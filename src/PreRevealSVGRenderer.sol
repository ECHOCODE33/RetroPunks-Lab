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

    function renderSVG(uint16 tokenIdSeed, uint16 backgroundIndex, uint256 globalSeed) public view returns (string memory svg, string memory attributes) {
        
        attributes = string.concat('"attributes":[', 
            _stringTrait("Type", "Pre-Reveal"), ',',
            _uintTrait("Token ID Seed", tokenIdSeed), ',',
            _uintTrait("Background Index", backgroundIndex),
        "]");

        bytes memory gifContent = _ASSETS_CONTRACT.loadAssetOriginal(33333333);
        bytes memory buffer = DynamicBuffer.allocate(15000);

        Utils.concat(buffer, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">');  
        Utils.concat(buffer, '<style> img {image-rendering: pixelated;} </style>');
        Utils.concat(buffer, '<foreignObject width="24" height="24"><img xmlns="http://www.w3.org/1999/xhtml" src="data:image/gif;base64,');
        Utils.concatBase64(buffer, gifContent);
        Utils.concat(buffer, '" width="100%" height="100%" /></foreignObject></svg>');

        svg = string(buffer);
    }

    function renderHTML(bytes memory svgContent) public view returns (string memory html) {
        bytes memory buffer = DynamicBuffer.allocate(35000); // adjust this value accordingly to save some gas

        bytes memory part1 = _ASSETS_CONTRACT.loadAssetDecompressed(11111111);
        bytes memory part2 = _ASSETS_CONTRACT.loadAssetDecompressed(22222222);

        Utils.concat(buffer, part1);
        Utils.concat(buffer, svgContent);
        Utils.concat(buffer, part2);

        html = string(buffer);
    }

    function _stringTrait(string memory traitName, string memory traitValue) internal pure returns (string memory) {
        return string.concat('{"trait_type":"', traitName,'","value":"',traitValue, '"}');
    }

    function _uintTrait(string memory traitName, uint traitValue) internal pure returns (string memory) {
        return _stringTrait(traitName, Utils.toString(traitValue));
    }
}