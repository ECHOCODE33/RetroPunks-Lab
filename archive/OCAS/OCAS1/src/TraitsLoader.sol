// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { IAssetsSSTORE2 } from './sstore2/IAssetsSSTORE2.sol';
import { TraitGroup, TraitInfo2, CachedTraitGroups } from './TraitsContextStructs.sol';
import { LibString } from './common/LibString.sol';

/**
 * @author EtoVass
 */

library TraitsLoader {
    function initCachedTraitGroups(uint traitGroupsLength) internal pure returns (CachedTraitGroups memory) {
        return CachedTraitGroups(
            new TraitGroup[](traitGroupsLength), 
            new bool[](traitGroupsLength)
        );
    }

    function decodeTraitGroupName(bytes memory traitGroupData, uint startIndex) internal pure returns (bytes memory) {
        uint8 traitGroupNameLength = uint8(traitGroupData[startIndex]); // get the trait group name length
        bytes memory traitGroupName = new bytes(traitGroupNameLength);      
        for (uint i = 0; i < traitGroupNameLength; i++) {
            traitGroupName[i] = traitGroupData[startIndex + i + 1];
        }
        return traitGroupName;
    }

    function decodeTraitGroupPalette(bytes memory traitGroupData, uint startIndex) internal pure returns (string[] memory, uint32[] memory) {
        uint8 paletteSize = uint8(traitGroupData[startIndex]); // get the palette size
        string[] memory palette = new string[](paletteSize);
        uint32[] memory paletteRgba = new uint32[](paletteSize);
        for (uint i = 0; i < paletteSize; i++) {
            // palette[i] = string.concat('rgba(', 
            //     Utils.toString(uint8(traitGroupData[startIndex + 1 + i * 4 + 1])), ',', 
            //     Utils.toString(uint8(traitGroupData[startIndex + 1 + i * 4 + 2])), ',', 
            //     Utils.toString(uint8(traitGroupData[startIndex + 1 + i * 4 + 3])), ',', 
            //     "1", ')');

            palette[i] = string.concat('#', 
                LibString.toHexStringNoPrefix(uint256(uint8(traitGroupData[startIndex + i * 4 + 1])), 1),
                LibString.toHexStringNoPrefix(uint256(uint8(traitGroupData[startIndex + i * 4 + 2])), 1),
                LibString.toHexStringNoPrefix(uint256(uint8(traitGroupData[startIndex + i * 4 + 3])), 1),
                LibString.toHexStringNoPrefix(uint256(uint8(traitGroupData[startIndex + i * 4 + 4])), 1)
            );

            paletteRgba[i] = 
                uint32(uint8(traitGroupData[startIndex + i * 4 + 1])) << 24 | 
                uint32(uint8(traitGroupData[startIndex + i * 4 + 2])) << 16 | 
                uint32(uint8(traitGroupData[startIndex + i * 4 + 3])) << 8 | 
                uint32(uint8(traitGroupData[startIndex + i * 4 + 4]));            
        }
        return (palette, paletteRgba);
    }

    function loadAndCacheTraitGroup(IAssetsSSTORE2 assetsSSTORE2, CachedTraitGroups memory cachedTraitGroups, uint traitGroupIndex) internal view returns (TraitGroup memory) {
        if (cachedTraitGroups.traitGroupsLoaded[traitGroupIndex]) {
            return cachedTraitGroups.traitGroups[traitGroupIndex];
        }

        TraitGroup memory traitGroup;

        traitGroup.traitGroupIndex = traitGroupIndex;

        bytes memory traitGroupData = assetsSSTORE2.loadAsset(traitGroupIndex, true); // load the trait group data, which is lz77 compressed
        
        traitGroup.traitGroupName = decodeTraitGroupName(traitGroupData, 0);
        (traitGroup.palette, traitGroup.paletteRgba) = decodeTraitGroupPalette(traitGroupData, traitGroup.traitGroupName.length + 1);

        uint index = traitGroup.traitGroupName.length + 1 + traitGroup.palette.length * 4 + 1;
        uint8 traitCount = uint8(traitGroupData[index]); // get the trait count
        index++;

        traitGroup.traits = new TraitInfo2[](traitCount);

        for (uint i = 0; i < traitCount; i++) {
            uint traitDataLength = uint(uint8(traitGroupData[index])) | uint(uint8(traitGroupData[index + 1])) << 8;
            index += 2;

            uint8 x1 = uint8(traitGroupData[index]);
            index++;

            uint8 y1 = uint8(traitGroupData[index]);
            index++;

            uint8 x2 = uint8(traitGroupData[index]);
            index++;

            uint8 y2 = uint8(traitGroupData[index]);
            index++;

            uint8 traitNameLength = uint8(traitGroupData[index]);
            index++;

            bytes memory traitName = new bytes(traitNameLength);
            for (uint j = 0; j < traitNameLength; j++) {
                traitName[j] = traitGroupData[index];
                index++;
            }

            uint8[] memory traitData = new uint8[](traitDataLength);
            for (uint j = 0; j < traitDataLength; j++) {
                traitData[j] = uint8(traitGroupData[index]);
                index++;
            }

            traitGroup.traits[i] = TraitInfo2(traitName, x1, y1, x2, y2, traitData);
        }
    
        cachedTraitGroups.traitGroups[traitGroupIndex] = traitGroup;
        cachedTraitGroups.traitGroupsLoaded[traitGroupIndex] = true;
    
        return traitGroup;
    }
}