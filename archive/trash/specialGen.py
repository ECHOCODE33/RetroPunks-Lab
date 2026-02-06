#!/usr/bin/env python3
"""
RetroPunks Special 1-of-1 Character Generator

Generates assets for unique special characters with manual customization support.
Some specials are pre-rendered PNGs, others are generated like normal traits.

Usage:
    python special_1s_generator.py

Customization:
    Edit CUSTOM_SPECIALS dictionary below to add/modify special traits.
    Each entry can specify custom attributes or use auto-generation.
"""

import os
import struct
from PIL import Image
from collections import Counter
import base64

# ============================================================================
# CONFIGURATION
# ============================================================================

SPECIALS_DIR = "traits/special 1s"  # Directory containing special character PNGs
OUTPUT_DIR = "output"
CANVAS_WIDTH = 48
CANVAS_HEIGHT = 48
MAGIC_TRANSPARENT = 0x5f5d6eff

# ============================================================================
# CUSTOM SPECIAL DEFINITIONS
# ============================================================================
# 
# To customize a special character, add an entry here with the trait name
# (filename without .png) and custom attributes.
#
# Copy and paste this template for each special:
#
# "TraitName": {
#     "layer_type": 0,              # 0=normal, higher values for special rendering
#     "pre_rendered": False,        # True=store as base64 PNG, False=encode as trait
#     "description": "Custom description",
#     # Add any other custom metadata here
# },
#
# Example:

CUSTOM_SPECIALS = {
    "Santa Claus": {
        "layer_type": 0,
        "pre_rendered": True,  # This one is stored as PNG
        "description": "Ho ho ho!",
    },
    "The Witch": {
        "layer_type": 0,
        "pre_rendered": False,  # This one is encoded like a normal trait
        "description": "Mystical sorceress",
    },
    # Add more custom specials here by copying the template above
}

# ============================================================================
# PRE-RENDERED SPECIALS
# ============================================================================
#
# These specials are stored as base64-encoded PNGs rather than trait data.
# The contract loads them with loadAssetOriginal() and renders as <img> tags.
#
# Pre-rendered specials have special IDs offset by 100:
# - Special index 5 (Predator_Blue) → storage key 105
# - Special index 6 (Predator_Green) → storage key 106
# etc.
#
# Why pre-rendered?
# - Very complex images that don't compress well with RLE
# - Images with many unique colors (large palettes)
# - Pre-rendered look identical to originals
#

PRE_RENDERED_SPECIALS = {
    "Predator Blue",
    "Predator Green", 
    "Predator Red",
    "Santa Claus",
    "Shadow Ninja",
    "The Devil",
    "The Portrait"
}

# ============================================================================
# UTILITY FUNCTIONS (same as trait_generator.py)
# ============================================================================

def rgba_to_packed(r, g, b, a):
    return (r << 24) | (g << 16) | (b << 8) | a


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
        raise ValueError(f"Too many colors: {len(palette)}")
    
    return palette


def encode_rle(pixels, palette, bounds, width):
    """
    Encode pixels as RLE within bounding box.
    
    Returns (rle_data, pixel_count)
    
    RLE compression is critical for on-chain storage efficiency:
    - Reduces gas costs significantly
    - Typical 5-10x compression for pixel art
    - Example: 12 identical pixels = [0x0C][palette_index] (2-3 bytes)
              vs. uncompressed = 48 bytes (12 * 4 bytes RGBA)
    """
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
                            rle_data.extend(struct.pack('<H', color_idx))
                        pixel_count += 255
                        run_length -= 255
                    
                    if run_length > 0:
                        rle_data.append(run_length)
                        if index_bytes == 1:
                            rle_data.append(color_idx)
                        else:
                            rle_data.extend(struct.pack('<H', color_idx))
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
                rle_data.extend(struct.pack('<H', color_idx))
            pixel_count += 255
            run_length -= 255
        
        if run_length > 0:
            rle_data.append(run_length)
            if index_bytes == 1:
                rle_data.append(color_idx)
            else:
                rle_data.extend(struct.pack('<H', color_idx))
            pixel_count += run_length
    
    return bytes(rle_data), pixel_count


def encode_pre_rendered(filepath):
    """
    Encode PNG as base64 for pre-rendered specials.
    
    Args:
        filepath: Path to PNG file
    
    Returns:
        Base64-encoded PNG data
    
    Why base64?
        - Preserves exact original image
        - No RLE encoding overhead
        - Can be embedded directly in SVG as data URI
        - Contract uses: data:image/png;base64,[this_data]
    """
    with open(filepath, 'rb') as f:
        png_data = f.read()
    
    return base64.b64encode(png_data)


def encode_special_trait(trait_data, pixels, palette, custom_config):
    """
    Encode a single special trait.
    
    Args:
        trait_data: Dict with name, pixels, etc.
        pixels: Pixel array
        palette: Shared palette
        custom_config: Custom configuration from CUSTOM_SPECIALS
    
    Returns:
        bytes of encoded trait
    """
    bounds = compute_bounds(pixels, CANVAS_WIDTH, CANVAS_HEIGHT)
    x1, y1, x2, y2 = bounds
    
    # Get layer type from custom config or use default
    layer_type = custom_config.get('layer_type', 0) if custom_config else 0
    
    # Encode RLE
    rle_data, pixel_count = encode_rle(pixels, palette, bounds, CANVAS_WIDTH)
    
    # Build trait data
    output = bytearray()
    output.extend(struct.pack('<H', pixel_count))
    output.append(x1)
    output.append(y1)
    output.append(x2)
    output.append(y2)
    output.append(layer_type)
    
    # Name
    name_bytes = trait_data['name'].encode('utf-8')
    output.append(len(name_bytes))
    output.extend(name_bytes)
    
    # RLE data
    output.extend(rle_data)
    
    return bytes(output)


def encode_special_group():
    """
    Encode all special 1-of-1 characters.
    
    Process:
        1. Load all PNGs from SPECIALS_DIR
        2. Separate pre-rendered vs. trait-encoded
        3. Build palette for trait-encoded specials
        4. Encode each special appropriately
        5. Write separate output files
    
    Outputs:
        - special_1s.bin: Trait-encoded specials (RLE)
        - special_1s_prerendered_XXX.bin: Pre-rendered PNGs (base64)
    """
    print(f"\nProcessing Special 1-of-1 Characters")
    print("=" * 60)
    
    # Find all PNG files
    png_files = sorted([f for f in os.listdir(SPECIALS_DIR) if f.endswith('.png')])
    if not png_files:
        print(f"Error: No PNG files found in {SPECIALS_DIR}")
        return
    
    print(f"Found {len(png_files)} special characters")
    
    # Separate pre-rendered from trait-encoded
    pre_rendered = []
    trait_encoded = []
    
    for png_file in png_files:
        trait_name = os.path.splitext(png_file)[0]
        filepath = os.path.join(SPECIALS_DIR, png_file)
        
        # Check if this should be pre-rendered
        is_pre_rendered = trait_name in PRE_RENDERED_SPECIALS
        
        # Check for custom config
        custom_config = CUSTOM_SPECIALS.get(trait_name)
        if custom_config and 'pre_rendered' in custom_config:
            is_pre_rendered = custom_config['pre_rendered']
        
        if is_pre_rendered:
            pre_rendered.append({
                'name': trait_name,
                'filepath': filepath,
                'custom': custom_config
            })
            print(f"  Pre-rendered: {trait_name}")
        else:
            pixels = load_png_as_rgba(filepath)
            trait_encoded.append({
                'name': trait_name,
                'pixels': pixels,
                'custom': custom_config
            })
            print(f"  Trait-encoded: {trait_name}")
    
    # ========================================================================
    # PROCESS PRE-RENDERED SPECIALS
    # ========================================================================
    
    print(f"\nEncoding {len(pre_rendered)} pre-rendered specials...")
    for idx, special in enumerate(pre_rendered):
        print(f"  [{idx+1}/{len(pre_rendered)}] {special['name']}")
        
        # Encode as base64
        encoded = encode_pre_rendered(special['filepath'])
        
        # Write to separate file
        # Storage key = 100 + special_index
        # (Contract uses loadAssetOriginal(special_id + 100))
        output_path = os.path.join(OUTPUT_DIR, f"special_1s_prerendered_{idx}.bin")
        with open(output_path, 'wb') as f:
            f.write(encoded)
        
        print(f"    Size: {len(encoded)} bytes")
        print(f"    Saved: {output_path}")
    
    # ========================================================================
    # PROCESS TRAIT-ENCODED SPECIALS
    # ========================================================================
    
    if not trait_encoded:
        print("\nNo trait-encoded specials to process")
        return
    
    print(f"\nEncoding {len(trait_encoded)} trait-encoded specials...")
    
    # Build palette
    print("Building palette...")
    all_pixels = [t['pixels'] for t in trait_encoded]
    palette = build_palette(all_pixels)
    print(f"Palette size: {len(palette)} colors")
    
    index_bytes = 2 if len(palette) > 255 else 1
    print(f"Index size: {index_bytes} byte(s)")
    
    # Start building binary data
    output = bytearray()
    
    # Group name
    group_name = "Special 1s"
    group_name_bytes = group_name.encode('utf-8')
    output.append(len(group_name_bytes))
    output.extend(group_name_bytes)
    
    # Palette
    output.extend(struct.pack('<H', len(palette)))
    for color in palette:
        r = (color >> 24) & 0xFF
        g = (color >> 16) & 0xFF
        b = (color >> 8) & 0xFF
        a = color & 0xFF
        output.extend([r, g, b, a])
    
    # Index byte size
    output.append(index_bytes)
    
    # Trait count
    output.append(len(trait_encoded))
    
    # Encode each trait
    for idx, trait in enumerate(trait_encoded):
        print(f"  [{idx+1}/{len(trait_encoded)}] {trait['name']}")
        
        trait_data = encode_special_trait(
            trait,
            trait['pixels'],
            palette,
            trait['custom']
        )
        output.extend(trait_data)
    
    # Write output
    output_path = os.path.join(OUTPUT_DIR, "special_1s.bin")
    with open(output_path, 'wb') as f:
        f.write(output)
    
    print(f"\nTotal size: {len(output)} bytes")
    print(f"Written: {output_path}")
    print("\nDone!")


# ============================================================================
# MAIN
# ============================================================================

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    encode_special_group()


if __name__ == '__main__':
    main()