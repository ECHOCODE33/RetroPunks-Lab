import os
import struct
from PIL import Image

# --- Helper Functions ---

def pack_le2(v):
    """Pack a 2-byte integer (little-endian)."""
    return struct.pack('<H', v)

def unpack_le2(b):
    """Unpack a 2-byte integer (little-endian)."""
    return struct.unpack('<H', b)[0]

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


# --- NEW DECODING FUNCTION (Mirrors TraitsLoader.sol) ---

def decode_trait_group(encoded_data, trait_group_index):
    """
    Decodes the raw byte data into a Python object mirroring the Solidity TraitGroup struct.
    This simulates the logic in TraitsLoader.loadAndCacheTraitGroup.
    """
    
    data = encoded_data
    index = 0
    trait_group = {
        'traitGroupIndex': trait_group_index,
        'traitGroupName': "",
        'paletteRgba': [],
        'traits': []
    }

    # 1. Decode Trait Group Name (decodeTraitGroupName)
    trait_name_length = data[index]
    index += 1
    trait_group['traitGroupName'] = data[index : index + trait_name_length].decode('utf-8')
    index += trait_name_length

    # 2. Decode Palette Size and Colors (decodeTraitGroupPalette)
    # The Solidity function reads two bytes, little-endian
    palette_size = unpack_le2(data[index : index + 2])
    index += 2

    palette_rgba = []
    for i in range(palette_size):
        # Solidity reads: [A, R, G, B] bytes and packs into a uint32 ARGB
        a = data[index]
        r = data[index + 1]
        g = data[index + 2]
        b = data[index + 3]
        
        # Simulating Solidity's uint32 ARGB packing:
        # uint32(A) << 24 | uint32(R) << 16 | uint32(G) << 8 | uint32(B)
        uint32_rgba = (a << 24) | (r << 16) | (g << 8) | b
        palette_rgba.append(f'0x{uint32_rgba:08x}')
        
        index += 4
    
    trait_group['paletteRgba'] = palette_rgba
    
    # 3. Decode Index Byte Size Flag
    index_byte_size = data[index]
    index += 1
    trait_group['indexByteSize'] = index_byte_size

    # 4. Decode Trait Count
    trait_count = data[index]
    index += 1
    
    # 5. Decode Traits
    for i in range(trait_count):
        trait_info = {}
        
        # Trait Pixel Count (2 bytes, little-endian)
        trait_pixel_count = unpack_le2(data[index : index + 2])
        index += 2

        # Bounding Box and BG info (6 single bytes)
        trait_info['x1'] = data[index]; index += 1
        trait_info['y1'] = data[index]; index += 1
        trait_info['x2'] = data[index]; index += 1
        trait_info['y2'] = data[index]; index += 1
        trait_info['bgTypeIndex'] = data[index]; index += 1
        trait_info['bgAssetKey'] = data[index]; index += 1

        # Trait Name
        trait_name_length = data[index]
        index += 1
        trait_info['traitName'] = data[index : index + trait_name_length].decode('utf-8')
        index += trait_name_length
        
        # Trait Data (Color indices)
        trait_data_byte_length = trait_pixel_count * index_byte_size
        trait_data = data[index : index + trait_data_byte_length].hex()
        index += trait_data_byte_length

        trait_info['pixelCount'] = trait_pixel_count
        trait_info['traitDataHex'] = trait_data
        
        trait_group['traits'].append(trait_info)

    return trait_group


# --- Configuration ---

# IMPORTANT: Ensure these paths exist on your system
# NOTE: Using a placeholder directory structure for execution.
#       You will need to set this to a real path for the script to read files.
base_dir = os.path.join(os.getcwd(), '/Users/echo/Downloads/RPNKSLab/traitsColor')

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

print("--- Running Traits Encoder and Decoder Simulation ---")
print(f"Base Directory: {base_dir}")

generated_assets = []

# --- Create dummy directories and files if they don't exist for a safe run ---
if not os.path.exists(base_dir):
    os.makedirs(os.path.join(base_dir, 'Male Skin'), exist_ok=True)
    os.makedirs(os.path.join(base_dir, 'Male Eyes'), exist_ok=True)
    os.makedirs(os.path.join(base_dir, 'Mouth'), exist_ok=True)
    # Create a minimal dummy PNG for testing
    dummy_img = Image.new('RGBA', (48, 48), color = (0, 0, 0, 0))
    dummy_img.putpixel((10, 10), (255, 0, 0, 255))
    dummy_img.putpixel((11, 11), (0, 255, 0, 255))
    dummy_img.save(os.path.join(base_dir, 'Male Skin', 'Tan Skin.png'))
    dummy_img.putpixel((10, 10), (0, 0, 0, 0))
    dummy_img.putpixel((12, 12), (0, 0, 255, 255))
    dummy_img.save(os.path.join(base_dir, 'Male Eyes', 'Blue Eyes.png'))
# --------------------------------------------------------------------------

for group in trait_groups:
    gname = group['name']
    traits = {} 

    # 1. Collect Traits (Skipping manual_background/overrides for brevity)
    gdir = group['dir']
    if os.path.exists(gdir):
        for fname in os.listdir(gdir):
            if fname.endswith('.png'):
                tname = fname[:-4].replace('_', ' ')
                try:
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
                            'bgTypeIndex': 0, 'bgAssetKey': 0,
                            'x1': minx, 'y1': miny, 'x2': maxx, 'y2': maxy,
                            'pixel_colors': pixel_colors
                        }
                except Exception as e:
                    print(f"Error processing image {fname}: {e}")
    
    if not traits:
        print(f"Warning: No traits found for group '{gname}' in {gdir}")
        continue

    # 2. Build Global Palette
    all_colors_set = set()
    for tinfo in traits.values():
        all_colors_set.update(tinfo['pixel_colors'])
    
    palette = sorted(list(all_colors_set))
    color_to_index = {c: i for i, c in enumerate(palette)}
    num_colors = len(palette)
    index_byte_size = 2 if num_colors > 255 else 1

    # 3. Serialize Data (Python Encoder)
    data = bytearray()
    
    # A. Group Name
    name_b = gname.encode('utf-8')
    data.append(len(name_b))
    data.extend(name_b)
    
    # B. Palette Size & Colors
    data.extend(pack_le2(num_colors))
    for hex_code in palette:
        r, g, b, a = hex_to_rgba(hex_code)
        # ARGB format for Solidity's uint32 packing
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
        data.append(tinfo['x1']); data.append(tinfo['y1']); 
        data.append(tinfo['x2']); data.append(tinfo['y2'])
        data.append(tinfo['bgTypeIndex']); data.append(tinfo['bgAssetKey'])
        
        tname_b = tname.encode('utf-8')
        data.append(len(tname_b))
        data.extend(tname_b)
        
        for pc in tinfo['pixel_colors']:
            idx = color_to_index[pc]
            if index_byte_size == 1:
                data.append(idx)
            else:
                data.extend(pack_le2(idx))
    
    # 4. DECODE AND PRINT (Simulation of Solidity TraitGroup)
    decoded_group = decode_trait_group(data, group['index'])
    
    print("\n" + "="*50)
    print(f"| Trait Group Data - {decoded_group['traitGroupName']} (Index {decoded_group['traitGroupIndex']})")
    print("="*50)
    print(f"Group Name: {decoded_group['traitGroupName']}")
    print(f"Total Colors (Palette Size): {len(decoded_group['paletteRgba'])}")
    print(f"Index Byte Size: {decoded_group['indexByteSize']} byte(s)")
    print(f"Total Traits: {len(decoded_group['traits'])}")
    print("-" * 50)
    
    # Print Palette Info
    print(f"Palette (First 5 of {len(decoded_group['paletteRgba'])}):")
    for i, color in enumerate(decoded_group['paletteRgba'][:5]):
        print(f"  [{i:02d}]: {color}")

    # Print Trait Info
    print("\nTraits:")
    for trait in decoded_group['traits']:
        print(f"  - Name: {trait['traitName']}")
        print(f"    Bounds: ({trait['x1']},{trait['y1']}) to ({trait['x2']},{trait['y2']})")
        print(f"    Pixels: {trait['pixelCount']} pixels")
        print(f"    Data (Hex): 0x{trait['traitDataHex'][:60]}... ({len(trait['traitDataHex'])//2} bytes)")
    
    print("="*50 + "\n")


print("\nSuccess! Decoded trait group data printed to the terminal.")
print("The decoded structure should directly map to the fields in your Solidity `TraitGroup` struct.")