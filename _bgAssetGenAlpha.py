#!/usr/bin/env python3
import os
import struct

# ============================================================================
# CONFIGURATION
# ============================================================================
OUTPUT_DIR = "output"
COMBINED_FILENAME = "background_trait_hex.txt" # // NEW: Specific output file
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
    {'name': 'Rainbow', 'layerType': 1, 'palette': []},
    {'name': 'Red Solid', 'layerType': 2, 'palette': ["#f24e4e"]},
    {'name': 'Smooth Vertical', 'layerType': 3, 'palette': ["#000000", "#ffffff"]},
    {'name': 'Smooth Horizontal', 'layerType': 7, 'palette': ["#333333", "#cccccc"]},
    {'name': 'Diagonal Gradient', 'layerType': 11, 'palette': ["#ff0000", "#00ff00", "#0000ff"]},
]

# ============================================================================
# UTILITIES
# ============================================================================

def parse_color(color):
    if isinstance(color, str):
        color = color.replace('#', '').replace('0x', '')
        if len(color) == 6: color += 'ff'
        return int(color, 16)
    return color

def get_gradient_coords(layer_type):
    """
    Maps layer types to SVG gradient vector coordinates.
    Standard: (x1, y1, x2, y2)
    """
    coords_map = {
        3:  (0, 0, 0, 1), # Vertical
        7:  (0, 0, 1, 0), # Horizontal
        11: (0, 0, 1, 1), # Diagonal
    }
    return coords_map.get(layer_type, (0, 0, 0, 0))

# ============================================================================
# ENCODING ENGINE
# ============================================================================

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
        output.extend([(color >> 24) & 0xFF, (color >> 16) & 0xFF, (color >> 8) & 0xFF, color & 0xFF])

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

        # Gradient stops are RLE runs of 1
        rle_data = bytearray()
        for color in bg_colors:
            rle_data.append(1) # Run Length
            idx = color_to_index[color]
            if index_bytes == 2:
                rle_data.extend(struct.pack('>H', idx))
            else:
                rle_data.append(idx)

        # // NEW: Header alignment to match TraitsLoader structure:
        # [pixelCount:2][x1:1][y1:1][x2:1][y2:1][layerType:1][nameLen:1]
        output.extend(struct.pack('>H', len(bg_colors))) # pixelCount = stopCount
        output.extend([coords[0], coords[1], coords[2], coords[3], layer_type, len(bg_name)])
        
        output.extend(bg_name)
        output.extend(rle_data)

    return bytes(output)

# ============================================================================
# MAIN
# ============================================================================

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    print(f"Generating Background Asset...")

    data = encode_background_group()
    
    if data:
        hex_string = "0x" + data.hex()
        final_path = os.path.join(OUTPUT_DIR, COMBINED_FILENAME)
        
        with open(final_path, 'w') as f:
            f.write(f"{GROUP_NAME}: {hex_string}\n")
            
        print(f"\n✓ Success! Asset saved to: {final_path}")
        print(f"  Binary Size: {len(data)} bytes")
        print(f"  Hex Length:  {len(hex_string)} chars")

if __name__ == '__main__':
    main()