// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { E_TraitsGroup, NUM_PRE_RENDERED_SPECIALS, NUM_TRAIT_GROUPS } from "./global/Enums.sol";
import { CachedTraitGroups, TraitGroup, TraitsContext } from "./global/Structs.sol";
import { IAssets } from "./interfaces/IAssets.sol";
import { IRenderer } from "./interfaces/IRenderer.sol";
import { ITraits } from "./interfaces/ITraits.sol";
import { DynamicBuffer } from "./libraries/DynamicBuffer.sol";
import { PathSVGRenderer } from "./libraries/PathSVGRenderer.sol";
import { TraitsLoader } from "./libraries/TraitsLoader.sol";
import { Utils } from "./libraries/Utils.sol";

/**
 * @title Renderer
 * @author ECHO (echomatrix.eth)
 * @notice Metadata rendering contract — generates SVG images and JSON attributes.
 * @dev Single external call from RetroPunks.tokenURI() to generateMetadata().
 *      Delegates trait generation to the external Traits contract via ITraits.
 *      Uses PathSVGRenderer for direct 2D RLE → SVG rect conversion (no bitmap, no PNG).
 */
contract Renderer is IRenderer {
    using Utils for *;

    IAssets private immutable ASSETS_CONTRACT;
    ITraits private immutable TRAITS_CONTRACT;

    // ──────── SVG constants ────────
    bytes private constant PREVIEW_SVG_HEADER = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><g id="GeneratedImage"><foreignObject width="48" height="48"><img xmlns="http://www.w3.org/1999/xhtml" width="100%" height="100%" style="image-rendering: pixelated" src="data:image/gif;base64,';
    bytes private constant MAIN_SVG_HEADER = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><g id="GeneratedImage"><foreignObject width="48" height="48"><img xmlns="http://www.w3.org/1999/xhtml" width="100%" height="100%" style="image-rendering: pixelated" src="data:image/png;base64,';
    bytes private constant SVG_FOOTER = '"/></foreignObject></g></svg>';

    constructor(IAssets _assetsContract, ITraits _traitsContract) {
        ASSETS_CONTRACT = _assetsContract;
        TRAITS_CONTRACT = _traitsContract;
    }

    // ══════════════════════════════════════════════════════════════════════════
    //                          EXTERNAL ENTRY POINT
    // ══════════════════════════════════════════════════════════════════════════

    function generateMetadata(uint16 _tokenIdSeed, uint8 _backgroundIndex, uint256 _globalSeed, uint8 _revealMetadata) external view returns (string memory svg, string memory attributes) {
        bytes memory buffer = DynamicBuffer.allocate(18000);

        if (_revealMetadata == 0) {
            return _generatePreviewMetadata(buffer);
        }

        return _generateRevealedMetadata(_tokenIdSeed, _backgroundIndex, _globalSeed, buffer);
    }

    // ══════════════════════════════════════════════════════════════════════════
    //                          METADATA GENERATION
    // ══════════════════════════════════════════════════════════════════════════

    function _generateRevealedMetadata(uint16 _tokenIdSeed, uint8 _backgroundIndex, uint256 _globalSeed, bytes memory _buffer) internal view returns (string memory svg, string memory attributes) {
        // Delegate trait generation to external Traits contract
        TraitsContext memory traits = TRAITS_CONTRACT.generateTraitsContext(_tokenIdSeed, _backgroundIndex, _globalSeed);

        // Fast path for pre-rendered specials (seeds 0-6) — skip all trait group loading
        if (traits.specialId > 0 && traits.specialId <= NUM_PRE_RENDERED_SPECIALS) {
            return _renderPreRenderedSpecial(_buffer, traits);
        }

        // Load required trait groups from SSTORE2
        CachedTraitGroups memory cachedTraitGroups = TraitsLoader.initCachedTraitGroups(NUM_TRAIT_GROUPS);
        _prepareCache(cachedTraitGroups, traits);

        // Render 2D RLE → SVG rects (no bitmap, no PNG)
        PathSVGRenderer.renderToSvg(ASSETS_CONTRACT, _buffer, cachedTraitGroups, traits);

        attributes = _getTraitsAsJson(cachedTraitGroups, traits);
        svg = string(_buffer);
    }

    function _generatePreviewMetadata(bytes memory _buffer) internal view returns (string memory svg, string memory attributes) {
        bytes memory gifContent = ASSETS_CONTRACT.loadAsset(333, false);

        _buffer.concat(PREVIEW_SVG_HEADER);
        _buffer.concatBase64(gifContent);
        _buffer.concat(SVG_FOOTER);

        svg = string(_buffer);
        attributes = '"attributes":[{"trait_type":"Status","value":"Unrevealed"}]';
    }

    function _renderPreRenderedSpecial(bytes memory _buffer, TraitsContext memory _traits) internal view returns (string memory svg, string memory attributes) {
        bytes memory rawPngBytes = ASSETS_CONTRACT.loadAsset(_traits.specialId + 100, false);

        _buffer.concat(MAIN_SVG_HEADER);
        _buffer.concatBase64(rawPngBytes);
        _buffer.concat(SVG_FOOTER);

        svg = string(_buffer);

        // Load Special_1s_Group to get the trait name from Assets (same as dynamic specials)
        CachedTraitGroups memory cachedTraitGroups = TraitsLoader.initCachedTraitGroups(NUM_TRAIT_GROUPS);
        cachedTraitGroups.traitGroups[uint256(E_TraitsGroup.Special_1s_Group)] = TraitsLoader.loadAndCacheTraitGroup(ASSETS_CONTRACT, cachedTraitGroups, uint256(E_TraitsGroup.Special_1s_Group));

        bytes memory attributesBuffer = DynamicBuffer.allocate(300);
        attributesBuffer.concat('"attributes":[{"display_type":"date","trait_type":"birthday","value":', bytes(_traits.birthday.toString()), "}");

        // Read special name from loaded trait group
        TraitGroup memory spGroup = cachedTraitGroups.traitGroups[uint256(E_TraitsGroup.Special_1s_Group)];
        uint256 specialIdx = _traits.specialId - 1;
        if (specialIdx < spGroup.traits.length) {
            attributesBuffer.concat(",");
            _stringTrait(attributesBuffer, "Special 1s", string(spGroup.traits[specialIdx].traitName));
        }

        attributesBuffer.concat("]");

        attributes = string(attributesBuffer);
    }

    // ══════════════════════════════════════════════════════════════════════════
    //                          CACHE PREPARATION
    // ══════════════════════════════════════════════════════════════════════════

    function _prepareCache(CachedTraitGroups memory _cachedTraitGroups, TraitsContext memory _traits) internal view {
        _cachedTraitGroups.traitGroups[uint256(E_TraitsGroup.Background_Group)] = TraitsLoader.loadAndCacheTraitGroup(ASSETS_CONTRACT, _cachedTraitGroups, uint256(E_TraitsGroup.Background_Group));

        if (_traits.specialId > 0) {
            _cachedTraitGroups.traitGroups[uint256(E_TraitsGroup.Special_1s_Group)] = TraitsLoader.loadAndCacheTraitGroup(ASSETS_CONTRACT, _cachedTraitGroups, uint256(E_TraitsGroup.Special_1s_Group));
        } else {
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

    // ══════════════════════════════════════════════════════════════════════════
    //                          JSON ATTRIBUTES
    // ══════════════════════════════════════════════════════════════════════════

    function _getTraitsAsJson(CachedTraitGroups memory _cachedTraitGroups, TraitsContext memory _traits) internal pure returns (string memory) {
        bytes memory buffer = DynamicBuffer.allocate(2500);
        buffer.concat('"attributes":[{"display_type":"date","trait_type":"birthday","value":', bytes(_traits.birthday.toString()), "}");

        if (_traits.specialId > 0) {
            TraitGroup memory spGroup = _cachedTraitGroups.traitGroups[uint256(E_TraitsGroup.Special_1s_Group)];
            uint256 specialIdx = _traits.specialId - 1;
            if (specialIdx < spGroup.traits.length) {
                buffer.concat(",");
                _stringTrait(buffer, "Special 1s", string(spGroup.traits[specialIdx].traitName));
            }
        } else {
            uint256 len = _traits.traitsToRenderLength;
            for (uint256 i = 1; i < len;) {
                TraitGroup memory group = _cachedTraitGroups.traitGroups[uint256(_traits.traitsToRender[i].traitGroup)];
                uint256 traitIdx = _traits.traitsToRender[i].traitIndex;

                if (group.traits.length > 0 && traitIdx < group.traits.length) {
                    buffer.concat(",");
                    _stringTrait(buffer, string(group.traitGroupName), string(group.traits[traitIdx].traitName));
                }
                unchecked {
                    ++i;
                }
            }
        }

        buffer.concat("]");
        return string(buffer);
    }

    function _stringTrait(bytes memory _buffer, string memory _traitName, string memory _traitValue) internal pure {
        _buffer.concat('{"trait_type":"', bytes(_traitName), '","value":"', bytes(_traitValue), '"}');
    }
}
