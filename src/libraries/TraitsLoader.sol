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
        
        traitGroup.traitGroupName = _decodeTraitGroupName(traitGroupData, index);
        index += 1 + traitGroup.traitGroupName.length;
        
        (traitGroup.paletteRgba, index) = _decodeTraitGroupPalette(traitGroupData, index);

        traitGroup.paletteIndexByteSize = uint8(traitGroupData[index]);
        index++;

        uint8 traitCount = uint8(traitGroupData[index]);
        index++;

        traitGroup.traits = new TraitInfo[](traitCount);

        for (uint i = 0; i < traitCount; i++) {
            TraitInfo memory t;
            
            // Read 2 bytes Big Endian for pixel count
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

            uint256 rleStartIndex = index;

            // --- BLOCK SCOPE START (To prevent Stack Too Deep) ---
            {
                uint256 pixelsTracked = 0;
                uint8 pSize = traitGroup.paletteIndexByteSize;
                
                if (traitPixelCount > 0) {
                    while (pixelsTracked < traitPixelCount) {
                        if (index >= traitGroupData.length) revert("RLE data truncated");
                        
                        uint8 runLength = uint8(traitGroupData[index++]);
                        
                        if (index + pSize > traitGroupData.length) revert("RLE palette index overflow");
                        index += pSize;

                        pixelsTracked += runLength;

                        if (pixelsTracked > traitPixelCount) revert("RLE exceeds trait pixel count");
                    }
                }
            }
            // --- BLOCK SCOPE END ---

            uint256 rleByteLength = index - rleStartIndex;
            t.traitData = new bytes(rleByteLength);
            _memoryCopy(t.traitData, 0, traitGroupData, rleStartIndex, rleByteLength);

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
        // Read 2 bytes Big Endian for palette size
        uint16 paletteSize = uint16(uint8(traitGroupData[startIndex])) << 8 | uint16(uint8(traitGroupData[startIndex + 1]));
        
        // If palette is empty (common for Background Images), return early
        if (paletteSize == 0) {
            return (new uint32[](0), startIndex + 2);
        }

        paletteRgba = new uint32[](paletteSize);
        uint cursor = startIndex + 2;
        
        // Safety check for data length
        require(traitGroupData.length >= cursor + (paletteSize * 4), "Insufficient palette data");
        
        for (uint i = 0; i < paletteSize; i++) {
            uint32 color;
            assembly {
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