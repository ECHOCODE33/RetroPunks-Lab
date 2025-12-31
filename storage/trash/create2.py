import os
import struct
from PIL import Image

# ============================================================================
# ENCODING UTILITIES
# ============================================================================

def pack_le2(v):
    """Pack unsigned 16-bit integer as little-endian bytes."""
    return struct.pack('<H', v)

def pack_le4(v):
    """Pack unsigned 32-bit integer as little-endian bytes."""
    return struct.pack('<I', v)

def rgba_to_argb_uint32(r, g, b, a):
    """
    Convert RGBA components to packed ARGB uint32.
    Format: 0xAARRGGBB (matches Solidity's uint32 packing)
    """
    return (a << 24) | (r << 16) | (g << 8) | b

def argb_uint32_to_rgba(packed):
    """Unpack ARGB uint32 back to RGBA components."""
    a = (packed >> 24) & 0xFF
    r = (packed >> 16) & 0xFF
    g = (packed >> 8) & 0xFF
    b = packed & 0xFF
    return r, g, b, a

# ============================================================================
# RLE COMPRESSION
# ============================================================================

def compress_pixels_rle(pixel_indices):
    """
    Compress pixel indices using Run-Length Encoding.
    
    Optimization: Transparent pixels (index 0) get special treatment
    to maximize compression. Non-transparent runs are limited to 255.
    
    Returns: List of (run_length, color_index) tuples
    """
    if not pixel_indices:
        return []
    
    compressed = []
    current_idx = pixel_indices[0]
    run_length = 0
    
    for idx in pixel_indices:
        # Check if we can continue the current run
        if idx == current_idx and run_length < 255:
            run_length += 1
        else:
            # Save the completed run
            compressed.append((run_length, current_idx))
            
            # Start new run
            current_idx = idx
            run_length = 1
    
    # Don't forget the final run
    compressed.append((run_length, current_idx))
    
    return compressed

def serialize_rle_data(compressed_runs, index_byte_size):
    """
    Serialize compressed RLE data to bytes.
    
    Format: [runLength(1B), colorIndex(1B or 2B)] repeated
    """
    data = bytearray()
    for run_length, color_idx in compressed_runs:
        data.append(run_length)
        if index_byte_size == 1:
            data.append(color_idx)
        else:
            data.extend(struct.pack('<H', color_idx))
    return data

# ============================================================================
# IMAGE PROCESSING
# ============================================================================

def extract_bounding_box(img):
    """
    Find the minimal bounding box containing all non-transparent pixels.
    
    Returns: (minx, miny, maxx, maxy) or None if image is fully transparent
    """
    width, height = img.size
    raw_pixels = img.load()
    
    minx, miny, maxx, maxy = width, height, -1, -1
    has_pixels = False
    
    for y in range(height):
        for x in range(width):
            r, g, b, a = raw_pixels[x, y]
            if a > 0:
                has_pixels = True
                minx = min(minx, x)
                miny = min(miny, y)
                maxx = max(maxx, x)
                maxy = max(maxy, y)
    
    return (minx, miny, maxx, maxy) if has_pixels else None

def extract_palette(img, bbox):
    """
    Extract all unique ARGB colors from image within bounding box.
    
    Returns: Set of ARGB uint32 values
    """
    if bbox is None:
        return set()
    
    minx, miny, maxx, maxy = bbox
    raw_pixels = img.load()
    palette = set()
    
    for y in range(miny, maxy + 1):
        for x in range(minx, maxx + 1):
            r, g, b, a = raw_pixels[x, y]
            palette.add(rgba_to_argb_uint32(r, g, b, a))
    
    return palette

def flatten_pixels_row_major(img, bbox):
    """
    Flatten pixels in row-major order (Y outer, X inner).
    This matches the Solidity rendering loop.
    
    Returns: List of ARGB uint32 values
    """
    minx, miny, maxx, maxy = bbox
    raw_pixels = img.load()
    pixels = []
    
    # Row-major: iterate Y first, then X
    for y in range(miny, maxy + 1):
        for x in range(minx, maxx + 1):
            r, g, b, a = raw_pixels[x, y]
            pixels.append(rgba_to_argb_uint32(r, g, b, a))
    
    return pixels

# ============================================================================
# TRAIT SERIALIZATION
# ============================================================================

def serialize_trait_group(group_name, traits_data):
    """
    Serialize a complete trait group to binary format.
    
    Format:
    1. Group name (1B length + UTF-8 bytes)
    2. Palette (2B count + 4B per color as ARGB)
    3. Index byte size (1B: 1 or 2)
    4. Trait count (1B)
    5. For each trait:
       - Pixel count (2B)
       - Bounding box (4B: x1, y1, x2, y2)
       - Background metadata (2B: bgTypeIndex, bgAssetKey)
       - Trait name (1B length + UTF-8 bytes)
       - RLE compressed pixel data
    """
    data = bytearray()
    
    # === SECTION 1: Group Name ===
    name_bytes = group_name.encode('utf-8')
    data.append(len(name_bytes))
    data.extend(name_bytes)
    
    # === SECTION 2: Build Global Palette ===
    global_palette_set = {0x00000000}  # Always include transparent
    
    for trait_info in traits_data:
        palette = extract_palette(trait_info['img'], trait_info['bbox'])
        global_palette_set.update(palette)
    
    # Sort palette (transparent first, then by value for determinism)
    sorted_colors = sorted(list(global_palette_set))
    if 0x00000000 in sorted_colors:
        sorted_colors.remove(0x00000000)
    palette = [0x00000000] + sorted_colors
    
    # Create color-to-index mapping
    color_to_index = {color: idx for idx, color in enumerate(palette)}
    num_colors = len(palette)
    index_byte_size = 2 if num_colors > 255 else 1
    
    # Write palette
    data.extend(pack_le2(num_colors))
    for argb_color in palette:
        # Pack as 4 bytes: matches Solidity's uint32 layout
        data.extend(pack_le4(argb_color))
    
    # === SECTION 3: Metadata ===
    data.append(index_byte_size)
    data.append(len(traits_data))
    
    # === SECTION 4: Trait Data ===
    # Sort by name for deterministic output
    traits_data.sort(key=lambda x: x['name'])
    
    for trait_info in traits_data:
        bbox = trait_info['bbox']
        if bbox is None:
            continue  # Skip empty traits
        
        minx, miny, maxx, maxy = bbox
        width_bb = maxx - minx + 1
        height_bb = maxy - miny + 1
        pixel_count = width_bb * height_bb
        
        # Write trait header
        data.extend(pack_le2(pixel_count))
        data.append(minx)
        data.append(miny)
        data.append(maxx)
        data.append(maxy)
        data.append(trait_info.get('bgTypeIndex', 0))
        data.append(trait_info.get('bgAssetKey', 0))
        
        # Write trait name
        name_bytes = trait_info['name'].encode('utf-8')
        data.append(len(name_bytes))
        data.extend(name_bytes)
        
        # Write compressed pixel data
        img = trait_info['img']
        flat_pixels = flatten_pixels_row_major(img, bbox)
        pixel_indices = [color_to_index[pixel] for pixel in flat_pixels]
        compressed = compress_pixels_rle(pixel_indices)
        rle_data = serialize_rle_data(compressed, index_byte_size)
        data.extend(rle_data)
    
    return bytes(data)

# ============================================================================
# MAIN PROCESSING
# ============================================================================

def process_trait_group(group_config):
    """
    Process a single trait group directory.
    
    Args:
        group_config: Dict with 'name', 'index', 'dir'
    
    Returns:
        Dict with serialized data and metadata
    """
    group_name = group_config['name']
    group_dir = group_config['dir']
    
    print(f"Processing: {group_name}")
    
    if not os.path.exists(group_dir):
        print(f"  ⚠ Directory not found: {group_dir}")
        return None
    
    traits_data = []
    
    # Load all PNG files in directory
    for filename in sorted(os.listdir(group_dir)):
        if not filename.endswith('.png'):
            continue
        
        # Trait name from filename (replace underscores with spaces)
        trait_name = filename[:-4].replace('_', ' ')
        
        # Load and process image
        img_path = os.path.join(group_dir, filename)
        img = Image.open(img_path).convert('RGBA')
        
        # Extract bounding box
        bbox = extract_bounding_box(img)
        
        if bbox is not None:
            traits_data.append({
                'name': trait_name,
                'img': img,
                'bbox': bbox,
                'bgTypeIndex': 0,
                'bgAssetKey': 0
            })
            print(f"  ✓ {trait_name} (bbox: {bbox})")
        else:
            print(f"  ⚠ {trait_name} (empty, skipped)")
    
    if not traits_data:
        print(f"  ⚠ No valid traits found")
        return None
    
    # Serialize the group
    serialized = serialize_trait_group(group_name, traits_data)
    
    print(f"  ✓ Serialized {len(traits_data)} traits ({len(serialized)} bytes)")
    
    return {
        'name': group_name,
        'index': group_config['index'],
        'data': serialized,
        'trait_count': len(traits_data)
    }

# ============================================================================
# CONFIGURATION & EXECUTION
# ============================================================================

def main():
    """Main execution function."""
    
    # === CONFIGURATION ===
    base_dir = '/Users/echo/Downloads/RPNKSLab/traitsColor'
    
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
    
    # === PROCESSING ===
    print("=" * 80)
    print("RETRO PUNKS ASSET GENERATOR")
    print("=" * 80)
    
    generated_assets = []
    
    for group_config in trait_groups:
        result = process_trait_group(group_config)
        if result:
            generated_assets.append(result)
        print()
    
    # === OUTPUT FILES ===
    
    # 1. Human-readable hex dump
    output_file = "assets_output.txt"
    with open(output_file, "w") as f:
        f.write("=" * 80 + "\n")
        f.write("RETRO PUNKS ASSET DATA\n")
        f.write("=" * 80 + "\n\n")
        
        for asset in generated_assets:
            f.write(f"Group: {asset['name']}\n")
            f.write(f"Index: {asset['index']}\n")
            f.write(f"Traits: {asset['trait_count']}\n")
            f.write(f"Size: {len(asset['data'])} bytes\n")
            f.write(f"Hex: 0x{asset['data'].hex()}\n")
            f.write("\n" + "-" * 80 + "\n\n")
    
    print(f"✓ Hex dump written to: {output_file}")
    
    # 2. Solidity deployment script
    sol_template = """// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {{ Script }} from "forge-std/Script.sol";
import {{ Assets }} from "../src/Assets.sol";
import {{ LibZip }} from "../src/libraries/LibZip.sol";

/**
 * @title AddAssetsBatch
 * @notice Deploys compressed trait assets to the Assets contract
 * @dev Auto-generated by asset_generator.py
 */
contract AddAssetsBatch is Script {{
    function run() external {{
        // === CONFIGURATION ===
        // Replace with your deployed Assets contract address
        address assetsAddr = 0x0000000000000000000000000000000000000000;
        uint256 startKey = 2;
        
        Assets assets = Assets(assetsAddr);

        vm.startBroadcast();

{asset_assignments}
        vm.stopBroadcast();
        
        console.log("Successfully added", {asset_count}, "asset groups");
    }}
}}
"""
    
    asset_assignments = ""
    for i, asset in enumerate(generated_assets):
        var_name = asset['name'].replace(' ', '_').replace('-', '_')
        hex_str = asset['data'].hex()
        
        asset_assignments += f"        // === {asset['name']} (Index: {asset['index']}) ===\n"
        asset_assignments += f"        bytes memory {var_name}_raw = hex\"{hex_str}\";\n"
        asset_assignments += f"        bytes memory {var_name}_compressed = LibZip.flzCompress({var_name}_raw);\n"
        asset_assignments += f"        assets.addAsset(startKey + {i}, {var_name}_compressed);\n"
        asset_assignments += f"        console.log(\"Added: {asset['name']}\");\n\n"
    
    sol_code = sol_template.format(
        asset_assignments=asset_assignments,
        asset_count=len(generated_assets)
    )
    
    sol_output_file = "script/AddAssetsBatch2.s.sol"
    os.makedirs(os.path.dirname(sol_output_file), exist_ok=True)
    with open(sol_output_file, "w") as f:
        f.write(sol_code)
    
    print(f"✓ Solidity script written to: {sol_output_file}")
    
    # === SUMMARY ===
    print("\n" + "=" * 80)
    print("SUMMARY")
    print("=" * 80)
    print(f"Groups processed: {len(generated_assets)}")
    total_bytes = sum(len(asset['data']) for asset in generated_assets)
    print(f"Total raw data: {total_bytes:,} bytes")
    print(f"Average per group: {total_bytes // len(generated_assets):,} bytes")
    print("\n✓ Generation complete!")

if __name__ == "__main__":
    main()