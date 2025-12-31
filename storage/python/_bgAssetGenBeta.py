#!/usr/bin/env python3
import os
import struct

# ============================================================================
# CONFIGURATION
# ============================================================================

OUTPUT_DIR = "output"
GROUP_NAME = "Background"

# Background types matching E_Background_Type enum
BG_TYPE_NONE = 0
BG_TYPE_IMAGE = 1
BG_TYPE_SOLID = 2

BG_TYPE_S_VERTICAL = 3
BG_TYPE_P_VERTICAL = 4
BG_TYPE_S_VERTICAL_INVERSE = 5
BG_TYPE_P_VERTICAL_INVERSE = 6

BG_TYPE_S_HORIZONTAL = 7
BG_TYPE_P_HORIZONTAL = 8
BG_TYPE_S_HORIZONTAL_INVERSE = 9
BG_TYPE_P_HORIZONTAL_INVERSE = 10

BG_TYPE_S_DIAGONAL = 11
BG_TYPE_P_DIAGONAL = 12
BG_TYPE_S_DIAGONAL_INVERSE = 13
BG_TYPE_P_DIAGONAL_INVERSE = 14

BG_TYPE_S_REVERSE_DIAGONAL = 15
BG_TYPE_P_REVERSE_DIAGONAL = 16
BG_TYPE_S_REVERSE_DIAGONAL_INVERSE = 17
BG_TYPE_P_REVERSE_DIAGONAL_INVERSE = 18

BG_TYPE_RADIAL = 19

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================


def parse_color(color):
    """
    Parse color from string or int format.
    Accepts: '#ff3333', 'ff3333', '#ff3333ff', 'ffccccff', 'FFccccFF', 0xffccccff, or integer
    Automatically adds 'ff' alpha if only RGB (6 chars) provided
    Returns: integer RRGGBBAA value
    """
    if isinstance(color, str):
        # Remove '#' or '0x' prefix if present
        color = color.replace('#', '').replace('0x', '').replace('0X', '')

        # If it's 6 characters (RGB), add 'ff' for full opacity (alpha=255)
        if len(color) == 6:
            color = color + 'ff'
        elif len(color) != 8:
            raise ValueError(
                f"Invalid color format: {color}. Must be 6 (RGB) or 8 (RGBA) hex characters.")

        return int(color, 16)
    return color

# ============================================================================
# BACKGROUND DEFINITIONS
# ============================================================================


BACKGROUNDS = [
    {
        'name': 'Rainbow',
        'layerType': BG_TYPE_IMAGE,
        'palette': []
    },

    {
        'name': 'Red Solid',
        'layerType': BG_TYPE_SOLID,
        'palette': ["#f24e4e"]
    },

    {
        'name': 'Green Solid',
        'layerType': BG_TYPE_SOLID,
        'palette': ["#47b576"]
    },

    {
        'name': 'Black & White Smooth Vertical',
        'layerType': BG_TYPE_S_VERTICAL,
        'palette': [
            0x000000FF,
            0x020202FF,
            0x070707FF,
            0x0F0F0FFF,
            0x161616FF,
            0x1E1E1EFF,
            0x272727FF,
            0x333333FF,
            0x404040FF,
            0x4E4E4EFF,
            0x5E5E5EFF,
            0x6E6E6EFF,
            0x808080FF,
            0x919191FF,
            0xA2A2A2FF,
            0xB3B3B3FF,
            0xC3C3C3FF,
            0xD2D2D2FF,
            0xDFDFDFFF,
            0xEAEAEAFF,
            0xF3F3F3FF,
            0xFAFAFAFF,
            0xFEFEFEFF,
            0xFFFFFFFF
        ]
    },

    {
        'name': 'Black & White Pixel Vertical',
        'layerType': BG_TYPE_P_VERTICAL,
        'palette': [
            0x000000FF,
            0x020202FF,
            0x070707FF,
            0x0F0F0FFF,
            0x161616FF,
            0x1E1E1EFF,
            0x272727FF,
            0x333333FF,
            0x404040FF,
            0x4E4E4EFF,
            0x5E5E5EFF,
            0x6E6E6EFF,
            0x808080FF,
            0x919191FF,
            0xA2A2A2FF,
            0xB3B3B3FF,
            0xC3C3C3FF,
            0xD2D2D2FF,
            0xDFDFDFFF,
            0xEAEAEAFF,
            0xF3F3F3FF,
            0xFAFAFAFF,
            0xFEFEFEFF,
            0xFFFFFFFF
        ]
    },

    {
        'name': 'Black & White Smooth Vertical Inverse',
        'layerType': BG_TYPE_S_VERTICAL_INVERSE,
        'palette': [
            0x000000FF,
            0x020202FF,
            0x070707FF,
            0x0F0F0FFF,
            0x161616FF,
            0x1E1E1EFF,
            0x272727FF,
            0x333333FF,
            0x404040FF,
            0x4E4E4EFF,
            0x5E5E5EFF,
            0x6E6E6EFF,
            0x808080FF,
            0x919191FF,
            0xA2A2A2FF,
            0xB3B3B3FF,
            0xC3C3C3FF,
            0xD2D2D2FF,
            0xDFDFDFFF,
            0xEAEAEAFF,
            0xF3F3F3FF,
            0xFAFAFAFF,
            0xFEFEFEFF,
            0xFFFFFFFF
        ]
    },

    {
        'name': 'Black & White Pixel Vertical Inverse',
        'layerType': BG_TYPE_P_VERTICAL_INVERSE,
        'palette': [
            0x000000FF,
            0x020202FF,
            0x070707FF,
            0x0F0F0FFF,
            0x161616FF,
            0x1E1E1EFF,
            0x272727FF,
            0x333333FF,
            0x404040FF,
            0x4E4E4EFF,
            0x5E5E5EFF,
            0x6E6E6EFF,
            0x808080FF,
            0x919191FF,
            0xA2A2A2FF,
            0xB3B3B3FF,
            0xC3C3C3FF,
            0xD2D2D2FF,
            0xDFDFDFFF,
            0xEAEAEAFF,
            0xF3F3F3FF,
            0xFAFAFAFF,
            0xFEFEFEFF,
            0xFFFFFFFF
        ]
    },

    {
        'name': 'Black & White Smooth Horizontal',
        'layerType': BG_TYPE_S_HORIZONTAL,
        'palette': [
            0x000000FF,
            0x020202FF,
            0x070707FF,
            0x0F0F0FFF,
            0x161616FF,
            0x1E1E1EFF,
            0x272727FF,
            0x333333FF,
            0x404040FF,
            0x4E4E4EFF,
            0x5E5E5EFF,
            0x6E6E6EFF,
            0x808080FF,
            0x919191FF,
            0xA2A2A2FF,
            0xB3B3B3FF,
            0xC3C3C3FF,
            0xD2D2D2FF,
            0xDFDFDFFF,
            0xEAEAEAFF,
            0xF3F3F3FF,
            0xFAFAFAFF,
            0xFEFEFEFF,
            0xFFFFFFFF
        ]
    },

    {
        'name': 'Black & White Pixel Horizontal',
        'layerType': BG_TYPE_P_HORIZONTAL,
        'palette': [
            0x000000FF,
            0x020202FF,
            0x070707FF,
            0x0F0F0FFF,
            0x161616FF,
            0x1E1E1EFF,
            0x272727FF,
            0x333333FF,
            0x404040FF,
            0x4E4E4EFF,
            0x5E5E5EFF,
            0x6E6E6EFF,
            0x808080FF,
            0x919191FF,
            0xA2A2A2FF,
            0xB3B3B3FF,
            0xC3C3C3FF,
            0xD2D2D2FF,
            0xDFDFDFFF,
            0xEAEAEAFF,
            0xF3F3F3FF,
            0xFAFAFAFF,
            0xFEFEFEFF,
            0xFFFFFFFF
        ]
    },

    {
        'name': 'Black & White Smooth Horizontal Inverse',
        'layerType': BG_TYPE_S_HORIZONTAL_INVERSE,
        'palette': [
            0x000000FF,
            0x020202FF,
            0x070707FF,
            0x0F0F0FFF,
            0x161616FF,
            0x1E1E1EFF,
            0x272727FF,
            0x333333FF,
            0x404040FF,
            0x4E4E4EFF,
            0x5E5E5EFF,
            0x6E6E6EFF,
            0x808080FF,
            0x919191FF,
            0xA2A2A2FF,
            0xB3B3B3FF,
            0xC3C3C3FF,
            0xD2D2D2FF,
            0xDFDFDFFF,
            0xEAEAEAFF,
            0xF3F3F3FF,
            0xFAFAFAFF,
            0xFEFEFEFF,
            0xFFFFFFFF
        ]
    },

    {
        'name': 'Black & White Pixel Horizontal Inverse',
        'layerType': BG_TYPE_P_HORIZONTAL_INVERSE,
        'palette': [
            0x000000FF,
            0x020202FF,
            0x070707FF,
            0x0F0F0FFF,
            0x161616FF,
            0x1E1E1EFF,
            0x272727FF,
            0x333333FF,
            0x404040FF,
            0x4E4E4EFF,
            0x5E5E5EFF,
            0x6E6E6EFF,
            0x808080FF,
            0x919191FF,
            0xA2A2A2FF,
            0xB3B3B3FF,
            0xC3C3C3FF,
            0xD2D2D2FF,
            0xDFDFDFFF,
            0xEAEAEAFF,
            0xF3F3F3FF,
            0xFAFAFAFF,
            0xFEFEFEFF,
            0xFFFFFFFF
        ]
    },

    {
        'name': 'Black & White Smooth Diagonal',
        'layerType': BG_TYPE_S_DIAGONAL,
        'palette': [
            0x000000FF,
            0x020202FF,
            0x070707FF,
            0x0F0F0FFF,
            0x161616FF,
            0x1E1E1EFF,
            0x272727FF,
            0x333333FF,
            0x404040FF,
            0x4E4E4EFF,
            0x5E5E5EFF,
            0x6E6E6EFF,
            0x808080FF,
            0x919191FF,
            0xA2A2A2FF,
            0xB3B3B3FF,
            0xC3C3C3FF,
            0xD2D2D2FF,
            0xDFDFDFFF,
            0xEAEAEAFF,
            0xF3F3F3FF,
            0xFAFAFAFF,
            0xFEFEFEFF,
            0xFFFFFFFF
        ]
    },

    {
        'name': 'Black & White Pixel Diagonal',
        'layerType': BG_TYPE_P_DIAGONAL,
        'palette': [
            0x000000FF,
            0x020202FF,
            0x070707FF,
            0x0F0F0FFF,
            0x161616FF,
            0x1E1E1EFF,
            0x272727FF,
            0x333333FF,
            0x404040FF,
            0x4E4E4EFF,
            0x5E5E5EFF,
            0x6E6E6EFF,
            0x808080FF,
            0x919191FF,
            0xA2A2A2FF,
            0xB3B3B3FF,
            0xC3C3C3FF,
            0xD2D2D2FF,
            0xDFDFDFFF,
            0xEAEAEAFF,
            0xF3F3F3FF,
            0xFAFAFAFF,
            0xFEFEFEFF,
            0xFFFFFFFF
        ]
    },

    {
        'name': 'Black & White Smooth Diagonal Inverse',
        'layerType': BG_TYPE_S_DIAGONAL_INVERSE,
        'palette': [
            0x000000FF,
            0x020202FF,
            0x070707FF,
            0x0F0F0FFF,
            0x161616FF,
            0x1E1E1EFF,
            0x272727FF,
            0x333333FF,
            0x404040FF,
            0x4E4E4EFF,
            0x5E5E5EFF,
            0x6E6E6EFF,
            0x808080FF,
            0x919191FF,
            0xA2A2A2FF,
            0xB3B3B3FF,
            0xC3C3C3FF,
            0xD2D2D2FF,
            0xDFDFDFFF,
            0xEAEAEAFF,
            0xF3F3F3FF,
            0xFAFAFAFF,
            0xFEFEFEFF,
            0xFFFFFFFF
        ]
    },

    {
        'name': 'Black & White Pixel Diagonal Inverse',
        'layerType': BG_TYPE_P_DIAGONAL_INVERSE,
        'palette': [
            0x000000FF,
            0x020202FF,
            0x070707FF,
            0x0F0F0FFF,
            0x161616FF,
            0x1E1E1EFF,
            0x272727FF,
            0x333333FF,
            0x404040FF,
            0x4E4E4EFF,
            0x5E5E5EFF,
            0x6E6E6EFF,
            0x808080FF,
            0x919191FF,
            0xA2A2A2FF,
            0xB3B3B3FF,
            0xC3C3C3FF,
            0xD2D2D2FF,
            0xDFDFDFFF,
            0xEAEAEAFF,
            0xF3F3F3FF,
            0xFAFAFAFF,
            0xFEFEFEFF,
            0xFFFFFFFF
        ]
    },

    {
        'name': 'Black & White Smooth Reverse Diagonal',
        'layerType': BG_TYPE_S_REVERSE_DIAGONAL,
        'palette': [
            0x000000FF,
            0x020202FF,
            0x070707FF,
            0x0F0F0FFF,
            0x161616FF,
            0x1E1E1EFF,
            0x272727FF,
            0x333333FF,
            0x404040FF,
            0x4E4E4EFF,
            0x5E5E5EFF,
            0x6E6E6EFF,
            0x808080FF,
            0x919191FF,
            0xA2A2A2FF,
            0xB3B3B3FF,
            0xC3C3C3FF,
            0xD2D2D2FF,
            0xDFDFDFFF,
            0xEAEAEAFF,
            0xF3F3F3FF,
            0xFAFAFAFF,
            0xFEFEFEFF,
            0xFFFFFFFF
        ]
    },

    {
        'name': 'Black & White Pixel Reverse Diagonal',
        'layerType': BG_TYPE_P_REVERSE_DIAGONAL,
        'palette': [
            0x000000FF,
            0x020202FF,
            0x070707FF,
            0x0F0F0FFF,
            0x161616FF,
            0x1E1E1EFF,
            0x272727FF,
            0x333333FF,
            0x404040FF,
            0x4E4E4EFF,
            0x5E5E5EFF,
            0x6E6E6EFF,
            0x808080FF,
            0x919191FF,
            0xA2A2A2FF,
            0xB3B3B3FF,
            0xC3C3C3FF,
            0xD2D2D2FF,
            0xDFDFDFFF,
            0xEAEAEAFF,
            0xF3F3F3FF,
            0xFAFAFAFF,
            0xFEFEFEFF,
            0xFFFFFFFF
        ]
    },

    {
        'name': 'Black & White Smooth Reverse Diagonal Inverse',
        'layerType': BG_TYPE_S_REVERSE_DIAGONAL_INVERSE,
        'palette': [
            0x000000FF,
            0x020202FF,
            0x070707FF,
            0x0F0F0FFF,
            0x161616FF,
            0x1E1E1EFF,
            0x272727FF,
            0x333333FF,
            0x404040FF,
            0x4E4E4EFF,
            0x5E5E5EFF,
            0x6E6E6EFF,
            0x808080FF,
            0x919191FF,
            0xA2A2A2FF,
            0xB3B3B3FF,
            0xC3C3C3FF,
            0xD2D2D2FF,
            0xDFDFDFFF,
            0xEAEAEAFF,
            0xF3F3F3FF,
            0xFAFAFAFF,
            0xFEFEFEFF,
            0xFFFFFFFF
        ]
    },

    {
        'name': 'Black & White Pixel Reverse Diagonal Inverse',
        'layerType': BG_TYPE_P_REVERSE_DIAGONAL_INVERSE,
        'palette': [
            0x000000FF,
            0x020202FF,
            0x070707FF,
            0x0F0F0FFF,
            0x161616FF,
            0x1E1E1EFF,
            0x272727FF,
            0x333333FF,
            0x404040FF,
            0x4E4E4EFF,
            0x5E5E5EFF,
            0x6E6E6EFF,
            0x808080FF,
            0x919191FF,
            0xA2A2A2FF,
            0xB3B3B3FF,
            0xC3C3C3FF,
            0xD2D2D2FF,
            0xDFDFDFFF,
            0xEAEAEAFF,
            0xF3F3F3FF,
            0xFAFAFAFF,
            0xFEFEFEFF,
            0xFFFFFFFF
        ]
    },

    {
        'name': 'Black & White Radial Gradient',
        'layerType': BG_TYPE_RADIAL,
        'palette': [
            0x000000FF,
            0x020202FF,
            0x070707FF,
            0x0F0F0FFF,
            0x161616FF,
            0x1E1E1EFF,
            0x272727FF,
            0x333333FF,
            0x404040FF,
            0x4E4E4EFF,
            0x5E5E5EFF,
            0x6E6E6EFF,
            0x808080FF,
            0x919191FF,
            0xA2A2A2FF,
            0xB3B3B3FF,
            0xC3C3C3FF,
            0xD2D2D2FF,
            0xDFDFDFFF,
            0xEAEAEAFF,
            0xF3F3F3FF,
            0xFAFAFAFF,
            0xFEFEFEFF,
            0xFFFFFFFF
        ]
    },
]

# ============================================================================
# COORDINATE MAPPING
# ============================================================================


def get_gradient_coords(layer_type):
    """
    Returns (x1, y1, x2, y2) for SVG gradient based on layerType.
    Matches the logic from TraitsRenderer._renderBackground
    """
    # BGData hex values unpacked: bit0=x1, bit1=y1, bit2=x2, bit3=y2
    coords_map = {
        BG_TYPE_S_VERTICAL: (0, 0, 0, 1),
        BG_TYPE_P_VERTICAL: (0, 0, 0, 1),
        BG_TYPE_S_VERTICAL_INVERSE: (0, 1, 0, 0),
        BG_TYPE_P_VERTICAL_INVERSE: (0, 1, 0, 0),

        BG_TYPE_S_HORIZONTAL: (0, 0, 1, 0),
        BG_TYPE_P_HORIZONTAL: (0, 0, 1, 0),
        BG_TYPE_S_HORIZONTAL_INVERSE: (1, 0, 0, 0),
        BG_TYPE_P_HORIZONTAL_INVERSE: (1, 0, 0, 0),

        BG_TYPE_S_DIAGONAL: (0, 0, 1, 1),
        BG_TYPE_P_DIAGONAL: (0, 0, 1, 1),
        BG_TYPE_S_DIAGONAL_INVERSE: (1, 1, 0, 0),
        BG_TYPE_P_DIAGONAL_INVERSE: (1, 1, 0, 0),

        BG_TYPE_S_REVERSE_DIAGONAL: (1, 0, 0, 1),
        BG_TYPE_P_REVERSE_DIAGONAL: (1, 0, 0, 1),
        BG_TYPE_S_REVERSE_DIAGONAL_INVERSE: (0, 1, 1, 0),
        BG_TYPE_P_REVERSE_DIAGONAL_INVERSE: (0, 1, 1, 0),

        BG_TYPE_RADIAL: (0, 0, 0, 0),  # Radial doesn't use linear coords
    }

    return coords_map.get(layer_type, (0, 0, 0, 0))


def encode_background_trait(bg_def):
    """Encode a single background trait"""
    output = bytearray()

    layer_type = bg_def['layerType']
    palette = [parse_color(c) for c in bg_def['palette']]

    # Pixel count = number of colors in palette
    pixel_count = len(palette)
    output.extend(struct.pack('>H', pixel_count))

    # Coordinates based on layerType
    x1, y1, x2, y2 = get_gradient_coords(layer_type)
    output.extend([x1, y1, x2, y2, layer_type])

    # Trait name
    name_bytes = bg_def['name'].encode('utf-8')
    output.append(len(name_bytes))
    output.extend(name_bytes)

    # "RLE" data - just palette indices in sequence
    # For backgrounds, each color gets 1 pixel run
    for i in range(len(palette)):
        output.append(1)  # run_length = 1
        # Index encoding depends on palette size (handled at group level)
        if len(palette) > 255:
            output.extend(struct.pack('>H', i))
        else:
            output.append(i)

    return bytes(output)


def encode_background_group():
    """Encode the complete background trait group"""
    output = bytearray()

    # Group name
    name_bytes = GROUP_NAME.encode('utf-8')
    output.append(len(name_bytes))
    output.extend(name_bytes)

    # Build unified palette from all backgrounds
    all_colors = []
    for bg in BACKGROUNDS:
        all_colors.extend([parse_color(c) for c in bg['palette']])

    # Remove duplicates while preserving order
    unified_palette = []
    seen = set()
    for color in all_colors:
        if color not in seen:
            unified_palette.append(color)
            seen.add(color)

    if len(unified_palette) > 65535:
        raise ValueError("Too many unique colors in backgrounds")

    # Write palette
    output.extend(struct.pack('>H', len(unified_palette)))
    for color in unified_palette:
        output.extend([
            (color >> 24) & 0xFF,  # R
            (color >> 16) & 0xFF,  # G
            (color >> 8) & 0xFF,   # B
            color & 0xFF           # A
        ])

    # Index byte size
    index_bytes = 2 if len(unified_palette) > 255 else 1
    output.append(index_bytes)

    # Trait count
    output.append(len(BACKGROUNDS))

    # Create color index map
    color_to_index = {color: idx for idx, color in enumerate(unified_palette)}

    # Encode each background with remapped indices
    for bg_def in BACKGROUNDS:
        bg_output = bytearray()

        layer_type = bg_def['layerType']
        palette = [parse_color(c) for c in bg_def['palette']]

        # Pixel count
        pixel_count = len(palette)
        bg_output.extend(struct.pack('>H', pixel_count))

        # Coordinates
        x1, y1, x2, y2 = get_gradient_coords(layer_type)
        bg_output.extend([x1, y1, x2, y2, layer_type])

        # Name
        name_bytes = bg_def['name'].encode('utf-8')
        bg_output.append(len(name_bytes))
        bg_output.extend(name_bytes)

        # RLE data with unified palette indices
        for color in palette:
            unified_index = color_to_index[color]
            bg_output.append(1)  # run_length = 1
            if index_bytes == 2:
                bg_output.extend(struct.pack('>H', unified_index))
            else:
                bg_output.append(unified_index)

        output.extend(bg_output)

    return bytes(output)


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    print(f"Generating background assets...")
    print(f"Backgrounds defined: {len(BACKGROUNDS)}")

    data = encode_background_group()
    if data:
        output_path = os.path.join(OUTPUT_DIR, f"{GROUP_NAME}.bin")
        with open(output_path, 'wb') as f:
            f.write(data)
        print(f"\n✓ Written: {output_path} - {len(data)} bytes")
        print(f"  Ready for LibZip.flzCompress and Assets contract upload")


if __name__ == '__main__':
    main()
