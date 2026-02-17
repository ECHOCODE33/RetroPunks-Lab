#!/usr/bin/env python3
"""
2D RLE Asset Encoder for RetroPunks Traits

Key changes from previous version:
  - Samples 48x48 source images at 24x24 LOGICAL resolution (top-left pixel of
    each 2x2 block). Artwork is drawn in 2x2 blocks so this halves stored data
    with zero visual loss. The renderer multiplies all coordinates and sizes by 2.
  - Palette stores RGB only — 3 bytes per entry, no alpha. Transparency is binary:
    a pixel is either fully transparent (never stored) or opaque (stored as RGB).
    The Solidity loader reconstructs the alpha byte as 0xFF.
  - Transparent runs are NEVER written to the 2D RLE data. The renderer needs no
    transparency check — every stored run is guaranteed opaque.
  - Bounding box (x1, y1, x2, y2) is in 24x24 logical coordinate space.
  - layerType=0xFF marks full-resolution 48x48 exception layers (~5 total).
    Add their filenames (without .png) to FULL_RES_TRAITS. Those layers are
    stored at 48x48 and the renderer does NOT double their coordinates.

Blob layout per trait group (identical to previous except palette entry size):
  [nameLen:1][name:N]
  [paletteCount:2]            big-endian uint16
  [palette: count * 3]        RGB, no alpha  (was count * 4 RGBA)
  [paletteIndexByteSize:1]    1 if count <= 255, else 2
  [traitCount:1]
  Per trait:
    [x1:1][y1:1][x2:1][y2:1] bounding box in logical (24x24) coordinate space
    [layerType:1]             0 = normal 24x24 logical, 0xFF = full-res 48x48
    [nameLen:1][name:N]
    [numRows:1]
    Per non-empty row:
      [rowY:1][numRuns:1]
      Per opaque run:
        [x:1][length:1][paletteIndex: pSize bytes, big-endian]
"""

import os
import struct
from PIL import Image
from collections import Counter
from dotenv import load_dotenv
from pathlib import Path

load_dotenv()

# ============================================================================
# CONFIGURATION
# ============================================================================

BASE_PATH = Path(os.getenv("BASE_DIR", "."))
TRAITS_DIR = BASE_PATH
OUTPUT_DIR = "output"
COMBINED_FILENAME = "traits_asset.txt"

# Source images are 48x48, drawn in 2x2 blocks.
# We sample at 24x24 logical resolution (one sample per 2x2 block).
SOURCE_WIDTH  = 48
SOURCE_HEIGHT = 48
LOGICAL_WIDTH  = SOURCE_WIDTH  // 2   # 24
LOGICAL_HEIGHT = SOURCE_HEIGHT // 2   # 24

INCLUDE_NONE_TRAIT = True

# Filenames (without .png extension) of the ~5 exception layers that have genuine
# single-pixel detail and must be stored at full 48x48 resolution.
# For those, layerType is set to 0xFF and the renderer uses unit=1 (no doubling).
FULL_RES_TRAITS: set = set()

ENUM_ORDER = [
    "Male_Skin_Group", "Male_Eyes_Group", "Male_Face_Group", "Male_Chain_Group",
    "Male_Earring_Group", "Male_Facial_Hair_Group", "Male_Mask_Group",
    "Male_Scarf_Group", "Male_Hair_Group", "Male_Hat_Hair_Group",
    "Male_Headwear_Group", "Male_Eye_Wear_Group", "Female_Skin_Group",
    "Female_Eyes_Group", "Female_Face_Group", "Female_Chain_Group",
    "Female_Earring_Group", "Female_Mask_Group", "Female_Scarf_Group",
    "Female_Hair_Group", "Female_Hat_Hair_Group", "Female_Headwear_Group",
    "Female_Eye_Wear_Group", "Mouth_Group", "Filler_Traits_Group"
]

_SUFFIXES = [
    " 1", " 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9", " 10", " 11", " 12",
    " Left", " Right",
    " Black", " Brown", " Blonde", " Ginger", " Light", " Dark", " Shadow", " Fade",
    " Blue", " Green", " Orange", " Pink", " Purple", " Red", " Turquoise",
    " White", " Yellow", " Sky Blue", " Hot Pink", " Neon Blue", " Neon Green",
    " Neon Purple", " Neon Red", " Grey", " Navy", " Burgundy", " Beige", " Golden",
    " Black Hat", " Brown Hat", " Blonde Hat", " Ginger Hat", " Blue Hat",
    " Green Hat", " Orange Hat", " Pink Hat", " Purple Hat", " Red Hat",
    " Turquoise Hat", " White Hat", " Yellow Hat"
]

_SUFFIXES_SORTED = sorted(_SUFFIXES, key=len, reverse=True)

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

def strip_gender_prefix(name: str) -> str:
    """Remove 'Male ' or 'Female ' prefix."""
    if name.startswith("Male "):
        return name[5:]
    if name.startswith("Female "):
        return name[7:]
    return name

def enum_to_display_name(enum_name: str) -> str:
    return enum_name.replace("_Group", "").replace("_", " ")

def normalize_trait_name(name: str) -> str:
    """Remove configured suffixes from trait names."""
    current = name
    while True:
        changed = False
        for s in _SUFFIXES_SORTED:
            if current.endswith(s):
                current = current[: -len(s)].rstrip()
                changed = True
                break
        if not changed:
            break
    return current

def load_png_logical(filepath: str) -> list:
    """
    Load a 48x48 PNG and sample it down to 24x24 logical resolution.

    Reads the pixel at (lx*2, ly*2) for each logical position (lx, ly).
    Since artwork is drawn in 2x2 blocks, all four pixels in each block are
    the same color, so sampling the top-left corner is perfectly lossless.

    Returns: 2D list [row][col] of (r, g, b, a) tuples at 24x24 resolution.
    """
    img = Image.open(filepath).convert('RGBA')
    if img.size != (SOURCE_WIDTH, SOURCE_HEIGHT):
        img = img.resize((SOURCE_WIDTH, SOURCE_HEIGHT), Image.Resampling.NEAREST)
    pixels = img.load()
    return [
        [pixels[lx * 2, ly * 2] for lx in range(LOGICAL_WIDTH)]
        for ly in range(LOGICAL_HEIGHT)
    ]

def load_png_fullres(filepath: str) -> list:
    """
    Load a 48x48 PNG at full resolution.

    Only used for the ~5 exception layers that have genuine single-pixel detail.

    Returns: 2D list [row][col] of (r, g, b, a) tuples at 48x48 resolution.
    """
    img = Image.open(filepath).convert('RGBA')
    if img.size != (SOURCE_WIDTH, SOURCE_HEIGHT):
        img = img.resize((SOURCE_WIDTH, SOURCE_HEIGHT), Image.Resampling.NEAREST)
    pixels = img.load()
    return [
        [pixels[x, y] for x in range(SOURCE_WIDTH)]
        for y in range(SOURCE_HEIGHT)
    ]

def compute_bounds(grid: list) -> tuple:
    """
    Compute the bounding box of all non-transparent pixels in a pixel grid.

    Works for any resolution (24x24 logical or 48x48 full-res).
    Returns (x1, y1, x2, y2) in the grid's own coordinate space.
    Returns (0, 0, 0, 0) for a fully transparent / empty image.
    """
    height = len(grid)
    width = len(grid[0]) if height > 0 else 0
    x1, y1 = width, height
    x2, y2 = -1, -1

    for y in range(height):
        for x in range(width):
            _, _, _, a = grid[y][x]
            if a > 0:
                if x < x1: x1 = x
                if y < y1: y1 = y
                if x > x2: x2 = x
                if y > y2: y2 = y

    return (0, 0, 0, 0) if x2 == -1 else (x1, y1, x2, y2)

def encode_2d_rle(grid: list, palette_map: dict, bounds: tuple, p_size: int) -> bytes:
    """
    Encode 2D RLE from a pixel grid (24x24 logical or 48x48 full-res).

    Transparent pixels are COMPLETELY SKIPPED — no sentinel value is ever written.
    The renderer performs no transparency check; every stored run is opaque.

    Format:
      [numRows: 1]
      Per non-empty row:
        [rowY: 1][numRuns: 1]
        Per opaque run:
          [x: 1][length: 1][paletteIndex: p_size bytes, big-endian]

    All coordinates are in the grid's own space. For 24x24 logical grids the
    renderer multiplies by 2. For 48x48 full-res grids coordinates are used as-is.
    """
    x1, y1, x2, y2 = bounds

    # Empty image: write a single numRows=0 byte
    if x2 < x1:
        return bytes([0])

    rows_data = []

    for y in range(y1, y2 + 1):
        runs = []
        x = x1

        while x <= x2:
            r, g, b, a = grid[y][x]

            # Extend this run as far as it goes (same RGBA value)
            run_start = x
            while x <= x2 and grid[y][x] == (r, g, b, a):
                x += 1
            run_length = x - run_start

            # Only store opaque runs — transparent runs are silently skipped
            if a > 0:
                runs.append((run_start, run_length, (r, g, b)))

        if runs:
            rows_data.append((y, runs))

    output = bytearray()
    output.append(len(rows_data))  # numRows

    for (row_y, runs) in rows_data:
        output.append(row_y)        # rowY
        output.append(len(runs))    # numRuns

        for (x_pos, length, rgb) in runs:
            output.append(x_pos)    # x
            output.append(length)   # run length (in grid units)

            color_idx = palette_map[rgb]
            if p_size == 2:
                output.extend(struct.pack('>H', color_idx))
            else:
                output.append(color_idx)

    return bytes(output)

# ============================================================================
# GROUP ENCODER
# ============================================================================

def encode_trait_group(trait_dir: str, display_name: str):
    """Encode an entire trait group into the binary blob format."""
    if not os.path.exists(trait_dir):
        return None

    png_files = sorted([f for f in os.listdir(trait_dir) if f.endswith('.png')])
    if not png_files:
        return None

    # Load each trait image at the appropriate resolution
    traits_data = []
    for f in png_files:
        raw_name = os.path.splitext(f)[0]
        cleaned_name = normalize_trait_name(raw_name)
        is_full_res = raw_name in FULL_RES_TRAITS

        grid = load_png_fullres(os.path.join(trait_dir, f)) if is_full_res \
               else load_png_logical(os.path.join(trait_dir, f))

        traits_data.append({
            'name': cleaned_name,
            'grid': grid,
            'full_res': is_full_res,
        })

    # Build a shared palette from ALL opaque pixels across all traits in this group.
    # Only RGB values are stored — transparent pixels are excluded completely.
    all_rgb = []
    for t in traits_data:
        for row in t['grid']:
            for (r, g, b, a) in row:
                if a > 0:
                    all_rgb.append((r, g, b))

    # Order by frequency so the most common colors get the lowest indices.
    palette = [c for c, _ in Counter(all_rgb).most_common()]
    palette_map = {rgb: idx for idx, rgb in enumerate(palette)}
    p_size = 2 if len(palette) > 255 else 1

    output = bytearray()

    # ── 1. Group name ──────────────────────────────────────────────────────────
    b_name = display_name.encode('utf-8')
    output.append(len(b_name))
    output.extend(b_name)

    # ── 2. Palette (RGB only, 3 bytes per entry — was 4 bytes RGBA) ────────────
    output.extend(struct.pack('>H', len(palette)))  # big-endian uint16 count
    for (r, g, b) in palette:
        output.extend([r, g, b])

    # ── 3. Settings ────────────────────────────────────────────────────────────
    output.append(p_size)  # paletteIndexByteSize: 1 or 2
    output.append(len(traits_data) + (1 if INCLUDE_NONE_TRAIT else 0))

    # ── 4. "None" trait (empty placeholder at index 0) ────────────────────────
    if INCLUDE_NONE_TRAIT:
        output.extend([0, 0, 0, 0])  # x1, y1, x2, y2
        output.append(0)             # layerType = 0 (normal)
        output.append(4)             # nameLen
        output.extend(b'None')
        output.append(0)             # numRows = 0 (empty RLE data)

    # ── 5. Real traits ─────────────────────────────────────────────────────────
    for t in traits_data:
        bounds = compute_bounds(t['grid'])
        rle_data = encode_2d_rle(t['grid'], palette_map, bounds, p_size)

        # layerType: 0xFF = full-res 48x48 exception, 0 = normal 24x24 logical
        layer_type = 0xFF if t['full_res'] else 0

        output.extend([bounds[0], bounds[1], bounds[2], bounds[3]])  # x1 y1 x2 y2
        output.append(layer_type)

        b_tname = t['name'].encode('utf-8')
        output.append(len(b_tname))
        output.extend(b_tname)

        output.extend(rle_data)

    return bytes(output)

# ============================================================================
# MAIN
# ============================================================================

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    combined_output = []

    print("=" * 70)
    print("2D RLE Asset Encoder for RetroPunks — 24x24 logical / RGB palette")
    print("=" * 70)

    for enum_name in ENUM_ORDER:
        folder_display_name = enum_to_display_name(enum_name)
        trait_group_name = strip_gender_prefix(folder_display_name)
        trait_dir = os.path.join(TRAITS_DIR, folder_display_name)

        print(f"Processing: {folder_display_name} (as '{trait_group_name}')...", end=" ")

        data = encode_trait_group(trait_dir, trait_group_name)
        if data:
            combined_output.append(f"{enum_name}: 0x{data.hex()}")
            print(f"✓ DONE ({len(data)} bytes)")
        else:
            print("⊗ SKIPPED (not found or empty)")

    output_file = os.path.join(OUTPUT_DIR, COMBINED_FILENAME)
    with open(output_file, 'w') as f:
        f.write("\n\n".join(combined_output))

    print("=" * 70)
    print(f"Output written to: {output_file}")
    print("=" * 70)

if __name__ == '__main__':
    main()