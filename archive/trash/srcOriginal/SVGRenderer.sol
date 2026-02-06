// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Utils } from './libraries/Utils.sol';
import { TraitsUtils } from './libraries/TraitsUtils.sol';
import { DynamicBuffer } from './libraries/DynamicBuffer.sol';
import { TraitsContext, CachedTraitGroups, TraitGroup, TraitInfo } from './common/Structs.sol';
import { NUM_TRAIT_GROUPS, E_Special_1s, E_TraitsGroup } from "./common/Enums.sol";
import { IAssets } from './interfaces/IAssets.sol';
import { TraitsLoader } from './libraries/TraitsLoader.sol';
import { ISVGRenderer } from './interfaces/ISVGRenderer.sol';
import { TraitsRenderer } from './libraries/TraitsRenderer.sol';
import { ITraits } from './interfaces/ITraits.sol';


/// @author ECHO


contract SVGRenderer is ISVGRenderer {
    IAssets private _assetsContract;
    ITraits private _traitsContract;

    string[] internal colorSuffixes = [
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

    constructor(IAssets assetsContract, ITraits traitsContract) {
        _assetsContract = assetsContract;
        _traitsContract = traitsContract;
    }
    
    function renderSVG(uint16 tokenIdSeed, uint16 backgroundIndex, uint256 globalSeed) public view returns (string memory svg, string memory traitsAsString) {
        bytes memory buffer = DynamicBuffer.allocate(20000); // adjust this value accordingly to save some gas

        CachedTraitGroups memory cachedTraitGroups = TraitsLoader.initCachedTraitGroups(NUM_TRAIT_GROUPS);        
        TraitsContext memory traits = _traitsContract.generateAllTraits(tokenIdSeed, backgroundIndex, globalSeed);

        if (traits.specialId - 1 == uint(E_Special_1s.Predator_Blue) ||
            traits.specialId - 1 == uint(E_Special_1s.Predator_Green) ||
            traits.specialId - 1 == uint(E_Special_1s.Predator_Red) ||
            traits.specialId - 1 == uint(E_Special_1s.Santa_Claus) ||
            traits.specialId - 1 == uint(E_Special_1s.Shadow_Ninja) ||
            traits.specialId - 1 == uint(E_Special_1s.The_Devil) ||
            traits.specialId - 1 == uint(E_Special_1s.The_Portrait)
        ) {
            bytes memory bytesBase64 = _assetsContract.loadAssetOriginal(traits.specialId + 100);

            Utils.concat(
                buffer,
                '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">',
                '<style>img {image-rendering: pixelated;}</style>',
                '<g id="GeneratedImage">',
                '<foreignObject width="48" height="48"><img xmlns="http://www.w3.org/1999/xhtml" src="data:image/png;base64,'
            );

            Utils.concatBase64(buffer, bytesBase64);
            Utils.concat(buffer, '" width="100%" height="100%"></img></foreignObject></g></svg>');

            svg = string(buffer);
            traitsAsString = _getTraitsAsJson(cachedTraitGroups, traits);
            return (svg, traitsAsString);
        }
    
        _generateSvg(buffer, cachedTraitGroups, _assetsContract, traits);
        traitsAsString = _getTraitsAsJson(cachedTraitGroups, traits);
        //traitsAsString = '"attributes":[]';

        svg = string(buffer);
        //svg = '<svg></svg>';
    }

    function renderHTML(bytes memory svgContent) public pure returns (string memory html) {
        // bytes memory buffer = DynamicBuffer.allocate(25000); // adjust this value accordingly to save some gas

        // bytes memory part1 = _assetsContract.loadAssetDecompressed(11111111);
        // bytes memory part2 = _assetsContract.loadAssetDecompressed(22222222);

        // Utils.concat(buffer, part1);
        // Utils.concat(buffer, svgContent);
        // Utils.concat(buffer, part2);

        // html = string(buffer);

        html = "";
    }

    function _generateSvg(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, IAssets assetsContract, TraitsContext memory traits) internal view {
        
        // load and cache trait groups
        for (uint i = 0; i < traits.traitsToRenderLength; i++) {

            uint traitGroupIndex = uint(traits.traitsToRender[i].traitGroup);
            
            TraitsLoader.loadAndCacheTraitGroup(assetsContract, cachedTraitGroups, traitGroupIndex);

            if (traits.traitsToRender[i].hasFiller) {

                uint fillerTraitGroupIndex = uint8(traits.traitsToRender[i].filler.traitGroup);
                
                TraitsLoader.loadAndCacheTraitGroup(assetsContract, cachedTraitGroups, fillerTraitGroupIndex);
            }
        }

        TraitsRenderer.renderGridToSvg(buffer, assetsContract, cachedTraitGroups, traits);
    }

    function _getTraitsAsJson(CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal view returns (string memory) {
        bytes memory buffer = DynamicBuffer.allocate(2000);
        Utils.concat(buffer, '"attributes":[');

        Utils.concat(buffer, '{"display_type":"date","trait_type":"Birthday","value":');
        Utils.concat(buffer, bytes(Utils.toString(traits.birthday)));
        Utils.concat(buffer, '},');

        for (uint i = 0; i < traits.traitsToRenderLength; i++) {
            uint traitGroupIndex = uint(traits.traitsToRender[i].traitGroup);
            uint traitIndex = traits.traitsToRender[i].traitIndex;  

            if (traitGroupIndex == uint(E_TraitsGroup.Background_Group)) {
                // skip background in attributes for all
                continue;
            }

            TraitGroup memory traitGroup = cachedTraitGroups.traitGroups[traitGroupIndex];
            TraitInfo memory traitInfo = traitGroup.traits[traitIndex];

            if (i > 0) {
                Utils.concat(buffer, ',');
            }

            string memory baseName = TraitsUtils.getBaseTraitValue(
                E_TraitsGroup(traitGroup.traitGroupIndex),
                string(traitInfo.traitName),
                colorSuffixes
            );

            Utils.concat(buffer, _stringTrait(string(traitGroup.traitGroupName), baseName));
        }

        Utils.concat(buffer, ']');
        return string(buffer);
    }

    function _stringTrait(string memory traitName, string memory traitValue) internal pure returns (bytes memory) {
        return bytes(string.concat('{"trait_type":"', traitName,'","value":"',traitValue, '"}'));
    }

    function _uintTrait(string memory traitName, uint traitValue) internal pure returns (bytes memory) {
        return bytes(string.concat('{"trait_type":"', traitName,'","value":"', Utils.toString(traitValue), '"}'));
    }
}