import re

# Paste your new code block here (Functions, Enums, etc.)
RAW_DATA = """



"""

def validate_traits(input_string):
    # 1. Robustly find the Enum Name (searching the whole string)
    enum_name_match = re.search(r'enum\s+(\w+)\s*\{', input_string)
    if not enum_name_match:
        print("❌ Error: Could not find an enum definition (e.g., 'enum Name { ... }')")
        return
    
    enum_name = enum_name_match.group(1)
    
    # 2. Extract all Enum Values from the curly braces
    enum_block_match = re.search(rf'enum\s+{enum_name}\s*\{{([\s\S]*?)\}}', input_string)
    enum_block = enum_block_match.group(1)
    # Split by comma, remove comments, and clean whitespace
    enum_values = [re.sub(r'//.*', '', v).strip() for v in enum_block.split(',') if v.strip()]

    # 3. Extract all traits used in ANY 'probs[uint(EnumName.TraitName)]' line
    # This regex looks for: probs[uint(ENUM_NAME.TRAIT_NAME)]
    probs_pattern = rf'probs\[uint\({enum_name}\.(\w+)\)\]'
    traits_in_probs = set(re.findall(probs_pattern, input_string))

    # 4. Final Comparison and Output
    print(f"\n--- Validation Report for {enum_name} ---")
    print(f"{'Trait Name':<25} | Status")
    print("-" * 40)

    all_valid = True
    
    for trait in enum_values:
        if trait in traits_in_probs:
            print(f"{trait:<25} | ✅")
        else:
            print(f"{trait:<25} | ❌ (Missing in probs)")
            all_valid = False

    # 5. Check Vice-Versa (Is there something in probs that isn't in the Enum?)
    extra_traits = traits_in_probs - set(enum_values)
    if extra_traits:
        print("\n--- Errors: Found in code but NOT in Enum ---")
        for extra in extra_traits:
            print(f"{extra:<25} | ❌ (Unknown Trait)")
            all_valid = False

    if all_valid:
        print("\n✨ Verification Complete: Everything matches perfectly.")
    else:
        print("\n⚠️ Verification Failed: Discrepancies found.")

if __name__ == "__main__":
    validate_traits(RAW_DATA)