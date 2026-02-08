#!/usr/bin/env python3
import os
import struct
from PIL import Image
from collections import Counter
from dotenv import load_dotenv
from pathlib import Path

load_dotenv()

# ============================================================================
# CONFIGURATION
# ============================================================================

BASE_PATH = Path(os.getenv("BASE_DIR", "."))
TRAITS_DIR = BASE_PATH
OUTPUT_DIR = "output"
COMBINED_FILENAME = "combined_traits_hex.txt"

CANVAS_WIDTH = 48
CANVAS_HEIGHT = 48

INCLUDE_NONE_TRAIT = True

ENUM_ORDER = [
    "Male_Skin_Group", "Male_Eyes_Group", "Male_Face_Group", "Male_Chain_Group", 
    "Male_Earring_Group", "Male_Facial_Hair_Group", "Male_Mask_Group", 
    "Male_Scarf_Group", "Male_Hair_Group", "Male_Hat_Hair_Group", 
    "Male_Headwear_Group", "Male_Eye_Wear_Group", "Female_Skin_Group", 
    "Female_Eyes_Group", "Female_Face_Group", "Female_Chain_Group", 
    "Female_Earring_Group", "Female_Mask_Group", "Female_Scarf_Group", 
    "Female_Hair_Group", "Female_Hat_Hair_Group", "Female_Headwear_Group", 
    "Female_Eye_Wear_Group", "Mouth_Group", "Filler_Traits_Group"
]

_SUFFIXES = [
    " 1", " 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9", " 10", " 11", " 12",
    " Left", " Right",
    " Black", " Brown", " Blonde", " Ginger", " Light", " Dark", " Shadow", " Fade",
    " Blue", " Green", " Orange", " Pink", " Purple", " Red", " Turquoise",
    " White", " Yellow", " Sky Blue", " Hot Pink", " Neon Blue", " Neon Green",
    " Neon Purple", " Neon Red", " Grey", " Navy", " Burgundy", " Beige", " Golden",
    " Black Hat", " Brown Hat", " Blonde Hat", " Ginger Hat", " Blue Hat",
    " Green Hat", " Orange Hat", " Pink Hat", " Purple Hat", " Red Hat",
    " Turquoise Hat", " White Hat", " Yellow Hat"
]

# Sort suffixes by length descending so longer suffixes (e.g. " Black Hat") are matched before shorter ones (" Black")
_SUFFIXES_SORTED = sorted(_SUFFIXES, key=len, reverse=True)

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

def strip_gender_prefix(name: str) -> str:
    """
    Removes "Male " or "Female " from the start of the string.
    """
    if name.startswith("Male "):
        return name[5:]
    if name.startswith("Female "):
        return name[7:]
    return name

def enum_to_display_name(enum_name):
    return enum_name.replace("_Group", "").replace("_", " ")

def rgba_to_packed(r, g, b, a):
    return (r << 24) | (g << 16) | (b << 8) | a

def normalize_trait_name(name: str) -> str:
    """
    Remove any of the configured suffixes if they appear at the end of the name.
    Repeats removal until no listed suffix matches the end.
    Example: "Cloak Blue" -> "Cloak"
    """
    # operate on the raw string
    current = name
    while True:
        changed = False
        for s in _SUFFIXES_SORTED:
            if current.endswith(s):
                # strip the suffix
                current = current[: -len(s)].rstrip()
                changed = True
                break  # restart checking from longest suffixes again
        if not changed:
            break
    return current

def load_png_as_rgba(filepath):
    img = Image.open(filepath).convert('RGBA')
    if img.size != (CANVAS_WIDTH, CANVAS_HEIGHT):
        img = img.resize((CANVAS_WIDTH, CANVAS_HEIGHT), Image.Resampling.NEAREST)
    pixels = []
    for y in range(CANVAS_HEIGHT):
        for x in range(CANVAS_WIDTH):
            r, g, b, a = img.getpixel((x, y))
            # Keep full transparency as 0
            pixels.append(0 if a == 0 else rgba_to_packed(r, g, b, a))
    return pixels

def compute_bounds(pixels, width, height):
    x1, y1, x2, y2 = width, height, -1, -1
    for y in range(height):
        for x in range(width):
            color = pixels[y * width + x]
            if (color & 0xFF) > 0: # Check alpha > 0
                x1, y1 = min(x1, x), min(y1, y)
                x2, y2 = max(x2, x), max(y2, y)
    return (0, 0, 0, 0) if x2 == -1 else (x1, y1, x2, y2)

def encode_rle(pixels, palette_map, bounds, width, p_size):
    x1, y1, x2, y2 = bounds
    rle_data = bytearray()
    
    # We MUST encode every pixel in the bounding box to keep the pointer correct
    flat_pixels = []
    for y in range(y1, y2 + 1):
        for x in range(x1, x2 + 1):
            flat_pixels.append(pixels[y * width + x])
            
    if not flat_pixels: return b"", 0

    pixel_count = len(flat_pixels)
    i = 0
    while i < pixel_count:
        color = flat_pixels[i]
        run_len = 0
        # Group identical colors up to 255
        while i < pixel_count and flat_pixels[i] == color and run_len < 255:
            run_len += 1
            i += 1
        
        rle_data.append(run_len)
        color_idx = palette_map[color]
        if p_size == 2:
            rle_data.extend(struct.pack('>H', color_idx))
        else:
            rle_data.append(color_idx)
            
    return bytes(rle_data), pixel_count

def encode_trait_group(trait_dir, display_name):
    if not os.path.exists(trait_dir): return None
    
    png_files = sorted([f for f in os.listdir(trait_dir) if f.endswith('.png')])
    traits_data = []
    for f in png_files:
        raw_name = os.path.splitext(f)[0]
        cleaned_name = normalize_trait_name(raw_name)
        traits_data.append({
            'name': cleaned_name,
            'pixels': load_png_as_rgba(os.path.join(trait_dir, f))
        })

    all_colors = []
    for t in traits_data: all_colors.extend(t['pixels'])
    palette = [c for c, _ in Counter(all_colors).most_common()]
    palette_map = {color: idx for idx, color in enumerate(palette)}
    p_size = 2 if len(palette) > 255 else 1

    output = bytearray()
    
    # 1. Group Name
    b_name = display_name.encode('utf-8')
    output.append(len(b_name))
    output.extend(b_name)
    
    # 2. Palette
    output.extend(struct.pack('>H', len(palette)))
    for c in palette:
        output.extend([(c >> 24) & 0xFF, (c >> 16) & 0xFF, (c >> 8) & 0xFF, c & 0xFF])
        
    # 3. Settings
    output.append(p_size)
    output.append(len(traits_data) + (1 if INCLUDE_NONE_TRAIT else 0))

    # 4. "None" Trait (FIXED: Exactly 8 bytes before the name)
    if INCLUDE_NONE_TRAIT:
        output.extend(struct.pack('>H', 0)) # PixelCount (2)
        output.extend([0, 0, 0, 0])         # x1, y1, x2, y2 (4)
        output.append(0)                   # layerType (1)
        output.append(4)                   # nameLen (1) 
        # Total = 8 bytes. Solidity index += 8 lands perfectly here:
        output.extend("None".encode('utf-8'))

    # 5. Real Traits
    for t in traits_data:
        bounds = compute_bounds(t['pixels'], CANVAS_WIDTH, CANVAS_HEIGHT)
        pixel_data, pixel_count = encode_rle(t['pixels'], palette_map, bounds, CANVAS_WIDTH, p_size)

        # Header (8 bytes)
        output.extend(struct.pack('>H', pixel_count)) # 2
        output.extend([bounds[0], bounds[1], bounds[2], bounds[3]]) # 4
        output.append(0) # layerType (1)
        
        b_tname = t['name'].encode('utf-8')
        output.append(len(b_tname)) # nameLen (1)
        # Total = 8 bytes
        
        output.extend(b_tname)
        output.extend(pixel_data)

    return bytes(output)

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    combined_output = []

    for enum_name in ENUM_ORDER:
        # Original folder name for file lookup
        folder_display_name = enum_to_display_name(enum_name)
        
        # New stripped name for the actual binary data / metadata
        trait_group_name = strip_gender_prefix(folder_display_name)
        
        trait_dir = os.path.join(TRAITS_DIR, folder_display_name)
        print(f"Processing: {folder_display_name} (Encoding as '{trait_group_name}')...", end=" ")
        
        # Pass the stripped name to the encoder
        data = encode_trait_group(trait_dir, trait_group_name)
        if data:
            combined_output.append(f"{folder_display_name}: 0x{data.hex()}")
            print(f"DONE ({len(data)} bytes)")
        else:
            print("SKIPPED (Not found)")

    with open(os.path.join(OUTPUT_DIR, COMBINED_FILENAME), 'w') as f:
        f.write("\n\n".join(combined_output))

if __name__ == '__main__':
    main()
