import re

# PASTE YOUR RAW PROBS HERE
input_string = """
                









"""

def generate_eyes_block(data):
    # Regex to capture Enum, Trait, and Weight
    pattern = r"probs\[uint\((.*?)\.(.*?)\)\]\s*=\s*(\d+);"
    matches = re.findall(pattern, data)
    if not matches: return

    detected_enum = matches[0][0]
    total_weight = sum(int(m[2]) for m in matches)
    cumulative = 0
    items = []

    for enum_name, trait, weight in matches:
        w_int = int(weight)
        cumulative += w_int
        pct = f"{(w_int / total_weight * 100 if total_weight > 0 else 0):g}%"
        items.append({
            "assign": f"probs[uint({enum_name}.{trait})]",
            "total_str": f"{cumulative};",
            "weight": weight,
            "pct": pct
        })

    max_assign = max(len(i["assign"]) for i in items)
    max_total = max(len(i["total_str"]) for i in items)

    print("            unchecked {")
    for i in items:
        col1 = f"                {i['assign'].ljust(max_assign + 1)}"
        col2 = f"= {i['total_str']}".ljust(max_total + 3)
        print(f"{col1}{col2}// weight: {i['weight']} ({i['pct']})")
    print("            }")
    print(f"\n            return {detected_enum}(_select(rndCtx, probs, {total_weight}));")

if __name__ == "__main__":
    generate_eyes_block(input_string)