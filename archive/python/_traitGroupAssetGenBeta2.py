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

BASE_PATH = Path(os.getenv("BASE_DIR"))
TRAITS_DIR = BASE_PATH
OUTPUT_DIR = "output"
COMBINED_FILENAME = "combined_traits_hex.txt"

CANVAS_WIDTH = 48
CANVAS_HEIGHT = 48
MAGIC_TRANSPARENT = 0x5f5d6eff
DEFAULT_LAYER_TYPE = 0
INCLUDE_NONE_TRAIT = True

# THE EXACT ORDER FOR THE TXT FILE
ENUM_ORDER = [
    "Special_1s_Group", "Background_Group", "Male_Skin_Group", "Male_Eyes_Group",
    "Male_Face_Group", "Male_Chain_Group", "Male_Earring_Group", "Male_Facial_Hair_Group",
    "Male_Mask_Group", "Male_Scarf_Group", "Male_Hair_Group", "Male_Hat_Hair_Group",
    "Male_Headwear_Group", "Male_Eye_Wear_Group", "Female_Skin_Group", "Female_Eyes_Group",
    "Female_Face_Group", "Female_Chain_Group", "Female_Earring_Group", "Female_Mask_Group",
    "Female_Scarf_Group", "Female_Hair_Group", "Female_Hat_Hair_Group", "Female_Headwear_Group",
    "Female_Eye_Wear_Group", "Mouth_Group", "Filler_Traits_Group"
]

# ============================================================================
# SUFFIX NORMALIZATION (REMOVE THESE IF THEY APPEAR AT THE END OF A NAME)
# ============================================================================

_SUFFIXES = [
    " 1", " 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9", " 10", " 11", " 12",
    " Left", " Right",
    " Black", " Brown", " Blonde", " Ginger", " Light", " Dark", " Shadow", " Fade",
    " Blue", " Green", " Orange", " Pink", " Purple", " Red", " Turquoise",
    " White", " Yellow", " Sky Blue", " Hot Pink", " Neon Blue", " Neon Green",
    " Neon Purple", " Neon Red", " Grey", " Navy", " Burgundy", " Beige",
    " Black Hat", " Brown Hat", " Blonde Hat", " Ginger Hat", " Blue Hat",
    " Green Hat", " Orange Hat", " Pink Hat", " Purple Hat", " Red Hat",
    " Turquoise Hat", " White Hat", " Yellow Hat"
]

# Sort by length descending so longer suffixes (e.g. " Black Hat") match before " Black"
_SUFFIXES_SORTED = sorted(_SUFFIXES, key=len, reverse=True)

def normalize_trait_name(name: str) -> str:
    """
    Remove any of the configured suffixes if they appear at the end of the name.
    Repeats removal until no listed suffix remains.
    NOTE: This matching is case-sensitive and only strips when the suffix
    appears exactly at the end of the string (per your request).
    Example: "Cloak Blue" -> "Cloak"
    """
    current = name
    while True:
        changed = False
        for s in _SUFFIXES_SORTED:
            if current.endswith(s):
                current = current[: -len(s)].rstrip()
                changed = True
                break
        if not changed:
            break
    return current

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

def enum_to_display_name(enum_name):
    """Converts 'Male_Skin_Group' to 'Male Skin' to match folder names."""
    return enum_name.replace("_Group", "").replace("_", " ")

def rgba_to_packed(r, g, b, a):
    return (r << 24) | (g << 16) | (b << 8) | a

def load_png_as_rgba(filepath):
    img = Image.open(filepath).convert('RGBA')
    if img.size != (CANVAS_WIDTH, CANVAS_HEIGHT):
        img = img.resize((CANVAS_WIDTH, CANVAS_HEIGHT), Image.Resampling.NEAREST)
    pixels = []
    for y in range(CANVAS_HEIGHT):
        for x in range(CANVAS_WIDTH):
            r, g, b, a = img.getpixel((x, y))
            pixels.append(0 if a == 0 else rgba_to_packed(r, g, b, a))
    return pixels

def compute_bounds(pixels, width, height):
    x1, y1, x2, y2 = width, height, -1, -1
    for y in range(height):
        for x in range(width):
            color = pixels[y * width + x]
            if (color & 0xFF) > 0 and color != MAGIC_TRANSPARENT:
                x1, y1 = min(x1, x), min(y1, y)
                x2, y2 = max(x2, x), max(y2, y)
    return (0, 0, 0, 0) if x2 == -1 else (x1, y1, x2, y2)

def verify_trait(name, pixels, bounds, rle_pixel_count):
    x1, y1, x2, y2 = bounds
    expected_area = (x2 - x1 + 1) * (y2 - y1 + 1)
    if rle_pixel_count != expected_area:
        raise ValueError(f"FATAL: {name} RLE count ({rle_pixel_count}) != Box Area ({expected_area})")

def build_palette(pixels_list):
    all_colors = []
    for pixels in pixels_list: all_colors.extend(pixels)
    palette = [color for color, count in Counter(all_colors).most_common()]
    if len(palette) > 65535: raise ValueError("Too many colors")
    return palette

def encode_rle(pixels, palette, bounds, width):
    x1, y1, x2, y2 = bounds
    index_bytes = 2 if len(palette) > 255 else 1
    palette_map = {color: idx for idx, color in enumerate(palette)}
    rle_data, pixel_count, current_run, current_color = bytearray(), 0, [], None

    for y in range(y1, y2 + 1):
        for x in range(x1, x2 + 1):
            color = pixels[y * width + x]
            if color == current_color:
                current_run.append(color)
            else:
                if current_run:
                    run_len, color_idx = len(current_run), palette_map[current_color]
                    while run_len > 255:
                        rle_data.append(255)
                        rle_data.extend(struct.pack('>H', color_idx) if index_bytes == 2 else [color_idx])
                        pixel_count += 255
                        run_len -= 255
                    if run_len > 0:
                        rle_data.append(run_len)
                        rle_data.extend(struct.pack('>H', color_idx) if index_bytes == 2 else [color_idx])
                        pixel_count += run_len
                current_color, current_run = color, [color]

    if current_run:
        run_len, color_idx = len(current_run), palette_map[current_color]
        while run_len > 255:
            rle_data.append(255)
            rle_data.extend(struct.pack('>H', color_idx) if index_bytes == 2 else [color_idx])
            pixel_count += 255
            run_len -= 255
        if run_len > 0:
            rle_data.append(run_len)
            rle_data.extend(struct.pack('>H', color_idx) if index_bytes == 2 else [color_idx])
            pixel_count += run_len
    return bytes(rle_data), pixel_count

def encode_trait_group(trait_dir, display_name):
    if not os.path.exists(trait_dir):
        return None
    
    png_files = sorted([f for f in os.listdir(trait_dir) if f.endswith('.png')])
    if not png_files: return None

    traits_data = []
    for png_file in png_files:
        raw_name = os.path.splitext(png_file)[0]
        cleaned_name = normalize_trait_name(raw_name)
        traits_data.append({
            'name': cleaned_name,
            'pixels': load_png_as_rgba(os.path.join(trait_dir, png_file))
        })

    palette = build_palette([t['pixels'] for t in traits_data])
    index_bytes = 2 if len(palette) > 255 else 1
    output = bytearray()

    name_bytes = display_name.encode('utf-8')
    output.append(len(name_bytes))
    output.extend(name_bytes)
    output.extend(struct.pack('>H', len(palette)))
    for color in palette:
        output.extend([(color >> 24) & 0xFF, (color >> 16) & 0xFF, (color >> 8) & 0xFF, color & 0xFF])

    total_traits = len(traits_data) + (1 if INCLUDE_NONE_TRAIT else 0)
    output.append(index_bytes)
    output.append(total_traits)

    if INCLUDE_NONE_TRAIT:
        output.extend(struct.pack('>H', 0)) # pixel_count
        output.extend([0, 0, 0, 0, 0])      # bounds + layerType
        none_name = "None".encode('utf-8')
        output.append(len(none_name))
        output.extend(none_name)

    for trait in traits_data:
        bounds = compute_bounds(trait['pixels'], CANVAS_WIDTH, CANVAS_HEIGHT)
        rle_data, pixel_count = encode_rle(trait['pixels'], palette, bounds, CANVAS_WIDTH)
        verify_trait(trait['name'], trait['pixels'], bounds, pixel_count)

        output.extend(struct.pack('>H', pixel_count))
        output.extend([bounds[0], bounds[1], bounds[2], bounds[3], DEFAULT_LAYER_TYPE])
        t_name = trait['name'].encode('utf-8')
        output.append(len(t_name))
        output.extend(t_name)
        output.extend(rle_data)
    return bytes(output)

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    combined_output = []

    print(f"Starting ordered encoding for {len(ENUM_ORDER)} groups...")

    for enum_name in ENUM_ORDER:
        display_name = enum_to_display_name(enum_name)
        trait_dir = os.path.join(TRAITS_DIR, display_name)
        
        print(f"Processing: {display_name}...", end=" ")
        data = encode_trait_group(trait_dir, display_name)

        if data:
            hex_string = "0x" + data.hex()
            combined_output.append(f"{display_name}: {hex_string}")
            print(f"DONE ({len(data)} bytes)")
        else:
            combined_output.append(f"{display_name}: MISSING FOLDER")
            print("SKIPPED (Folder not found)")

    final_path = os.path.join(OUTPUT_DIR, COMBINED_FILENAME)
    with open(final_path, 'w') as f:
        f.write("\n\n".join(combined_output))
        f.write("\n")

    print(f"\n✓ Success! Ordered hex assets saved to: {final_path}")

if __name__ == '__main__':
    main()
