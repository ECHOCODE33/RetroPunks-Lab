// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { ISVGRenderer } from './ISVGRenderer.sol';
import { IAssetsSSTORE2 } from './sstore2/IAssetsSSTORE2.sol';
import { Utils } from './common/Utils.sol';
import { DynamicBuffer } from './common/DynamicBuffer.sol';
import { TraitsLoader, CachedTraitGroups } from './TraitsLoader.sol';
import { NUM_TRAIT_GROUPS } from './Traits.sol';
import { E_TraitsGroup } from './Traits.sol';
import { TraitGroup, TraitInfo2 } from './Traits.sol';
import { TraitsContext } from './Traits.sol';
import { TraitToRender } from './Traits.sol';
import { E_Background } from './Traits.sol';


/**
 * @author EtoVass
 */

contract PreRevealSVGRenderer is ISVGRenderer {
    IAssetsSSTORE2 private _assetsSSTORE2;

    constructor(IAssetsSSTORE2 assetsSSTORE2) {
        _assetsSSTORE2 = assetsSSTORE2;
    }   

    function stringTrait(string memory traitName, string memory traitValue) internal pure returns (string memory) {
        return string.concat('{"trait_type":"', traitName,'","value":"',traitValue, '"}');
    }

    function uintTrait(string memory traitName, uint traitValue) internal pure returns (string memory) {
        return stringTrait(traitName, Utils.toString(traitValue));
    }

function renderBackground(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) private pure {
        uint traitGroupIndex = uint8(E_TraitsGroup.E_Background_Group);
        TraitGroup memory traitGroup = cachedTraitGroups.traitGroups[traitGroupIndex];
        TraitInfo2 memory trait = traitGroup.traits[uint8(traits.background)];

        uint traitDataLength = trait.traitData.length;

        // Add gradient definition with unique ID
        bytes memory gradientId = bytes(Utils.toString(uint(traits.background)));
        Utils.concat(buffer, '<defs><linearGradient id="bg-gradient-', gradientId, '" x1="0" y1="0" x2="0" y2="1">');
        
        if (traitDataLength == 1) {
            // Single color case - still need a gradient with single stop
            bytes memory palette = bytes(cachedTraitGroups.traitGroups[traitGroupIndex].palette[trait.traitData[0]]);
            Utils.concat(buffer, '<stop offset="0%" stop-color="', palette, '" />');
            Utils.concat(buffer, '<stop offset="100%" stop-color="', palette, '" />');
        } else if (traitDataLength == 24) {
            // 24 colors case - evenly distribute stops
            for (uint i = 0; i < 24; i++) {
                bytes memory palette = bytes(cachedTraitGroups.traitGroups[traitGroupIndex].palette[trait.traitData[i]]);
                bytes memory offsetStart = bytes(Utils.toString((i * 100) / 23)); // Calculate percentage (0% to 100%)
                Utils.concat(buffer, '<stop offset="', offsetStart, '%" stop-color="', palette, '" />');
            }
        } else {
            // Variable number of stops
            for (uint i = 0; i < traitDataLength; i++) {
                bytes memory palette = bytes(cachedTraitGroups.traitGroups[traitGroupIndex].palette[trait.traitData[i]]);
                bytes memory offsetPercent = bytes(Utils.toString((i * 100) / (traitDataLength - 1))); // Calculate percentage
                Utils.concat(buffer, '<stop offset="', offsetPercent, '%" stop-color="', palette, '" />');
            }
        }
        
        Utils.concat(buffer, '</linearGradient></defs>');
        
        // Render single rectangle with gradient fill
        Utils.concat(buffer, '<rect x="0" y="0" width="32" height="32" fill="url(#bg-gradient-', gradientId, ')" />');
    }


    function renderSVG(uint tokenId, uint backgroundIndex, uint seed) public view returns (string memory svg, string memory traitsAsString) {
        CachedTraitGroups memory cachedTraitGroups = TraitsLoader.initCachedTraitGroups(NUM_TRAIT_GROUPS);        
        
        traitsAsString = string.concat('"attributes":[', 
            stringTrait("Type", "Pre-Reveal"), ',',
            uintTrait("token id seed", tokenId), ',',
            uintTrait("seed", seed), ',',
            uintTrait("background index", backgroundIndex),
        "]");

        bytes memory buffer = DynamicBuffer.allocate(20000);

        Utils.concat(buffer, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">');  

        Utils.concat(buffer, '<style> img {width: 100%; height: 100%; ');
        Utils.concat(buffer, ' image-rendering: optimizeSpeed;');
        Utils.concat(buffer, ' image-rendering: -moz-crisp-edges;');
        Utils.concat(buffer, ' image-rendering: -o-crisp-edges;');
        Utils.concat(buffer, ' image-rendering: -webkit-optimize-contrast;');
        Utils.concat(buffer, ' image-rendering: optimize-contrast;');
        Utils.concat(buffer, ' image-rendering: crisp-edges;');
        Utils.concat(buffer, ' image-rendering: pixelated;');
        Utils.concat(buffer, ' -ms-interpolation-mode: nearest-neighbor;');
        Utils.concat(buffer, '} </style>');

        bytes memory gifContent = _assetsSSTORE2.loadAsset(33333333, false);

        Utils.concat(buffer, '<g id="Background">');
        TraitsContext memory traits;
        traits.background = E_Background(backgroundIndex);


        TraitsLoader.loadAndCacheTraitGroup(_assetsSSTORE2, cachedTraitGroups, uint8(E_TraitsGroup.E_Background_Group));
        renderBackground(buffer, cachedTraitGroups, traits);
        Utils.concat(buffer, '</g>');

        Utils.concat(buffer, '<foreignObject x="4" y="4" width="16" height="16">');
        Utils.concat(buffer, '<img xmlns="http://www.w3.org/1999/xhtml" src="data:image/gif;base64,');
        Utils.concatBase64(buffer, gifContent);
        Utils.concat(buffer, '" width="100%" height="100%" />');
        Utils.concat(buffer, '</foreignObject>');

        Utils.concat(buffer, '</svg>');

        svg = string(buffer);
    }

    function renderHTML(bytes memory svgContent) public view returns (string memory html) {
        bytes memory buffer = DynamicBuffer.allocate(30000); // adjust this value accordingly to save some gas

        bytes memory part1 = _assetsSSTORE2.loadAsset(11111111, true);
        bytes memory part2 = _assetsSSTORE2.loadAsset(22222222, true);

        Utils.concat(buffer, part1);
        Utils.concat(buffer, svgContent);
        Utils.concat(buffer, part2);

        html = string(buffer);
    }
}