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
TRAITS_DIR = BASE_PATH / "Special 1s"
OUTPUT_DIR = "output"
COMBINED_FILENAME = "special_traits_hex.txt"

GROUP_NAME = "Special 1s"
CANVAS_WIDTH = 48
CANVAS_HEIGHT = 48
MAGIC_TRANSPARENT = 0x5f5d6eff
DEFAULT_LAYER_TYPE = 0
INCLUDE_NONE_TRAIT = False 

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

PRE_RENDERED_SPECIALS = [
    "Predator Blue", "Predator Green", "Predator Red",
    "Santa Claus", "Shadow Ninja", "The Devil", "The Portrait"
]

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

def rgba_to_packed(r, g, b, a):
    return (r << 24) | (g << 16) | (b << 8) | a

def load_png_as_rgba(filepath):
    if not os.path.exists(filepath):
        print(f"  Warning: File not found {filepath}")
        return None
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

def build_palette(pixels_list):
    all_colors = []
    for pixels in pixels_list:
        if pixels: all_colors.extend(pixels)
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

def encode_special_group():
    if not os.path.exists(TRAITS_DIR):
        print(f"Error: Directory {TRAITS_DIR} not found.")
        return None
    
    traits_data = []
    # // CHANGED: Iterate based on TRAIT_ORDER instead of directory listing
    for trait_name in TRAIT_ORDER:
        if trait_name in PRE_RENDERED_SPECIALS:
            traits_data.append({'name': trait_name, 'pixels': None})
        else:
            file_path = os.path.join(TRAITS_DIR, f"{trait_name}.png")
            pixels = load_png_as_rgba(file_path)
            if pixels is not None:
                traits_data.append({'name': trait_name, 'pixels': pixels})
    
    if not traits_data:
        print("Error: No valid traits found matching TRAIT_ORDER.")
        return None

    palette = build_palette([t['pixels'] for t in traits_data if t['pixels'] is not None])
    index_bytes = 2 if len(palette) > 255 else 1
    output = bytearray()
    
    # 1. Group Name
    name_bytes = GROUP_NAME.encode('utf-8')
    output.append(len(name_bytes))
    output.extend(name_bytes)
    
    # 2. Palette
    output.extend(struct.pack('>H', len(palette)))
    for color in palette:
        output.extend([(color >> 24) & 0xFF, (color >> 16) & 0xFF, (color >> 8) & 0xFF, color & 0xFF])
    
    # 3. Metadata
    total_traits = len(traits_data) + (1 if INCLUDE_NONE_TRAIT else 0)
    output.append(index_bytes)
    output.append(total_traits)
    
    if INCLUDE_NONE_TRAIT:
        output.extend(struct.pack('>H', 0))
        output.extend([0, 0, 0, 0, 0])
        none_name = "None".encode('utf-8')
        output.append(len(none_name))
        output.extend(none_name)

    # 4. Process Traits in the specific order
    for trait in traits_data:
        t_name_bytes = trait['name'].encode('utf-8')
        
        if trait['pixels'] is None:
            output.extend(struct.pack('>H', 0))
            output.extend([0, 0, 0, 0, DEFAULT_LAYER_TYPE])
            output.append(len(t_name_bytes))
            output.extend(t_name_bytes)
            print(f"  [Blanked] {trait['name']}")
        else:
            bounds = compute_bounds(trait['pixels'], CANVAS_WIDTH, CANVAS_HEIGHT)
            rle_data, pixel_count = encode_rle(trait['pixels'], palette, bounds, CANVAS_WIDTH)
            output.extend(struct.pack('>H', pixel_count))
            output.extend([bounds[0], bounds[1], bounds[2], bounds[3], DEFAULT_LAYER_TYPE])
            output.append(len(t_name_bytes))
            output.extend(t_name_bytes)
            output.extend(rle_data)
            print(f"  [Encoded] {trait['name']} ({pixel_count}px)")

    return bytes(output)

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    print(f"Generating Ordered Hex for: {GROUP_NAME}")
    data = encode_special_group()
    
    if data:
        hex_string = "0x" + data.hex()
        final_path = os.path.join(OUTPUT_DIR, COMBINED_FILENAME)
        with open(final_path, 'w') as f:
            f.write(f"{GROUP_NAME}: {hex_string}\n")
        print(f"\n✓ Success! Ordered Asset saved to: {final_path}")
    else:
        print("\nFailed: Check configuration or trait folder.")

if __name__ == '__main__':
    main()