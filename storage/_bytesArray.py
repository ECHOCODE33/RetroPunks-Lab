import re

def generate_hex_string():
    # ---------------------------------------------------------
    # PASTE YOUR SOLIDITY CODE INSIDE THIS STRING VARIABLE
    # ---------------------------------------------------------
    input_code = """
            
probs[uint(E_Male_Eyes.None)] = 0;
            probs[uint(E_Male_Eyes.Left)] = 4125;
            probs[uint(E_Male_Eyes.Right)] = 4125;
            probs[uint(E_Male_Eyes.Tired_Left)] = 500;
            probs[uint(E_Male_Eyes.Tired_Right)] = 500;
            probs[uint(E_Male_Eyes.Confused)] = 250;
            probs[uint(E_Male_Eyes.Tired_Confused)] = 125;
            probs[uint(E_Male_Eyes.Closed)] = 100;
            probs[uint(E_Male_Eyes.Wink)] = 76;
            probs[uint(E_Male_Eyes.Blind)] = 50;
            probs[uint(E_Male_Eyes.Clown_Eyes_Blue)] = 11;
            probs[uint(E_Male_Eyes.Clown_Eyes_Green)] = 11;
            probs[uint(E_Male_Eyes.Clown_Eyes_Orange)] = 11;
            probs[uint(E_Male_Eyes.Clown_Eyes_Pink)] = 11;
            probs[uint(E_Male_Eyes.Clown_Eyes_Purple)] = 11;
            probs[uint(E_Male_Eyes.Clown_Eyes_Red)] = 11;
            probs[uint(E_Male_Eyes.Clown_Eyes_Sky_Blue)] = 11;
            probs[uint(E_Male_Eyes.Clown_Eyes_Turquoise)] = 11;
            probs[uint(E_Male_Eyes.Clown_Eyes_Yellow)] = 11;
            probs[uint(E_Male_Eyes.Possessed_Left)] = 25;
            probs[uint(E_Male_Eyes.Possessed_Right)] = 25;
            probs[uint(E_Male_Eyes.Ghost_Left)] = 0;
            probs[uint(E_Male_Eyes.Ghost_Right)] = 0;


    """
    # ---------------------------------------------------------

    parsed_data = []
    total_weight = 0

    # Regex to capture: E_Enum.Name and Value
    regex = r"probs\[uint\([^.]+\.([^)]+)\)\]\s*=\s*(\d+)"

    # 1. Parse lines
    for line in input_code.strip().split('\n'):
        match = re.search(regex, line)
        if match:
            name = match.group(1).strip()
            value = int(match.group(2).strip())
            parsed_data.append({'name': name, 'value': value})
            total_weight += value

    # 2. Custom Sort Logic
    # Group A: Always None
    none_items = [x for x in parsed_data if x['name'] == 'None']
    
    # Group B: Starts with underscore (e.g., _3D_Glasses)
    underscore_items = [x for x in parsed_data if x['name'].startswith('_')]
    underscore_items.sort(key=lambda x: x['name'])
    
    # Group C: Everything else
    other_items = [x for x in parsed_data if x['name'] != 'None' and not x['name'].startswith('_')]
    other_items.sort(key=lambda x: x['name'])
    
    # Combine in specific order
    final_order = none_items + underscore_items + other_items

    # 3. Build Hex String and Print Table
    hex_output = ""
    
    print("")
    print(f"{'Index':<6} | {'Trait Name':<25} | {'Weight':<6} | {'Hex (2 Bytes)'}")
    print("-" * 60)

    for index, item in enumerate(final_order):
        val = item['value']
        
        # Only the Value (4 hex chars / 2 bytes)
        segment = f"{val:04X}" 
        hex_output += segment

        print(f"{index:<6} | {item['name']:<25} | {val:<6} | {segment}")

    print("-" * 60)
    print(f"TOTAL SUM OF WEIGHTS: {total_weight}")
    print("-" * 60)
    print("\nFINAL HEX STRING (Values only):")
    print(hex_output)
    print("")

if __name__ == "__main__":
    generate_hex_string()