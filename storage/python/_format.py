import re

# Paste your raw Solidity weight assignments here
input_string = """
      



// None = 9000 (90%)
            probs[uint(E_Female_Chain.None)] = 9000;

        // Chain = 1000 (10%)
            probs[uint(E_Female_Chain.Chain_Onyx)] = 350;
            probs[uint(E_Female_Chain.Chain_Amethyst)] = 250;
            probs[uint(E_Female_Chain.Chain_Gold)] = 140;
            probs[uint(E_Female_Chain.Chain_Sapphire)] = 100;
            probs[uint(E_Female_Chain.Chain_Emerald)] = 75;
            probs[uint(E_Female_Chain.Chain_Ruby)] = 50;
            probs[uint(E_Female_Chain.Chain_Diamond)] = 25;
            probs[uint(E_Female_Chain.Chain_Pink_Diamond)] = 10;
        
        



"""

def generate_cumulative_probs(data):
    # Regex to find the trait name and the weight value
    pattern = r"probs\[uint\((.*?)\)\]\s*=\s*(\d+);"
    matches = re.findall(pattern, data)
    
    if not matches:
        print("No matches found. Check your input formatting.")
        return

    cumulative_sum = 0
    items = []
    
    # Pass 1: Gather raw parts and calculate cumulative totals
    for trait, weight in matches:
        cumulative_sum += int(weight)
        items.append({
            "assign": f"probs[uint({trait})]",
            "total_str": f"{cumulative_sum};",
            "weight": weight
        })

    # Pass 2: Calculate maximum lengths for each column
    max_assign_len = max(len(i["assign"]) for i in items)
    max_total_len = max(len(i["total_str"]) for i in items)

    # Output Generation
    print("// Optimized Cumulative Thresholds (Perfect Column Alignment)")
    print("\nunchecked {")
    for i in items:
        # Col 1: Assignment (ljust to max + 1 for space before '=')
        col1 = f"            {i['assign'].ljust(max_assign_len + 1)}"
        
        # Col 2: The Equals sign and the Value (ljust to max + 1 for space before '//')
        # We add the '= ' prefix to the total_str to align the numbers correctly
        value_part = f"= {i['total_str']}"
        
        # To align the comments based on the longest value, 
        # we calculate the padding needed for the value part specifically
        # (len of '= ' is 2, so we pad to max_total_len + 2)
        col2 = value_part.ljust(max_total_len + 3)
        
        print(f"{col1}{col2}// weight: {i['weight']}")
    print("        }\n")

if __name__ == "__main__":
    generate_cumulative_probs(input_string)