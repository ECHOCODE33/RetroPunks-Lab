#!/usr/bin/env python3
import os

# ============================================================================
# CONFIGURATION
# ============================================================================

# Your gradient palette (RRGGBBAA format)
PALETTE = [
    0x43FF64FF,
    0x5BFF6AFF,
    0x73FF70FF,
    0x8BFF76FF,
    0xA3FF7CFF,
    0xBBFF82FF,
    0xD3FF88FF,
    0xEBFF8EFF,
    0xFFFA94FF,
    0xFFE29AFF,
    0xFFCAA0FF,
    0xFFB2A6FF,
    0xFF9AACFF,
    0xFF82B2FF,
    0xFF6AB8FF,
    0xFF52BEFF,
    0xFF3AC4FF,
    0xFF22CAFF,
    0xFF0AD0FF,
    0xFF00D6FF,
    0xFF00DCFF,
    0xFF00E2FF,
    0xFF00EBFF,
    0xFF0055FF
]

# Gradient type: 'smooth' or 'pixelated'
GRADIENT_TYPE = 'smooth'

# Gradient direction (matches SVG linearGradient attributes)
# Common presets:
#   Vertical: (0, 0, 0, 1)
#   Horizontal: (0, 0, 1, 0)
#   Diagonal: (0, 0, 1, 1)
#   Reverse diagonal: (1, 0, 0, 1)
GRADIENT_COORDS = (0, 0, 0, 1)  # x1, y1, x2, y2

# Canvas size (matches your NFT dimensions)
CANVAS_WIDTH = 48
CANVAS_HEIGHT = 48

# Scale factor for preview (makes it easier to see)
PREVIEW_SCALE = 10

# Output file
OUTPUT_FILE = "gradientBeta.html"

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
    
    # Add opacity if not fully opaque (matches Solidity logic)
    if a < 255:
        # Convert alpha to decimal (0.xx format)
        opacity = a / 255.0
        stop += f' stop-opacity="{opacity:.2f}"'
    
    return stop

def generate_smooth_gradient_stops(palette):
    """
    Generate smooth gradient stops (matches _renderSmoothGradientStops)
    Each color gets one stop, evenly distributed from 0% to 100%
    """
    num_stops = len(palette)
    stops = []
    
    for i, color in enumerate(palette):
        # Evenly distribute stops from 0% to 100%
        # Formula: (i * 100) / (numStops - 1)
        if num_stops == 1:
            offset = 0.0
        else:
            offset = (i * 100.0) / (num_stops - 1)
        
        color_stop = format_color_stop(color)
        stops.append(f'    <stop offset="{offset:.4f}%" {color_stop}/>')
    
    return stops

def generate_pixelated_gradient_stops(palette):
    """
    Generate pixelated gradient stops (matches _renderPixelGradientStops)
    Each color gets two stops at different offsets for hard edges
    """
    num_stops = len(palette)
    stops = []
    
    for i, color in enumerate(palette):
        # Calculate start and end offsets for this color band
        # Formula: (i * 100) / numStops and ((i+1) * 100) / numStops
        start_offset = (i * 100.0) / num_stops
        end_offset = ((i + 1) * 100.0) / num_stops
        
        color_stop = format_color_stop(color)
        
        # Two stops at different offsets with same color = hard edge
        stops.append(f'    <stop offset="{start_offset:.4f}%" {color_stop}/>')
        stops.append(f'    <stop offset="{end_offset:.4f}%" {color_stop}/>')
    
    return stops

def generate_html(palette, gradient_type, coords, canvas_w, canvas_h, scale):
    """Generate complete HTML preview"""
    x1, y1, x2, y2 = coords
    
    # Generate gradient stops based on type
    if gradient_type == 'smooth':
        stops = generate_smooth_gradient_stops(palette)
    else:  # pixelated
        stops = generate_pixelated_gradient_stops(palette)
    
    stops_html = '\n'.join(stops)
    
    # Scaled dimensions for preview
    preview_w = canvas_w * scale
    preview_h = canvas_h * scale
    
    # Generate palette info for display
    palette_info = []
    for i, color in enumerate(palette):
        r, g, b, a = rgba_to_components(color)
        palette_info.append(f"      <div style='display:flex; align-items:center; gap:10px; margin:2px 0;'>")
        palette_info.append(f"        <div style='width:30px; height:20px; background:rgba({r},{g},{b},{a/255:.2f}); border:1px solid #ccc;'></div>")
        palette_info.append(f"        <span style='font-family:monospace; font-size:12px;'>#{color:08X} (R:{r:3d} G:{g:3d} B:{b:3d} A:{a:3d})</span>")
        palette_info.append(f"      </div>")
    
    palette_html = '\n'.join(palette_info)
    
    html = f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gradient Preview - {gradient_type.title()}</title>
  <style>
    body {{
      margin: 0;
      padding: 20px;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      background: #1a1a1a;
      color: #fff;
    }}
    .container {{
      max-width: 1200px;
      margin: 0 auto;
    }}
    h1 {{
      font-size: 24px;
      margin-bottom: 10px;
    }}
    .info {{
      background: #2a2a2a;
      padding: 15px;
      border-radius: 8px;
      margin-bottom: 20px;
      font-size: 14px;
      line-height: 1.6;
    }}
    .preview-section {{
      display: flex;
      gap: 30px;
      flex-wrap: wrap;
    }}
    .svg-container {{
      background: #2a2a2a;
      padding: 20px;
      border-radius: 8px;
      display: inline-block;
    }}
    .palette-container {{
      background: #2a2a2a;
      padding: 20px;
      border-radius: 8px;
      flex: 1;
      min-width: 300px;
    }}
    .palette-title {{
      font-size: 16px;
      font-weight: 600;
      margin-bottom: 15px;
    }}
    svg {{
      border: 2px solid #444;
      background: white;
      image-rendering: pixelated;
      image-rendering: crisp-edges;
    }}
    .label {{
      font-weight: 600;
      color: #60a5fa;
    }}
  </style>
</head>
<body>
  <div class="container">
    <h1>🎨 Gradient Preview</h1>
    
    <div class="info">
      <div><span class="label">Type:</span> {gradient_type.title()}</div>
      <div><span class="label">Coordinates:</span> x1={x1}, y1={y1}, x2={x2}, y2={y2}</div>
      <div><span class="label">Canvas:</span> {canvas_w}×{canvas_h}px (scaled {scale}x for preview)</div>
      <div><span class="label">Colors:</span> {len(palette)} stops</div>
      <div style="margin-top:10px; padding-top:10px; border-top:1px solid #444;">
        <span class="label">Note:</span> This matches the exact rendering logic from TraitsRenderer.sol
      </div>
    </div>
    
    <div class="preview-section">
      <div class="svg-container">
        <svg xmlns="http://www.w3.org/2000/svg" 
             viewBox="0 0 {canvas_w} {canvas_h}" 
             width="{preview_w}" 
             height="{preview_h}"
             shape-rendering="crispEdges">
          <defs>
            <linearGradient id="gradient" x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}">
{stops_html}
            </linearGradient>
          </defs>
          <rect width="{canvas_w}" height="{canvas_h}" fill="url(#gradient)"/>
        </svg>
      </div>
      
      <div class="palette-container">
        <div class="palette-title">Color Palette ({len(palette)} colors)</div>
{palette_html}
      </div>
    </div>
  </div>
</body>
</html>"""
    
    return html

# ============================================================================
# MAIN
# ============================================================================

def main():
    print("=" * 70)
    print("GRADIENT PREVIEW GENERATOR")
    print("=" * 70)
    print(f"\nGenerating {GRADIENT_TYPE} gradient preview...")
    print(f"Palette: {len(PALETTE)} colors")
    print(f"Coordinates: x1={GRADIENT_COORDS[0]}, y1={GRADIENT_COORDS[1]}, x2={GRADIENT_COORDS[2]}, y2={GRADIENT_COORDS[3]}")
    
    html = generate_html(
        PALETTE,
        GRADIENT_TYPE,
        GRADIENT_COORDS,
        CANVAS_WIDTH,
        CANVAS_HEIGHT,
        PREVIEW_SCALE
    )
    
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        f.write(html)
    
    print(f"\n✓ Generated: {OUTPUT_FILE}")
    print(f"  Open this file in your browser to preview the gradient")
    print(f"  Preview size: {CANVAS_WIDTH * PREVIEW_SCALE}×{CANVAS_HEIGHT * PREVIEW_SCALE}px")
    print("\n" + "=" * 70)

if __name__ == '__main__':
    main()