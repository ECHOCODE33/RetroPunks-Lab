import os

# ==========================================
# CONFIGURATION
# ==========================================

# Replace this string with the absolute or relative path to your target directory
ROOT_DIRECTORY = r"src" 

# The name of the resulting markdown file
OUTPUT_FILENAME = "all_contracts.md"

# ==========================================
# SCRIPT LOGIC
# ==========================================

def compile_solidity_files_to_md(root_dir, output_file):
    # Check if the directory actually exists
    if not os.path.exists(root_dir):
        print(f"Error: The directory '{root_dir}' does not exist.")
        return

    print(f"Scanning directory: {root_dir}...")
    
    count = 0
    
    try:
        # Open the output file in write mode
        with open(output_file, "w", encoding="utf-8") as md_file:
            
            # Walk through the directory tree recursively
            for current_root, dirs, files in os.walk(root_dir):
                for file in files:
                    if file.endswith(".sol"):
                        full_path = os.path.join(current_root, file)
                        
                        # Calculate the relative path (e.g., contracts/MyContract.sol)
                        relative_path = os.path.relpath(full_path, root_dir)
                        
                        # Convert backslashes to forward slashes for better Markdown rendering on Windows
                        relative_path_formatted = relative_path.replace(os.sep, '/')
                        
                        try:
                            # Read the content of the solidity file
                            with open(full_path, "r", encoding="utf-8") as sol_file:
                                content = sol_file.read()
                                
                            # Write the formatted section to the Markdown file
                            md_file.write(f"### {relative_path_formatted}\n")
                            md_file.write("```solidity\n")
                            md_file.write(content)
                            
                            # Ensure there is a newline if the file doesn't end with one
                            if not content.endswith('\n'):
                                md_file.write("\n")
                                
                            md_file.write("```\n\n")
                            
                            print(f"Processed: {relative_path_formatted}")
                            count += 1
                            
                        except Exception as e:
                            print(f"Failed to read {relative_path}: {e}")

        print(f"------------------------------------------------")
        print(f"Success! {count} Solidity files combined into '{output_file}'")

    except Exception as e:
        print(f"An error occurred while creating the output file: {e}")

# Run the function
if __name__ == "__main__":
    compile_solidity_files_to_md(ROOT_DIRECTORY, OUTPUT_FILENAME)