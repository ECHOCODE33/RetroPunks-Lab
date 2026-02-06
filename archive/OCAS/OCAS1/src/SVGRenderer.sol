// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { Utils } from './common/Utils.sol';
import { Random, RandomCtx } from './common/Random.sol';
import { DynamicBuffer } from './common/DynamicBuffer.sol';
import { TraitsContext, CachedTraitGroups, TraitGroup, TraitInfo2 } from './TraitsContextStructs.sol';
import { TraitsUtils } from './TraitsUtils.sol';
import "./TraitContextGenerated.sol";
import { IAssetsSSTORE2 } from './sstore2/IAssetsSSTORE2.sol';
import { TraitsLoader } from './TraitsLoader.sol';
import { ISVGRenderer } from './ISVGRenderer.sol';
import { TraitsRenderer } from './TraitsRenderer.sol';
import { ITraits } from './ITraits.sol';

/**
 * @author EtoVass
 */

contract SVGRenderer is ISVGRenderer {
    IAssetsSSTORE2 private _assetsSSTORE2;
    ITraits private _traitsContract;

    constructor(IAssetsSSTORE2 assetsSSTORE2, ITraits traitsContract) {
        _assetsSSTORE2 = assetsSSTORE2;
        _traitsContract = traitsContract;
    }   

    function renderSVG(uint tokenIdSeed, uint backgroundIndex, uint seed) public view returns (string memory svg, string memory traitsAsString) {
        bytes memory buffer = DynamicBuffer.allocate(20000); // adjust this value accordingly to save some gas

        CachedTraitGroups memory cachedTraitGroups = TraitsLoader.initCachedTraitGroups(NUM_TRAIT_GROUPS);        
        TraitsContext memory traits = _traitsContract.generateAllTraits(tokenIdSeed, backgroundIndex, seed);
    
        generateSvg(buffer, cachedTraitGroups, _assetsSSTORE2, traits);
        traitsAsString = getTraitsAsJson(cachedTraitGroups, traits);
        //traitsAsString = '"attributes":[]';

        svg = string(buffer);
        //svg = "<svg></svg>";
    }

    function renderHTML(bytes memory svgContent) public view returns (string memory html) {
        // bytes memory buffer = DynamicBuffer.allocate(30000); // adjust this value accordingly to save some gas

        // bytes memory part1 = _assetsSSTORE2.loadAsset(11111111, true);
        // bytes memory part2 = _assetsSSTORE2.loadAsset(22222222, true);

        // Utils.concat(buffer, part1);
        // Utils.concat(buffer, svgContent);
        // Utils.concat(buffer, part2);

        // html = string(buffer);

        // return empty html, so there is no animation ulr; May enable in the future when marketplease have 
        // better support for HTMLs
        html = "";
    }

    function stringTrait(string memory traitName, string memory traitValue) internal pure returns (bytes memory) {
        return bytes(string.concat('{"trait_type":"', traitName,'","value":"',traitValue, '"}'));
    }

    function uintTrait(string memory traitName, uint traitValue) internal pure returns (bytes memory) {
        return bytes(string.concat('{"trait_type":"', traitName,'","value":"', Utils.toString(traitValue), '"}'));
    }

    function generateSvg(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, IAssetsSSTORE2 assetsSSTORE2, TraitsContext memory traits) internal view {
        // load and cache trait groups
        for (uint i = 0; i < traits.traitsToRenderLength; i++) {
            uint traitGroupIndex = uint(traits.traitsToRender[i].traitGroup);
            
            TraitsLoader.loadAndCacheTraitGroup(assetsSSTORE2, cachedTraitGroups, traitGroupIndex);

            if (traits.traitsToRender[i].hasFiller) {
                uint fillerTraitGroupIndex = uint8(traits.traitsToRender[i].filler.traitGroup);
                TraitsLoader.loadAndCacheTraitGroup(assetsSSTORE2, cachedTraitGroups, fillerTraitGroupIndex);
            }
        }

        TraitsRenderer.renderGridToSvg(buffer, cachedTraitGroups, traits);
    }

    function getTraitsAsJson(CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal pure returns (string memory) {
        bytes memory buffer = DynamicBuffer.allocate(10000);
        Utils.concat(buffer, '"attributes":[');

        if (traits.isAngel) {
            Utils.concat(buffer, stringTrait("Angel", "yes"), ',');
        }

        if (traits.numTattoos > 0) {
            Utils.concat(buffer, uintTrait("Num Tattoos", traits.numTattoos), ',');
        }

        if (traits.numJewelry > 0) {
            Utils.concat(buffer, uintTrait("Num Jewellery", traits.numJewelry), ',');
        }
    
        for (uint i = 0; i < traits.traitsToRenderLength; i++) {
            uint traitGroupIndex = uint(traits.traitsToRender[i].traitGroup);
            uint traitIndex = traits.traitsToRender[i].traitIndex;  

            if (traitGroupIndex == uint(E_TraitsGroup.E_Background_Group)) {
                // skip background in attributes for all
                continue;
            }

            if (traitGroupIndex == uint(E_TraitsGroup.E_Mouth_Group)) {
                // skip mouth in attributes
                continue;
            }

            if (traitGroupIndex == uint(E_TraitsGroup.E_3b_Clothes_Group) && TraitsUtils.hasHoodie(traits)) {
                // skip clothes in attributes if there is hoodie and clothes
                continue;
            }


            TraitGroup memory traitGroup = cachedTraitGroups.traitGroups[traitGroupIndex];
            TraitInfo2 memory traitInfo = traitGroup.traits[traitIndex];

            if (i > 0) {
                Utils.concat(buffer, ',');
            }

            Utils.concat(buffer, stringTrait(string(traitGroup.traitGroupName), string(traitInfo.traitName)));
        }

        Utils.concat(buffer, ']');
        return string(buffer);
    }

}