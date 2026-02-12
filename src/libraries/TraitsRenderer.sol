// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { E_Background_Type, E_TraitsGroup } from "../global/Enums.sol";
import { CachedTraitGroups, TraitGroup, TraitInfo, TraitsContext } from "../global/Structs.sol";
import { IAssets } from "../interfaces/IAssets.sol";
import { BitMap, LibBitmap } from "./LibBitmap.sol";
import { Utils } from "./Utils.sol";

library TraitsRenderer {
    function renderGridToSvg(IAssets assetsContract, bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal view {
        Utils.concat(buffer, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">');
        Utils.concat(buffer, "<style> img {image-rendering: pixelated; shape-rendering: crispEdges; image-rendering: -moz-crisp-edges;} </style>");

        Utils.concat(buffer, '<g id="Background">');
        _renderBackground(assetsContract, buffer, cachedTraitGroups, traits);
        Utils.concat(buffer, "</g>");

        BitMap memory bitMap;

        for (uint256 i = 0; i < traits.traitsToRenderLength; i++) {
            if (traits.traitsToRender[i].traitGroup == E_TraitsGroup.Background_Group) continue;

            _renderTraitGroup(bitMap, cachedTraitGroups, uint8(traits.traitsToRender[i].traitGroup), traits.traitsToRender[i].traitIndex);

            if (traits.traitsToRender[i].hasFiller) {
                _renderTraitGroup(bitMap, cachedTraitGroups, uint8(traits.traitsToRender[i].filler.traitGroup), traits.traitsToRender[i].filler.traitIndex);
            }
        }

        string memory urlEncodedPNG = LibBitmap.toURLEncodedPNG(bitMap);
        Utils.concat(buffer, '<g id="GeneratedImage">');
        Utils.concat(buffer, '<foreignObject width="48" height="48"><img xmlns="http://www.w3.org/1999/xhtml" src="');
        Utils.concat(buffer, bytes(urlEncodedPNG));
        Utils.concat(buffer, '" width="100%" height="100%"/></foreignObject></g></svg>');
    }

    function _renderBackground(IAssets assetsContract, bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) private view {
        uint256 bgGroupIndex = uint8(E_TraitsGroup.Background_Group);

        TraitGroup memory bgTraitGroup = cachedTraitGroups.traitGroups[bgGroupIndex];

        TraitInfo memory trait = bgTraitGroup.traits[uint8(traits.background)];

        E_Background_Type bg = E_Background_Type(trait.layerType);

        if (bg == E_Background_Type.Solid) {
            uint16 paletteIdx = _decodePaletteIndex(trait.traitData, 0, bgTraitGroup.paletteIndexByteSize);

            uint32 color = bgTraitGroup.paletteRgba[paletteIdx];
            Utils.concat(buffer, '<rect width="48" height="48" fill="');
            _writeHexColor(buffer, color);
            Utils.concat(buffer, '"/>');
            return;
        } else if (bg == E_Background_Type.Background_Image) {
            bytes memory pngBase64 = assetsContract.loadAsset(1000 + uint256(traits.background), false);
            Utils.concat(buffer, '<foreignObject width="48" height="48">');
            Utils.concat(buffer, '<img xmlns="http://www.w3.org/1999/xhtml" src="data:image/png;base64,');
            Utils.concatBase64(buffer, pngBase64);
            Utils.concat(buffer, '" width="100%" height="100%" /></foreignObject>');
            return;
        } else if (bg == E_Background_Type.Radial) {
            bytes memory gradientIdx = bytes(Utils.toString(uint256(traits.background)));
            Utils.concat(buffer, '<defs><radialGradient id="bg-');
            Utils.concat(buffer, gradientIdx);
            Utils.concat(buffer, '">');
            _renderSmoothGradientStops(buffer, cachedTraitGroups, bgGroupIndex, trait);
            Utils.concat(buffer, '</radialGradient></defs><rect width="48" height="48" fill="url(#bg-');
            Utils.concat(buffer, gradientIdx);
            Utils.concat(buffer, ')"/>');
            return;
        } else if (
            bg == E_Background_Type.S_Vertical || bg == E_Background_Type.P_Vertical || bg == E_Background_Type.S_Horizontal || bg == E_Background_Type.P_Horizontal
                || bg == E_Background_Type.S_Down || bg == E_Background_Type.P_Down || bg == E_Background_Type.S_Up || bg == E_Background_Type.P_Up
        ) {
            bytes memory gradientIdx = bytes(Utils.toString(uint256(traits.background)));
            Utils.concat(buffer, '<defs><linearGradient id="bg-');
            Utils.concat(buffer, gradientIdx);
            Utils.concat(buffer, '" x1="');
            Utils.concat(buffer, bytes(Utils.toString(trait.x1)));
            Utils.concat(buffer, '" y1="');
            Utils.concat(buffer, bytes(Utils.toString(trait.y1)));
            Utils.concat(buffer, '" x2="');
            Utils.concat(buffer, bytes(Utils.toString(trait.x2)));
            Utils.concat(buffer, '" y2="');
            Utils.concat(buffer, bytes(Utils.toString(trait.y2)));
            Utils.concat(buffer, '">');

            bool isPixelated =
                bg == E_Background_Type.P_Vertical || bg == E_Background_Type.P_Horizontal || bg == E_Background_Type.P_Down || bg == E_Background_Type.P_Up;

            if (isPixelated) _renderPixelGradientStops(buffer, cachedTraitGroups, bgGroupIndex, trait);
            else _renderSmoothGradientStops(buffer, cachedTraitGroups, bgGroupIndex, trait);

            Utils.concat(buffer, '</linearGradient></defs><rect width="48" height="48" fill="url(#bg-');
            Utils.concat(buffer, gradientIdx);
            Utils.concat(buffer, ')"/>');
        } else {
            revert("Unsupported background type");
        }
    }

    function _renderTraitGroup(BitMap memory bitMap, CachedTraitGroups memory cachedTraitGroups, uint8 traitGroupIndex, uint8 traitIndex) internal pure {
        TraitGroup memory group = cachedTraitGroups.traitGroups[traitGroupIndex];
        TraitInfo memory trait = group.traits[traitIndex];

        bytes memory data = trait.traitData;
        uint32[] memory palette = group.paletteRgba;

        uint256 x = trait.x1;
        uint256 y = trait.y1;
        uint256 maxX = trait.x2;
        uint256 width = maxX - x + 1;

        uint256 ptr;
        uint256 dataLen = data.length;

        unchecked {
            while (ptr < dataLen) {
                uint8 run;
                uint16 colorIdx;

                assembly {
                    let dataPtr := add(data, 0x20)
                    run := byte(0, mload(add(dataPtr, ptr)))
                }
                ptr++;

                // Read color index
                if (group.paletteIndexByteSize == 1) {
                    assembly {
                        let dataPtr := add(data, 0x20)
                        colorIdx := byte(0, mload(add(dataPtr, ptr)))
                    }
                    ptr++;
                } else {
                    assembly {
                        let dataPtr := add(data, 0x20)
                        let b1 := byte(0, mload(add(dataPtr, ptr)))
                        let b2 := byte(0, mload(add(dataPtr, add(ptr, 1))))
                        colorIdx := or(shl(8, b1), b2)
                    }
                    ptr += 2;
                }

                uint32 rgba = palette[colorIdx];
                uint8 alpha = uint8(rgba);

                // Skip if fully transparent
                if (alpha == 0) {
                    x += run;
                    while (x > maxX) {
                        x -= width;
                        y++;
                    }
                    continue;
                }

                if (alpha == 255) {
                    if (run > 1 && x + run - 1 <= maxX) {
                        // ✅ CORRECT
                        // batch write in same row
                        assembly {
                            let bmpBase := bitMap
                            for { let i := 0 } lt(i, run) { i := add(i, 1) } {
                                let pixelSlot := add(bmpBase, add(mul(add(x, i), mul(48, 32)), mul(y, 32)))
                                mstore(pixelSlot, rgba)
                            }
                        }
                        x += run;
                        continue;
                    }
                }

                // Optimized pixel rendering
                for (uint8 i = 0; i < run; i++) {
                    _renderPixelInline(bitMap, x, y, rgba, alpha);

                    x++;
                    if (x > maxX) {
                        x = trait.x1;
                        y++;
                    }
                }
            }
        }
    }

    function _renderPixelInline(BitMap memory bitMap, uint256 x, uint256 y, uint32 src, uint8 srcA) private pure {
        if (srcA == 0) return;

        uint32 dst = bitMap.pixels[x][y];

        // Fast paths
        if (dst == 0 || srcA == 255) {
            bitMap.pixels[x][y] = src;
            return;
        }

        // Full alpha blending (already optimized in your code)
        uint32 blended;
        assembly {
            let srcR := and(shr(24, src), 0xFF)
            let srcG := and(shr(16, src), 0xFF)
            let srcB := and(shr(8, src), 0xFF)

            let dstA := and(dst, 0xFF)
            let dstR := and(shr(24, dst), 0xFF)
            let dstG := and(shr(16, dst), 0xFF)
            let dstB := and(shr(8, dst), 0xFF)

            let invA := sub(255, srcA)
            let outA := add(srcA, div(add(mul(dstA, invA), 127), 255))
            if iszero(outA) { outA := 1 }

            let outR := div(add(mul(srcR, srcA), div(mul(mul(dstR, dstA), invA), 255)), outA)
            let outG := div(add(mul(srcG, srcA), div(mul(mul(dstG, dstA), invA), 255)), outA)
            let outB := div(add(mul(srcB, srcA), div(mul(mul(dstB, dstA), invA), 255)), outA)

            blended := or(or(or(shl(24, outR), shl(16, outG)), shl(8, outB)), outA)
        }

        bitMap.pixels[x][y] = blended;
    }

    function _renderPixelGradientStops(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, uint256 traitGroupIndex, TraitInfo memory trait)
        private
        pure
    {
        TraitGroup memory traitGroup = cachedTraitGroups.traitGroups[traitGroupIndex];
        require(trait.traitData.length > 0, "TraitData is empty, couldn't fetch gradient stops");

        uint256 numStops = trait.traitData.length / traitGroup.paletteIndexByteSize;

        int256 scale = 1_000_000;

        for (uint256 i = 0; i < numStops; i++) {
            uint16 idx = _decodePaletteIndex(trait.traitData, i * traitGroup.paletteIndexByteSize, traitGroup.paletteIndexByteSize);

            uint32 color = traitGroup.paletteRgba[idx];

            bytes memory startOffset = bytes(Utils.divisionString(4, (int256(i) * 100 * scale) / int256(numStops), scale));
            bytes memory endOffset = bytes(Utils.divisionString(4, (int256(i + 1) * 100 * scale) / int256(numStops), scale));

            Utils.concat(buffer, '<stop offset="');
            Utils.concat(buffer, startOffset);
            Utils.concat(buffer, '%" ');
            _writeColorStop(buffer, color);
            Utils.concat(buffer, '/><stop offset="');
            Utils.concat(buffer, endOffset);
            Utils.concat(buffer, '%" ');
            _writeColorStop(buffer, color);
            Utils.concat(buffer, "/>");
        }
    }

    function _renderSmoothGradientStops(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, uint256 traitGroupIndex, TraitInfo memory trait)
        private
        pure
    {
        TraitGroup memory traitGroup = cachedTraitGroups.traitGroups[traitGroupIndex];
        require(trait.traitData.length > 0, "TraitData is empty, couldn't fetch gradient stops");

        uint256 numStops = trait.traitData.length / traitGroup.paletteIndexByteSize;

        int256 scale = 1_000_000;

        for (uint256 i = 0; i < numStops; i++) {
            uint16 idx = _decodePaletteIndex(trait.traitData, i * traitGroup.paletteIndexByteSize, traitGroup.paletteIndexByteSize);

            uint32 color = traitGroup.paletteRgba[idx];

            bytes memory offset = bytes(Utils.divisionString(4, (int256(i) * 100 * scale) / int256(numStops - 1), scale));

            Utils.concat(buffer, '<stop offset="');
            Utils.concat(buffer, offset);
            Utils.concat(buffer, '%" ');
            _writeColorStop(buffer, color);
            Utils.concat(buffer, "/>");
        }
    }

    function _decodePaletteIndex(bytes memory data, uint256 offset, uint8 byteSize) internal pure returns (uint16) {
        if (byteSize == 1) return uint16(uint8(data[offset]));
        // Big-endian (high byte first)
        return (uint16(uint8(data[offset])) << 8) | uint16(uint8(data[offset + 1]));
    }

    function _writeColorStop(bytes memory buffer, uint32 packedRgba) internal pure {
        Utils.concat(buffer, 'stop-color="');
        _writeHexColor(buffer, packedRgba);
        Utils.concat(buffer, '"');
    }

    function _writeHexColor(bytes memory buffer, uint32 rgba) private pure {
        bytes16 hexChars = "0123456789abcdef";

        uint256 r = (rgba >> 24) & 0xFF;
        uint256 g = (rgba >> 16) & 0xFF;
        uint256 b = (rgba >> 8) & 0xFF;

        Utils.concat(buffer, "#");
        Utils.concat(buffer, abi.encodePacked(hexChars[r >> 4], hexChars[r & 0xf], hexChars[g >> 4], hexChars[g & 0xf], hexChars[b >> 4], hexChars[b & 0xf]));
    }
}
