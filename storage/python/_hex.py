import base64
import sys
import os

# python3 _hex.py "/Users/echo/Downloads/RPNKSLab/traitsGreyscale/Prototypes/Rainbow.png"
# xxd -p "/Users/echo/Downloads/RPNKSLab/traitsGreyscale/Prototypes/Rainbow.png" | tr -d '\n'

def convert_png_to_hex(file_path):
    # 1. Check if file exists
    if not os.path.exists(file_path):
        print(f"Error: File '{file_path}' not found.")
        return

    try:
        # 2. Read the PNG as binary
        with open(file_path, "rb") as image_file:
            binary_data = image_file.read()

        # 3. Get the Base64 encoding (the 'iVBOR...' part)
        # We decode to utf-8 to get the string version of the base64
        base64_encoded = base64.b64encode(binary_data).decode('utf-8')
        
        # 4. Convert the Base64 string to Hexadecimal
        # We convert the string back to bytes to get the hex representation
        hex_output = base64_encoded.encode('utf-8').hex()

        # Print results to terminal
        print("\n--- Base64 String (Starts with) ---")
        print(base64_encoded[:50] + "...") 
        
        print("\n--- Hexadecimal Output ---")
        print(hex_output)
        
        return hex_output

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        path = sys.argv[1]
        convert_png_to_hex(path)
    else:
        print("Usage: python script.py path/to/your/image.png")