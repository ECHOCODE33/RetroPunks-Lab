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
        
        traitGroup.traitGroupName = decodeTraitGroupName(traitGroupData, 0);
        
        (traitGroup.paletteRgba) = decodeTraitGroupPalette(traitGroupData, traitGroup.traitGroupName.length + 1);

        uint paletteStartIndex = traitGroup.traitGroupName.length + 1;
        uint paletteSize = uint(uint8(traitGroupData[paletteStartIndex])) | uint(uint8(traitGroupData[paletteStartIndex + 1])) << 8;
        
        uint index = paletteStartIndex + 2 + paletteSize * 4;
        
        uint8 indexByteSize = uint8(traitGroupData[index]); 
        traitGroup.indexByteSize = indexByteSize;
        index++;

        uint8 traitCount = uint8(traitGroupData[index]); 
        index++;

        traitGroup.traits = new TraitInfo[](traitCount);

        for (uint i = 0; i < traitCount; i++) {
            uint traitPixelCount = uint(uint8(traitGroupData[index])) | uint(uint8(traitGroupData[index + 1])) << 8;
            index += 2;

            uint8 x1 = uint8(traitGroupData[index]);
            index++;

            uint8 y1 = uint8(traitGroupData[index]);
            index++;

            uint8 x2 = uint8(traitGroupData[index]);
            index++;

            uint8 y2 = uint8(traitGroupData[index]); 
            index++;

            uint8 bgTypeIndex = uint8(traitGroupData[index]);
            index++;

            uint8 bgAssetKey = uint8(traitGroupData[index]);
            index++;

            uint8 traitNameLength = uint8(traitGroupData[index]);
            index++;

            bytes memory traitName = new bytes(traitNameLength);
            for (uint j = 0; j < traitNameLength; j++) {
                traitName[j] = traitGroupData[index];
                index++;
            }

            // 1. We don't know the byte length upfront because it's compressed.
            // We scan the RLE stream until we have accounted for all 'traitPixelCount' pixels.
            uint256 startByte = index;
            uint256 pixelsTracked = 0;

            while (pixelsTracked < traitPixelCount) {
                // Read the 'run length' (how many pixels this color covers)
                uint8 runLength = uint8(traitGroupData[index]);
                index++; // move past runLength byte

                // Move past the color index (1 or 2 bytes depending on palette size)
                index += indexByteSize; 
                
                // Accumulate the pixel count to know when the trait is fully read
                pixelsTracked += runLength;
            }

            // 2. Now that we know the compressed byte length, copy it into memory
            uint256 rleByteLength = index - startByte;
            bytes memory traitData = new bytes(rleByteLength);

            for (uint j = 0; j < rleByteLength; j++) {
                traitData[j] = traitGroupData[startByte + j];
            }

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
    
        _cachedTraitGroups.traitGroups[_traitGroupIndex] = traitGroup;
        _cachedTraitGroups.traitGroupsLoaded[_traitGroupIndex] = true;
    
        return traitGroup;
    }
    
    function decodeTraitGroupName(bytes memory traitGroupData, uint startIndex) internal pure returns (bytes memory) {
        uint8 traitGroupNameLength = uint8(traitGroupData[startIndex]);
        bytes memory traitGroupName = new bytes(traitGroupNameLength);      
        for (uint i = 0; i < traitGroupNameLength; i++) {
            traitGroupName[i] = traitGroupData[startIndex + i + 1];
        }
        return traitGroupName;
    }

    function decodeTraitGroupPalette(bytes memory traitGroupData, uint startIndex) internal pure returns (uint32[] memory) {
        uint16 paletteSize = uint16(uint8(traitGroupData[startIndex])) | (uint16(uint8(traitGroupData[startIndex + 1])) << 8); 

        uint32[] memory paletteRgba = new uint32[](paletteSize);

        for (uint i = 0; i < paletteSize; i++) {

            paletteRgba[i] = 
                uint32(uint8(traitGroupData[startIndex + 2 + i * 4])) << 24 | // A
                uint32(uint8(traitGroupData[startIndex + 3 + i * 4])) << 16 | // R
                uint32(uint8(traitGroupData[startIndex + 4 + i * 4])) << 8 |  // G
                uint32(uint8(traitGroupData[startIndex + 5 + i * 4]));        // B             
        }

        return paletteRgba;
    }
}