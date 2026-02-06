// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { IAssets } from "./interfaces/IAssets.sol";
import { IMetaGen } from "./interfaces/IMetaGen.sol";
import { DynamicBuffer } from "./libraries/DynamicBuffer.sol";
import { Utils } from "./libraries/Utils.sol";

/**
 * @title PreviewMetaGen (Preview Metadata Generator)
 * @author ECHO
 * @notice Generates preview GIF & JSON attributes for unrevealed tokens in the RetroPunks collection
 * @dev Uses Assets contract to load pre-rendered GIF asset for gas efficiency
 */
contract PreviewMetaGen is IMetaGen {
    IAssets private immutable _ASSETS_CONTRACT;

    bytes private constant SVG_HEADER =
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><style> img {image-rendering: pixelated;} </style><foreignObject width="48" height="48"><img xmlns="http://www.w3.org/1999/xhtml" width="100%" height="100%" src="data:image/gif;base64,';
    bytes private constant SVG_FOOTER = '"/></foreignObject></svg>';

    constructor(IAssets assetsContract) {
        _ASSETS_CONTRACT = assetsContract;
    }

    function generateMetadata(uint16 tokenIdSeed, uint8 backgroundIndex, uint256 globalSeed) public view returns (string memory svg, string memory attributes) {
        attributes = '"attributes":[{"trait_type":"Status","value":"Unrevealed"}]';

        bytes memory gifContent = _ASSETS_CONTRACT.loadAsset(333, false);

        uint256 estimatedSize = (gifContent.length * 4 / 3) + SVG_HEADER.length + SVG_FOOTER.length + 32;

        bytes memory buffer = DynamicBuffer.allocate(estimatedSize);
        Utils.concat(buffer, SVG_HEADER);
        Utils.concatBase64(buffer, gifContent);
        Utils.concat(buffer, SVG_FOOTER);

        svg = string(buffer);
    }
}
