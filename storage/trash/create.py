import os
import struct
from PIL import Image

def pack_le2(v):
    return struct.pack('<H', v)

def hex_to_rgba(hex_str):
    hex_str = hex_str.lstrip('#')
    r = int(hex_str[0:2], 16)
    g = int(hex_str[2:4], 16)
    b = int(hex_str[4:6], 16)
    a = int(hex_str[6:8], 16) if len(hex_str) == 8 else 255
    return r, g, b, a

def rgba_to_hex(r, g, b, a):
    return f'#{r:02x}{g:02x}{b:02x}{a:02x}'

base_dir = '/Users/mani/Downloads/RPNKSLab/traitsColor'

trait_groups = [
    {'index': 2, 'name': 'Male Skin', 'dir': os.path.join(base_dir, 'Male Skin')},
    {'index': 3, 'name': 'Male Eyes', 'dir': os.path.join(base_dir, 'Male Eyes')},
    {'index': 4, 'name': 'Male Face', 'dir': os.path.join(base_dir, 'Male Face')},
    {'index': 5, 'name': 'Male Chain', 'dir': os.path.join(base_dir, 'Male Chain')},
    {'index': 6, 'name': 'Male Earring', 'dir': os.path.join(base_dir, 'Male Earring')},
    {'index': 7, 'name': 'Male Facial Hair', 'dir': os.path.join(base_dir, 'Male Facial Hair')},
    {'index': 8, 'name': 'Male Mask', 'dir': os.path.join(base_dir, 'Male Mask')},
    {'index': 9, 'name': 'Male Scarf', 'dir': os.path.join(base_dir, 'Male Scarf')},
    {'index': 10, 'name': 'Male Hair', 'dir': os.path.join(base_dir, 'Male Hair')},
    {'index': 11, 'name': 'Male Hat Hair', 'dir': os.path.join(base_dir, 'Male Hat Hair')},
    {'index': 12, 'name': 'Male Headwear', 'dir': os.path.join(base_dir, 'Male Headwear')},
    {'index': 13, 'name': 'Male Eye Wear', 'dir': os.path.join(base_dir, 'Male Eye Wear')},
    {'index': 14, 'name': 'Female Skin', 'dir': os.path.join(base_dir, 'Female Skin')},
    {'index': 15, 'name': 'Female Eyes', 'dir': os.path.join(base_dir, 'Female Eyes')},
    {'index': 16, 'name': 'Female Face', 'dir': os.path.join(base_dir, 'Female Face')},
    {'index': 17, 'name': 'Female Chain', 'dir': os.path.join(base_dir, 'Female Chain')},
    {'index': 18, 'name': 'Female Earring', 'dir': os.path.join(base_dir, 'Female Earring')},
    {'index': 19, 'name': 'Female Mask', 'dir': os.path.join(base_dir, 'Female Mask')},
    {'index': 20, 'name': 'Female Scarf', 'dir': os.path.join(base_dir, 'Female Scarf')},
    {'index': 21, 'name': 'Female Hair', 'dir': os.path.join(base_dir, 'Female Hair')},
    {'index': 22, 'name': 'Female Hat Hair', 'dir': os.path.join(base_dir, 'Female Hat Hair')},
    {'index': 23, 'name': 'Female Headwear', 'dir': os.path.join(base_dir, 'Female Headwear')},
    {'index': 24, 'name': 'Female Eye Wear', 'dir': os.path.join(base_dir, 'Female Eye Wear')},
    {'index': 25, 'name': 'Mouth', 'dir': os.path.join(base_dir, 'Mouth')},
    {'index': 26, 'name': 'Filler Traits', 'dir': os.path.join(base_dir, 'Filler Traits')},
]

generated_assets = []

for group in trait_groups:
    gname = group['name']
    gdir = group['dir']
    traits_data = [] 
    global_palette_set = set()
    global_palette_set.add("#00000000") 

    if os.path.exists(gdir):
        for fname in os.listdir(gdir):
            if fname.endswith('.png'):
                tname = fname[:-4].replace('_', ' ')
                img = Image.open(os.path.join(gdir, fname)).convert('RGBA')
                width, height = img.size
                minx, miny, maxx, maxy = width, height, -1, -1
                raw_pixels = img.load()
                has_pixels = False

                for y in range(height):
                    for x in range(width):
                        r, g, b, a = raw_pixels[x, y]
                        if a > 0:
                            has_pixels = True
                            if x < minx: minx = x
                            if y < miny: miny = y
                            if x > maxx: maxx = x
                            if y > maxy: maxy = y
                            global_palette_set.add(rgba_to_hex(r, g, b, a))

                if has_pixels:
                    traits_data.append({
                        'name': tname, 'img': img,
                        'x1': minx, 'y1': miny, 'x2': maxx, 'y2': maxy,
                        'bgTypeIndex': 0, 'bgAssetKey': 0
                    })

    # Build Palette
    sorted_colors = sorted(list(global_palette_set))
    if "#00000000" in sorted_colors: sorted_colors.remove("#00000000")
    palette = ["#00000000"] + sorted_colors
    color_to_index = {c: i for i, c in enumerate(palette)}
    num_colors = len(palette)
    index_byte_size = 2 if num_colors > 255 else 1

    # SERIALIZATION
    data = bytearray()
    
    # 1. Group Name
    name_b = gname.encode('utf-8')
    data.append(len(name_b))
    data.extend(name_b)
    
    # 2. Palette (Matches decodeTraitGroupPalette)
    data.extend(pack_le2(num_colors))
    for hex_code in palette:
        r, g, b, a = hex_to_rgba(hex_code)
        # We pack as 4 bytes: A, R, G, B
        # Solidity reads +2, +3, +4, +5 for the first color
        data.extend([a, r, g, b])
        
    # 3. Metadata
    data.append(index_byte_size)
    data.append(len(traits_data))
    
    traits_data.sort(key=lambda x: x['name'])

    for tinfo in traits_data:
        width_bb = tinfo['x2'] - tinfo['x1'] + 1
        height_bb = tinfo['y2'] - tinfo['y1'] + 1
        pixel_count = width_bb * height_bb 

        data.extend(pack_le2(pixel_count))
        data.append(tinfo['x1'])
        data.append(tinfo['y1'])
        data.append(tinfo['x2'])
        data.append(tinfo['y2'])
        data.append(tinfo['bgTypeIndex'])
        data.append(tinfo['bgAssetKey'])
        
        tname_b = tinfo['name'].encode('utf-8')
        data.append(len(tname_b))
        data.extend(tname_b)
        
        img = tinfo['img']
        raw_pixels = img.load()
        
        # 1. Flatten all pixels in the bounding box into a simple list
        # Note: We loop Y then X to stay consistent with your current Solidity logic
        pixel_indices = []
        # Row-Major: Y loop on the outside, X loop on the inside
        for y in range(tinfo['y1'], tinfo['y2'] + 1):
            for x in range(tinfo['x1'], tinfo['x2'] + 1):
                r, g, b, a = raw_pixels[x, y]
                idx = 0 if a == 0 else color_to_index[rgba_to_hex(r, g, b, a)]
                pixel_indices.append(idx)

        # 2. Compress those indices into (RunLength, ColorIndex) pairs
        if pixel_indices:
            current_idx = pixel_indices[0]
            run_length = 0
            
            for idx in pixel_indices:
                # Max run length is 255 (1 byte)
                if idx == current_idx and run_length < 255:
                    run_length += 1
                else:
                    # Record the finished run
                    data.append(run_length)
                    if index_byte_size == 1:
                        data.append(current_idx)
                    else:
                        data.extend(struct.pack('<H', current_idx))
                    
                    # Start new run
                    current_idx = idx
                    run_length = 1
            
            # Don't forget the very last run
            data.append(run_length)
            if index_byte_size == 1:
                data.append(current_idx)
            else:
                data.extend(struct.pack('<H', current_idx))

    generated_assets.append({'name': gname, 'data': data})
    print(f"Processed {gname}")

# --- Output Files ---

output_file = "assets_output.txt"
with open(output_file, "w") as f:
    for asset in generated_assets:
        f.write(f"{asset['name']}: 0x{asset['data'].hex()}\n\n")

# FIXED: Use double curly braces for literal Solidity code
sol_template = """// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {{ Script }} from "forge-std/Script.sol";
import {{ Assets }} from "../src/Assets.sol";
import {{ LibZip }} from "./libraries/LibZip.sol";

contract AddAssetsBatch is Script {{
    function run() external {{
        address assetsAddr = 0x0000000000000000000000000000000000000000;
        uint256 startKey = 2;
        Assets assets = Assets(assetsAddr);

        vm.startBroadcast();

{asset_assignments}
        vm.stopBroadcast();
    }}
}}
"""

asset_assignments = ""
for i, asset in enumerate(generated_assets):
    var_name = asset['name'].replace(' ', '_')
    hex_str = asset['data'].hex()
    asset_assignments += f"        // {asset['name']}\n"
    asset_assignments += f"        bytes memory {var_name}_raw = hex\"{hex_str}\";\n"
    asset_assignments += f"        assets.addAsset(startKey + {i}, LibZip.flzCompress({var_name}_raw));\n\n"

sol_code = sol_template.format(asset_assignments=asset_assignments)

sol_output_file = "script/AddAssetsBatch.s.sol"
os.makedirs(os.path.dirname(sol_output_file), exist_ok=True)
with open(sol_output_file, "w") as f:
    f.write(sol_code)

print(f"\nSuccess! Solidity script written to {sol_output_file}")