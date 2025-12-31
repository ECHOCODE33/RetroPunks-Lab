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
        uint256 dataLength = traitGroupData.length; // NEW: Cache length to avoid repeated reads
        
        uint256 index = 0; // NEW: Changed to uint256 for consistency and gas savings
        
        // Decode Name
        traitGroup.traitGroupName = _decodeTraitGroupName(traitGroupData, index);
        unchecked { index += 1 + traitGroup.traitGroupName.length; } // NEW: Unchecked - sequential read, no overflow
        
        // Decode Palette
        (traitGroup.paletteRgba, index) = _decodeTraitGroupPalette(traitGroupData, index);

        // Decode Data
        traitGroup.paletteIndexByteSize = uint8(traitGroupData[index]);
        unchecked { index++; } // NEW: Unchecked increment

        uint8 traitCount = uint8(traitGroupData[index]);
        unchecked { index++; } // NEW: Unchecked increment

        traitGroup.traits = new TraitInfo[](traitCount);
        uint8 pSize = traitGroup.paletteIndexByteSize; // NEW: Cache palette size to save gas

        unchecked { // NEW: Unchecked block for entire trait parsing loop
            for (uint256 i = 0; i < traitCount; i++) { // NEW: uint256 for loop counter (gas optimization)
                require(index + 8 <= dataLength, "Insufficient data for trait header"); // NEW: Explicit bounds check
                
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

                require(index + traitNameLength <= dataLength, "Insufficient data for trait name"); // NEW: Explicit bounds check
                t.traitName = new bytes(traitNameLength);
                _memoryCopy(t.traitName, 0, traitGroupData, index, traitNameLength);
                index += traitNameLength;

                uint256 startOfData = index;
                
                if (traitPixelCount > 0) {
                    if (traitGroup.traitGroupIndex == uint8(E_TraitsGroup.Background_Group)) {
                        index += (traitPixelCount * pSize);
                    } 
                    else {
                        uint256 pixelsTracked = 0;
                        while (pixelsTracked < traitPixelCount) {
                            require(index < dataLength, "Insufficient RLE data");
                            uint8 runLength = uint8(traitGroupData[index++]);
                            
                            // SAFETY: If the encoder failed and wrote a 0, we must revert, not hang
                            require(runLength > 0, "RLE: Run length cannot be 0"); 

                            require(index + pSize <= dataLength, "Insufficient palette index data");
                            index += pSize;
                            pixelsTracked += runLength;
                        }
                        require(pixelsTracked == traitPixelCount, "RLE pixel count mismatch"); // NEW: Verify exact match
                    }
                }

                uint256 dataLen = index - startOfData; // NEW: Renamed to avoid shadowing
                t.traitData = new bytes(dataLen);
                
                if (dataLen > 0) {
                    _memoryCopy(t.traitData, 0, traitGroupData, startOfData, dataLen);
                }

                traitGroup.traits[i] = t;
            }
        } // NEW: End of unchecked block
    
        _cachedTraitGroups.traitGroups[_traitGroupIndex] = traitGroup;
        _cachedTraitGroups.traitGroupsLoaded[_traitGroupIndex] = true;
        return traitGroup;
    }
    
    function _decodeTraitGroupName(bytes memory traitGroupData, uint256 startIndex) internal pure returns (bytes memory) {
        // NEW: uint256 for startIndex
        require(startIndex < traitGroupData.length, "Invalid name start index"); // NEW: Bounds check
        uint8 nameLength = uint8(traitGroupData[startIndex]);
        require(startIndex + 1 + nameLength <= traitGroupData.length, "Invalid name length"); // NEW: Bounds check
        bytes memory name = new bytes(nameLength);
        unchecked { _memoryCopy(name, 0, traitGroupData, startIndex + 1, nameLength); } // NEW: Unchecked for copy
        return name;
    }

    function _decodeTraitGroupPalette(bytes memory traitGroupData, uint256 startIndex) internal pure returns (uint32[] memory paletteRgba, uint256 nextIndex) {
        // NEW: uint256 for indices
        require(startIndex + 2 <= traitGroupData.length, "Insufficient data for palette size"); // NEW: Bounds check
        uint16 paletteSize = uint16(uint8(traitGroupData[startIndex])) << 8 | uint16(uint8(traitGroupData[startIndex + 1]));
        
        if (paletteSize == 0) {
            return (new uint32[](0), startIndex + 2);
        }

        require(startIndex + 2 + (uint256(paletteSize) * 4) <= traitGroupData.length, "Insufficient data for palette"); // NEW: Bounds check
        paletteRgba = new uint32[](paletteSize);
        uint256 cursor = startIndex + 2;
        
        unchecked {
            // NEW: Unchecked block for palette parsing
            for (uint256 i = 0; i < paletteSize; i++) { // NEW: uint256 for loop counter
                uint32 color = uint32(uint8(traitGroupData[cursor])) << 24 |
                               uint32(uint8(traitGroupData[cursor + 1])) << 16 |
                               uint32(uint8(traitGroupData[cursor + 2])) << 8 |
                               uint32(uint8(traitGroupData[cursor + 3]));
                paletteRgba[i] = color;
                cursor += 4;
            }
        }

        nextIndex = cursor;
    }

    function _memoryCopy(bytes memory dest, uint256 destOffset, bytes memory src, uint256 srcOffset, uint256 len) internal pure {
        if (len == 0) return;
        assembly {
            let destPtr := add(add(dest, 32), destOffset)
            let srcPtr := add(add(src, 32), srcOffset)
            
            // Copy in 32-byte chunks
            for { let i := 0 } lt(i, len) { i := add(i, 32) } {
                mstore(add(destPtr, i), mload(add(srcPtr, i)))
            }
        }
    }
}