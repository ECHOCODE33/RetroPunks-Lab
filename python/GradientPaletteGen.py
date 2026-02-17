#!/usr/bin/env python3
import math

# ============================================================================
# CONFIGURATION
# ============================================================================

COLORS = [
    "#000000ff",
    "#ffffffff",
]

STEP_COUNT = 24

# Options: 'lab' (best perceptual quality), 'lch', 'hsl', 'rgb'
INTERPOLATION_METHOD = 'lab'

# Options: 'linear', 'ease_in_out', 'ease_in', 'ease_out'
EASING = 'ease_in_out'

# For 'lch' or 'hsl' only: 'short' or 'long'
HUE_DIRECTION = 'short'

# ============================================================================
# COLOR PARSING & FORMATTING
# ============================================================================

def parse_color(color_str):
    """Parse #rrggbb, #rrggbbaa, #rgb, #rgba, 0xRRGGBBAA → (r,g,b,a)"""
    color_str = str(color_str).strip().lower()

    if color_str.startswith('0x'):
        val = int(color_str, 16)
        return (
            (val >> 24) & 0xFF,
            (val >> 16) & 0xFF,
            (val >>  8) & 0xFF,
            val & 0xFF
        )

    if color_str.startswith('#'):
        hex_part = color_str[1:]

        if len(hex_part) in (3, 4):  # short #rgb or #rgba
            r = int(hex_part[0], 16) * 17
            g = int(hex_part[1], 16) * 17
            b = int(hex_part[2], 16) * 17
            a = int(hex_part[3], 16) * 17 if len(hex_part) == 4 else 255
            return (r, g, b, a)

        if len(hex_part) in (6, 8):  # full #rrggbb or #rrggbbaa
            r = int(hex_part[0:2], 16)
            g = int(hex_part[2:4], 16)
            b = int(hex_part[4:6], 16)
            a = int(hex_part[6:8], 16) if len(hex_part) == 8 else 255
            return (r, g, b, a)

    raise ValueError(f"Invalid color: {color_str}")

def rgba_to_hex(r, g, b, a):
    """Convert (r,g,b,a) → #rrggbbaa (lowercase)"""
    return f"#{r:02x}{g:02x}{b:02x}{a:02x}"

# ============================================================================
# COLOR SPACE CONVERSIONS
# ============================================================================

def rgb_to_xyz(r, g, b):
    r, g, b = r/255.0, g/255.0, b/255.0
    r = ((r + 0.055) / 1.055) ** 2.4 if r > 0.04045 else r / 12.92
    g = ((g + 0.055) / 1.055) ** 2.4 if g > 0.04045 else g / 12.92
    b = ((b + 0.055) / 1.055) ** 2.4 if b > 0.04045 else b / 12.92
    x = r * 0.4124564 + g * 0.3575761 + b * 0.1804375
    y = r * 0.2126729 + g * 0.7151522 + b * 0.0721750
    z = r * 0.0193339 + g * 0.1191920 + b * 0.9503041
    return x * 100, y * 100, z * 100

def xyz_to_lab(x, y, z):
    x, y, z = x / 95.047, y / 100.0, z / 108.883
    def f(t): return t ** (1/3) if t > 0.008856 else (7.787 * t) + (16/116)
    fx, fy, fz = f(x), f(y), f(z)
    L = 116 * fy - 16
    a = 500 * (fx - fy)
    b = 200 * (fy - fz)
    return L, a, b

def lab_to_xyz(L, a, b):
    fy = (L + 16) / 116
    fx = (a / 500) + fy
    fz = fy - (b / 200)
    def f_inv(t): return t ** 3 if t ** 3 > 0.008856 else (t - 16/116) / 7.787
    x = f_inv(fx) * 95.047
    y = f_inv(fy) * 100.0
    z = f_inv(fz) * 108.883
    return x, y, z

def xyz_to_rgb(x, y, z):
    x, y, z = x / 100, y / 100, z / 100
    r = x *  3.2404542 + y * -1.5371385 + z * -0.4985314
    g = x * -0.9692660 + y *  1.8760108 + z *  0.0415560
    b = x *  0.0556434 + y * -0.2040259 + z *  1.0572252
    def gamma(c): return 1.055 * (c ** (1/2.4)) - 0.055 if c > 0.0031308 else 12.92 * c
    r, g, b = gamma(r), gamma(g), gamma(b)
    r = max(0, min(255, int(r * 255 + 0.5)))
    g = max(0, min(255, int(g * 255 + 0.5)))
    b = max(0, min(255, int(b * 255 + 0.5)))
    return r, g, b

def rgb_to_lab(r, g, b):
    x, y, z = rgb_to_xyz(r, g, b)
    return xyz_to_lab(x, y, z)

def lab_to_rgb(L, a, b):
    x, y, z = lab_to_xyz(L, a, b)
    return xyz_to_rgb(x, y, z)

def lab_to_lch(L, a, b):
    C = math.sqrt(a*a + b*b)
    H = math.atan2(b, a) * 180 / math.pi
    if H < 0: H += 360
    return L, C, H

def lch_to_lab(L, C, H):
    H_rad = H * math.pi / 180
    a = C * math.cos(H_rad)
    b = C * math.sin(H_rad)
    return L, a, b

def rgb_to_hsl(r, g, b):
    r, g, b = r/255.0, g/255.0, b/255.0
    max_c, min_c = max(r,g,b), min(r,g,b)
    diff = max_c - min_c
    l = (max_c + min_c) / 2
    if diff == 0:
        return 0, 0, l
    s = diff / (2 - max_c - min_c) if l > 0.5 else diff / (max_c + min_c)
    if max_c == r:
        h = ((g - b) / diff + (6 if g < b else 0)) / 6
    elif max_c == g:
        h = ((b - r) / diff + 2) / 6
    else:
        h = ((r - g) / diff + 4) / 6
    return h * 360, s, l

def hsl_to_rgb(h, s, l):
    h = h / 360.0
    def hue2rgb(p, q, t):
        if t < 0: t += 1
        if t > 1: t -= 1
        if t < 1/6: return p + (q - p) * 6 * t
        if t < 1/2: return q
        if t < 2/3: return p + (q - p) * (2/3 - t) * 6
        return p
    if s == 0:
        return int(l*255+0.5), int(l*255+0.5), int(l*255+0.5)
    q = l * (1 + s) if l < 0.5 else l + s - l * s
    p = 2 * l - q
    r = hue2rgb(p, q, h + 1/3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1/3)
    return int(r*255+0.5), int(g*255+0.5), int(b*255+0.5)

# ============================================================================
# EASING FUNCTIONS
# ============================================================================

def ease_in_out(t):
    return (1 - math.cos(t * math.pi)) / 2

def ease_in(t):
    return t * t

def ease_out(t):
    return 1 - (1 - t) * (1 - t)

def apply_easing(t, easing_type):
    if easing_type == 'ease_in_out': return ease_in_out(t)
    if easing_type == 'ease_in':     return ease_in(t)
    if easing_type == 'ease_out':    return ease_out(t)
    return t

# ============================================================================
# INTERPOLATION
# ============================================================================

def lerp(a, b, t):
    return a + (b - a) * t

def interpolate_lab(c1, c2, t):
    r1,g1,b1,a1 = c1
    r2,g2,b2,a2 = c2
    L1, a1_lab, b1_lab = rgb_to_lab(r1,g1,b1)
    L2, a2_lab, b2_lab = rgb_to_lab(r2,g2,b2)
    L   = lerp(L1,   L2,   t)
    a_l = lerp(a1_lab, a2_lab, t)
    b_l = lerp(b1_lab, b2_lab, t)
    r,g,b = lab_to_rgb(L, a_l, b_l)
    a = int(lerp(a1, a2, t) + 0.5)
    return r,g,b,a

def interpolate_lch(c1, c2, t, hue_dir='short'):
    r1,g1,b1,a1 = c1
    r2,g2,b2,a2 = c2
    L1,aa1,bb1 = rgb_to_lab(r1,g1,b1)
    L2,aa2,bb2 = rgb_to_lab(r2,g2,b2)
    L1,C1,H1 = lab_to_lch(L1,aa1,bb1)
    L2,C2,H2 = lab_to_lch(L2,aa2,bb2)
    if hue_dir == 'long':
        if H2 > H1: H1 += 360
        else:       H2 += 360
    else:
        diff = H2 - H1
        if diff > 180:  H1 += 360
        elif diff < -180: H2 += 360
    L = lerp(L1, L2, t)
    C = lerp(C1, C2, t)
    H = lerp(H1, H2, t) % 360
    L_lab,aa,bb = lch_to_lab(L, C, H)
    r,g,b = lab_to_rgb(L_lab, aa, bb)
    a = int(lerp(a1,a2,t) + 0.5)
    return r,g,b,a

def interpolate_hsl(c1, c2, t, hue_dir='short'):
    r1,g1,b1,a1 = c1
    r2,g2,b2,a2 = c2
    h1,s1,l1 = rgb_to_hsl(r1,g1,b1)
    h2,s2,l2 = rgb_to_hsl(r2,g2,b2)
    if hue_dir == 'long':
        if h2 > h1: h1 += 360
        else:       h2 += 360
    else:
        diff = h2 - h1
        if diff > 180:  h1 += 360
        elif diff < -180: h2 += 360
    h = lerp(h1, h2, t) % 360
    s = lerp(s1, s2, t)
    l = lerp(l1, l2, t)
    r,g,b = hsl_to_rgb(h, s, l)
    a = int(lerp(a1,a2,t) + 0.5)
    return r,g,b,a

def interpolate_rgb(c1, c2, t):
    return tuple(int(lerp(v1, v2, t) + 0.5) for v1,v2 in zip(c1, c2))

# ============================================================================
# GRADIENT GENERATION
# ============================================================================

def generate_gradient(colors_input, steps, method='lab', easing='linear', hue_dir='short'):
    parsed = [parse_color(c) for c in colors_input]
    if len(parsed) < 2:
        raise ValueError("Need at least 2 colors")
    if steps < len(parsed):
        raise ValueError("Steps must be >= number of colors")

    gradient = []
    num_segments = len(parsed) - 1

    for i in range(steps):
        t_global = i / (steps - 1)
        t = apply_easing(t_global, easing)
        seg_idx = min(int(t * num_segments), num_segments - 1)
        seg_t = (t - seg_idx / num_segments) / (1 / num_segments)
        c1 = parsed[seg_idx]
        c2 = parsed[seg_idx + 1]

        if method == 'lab':
            interp = interpolate_lab
        elif method == 'lch':
            interp = lambda c1,c2,t: interpolate_lch(c1,c2,t,hue_dir)
        elif method == 'hsl':
            interp = lambda c1,c2,t: interpolate_hsl(c1,c2,t,hue_dir)
        else:
            interp = interpolate_rgb

        gradient.append(interp(c1, c2, seg_t))

    return gradient

# ============================================================================
# OUTPUT FORMATTING
# ============================================================================

def format_palette_hex(palette):
    """Format as array of #rrggbbaa hex strings"""
    lines = []
    for (r,g,b,a) in palette:
        hex_val = rgba_to_hex(r, g, b, a)
        lines.append(f'"{hex_val}"')
    output = "[\n    " + ",\n    ".join(lines) + "\n]"
    return output

def main():
    print("=" * 70)
    print("GRADIENT PALETTE GENERATOR")
    print("=" * 70)

    print(f"\nInput colors: {len(COLORS)}")
    for i, c in enumerate(COLORS):
        r,g,b,a = parse_color(c)
        print(f"  Color {i+1}: {c:>12} → rgba({r:3d},{g:3d},{b:3d},{a:3d})")

    print(f"\nMethod:          {INTERPOLATION_METHOD.upper()}")
    print(f"Easing:          {EASING}")
    if INTERPOLATION_METHOD in ['lch', 'hsl']:
        print(f"Hue direction:   {HUE_DIRECTION}")
    print(f"Steps:           {STEP_COUNT}")

    print(f"\nGenerating {STEP_COUNT} gradient steps...")
    gradient = generate_gradient(
        COLORS, STEP_COUNT, INTERPOLATION_METHOD, EASING, HUE_DIRECTION
    )

    print(f"\n✓ Generated {len(gradient)} colors")
    print("\n" + "=" * 70)
    print("COPY THIS PALETTE (#rrggbbaa format):")
    print("=" * 70)
    print("\n" + format_palette_hex(gradient))
    print("\n" + "=" * 70)

    print("\nGradient preview (RGBA + hex):")
    for i, (r,g,b,a) in enumerate(gradient):
        print(f"  Step {i+1:2d}: rgba({r:3d},{g:3d},{b:3d},{a:3d})  {rgba_to_hex(r,g,b,a)}")

    print("\n" + "=" * 70)

if __name__ == '__main__':
    main()