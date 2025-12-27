// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { IAssets } from '../interfaces/IAssets.sol';
import { TraitGroup, TraitInfo, CachedTraitGroups } from '../common/Structs.sol';
import { E_TraitsGroup } from '../common/Enums.sol';


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
        
        // Decode Name
        traitGroup.traitGroupName = _decodeTraitGroupName(traitGroupData, index);
        index += 1 + traitGroup.traitGroupName.length;
        
        // Decode Palette
        (traitGroup.paletteRgba, index) = _decodeTraitGroupPalette(traitGroupData, index);

        // Decode Data
        traitGroup.paletteIndexByteSize = uint8(traitGroupData[index]);
        index++;

        uint8 traitCount = uint8(traitGroupData[index]);
        index++;

        traitGroup.traits = new TraitInfo[](traitCount);

        for (uint i = 0; i < traitCount; i++) {
            TraitInfo memory t;
            
            // [PixelCount:2][x1:1][y1:1][x2:1][y2:1][layerType:1][nameLen:1] = 8 bytes
            uint16 traitPixelCount = uint16(uint8(traitGroupData[index])) << 8 | uint16(uint8(traitGroupData[index + 1]));
            
            t.x1 = uint8(traitGroupData[index + 2]);
            t.y1 = uint8(traitGroupData[index + 3]);
            t.x2 = uint8(traitGroupData[index + 4]);
            t.y2 = uint8(traitGroupData[index + 5]);
            t.layerType = uint8(traitGroupData[index + 6]);
            uint8 traitNameLength = uint8(traitGroupData[index + 7]);
            
            index += 8; 

            t.traitName = new bytes(traitNameLength);
            _memoryCopy(t.traitName, 0, traitGroupData, index, traitNameLength);
            index += traitNameLength;

            uint256 startOfData = index;
            uint8 pSize = traitGroup.paletteIndexByteSize;
            
            if (traitPixelCount > 0) {
                if (traitGroup.traitGroupIndex == uint8(E_TraitsGroup.Background_Group)) {
                    index += (traitPixelCount * pSize);
                } 
                else {
                    uint256 pixelsTracked = 0;
                    while (pixelsTracked < traitPixelCount) {
                        uint8 runLength = uint8(traitGroupData[index++]);
                        index += pSize;
                        pixelsTracked += runLength;
                    }
                }
            }

            uint256 dataLength = index - startOfData;
            t.traitData = new bytes(dataLength);
            
            if (dataLength > 0) {
                _memoryCopy(t.traitData, 0, traitGroupData, startOfData, dataLength);
            }

            traitGroup.traits[i] = t;
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
        uint16 paletteSize = uint16(uint8(traitGroupData[startIndex])) << 8 | uint16(uint8(traitGroupData[startIndex + 1]));
        
        if (paletteSize == 0) {
            return (new uint32[](0), startIndex + 2);
        }

        paletteRgba = new uint32[](paletteSize);
        uint cursor = startIndex + 2;
        
        for (uint i = 0; i < paletteSize; i++) {
            uint32 color = uint32(uint8(traitGroupData[cursor])) << 24 |
                           uint32(uint8(traitGroupData[cursor + 1])) << 16 |
                           uint32(uint8(traitGroupData[cursor + 2])) << 8 |
                           uint32(uint8(traitGroupData[cursor + 3]));
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