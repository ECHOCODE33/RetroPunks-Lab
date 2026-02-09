#!/usr/bin/env python3
import os
import struct
import colorsys
import math
from pathlib import Path

# ============================================================================
# CONFIGURATION
# ============================================================================

INPUT_FILE = Path("output/combined_traits_hex.txt")

# ============================================================================
# PARSER UTILS
# ============================================================================

def parse_hex_line(hex_str):
    """
    Decodes the hex string based on the specific packing format:
    [NameLen (1)][Name (Var)][PaletteCount (2)][PaletteData (N*4)]...
    """
    # Remove '0x' prefix if present
    if hex_str.startswith("0x"):
        hex_str = hex_str[2:]
    
    data = bytes.fromhex(hex_str)
    ptr = 0
    
    # 1. Read Name Length
    if ptr >= len(data): return []
    name_len = data[ptr]
    ptr += 1
    
    # 2. Skip Name
    ptr += name_len
    
    # 3. Read Palette Count (Big Endian Unsigned Short)
    if ptr + 2 > len(data): return []
    palette_count = struct.unpack('>H', data[ptr:ptr+2])[0]
    ptr += 2
    
    # 4. Extract Colors
    extracted_colors = []
    for _ in range(palette_count):
        if ptr + 4 > len(data): break
        r = data[ptr]
        g = data[ptr+1]
        b = data[ptr+2]
        a = data[ptr+3]
        ptr += 4
        
        # Only keep opaque or semi-opaque colors (Ignore fully transparent)
        if a > 0:
            extracted_colors.append((r, g, b))
            
    return extracted_colors

# ============================================================================
# COLOR THEORY LOGIC
# ============================================================================

def get_luminance(rgb):
    """Returns perceived brightness (0-255)."""
    return (0.299 * rgb[0]) + (0.587 * rgb[1]) + (0.114 * rgb[2])

def rgb_to_hex(rgb):
    return "#{:02x}{:02x}{:02x}".format(int(rgb[0]), int(rgb[1]), int(rgb[2]))

def generate_background(all_colors):
    if not all_colors:
        print("No colors found in the data.")
        return

    total_r, total_g, total_b = 0, 0, 0
    total_lum = 0
    valid_pixels = len(all_colors)

    # 1. Calculate Average Color and Luminance
    for r, g, b in all_colors:
        total_r += r
        total_g += g
        total_b += b
        total_lum += get_luminance((r, g, b))

    avg_r = total_r / valid_pixels
    avg_g = total_g / valid_pixels
    avg_b = total_b / valid_pixels
    avg_lum = total_lum / valid_pixels

    # Convert average RGB to HSL to find the dominant Hue
    h, l, s = colorsys.rgb_to_hls(avg_r/255, avg_g/255, avg_b/255)
    
    print(f"--- COLLECTION ANALYSIS ---")
    print(f"Total Unique Colors Scanned: {valid_pixels}")
    print(f"Average Luminance: {avg_lum:.2f} (0=Black, 255=White)")
    print(f"Average Hue: {h*360:.1f}°")
    
    # 2. Determine Base Value (Contrast Logic)
    # If the collection is bright (>128), go Dark. If dark (<128), go Light.
    # We push it towards the extremes (15% or 92%) for better contrast.
    if avg_lum > 128:
        bg_lum = 0.15 # Dark background (15% lightness)
        print("Verdict: Your characters are generally BRIGHT.")
        print("Strategy: Use a DARK background for contrast.")
    else:
        bg_lum = 0.92 # Light background (92% lightness)
        print("Verdict: Your characters are generally DARK.")
        print("Strategy: Use a LIGHT background for contrast.")

    # 3. Determine Tint (Complementary Logic)
    # Calculate complementary hue (add 0.5 in 0-1 scale, which is 180 degrees)
    comp_hue = (h + 0.5) % 1.0
    
    # Use very low saturation (10-15%) so it looks like a tinted neutral, not a rainbow
    bg_sat = 0.12 

    # 4. Generate the Color
    # Convert HLS back to RGB
    final_r, final_g, final_b = colorsys.hls_to_rgb(comp_hue, bg_lum, bg_sat)
    final_rgb = (final_r * 255, final_g * 255, final_b * 255)
    final_hex = rgb_to_hex(final_rgb)

    # 5. Generate a "Safe" Pure Neutral Option (Greyscale)
    safe_grey_val = int(bg_lum * 255)
    safe_hex = rgb_to_hex((safe_grey_val, safe_grey_val, safe_grey_val))

    print(f"\n--- RECOMMENDATIONS ---")
    
    print(f"\nOPTION 1: THE 'PRO' CHOICE (Complementary Tint)")
    print(f"Hex: {final_hex}")
    print(f"Why: This is a {('Dark' if bg_lum < 0.5 else 'Light')} Grey with a subtle {int(comp_hue*360)}° tint.")
    print("This color sits on the opposite side of the color wheel from your characters' average skin/clothes, making them pop more.")

    print(f"\nOPTION 2: THE 'SAFE' CHOICE (Pure Neutral)")
    print(f"Hex: {safe_hex}")
    print(f"Why: Pure greyscale. Ensures 0% color clashing.")

# ============================================================================
# MAIN
# ============================================================================

def main():
    if not INPUT_FILE.exists():
        print(f"Error: {INPUT_FILE} not found. Run your encoder script first.")
        return

    print("Reading hex data...")
    
    # Aggregation of every color used in every trait
    # Note: We are ignoring pixel *counts* (area) and just looking at palette *presence*.
    # This prevents a massive background trait from skewing the data, 
    # ensuring small colorful accessories are accounted for.
    global_palette = []

    with open(INPUT_FILE, 'r') as f:
        content = f.read()
        # Split by the separator used in your previous script
        chunks = content.split('\n\n')
        
        for chunk in chunks:
            if ": 0x" not in chunk: continue
            _, hex_data = chunk.split(": 0x")
            colors = parse_hex_line(hex_data)
            global_palette.extend(colors)

    generate_background(global_palette)

if __name__ == '__main__':
    main()