 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { TraitInfo, TraitGroup, CachedTraitGroups, TraitsContext } from '../common/Structs.sol';
import { E_TraitsGroup, E_Background_Type } from '../common/Enums.sol';
import { IAssets } from '../interfaces/IAssets.sol';
import { Utils } from './Utils.sol';
import { BitMap, PNG48x48 } from './PNG48x48.sol';
import { Division } from './Division.sol';

error TraitGroupNotLoaded(TraitGroup, bool traitGroupIsLoaded);
error TraitIndexOutOfBounds(uint8 traitGroupIndex, uint8 traitIndex, uint256 maxIndex);
error PaletteIndexOutOfBounds(uint16 colorIdx, uint256 paletteSize);
error PixelCoordinatesOutOfBounds(uint8 x, uint8 y);
error NoPixelData(uint traitDataLength);

library TraitsRenderer {
    
    function renderGridToSvg(IAssets assetsContract, bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal view {
        
        Utils.concat(buffer, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">');  
        Utils.concat(buffer, '<style>img{image-rendering:pixelated;}</style>');
        
        Utils.concat(buffer, '<g id="Background">');
        _renderBackground(assetsContract, buffer, cachedTraitGroups, traits);
        Utils.concat(buffer, '</g>');

        BitMap memory bitMap;

        for (uint i = 0; i < traits.traitsToRenderLength; i++) {
            if (traits.traitsToRender[i].traitGroup == E_TraitsGroup.Background_Group) continue;

            _renderTraitGroup(
                bitMap,
                cachedTraitGroups,
                uint8(traits.traitsToRender[i].traitGroup),
                traits.traitsToRender[i].traitIndex
            );

            if (traits.traitsToRender[i].hasFiller) {
                _renderTraitGroup(
                    bitMap,
                    cachedTraitGroups,
                    uint8(traits.traitsToRender[i].filler.traitGroup),
                    traits.traitsToRender[i].filler.traitIndex
                );
            }
        }

        string memory urlEncodedPNG = PNG48x48.toURLEncodedPNG(bitMap);
        Utils.concat(buffer, '<g id="GeneratedImage">');
        Utils.concat(buffer, '<foreignObject width="48" height="48"><img xmlns="http://www.w3.org/1999/xhtml" src="');
        Utils.concat(buffer, bytes(urlEncodedPNG));
        Utils.concat(buffer, '" width="100%" height="100%"/></foreignObject></g></svg>');
    }

    function _renderBackground(IAssets assetsContract, bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) private view {
        
        uint bgGroupIndex = uint8(E_TraitsGroup.Background_Group); // this equals 1

        TraitGroup memory bgTraitGroup = cachedTraitGroups.traitGroups[bgGroupIndex];


        if (uint8(traits.background) >= bgTraitGroup.traits.length) {
            // Check if length is 0 first to avoid the 0 - 1 underflow
            uint256 maxIdx = bgTraitGroup.traits.length > 0 ? bgTraitGroup.traits.length - 1 : 0;
            revert TraitIndexOutOfBounds(uint8(bgGroupIndex), uint8(traits.background), maxIdx);
        }
        
        TraitInfo memory trait = bgTraitGroup.traits[uint8(traits.background)];
        
        E_Background_Type bg = E_Background_Type(trait.layerType);

        if (bg == E_Background_Type.Solid) {
            uint16 paletteIdx = _decodePaletteIndex(trait.traitData, 0, bgTraitGroup.paletteIndexByteSize);
            
            if (paletteIdx >= bgTraitGroup.paletteRgba.length) {
                revert PaletteIndexOutOfBounds(paletteIdx, bgTraitGroup.paletteRgba.length);
            }
            
            uint32 color = bgTraitGroup.paletteRgba[paletteIdx];
            Utils.concat(buffer, '<rect width="48" height="48" fill="');
            _writeHexColor(buffer, color);
            Utils.concat(buffer, '"/>');
            return;
        }

        else if (bg == E_Background_Type.Background_Image) {
            bytes memory pngBase64 = assetsContract.loadAssetOriginal(1000 + uint(traits.background));
            Utils.concat(buffer, '<foreignObject width="48" height="48">');
            Utils.concat(buffer, '<img xmlns="http://www.w3.org/1999/xhtml" src="data:image/png;base64,');
            Utils.concatBase64(buffer, pngBase64);
            Utils.concat(buffer, '" width="100%" height="100%" /></foreignObject>');
            return;
        }

        else if (bg == E_Background_Type.Radial) {
            bytes memory gradientIdx = bytes(Utils.toString(uint(traits.background)));
            Utils.concat(buffer, '<defs><radialGradient id="bg-');
            Utils.concat(buffer, gradientIdx);
            Utils.concat(buffer, '">');
            _renderSmoothGradientStops(buffer, cachedTraitGroups, bgGroupIndex, trait);
            Utils.concat(buffer, '</radialGradient></defs><rect width="48" height="48" fill="url(#bg-');
            Utils.concat(buffer, gradientIdx);
            Utils.concat(buffer, ')"/>');
            return;
        }

        else {
            bytes memory gradientIdx = bytes(Utils.toString(uint(traits.background)));
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

            bool isPixelated = (uint8(bg) % 2 == 0) && (uint8(bg) >= uint8(E_Background_Type.P_Vertical));
            
            if (isPixelated) {
                _renderPixelGradientStops(buffer, cachedTraitGroups, bgGroupIndex, trait);
            } else {
                _renderSmoothGradientStops(buffer, cachedTraitGroups, bgGroupIndex, trait);
            }
            
            Utils.concat(buffer, '</linearGradient></defs><rect width="48" height="48" fill="url(#bg-');
            Utils.concat(buffer, gradientIdx);
            Utils.concat(buffer, ')"/>');
        }
    }

    function _renderTraitGroup(BitMap memory bitMap, CachedTraitGroups memory cachedTraitGroups, uint8 traitGroupIndex, uint8 traitIndex) internal pure {
        
        TraitGroup memory group = cachedTraitGroups.traitGroups[traitGroupIndex];
        // bool traitGroupIsLoaded = cachedTraitGroups.traitGroupsLoaded[traitGroupIndex];

        // if (!traitGroupIsLoaded) {
        //     revert TraitGroupNotLoaded(group, traitGroupIsLoaded);
        // }
        
        // Safety check for index
        if (traitIndex >= group.traits.length) {
            revert TraitIndexOutOfBounds(traitGroupIndex, traitIndex, group.traits.length > 0 ? group.traits.length - 1 : 0);
        }
        
        TraitInfo memory trait = group.traits[traitIndex];
        
        uint traitDataLength = trait.traitData.length;
        if (traitDataLength == 0) {
            revert NoPixelData(traitDataLength);
        }

        bytes memory data = trait.traitData;
        uint256 ptr = 0;
        uint256 totalData = data.length;

        uint currX = trait.x1;
        uint currY = trait.y1;

        while (ptr < totalData) {
            uint8 run = uint8(data[ptr++]);
            uint16 colorIdx;
            
            if (group.paletteIndexByteSize == 1) {
                colorIdx = uint16(uint8(data[ptr++]));
            } else {
                colorIdx = (uint16(uint8(data[ptr++])) << 8) | uint16(uint8(data[ptr++]));
            }

            if (colorIdx >= group.paletteRgba.length) {
                revert PaletteIndexOutOfBounds(colorIdx, group.paletteRgba.length);
            }

            uint32 rgba = group.paletteRgba[colorIdx];

            for (uint8 i = 0; i < run; i++) {
                // Now safe — no wrap-around possible
                if (currX >= 48 || currY >= 48) {
                    revert PixelCoordinatesOutOfBounds(uint8(currX), uint8(currY));
                }
                
                if (rgba & 0xFF > 0) {
                    PNG48x48.renderPixelToBitMap(bitMap, uint8(currX), uint8(currY), rgba);
                }
                
                currX++;
                if (currX > trait.x2) {
                    currX = trait.x1;
                    currY++;
                }
            }
        }
    }

    function _renderPixelGradientStops(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, uint traitGroupIndex, TraitInfo memory trait) private pure {
        
        TraitGroup memory traitGroup = cachedTraitGroups.traitGroups[traitGroupIndex];
        require (trait.traitData.length > 0, "TraitData is empty, couldn't fetch gradient stops");
        
        uint numStops = trait.traitData.length / traitGroup.paletteIndexByteSize;

        int scale = 1_000_000;

        for (uint i = 0; i < numStops; i++) {
            uint16 idx = _decodePaletteIndex(trait.traitData, i * traitGroup.paletteIndexByteSize, traitGroup.paletteIndexByteSize);
            
            // BOUNDS CHECK: Validate palette index
            if (idx >= traitGroup.paletteRgba.length) {
                revert PaletteIndexOutOfBounds(idx, traitGroup.paletteRgba.length);
            }
            
            uint32 color = traitGroup.paletteRgba[idx];
            
            bytes memory startOffset = bytes(Division.divisionStr(4, (int(i) * 100 * scale) / int(numStops), scale));
            bytes memory endOffset = bytes(Division.divisionStr(4, (int(i + 1) * 100 * scale) / int(numStops), scale));
            
            Utils.concat(buffer, '<stop offset="'); 
            Utils.concat(buffer, startOffset); 
            Utils.concat(buffer, '%" '); 
            _writeColorStop(buffer, color);
            Utils.concat(buffer, '/><stop offset="'); 
            Utils.concat(buffer, endOffset); 
            Utils.concat(buffer, '%" '); 
            _writeColorStop(buffer, color);
            Utils.concat(buffer, '/>');
        }
    }

    function _renderSmoothGradientStops(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, uint traitGroupIndex, TraitInfo memory trait) private pure {
        
        TraitGroup memory traitGroup = cachedTraitGroups.traitGroups[traitGroupIndex];
        require (trait.traitData.length > 0, "TraitData is empty, couldn't fetch gradient stops");
        
        uint numStops = trait.traitData.length / traitGroup.paletteIndexByteSize;

        int scale = 1_000_000;
        
        for (uint i = 0; i < numStops; i++) {
            uint16 idx = _decodePaletteIndex(trait.traitData, i * traitGroup.paletteIndexByteSize, traitGroup.paletteIndexByteSize);
            
            // Safety Check: Ensure index is not out of paletteRgba bounds
            if (idx >= traitGroup.paletteRgba.length) {
                revert PaletteIndexOutOfBounds(idx, traitGroup.paletteRgba.length);
            }
            
            uint32 color = traitGroup.paletteRgba[idx];

            bytes memory offset = bytes(Division.divisionStr(4, (int(i) * 100 * scale) / int(numStops - 1), scale));
            
            Utils.concat(buffer, '<stop offset="');
            Utils.concat(buffer, offset);
            Utils.concat(buffer, '%" ');
            _writeColorStop(buffer, color);
            Utils.concat(buffer, '/>');
        }
    }

    function _decodePaletteIndex(bytes memory data, uint offset, uint8 byteSize) internal pure returns (uint16) {
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
        Utils.concat(buffer, abi.encodePacked(
            hexChars[r >> 4], hexChars[r & 0xf],
            hexChars[g >> 4], hexChars[g & 0xf],
            hexChars[b >> 4], hexChars[b & 0xf]
        ));
    }
}