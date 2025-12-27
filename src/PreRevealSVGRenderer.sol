// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { ISVGRenderer } from './interfaces/ISVGRenderer.sol';
import { CachedTraitGroups, TraitGroup } from './common/Structs.sol';
import { IAssets} from './interfaces/IAssets.sol';
import { Utils } from './libraries/Utils.sol';
import { DynamicBuffer } from './libraries/DynamicBuffer.sol';

/**
 * @author ECHO
 */

contract PreRevealSVGRenderer is ISVGRenderer {
    IAssets private immutable _ASSETS_CONTRACT;

    constructor(IAssets assetsContract) {
        _ASSETS_CONTRACT = assetsContract;
    } 

    function renderSVG(uint16 tokenIdSeed, uint8 backgroundIndex, uint256 globalSeed) public view returns (string memory svg, string memory attributes) {
        
        attributes = string.concat(
            '"attributes":[',
            '{"trait_type":"Type","value":"Pre-Reveal"},',
            '{"trait_type":"Token ID Seed","value":"', Utils.toString(tokenIdSeed), '"},',
            '{"trait_type":"Background Index","value":"', Utils.toString(backgroundIndex), '"},',
            "]"
        );

        bytes memory gifContent = _ASSETS_CONTRACT.loadAssetOriginal(33333333);
        bytes memory buffer = DynamicBuffer.allocate(10000);

        Utils.concat(buffer, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">');  
        Utils.concat(buffer, '<style> img {image-rendering: pixelated;} </style>');
        Utils.concat(buffer, '<foreignObject width="24" height="24"><img xmlns="http://www.w3.org/1999/xhtml" src="data:image/gif;base64,');
        Utils.concatBase64(buffer, gifContent);
        Utils.concat(buffer, '" width="100%" height="100%" /></foreignObject></svg>');

        svg = string(buffer);
    }
}