#!/usr/bin/env python3
"""
2D RLE Asset Encoder for RetroPunks Traits
Generates optimized 2D RLE data for direct SVG rect rendering (no bitmap, no PNG)
Gas optimized: no LZ77 compression, row-based RLE for efficient rect emission
"""
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
COMBINED_FILENAME = "traits_asset.txt"

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

# Sort suffixes by length descending
_SUFFIXES_SORTED = sorted(_SUFFIXES, key=len, reverse=True)

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

def strip_gender_prefix(name: str) -> str:
    """Remove 'Male ' or 'Female ' prefix."""
    if name.startswith("Male "):
        return name[5:]
    if name.startswith("Female "):
        return name[7:]
    return name

def enum_to_display_name(enum_name):
    return enum_name.replace("_Group", "").replace("_", " ")

def rgba_to_packed(r, g, b, a):
    """Pack RGBA into 0xRRGGBBAA format."""
    return (r << 24) | (g << 16) | (b << 8) | a

def normalize_trait_name(name: str) -> str:
    """Remove configured suffixes from trait names."""
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

def load_png_as_rgba(filepath):
    """Load PNG and return 2D pixel array."""
    img = Image.open(filepath).convert('RGBA')
    if img.size != (CANVAS_WIDTH, CANVAS_HEIGHT):
        img = img.resize((CANVAS_WIDTH, CANVAS_HEIGHT), Image.Resampling.NEAREST)
    
    pixels = []
    for y in range(CANVAS_HEIGHT):
        row = []
        for x in range(CANVAS_WIDTH):
            r, g, b, a = img.getpixel((x, y))
            # Keep full transparency as 0
            row.append(0 if a == 0 else rgba_to_packed(r, g, b, a))
        pixels.append(row)
    
    return pixels

def compute_bounds(pixels):
    """Compute bounding box of non-transparent pixels."""
    x1, y1, x2, y2 = CANVAS_WIDTH, CANVAS_HEIGHT, -1, -1
    
    for y in range(CANVAS_HEIGHT):
        for x in range(CANVAS_WIDTH):
            color = pixels[y][x]
            if (color & 0xFF) > 0:  # Check alpha > 0
                x1 = min(x1, x)
                y1 = min(y1, y)
                x2 = max(x2, x)
                y2 = max(y2, y)
    
    return (0, 0, 0, 0) if x2 == -1 else (x1, y1, x2, y2)

def encode_2d_rle(pixels, palette_map, bounds, p_size):
    """
    Encode 2D RLE data optimized for SVG rect rendering.
    
    Format:
        [numRows:1]
        For each non-empty row:
            [rowY:1][numRuns:1]
            For each run:
                [x:1][length:1][paletteIndex:1-2]
    
    This allows renderer to directly emit <rect> elements without bitmap.
    """
    x1, y1, x2, y2 = bounds
    
    # If empty bounds, return empty data
    if x1 > x2:
        return b""
    
    # Collect non-empty rows
    rows_data = []
    for y in range(y1, y2 + 1):
        row_runs = []
        x = x1
        
        while x <= x2:
            color = pixels[y][x]
            
            # Find run length for this color
            run_start = x
            while x <= x2 and pixels[y][x] == color:
                x += 1
            
            run_length = x - run_start
            
            # Only store non-transparent runs
            if (color & 0xFF) > 0:  # alpha > 0
                row_runs.append({
                    'x': run_start,
                    'length': run_length,
                    'color': color
                })
        
        # Only store rows that have visible pixels
        if row_runs:
            rows_data.append({
                'y': y,
                'runs': row_runs
            })
    
    # Encode to bytes
    output = bytearray()
    
    # Number of non-empty rows
    output.append(len(rows_data))
    
    # Encode each row
    for row in rows_data:
        output.append(row['y'])  # rowY
        output.append(len(row['runs']))  # numRuns
        
        for run in row['runs']:
            output.append(run['x'])  # x position
            output.append(run['length'])  # run length
            
            # Palette index
            color_idx = palette_map[run['color']]
            if p_size == 2:
                output.extend(struct.pack('>H', color_idx))
            else:
                output.append(color_idx)
    
    return bytes(output)

def encode_trait_group(trait_dir, display_name):
    """Encode entire trait group with 2D RLE format."""
    if not os.path.exists(trait_dir):
        return None
    
    png_files = sorted([f for f in os.listdir(trait_dir) if f.endswith('.png')])
    
    traits_data = []
    for f in png_files:
        raw_name = os.path.splitext(f)[0]
        cleaned_name = normalize_trait_name(raw_name)
        traits_data.append({
            'name': cleaned_name,
            'pixels': load_png_as_rgba(os.path.join(trait_dir, f))
        })
    
    # Build palette from all colors
    all_colors = []
    for t in traits_data:
        for row in t['pixels']:
            all_colors.extend(row)
    
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
        output.extend([
            (c >> 24) & 0xFF,  # R
            (c >> 16) & 0xFF,  # G
            (c >> 8) & 0xFF,   # B
            c & 0xFF           # A
        ])
    
    # 3. Settings
    output.append(p_size)  # paletteIndexByteSize
    output.append(len(traits_data) + (1 if INCLUDE_NONE_TRAIT else 0))  # traitCount
    
    # 4. "None" Trait (empty)
    if INCLUDE_NONE_TRAIT:
        # [x1:1][y1:1][x2:1][y2:1][layerType:1][nameLen:1] = 6 bytes
        output.extend([0, 0, 0, 0])  # x1, y1, x2, y2
        output.append(0)  # layerType
        output.append(4)  # nameLen
        output.extend("None".encode('utf-8'))
        # Empty 2D RLE data
        output.append(0)  # numRows = 0
    
    # 5. Real Traits
    for t in traits_data:
        bounds = compute_bounds(t['pixels'])
        rle_data = encode_2d_rle(t['pixels'], palette_map, bounds, p_size)
        
        # Trait header (6 bytes)
        output.extend([bounds[0], bounds[1], bounds[2], bounds[3]])  # x1, y1, x2, y2
        output.append(0)  # layerType
        
        b_tname = t['name'].encode('utf-8')
        output.append(len(b_tname))  # nameLen
        output.extend(b_tname)
        
        # 2D RLE data
        output.extend(rle_data)
    
    return bytes(output)

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    combined_output = []
    
    print("=" * 70)
    print("2D RLE Asset Encoder for RetroPunks")
    print("Gas-optimized format for direct SVG rect rendering")
    print("=" * 70)
    
    for enum_name in ENUM_ORDER:
        folder_display_name = enum_to_display_name(enum_name)
        trait_group_name = strip_gender_prefix(folder_display_name)
        trait_dir = os.path.join(TRAITS_DIR, folder_display_name)
        
        print(f"Processing: {folder_display_name}", end=" ")
        print(f"(encoding as '{trait_group_name}')...", end=" ")
        
        data = encode_trait_group(trait_dir, trait_group_name)
        if data:
            combined_output.append(f"{enum_name}: 0x{data.hex()}")
            print(f"✓ DONE ({len(data)} bytes, no compression)")
        else:
            print("⊗ SKIPPED (not found)")
    
    # Write output
    output_file = os.path.join(OUTPUT_DIR, COMBINED_FILENAME)
    with open(output_file, 'w') as f:
        f.write("\n\n".join(combined_output))
    
    print("=" * 70)
    print(f"Output written to: {output_file}")
    print("=" * 70)

if __name__ == '__main__':
    main()
