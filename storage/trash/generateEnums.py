import os
import re

def clean_identifier(name):
    """Converts a string like '3D Glasses' or 'Hat Pink' into a valid Solidity identifier."""
    # Remove file extension if present
    name = os.path.splitext(name)[0]
    # Replace spaces and hyphens with underscores
    name = re.sub(r'[\s\-]+', '_', name)
    # Remove any other non-alphanumeric characters
    name = re.sub(r'[^a-zA-Z0-9_]', '', name)
    # Solidity identifiers can't start with a number; prefix with an underscore if it does
    if name[0].isdigit():
        name = "_" + name
    return name

def generate_solidity_enums(root_dir):
    # The specific order requested by the user
    priority_order = [
        "Male Skin", "Male Eyes", "Male Face", "Male Chain", "Male Earring", 
        "Male Scarf", "Male Facial Hair", "Male Mask", "Male Hair", 
        "Male Hat Hair", "Male Headwear", "Male Eye Wear", "Female Skin", 
        "Female Eyes", "Female Face", "Female Chain", "Female Earring", 
        "Female Scarf", "Female Mask", "Female Hair", "Female Hat Hair", 
        "Female Headwear", "Female Eye Wear", "Mouth"
    ]

    # Find all subdirectories
    all_folders = [d for d in os.listdir(root_dir) if os.path.isdir(os.path.join(root_dir, d))]
    
    # Sort them: priority items first, then the rest alphabetically
    sorted_folders = []
    for p in priority_order:
        if p in all_folders:
            sorted_folders.append(p)
    
    for f in sorted(all_folders):
        if f not in sorted_folders:
            sorted_folders.append(f)

    # Build the Solidity content
    output = [
        "// SPDX-License-Identifier: MIT",
        "pragma solidity ^0.8.30;\n",
        "/**",
        " * @dev Automatically generated Enum file from asset directory",
        " */"
    ]

    for folder in sorted_folders:
        # Create Enum Name: "Male Skin" -> E_Male_Skin
        enum_name = "E_" + folder.replace(" ", "_")
        output.append(f"enum {enum_name} {{")
        
        # Always start with None
        entries = ["    None"]
        
        # Get all PNG files in folder
        folder_path = os.path.join(root_dir, folder)
        files = sorted([f for f in os.listdir(folder_path) if f.lower().endswith('.png')])
        
        for file in files:
            entries.append("    " + clean_identifier(file))
        
        output.append(",\n".join(entries))
        output.append("}\n")

    # Write to file
    with open("Enums.sol", "w") as f:
        f.write("\n".join(output))
    
    print(f"Successfully generated Enums.sol with {len(sorted_folders)} enums.")

if __name__ == "__main__":
    # Change 'assets' to the path of your main directory
    target_directory = "/Users/mani/Downloads/RPNKSLab/traitsColor" 
    if os.path.exists(target_directory):
        generate_solidity_enums(target_directory)
    else:
        print(f"Error: Directory '{target_directory}' not found.")