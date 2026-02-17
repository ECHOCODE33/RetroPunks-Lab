from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ADD_PATH = ROOT / "script" / "AddAssetsBatch.s.sol"
OUTPUT_DIR = ROOT / "output"

BACKGROUND_PATH = OUTPUT_DIR / "background_asset_compressed.txt"
COMBINED_PATH = OUTPUT_DIR / "traits_asset_compressed.txt"
SPECIAL_PATH = OUTPUT_DIR / "special_asset_compressed.txt"

ASSET_PATTERN = re.compile(
    r"AssetEntry\(\{\s*key:\s*[^,]+,\s*name:\s*\"(?P<name>[^\"]+)\",\s*"
    r"compressedData:\s*hex\"(?P<hex>[^\"]*)\"\s*\}\)",
    re.DOTALL
)


def _load_single_line(path: Path) -> tuple[str, str] | None:
    if not path.exists():
        raise FileNotFoundError(f"Missing file: {path}")
    text = path.read_text().strip()
    if not text:
        return None
    key, value = text.split(":", 1)
    return key.strip(), value.strip()


def _load_mapping() -> dict[str, str]:
    mapping: dict[str, str] = {}

    background = _load_single_line(BACKGROUND_PATH)
    if background:
        mapping[background[0]] = background[1]

    special = _load_single_line(SPECIAL_PATH)
    if special:
        mapping[special[0]] = special[1]

    if not COMBINED_PATH.exists():
        raise FileNotFoundError(f"Missing file: {COMBINED_PATH}")
    for line in COMBINED_PATH.read_text().splitlines():
        if not line.strip():
            continue
        key, value = line.split(":", 1)
        mapping[key.strip()] = value.strip()

    # Normalize trait group keys to asset names.
    normalized: dict[str, str] = {}
    for key, value in mapping.items():
        if key.endswith("_Group"):
            normalized[key[:-6].replace("_", " ")] = value
        else:
            normalized[key] = value

    return normalized


def main() -> None:
    name_to_hex = _load_mapping()
    content = ADD_PATH.read_text()

    replaced = 0
    missing: set[str] = set()

    def replacer(match: re.Match) -> str:
        nonlocal replaced
        name = match.group("name")
        if name not in name_to_hex:
            missing.add(name)
            return match.group(0)
        new_hex = name_to_hex[name]
        if not new_hex.startswith("0x"):
            raise ValueError(f"Expected hex to start with 0x for {name}")
        replaced += 1
        # Reconstruct the entry with new hex (avoid simple replace which can corrupt data)
        full_match = match.group(0)
        old_hex = match.group("hex")
        # Strip whitespace from old hex for finding
        old_hex_clean = "".join(old_hex.split())
        # Find the exact position of hex" and replace everything until the closing "
        hex_start = full_match.find('hex"')
        if hex_start == -1:
            return full_match  # Safety fallback
        # Find the closing quote after hex"
        quote_end = full_match.find('"', hex_start + 4)
        if quote_end == -1:
            return full_match
        before = full_match[:hex_start + 4]  # Up to and including 'hex"'
        after = full_match[quote_end:]  # From the closing " onwards
        return before + new_hex[2:] + after

    updated = ASSET_PATTERN.sub(replacer, content)
    ADD_PATH.write_text(updated)

    print(f"Updated {replaced} asset entries.")
    if missing:
        print("No replacement found for:")
        for name in sorted(missing):
            print(f"  - {name}")


if __name__ == "__main__":
    main()
