#!/usr/bin/env python3
import os
import struct

OUTPUT_DIR = "output"
COMBINED_FILENAME = "background_ultimate_asset.txt"
GROUP_NAME = "Background"

BG_TYPES = {
    "None":          0,
    "Image":         1,
    "Solid":         2,
    "S_Vertical":    3,
    "P_Vertical":    4,
    "S_Horizontal":  5,
    "P_Horizontal":  6,
    "S_Down":        7,      # top-left → bottom-right
    "P_Down":        8,
    "S_Up":          9,      # bottom-left → top-right
    "P_Up":         10,
    "Radial":       11
}

BG_TYPE_NAMES = {v: k for k, v in BG_TYPES.items()}

BACKGROUNDS = [
    {
        'name': 'Black',
        'layerType': 2,
        'palette': ["#000000"]
    },

    {
        'name': 'Grey 1',
        'layerType': 2,
        'palette': ["#1a1a1a"]
    },

    {
        'name': 'Grey 2',
        'layerType': 2,
        'palette': ["#333333"]
    },

    {
        'name': 'Grey 3',
        'layerType': 2,
        'palette': ["#4d4d4d"]
    },

    {
        'name': 'Grey 4',
        'layerType': 2,
        'palette': ["#666666"]
    },

    {
        'name': 'Grey 5',
        'layerType': 2,
        'palette': ["#808080"]
    },

    {
        'name': 'Grey 6',
        'layerType': 2,
        'palette': ["#999999"]
    },

    {
        'name': 'Grey 7',
        'layerType': 2,
        'palette': ["#b3b3b3"]
    },

    {
        'name': 'Grey 8',
        'layerType': 2,
        'palette': ["#cccccc"]
    },

    {
        'name': 'Grey 9',
        'layerType': 2,
        'palette': ["#e6e6e6"]
    },

    {
        'name': 'White',
        'layerType': 2,
        'palette': ["#ffffff"]
    },

    {
        'name': 'Greyscale_SV',
        'layerType': 3,
        'palette': ["#000000", "#ffffff"]
    },

    {
        'name': 'Greyscale_PV',
        'layerType': 4,
        'palette': [
            "#000000ff",
            "#020202ff",
            "#070707ff",
            "#0f0f0fff",
            "#161616ff",
            "#1e1e1eff",
            "#272727ff",
            "#333333ff",
            "#404040ff",
            "#4e4e4eff",
            "#5e5e5eff",
            "#6e6e6eff",
            "#808080ff",
            "#919191ff",
            "#a2a2a2ff",
            "#b3b3b3ff",
            "#c3c3c3ff",
            "#d2d2d2ff",
            "#dfdfdfff",
            "#eaeaeaff",
            "#f3f3f3ff",
            "#fafafaff",
            "#fefefeff",
            "#ffffffff"
        ]
    },

    {
        'name': 'Greyscale_SVI',
        'layerType': 3,
        'palette': ["#ffffff", "#000000"]
    },

    {
        'name': 'Greyscale_PVI',
        'layerType': 4,
        'palette': [
            "#ffffffff",
            "#fefefeff",
            "#fafafaff",
            "#f3f3f3ff",
            "#eaeaeaff",
            "#dfdfdfff",
            "#d2d2d2ff",
            "#c3c3c3ff",
            "#b3b3b3ff",
            "#a2a2a2ff",
            "#919191ff",
            "#808080ff",
            "#6e6e6eff",
            "#5e5e5eff",
            "#4e4e4eff",
            "#404040ff",
            "#333333ff",
            "#272727ff",
            "#1e1e1eff",
            "#161616ff",
            "#0f0f0fff",
            "#070707ff",
            "#020202ff",
            "#000000ff"
        ]
    },

    {
        'name': 'Greyscale_SH',
        'layerType': 5,
        'palette': ["#000000", "#ffffff"]
    },

    {
        'name': 'Greyscale_PH',
        'layerType': 6,
        'palette': [
            "#000000ff",
            "#020202ff",
            "#070707ff",
            "#0f0f0fff",
            "#161616ff",
            "#1e1e1eff",
            "#272727ff",
            "#333333ff",
            "#404040ff",
            "#4e4e4eff",
            "#5e5e5eff",
            "#6e6e6eff",
            "#808080ff",
            "#919191ff",
            "#a2a2a2ff",
            "#b3b3b3ff",
            "#c3c3c3ff",
            "#d2d2d2ff",
            "#dfdfdfff",
            "#eaeaeaff",
            "#f3f3f3ff",
            "#fafafaff",
            "#fefefeff",
            "#ffffffff"
        ]
    },

    {
        'name': 'Greyscale_SHI',
        'layerType': 5,
        'palette': ["#ffffff", "#000000"]
    },

    {
        'name': 'Greyscale_PHI',
        'layerType': 6,
        'palette': [
            "#ffffffff",
            "#fefefeff",
            "#fafafaff",
            "#f3f3f3ff",
            "#eaeaeaff",
            "#dfdfdfff",
            "#d2d2d2ff",
            "#c3c3c3ff",
            "#b3b3b3ff",
            "#a2a2a2ff",
            "#919191ff",
            "#808080ff",
            "#6e6e6eff",
            "#5e5e5eff",
            "#4e4e4eff",
            "#404040ff",
            "#333333ff",
            "#272727ff",
            "#1e1e1eff",
            "#161616ff",
            "#0f0f0fff",
            "#070707ff",
            "#020202ff",
            "#000000ff"
        ]
    },

    {
        'name': 'Greyscale_SD',
        'layerType': 7,
        'palette': ["#000000", "#ffffff"]
    },

    {
        'name': 'Greyscale_PD',
        'layerType': 8,
        'palette': [
            "#000000ff",
            "#020202ff",
            "#070707ff",
            "#0f0f0fff",
            "#161616ff",
            "#1e1e1eff",
            "#272727ff",
            "#333333ff",
            "#404040ff",
            "#4e4e4eff",
            "#5e5e5eff",
            "#6e6e6eff",
            "#808080ff",
            "#919191ff",
            "#a2a2a2ff",
            "#b3b3b3ff",
            "#c3c3c3ff",
            "#d2d2d2ff",
            "#dfdfdfff",
            "#eaeaeaff",
            "#f3f3f3ff",
            "#fafafaff",
            "#fefefeff",
            "#ffffffff"
        ]
    },

    {
        'name': 'Greyscale_SDI',
        'layerType': 7,
        'palette': ["#ffffff", "#000000"]
    },

    {
        'name': 'Greyscale_PDI',
        'layerType': 8,
        'palette': [
            "#ffffffff",
            "#fefefeff",
            "#fafafaff",
            "#f3f3f3ff",
            "#eaeaeaff",
            "#dfdfdfff",
            "#d2d2d2ff",
            "#c3c3c3ff",
            "#b3b3b3ff",
            "#a2a2a2ff",
            "#919191ff",
            "#808080ff",
            "#6e6e6eff",
            "#5e5e5eff",
            "#4e4e4eff",
            "#404040ff",
            "#333333ff",
            "#272727ff",
            "#1e1e1eff",
            "#161616ff",
            "#0f0f0fff",
            "#070707ff",
            "#020202ff",
            "#000000ff"
        ]
    },

    {
        'name': 'Greyscale_SU',
        'layerType': 9,
        'palette': ["#000000", "#ffffff"]
    },

    {
        'name': 'Greyscale_PU',
        'layerType': 10,
        'palette': [
            "#000000ff",
            "#020202ff",
            "#070707ff",
            "#0f0f0fff",
            "#161616ff",
            "#1e1e1eff",
            "#272727ff",
            "#333333ff",
            "#404040ff",
            "#4e4e4eff",
            "#5e5e5eff",
            "#6e6e6eff",
            "#808080ff",
            "#919191ff",
            "#a2a2a2ff",
            "#b3b3b3ff",
            "#c3c3c3ff",
            "#d2d2d2ff",
            "#dfdfdfff",
            "#eaeaeaff",
            "#f3f3f3ff",
            "#fafafaff",
            "#fefefeff",
            "#ffffffff"
        ]
    },

    {
        'name': 'Greyscale_SUI',
        'layerType': 9,
        'palette': ["#ffffff", "#000000"]
    },

    {
        'name': 'Greyscale_PUI',
        'layerType': 10,
        'palette': [
            "#ffffffff",
            "#fefefeff",
            "#fafafaff",
            "#f3f3f3ff",
            "#eaeaeaff",
            "#dfdfdfff",
            "#d2d2d2ff",
            "#c3c3c3ff",
            "#b3b3b3ff",
            "#a2a2a2ff",
            "#919191ff",
            "#808080ff",
            "#6e6e6eff",
            "#5e5e5eff",
            "#4e4e4eff",
            "#404040ff",
            "#333333ff",
            "#272727ff",
            "#1e1e1eff",
            "#161616ff",
            "#0f0f0fff",
            "#070707ff",
            "#020202ff",
            "#000000ff"
        ]
    },

    {
        'name': 'Greyscale_Radial_1',
        'layerType': 11,
        'palette': ["#ffffff", "#000000"]
    },
    {
        'name': 'Greyscale_Radial_2',
        'layerType': 11,
        'palette': ["#000000", "#ffffff"]
    },
]


def parse_color(c):
    """Convert #rrggbb, #rrggbbaa, 0xRRGGBBAA → integer 0xRRGGBBAA"""
    if isinstance(c, int):
        return c & 0xFFFFFFFF
    if isinstance(c, str):
        c = c.strip().replace('#', '').replace('0x', '').lower()
        if len(c) == 6:
            c += 'ff'
        if len(c) == 8:
            return int(c, 16)
    raise ValueError(f"Invalid color format: {c!r}")


def get_gradient_coords(layer_type):
    """Returns (x1,y1,x2,y2) in range 0-1 (normalized SVG style) like the first script"""
    mapping = {
        BG_TYPES["S_Vertical"]:   (0, 0, 0, 1),
        BG_TYPES["P_Vertical"]:   (0, 0, 0, 1),
        BG_TYPES["S_Horizontal"]: (0, 0, 1, 0),
        BG_TYPES["P_Horizontal"]: (0, 0, 1, 0),
        BG_TYPES["S_Down"]:       (0, 0, 1, 1),
        BG_TYPES["P_Down"]:       (0, 0, 1, 1),
        BG_TYPES["S_Up"]:         (0, 1, 1, 0),
        BG_TYPES["P_Up"]:         (0, 1, 1, 0),
        # dummy, same as first script fallback
        BG_TYPES["Radial"]:       (0, 0, 0, 0),
    }
    return mapping.get(layer_type, (0, 0, 0, 0))


def encode_background_group():
    output = bytearray()

    # 1. Group name length + name
    name_bytes = GROUP_NAME.encode('utf-8')
    output.append(len(name_bytes))
    output.extend(name_bytes)

    # 2. Collect & deduplicate all colors → unified palette (insertion order, like first script)
    unified_palette = []
    seen = set()
    for bg in BACKGROUNDS:
        for c in bg.get('palette', []):
            col = parse_color(c)
            if col not in seen:
                unified_palette.append(col)
                seen.add(col)

    palette_size = len(unified_palette)

    output.extend(struct.pack('>H', palette_size))          # 2 bytes
    for color in unified_palette:
        output.extend(struct.pack('>I', color))             # 4 bytes each

    # 3. Index size + background count
    # Force 2 bytes always — matches first script behavior
    index_bytes = 2
    output.append(index_bytes)
    output.append(len(BACKGROUNDS))

    # 4. Color → palette index lookup
    color_to_index = {col: i for i, col in enumerate(unified_palette)}

    # 5. Each background
    for bg in BACKGROUNDS:
        name = bg['name'].encode('utf-8')
        layer_type = bg['layerType']
        raw_palette = bg.get('palette', [])
        palette_ints = [parse_color(c) for c in raw_palette]

        # Number of color stops (for gradients), 1 for solid, 0 for image
        stop_count = len(
            palette_ints) if layer_type != BG_TYPES["Image"] else 0

        # Coordinates (now 0/1 like first script)
        x1, y1, x2, y2 = get_gradient_coords(layer_type)

        # Header: stopCount(2) + x1,y1,x2,y2(1 each) + layerType(1) + nameLen(1)
        header = struct.pack(
            '>HBBBBBB',
            stop_count, x1, y1, x2, y2, layer_type, len(name)
        )
        output.extend(header)
        output.extend(name)

        # Payload: color indices (always 2 bytes)
        if layer_type == BG_TYPES["Image"]:
            # No palette data for images
            continue

        if layer_type == BG_TYPES["Solid"]:
            if palette_ints:
                idx = color_to_index[palette_ints[0]]
                output.extend(struct.pack('>H', idx))
        else:
            # Gradient: write sequence of 2-byte indices
            for col in palette_ints:
                idx = color_to_index[col]
                output.extend(struct.pack('>H', idx))

    return bytes(output)


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    print("Generating Background Asset Group...")

    try:
        data = encode_background_group()
    except Exception as e:
        print(f"ERROR during encoding: {e}")
        return

    if not data:
        print("No data generated.")
        return

    hex_string = "0x" + data.hex()
    path = os.path.join(OUTPUT_DIR, COMBINED_FILENAME)

    with open(path, 'w', encoding='utf-8') as f:
        f.write(f"{GROUP_NAME}: {hex_string}\n")

    print(f"\nSuccess! Written to: {path}")
    print(f"  Binary size: {len(data):,} bytes")
    print(f"  Hex length:  {len(hex_string):,} chars")
    print(
        f"  Palette size: {len({parse_color(c) for bg in BACKGROUNDS for c in bg.get('palette', [])}):,} unique colors")

    # Quick header check
    if len(data) >= 12:
        start = data[:12].hex()
        namelen = data[0]
        print(f"  Header preview: 0x{start}")
        print(f"  Group name length: {namelen} → should be {len(GROUP_NAME)}")
        if namelen == len(GROUP_NAME):
            print("  ✓ Name length looks correct")


if __name__ == '__main__':
    main()
