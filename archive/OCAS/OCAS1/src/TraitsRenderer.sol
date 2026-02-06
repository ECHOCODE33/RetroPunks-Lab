// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { TraitInfo2, TraitGroup, CachedTraitGroups, TraitsContext } from './TraitsContextStructs.sol';
import { E_TraitsGroup, E_Background, E_0_Special_1s } from './TraitContextGenerated.sol';
import { TraitsLoader } from './TraitsLoader.sol';
import { Utils } from './common/Utils.sol';
import { BitMap, PNG24x24 } from './common/PNG24x24.sol';

/**
 * @author EtoVass
 */

library TraitsRenderer {
    function renderRect(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, uint x, uint y, uint width, uint height, uint traitGroupIndex, uint paletteIndex) private pure {
        bytes memory palette = bytes(cachedTraitGroups.traitGroups[traitGroupIndex].palette[paletteIndex]);
        bytes memory xStr = bytes(Utils.toString(x));
        bytes memory yStr = bytes(Utils.toString(y));
        bytes memory widthStr = bytes(Utils.toString(width));
        bytes memory heightStr = bytes(Utils.toString(height));
        Utils.concat(buffer, '<rect x="', xStr, '" y="', yStr, '" width="', widthStr, '" height="', heightStr, '" fill="', palette, '" />');
    }

    function renderRect(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, bytes memory x, bytes memory y, bytes memory width, bytes memory height, uint traitGroupIndex, uint paletteIndex) private pure {
        bytes memory palette = bytes(cachedTraitGroups.traitGroups[traitGroupIndex].palette[paletteIndex]);
        Utils.concat(buffer, '<rect x="', x, '" y="', y, '" width="', width, '" height="', height, '" fill="', palette, '" />');
    }

    function renderTraitGroup(BitMap memory bitMap, CachedTraitGroups memory cachedTraitGroups, uint8 traitGroupIndex, uint8 traitIndex) internal pure {
        TraitGroup memory traitGroup = cachedTraitGroups.traitGroups[traitGroupIndex];
        TraitInfo2 memory trait = traitGroup.traits[traitIndex];

        uint index = 0;

        unchecked {
            for (uint x = trait.x1; x <= trait.x2; x++) {
                for (uint y = trait.y1; y <= trait.y2; y++) {             
                    uint32 rgba = cachedTraitGroups.traitGroups[traitGroupIndex].paletteRgba[trait.traitData[index]];
                    PNG24x24.renderPixelToBitMap(bitMap, x, y, rgba);  
                    index++;
                }
            }
        }
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
        Utils.concat(buffer, '<rect x="0" y="0" width="24" height="24" fill="url(#bg-gradient-', gradientId, ')" />');
    }

    function renderGridToSvg(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal pure {
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

        if (traits.specialId != 1 + uint(E_0_Special_1s.Blueprint)) {
            Utils.concat(buffer, '<g id="Background">');
            renderBackground(buffer, cachedTraitGroups, traits);
            Utils.concat(buffer, '</g>');
        }

        bool hasFillersForTheEnd = false;

        BitMap memory bitMap;

        for (uint i = 0; i < traits.traitsToRenderLength; i++) {
            if (traits.traitsToRender[i].traitGroup == E_TraitsGroup.E_Background_Group) {
                // it is handleded in the section above
                continue;
            }

            renderTraitGroup(bitMap, cachedTraitGroups, uint8(traits.traitsToRender[i].traitGroup), traits.traitsToRender[i].traitIndex);

            // special case for fillers than enhace some of the traits
            if (traits.traitsToRender[i].hasFiller) {
                if (traits.traitsToRender[i].fillerRenderedAtTheEnd) {
                    hasFillersForTheEnd = true;
                } else {
                    renderTraitGroup(bitMap, cachedTraitGroups, uint8(traits.traitsToRender[i].filler.traitGroup), traits.traitsToRender[i].filler.traitIndex);
                }
            }

            //Utils.concat(buffer, '</g>');
        }

        // special case for fillers than enhace some of the traits, rendered at the end
        if (hasFillersForTheEnd) {
            //Utils.concat(buffer, '<g id="Fillers">');
            for (uint i = 0; i < traits.traitsToRenderLength; i++) {
                if (traits.traitsToRender[i].hasFiller) {
                    if (traits.traitsToRender[i].fillerRenderedAtTheEnd) {
                        renderTraitGroup(bitMap, cachedTraitGroups, uint8(traits.traitsToRender[i].filler.traitGroup), traits.traitsToRender[i].filler.traitIndex);
                    }
                }
            }
            //Utils.concat(buffer, '</g>');
        }

        string memory urlEncodedPNG = PNG24x24.toURLEncodedPNG(bitMap);

        Utils.concat(buffer, '<g id="GeneratedImage">');

        Utils.concat(buffer, '<foreignObject width="24" height="24">');
        //Utils.concat(buffer, '<image image-rendering="pixelated" href="', bytes(urlEncodedPNG), '" width="100%" height="100%" />');
        Utils.concat(buffer, '<img xmlns="http://www.w3.org/1999/xhtml" src="', bytes(urlEncodedPNG), '" width="100%" height="100%">');
        Utils.concat(buffer, '</img>');
        Utils.concat(buffer, '</foreignObject>');
        
        // for (uint i = 0; i < 24; i++) {
        //     for (uint j = 0; j < 24; j++) {
        //         uint32 rgba = bitMap.pixels[i][j];
        //         Utils.concat(buffer, '<rect x="', bytes(Utils.toString(i)), '" y="', bytes(Utils.toString(j)), '" width="1" height="1" fill="#', bytes(LibString.toHexStringNoPrefix(rgba, 4)), '" />');    
        //     }
        // }
        
        Utils.concat(buffer, '</g>');

        Utils.concat(buffer, '</svg>');
    }
}