import re
import os

# ================= CONFIGURATION =================
ENUM_STRING = """

"""

SOLIDITY_FILE_PATH = "/Users/echo/Downloads/TestSpace/src/FemaleProbabilities.sol"
# =================================================

def audit_two_way():
    # 1. Extract Enum Name
    name_match = re.search(r'enum\s+(\w+)', ENUM_STRING)
    if not name_match: return
    enum_name = name_match.group(1)

    # 2. Extract Enum Members from the string
    members_block = ENUM_STRING[ENUM_STRING.find('{')+1 : ENUM_STRING.rfind('}')]
    enum_members = {m.strip() for m in members_block.split(',') if m.strip()}

    if not os.path.exists(SOLIDITY_FILE_PATH):
        print(f"❌ File not found: {SOLIDITY_FILE_PATH}")
        return

    with open(SOLIDITY_FILE_PATH, 'r') as f:
        content = f.read()

    # 3. Find all instances of "EnumName.Member" inside the Solidity file
    # This regex looks for the Enum name followed by a dot and any word characters
    found_in_file = set(re.findall(rf'{enum_name}\.(\w+)', content))

    print(f"--- 🔍 Two-Way Audit: {enum_name} ---")

    # CHECK 1: Is everything in the Enum used in the File?
    missing_in_file = enum_members - found_in_file
    # We ignore 'None' usually as it might be handled by default, 
    # but let's show it if it's missing just in case.
    
    # CHECK 2: Is there anything in the File that isn't in the Enum?
    # (This catches typos or old traits you deleted from the Enum)
    missing_in_enum = found_in_file - enum_members

    # --- REPORTING ---
    if not missing_in_file and not missing_in_enum:
        print("✅ Perfect Sync: Enum and File match exactly.")
    else:
        if missing_in_file:
            print(f"\n⚠️  UNASSIGNED (In Enum but NOT in File):")
            for m in sorted(missing_in_file):
                print(f"   - {m}")

        if missing_in_enum:
            print(f"\n❌ INVALID (In File but NOT in Enum):")
            for m in sorted(missing_in_enum):
                print(f"   - {m}")
                
    print(f"\nStats: {len(enum_members)} items in Enum | {len(found_in_file)} items used in File.")

if __name__ == "__main__":
    audit_two_way()