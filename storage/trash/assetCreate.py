import os
import struct
from PIL import Image

# --- Helper Functions ---

def pack_le2(v):
    """Pack a 2-byte integer (little-endian)."""
    return struct.pack('<H', v)

def hex_to_rgba(hex_str):
    """Convert hex string (#RRGGBBAA or #RRGGBB) to (r, g, b, a) tuple."""
    hex_str = hex_str.lstrip('#')
    if len(hex_str) not in (6, 8):
        raise ValueError(f"Invalid hex: {hex_str}")
    r = int(hex_str[0:2], 16)
    g = int(hex_str[2:4], 16)
    b = int(hex_str[4:6], 16)
    a = int(hex_str[6:8], 16) if len(hex_str) == 8 else 255
    return r, g, b, a

def rgba_to_hex(r, g, b, a):
    return f'#{r:02x}{g:02x}{b:02x}{a:02x}'

def generate_gradient(input_colors, n):
    """Generates a list of n hex colors forming a gradient."""
    if not input_colors: raise ValueError("No colors provided")
    k = len(input_colors)
    if k == 1: return [input_colors[0]] * n
    
    positions = [round(i * (n - 1) / (k - 1)) for i in range(k)]
    gradient = [None] * n
    for i in range(k): gradient[positions[i]] = input_colors[i]
        
    for s in range(k - 1):
        start_pos, end_pos = positions[s], positions[s + 1]
        start_rgba, end_rgba = hex_to_rgba(input_colors[s]), hex_to_rgba(input_colors[s + 1])
        for j in range(start_pos + 1, end_pos):
            frac = (j - start_pos) / (end_pos - start_pos)
            new_r = round(start_rgba[0] + frac * (end_rgba[0] - start_rgba[0]))
            new_g = round(start_rgba[1] + frac * (end_rgba[1] - start_rgba[1]))
            new_b = round(start_rgba[2] + frac * (end_rgba[2] - start_rgba[2]))
            new_a = round(start_rgba[3] + frac * (end_rgba[3] - start_rgba[3]))
            gradient[j] = rgba_to_hex(new_r, new_g, new_b, new_a)
    return gradient

# --- Configuration ---

# IMPORTANT: Ensure these paths exist on your system
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

manual_background = False
manual_bg_slots = []
overrides = {}

# --- Main Processing ---

generated_assets = []

for group in trait_groups:
    gname = group['name']
    traits = {} 

    # 1. Collect Traits
    if gname == 'Background_Group' and manual_background:
        for slot in manual_bg_slots:
            tname = slot['traitName']
            pixel_colors = generate_gradient(slot['colors'], slot['steps'])
            traits[tname] = {
                'bgTypeIndex': slot['bgTypeIndex'],
                'bgAssetKey': slot['bgAssetKey'],
                'x1': slot.get('x1', 0), 'y1': slot.get('y1', 0),
                'x2': slot.get('x2', 47), 'y2': slot.get('y2', 47),
                'pixel_colors': pixel_colors
            }
    else:
        gdir = group['dir']
        if os.path.exists(gdir):
            for fname in os.listdir(gdir):
                if fname.endswith('.png'):
                    tname = fname[:-4].replace('_', ' ')
                    img = Image.open(os.path.join(gdir, fname)).convert('RGBA')
                    width, height = img.size
                    
                    minx, miny, maxx, maxy = 48, 48, -1, -1
                    pixel_colors = []
                    raw_pixels = list(img.getdata())
                    
                    for i, p in enumerate(raw_pixels):
                        r, g, b, a = p
                        if a > 0:
                            x = i % width
                            y = i // width
                            pixel_colors.append(rgba_to_hex(r, g, b, a))
                            if x < minx: minx = x
                            if y < miny: miny = y
                            if x > maxx: maxx = x
                            if y > maxy: maxy = y
                            
                    if pixel_colors:
                        traits[tname] = {
                            'bgTypeIndex': 0,
                            'bgAssetKey': 0,
                            'x1': minx, 'y1': miny, 'x2': maxx, 'y2': maxy,
                            'pixel_colors': pixel_colors
                        }
        else:
            print(f"Directory not found: {gdir}")

    # 2. Apply Overrides
    for ov_name, ov_info in overrides.items():
        if ov_info.get('traitGroup') == gname:
            tinfo = ov_info.copy()
            traits[ov_name] = tinfo

    if not traits:
        print(f"Warning: No traits found for group '{gname}'")
        continue

    # 3. Build Global Palette (Only RGBA bytes)
    all_colors_set = set()
    for tinfo in traits.values():
        all_colors_set.update(tinfo['pixel_colors'])
    
    palette = sorted(list(all_colors_set))
    color_to_index = {c: i for i, c in enumerate(palette)}
    num_colors = len(palette)
    index_byte_size = 2 if num_colors > 255 else 1

    # 4. Serialize Data (NO COMPRESSION)
    data = bytearray()
    
    # A. Group Name
    name_b = gname.encode('utf-8')
    data.append(len(name_b))
    data.extend(name_b)
    
    # B. Palette Size & Colors
    data.extend(pack_le2(num_colors))
    for hex_code in palette:
        r, g, b, a = hex_to_rgba(hex_code)
        data.extend([a, r, g, b])
        
    # C. Index Size Flag
    data.append(index_byte_size)
    
    # D. Trait Count
    trait_list = sorted(traits.items())
    data.append(len(trait_list))
    
    # E. Traits Data
    for tname, tinfo in trait_list:
        pixel_count = len(tinfo['pixel_colors'])
        data.extend(pack_le2(pixel_count))
        data.append(tinfo['x1'])
        data.append(tinfo['y1'])
        data.append(tinfo['x2'])
        data.append(tinfo['y2'])
        data.append(tinfo['bgTypeIndex'])
        data.append(tinfo['bgAssetKey'])
        
        tname_b = tname.encode('utf-8')
        data.append(len(tname_b))
        data.extend(tname_b)
        
        for pc in tinfo['pixel_colors']:
            idx = color_to_index[pc]
            if index_byte_size == 1:
                data.append(idx)
            else:
                data.extend(pack_le2(idx))

    # NO COMPRESSION STEP HERE
    # We directly use the raw `data` bytearray
    
    generated_assets.append({
        'name': gname,
        'data': data  # Store raw bytes
    })
    
    print(f"Processed {gname}: {len(trait_list)} traits, {num_colors} colors (Uncompressed).")

# --- Output to File ---

output_file = "assets_output.txt"
with open(output_file, "w") as f:
    for asset in generated_assets:
        hex_string = asset['data'].hex()
        f.write(f"{asset['name']}: 0x{hex_string}\n\n")

print(f"\nSuccess! Uncompressed assets written to {output_file}")