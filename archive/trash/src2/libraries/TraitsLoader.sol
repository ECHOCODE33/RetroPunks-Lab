// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { IAssets } from '../interfaces/IAssets.sol';
import { TraitGroup, TraitInfo, CachedTraitGroups } from '../common/Structs.sol';

/**
 * @title TraitsLoader
 * @notice Efficient loader for compressed trait data with caching
 * @dev Optimized with inline assembly for gas savings
 */
library TraitsLoader {
    
    /**
     * @notice Initialize a new cached trait groups structure
     * @param _traitGroupsLength Number of trait groups to allocate
     * @return Empty CachedTraitGroups with allocated arrays
     */
    function initCachedTraitGroups(uint _traitGroupsLength) public pure returns (CachedTraitGroups memory) {
        return CachedTraitGroups({ 
            traitGroups: new TraitGroup[](_traitGroupsLength), 
            traitGroupsLoaded: new bool[](_traitGroupsLength) 
        });
    }

    /**
     * @notice Load and cache a trait group (if not already cached)
     * @param _assetsContract The assets storage contract
     * @param _cachedTraitGroups Cache structure to store loaded groups
     * @param _traitGroupIndex Index of the group to load
     * @return The loaded TraitGroup (from cache or freshly loaded)
     */
    function loadAndCacheTraitGroup(
        IAssets _assetsContract,
        CachedTraitGroups memory _cachedTraitGroups,
        uint _traitGroupIndex
    ) public view returns (TraitGroup memory) {
        // Return from cache if already loaded
        if (_cachedTraitGroups.traitGroupsLoaded[_traitGroupIndex]) {
            return _cachedTraitGroups.traitGroups[_traitGroupIndex];
        }

        TraitGroup memory traitGroup;
        traitGroup.traitGroupIndex = _traitGroupIndex;

        // Load compressed data from assets contract
        bytes memory traitGroupData = _assetsContract.loadAssetDecompressed(_traitGroupIndex);
        
        // === SECTION 1: Decode Group Name ===
        uint index = 0;
        traitGroup.traitGroupName = _decodeTraitGroupName(traitGroupData, index);
        index += 1 + traitGroup.traitGroupName.length;
        
        // === SECTION 2: Decode Palette ===
        (traitGroup.paletteRgba, index) = _decodeTraitGroupPalette(traitGroupData, index);

        // === SECTION 3: Decode Metadata ===
        uint8 indexByteSize = uint8(traitGroupData[index]);
        traitGroup.indexByteSize = indexByteSize;
        index++;

        uint8 traitCount = uint8(traitGroupData[index]);
        index++;

        // === SECTION 4: Decode Individual Traits ===
        traitGroup.traits = new TraitInfo[](traitCount);

        for (uint i = 0; i < traitCount; i++) {
            // Read trait header (9 bytes total)
            uint16 traitPixelCount;
            uint8 x1; 
            uint8 y1; 
            uint8 x2; 
            uint8 y2;
            uint8 bgTypeIndex; uint8 bgAssetKey;
            uint8 traitNameLength;
            
            // Optimized assembly read for trait header
            assembly {
                let dataPtr := add(traitGroupData, add(32, index))
                
                // Read 2-byte pixel count (little-endian)
                traitPixelCount := and(mload(dataPtr), 0xFFFF)
                
                // Read bounding box (4 bytes)
                x1 := byte(0, mload(add(dataPtr, 2)))
                y1 := byte(0, mload(add(dataPtr, 3)))
                x2 := byte(0, mload(add(dataPtr, 4)))
                y2 := byte(0, mload(add(dataPtr, 5)))
                
                // Read background metadata (2 bytes)
                bgTypeIndex := byte(0, mload(add(dataPtr, 6)))
                bgAssetKey := byte(0, mload(add(dataPtr, 7)))
                
                // Read trait name length (1 byte)
                traitNameLength := byte(0, mload(add(dataPtr, 8)))
            }
            
            index += 9; // Move past header
            
            // Read trait name
            bytes memory traitName = new bytes(traitNameLength);
            _memoryCopy(traitName, 0, traitGroupData, index, traitNameLength);
            index += traitNameLength;

            // === RLE Data Extraction ===
            uint256 rleStartIndex = index;
            uint256 pixelsTracked = 0;

            while (pixelsTracked < traitPixelCount) {
                // Read run length (1 byte)
                uint8 runLength = uint8(traitGroupData[index]);
                index++;
                
                // Skip color index (1 or 2 bytes)
                index += indexByteSize;
                
                // Track pixels covered by this run
                pixelsTracked += runLength;
            }

            // Copy RLE data
            uint256 rleByteLength = index - rleStartIndex;
            bytes memory traitData = new bytes(rleByteLength);
            _memoryCopy(traitData, 0, traitGroupData, rleStartIndex, rleByteLength);

            // Store trait info
            traitGroup.traits[i] = TraitInfo({
                traitName: traitName,
                bgTypeIndex: bgTypeIndex,
                bgAssetKey: bgAssetKey,
                x1: x1,
                y1: y1,
                x2: x2,
                y2: y2,
                traitData: traitData
            });
        }
    
        // Cache the loaded group
        _cachedTraitGroups.traitGroups[_traitGroupIndex] = traitGroup;
        _cachedTraitGroups.traitGroupsLoaded[_traitGroupIndex] = true;
    
        return traitGroup;
    }
    
    /**
     * @dev Decode trait group name from data
     */
    function _decodeTraitGroupName(
        bytes memory traitGroupData,
        uint startIndex
    ) internal pure returns (bytes memory) {
        uint8 nameLength = uint8(traitGroupData[startIndex]);
        bytes memory name = new bytes(nameLength);
        
        _memoryCopy(name, 0, traitGroupData, startIndex + 1, nameLength);
        
        return name;
    }

    /**
     * @dev Decode palette from trait group data
     */
    function _decodeTraitGroupPalette(
        bytes memory traitGroupData,
        uint startIndex
    ) internal pure returns (uint32[] memory paletteRgba, uint nextIndex) {
        // Read palette size (2 bytes, little-endian)
        uint16 paletteSize;
        assembly {
            let ptr := add(add(traitGroupData, 32), startIndex)
            paletteSize := and(mload(ptr), 0xFFFF)
        }

        paletteRgba = new uint32[](paletteSize);
        
        // Read palette colors - each is 4-byte little-endian uint32
        // Python writes: pack_le4(argb_uint32) where argb = (a<<24)|(r<<16)|(g<<8)|b
        assembly {
            let srcPtr := add(add(traitGroupData, 32), add(startIndex, 2))
            let destPtr := add(paletteRgba, 32)
            let endPtr := add(destPtr, mul(paletteSize, 32))
            
            for {} lt(destPtr, endPtr) {} {
                // Read 4-byte little-endian uint32
                // Bytes are stored as: [B, G, R, A] in memory (little-endian)
                // We need to reassemble as: 0xAARRGGBB
                let b0 := byte(0, mload(srcPtr))        // B
                let b1 := byte(0, mload(add(srcPtr, 1))) // G
                let b2 := byte(0, mload(add(srcPtr, 2))) // R
                let b3 := byte(0, mload(add(srcPtr, 3))) // A
                
                // Reconstruct as ARGB: (A<<24)|(R<<16)|(G<<8)|B
                let color := or(or(or(shl(24, b3), shl(16, b2)), shl(8, b1)), b0)
                
                mstore(destPtr, color)
                
                srcPtr := add(srcPtr, 4)
                destPtr := add(destPtr, 32)
            }
        }

        nextIndex = startIndex + 2 + (paletteSize * 4);
    }

    /**
     * @dev Efficient memory copy using assembly
     */
    function _memoryCopy(
        bytes memory dest,
        uint destOffset,
        bytes memory src,
        uint srcOffset,
        uint len
    ) internal pure {
        assembly {
            let destPtr := add(add(dest, 32), destOffset)
            let srcPtr := add(add(src, 32), srcOffset)
            let endPtr := add(srcPtr, len)
            
            // Copy 32 bytes at a time when possible
            for {} lt(add(srcPtr, 31), endPtr) {} {
                mstore(destPtr, mload(srcPtr))
                srcPtr := add(srcPtr, 32)
                destPtr := add(destPtr, 32)
            }
            
            // Copy remaining bytes
            for {} lt(srcPtr, endPtr) {} {
                mstore8(destPtr, byte(0, mload(srcPtr)))
                srcPtr := add(srcPtr, 1)
                destPtr := add(destPtr, 1)
            }
        }
    }
}