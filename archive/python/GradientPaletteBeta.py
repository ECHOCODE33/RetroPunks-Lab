#!/usr/bin/env python3
import math

# ============================================================================
# CONFIGURATION
# ============================================================================

COLORS = [
    0xffffffff,
    0x000000ff
]

STEP_COUNT = 24

# Interpolation method: 'lab' (recommended), 'lch', 'hsl', or 'rgb'
INTERPOLATION_METHOD = 'lab'

# Easing function: 'linear', 'ease_in_out', 'ease_in', 'ease_out'
EASING = 'ease_in_out'

# For HSL/LCH: 'short' (default) or 'long' hue path around color wheel
HUE_DIRECTION = 'short'

# ============================================================================
# COLOR SPACE CONVERSIONS
# ============================================================================

def rgb_to_xyz(r, g, b):
    """Convert RGB to XYZ color space (D65 illuminant)"""
    # Normalize to 0-1 and apply gamma correction
    r, g, b = r/255, g/255, b/255
    
    r = ((r + 0.055) / 1.055) ** 2.4 if r > 0.04045 else r / 12.92
    g = ((g + 0.055) / 1.055) ** 2.4 if g > 0.04045 else g / 12.92
    b = ((b + 0.055) / 1.055) ** 2.4 if b > 0.04045 else b / 12.92
    
    # Convert to XYZ using D65 illuminant matrix
    x = r * 0.4124564 + g * 0.3575761 + b * 0.1804375
    y = r * 0.2126729 + g * 0.7151522 + b * 0.0721750
    z = r * 0.0193339 + g * 0.1191920 + b * 0.9503041
    
    return x * 100, y * 100, z * 100

def xyz_to_lab(x, y, z):
    """Convert XYZ to LAB color space"""
    # D65 reference white point
    x, y, z = x / 95.047, y / 100.0, z / 108.883
    
    def f(t):
        return t ** (1/3) if t > 0.008856 else (7.787 * t) + (16/116)
    
    fx, fy, fz = f(x), f(y), f(z)
    
    L = (116 * fy) - 16
    a = 500 * (fx - fy)
    b = 200 * (fy - fz)
    
    return L, a, b

def lab_to_xyz(L, a, b):
    """Convert LAB to XYZ color space"""
    fy = (L + 16) / 116
    fx = (a / 500) + fy
    fz = fy - (b / 200)
    
    def f_inv(t):
        return t ** 3 if t ** 3 > 0.008856 else (t - 16/116) / 7.787
    
    x = f_inv(fx) * 95.047
    y = f_inv(fy) * 100.0
    z = f_inv(fz) * 108.883
    
    return x, y, z

def xyz_to_rgb(x, y, z):
    """Convert XYZ to RGB color space"""
    x, y, z = x / 100, y / 100, z / 100
    
    # Convert using inverse D65 matrix
    r = x *  3.2404542 + y * -1.5371385 + z * -0.4985314
    g = x * -0.9692660 + y *  1.8760108 + z *  0.0415560
    b = x *  0.0556434 + y * -0.2040259 + z *  1.0572252
    
    # Inverse gamma correction
    def gamma(c):
        return 1.055 * (c ** (1/2.4)) - 0.055 if c > 0.0031308 else 12.92 * c
    
    r, g, b = gamma(r), gamma(g), gamma(b)
    
    # Clamp to valid range and convert to 0-255
    r = max(0, min(255, int(r * 255 + 0.5)))
    g = max(0, min(255, int(g * 255 + 0.5)))
    b = max(0, min(255, int(b * 255 + 0.5)))
    
    return r, g, b

def rgb_to_lab(r, g, b):
    """Convert RGB directly to LAB"""
    x, y, z = rgb_to_xyz(r, g, b)
    return xyz_to_lab(x, y, z)

def lab_to_rgb(L, a, b):
    """Convert LAB directly to RGB"""
    x, y, z = lab_to_xyz(L, a, b)
    return xyz_to_rgb(x, y, z)

def lab_to_lch(L, a, b):
    """Convert LAB to LCH (cylindrical coordinates)"""
    C = math.sqrt(a*a + b*b)
    H = math.atan2(b, a) * 180 / math.pi
    if H < 0:
        H += 360
    return L, C, H

def lch_to_lab(L, C, H):
    """Convert LCH to LAB"""
    H_rad = H * math.pi / 180
    a = C * math.cos(H_rad)
    b = C * math.sin(H_rad)
    return L, a, b

def rgb_to_hsl(r, g, b):
    """Convert RGB to HSL"""
    r, g, b = r/255, g/255, b/255
    max_c = max(r, g, b)
    min_c = min(r, g, b)
    diff = max_c - min_c
    
    # Lightness
    l = (max_c + min_c) / 2
    
    if diff == 0:
        h = s = 0
    else:
        # Saturation
        s = diff / (2 - max_c - min_c) if l > 0.5 else diff / (max_c + min_c)
        
        # Hue
        if max_c == r:
            h = ((g - b) / diff + (6 if g < b else 0)) / 6
        elif max_c == g:
            h = ((b - r) / diff + 2) / 6
        else:
            h = ((r - g) / diff + 4) / 6
    
    return h * 360, s, l

def hsl_to_rgb(h, s, l):
    """Convert HSL to RGB"""
    h = h / 360
    
    def hue_to_rgb(p, q, t):
        if t < 0: t += 1
        if t > 1: t -= 1
        if t < 1/6: return p + (q - p) * 6 * t
        if t < 1/2: return q
        if t < 2/3: return p + (q - p) * (2/3 - t) * 6
        return p
    
    if s == 0:
        r = g = b = l
    else:
        q = l * (1 + s) if l < 0.5 else l + s - l * s
        p = 2 * l - q
        r = hue_to_rgb(p, q, h + 1/3)
        g = hue_to_rgb(p, q, h)
        b = hue_to_rgb(p, q, h - 1/3)
    
    return int(r * 255 + 0.5), int(g * 255 + 0.5), int(b * 255 + 0.5)

# ============================================================================
# EASING FUNCTIONS
# ============================================================================

def ease_in_out(t):
    """Smooth acceleration and deceleration (cosine)"""
    return (1 - math.cos(t * math.pi)) / 2

def ease_in(t):
    """Gradual acceleration (quadratic)"""
    return t * t

def ease_out(t):
    """Gradual deceleration"""
    return 1 - (1 - t) * (1 - t)

def apply_easing(t, easing_type):
    """Apply easing function to interpolation parameter"""
    if easing_type == 'ease_in_out':
        return ease_in_out(t)
    elif easing_type == 'ease_in':
        return ease_in(t)
    elif easing_type == 'ease_out':
        return ease_out(t)
    else:  # linear
        return t

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
    return a + (b - a) * t

def interpolate_lab(color1, color2, t):
    """Interpolate in LAB color space (perceptually uniform)"""
    r1, g1, b1, a1 = color1
    r2, g2, b2, a2 = color2
    
    L1, a1_lab, b1_lab = rgb_to_lab(r1, g1, b1)
    L2, a2_lab, b2_lab = rgb_to_lab(r2, g2, b2)
    
    L = lerp(L1, L2, t)
    a_lab = lerp(a1_lab, a2_lab, t)
    b_lab = lerp(b1_lab, b2_lab, t)
    
    r, g, b = lab_to_rgb(L, a_lab, b_lab)
    a = int(lerp(a1, a2, t))
    
    return r, g, b, a

def interpolate_lch(color1, color2, t, hue_direction='short'):
    """Interpolate in LCH color space (perceptually uniform with hue control)"""
    r1, g1, b1, a1 = color1
    r2, g2, b2, a2 = color2
    
    L1, a1_lab, b1_lab = rgb_to_lab(r1, g1, b1)
    L2, a2_lab, b2_lab = rgb_to_lab(r2, g2, b2)
    
    L1, C1, H1 = lab_to_lch(L1, a1_lab, b1_lab)
    L2, C2, H2 = lab_to_lch(L2, a2_lab, b2_lab)
    
    # Handle hue interpolation direction
    if hue_direction == 'long':
        if H2 > H1:
            H1 += 360
        else:
            H2 += 360
    else:  # short
        diff = H2 - H1
        if diff > 180:
            H1 += 360
        elif diff < -180:
            H2 += 360
    
    L = lerp(L1, L2, t)
    C = lerp(C1, C2, t)
    H = lerp(H1, H2, t) % 360
    
    L_lab, a_lab, b_lab = lch_to_lab(L, C, H)
    r, g, b = lab_to_rgb(L_lab, a_lab, b_lab)
    a = int(lerp(a1, a2, t))
    
    return r, g, b, a

def interpolate_hsl(color1, color2, t, hue_direction='short'):
    """Interpolate in HSL color space"""
    r1, g1, b1, a1 = color1
    r2, g2, b2, a2 = color2
    
    h1, s1, l1 = rgb_to_hsl(r1, g1, b1)
    h2, s2, l2 = rgb_to_hsl(r2, g2, b2)
    
    # Handle hue interpolation direction
    if hue_direction == 'long':
        if h2 > h1:
            h1 += 360
        else:
            h2 += 360
    else:  # short
        diff = h2 - h1
        if diff > 180:
            h1 += 360
        elif diff < -180:
            h2 += 360
    
    h = lerp(h1, h2, t) % 360
    s = lerp(s1, s2, t)
    l = lerp(l1, l2, t)
    
    r, g, b = hsl_to_rgb(h, s, l)
    a = int(lerp(a1, a2, t))
    
    return r, g, b, a

def interpolate_rgb(color1, color2, t):
    """Simple RGB interpolation (original method)"""
    r1, g1, b1, a1 = color1
    r2, g2, b2, a2 = color2
    
    r = int(lerp(r1, r2, t))
    g = int(lerp(g1, g2, t))
    b = int(lerp(b1, b2, t))
    a = int(lerp(a1, a2, t))
    
    return r, g, b, a

def generate_gradient(colors, steps, method='lab', easing='linear', hue_dir='short'):
    """
    Generate a gradient palette with specified number of steps.
    
    Args:
        colors: List of colors in RRGGBBAA format
        steps: Number of gradient steps
        method: 'lab', 'lch', 'hsl', or 'rgb'
        easing: 'linear', 'ease_in_out', 'ease_in', or 'ease_out'
        hue_dir: 'short' or 'long' (for LCH/HSL only)
    """
    if len(colors) < 2:
        raise ValueError("Need at least 2 colors for a gradient")
    
    if steps < len(colors):
        raise ValueError(f"Steps ({steps}) must be >= number of colors ({len(colors)})")
    
    gradient = []
    num_segments = len(colors) - 1
    
    for i in range(steps):
        # Global position (0.0 to 1.0)
        t_global = i / (steps - 1)
        
        # Apply easing
        t_eased = apply_easing(t_global, easing)
        
        # Determine segment
        segment_index = min(int(t_eased * num_segments), num_segments - 1)
        
        # Position within segment
        segment_start = segment_index / num_segments
        segment_end = (segment_index + 1) / num_segments
        t_segment = (t_eased - segment_start) / (segment_end - segment_start)
        
        # Get colors for this segment
        color1 = hex_to_rgba(colors[segment_index])
        color2 = hex_to_rgba(colors[segment_index + 1])
        
        # Interpolate based on method
        if method == 'lab':
            r, g, b, a = interpolate_lab(color1, color2, t_segment)
        elif method == 'lch':
            r, g, b, a = interpolate_lch(color1, color2, t_segment, hue_dir)
        elif method == 'hsl':
            r, g, b, a = interpolate_hsl(color1, color2, t_segment, hue_dir)
        else:  # rgb
            r, g, b, a = interpolate_rgb(color1, color2, t_segment)
        
        gradient.append(rgba_to_hex(r, g, b, a))
    
    return gradient

def format_palette_for_background_script(palette):
    """Format palette as Python list for easy copy-paste"""
    hex_strings = [f"0x{color:08X}" for color in palette]
    
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
    
    print(f"\nMethod: {INTERPOLATION_METHOD.upper()}")
    print(f"Easing: {EASING}")
    if INTERPOLATION_METHOD in ['lch', 'hsl']:
        print(f"Hue direction: {HUE_DIRECTION}")
    
    print(f"\nGenerating {STEP_COUNT} gradient steps...")
    
    gradient = generate_gradient(
        COLORS, 
        STEP_COUNT, 
        INTERPOLATION_METHOD, 
        EASING,
        HUE_DIRECTION
    )
    
    print(f"\n✓ Generated {len(gradient)} colors")
    print("\n" + "=" * 70)
    print("COPY THIS PALETTE TO YOUR BACKGROUND SCRIPT:")
    print("=" * 70)
    print("\n")
    print(format_palette_for_background_script(gradient))
    print("\n")
    print("=" * 70)
    
    # Show preview
    print("\nGradient preview:")
    for i, color in enumerate(gradient):
        r, g, b, a = hex_to_rgba(color)
        print(f"  Step {i+1:2d}: #{color:08X} (R:{r:3d}, G:{g:3d}, B:{b:3d}, A:{a:3d})")
    print("\n")

if __name__ == '__main__':
    main()