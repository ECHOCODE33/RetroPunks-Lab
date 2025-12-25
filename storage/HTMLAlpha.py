#!/usr/bin/env python3
import os

# ============================================================================
# CONFIGURATION
# ============================================================================

# Your gradient palette (RRGGBBAA format)
PALETTE = [
    0x000000FF,
    0x020202FF,
    0x070707FF,
    0x0F0F0FFF,
    0x161616FF,
    0x1E1E1EFF,
    0x272727FF,
    0x333333FF,
    0x404040FF,
    0x4E4E4EFF,
    0x5E5E5EFF,
    0x6E6E6EFF,
    0x808080FF,
    0x919191FF,
    0xA2A2A2FF,
    0xB3B3B3FF,
    0xC3C3C3FF,
    0xD2D2D2FF,
    0xDFDFDFFF,
    0xEAEAEAFF,
    0xF3F3F3FF,
    0xFAFAFAFF,
    0xFEFEFEFF,
    0xFFFFFFFF
]




# Gradient type: 'smooth' or 'pixelated'
GRADIENT_TYPE = 'pixelated'

# Gradient direction (matches SVG linearGradient attributes)
GRADIENT_COORDS = (1, 0, 0, 0)  # x1, y1, x2, y2

# Output file
OUTPUT_FILE = "gradientAlpha.html"

# ============================================================================
# GRADIENT GENERATION (matches TraitsRenderer.sol logic)
# ============================================================================


def rgba_to_components(rgba):
    """Extract RRGGBBAA components"""
    r = (rgba >> 24) & 0xFF
    g = (rgba >> 16) & 0xFF
    b = (rgba >> 8) & 0xFF
    a = rgba & 0xFF
    return r, g, b, a


def format_color_stop(rgba):
    """Format color stop matching Solidity _writeColorStop"""
    r, g, b, a = rgba_to_components(rgba)

    stop = f'stop-color="rgb({r},{g},{b})"'

    if a < 255:
        opacity = a / 255.0
        stop += f' stop-opacity="{opacity:.2f}"'

    return stop


def generate_smooth_gradient_stops(palette):
    """Generate smooth gradient stops (matches _renderSmoothGradientStops)"""
    num_stops = len(palette)
    stops = []

    for i, color in enumerate(palette):
        if num_stops == 1:
            offset = 0.0
        else:
            offset = (i * 100.0) / (num_stops - 1)

        color_stop = format_color_stop(color)
        stops.append(
            f'              <stop offset="{offset:.4f}%" {color_stop}/>')

    return stops


def generate_pixelated_gradient_stops(palette):
    """Generate pixelated gradient stops (matches _renderPixelGradientStops)"""
    num_stops = len(palette)
    stops = []

    for i, color in enumerate(palette):
        start_offset = (i * 100.0) / num_stops
        end_offset = ((i + 1) * 100.0) / num_stops

        color_stop = format_color_stop(color)

        stops.append(
            f'              <stop offset="{start_offset:.4f}%" {color_stop}/>')
        stops.append(
            f'              <stop offset="{end_offset:.4f}%" {color_stop}/>')

    return stops


def generate_html(palette, gradient_type, coords):
    """Generate minimal HTML preview"""
    x1, y1, x2, y2 = coords

    # Generate gradient stops
    if gradient_type == 'smooth':
        stops = generate_smooth_gradient_stops(palette)
    else:  # pixelated
        stops = generate_pixelated_gradient_stops(palette)

    stops_html = '\n'.join(stops)

    html = f"""<!DOCTYPE html>
<html>
  <style>
    body {{
      overflow: hidden;
      margin: 0;
    }}

    svg {{
      max-width: 100vw;
      max-height: 100vh;
      width: 100%;
    }}

    img {{
      image-rendering: pixelated;
    }}
  </style>

  <body>
    <div>
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">
        <g>
          <defs>
            <linearGradient id="bg-gradient" x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}">
{stops_html}
            </linearGradient>
          </defs>
          <rect
            x="0"
            y="0"
            width="48"
            height="48"
            fill="url(#bg-gradient)"
          />
        </g>
        <g id="GeneratedImage">
          <foreignObject width="48" height="48"
            ><img
              xmlns="http://www.w3.org/1999/xhtml"
              src="data:image/png;base64,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"
              width="100%"
              height="100%"
            ></img
          ></foreignObject>
        </g>
      </svg>
    </div>
  </body>
</html>
"""

    return html

# ============================================================================
# MAIN
# ============================================================================


def main():
    print("=" * 70)
    print("GRADIENT PREVIEW GENERATOR")
    print("=" * 70)
    print(f"\nGenerating {GRADIENT_TYPE} gradient...")
    print(f"Colors: {len(PALETTE)}")
    print(
        f"Coords: x1={GRADIENT_COORDS[0]}, y1={GRADIENT_COORDS[1]}, x2={GRADIENT_COORDS[2]}, y2={GRADIENT_COORDS[3]}")

    html = generate_html(PALETTE, GRADIENT_TYPE, GRADIENT_COORDS)

    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        f.write(html)

    print(f"\n✓ {OUTPUT_FILE}")
    print("=" * 70)


if __name__ == '__main__':
    main()
