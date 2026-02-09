#!/usr/bin/env python3
import os
import struct

# ============================================================================
# CONFIGURATION
# ============================================================================
OUTPUT_DIR = "output"
COMBINED_FILENAME = "background_trait_hex.txt"
GROUP_NAME = "Background"

# Background types matching your Solidity E_Background_Type enum
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


BACKGROUNDS = [
    {
        'name': 'Rainbow',
        'layerType': 1,
        'palette': []
    },

    {
        'name': 'Solid',
        'layerType': 2,
        'palette': ["#b5b5b5"]
    },

    {
        'name': 'Smooth Vertical',
        'layerType': 3,
        'palette': ["#000000", "#ffffff"]
    },

    {
        'name': 'Pixelated Vertical',
        'layerType': 4,
        'palette': [
            0xFFFFFFFF,
            0xFEFEFEFF,
            0xFAFAFAFF,
            0xF3F3F3FF,
            0xEAEAEAFF,
            0xDFDFDFFF,
            0xD2D2D2FF,
            0xC3C3C3FF,
            0xB3B3B3FF,
            0xA2A2A2FF,
            0x919191FF,
            0x808080FF,
            0x6E6E6EFF,
            0x5E5E5EFF,
            0x4E4E4EFF,
            0x404040FF,
            0x333333FF,
            0x272727FF,
            0x1E1E1EFF,
            0x161616FF,
            0x0F0F0FFF,
            0x070707FF,
            0x020202FF,
            0x000000FF
        ]
    },

    {
        'name': 'Smooth Vertical Inverse',
        'layerType': 5,
        'palette': [
            0xFFFFFFFF,
            0xFEFEFEFF,
            0xFAFAFAFF,
            0xF3F3F3FF,
            0xEAEAEAFF,
            0xDFDFDFFF,
            0xD2D2D2FF,
            0xC3C3C3FF,
            0xB3B3B3FF,
            0xA2A2A2FF,
            0x919191FF,
            0x808080FF,
            0x6E6E6EFF,
            0x5E5E5EFF,
            0x4E4E4EFF,
            0x404040FF,
            0x333333FF,
            0x272727FF,
            0x1E1E1EFF,
            0x161616FF,
            0x0F0F0FFF,
            0x070707FF,
            0x020202FF,
            0x000000FF
        ]
    },

    {
        'name': 'Pixelated Vertical Inverse',
        'layerType': 6,
        'palette': [
            0xFFFFFFFF,
            0xFEFEFEFF,
            0xFAFAFAFF,
            0xF3F3F3FF,
            0xEAEAEAFF,
            0xDFDFDFFF,
            0xD2D2D2FF,
            0xC3C3C3FF,
            0xB3B3B3FF,
            0xA2A2A2FF,
            0x919191FF,
            0x808080FF,
            0x6E6E6EFF,
            0x5E5E5EFF,
            0x4E4E4EFF,
            0x404040FF,
            0x333333FF,
            0x272727FF,
            0x1E1E1EFF,
            0x161616FF,
            0x0F0F0FFF,
            0x070707FF,
            0x020202FF,
            0x000000FF
        ]
    },

    {
        'name': 'Smooth Horizontal',
        'layerType': 7,
        'palette': ["#333333", "#cccccc"]
    },

    {
        'name': 'Pixelated Horizontal',
        'layerType': 8,
        'palette': [
            0xFFFFFFFF,
            0xFEFEFEFF,
            0xFAFAFAFF,
            0xF3F3F3FF,
            0xEAEAEAFF,
            0xDFDFDFFF,
            0xD2D2D2FF,
            0xC3C3C3FF,
            0xB3B3B3FF,
            0xA2A2A2FF,
            0x919191FF,
            0x808080FF,
            0x6E6E6EFF,
            0x5E5E5EFF,
            0x4E4E4EFF,
            0x404040FF,
            0x333333FF,
            0x272727FF,
            0x1E1E1EFF,
            0x161616FF,
            0x0F0F0FFF,
            0x070707FF,
            0x020202FF,
            0x000000FF
        ]
    },

    {
        'name': 'Smooth Horizontal Inverse',
        'layerType': 9,
        'palette': ["#333333", "#cccccc"]
    },

    {
        'name': 'Pixelated Horizontal Inverse',
        'layerType': 10,
        'palette': [
            0xFFFFFFFF,
            0xFEFEFEFF,
            0xFAFAFAFF,
            0xF3F3F3FF,
            0xEAEAEAFF,
            0xDFDFDFFF,
            0xD2D2D2FF,
            0xC3C3C3FF,
            0xB3B3B3FF,
            0xA2A2A2FF,
            0x919191FF,
            0x808080FF,
            0x6E6E6EFF,
            0x5E5E5EFF,
            0x4E4E4EFF,
            0x404040FF,
            0x333333FF,
            0x272727FF,
            0x1E1E1EFF,
            0x161616FF,
            0x0F0F0FFF,
            0x070707FF,
            0x020202FF,
            0x000000FF
        ]
    },

    {
        'name': 'Smooth Diagonal',
        'layerType': 11,
        'palette': [
            0xFFFFFFFF,
            0xFEFEFEFF,
            0xFAFAFAFF,
            0xF3F3F3FF,
            0xEAEAEAFF,
            0xDFDFDFFF,
            0xD2D2D2FF,
            0xC3C3C3FF,
            0xB3B3B3FF,
            0xA2A2A2FF,
            0x919191FF,
            0x808080FF,
            0x6E6E6EFF,
            0x5E5E5EFF,
            0x4E4E4EFF,
            0x404040FF,
            0x333333FF,
            0x272727FF,
            0x1E1E1EFF,
            0x161616FF,
            0x0F0F0FFF,
            0x070707FF,
            0x020202FF,
            0x000000FF
        ]
    },

    {
        'name': 'Pixel Diagonal',
        'layerType': 12,
        'palette': [
            0xFFFFFFFF,
            0xFEFEFEFF,
            0xFAFAFAFF,
            0xF3F3F3FF,
            0xEAEAEAFF,
            0xDFDFDFFF,
            0xD2D2D2FF,
            0xC3C3C3FF,
            0xB3B3B3FF,
            0xA2A2A2FF,
            0x919191FF,
            0x808080FF,
            0x6E6E6EFF,
            0x5E5E5EFF,
            0x4E4E4EFF,
            0x404040FF,
            0x333333FF,
            0x272727FF,
            0x1E1E1EFF,
            0x161616FF,
            0x0F0F0FFF,
            0x070707FF,
            0x020202FF,
            0x000000FF
        ]
    },

    {
        'name': 'Smooth Diagonal Inverse',
        'layerType': 13,
        'palette': [
            0xFFFFFFFF,
            0xFEFEFEFF,
            0xFAFAFAFF,
            0xF3F3F3FF,
            0xEAEAEAFF,
            0xDFDFDFFF,
            0xD2D2D2FF,
            0xC3C3C3FF,
            0xB3B3B3FF,
            0xA2A2A2FF,
            0x919191FF,
            0x808080FF,
            0x6E6E6EFF,
            0x5E5E5EFF,
            0x4E4E4EFF,
            0x404040FF,
            0x333333FF,
            0x272727FF,
            0x1E1E1EFF,
            0x161616FF,
            0x0F0F0FFF,
            0x070707FF,
            0x020202FF,
            0x000000FF
        ]
    },

    {
        'name': 'Pixel Diagonal Inverse',
        'layerType': 14,
        'palette': [
            0xFFFFFFFF,
            0xFEFEFEFF,
            0xFAFAFAFF,
            0xF3F3F3FF,
            0xEAEAEAFF,
            0xDFDFDFFF,
            0xD2D2D2FF,
            0xC3C3C3FF,
            0xB3B3B3FF,
            0xA2A2A2FF,
            0x919191FF,
            0x808080FF,
            0x6E6E6EFF,
            0x5E5E5EFF,
            0x4E4E4EFF,
            0x404040FF,
            0x333333FF,
            0x272727FF,
            0x1E1E1EFF,
            0x161616FF,
            0x0F0F0FFF,
            0x070707FF,
            0x020202FF,
            0x000000FF
        ]
    },

    {
        'name': 'Smooth Reverse Diagonal',
        'layerType': 15,
        'palette': [
            0xFFFFFFFF,
            0xFEFEFEFF,
            0xFAFAFAFF,
            0xF3F3F3FF,
            0xEAEAEAFF,
            0xDFDFDFFF,
            0xD2D2D2FF,
            0xC3C3C3FF,
            0xB3B3B3FF,
            0xA2A2A2FF,
            0x919191FF,
            0x808080FF,
            0x6E6E6EFF,
            0x5E5E5EFF,
            0x4E4E4EFF,
            0x404040FF,
            0x333333FF,
            0x272727FF,
            0x1E1E1EFF,
            0x161616FF,
            0x0F0F0FFF,
            0x070707FF,
            0x020202FF,
            0x000000FF
        ]
    },

    {
        'name': 'Pixel Reverse Diagonal',
        'layerType': 16,
        'palette': [
            0xFFFFFFFF,
            0xFEFEFEFF,
            0xFAFAFAFF,
            0xF3F3F3FF,
            0xEAEAEAFF,
            0xDFDFDFFF,
            0xD2D2D2FF,
            0xC3C3C3FF,
            0xB3B3B3FF,
            0xA2A2A2FF,
            0x919191FF,
            0x808080FF,
            0x6E6E6EFF,
            0x5E5E5EFF,
            0x4E4E4EFF,
            0x404040FF,
            0x333333FF,
            0x272727FF,
            0x1E1E1EFF,
            0x161616FF,
            0x0F0F0FFF,
            0x070707FF,
            0x020202FF,
            0x000000FF
        ]
    },

    {
        'name': 'Smooth Reverse Diagonal Inverse',
        'layerType': 17,
        'palette': [
            0xFFFFFFFF,
            0xFEFEFEFF,
            0xFAFAFAFF,
            0xF3F3F3FF,
            0xEAEAEAFF,
            0xDFDFDFFF,
            0xD2D2D2FF,
            0xC3C3C3FF,
            0xB3B3B3FF,
            0xA2A2A2FF,
            0x919191FF,
            0x808080FF,
            0x6E6E6EFF,
            0x5E5E5EFF,
            0x4E4E4EFF,
            0x404040FF,
            0x333333FF,
            0x272727FF,
            0x1E1E1EFF,
            0x161616FF,
            0x0F0F0FFF,
            0x070707FF,
            0x020202FF,
            0x000000FF
        ]
    },

    {
        'name': 'Pixel Reverse Diagonal Inverse',
        'layerType': 18,
        'palette': [
            0xFFFFFFFF,
            0xFEFEFEFF,
            0xFAFAFAFF,
            0xF3F3F3FF,
            0xEAEAEAFF,
            0xDFDFDFFF,
            0xD2D2D2FF,
            0xC3C3C3FF,
            0xB3B3B3FF,
            0xA2A2A2FF,
            0x919191FF,
            0x808080FF,
            0x6E6E6EFF,
            0x5E5E5EFF,
            0x4E4E4EFF,
            0x404040FF,
            0x333333FF,
            0x272727FF,
            0x1E1E1EFF,
            0x161616FF,
            0x0F0F0FFF,
            0x070707FF,
            0x020202FF,
            0x000000FF
        ]
    },

    {
        'name': 'Radial',
        'layerType': 19,
        'palette': [
            0xFFFFFFFF,
            0x000000FF
        ]
    },
]


def parse_color(color):
    if isinstance(color, str):
        color = color.replace('#', '').replace('0x', '')
        if len(color) == 6:
            color += 'ff'
        return int(color, 16)
    return color


def get_gradient_coords(layer_type):
    # Maps layer types to SVG gradient vector coordinates (x1, y1, x2, y2).
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


def encode_background_group():
    output = bytearray()

    # 1. Group Name
    name_bytes = GROUP_NAME.encode('utf-8')
    output.append(len(name_bytes))
    output.extend(name_bytes)

    # 2. Unified Palette
    all_colors = []
    for bg in BACKGROUNDS:
        all_colors.extend([parse_color(c) for c in bg['palette']])

    unified_palette = []
    seen = set()
    for color in all_colors:
        if color not in seen:
            unified_palette.append(color)
            seen.add(color)

    # Palette Size (2 bytes) + Colors (4 bytes each)
    output.extend(struct.pack('>H', len(unified_palette)))
    for color in unified_palette:
        output.extend([(color >> 24) & 0xFF, (color >> 16) &
                      0xFF, (color >> 8) & 0xFF, color & 0xFF])

    # 3. Metadata
    index_bytes = 2 if len(unified_palette) > 255 else 1
    output.append(index_bytes)
    output.append(len(BACKGROUNDS))

    # 4. Trait Encoding Loop
    color_to_index = {color: idx for idx, color in enumerate(unified_palette)}

    for bg in BACKGROUNDS:
        bg_name = bg['name'].encode('utf-8')
        layer_type = bg['layerType']
        bg_colors = [parse_color(c) for c in bg['palette']]
        coords = get_gradient_coords(layer_type)

        trait_data = bytearray()

        # --- LOGIC ALIGNMENT WITH TRAITSLOADER ---
        # "Fast Path": Only write indices. No RLE headers.
        if layer_type == BG_TYPE_SOLID:
            if bg_colors:
                idx = color_to_index[bg_colors[0]]
                if index_bytes == 2:
                    trait_data.extend(struct.pack('>H', idx))
                else:
                    trait_data.append(idx)
        elif layer_type == BG_TYPE_IMAGE:
            pass
        else:
            # Gradient: Sequence of indices
            for color in bg_colors:
                idx = color_to_index[color]
                if index_bytes == 2:
                    trait_data.extend(struct.pack('>H', idx))
                else:
                    trait_data.append(idx)

        # Header: [pixelCount:2][x1:1][y1:1][x2:1][y2:1][layerType:1][nameLen:1]
        # For backgrounds, pixelCount = number of stops (or 1 for solid)
        stop_count = len(bg_colors) if layer_type != BG_TYPE_IMAGE else 0

        output.extend(struct.pack('>H', stop_count))
        output.extend([
            coords[0], coords[1], coords[2], coords[3],
            layer_type,
            len(bg_name)
        ])

        output.extend(bg_name)
        output.extend(trait_data)

    return bytes(output)


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    print(f"Generating Background Asset Group...")

    data = encode_background_group()

    if data:
        hex_string = "0x" + data.hex()
        final_path = os.path.join(OUTPUT_DIR, COMBINED_FILENAME)

        with open(final_path, 'w') as f:
            f.write(f"{GROUP_NAME}: {hex_string}\n")

        print(f"\n✓ Success! Asset saved to: {final_path}")
        print(f"  Binary Size: {len(data)} bytes")
        print(f"  Hex Length:  {len(hex_string)} chars")

        # VISUAL VERIFICATION
        print("\n[IMPORTANT] Verify the start of your hex string:")
        print(
            f"  Should start with 0a (len=10) and 42 ('B'): 0x{data.hex()[:20]}...")
        if data.hex().startswith("0a42"):
            print("  ✓ HEADER LOOKS CORRECT.")
        else:
            print("  X HEADER LOOKS WRONG. Check your group name length.")


if __name__ == '__main__':
    main()
