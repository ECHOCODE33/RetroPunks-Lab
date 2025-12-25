#!/usr/bin/env python3
"""
RetroPunks Trait Asset Generator

Generates encoded trait data from PNG images for on-chain storage.
"""

import os
import struct
from PIL import Image
from collections import Counter
import json

# ============================================================================
# CONFIGURATION
# ============================================================================

TRAITS_DIR = "/Users/mani/Downloads/RPNKSLab/traitsColor"
OUTPUT_DIR = "output"
DEBUG_DIR = "output/debug"

CANVAS_WIDTH = 48
CANVAS_HEIGHT = 48
MAGIC_TRANSPARENT = 0x5f5d6eff
DEFAULT_LAYER_TYPE = 0

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

def rgba_to_packed(r, g, b, a):
    return (r << 24) | (g << 16) | (b << 8) | a

def packed_to_rgba(packed):
    """Unpack RRGGBBAA integer to (r, g, b, a) tuple."""
    return (
        (packed >> 24) & 0xFF,
        (packed >> 16) & 0xFF,
        (packed >> 8) & 0xFF,
        packed & 0xFF
    )

def load_png_as_rgba(filepath):
    img = Image.open(filepath).convert('RGBA')
    
    if img.size != (CANVAS_WIDTH, CANVAS_HEIGHT):
        print(f"Warning: {filepath} is {img.size}, resizing to {CANVAS_WIDTH}x{CANVAS_HEIGHT}")
        img = img.resize((CANVAS_WIDTH, CANVAS_HEIGHT), Image.Resampling.NEAREST)
    
    pixels = []
    for y in range(CANVAS_HEIGHT):
        for x in range(CANVAS_WIDTH):
            r, g, b, a = img.getpixel((x, y))
            pixels.append(rgba_to_packed(r, g, b, a))
    
    return pixels

def compute_bounds(pixels, width, height):
    x1, y1 = width, height
    x2, y2 = 0, 0
    
    for y in range(height):
        for x in range(width):
            color = pixels[y * width + x]
            alpha = color & 0xFF
            
            if alpha > 0 and color != MAGIC_TRANSPARENT:
                x1 = min(x1, x)
                y1 = min(y1, y)
                x2 = max(x2, x)
                y2 = max(y2, y)
    
    if x1 > x2:
        return (0, 0, width - 1, height - 1)
    
    return (x1, y1, x2, y2)

def build_palette(pixels_list):
    all_colors = []
    for pixels in pixels_list:
        all_colors.extend(pixels)
    
    color_counts = Counter(all_colors)
    palette = [color for color, count in color_counts.most_common()]
    
    if len(palette) > 65535:
        raise ValueError(f"Too many colors: {len(palette)} (max 65535)")
    
    return palette

def encode_rle(pixels, palette, bounds, width):
    x1, y1, x2, y2 = bounds
    index_bytes = 2 if len(palette) > 255 else 1
    
    palette_map = {color: idx for idx, color in enumerate(palette)}
    
    rle_data = bytearray()
    pixel_count = 0
    current_run = []
    current_color = None
    
    for y in range(y1, y2 + 1):
        for x in range(x1, x2 + 1):
            color = pixels[y * width + x]
            
            if color == current_color:
                current_run.append(color)
            else:
                if current_run:
                    run_length = len(current_run)
                    color_idx = palette_map[current_color]
                    
                    while run_length > 255:
                        rle_data.append(255)
                        if index_bytes == 1:
                            rle_data.append(color_idx)
                        else:
                            # CRITICAL FIX: Use Big Endian (>H) for consistency
                            rle_data.extend(struct.pack('>H', color_idx))
                        pixel_count += 255
                        run_length -= 255
                    
                    if run_length > 0:
                        rle_data.append(run_length)
                        if index_bytes == 1:
                            rle_data.append(color_idx)
                        else:
                            # CRITICAL FIX: Use Big Endian (>H) for consistency
                            rle_data.extend(struct.pack('>H', color_idx))
                        pixel_count += run_length
                
                current_color = color
                current_run = [color]
    
    if current_run:
        run_length = len(current_run)
        color_idx = palette_map[current_color]
        
        while run_length > 255:
            rle_data.append(255)
            if index_bytes == 1:
                rle_data.append(color_idx)
            else:
                # CRITICAL FIX: Use Big Endian (>H) for consistency
                rle_data.extend(struct.pack('>H', color_idx))
            pixel_count += 255
            run_length -= 255
        
        if run_length > 0:
            rle_data.append(run_length)
            if index_bytes == 1:
                rle_data.append(color_idx)
            else:
                # CRITICAL FIX: Use Big Endian (>H) for consistency
                rle_data.extend(struct.pack('>H', color_idx))
            pixel_count += run_length
    
    return bytes(rle_data), pixel_count

def save_debug_info(group_name, traits_data, palette, output_dir):
    debug_info = {
        "group_name": group_name,
        "palette_size": len(palette),
        "palette": [
            {
                "index": idx,
                "color": f"#{(c>>24):02x}{(c>>16)&0xff:02x}{(c>>8)&0xff:02x}{c&0xff:02x}",
                "rgba": packed_to_rgba(c),
                "is_magic": c == MAGIC_TRANSPARENT
            }
            for idx, c in enumerate(palette)
        ],
        "traits": [
            {
                "name": t['name'],
                "pixel_count": t.get('pixel_count', 0),
                "bounds": t.get('bounds', [0, 0, 0, 0]),
                "rle_size": t.get('rle_size', 0)
            }
            for t in traits_data
        ]
    }
    
    output_path = os.path.join(output_dir, f"{group_name}.json")
    with open(output_path, 'w') as f:
        json.dump(debug_info, f, indent=2)
    
    print(f"Debug info: {output_path}")

def encode_trait_group(trait_dir, save_debug=True):
    group_name = os.path.basename(trait_dir)
    print(f"\nProcessing trait group: {group_name}")
    
    png_files = sorted([f for f in os.listdir(trait_dir) if f.endswith('.png')])
    if not png_files:
        print(f"Warning: No PNG files found in {trait_dir}")
        return None
    
    print(f"Found {len(png_files)} traits")
    
    traits_data = []
    for png_file in png_files:
        filepath = os.path.join(trait_dir, png_file)
        pixels = load_png_as_rgba(filepath)
        trait_name = os.path.splitext(png_file)[0]
        traits_data.append({
            'name': trait_name,
            'pixels': pixels
        })
    
    print("Building palette...")
    all_pixels = [t['pixels'] for t in traits_data]
    palette = build_palette(all_pixels)
    print(f"Palette size: {len(palette)} colors")
    
    if MAGIC_TRANSPARENT in palette:
        print(f"  ✓ Magic transparent color found in palette")
    
    index_bytes = 2 if len(palette) > 255 else 1
    print(f"Index size: {index_bytes} byte(s)")
    
    output = bytearray()
    
    # Group Name
    group_name_bytes = group_name.encode('utf-8')
    output.append(len(group_name_bytes))
    output.extend(group_name_bytes)
    
    # Palette Size: CRITICAL FIX (>H for Big Endian)
    output.extend(struct.pack('>H', len(palette)))
    
    # Palette Colors
    for color in palette:
        r = (color >> 24) & 0xFF
        g = (color >> 16) & 0xFF
        b = (color >> 8) & 0xFF
        a = color & 0xFF
        output.extend([r, g, b, a])
    
    # Index Byte Size & Trait Count
    output.append(index_bytes)
    output.append(len(traits_data))
    
    print("Encoding traits...")
    for idx, trait in enumerate(traits_data):
        print(f"  [{idx+1}/{len(traits_data)}] {trait['name']}")
        
        bounds = compute_bounds(trait['pixels'], CANVAS_WIDTH, CANVAS_HEIGHT)
        x1, y1, x2, y2 = bounds
        
        rle_data, pixel_count = encode_rle(
            trait['pixels'], 
            palette, 
            bounds, 
            CANVAS_WIDTH
        )
        
        trait['pixel_count'] = pixel_count
        trait['bounds'] = [x1, y1, x2, y2]
        trait['rle_size'] = len(rle_data)
        
        # Trait Pixel Count: CRITICAL FIX (>H for Big Endian)
        output.extend(struct.pack('>H', pixel_count))
        
        # Trait Bounds & Header
        output.append(x1)
        output.append(y1)
        output.append(x2)
        output.append(y2)
        output.append(DEFAULT_LAYER_TYPE)
        
        # Trait Name
        name_bytes = trait['name'].encode('utf-8')
        output.append(len(name_bytes))
        output.extend(name_bytes)
        
        # RLE Data
        output.extend(rle_data)
        
        original_size = pixel_count * 4
        compressed_size = len(rle_data)
        ratio = original_size / compressed_size if compressed_size > 0 else 0
        print(f"    Pixels: {pixel_count}, RLE: {compressed_size} bytes, Ratio: {ratio:.1f}x")
    
    if save_debug:
        save_debug_info(group_name, traits_data, palette, DEBUG_DIR)
    
    print(f"Total size: {len(output)} bytes")
    return bytes(output)

def compress_fastlz(data):
    try:
        import fastlz
        return fastlz.compress(data)
    except ImportError:
        print("Warning: fastlz not available, returning uncompressed data")
        return data

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    os.makedirs(DEBUG_DIR, exist_ok=True)
    
    trait_groups = [d for d in os.listdir(TRAITS_DIR) 
                   if os.path.isdir(os.path.join(TRAITS_DIR, d))]
    
    if not trait_groups:
        print(f"Error: No trait group directories found in {TRAITS_DIR}")
        return
    
    print(f"Found {len(trait_groups)} trait groups")
    
    for group_name in sorted(trait_groups):
        trait_dir = os.path.join(TRAITS_DIR, group_name)
        
        data = encode_trait_group(trait_dir, save_debug=True)
        if data is None:
            continue
        
        print(f"Compressing...")
        compressed = compress_fastlz(data)
        compression_ratio = len(data) / len(compressed) if len(compressed) > 0 else 0
        print(f"Compressed: {len(data)} → {len(compressed)} bytes ({compression_ratio:.1f}x)")
        
        output_path = os.path.join(OUTPUT_DIR, f"{group_name}.bin")
        with open(output_path, 'wb') as f:
            f.write(compressed)
        print(f"Written: {output_path}\n")
    
    print("Done! Check output/debug/ for human-readable JSON files")

if __name__ == '__main__':
    main()