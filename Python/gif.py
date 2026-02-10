#!/usr/bin/env python3
"""
PNG to GIF Converter
Creates an animated GIF from PNG images in a directory with customizable options.

INSTRUCTIONS:
Edit the configuration variables below to customize your GIF, then run the script.
"""

import sys
from pathlib import Path
from PIL import Image


# Path to the directory containing PNG files
DIRECTORY_PATH = '/Users/mani/Downloads/gifs'

# Output GIF filename (will be saved in the same directory as the PNGs)
OUTPUT_FILENAME = "output.gif"

# Frame timing - choose ONE method:
# Method 1: Duration in milliseconds per frame (e.g., 500 = 0.5 seconds per frame)
DURATION = 500
# Method 2: Frames per second (if set, this overrides DURATION)
FPS = None  # Example: 10 for 10 frames per second, or None to use DURATION

# Loop count (0 = loop forever, 1 = play once, 2 = play twice, etc.)
LOOP = 0

# Optimize GIF file size (True = smaller file, False = larger but faster processing)
OPTIMIZE = False

# Quality (1-100, higher = better quality but larger file size)
QUALITY = 100

# Resize options (None = keep original size)
RESIZE_WIDTH = None   # Example: 800 to resize width to 800 pixels
RESIZE_HEIGHT = None  # Example: 600 to resize height to 600 pixels
# If both width and height are set, image will be stretched to exact dimensions
# If only one is set, aspect ratio is maintained

# Reverse the order of frames (True = reverse, False = normal order)
REVERSE = False

# How to sort images before creating GIF
# Options: "name" (alphabetical), "modified" (last modified date), "created" (creation date)
SORT_BY = "name"

# ============================================================================
# END CONFIGURATION
# ============================================================================


def create_gif_from_pngs(
    directory_path,
    output_filename="output.gif",
    duration=500,
    loop=0,
    optimize=True,
    quality=85,
    resize_width=None,
    resize_height=None,
    reverse=False,
    sort_by="name",
    fps=None
):
    """
    Create a GIF from PNG files in a directory.
    """
    
    # Convert path to Path object
    dir_path = Path(directory_path)
    
    # Check if directory exists
    if not dir_path.exists():
        print(f"Error: Directory '{directory_path}' does not exist.")
        sys.exit(1)
    
    if not dir_path.is_dir():
        print(f"Error: '{directory_path}' is not a directory.")
        sys.exit(1)
    
    # Get all PNG files
    png_files = list(dir_path.glob("*.png")) + list(dir_path.glob("*.PNG"))
    
    if not png_files:
        print(f"Error: No PNG files found in '{directory_path}'.")
        sys.exit(1)
    
    # Sort files based on sort_by parameter
    if sort_by == "name":
        png_files.sort(key=lambda x: x.name)
    elif sort_by == "modified":
        png_files.sort(key=lambda x: x.stat().st_mtime)
    elif sort_by == "created":
        png_files.sort(key=lambda x: x.stat().st_ctime)
    else:
        print(f"Warning: Unknown sort method '{sort_by}', using name sort.")
        png_files.sort(key=lambda x: x.name)
    
    # Reverse if requested
    if reverse:
        png_files.reverse()
    
    print(f"Found {len(png_files)} PNG files.")
    print(f"Files in order: {[f.name for f in png_files[:5]]}{'...' if len(png_files) > 5 else ''}")
    
    # Load images
    images = []
    for png_file in png_files:
        try:
            img = Image.open(png_file)
            
            # Convert to RGB if necessary (GIFs don't support transparency well)
            if img.mode in ('RGBA', 'LA', 'P'):
                # Create white background
                background = Image.new('RGB', img.size, (255, 255, 255))
                if img.mode == 'P':
                    img = img.convert('RGBA')
                background.paste(img, mask=img.split()[-1] if img.mode in ('RGBA', 'LA') else None)
                img = background
            elif img.mode != 'RGB':
                img = img.convert('RGB')
            
            # Resize if requested
            if resize_width or resize_height:
                if resize_width and resize_height:
                    img = img.resize((resize_width, resize_height), Image.Resampling.LANCZOS)
                elif resize_width:
                    aspect_ratio = img.height / img.width
                    new_height = int(resize_width * aspect_ratio)
                    img = img.resize((resize_width, new_height), Image.Resampling.LANCZOS)
                else:  # resize_height only
                    aspect_ratio = img.width / img.height
                    new_width = int(resize_height * aspect_ratio)
                    img = img.resize((new_width, resize_height), Image.Resampling.LANCZOS)
            
            images.append(img)
        except Exception as e:
            print(f"Warning: Could not load {png_file.name}: {e}")
    
    if not images:
        print("Error: No images could be loaded successfully.")
        sys.exit(1)
    
    # Calculate duration from fps if provided
    if fps:
        duration = int(1000 / fps)
    
    # Create output path
    output_path = dir_path / output_filename
    
    # Save as GIF
    print(f"\nCreating GIF with {len(images)} frames...")
    print(f"  Duration per frame: {duration}ms" + (f" ({fps} fps)" if fps else ""))
    print(f"  Loop count: {'Infinite' if loop == 0 else loop}")
    print(f"  Optimize: {optimize}")
    print(f"  Output: {output_path}")
    
    try:
        images[0].save(
            output_path,
            save_all=True,
            append_images=images[1:],
            duration=duration,
            loop=loop,
            optimize=optimize,
            quality=quality
        )
        print(f"\n✓ GIF created successfully: {output_path}")
        print(f"  File size: {output_path.stat().st_size / 1024:.2f} KB")
    except Exception as e:
        print(f"Error creating GIF: {e}")
        sys.exit(1)


if __name__ == "__main__":
    # Run the GIF creation with the configuration values from above
    create_gif_from_pngs(
        directory_path=DIRECTORY_PATH,
        output_filename=OUTPUT_FILENAME,
        duration=DURATION,
        loop=LOOP,
        optimize=OPTIMIZE,
        quality=QUALITY,
        resize_width=RESIZE_WIDTH,
        resize_height=RESIZE_HEIGHT,
        reverse=REVERSE,
        sort_by=SORT_BY,
        fps=FPS
    )