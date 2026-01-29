// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import {ISVGRenderer} from "./interfaces/ISVGRenderer.sol";
import {IAssets} from "./interfaces/IAssets.sol";
import {TraitGroup} from "./common/Structs.sol";
import {Utils} from "./libraries/Utils.sol";
import {DynamicBuffer} from "./libraries/DynamicBuffer.sol";

/**
 * @author ECHO
 */
contract PreRevealSVGRenderer is ISVGRenderer {
    IAssets private immutable _ASSETS_CONTRACT;

    bytes private constant SVG_HEADER = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><style>img{image-rendering:pixelated;image-rendering:crisp-edges;image-rendering:-moz-crisp-edges;}</style><foreignObject width="48" height="48"><img xmlns="http://www.w3.org/1999/xhtml" src="data:image/gif;base64,';
    bytes private constant SVG_FOOTER = '" width="100%" height="100%"/></foreignObject></svg>';

    constructor(IAssets assetsContract) {
        _ASSETS_CONTRACT = assetsContract;
    }

    function renderSVG(uint16 tokenIdSeed, uint8 backgroundIndex, uint256 globalSeed) public view returns (string memory svg, string memory attributes) {
        attributes = string.concat('"attributes":[{"trait_type":"Type","value":"Pre-Reveal"},{"trait_type":"Token ID Seed","value":"', Utils.toString(tokenIdSeed), '"},{"trait_type":"Background Index","value":"', Utils.toString(backgroundIndex), '"}]');

        bytes memory gifContent = _ASSETS_CONTRACT.loadAsset(333, false);

        uint256 estimatedSize = (gifContent.length * 4 / 3) + SVG_HEADER.length + SVG_FOOTER.length + 32;

        bytes memory buffer = DynamicBuffer.allocate(estimatedSize);

        Utils.concat(buffer, SVG_HEADER);
        Utils.concatBase64(buffer, gifContent);
        Utils.concat(buffer, SVG_FOOTER);

        svg = string(buffer);
    }
}
