// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { ISVGRenderer } from './interfaces/ISVGRenderer.sol';
import { ITraits } from './interfaces/ITraits.sol';
import { IAssets } from './interfaces/IAssets.sol';
import { NUM_TRAIT_GROUPS, E_TraitsGroup } from "./common/Enums.sol";
import { TraitsContext, CachedTraitGroups, TraitGroup, TraitInfo } from './common/Structs.sol';
import { TraitsRenderer } from './libraries/TraitsRenderer.sol';
import { TraitsLoader } from './libraries/TraitsLoader.sol';
import { LibTraits } from './libraries/LibTraits.sol';
import { Utils } from './libraries/Utils.sol';
import { DynamicBuffer } from './libraries/DynamicBuffer.sol';

/**
 * @author ECHO
 */

contract SVGRenderer is ISVGRenderer {

    IAssets private immutable _ASSETS_CONTRACT;
    ITraits private immutable _TRAITS_CONTRACT;

    string[] internal suffixes = [
        " 1",
        " 2",
        " 3",
        " 4",
        " 5",
        " 6",
        " 7",
        " 8",
        " 9",
        " 10",
        " 11",
        " 12",
        " Left",
        " Right",
        " Black",
        " Brown",
        " Blonde",
        " Ginger",
        " Light",
        " Dark",
        " Shadow",
        " Fade",
        " Blue",
        " Green",
        " Orange",
        " Pink",
        " Purple",
        " Red",
        " Turquoise",
        " White",
        " Yellow",
        " Sky Blue",
        " Hot Pink",
        " Neon Blue",
        " Neon Green",
        " Neon Purple",
        " Neon Red",
        " Grey",
        " Navy",
        " Burgundy",
        " Beige",
        " Black Hat",
        " Brown Hat",
        " Blonde Hat",
        " Ginger Hat",
        " Blue Hat",
        " Green Hat",
        " Orange Hat",
        " Pink Hat",
        " Purple Hat",
        " Red Hat",
        " Turquoise Hat",
        " White Hat",
        " Yellow Hat"
    ];

    error BackgroundTraitsArrayIsEmpty(); 

    constructor(IAssets assetsContract, ITraits traitsContract) {
        _ASSETS_CONTRACT = assetsContract;
        _TRAITS_CONTRACT = traitsContract;
    }

    function renderSVG(uint16 tokenIdSeed, uint8 backgroundIndex, uint256 globalSeed) public view returns (string memory svg, string memory attributes) {
        bytes memory buffer = DynamicBuffer.allocate(20000);

        CachedTraitGroups memory cachedTraitGroups = TraitsLoader.initCachedTraitGroups(NUM_TRAIT_GROUPS);
        TraitsContext memory traits = _TRAITS_CONTRACT.generateTraitsContext(tokenIdSeed, backgroundIndex, globalSeed);

        _prepareCache(cachedTraitGroups, traits);

        if (_isPreRenderedSpecial(traits.specialId)) {
            return _renderPreRenderedSpecial(buffer, traits, cachedTraitGroups);
        }

        TraitsRenderer.renderGridToSvg(_ASSETS_CONTRACT, buffer, cachedTraitGroups, traits);

        attributes = _getTraitsAsJson(cachedTraitGroups, traits);
        svg = string(buffer);
    }

    function _prepareCache(CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal view {
        if (traits.specialId > 0) {
            // Special Tokens only need to load the Background and Special 1s groups
            cachedTraitGroups.traitGroups[uint(E_TraitsGroup.Background_Group)] = TraitsLoader.loadAndCacheTraitGroup(_ASSETS_CONTRACT, cachedTraitGroups, uint(E_TraitsGroup.Background_Group));
            cachedTraitGroups.traitGroups[uint(E_TraitsGroup.Special_1s_Group)] = TraitsLoader.loadAndCacheTraitGroup(_ASSETS_CONTRACT, cachedTraitGroups, uint(E_TraitsGroup.Special_1s_Group));
        } 
        else {
            // Background is loaded explicitly and captured in cache
            cachedTraitGroups.traitGroups[uint(E_TraitsGroup.Background_Group)] = TraitsLoader.loadAndCacheTraitGroup(_ASSETS_CONTRACT, cachedTraitGroups, uint(E_TraitsGroup.Background_Group));

            for (uint i = 0; i < traits.traitsToRenderLength; i++) {
                uint traitGroupIndex = uint8(traits.traitsToRender[i].traitGroup);

                // NEW: Assigning return value back to traitGroups array for persistence
                cachedTraitGroups.traitGroups[traitGroupIndex] = TraitsLoader.loadAndCacheTraitGroup(_ASSETS_CONTRACT, cachedTraitGroups, traitGroupIndex);

                if (traits.traitsToRender[i].hasFiller) {
                    uint fillerGroupIdx = uint8(traits.traitsToRender[i].filler.traitGroup);
                    cachedTraitGroups.traitGroups[fillerGroupIdx] = TraitsLoader.loadAndCacheTraitGroup(_ASSETS_CONTRACT, cachedTraitGroups, fillerGroupIdx);
                }
            }
        }
    }

    function _isPreRenderedSpecial(uint16 specialId) internal pure returns (bool) {
        if (specialId == 0) return false;
        
        uint idx = specialId - 1;

        return (idx < 7);
    }

    function _renderPreRenderedSpecial(bytes memory buffer, TraitsContext memory traits, CachedTraitGroups memory cachedTraitGroups) internal view returns (string memory svg, string memory attributes) {
        /* Pre-rendered Special 1s
        
            Predator_Blue  --> key 105
            Predator_Green --> key 106  
            Predator_Red   --> key 107
            Santa_Claus    --> key 108
            Shadow_Ninja   --> key 109
            The_Devil      --> key 112
            The_Portrait   --> key 114
        */
        bytes memory rawPngBytes = _ASSETS_CONTRACT.loadAssetOriginal(traits.specialId + 100);

        Utils.concat(buffer, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">');
        Utils.concat(buffer, '<style> img {image-rendering: pixelated; shape-rendering: crispEdges; image-rendering: -moz-crisp-edges;} </style>');
        Utils.concat(buffer, '<g id="GeneratedImage">');
        Utils.concat(buffer, '<foreignObject width="48" height="48">');
        Utils.concat(buffer, '<img xmlns="http://www.w3.org/1999/xhtml" src="data:image/png;base64,');
        Utils.concatBase64(buffer, rawPngBytes);
        Utils.concat(buffer, '" width="100%" height="100%"/></foreignObject></g></svg>');

        svg = string(buffer);

        uint16 specialIdx = traits.specialId - 1;
        string memory specialName = string(cachedTraitGroups.traitGroups[uint(E_TraitsGroup.Special_1s_Group)].traits[specialIdx].traitName);

        bytes memory attributesBuffer = DynamicBuffer.allocate(100);

        Utils.concat(attributesBuffer, '"attributes":[');
        Utils.concat(attributesBuffer, _stringTrait("Special 1s", specialName));
        Utils.concat(attributesBuffer, '],');

        attributes = string(attributesBuffer);
    }

    function _getTraitsAsJson(CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal view returns (string memory) {
        
        bytes memory buffer = DynamicBuffer.allocate(2500);
        Utils.concat(buffer, '"attributes":[');
        
        // Birthday attribute (Always added)
        Utils.concat(buffer, '{"display_type":"date","trait_type":"Birthday","value":');
        Utils.concat(buffer, bytes(Utils.toString(traits.birthday)));
        Utils.concat(buffer, '}');
        Utils.concat(buffer, ',');

        // Background attribute
        TraitGroup memory backgroundGroup = cachedTraitGroups.traitGroups[uint(E_TraitsGroup.Background_Group)];
        uint backgroundIdx = uint(traits.background);

        if (backgroundGroup.traits.length == 0) { 
            revert BackgroundTraitsArrayIsEmpty();
        }

        string memory backgroundName = string(backgroundGroup.traits[backgroundIdx].traitName);
        Utils.concat(buffer, _stringTrait("Background", backgroundName));

        // Special 1s Attribute
        if (traits.specialId > 0) {

            TraitGroup memory specialGroup = cachedTraitGroups.traitGroups[uint(E_TraitsGroup.Special_1s_Group)];
            uint specialIdx = traits.specialId - 1;

            if (specialIdx < specialGroup.traits.length) {
                string memory specialName = string(specialGroup.traits[specialIdx].traitName);
                Utils.concat(buffer, ',');
                Utils.concat(buffer, _stringTrait("Special 1s", specialName));
            }
        }

        // Normal Trait Attributes
        else {
            for (uint i = 0; i < traits.traitsToRenderLength; i++) {

                uint traitGroupIndex = uint(traits.traitsToRender[i].traitGroup);
                uint traitIndex = traits.traitsToRender[i].traitIndex;

                // Skip background attribute since its already added independently
                if (traitGroupIndex == uint(E_TraitsGroup.Background_Group)) continue;

                TraitGroup memory traitGroup = cachedTraitGroups.traitGroups[traitGroupIndex];
                
                // Safety check: Ensure the group was actually loaded and the index is not out of bounds
                if (traitGroup.traits.length > 0 && traitIndex < traitGroup.traits.length) {

                    TraitInfo memory traitInfo = traitGroup.traits[traitIndex];
                    Utils.concat(buffer, ',');

                    // Remove suffixes
                    string memory baseName = _getTraitBaseName(
                        E_TraitsGroup(traitGroup.traitGroupIndex),
                        string(traitInfo.traitName),
                        suffixes
                    );

                    Utils.concat(buffer, _stringTrait(string(traitGroup.traitGroupName), baseName));
                }
            }
        }

        Utils.concat(buffer, ']');
        return string(buffer);
    }

    function _stringTrait(string memory traitName, string memory traitValue) internal pure returns (bytes memory) {
        return bytes(string.concat(
            '{"trait_type":"',
            traitName,
            '","value":"',
            traitValue,
            '"}'
        ));
    }

    function _getTraitBaseName(E_TraitsGroup group, string memory traitName, string[] memory suffixesArray) internal pure returns (string memory) {
        
        if (
            group == E_TraitsGroup.Male_Headwear_Group ||
            group == E_TraitsGroup.Female_Headwear_Group ||
            group == E_TraitsGroup.Male_Hair_Group ||
            group == E_TraitsGroup.Female_Hair_Group ||
            group == E_TraitsGroup.Male_Hat_Hair_Group ||
            group == E_TraitsGroup.Female_Hat_Hair_Group ||
            group == E_TraitsGroup.Male_Eye_Wear_Group ||
            group == E_TraitsGroup.Female_Eye_Wear_Group ||
            group == E_TraitsGroup.Male_Facial_Hair_Group
        ) {
            return _removeSuffix(traitName, suffixesArray);
        }

        return traitName;
    }

    function _removeSuffix(string memory traitName, string[] memory suffixesArray) internal pure returns (string memory) {
        bytes memory traitNameBytes = bytes(traitName);

        for (uint256 suffixIndex = 0; suffixIndex < suffixesArray.length; suffixIndex++) {
            bytes memory currentSuffixBytes = bytes(suffixesArray[suffixIndex]);

            if (traitNameBytes.length > currentSuffixBytes.length) {
                bool suffixMatches = true;

                // Check if the ending of traitName matches the current suffix
                for (uint256 j = 0; j < currentSuffixBytes.length; j++) {
                    if (
                        traitNameBytes[traitNameBytes.length - currentSuffixBytes.length + j] !=
                        currentSuffixBytes[j]
                    ) {
                        suffixMatches = false;
                        break;
                    }
                }

                if (suffixMatches) {
                    // Slice off the suffix to create the base name
                    bytes memory baseNameBytes = new bytes(traitNameBytes.length - currentSuffixBytes.length);
                    for (uint256 i = 0; i < baseNameBytes.length; i++) {
                        baseNameBytes[i] = traitNameBytes[i];
                    }
                    return string(baseNameBytes);
                }
            }
        }

        return traitName;
    }
}