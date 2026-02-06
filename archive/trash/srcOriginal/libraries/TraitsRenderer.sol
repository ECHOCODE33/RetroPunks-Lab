// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { TraitInfo, TraitGroup, CachedTraitGroups, TraitsContext } from '../common/Structs.sol';
import { E_TraitsGroup, E_BgType } from '../common/Enums.sol';
import { IAssets } from '../interfaces/IAssets.sol';
import { Utils } from './Utils.sol';
import { BitMap, PNG48x48 } from './PNG48x48.sol';
import { Division } from './Division.sol';
import { LibString } from './LibString.sol';


library TraitsRenderer {
    
    function renderGridToSvg(bytes memory buffer, IAssets assetsContract, CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal view {
        Utils.concat(buffer, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">');  
        Utils.concat(buffer, '<style> img {image-rendering: pixelated;} </style>');
        Utils.concat(buffer, '<g id="Background">');
        _renderBackground(buffer, assetsContract, cachedTraitGroups, traits);
        Utils.concat(buffer, '</g>');
        
        BitMap memory bitMap;

        for (uint i = 0; i < traits.traitsToRenderLength; i++) {
            if (traits.traitsToRender[i].traitGroup == E_TraitsGroup.Background_Group) {
                continue;
            }

            _renderTraitGroup(bitMap, cachedTraitGroups, uint8(traits.traitsToRender[i].traitGroup), traits.traitsToRender[i].traitIndex);

            if (traits.traitsToRender[i].hasFiller) {
                _renderTraitGroup(bitMap, cachedTraitGroups, uint8(traits.traitsToRender[i].filler.traitGroup), traits.traitsToRender[i].filler.traitIndex);
            }
        }

        string memory urlEncodedPNG = PNG48x48.toURLEncodedPNG(bitMap);
        Utils.concat(buffer, '<g id="GeneratedImage">');
        Utils.concat(buffer, '<foreignObject width="48" height="48"><img xmlns="http://www.w3.org/1999/xhtml" src="', bytes(urlEncodedPNG));
        Utils.concat(buffer, '" width="100%" height="100%" /></foreignObject></g></svg>');
    }

    function _renderBackground(bytes memory buffer, IAssets assetsContract, CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) private view {
        bytes memory BGDATA = hex"fffe0888181909191b0a1a0b1b02120a13131404150c1605";

        uint bgGroupIndex = uint8(E_TraitsGroup.Background_Group);
        
        TraitGroup memory bgtraitGroup = cachedTraitGroups.traitGroups[bgGroupIndex];
        TraitInfo memory trait = bgtraitGroup.traits[uint8(traits.background)];

        E_BgType bg = E_BgType(trait.bgTypeIndex);

        bytes memory gradientIdx = bytes(Utils.toString(uint(traits.background)));

        if (bg == E_BgType.Background_Image) {
            bytes memory base64 = assetsContract.loadAssetOriginal(uint(trait.bgAssetKey) + 1000);

            Utils.concat(buffer, '<foreignObject width="24" height="24">');
            Utils.concat(buffer, '<img xmlns="http://www.w3.org/1999/xhtml" src="data:image/png;base64,');
            Utils.concatBase64(buffer, base64);
            Utils.concat(buffer, ' width="100%" height="100%" /></foreignObject>');
        }

        else if (bg == E_BgType.Radial) {
            // Radial gradient background
            Utils.concat(buffer, '<defs><radialGradient id="background-', gradientIdx, '">');

            uint numStops = trait.traitData.length / bgtraitGroup.indexByteSize;
            for (uint i = 0; i < numStops; i++) {
                uint dataOffset = i * bgtraitGroup.indexByteSize;
                uint16 idx = _decodePaletteIndex(trait.traitData, dataOffset, bgtraitGroup.indexByteSize);
                
                // --- CHANGE 1: Get hex string from paletteRgba ---
                bytes memory color = _colorRgbaToRgbHex(bgtraitGroup.paletteRgba[idx]);
                
                bytes memory offsetPercent = bytes(Utils.toString((i * 100) / (numStops - 1)));
                Utils.concat(buffer, '<stop offset="', offsetPercent, '%" stop-color="', color, '" />');
            }

            Utils.concat(buffer, '</radialGradient></defs><rect x="0" y="0" width="48" height="48" fill="url(#background-', gradientIdx, ')" />');
        }

        else {
            // ---------- Linear gradient / Solid (lookup-table) ----------
            uint idx = uint(uint8(bg));
            uint8 packed = 0x08; 
            if (idx < BGDATA.length) {
                packed = uint8(BGDATA[idx]);
            }
            if (packed == 0xff || packed == 0xfe) {
                packed = 0x08;
            }

            uint8 x1 = (packed >> 0) & 1;
            uint8 y1 = (packed >> 1) & 1;
            uint8 x2 = (packed >> 2) & 1;
            uint8 y2 = (packed >> 3) & 1;
            bool pixel = (((packed >> 4) & 1) == 1);

            bytes memory b0 = "0";
            bytes memory b1 = "1";

            bytes memory xs1 = x1 == 0 ? b0 : b1;
            bytes memory ys1 = y1 == 0 ? b0 : b1;
            bytes memory xs2 = x2 == 0 ? b0 : b1;
            bytes memory ys2 = y2 == 0 ? b0 : b1;

            Utils.concat(
                buffer,
                '<defs><linearGradient id="background-', gradientIdx,
                '" x1="', xs1,
                '" y1="', ys1,
                '" x2="', xs2,
                '" y2="', ys2,
                '">'
            );

            if (pixel) {
                _renderPixelColorGradientStops(buffer, cachedTraitGroups, bgGroupIndex, trait);
            } else {
                _renderColorGradientStops(buffer, cachedTraitGroups, bgGroupIndex, trait);
            }

            Utils.concat(buffer, '</linearGradient></defs><rect x="0" y="0" width="48" height="48" fill="url(#background-', gradientIdx, ')" />');
        }
    }

    function _renderTraitGroup(BitMap memory bitMap, CachedTraitGroups memory cachedTraitGroups, uint8 traitGroupIndex, uint8 traitIndex) internal pure {
        TraitGroup memory group = cachedTraitGroups.traitGroups[traitGroupIndex];
        TraitInfo memory trait = group.traits[traitIndex];
        
        bytes memory data = trait.traitData;
        uint256 ptr = 0;
        uint256 totalData = data.length;
        
        // Tracking current position within the bounding box
        uint8 currX = trait.x1;
        uint8 currY = trait.y1;

        while (ptr < totalData) {
            uint8 run = uint8(data[ptr++]);
            uint16 colorIdx;
            
            if (group.indexByteSize == 1) {
                colorIdx = uint8(data[ptr++]);
            } else {
                colorIdx = uint16(uint8(data[ptr])) | (uint16(uint8(data[ptr + 1])) << 8);
                ptr += 2;
            }

            uint32 rgba = group.paletteRgba[colorIdx];

            // Apply the color to the next 'run' of pixels
            for (uint8 i = 0; i < run; i++) {
                // Alpha check: Only paint if A > 0
                if (rgba & 0xFF > 0) {
                    PNG48x48.renderPixelToBitMap(bitMap, currX, currY, rgba);
                }
                
                // Advance coordinates (Row-Major: move X, then move to next Y row)
                currX++;
                if (currX > trait.x2) {
                    currX = trait.x1;
                    currY++;
                }
            }
        }
    }

    function _renderPixelColorGradientStops(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, uint traitGroupIndex, TraitInfo memory trait) private pure {
        
        TraitGroup memory traitGroup = cachedTraitGroups.traitGroups[traitGroupIndex];
        uint numStops = trait.traitData.length / traitGroup.indexByteSize;

        int scale = 1000000;
        int totalRange = 100 * scale;

        for (uint i = 0; i < numStops; i++) {
            uint dataOffset = i * traitGroup.indexByteSize;
            uint16 idx = _decodePaletteIndex(trait.traitData, dataOffset, traitGroup.indexByteSize);
            
            // --- CHANGE 2: Get hex string from paletteRgba ---
            bytes memory color = _colorRgbaToRgbHex(traitGroup.paletteRgba[idx]);
            
            int startPos = (int256(i) * totalRange) / int256(numStops);
            int endPos   = (int256(i + 1) * totalRange) / int256(numStops);

            bytes memory startOffset = bytes(Division.divisionStr(4, startPos, int(scale)));
            bytes memory endOffset = bytes(Division.divisionStr(4, endPos, int(scale)));
            
            Utils.concat(buffer, '<stop offset="', startOffset, '%" stop-color="', color, '" />');
            Utils.concat(buffer, '<stop offset="', endOffset, '%" stop-color="', color, '" />');
        }
    }

    function _renderColorGradientStops(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, uint traitGroupIndex, TraitInfo memory trait) private pure {
        
        TraitGroup memory traitGroup = cachedTraitGroups.traitGroups[traitGroupIndex];
        uint numStops = trait.traitData.length / traitGroup.indexByteSize;

        int scale = 1000000;
        int totalRange = 100 * scale;

        for (uint i = 0; i < numStops; i++) {
            uint dataOffset = i * traitGroup.indexByteSize;
            uint16 idx = _decodePaletteIndex(trait.traitData, dataOffset, traitGroup.indexByteSize);
            
            // --- CHANGE 3: Get hex string from paletteRgba ---
            bytes memory color = _colorRgbaToRgbHex(traitGroup.paletteRgba[idx]);
            
            int startPos = (int256(i) * totalRange) / int256(numStops);

            bytes memory startOffset = bytes(Division.divisionStr(4, startPos, int(scale)));
            
            Utils.concat(buffer, '<stop offset="', startOffset, '%" stop-color="', color, '" />');
        }
    }

    function _decodePaletteIndex(bytes memory data, uint offset, uint8 byteSize) internal pure returns (uint16) {
        if (byteSize == 1) {
            return uint16(uint8(data[offset]));
        } else {
            return uint16(uint8(data[offset])) | (uint16(uint8(data[offset + 1])) << 8);
        }
    }

    // --- NEW HELPER FUNCTION ---
    /// @notice Converts a packed uint32 ARGB color (0xAARRGGBB) to an SVG-compatible RGB hex string (e.g., #FF00FF).
    /// @param packedRgba The color packed as 0xAARRGGBB.
    /// @return A bytes object containing the RGB hex string, e.g., "#FF00FF".
    function _colorRgbaToRgbHex(uint32 packedRgba) internal pure returns (bytes memory) {
        uint256 r = (uint256(packedRgba) >> 16) & 0xFF;
        uint256 g = (uint256(packedRgba) >> 8) & 0xFF;
        uint256 b = uint256(packedRgba) & 0xFF;

        return bytes.concat(
            "#",
            bytes(LibString.toHexStringNoPrefix(r, 1)),
            bytes(LibString.toHexStringNoPrefix(g, 1)),
            bytes(LibString.toHexStringNoPrefix(b, 1))
        );
    }
}