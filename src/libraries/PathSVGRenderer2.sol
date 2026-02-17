// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { E_Background_Type, E_TraitsGroup } from "../global/Enums.sol";
import { CachedTraitGroups, TraitGroup, TraitInfo, TraitsContext } from "../global/Structs.sol";
import { IAssets } from "../interfaces/IAssets.sol";
import { Utils } from "./Utils.sol";

library PathSVGRenderer {
    using Utils for *;

    // NEW: Sentinel value for full-resolution 48x48 exception layers (~5 total).
    // Background group layerType uses small enum values (0-9), so 0xFF never collides.
    uint8 private constant LAYER_FULLRES = 0xFF; // NEW

    // ══════════════════════════════════════════════════════════════════════════
    //                            ENTRY POINT
    // ══════════════════════════════════════════════════════════════════════════

    function renderToSvg(IAssets assetsContract, bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal view {
        buffer.concat('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" shape-rendering="crispEdges">');

        buffer.concat('<g id="Background">');
        _renderBackground(assetsContract, buffer, cachedTraitGroups, traits);
        buffer.concat("</g>");

        buffer.concat('<g id="Traits">');
        uint256 len = traits.traitsToRenderLength;
        for (uint256 i = 0; i < len;) {
            if (traits.traitsToRender[i].traitGroup == E_TraitsGroup.Background_Group) {
                unchecked {
                    ++i;
                }
                continue;
            }

            _renderTraitLayer(buffer, cachedTraitGroups, uint8(traits.traitsToRender[i].traitGroup), traits.traitsToRender[i].traitIndex);

            if (traits.traitsToRender[i].hasFiller) {
                _renderTraitLayer(buffer, cachedTraitGroups, uint8(traits.traitsToRender[i].filler.traitGroup), traits.traitsToRender[i].filler.traitIndex);
            }

            unchecked {
                ++i;
            }
        }
        buffer.concat("</g></svg>");
    }

    // ══════════════════════════════════════════════════════════════════════════
    //                         TRAIT LAYER RENDERING
    // ══════════════════════════════════════════════════════════════════════════

    function _renderTraitLayer(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, uint8 traitGroupIndex, uint8 traitIndex) internal pure {
        TraitGroup memory group = cachedTraitGroups.traitGroups[traitGroupIndex];
        TraitInfo memory trait = group.traits[traitIndex];
        bytes memory data = trait.traitData;

        if (data.length == 0) {
            return;
        }

        uint8 pSize = group.paletteIndexByteSize;
        uint256 colorCount = group.paletteRgba.length;

        // NEW: Determine coordinate scale based on layerType.
        // unit = 2 → 24x24 logical data, all coords doubled to fill 48x48 canvas.
        // unit = 1 → full-res 48x48 exception layer, coords used as-is.
        uint256 unit = (trait.layerType == LAYER_FULLRES) ? 1 : 2; // NEW

        // NEW: Precompute unit as a string once to avoid repeated toString calls in the inner loop.
        bytes memory unitStr = (unit == 2) ? bytes("2") : bytes("1"); // NEW

        // NEW: One path-command accumulator per palette color.
        // All runs of the same color are batched into one <path> element,
        // reducing SVG element count from (number of runs) down to (number of colors).
        bytes[] memory pathBufs = new bytes[](colorCount); // NEW

        // NEW: Single pass — read RLE runs and bucket path commands by color index.
        uint256 ptr = 0;
        uint8 numRows = uint8(data[ptr++]);

        unchecked {
            for (uint256 r = 0; r < numRows; ++r) {
                uint256 rowY = uint256(uint8(data[ptr++])) * unit; // NEW: multiply by unit
                uint8 numRuns = uint8(data[ptr++]);

                for (uint256 run = 0; run < numRuns; ++run) {
                    uint256 x = uint256(uint8(data[ptr++])) * unit; // NEW: multiply by unit
                    uint256 w = uint256(uint8(data[ptr++])) * unit; // NEW: multiply by unit

                    uint16 colorIdx;
                    if (pSize == 1) {
                        colorIdx = uint16(uint8(data[ptr++]));
                    } else {
                        colorIdx = (uint16(uint8(data[ptr])) << 8) | uint16(uint8(data[ptr + 1]));
                        ptr += 2;
                    }

                    // NEW: No alpha check here — transparent runs are never stored by the encoder.
                    // NEW: Append path rectangle command to this color's buffer.
                    // M x y  → move to top-left corner
                    // h w    → draw right
                    // v unit → draw down
                    // h-w    → draw left
                    // z      → close back to top-left
                    pathBufs[colorIdx] = abi.encodePacked( // NEW
                        pathBufs[colorIdx],
                        "M",
                        Utils.toString(x),
                        " ",
                        Utils.toString(rowY),
                        "h",
                        Utils.toString(w),
                        "v",
                        unitStr,
                        "h-",
                        Utils.toString(w),
                        "z"
                    );
                }
            }
        }

        // NEW: Second pass — emit one <path fill="#RRGGBB" d="..."/> per color used.
        unchecked {
            for (uint256 c = 0; c < colorCount; ++c) {
                if (pathBufs[c].length == 0) {
                    continue;
                }
                buffer.concat('<path fill="');
                _emitRgbColor(buffer, group.paletteRgba[c]); // NEW: was _emitRgbaColor
                buffer.concat('" d="');
                buffer.concat(pathBufs[c]);
                buffer.concat('"/>');
            }
        }
    }

    // ══════════════════════════════════════════════════════════════════════════
    //                         COLOR EMISSION
    // ══════════════════════════════════════════════════════════════════════════

    /**
     * NEW: Replaces _emitRgbaColor + _emitHexByte from the previous version.
     * Emits exactly 7 bytes: #RRGGBB. Since alpha is always 0xFF it is never written.
     * Single allocation of 7 bytes instead of per-nibble allocations.
     */
    function _emitRgbColor(bytes memory buffer, uint32 rgba) private pure {
        // NEW
        bytes memory result = new bytes(7);
        result[0] = "#";
        uint8 r = uint8(rgba >> 24);
        uint8 g = uint8(rgba >> 16);
        uint8 b = uint8(rgba >> 8);
        result[1] = _hexChar(r >> 4);
        result[2] = _hexChar(r & 0xF);
        result[3] = _hexChar(g >> 4);
        result[4] = _hexChar(g & 0xF);
        result[5] = _hexChar(b >> 4);
        result[6] = _hexChar(b & 0xF);
        buffer.concat(result);
    }

    /**
     * NEW: Replaces _emitHexByte. Converts a 4-bit nibble to uppercase hex.
     * Arithmetic only — no lookup table allocation.
     */
    function _hexChar(uint8 nibble) private pure returns (bytes1) {
        // NEW
        return nibble < 10 ? bytes1(nibble + 48) : bytes1(nibble + 55);
    }

    // ══════════════════════════════════════════════════════════════════════════
    //                       BACKGROUND RENDERING
    // ══════════════════════════════════════════════════════════════════════════

    function _renderBackground(IAssets assetsContract, bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) private view {
        uint256 bgGroupIndex = uint8(E_TraitsGroup.Background_Group);
        TraitGroup memory bgTraitGroup = cachedTraitGroups.traitGroups[bgGroupIndex];
        TraitInfo memory trait = bgTraitGroup.traits[uint8(traits.background)];
        E_Background_Type bg = E_Background_Type(trait.layerType);

        if (bg == E_Background_Type.Solid) {
            uint16 paletteIdx = _decodePaletteIndex(trait.traitData, 0, bgTraitGroup.paletteIndexByteSize);
            uint32 color = bgTraitGroup.paletteRgba[paletteIdx];
            buffer.concat('<rect width="48" height="48" fill="');
            _emitRgbColor(buffer, color); // NEW: was _emitRgbaColor
            buffer.concat('"/>');
        } else if (bg == E_Background_Type.Background_Image) {
            // Background images are also encoded at 24x24 logical resolution.
            // Their layerType is the background enum value (not 0xFF),
            // so unit=2 applies correctly inside _renderTraitLayer.
            _renderTraitLayer(buffer, cachedTraitGroups, uint8(E_TraitsGroup.Background_Group), uint8(traits.background));
        } else if (bg == E_Background_Type.Radial) {
            _renderRadialGradient(buffer, trait, bgTraitGroup);
        } else if (bg == E_Background_Type.S_Vertical || bg == E_Background_Type.P_Vertical || bg == E_Background_Type.S_Horizontal || bg == E_Background_Type.P_Horizontal || bg == E_Background_Type.S_Down || bg == E_Background_Type.P_Down || bg == E_Background_Type.S_Up || bg == E_Background_Type.P_Up) {
            _renderLinearGradient(buffer, trait, bgTraitGroup, bg);
        }
    }

    function _decodePaletteIndex(bytes memory data, uint256 offset, uint8 pSize) private pure returns (uint16) {
        if (pSize == 1) {
            return uint16(uint8(data[offset]));
        } else {
            return (uint16(uint8(data[offset])) << 8) | uint16(uint8(data[offset + 1]));
        }
    }

    function _renderRadialGradient(bytes memory buffer, TraitInfo memory trait, TraitGroup memory bgTraitGroup) private pure {
        bytes memory data = trait.traitData;
        uint8 pSize = bgTraitGroup.paletteIndexByteSize;

        uint16 idx1 = _decodePaletteIndex(data, 0, pSize);
        uint16 idx2 = _decodePaletteIndex(data, pSize, pSize);

        uint32 color1 = bgTraitGroup.paletteRgba[idx1];
        uint32 color2 = bgTraitGroup.paletteRgba[idx2];

        buffer.concat('<defs><radialGradient id="rg"><stop offset="0%" stop-color="');
        _emitRgbColor(buffer, color1); // NEW: was _emitRgbaColor
        buffer.concat('"/><stop offset="100%" stop-color="');
        _emitRgbColor(buffer, color2); // NEW: was _emitRgbaColor
        buffer.concat('"/></radialGradient></defs><rect width="48" height="48" fill="url(#rg)"/>');
    }

    function _renderLinearGradient(bytes memory buffer, TraitInfo memory trait, TraitGroup memory bgTraitGroup, E_Background_Type bg) private pure {
        bytes memory data = trait.traitData;
        uint8 pSize = bgTraitGroup.paletteIndexByteSize;

        uint16 idx1 = _decodePaletteIndex(data, 0, pSize);
        uint16 idx2 = _decodePaletteIndex(data, pSize, pSize);

        uint32 color1 = bgTraitGroup.paletteRgba[idx1];
        uint32 color2 = bgTraitGroup.paletteRgba[idx2];

        bytes memory x1 = "0%";
        bytes memory y1 = "0%";
        bytes memory x2 = "0%";
        bytes memory y2 = "100%";

        if (bg == E_Background_Type.S_Horizontal || bg == E_Background_Type.P_Horizontal) {
            x2 = "100%";
            y2 = "0%";
        } else if (bg == E_Background_Type.S_Down || bg == E_Background_Type.P_Down) {
            x2 = "100%";
            y2 = "100%";
        } else if (bg == E_Background_Type.S_Up || bg == E_Background_Type.P_Up) {
            x1 = "0%";
            y1 = "100%";
            x2 = "100%";
            y2 = "0%";
        }

        buffer.concat('<defs><linearGradient id="lg" x1="');
        buffer.concat(x1);
        buffer.concat('" y1="');
        buffer.concat(y1);
        buffer.concat('" x2="');
        buffer.concat(x2);
        buffer.concat('" y2="');
        buffer.concat(y2);
        buffer.concat('"><stop offset="0%" stop-color="');
        _emitRgbColor(buffer, color1); // NEW: was _emitRgbaColor
        buffer.concat('"/><stop offset="100%" stop-color="');
        _emitRgbColor(buffer, color2); // NEW: was _emitRgbaColor
        buffer.concat('"/></linearGradient></defs><rect width="48" height="48" fill="url(#lg)"/>');
    }
}
