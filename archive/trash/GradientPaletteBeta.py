#!/usr/bin/env python3

# ============================================================================
# CONFIGURATION
# ============================================================================

# Define your colors here (RRGGBBAA format in hex)
COLORS = [
    0x43ff64ff,  # Green
    0xff0055ff   # Pink
]

# Number of steps to divide the gradient into
STEP_COUNT = 24

# ============================================================================
# GRADIENT GENERATION
# ============================================================================

def hex_to_rgba(color):
    """Convert packed RRGGBBAA to (r, g, b, a) tuple"""
    return (
        (color >> 24) & 0xFF,
        (color >> 16) & 0xFF,
        (color >> 8) & 0xFF,
        color & 0xFF
    )

def rgba_to_hex(r, g, b, a):
    """Convert (r, g, b, a) to packed RRGGBBAA"""
    return (r << 24) | (g << 16) | (b << 8) | a

def lerp(a, b, t):
    """Linear interpolation between a and b"""
    return int(a + (b - a) * t)

def generate_gradient(colors, steps):
    """
    Generate a gradient palette with specified number of steps.
    Colors are divided evenly across the gradient.
    """
    if len(colors) < 2:
        raise ValueError("Need at least 2 colors for a gradient")
    
    if steps < len(colors):
        raise ValueError(f"Steps ({steps}) must be >= number of colors ({len(colors)})")
    
    gradient = []
    
    # Number of segments between colors
    num_segments = len(colors) - 1
    
    # Steps per segment (distribute evenly)
    steps_per_segment = (steps - 1) / num_segments
    
    for i in range(steps):
        # Determine which segment we're in
        t_global = i / (steps - 1)  # 0.0 to 1.0
        segment_index = min(int(t_global * num_segments), num_segments - 1)
        
        # Position within this segment
        segment_start = segment_index / num_segments
        segment_end = (segment_index + 1) / num_segments
        t_segment = (t_global - segment_start) / (segment_end - segment_start)
        
        # Get colors for this segment
        color1 = hex_to_rgba(colors[segment_index])
        color2 = hex_to_rgba(colors[segment_index + 1])
        
        # Interpolate each channel
        r = lerp(color1[0], color2[0], t_segment)
        g = lerp(color1[1], color2[1], t_segment)
        b = lerp(color1[2], color2[2], t_segment)
        a = lerp(color1[3], color2[3], t_segment)
        
        gradient.append(rgba_to_hex(r, g, b, a))
    
    return gradient

def format_palette_for_background_script(palette):
    """Format palette as Python list for easy copy-paste"""
    hex_strings = [f"0x{color:08X}" for color in palette]
    
    # Format with nice wrapping
    output = "[\n    "
    line_items = []
    for i, hex_str in enumerate(hex_strings):
        line_items.append(hex_str)
        if (i + 1) % 1 == 0 and i < len(hex_strings) - 1:
            output += ", ".join(line_items) + ",\n    "
            line_items = []
    
    if line_items:
        output += ", ".join(line_items)
    
    output += "\n]"
    return output

def main():
    print("=" * 70)
    print("GRADIENT PALETTE GENERATOR")
    print("=" * 70)
    print(f"\nInput colors: {len(COLORS)}")
    for i, color in enumerate(COLORS):
        r, g, b, a = hex_to_rgba(color)
        print(f"  Color {i+1}: #{color:08X} (R:{r}, G:{g}, B:{b}, A:{a})")
    
    print(f"\nGenerating {STEP_COUNT} gradient steps...")
    
    gradient = generate_gradient(COLORS, STEP_COUNT)
    
    print(f"\n✓ Generated {len(gradient)} colors")
    print("\n" + "=" * 70)
    print("COPY THIS PALETTE TO YOUR BACKGROUND SCRIPT:")
    print("=" * 70)
    print(format_palette_for_background_script(gradient))
    print("=" * 70)
    
    # Also show preview
    print("\nGradient preview:")
    for i, color in enumerate(gradient):
        r, g, b, a = hex_to_rgba(color)
        print(f"  Step {i+1:2d}: #{color:08X} (R:{r:3d}, G:{g:3d}, B:{b:3d}, A:{a:3d})")

if __name__ == '__main__':
    main()