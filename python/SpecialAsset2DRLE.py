#!/usr/bin/env python3
"""
2D RLE Asset Encoder for RetroPunks Special 1s
Generates optimized 2D RLE data for direct SVG rect rendering
Handles both pre-rendered (PNG) and dynamically rendered (2D RLE) specials
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

BASE_PATH = Path(os.getenv("BASE_DIR"))
TRAITS_DIR = BASE_PATH / "Special 1s"
OUTPUT_DIR = "output"
COMBINED_FILENAME = "special_asset.txt"

GROUP_NAME = "Special 1s"
CANVAS_WIDTH = 48
CANVAS_HEIGHT = 48
DEFAULT_LAYER_TYPE = 0
INCLUDE_NONE_TRAIT = False

# Ordered list of special characters
TRAIT_ORDER = [
    "Predator Blue",
    "Predator Green",
    "Predator Red",
    "Santa Claus",
    "Shadow Ninja",
    "The Devil",
    "The Portrait",
    "Ancient Mummy",
    "CyberApe",
    "Old Skeleton",
    "Pig",
    "Slenderman",
    "The Clown",
    "The Pirate",
    "The Witch",
    "The Wizard"
]

# First 7 are pre-rendered PNGs (stored separately, not in trait group)
PRE_RENDERED_SPECIALS = [
    "Predator Blue", "Predator Green", "Predator Red",
    "Santa Claus", "Shadow Ninja", "The Devil", "The Portrait"
]

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

def rgba_to_packed(r, g, b, a):
    """Pack RGBA into 0xRRGGBBAA format."""
    return (r << 24) | (g << 16) | (b << 8) | a

def load_png_as_rgba(filepath):
    """Load PNG and return 2D pixel array."""
    if not os.path.exists(filepath):
        print(f"  Warning: File not found {filepath}")
        return None
    
    img = Image.open(filepath).convert('RGBA')
    if img.size != (CANVAS_WIDTH, CANVAS_HEIGHT):
        img = img.resize((CANVAS_WIDTH, CANVAS_HEIGHT), Image.Resampling.NEAREST)
    
    pixels = []
    for y in range(CANVAS_HEIGHT):
        row = []
        for x in range(CANVAS_WIDTH):
            r, g, b, a = img.getpixel((x, y))
            row.append(0 if a == 0 else rgba_to_packed(r, g, b, a))
        pixels.append(row)
    
    return pixels

def compute_bounds(pixels):
    """Compute bounding box of non-transparent pixels."""
    x1, y1, x2, y2 = CANVAS_WIDTH, CANVAS_HEIGHT, -1, -1
    
    for y in range(CANVAS_HEIGHT):
        for x in range(CANVAS_WIDTH):
            color = pixels[y][x]
            if (color & 0xFF) > 0:  # alpha > 0
                x1 = min(x1, x)
                y1 = min(y1, y)
                x2 = max(x2, x)
                y2 = max(y2, y)
    
    return (0, 0, 0, 0) if x2 == -1 else (x1, y1, x2, y2)

def build_palette(pixels_list):
    """Build color palette from all non-None pixel arrays."""
    all_colors = []
    for pixels in pixels_list:
        if pixels:
            for row in pixels:
                all_colors.extend(row)
    
    palette = [color for color, _ in Counter(all_colors).most_common()]
    if len(palette) > 65535:
        raise ValueError("Too many colors in palette")
    
    return palette

def encode_2d_rle(pixels, palette_map, bounds, p_size):
    """
    Encode 2D RLE data optimized for SVG rect rendering.
    
    Format:
        [numRows:1]
        For each non-empty row:
            [rowY:1][numRuns:1]
            For each run:
                [x:1][length:1][paletteIndex:1-2]
    """
    x1, y1, x2, y2 = bounds
    
    if x1 > x2:
        return b""
    
    rows_data = []
    for y in range(y1, y2 + 1):
        row_runs = []
        x = x1
        
        while x <= x2:
            color = pixels[y][x]
            run_start = x
            
            # Find run length
            while x <= x2 and pixels[y][x] == color:
                x += 1
            
            run_length = x - run_start
            
            # Only store visible runs
            if (color & 0xFF) > 0:
                row_runs.append({
                    'x': run_start,
                    'length': run_length,
                    'color': color
                })
        
        if row_runs:
            rows_data.append({
                'y': y,
                'runs': row_runs
            })
    
    output = bytearray()
    output.append(len(rows_data))  # numRows
    
    for row in rows_data:
        output.append(row['y'])  # rowY
        output.append(len(row['runs']))  # numRuns
        
        for run in row['runs']:
            output.append(run['x'])
            output.append(run['length'])
            
            color_idx = palette_map[run['color']]
            if p_size == 2:
                output.extend(struct.pack('>H', color_idx))
            else:
                output.append(color_idx)
    
    return bytes(output)

def encode_special_group():
    """Encode Special 1s trait group with 2D RLE format."""
    if not os.path.exists(TRAITS_DIR):
        print(f"Error: Directory {TRAITS_DIR} not found.")
        return None
    
    traits_data = []
    
    # Load traits in order
    for trait_name in TRAIT_ORDER:
        if trait_name in PRE_RENDERED_SPECIALS:
            # Pre-rendered specials are stored as separate PNGs, blank in trait group
            traits_data.append({'name': trait_name, 'pixels': None})
        else:
            # Dynamically rendered specials use 2D RLE
            file_path = os.path.join(TRAITS_DIR, f"{trait_name}.png")
            pixels = load_png_as_rgba(file_path)
            if pixels is not None:
                traits_data.append({'name': trait_name, 'pixels': pixels})
    
    if not traits_data:
        print("Error: No valid traits found.")
        return None
    
    # Build palette
    palette = build_palette([t['pixels'] for t in traits_data if t['pixels'] is not None])
    p_size = 2 if len(palette) > 255 else 1
    palette_map = {color: idx for idx, color in enumerate(palette)}
    
    output = bytearray()
    
    # 1. Group Name
    name_bytes = GROUP_NAME.encode('utf-8')
    output.append(len(name_bytes))
    output.extend(name_bytes)
    
    # 2. Palette
    output.extend(struct.pack('>H', len(palette)))
    for color in palette:
        output.extend([
            (color >> 24) & 0xFF,  # R
            (color >> 16) & 0xFF,  # G
            (color >> 8) & 0xFF,   # B
            color & 0xFF           # A
        ])
    
    # 3. Metadata
    total_traits = len(traits_data) + (1 if INCLUDE_NONE_TRAIT else 0)
    output.append(p_size)  # paletteIndexByteSize
    output.append(total_traits)  # traitCount
    
    # 4. None trait (if included)
    if INCLUDE_NONE_TRAIT:
        output.extend([0, 0, 0, 0])  # x1, y1, x2, y2
        output.append(DEFAULT_LAYER_TYPE)
        none_name_bytes = "None".encode('utf-8')
        output.append(len(none_name_bytes))
        output.extend(none_name_bytes)
        output.append(0)  # numRows = 0
    
    # 5. Process traits in order
    for trait in traits_data:
        t_name_bytes = trait['name'].encode('utf-8')
        
        if trait['pixels'] is None:
            # Pre-rendered special: blank entry
            output.extend([0, 0, 0, 0])  # x1, y1, x2, y2
            output.append(DEFAULT_LAYER_TYPE)
            output.append(len(t_name_bytes))
            output.extend(t_name_bytes)
            output.append(0)  # numRows = 0 (empty 2D RLE)
            print(f"  [Pre-rendered] {trait['name']}")
        else:
            # Dynamic special: encode 2D RLE
            bounds = compute_bounds(trait['pixels'])
            rle_data = encode_2d_rle(trait['pixels'], palette_map, bounds, p_size)
            
            output.extend([bounds[0], bounds[1], bounds[2], bounds[3]])  # x1, y1, x2, y2
            output.append(DEFAULT_LAYER_TYPE)
            output.append(len(t_name_bytes))
            output.extend(t_name_bytes)
            output.extend(rle_data)
            print(f"  [2D RLE] {trait['name']}")
    
    return bytes(output)

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    print("=" * 70)
    print("2D RLE Asset Encoder for RetroPunks Special 1s")
    print("Gas-optimized format for direct SVG rect rendering")
    print("=" * 70)
    print(f"Processing: {GROUP_NAME}")
    
    data = encode_special_group()
    
    if data:
        hex_string = "0x" + data.hex()
        final_path = os.path.join(OUTPUT_DIR, COMBINED_FILENAME)
        with open(final_path, 'w') as f:
            f.write(f"{GROUP_NAME}: {hex_string}\n")
        print("=" * 70)
        print(f"✓ Success! Asset saved to: {final_path}")
        print(f"  Total size: {len(data)} bytes (no compression)")
        print("=" * 70)
    else:
        print("⊗ Failed: Check configuration or trait folder.")

if __name__ == '__main__':
    main()
