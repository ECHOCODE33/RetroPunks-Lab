// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { E_TraitsGroup, NUM_TRAIT_GROUPS } from "./global/Enums.sol";
import { CachedTraitGroups, TraitGroup, TraitsContext } from "./global/Structs.sol";
import { IAssets } from "./interfaces/IAssets.sol";
import { IMetaGen } from "./interfaces/IMetaGen.sol";
import { ITraits } from "./interfaces/ITraits.sol";
import { DynamicBuffer } from "./libraries/DynamicBuffer.sol";
import { TraitsLoader } from "./libraries/TraitsLoader.sol";
import { TraitsRenderer } from "./libraries/TraitsRenderer.sol";
import { Utils } from "./libraries/Utils.sol";

/**
 * @title MetaGen (Metadata Generator)
 * @author ECHO (echomatrix.eth)
 * @notice Generates rendered SVG & JSON attributes for the RetroPunks
 *         collection, optimized for gas efficiency.
 *
 *         Note: Before metadata is revealed, preview metadata is
 *         generated and used for all tokens
 *
 * @dev Uses TraitsLoader, TraitsRenderer, and PNGBuilder libraries to
 *      effectively load RLE data and generate base64 encoded SVGs.
 */
contract MetaGen is IMetaGen {
    IAssets private immutable ASSETS_CONTRACT;
    ITraits private immutable TRAITS_CONTRACT;

    bytes private constant PREVIEW_SVG_HEADER =
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><g id="GeneratedImage"><foreignObject width="48" height="48"><img xmlns="http://www.w3.org/1999/xhtml" width="100%" height="100%" style="image-rendering: pixelated" src="data:image/gif;base64,';
    bytes private constant MAIN_SVG_HEADER =
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><g id="GeneratedImage"><foreignObject width="48" height="48"><img xmlns="http://www.w3.org/1999/xhtml" width="100%" height="100%" style="image-rendering: pixelated" src="data:image/png;base64,';
    bytes private constant SVG_FOOTER = '"/></foreignObject></g></svg>';

    constructor(IAssets _assetsContract, ITraits _traitsContract) {
        ASSETS_CONTRACT = _assetsContract;
        TRAITS_CONTRACT = _traitsContract;
    }

    function generateMetadata(uint16 _tokenIdSeed, uint8 _backgroundIndex, uint256 _globalSeed, uint8 _revealMetadata)
        public
        view
        returns (string memory svg, string memory attributes)
    {
        bytes memory buffer = DynamicBuffer.allocate(18000);

        if (_revealMetadata == 0) {
            (svg, attributes) = _generatePreviewMetadata(buffer);
        } else {
            (svg, attributes) = _generateRevealedMetadata(_tokenIdSeed, _backgroundIndex, _globalSeed, buffer);
        }
    }

    function _generateRevealedMetadata(uint16 _tokenIdSeed, uint8 _backgroundIndex, uint256 _globalSeed, bytes memory _buffer)
        public
        view
        returns (string memory svg, string memory attributes)
    {
        TraitsContext memory traits = TRAITS_CONTRACT.generateTraitsContext(_tokenIdSeed, _backgroundIndex, _globalSeed);
        CachedTraitGroups memory cachedTraitGroups = TraitsLoader.initCachedTraitGroups(NUM_TRAIT_GROUPS);

        _prepareCache(cachedTraitGroups, traits);

        if (traits.specialId > 0 && traits.specialId <= 7) {
            return _renderPreRenderedSpecial(_buffer, traits, cachedTraitGroups);
        }

        TraitsRenderer.renderGridToSvg(ASSETS_CONTRACT, _buffer, cachedTraitGroups, traits);

        attributes = _getTraitsAsJson(cachedTraitGroups, traits);
        svg = string(_buffer);
    }

    function _generatePreviewMetadata(bytes memory _buffer) public view returns (string memory svg, string memory attributes) {
        bytes memory gifContent = ASSETS_CONTRACT.loadAsset(333, false);

        Utils.concat(_buffer, PREVIEW_SVG_HEADER);
        Utils.concatBase64(_buffer, gifContent);
        Utils.concat(_buffer, SVG_FOOTER);

        svg = string(_buffer);
        attributes = '"attributes":[{"trait_type":"Status","value":"Unrevealed"}]';
    }

    function _prepareCache(CachedTraitGroups memory _cachedTraitGroups, TraitsContext memory _traits) internal view {
        _cachedTraitGroups.traitGroups[uint256(E_TraitsGroup.Background_Group)] =
            TraitsLoader.loadAndCacheTraitGroup(ASSETS_CONTRACT, _cachedTraitGroups, uint256(E_TraitsGroup.Background_Group));

        if (_traits.specialId > 0) {
            // Rendered Special 1s
            _cachedTraitGroups.traitGroups[uint256(E_TraitsGroup.Special_1s_Group)] =
                TraitsLoader.loadAndCacheTraitGroup(ASSETS_CONTRACT, _cachedTraitGroups, uint256(E_TraitsGroup.Special_1s_Group));
        } else {
            // Normal NFT traits
            uint256 len = _traits.traitsToRenderLength;
            for (uint256 i = 0; i < len;) {
                uint256 traitGroupIndex = uint8(_traits.traitsToRender[i].traitGroup);

                _cachedTraitGroups.traitGroups[traitGroupIndex] = TraitsLoader.loadAndCacheTraitGroup(ASSETS_CONTRACT, _cachedTraitGroups, traitGroupIndex);

                if (_traits.traitsToRender[i].hasFiller) {
                    uint256 fillerGroupIdx = uint8(_traits.traitsToRender[i].filler.traitGroup);
                    _cachedTraitGroups.traitGroups[fillerGroupIdx] = TraitsLoader.loadAndCacheTraitGroup(ASSETS_CONTRACT, _cachedTraitGroups, fillerGroupIdx);
                }
                unchecked {
                    ++i;
                }
            }
        }
    }

    function _renderPreRenderedSpecial(bytes memory _buffer, TraitsContext memory _traits, CachedTraitGroups memory _cachedTraitGroups)
        internal
        view
        returns (string memory svg, string memory attributes)
    {
        bytes memory rawPngBytes = ASSETS_CONTRACT.loadAsset(_traits.specialId + 100, false);

        Utils.concat(_buffer, MAIN_SVG_HEADER);
        Utils.concatBase64(_buffer, rawPngBytes);
        Utils.concat(_buffer, SVG_FOOTER);

        svg = string(_buffer);

        uint16 specialIdx = _traits.specialId - 1;
        string memory specialName = string(_cachedTraitGroups.traitGroups[uint256(E_TraitsGroup.Special_1s_Group)].traits[specialIdx].traitName);

        bytes memory attributesBuffer = DynamicBuffer.allocate(500);
        Utils.concat(attributesBuffer, '"attributes":[');
        _stringTrait(attributesBuffer, "Special 1", specialName);
        Utils.concat(attributesBuffer, ',{"display_type":"date","trait_type":"birthday","value":');
        Utils.concat(attributesBuffer, bytes(Utils.toString(_traits.birthday)));
        Utils.concat(attributesBuffer, "}]");

        attributes = string(attributesBuffer);
    }

    function _getTraitsAsJson(CachedTraitGroups memory cachedTraitGroups, TraitsContext memory _traits) internal pure returns (string memory) {
        bytes memory buffer = DynamicBuffer.allocate(2500);
        Utils.concat(buffer, '"attributes":[');

        Utils.concat(buffer, '{"display_type":"date","trait_type":"birthday","value":');
        Utils.concat(buffer, bytes(Utils.toString(_traits.birthday)));
        Utils.concat(buffer, "}");

        if (_traits.specialId > 0) {
            TraitGroup memory spGroup = cachedTraitGroups.traitGroups[uint256(E_TraitsGroup.Special_1s_Group)];
            uint256 specialIdx = _traits.specialId - 1;
            if (specialIdx < spGroup.traits.length) {
                Utils.concat(buffer, ",");
                _stringTrait(buffer, "Special 1s", string(spGroup.traits[specialIdx].traitName));
            }
        } else {
            uint256 len = _traits.traitsToRenderLength;
            for (uint256 i = 1; i < len;) {
                TraitGroup memory group = cachedTraitGroups.traitGroups[uint256(_traits.traitsToRender[i].traitGroup)];
                uint256 traitIdx = _traits.traitsToRender[i].traitIndex;

                if (group.traits.length > 0 && traitIdx < group.traits.length) {
                    Utils.concat(buffer, ",");
                    _stringTrait(buffer, string(group.traitGroupName), string(group.traits[traitIdx].traitName));
                }
                unchecked {
                    ++i;
                }
            }
        }

        Utils.concat(buffer, "]");
        return string(buffer);
    }

    function _stringTrait(bytes memory _buffer, string memory _traitName, string memory _traitValue) internal pure {
        Utils.concat(_buffer, '{"trait_type":"');
        Utils.concat(_buffer, bytes(_traitName));
        Utils.concat(_buffer, '","value":"');
        Utils.concat(_buffer, bytes(_traitValue));
        Utils.concat(_buffer, '"}');
    }
}
