#!/usr/bin/env python3
"""
RetroPunks Background Generator

Generates background assets with full manual control.
Backgrounds can be:
- Solid colors
- Gradient patterns (linear or radial)
- Full images

All backgrounds are defined manually in code rather than loaded from files.
This provides complete control over gradient types, colors, and ordering.

Usage:
    python backgrounds_generator.py

Customization:
    Edit BACKGROUNDS list below to add/modify backgrounds.
    Each background is fully defined in code.
"""

import os
import struct

# ============================================================================
# CONFIGURATION
# ============================================================================

OUTPUT_DIR = "output"
CANVAS_WIDTH = 48
CANVAS_HEIGHT = 48

# ============================================================================
# BACKGROUND LAYER TYPES
# ============================================================================
#
# Background layer types determine how the background is rendered:
#
# 0:  None (should not be used)
# 1:  Background_Image - Full 48x48 image encoded as trait data
# 2:  Solid - Single solid color (not implemented, falls through to gradient)
# 3-19: Various gradient types (see below)
# 20: Radial - Radial gradient from center
#
# Gradient Types (3-19):
# - S = Smooth gradient (colors blend)
# - P = Pixelated gradient (hard edges between colors)
# - Vertical, Horizontal, Diagonal, Reverse_Diagonal
# - Regular or Inverse (direction)
#
# Examples:
#   3: S_Vertical - Smooth vertical gradient (top to bottom)
#   4: P_Vertical - Pixelated vertical gradient
#   5: S_Vertical_Inverse - Smooth vertical gradient (bottom to top)
#   ...
#
# See Enums.sol E_BgType for complete list

# ============================================================================
# BACKGROUND DEFINITIONS
# ============================================================================
#
# To add a new background, copy this template:
#
# {
#     "name": "Background Name",
#     "layer_type": 3,  # See layer types above
#     "colors": [
#         (255, 0, 0, 255),    # Red
#         (0, 255, 0, 255),    # Green
#         (0, 0, 255, 255),    # Blue
#     ],
#     "image_data": None,  # For layer_type=1, provide pixel array
# },
#
# For gradients:
#   - colors: List of (R, G, B, A) tuples
#   - Colors are distributed evenly across gradient
#   - 2 colors = simple gradient
#   - 3+ colors = multi-stop gradient
#
# For images (layer_type=1):
#   - image_data: List of 2304 (48x48) packed RGBA integers
#   - colors: Automatically extracted from image_data
#   - Use helper function to load from PNG if needed
#

BACKGROUNDS = [
    {
        "name": "Standard",
        "layer_type": 3,  # S_Vertical
        "colors": [
            (200, 200, 200, 255),  # Light gray
            (150, 150, 150, 255),  # Medium gray
        ],
        "image_data": None,
    },
    {
        "name": "Blue",
        "layer_type": 3,  # S_Vertical
        "colors": [
            (100, 150, 255, 255),  # Light blue
            (0, 50, 200, 255),     # Dark blue
        ],
        "image_data": None,
    },
    {
        "name": "Green",
        "layer_type": 3,  # S_Vertical
        "colors": [
            (150, 255, 150, 255),  # Light green
            (0, 150, 0, 255),      # Dark green
        ],
        "image_data": None,
    },
    {
        "name": "Lava",
        "layer_type": 4,  # P_Vertical (pixelated for harsh lava look)
        "colors": [
            (255, 100, 0, 255),    # Orange
            (255, 0, 0, 255),      # Red
            (100, 0, 0, 255),      # Dark red
        ],
        "image_data": None,
    },
    {
        "name": "Orange",
        "layer_type": 3,  # S_Vertical
        "colors": [
            (255, 200, 100, 255),  # Light orange
            (255, 100, 0, 255),    # Dark orange
        ],
        "image_data": None,
    },
    {
        "name": "Pink",
        "layer_type": 3,  # S_Vertical
        "colors": [
            (255, 150, 200, 255),  # Light pink
            (255, 50, 150, 255),   # Dark pink
        ],
        "image_data": None,
    },
    {
        "name": "Purple",
        "layer_type": 3,  # S_Vertical
        "colors": [
            (200, 100, 255, 255),  # Light purple
            (100, 0, 200, 255),    # Dark purple
        ],
        "image_data": None,
    },
    {
        "name": "Red",
        "layer_type": 3,  # S_Vertical
        "colors": [
            (255, 100, 100, 255),  # Light red
            (200, 0, 0, 255),      # Dark red
        ],
        "image_data": None,
    },
    {
        "name": "Sky Blue",
        "layer_type": 3,  # S_Vertical
        "colors": [
            (200, 230, 255, 255),  # Very light blue
            (100, 180, 255, 255),  # Sky blue
        ],
        "image_data": None,
    },
    {
        "name": "Turquoise",
        "layer_type": 3,  # S_Vertical
        "colors": [
            (150, 255, 255, 255),  # Light turquoise
            (0, 200, 200, 255),    # Dark turquoise
        ],
        "image_data": None,
    },
    {
        "name": "Yellow",
        "layer_type": 3,  # S_Vertical
        "colors": [
            (255, 255, 150, 255),  # Light yellow
            (255, 200, 0, 255),    # Dark yellow
        ],
        "image_data": None,
    },
    
    # Example of radial gradient:
    # {
    #     "name": "Radial Example",
    #     "layer_type": 20,  # Radial
    #     "colors": [
    #         (255, 255, 255, 255),  # White center
    #         (100, 100, 100, 255),  # Gray edge
    #     ],
    #     "image_data": None,
    # },
    
    # Example of diagonal gradient:
    # {
    #     "name": "Diagonal Example",
    #     "layer_type": 11,  # S_Diagonal
    #     "colors": [
    #         (255, 0, 0, 255),      # Red
    #         (0, 0, 255, 255),      # Blue
    #     ],
    #     "image_data": None,
    # },
]

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

def rgba_to_packed(r, g, b, a):
    """Pack RGBA components into 32-bit RRGGBBAA integer."""
    return (r << 24) | (g << 16) | (b << 8) | a


def build_palette_from_colors(color_tuples):
    """
    Build palette from list of color tuples.
    
    Args:
        color_tuples: List of (R, G, B, A) tuples
    
    Returns:
        List of packed RRGGBBAA integers
    """
    palette = []
    for r, g, b, a in color_tuples:
        palette.append(rgba_to_packed(r, g, b, a))
    return palette


def encode_gradient_colors(colors, palette):
    """
    Encode gradient colors as palette indices.
    
    For gradients, the "trait data" is just a sequence of palette indices
    representing the gradient stops.
    
    Args:
        colors: List of packed RGBA integers
        palette: Palette (same as colors for gradients)
    
    Returns:
        bytes of palette indices
    """
    palette_map = {color: idx for idx, color in enumerate(palette)}
    
    index_bytes = 2 if len(palette) > 255 else 1
    output = bytearray()
    
    for color in colors:
        idx = palette_map[color]
        if index_bytes == 1:
            output.append(idx)
        else:
            output.extend(struct.pack('<H', idx))
    
    return bytes(output)


def encode_image_data(pixels, palette):
    """
    Encode full image as RLE data.
    
    For background images (layer_type=1), encode the entire 48x48 image.
    
    Args:
        pixels: List of 2304 packed RGBA integers
        palette: Palette of unique colors
    
    Returns:
        bytes of RLE-encoded image
    
    Note:
        This uses the same RLE encoding as normal traits, but for the full canvas.
        Bounds are (0, 0, 47, 47).
    """
    palette_map = {color: idx for idx, color in enumerate(palette)}
    index_bytes = 2 if len(palette) > 255 else 1
    
    rle_data = bytearray()
    current_run = []
    current_color = None
    
    for color in pixels:
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
                    run_length -= 255
                
                if run_length > 0:
                    rle_data.append(run_length)
                    if index_bytes == 1:
                        rle_data.append(color_idx)
                    else:
                        rle_data.extend(struct.pack('<H', color_idx))
            
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
            run_length -= 255
        
        if run_length > 0:
            rle_data.append(run_length)
            if index_bytes == 1:
                rle_data.append(color_idx)
            else:
                rle_data.extend(struct.pack('<H', color_idx))
    
    return bytes(rle_data)


def encode_background(bg_def):
    """
    Encode a single background.
    
    Args:
        bg_def: Background definition dict
    
    Returns:
        bytes of encoded background trait
    """
    name = bg_def['name']
    layer_type = bg_def['layer_type']
    
    if layer_type == 1:
        # Full image background
        pixels = bg_def['image_data']
        if not pixels or len(pixels) != CANVAS_WIDTH * CANVAS_HEIGHT:
            raise ValueError(f"Background '{name}' requires 2304 pixels for layer_type=1")
        
        # Build palette from image
        unique_colors = list(set(pixels))
        palette = unique_colors
        
        # Encode as RLE
        trait_data = encode_image_data(pixels, palette)
        pixel_count = len(pixels)
        x1, y1, x2, y2 = 0, 0, CANVAS_WIDTH - 1, CANVAS_HEIGHT - 1
        
    else:
        # Gradient background
        colors = bg_def['colors']
        if not colors:
            raise ValueError(f"Background '{name}' requires colors for gradients")
        
        # For gradients, palette = colors
        palette = build_palette_from_colors(colors)
        
        # Encode colors as indices (no RLE needed, just indices)
        trait_data = encode_gradient_colors(palette, palette)
        pixel_count = len(colors)
        
        # Gradients don't have bounds, but we need to write them
        x1, y1, x2, y2 = 0, 0, 0, 0
    
    # Build trait binary data
    output = bytearray()
    
    # Pixel count
    output.extend(struct.pack('<H', pixel_count))
    
    # Bounds
    output.append(x1)
    output.append(y1)
    output.append(x2)
    output.append(y2)
    
    # Layer type
    output.append(layer_type)
    
    # Name
    name_bytes = name.encode('utf-8')
    output.append(len(name_bytes))
    output.extend(name_bytes)
    
    # Trait data
    output.extend(trait_data)
    
    return bytes(output), palette


def encode_backgrounds():
    """
    Encode all backgrounds into a single trait group file.
    
    Process:
        1. Encode each background separately
        2. Build combined palette from all backgrounds
        3. Pack into trait group format
        4. Write to backgrounds.bin
    """
    print("\nProcessing Backgrounds")
    print("=" * 60)
    print(f"Found {len(BACKGROUNDS)} backgrounds")
    
    # Encode each background and collect palettes
    encoded_backgrounds = []
    all_palettes = []
    
    for idx, bg_def in enumerate(BACKGROUNDS):
        print(f"\n[{idx+1}/{len(BACKGROUNDS)}] {bg_def['name']}")
        print(f"  Layer type: {bg_def['layer_type']}")
        
        trait_data, palette = encode_background(bg_def)
        encoded_backgrounds.append({
            'name': bg_def['name'],
            'data': trait_data,
            'palette': palette
        })
        all_palettes.append(palette)
        
        print(f"  Colors: {len(palette)}")
        print(f"  Data size: {len(trait_data)} bytes")
    
    # Build combined palette
    print("\nBuilding combined palette...")
    all_colors = []
    for palette in all_palettes:
        all_colors.extend(palette)
    
    combined_palette = list(set(all_colors))
    print(f"Combined palette: {len(combined_palette)} unique colors")
    
    index_bytes = 2 if len(combined_palette) > 255 else 1
    print(f"Index size: {index_bytes} byte(s)")
    
    # Build trait group binary data
    output = bytearray()
    
    # Group name
    group_name = "Background"
    group_name_bytes = group_name.encode('utf-8')
    output.append(len(group_name_bytes))
    output.extend(group_name_bytes)
    
    # Palette
    output.extend(struct.pack('<H', len(combined_palette)))
    for color in combined_palette:
        r = (color >> 24) & 0xFF
        g = (color >> 16) & 0xFF
        b = (color >> 8) & 0xFF
        a = color & 0xFF
        output.extend([r, g, b, a])
    
    # Index byte size
    output.append(index_bytes)
    
    # Trait count
    output.append(len(BACKGROUNDS))
    
    # Write each background
    for bg in encoded_backgrounds:
        output.extend(bg['data'])
    
    # Write output
    output_path = os.path.join(OUTPUT_DIR, "backgrounds.bin")
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
    encode_backgrounds()


if __name__ == '__main__':
    main()