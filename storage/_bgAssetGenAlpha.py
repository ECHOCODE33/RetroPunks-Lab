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
BG_TYPE_GRADIENT = 11 # Using 11 as generic gradient for this example config

BACKGROUNDS = [
    {'name': 'Rainbow', 'layerType': 1, 'palette': []},
    {'name': 'Red Solid', 'layerType': 2, 'palette': ["#f24e4e"]},
    {'name': 'Smooth Vertical', 'layerType': 3, 'palette': ["#000000", "#ffffff"]},
    {'name': 'Smooth Horizontal', 'layerType': 7, 'palette': ["#333333", "#cccccc"]},
    {'name': 'Diagonal Gradient', 'layerType': 11, 'palette': ["#ff0000", "#00ff00", "#0000ff"]},
]

def parse_color(color):
    if isinstance(color, str):
        color = color.replace('#', '').replace('0x', '')
        if len(color) == 6: color += 'ff'
        return int(color, 16)
    return color

def get_gradient_coords(layer_type):
    # Maps layer types to SVG gradient vector coordinates (x1, y1, x2, y2).
    coords_map = {
        3:  (0, 0, 0, 1), # Vertical
        7:  (0, 0, 1, 0), # Horizontal
        11: (0, 0, 1, 1), # Diagonal
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
        print(f"  Should start with 0a (len=10) and 42 ('B'): 0x{data.hex()[:20]}...")
        if data.hex().startswith("0a42"):
            print("  ✓ HEADER LOOKS CORRECT.")
        else:
            print("  X HEADER LOOKS WRONG. Check your group name length.")

if __name__ == '__main__':
    main()