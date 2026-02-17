// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { E_Background_Type, E_TraitsGroup } from "../global/Enums.sol";
import { CachedTraitGroups, TraitGroup, TraitInfo, TraitsContext } from "../global/Structs.sol";
import { IAssets } from "../interfaces/IAssets.sol";
import { Utils } from "./Utils.sol";

/**
 * @title PathSVGRenderer
 * @author ECHO (echomatrix.eth)
 * @notice Renders 2D RLE trait data directly to SVG using rect elements.
 * @dev Huge gas savings over bitmap + PNG approach:
 *      - No intermediate bitmap allocation
 *      - No PNG encoding (CRC32/Adler32)
 *      - No LZ77 decompression
 *      - Direct SVG rect emission from 2D RLE runs
 */
library PathSVGRenderer {
    using Utils for *;

    /**
     * @notice Render all traits to SVG using 2D RLE data
     */
    function renderToSvg(IAssets assetsContract, bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal view {
        buffer.concat('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" shape-rendering="crispEdges">');

        // Render background first
        buffer.concat('<g id="Background">');
        _renderBackground(assetsContract, buffer, cachedTraitGroups, traits);
        buffer.concat("</g>");

        // Render all other trait layers
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

    /**
     * @notice Render a single trait layer from 2D RLE data
     * @dev 2D RLE Format per trait:
     *      [numRows:1]
     *      For each row: [rowY:1][numRuns:1]
     *        For each run: [x:1][length:1][paletteIndex:1-2]
     */
    function _renderTraitLayer(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, uint8 traitGroupIndex, uint8 traitIndex) internal pure {
        TraitGroup memory group = cachedTraitGroups.traitGroups[traitGroupIndex];
        TraitInfo memory trait = group.traits[traitIndex];

        bytes memory data = trait.traitData;
        if (data.length == 0) {
            return;
        }

        uint256 ptr = 0;
        uint8 pSize = group.paletteIndexByteSize;

        // Read number of rows
        uint8 numRows = uint8(data[ptr++]);

        // Process each row
        for (uint256 r = 0; r < numRows;) {
            uint8 rowY = uint8(data[ptr++]);
            uint8 numRuns = uint8(data[ptr++]);

            // Process each run in this row
            for (uint256 run = 0; run < numRuns;) {
                uint8 x = uint8(data[ptr++]);
                uint8 length = uint8(data[ptr++]);

                // Decode palette index
                uint16 colorIdx;
                if (pSize == 1) {
                    colorIdx = uint16(uint8(data[ptr++]));
                } else {
                    colorIdx = (uint16(uint8(data[ptr])) << 8) | uint16(uint8(data[ptr + 1]));
                    ptr += 2;
                }

                uint32 rgba = group.paletteRgba[colorIdx];
                uint8 alpha = uint8(rgba); // LSB

                // Skip fully transparent pixels
                if (alpha > 0) {
                    _emitRect(buffer, x, rowY, length, rgba);
                }

                unchecked {
                    ++run;
                }
            }

            unchecked {
                ++r;
            }
        }
    }

    /**
     * @notice Emit an SVG rect element for a horizontal run
     */
    function _emitRect(bytes memory buffer, uint8 x, uint8 y, uint8 width, uint32 rgba) private pure {
        // <rect x="10" y="5" width="3" height="1" fill="#RRGGBBAA"/>
        buffer.concat('<rect x="', bytes(Utils.toString(uint256(x))));
        buffer.concat('" y="', bytes(Utils.toString(uint256(y))));
        buffer.concat('" width="', bytes(Utils.toString(uint256(width))));
        buffer.concat('" height="1" fill="');
        _emitRgbaColor(buffer, rgba);
        buffer.concat('"/>');
    }

    /**
     * @notice Convert RGBA32 (0xRRGGBBAA) to #RRGGBBAA hex string
     */
    function _emitRgbaColor(bytes memory buffer, uint32 rgba) private pure {
        buffer.concat("#");

        uint8 r = uint8(rgba >> 24);
        uint8 g = uint8(rgba >> 16);
        uint8 b = uint8(rgba >> 8);
        uint8 a = uint8(rgba);

        _emitHexByte(buffer, r);
        _emitHexByte(buffer, g);
        _emitHexByte(buffer, b);

        // Only emit alpha if not fully opaque
        if (a != 0xFF) {
            _emitHexByte(buffer, a);
        }
    }

    /**
     * @notice Convert a byte to 2-character hex string
     */
    function _emitHexByte(bytes memory buffer, uint8 value) private pure {
        bytes memory hexChars = "0123456789ABCDEF";
        bytes memory result = new bytes(2);
        result[0] = hexChars[value >> 4];
        result[1] = hexChars[value & 0xF];
        buffer.concat(result);
    }

    // ──────────────────────────── Background Rendering ───────────────────────

    /**
     * @notice Render background (solid colors, gradients, or special patterns)
     */
    function _renderBackground(IAssets assetsContract, bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) private view {
        uint256 bgGroupIndex = uint8(E_TraitsGroup.Background_Group);
        TraitGroup memory bgTraitGroup = cachedTraitGroups.traitGroups[bgGroupIndex];
        TraitInfo memory trait = bgTraitGroup.traits[uint8(traits.background)];
        E_Background_Type bg = E_Background_Type(trait.layerType);

        if (bg == E_Background_Type.Solid) {
            // Solid color: read palette index and emit full rect
            uint16 paletteIdx = _decodePaletteIndex(trait.traitData, 0, bgTraitGroup.paletteIndexByteSize);
            uint32 color = bgTraitGroup.paletteRgba[paletteIdx];

            buffer.concat('<rect width="48" height="48" fill="');
            _emitRgbaColor(buffer, color);
            buffer.concat('"/>');
        } else if (bg == E_Background_Type.Background_Image) {
            // Image background: render as 2D RLE layer
            _renderTraitLayer(buffer, cachedTraitGroups, uint8(E_TraitsGroup.Background_Group), uint8(traits.background));
        } else if (bg == E_Background_Type.Radial) {
            // Radial gradient
            _renderRadialGradient(buffer, trait, bgTraitGroup);
        } else if (bg == E_Background_Type.S_Vertical || bg == E_Background_Type.P_Vertical || bg == E_Background_Type.S_Horizontal || bg == E_Background_Type.P_Horizontal || bg == E_Background_Type.S_Down || bg == E_Background_Type.P_Down || bg == E_Background_Type.S_Up || bg == E_Background_Type.P_Up) {
            // Linear gradients
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
        _emitRgbaColor(buffer, color1);
        buffer.concat('"/><stop offset="100%" stop-color="');
        _emitRgbaColor(buffer, color2);
        buffer.concat('"/></radialGradient></defs><rect width="48" height="48" fill="url(#rg)"/>');
    }

    function _renderLinearGradient(bytes memory buffer, TraitInfo memory trait, TraitGroup memory bgTraitGroup, E_Background_Type bg) private pure {
        bytes memory data = trait.traitData;
        uint8 pSize = bgTraitGroup.paletteIndexByteSize;

        uint16 idx1 = _decodePaletteIndex(data, 0, pSize);
        uint16 idx2 = _decodePaletteIndex(data, pSize, pSize);

        uint32 color1 = bgTraitGroup.paletteRgba[idx1];
        uint32 color2 = bgTraitGroup.paletteRgba[idx2];

        // Determine gradient direction
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
        _emitRgbaColor(buffer, color1);
        buffer.concat('"/><stop offset="100%" stop-color="');
        _emitRgbaColor(buffer, color2);
        buffer.concat('"/></linearGradient></defs><rect width="48" height="48" fill="url(#lg)"/>');
    }
}
