// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { IAssets } from '../interfaces/IAssets.sol';
import { TraitGroup, TraitInfo, CachedTraitGroups } from '../common/Structs.sol';

library TraitsLoader {
    function initCachedTraitGroups(uint _traitGroupsLength) public pure returns (CachedTraitGroups memory) {
        return CachedTraitGroups({ 
            traitGroups: new TraitGroup[](_traitGroupsLength), 
            traitGroupsLoaded: new bool[](_traitGroupsLength) 
        });
    }

    function loadAndCacheTraitGroup(IAssets _assetsContract, CachedTraitGroups memory _cachedTraitGroups, uint _traitGroupIndex) public view returns (TraitGroup memory) {
        if (_cachedTraitGroups.traitGroupsLoaded[_traitGroupIndex]) {
            return _cachedTraitGroups.traitGroups[_traitGroupIndex];
        }

        TraitGroup memory traitGroup;
        traitGroup.traitGroupIndex = _traitGroupIndex;
        bytes memory traitGroupData = _assetsContract.loadAssetDecompressed(_traitGroupIndex);
        
        uint index = 0;
        
        // Decode Group Name
        traitGroup.traitGroupName = _decodeTraitGroupName(traitGroupData, index);
        index += 1 + traitGroup.traitGroupName.length;
        
        // Decode Palette
        (traitGroup.paletteRgba, index) = _decodeTraitGroupPalette(traitGroupData, index);

        // Read Index Byte Size & Trait Count
        uint8 indexByteSize = uint8(traitGroupData[index]);
        traitGroup.indexByteSize = indexByteSize;
        index++;

        uint8 traitCount = uint8(traitGroupData[index]);
        index++;

        traitGroup.traits = new TraitInfo[](traitCount);

        // Decode Traits
        for (uint i = 0; i < traitCount; i++) {
            // Read Trait Header safely using manual byte shifting for the uint16
            // This avoids alignment issues with mload
            uint16 traitPixelCount = uint16(uint8(traitGroupData[index])) << 8 | uint16(uint8(traitGroupData[index + 1]));
            
            uint8 x1 = uint8(traitGroupData[index + 2]);
            uint8 y1 = uint8(traitGroupData[index + 3]);
            uint8 x2 = uint8(traitGroupData[index + 4]);
            uint8 y2 = uint8(traitGroupData[index + 5]);
            uint8 layerType = uint8(traitGroupData[index + 6]);
            uint8 traitNameLength = uint8(traitGroupData[index + 7]);
            
            index += 8; 

            // Read Trait Name
            bytes memory traitName = new bytes(traitNameLength);
            _memoryCopy(traitName, 0, traitGroupData, index, traitNameLength);
            index += traitNameLength;

            // Read RLE Data
            uint256 rleStartIndex = index;
            uint256 pixelsTracked = 0;
            
            while (pixelsTracked < traitPixelCount) {
                uint8 runLength = uint8(traitGroupData[index]);
                index++;
                
                // If indexByteSize is 2, we must skip 2 bytes for the color index
                // otherwise we skip 1 byte.
                index += indexByteSize;
                
                pixelsTracked += runLength;
            }

            // Copy the exact RLE slice
            uint256 rleByteLength = index - rleStartIndex;
            bytes memory traitData = new bytes(rleByteLength);
            _memoryCopy(traitData, 0, traitGroupData, rleStartIndex, rleByteLength);

            traitGroup.traits[i] = TraitInfo({
                traitName: traitName,
                layerType: layerType,
                x1: x1, 
                y1: y1, 
                x2: x2, 
                y2: y2,
                traitData: traitData
            });
        }
    
        _cachedTraitGroups.traitGroups[_traitGroupIndex] = traitGroup;
        _cachedTraitGroups.traitGroupsLoaded[_traitGroupIndex] = true;
        return traitGroup;
    }
    
    function _decodeTraitGroupName(bytes memory traitGroupData, uint startIndex) internal pure returns (bytes memory) {
        uint8 nameLength = uint8(traitGroupData[startIndex]);
        bytes memory name = new bytes(nameLength);
        _memoryCopy(name, 0, traitGroupData, startIndex + 1, nameLength);
        return name;
    }

    function _decodeTraitGroupPalette(bytes memory traitGroupData, uint startIndex) internal pure returns (uint32[] memory paletteRgba, uint nextIndex) {
        // Safe manual read of uint16 Palette Size (Big Endian)
        uint16 paletteSize = uint16(uint8(traitGroupData[startIndex])) << 8 | uint16(uint8(traitGroupData[startIndex + 1]));
        
        paletteRgba = new uint32[](paletteSize);
        uint cursor = startIndex + 2;
        
        // Loop through colors
        for (uint i = 0; i < paletteSize; i++) {
            uint32 color;
            assembly {
                // Read 32 bytes from cursor position, shift right 224 bits to keep top 4 bytes (RGBA)
                color := shr(224, mload(add(add(traitGroupData, 32), cursor)))
            }
            paletteRgba[i] = color;
            cursor += 4;
        }
        nextIndex = cursor;
    }

    function _memoryCopy(bytes memory dest, uint destOffset, bytes memory src, uint srcOffset, uint len) internal pure {
        assembly {
            let destPtr := add(add(dest, 32), destOffset)
            let srcPtr := add(add(src, 32), srcOffset)
            let endPtr := add(srcPtr, len)
            for {} lt(add(srcPtr, 31), endPtr) {} {
                mstore(destPtr, mload(srcPtr))
                srcPtr := add(srcPtr, 32)
                destPtr := add(destPtr, 32)
            }
            for {} lt(srcPtr, endPtr) {} {
                mstore8(destPtr, byte(0, mload(srcPtr)))
                srcPtr := add(srcPtr, 1)
                destPtr := add(destPtr, 1)
            }
        }
    }
}