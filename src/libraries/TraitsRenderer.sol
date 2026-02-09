// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { E_Background_Type, E_TraitsGroup } from "../common/Enums.sol";
import { CachedTraitGroups, TraitGroup, TraitInfo, TraitsContext } from "../common/Structs.sol";
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

            bool isPixelated = bg == E_Background_Type.P_Vertical || bg == E_Background_Type.P_Horizontal || bg == E_Background_Type.P_Down || bg == E_Background_Type.P_Up;

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

        uint256 traitDataLength = trait.traitData.length;

        bytes memory data = trait.traitData;
        uint256 ptr = 0;
        uint256 totalData = data.length;

        uint256 currX = trait.x1;
        uint256 currY = trait.y1;

        while (ptr < totalData) {
            uint8 run = uint8(data[ptr++]);
            uint16 colorIdx;

            if (group.paletteIndexByteSize == 1) colorIdx = uint16(uint8(data[ptr++]));
            else colorIdx = (uint16(uint8(data[ptr++])) << 8) | uint16(uint8(data[ptr++]));

            uint32 rgba = group.paletteRgba[colorIdx];

            for (uint8 i = 0; i < run; i++) {
                uint8 alpha = uint8(rgba); // or rgba & 0xFF
                if (alpha > 0) LibBitmap.renderPixelToBitMap(bitMap, uint8(currX), uint8(currY), rgba);

                currX++;
                if (currX > trait.x2) {
                    currX = trait.x1;
                    currY++;
                }
            }
        }
    }

    function _renderPixelGradientStops(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, uint256 traitGroupIndex, TraitInfo memory trait) private pure {
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

    function _renderSmoothGradientStops(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, uint256 traitGroupIndex, TraitInfo memory trait) private pure {
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
