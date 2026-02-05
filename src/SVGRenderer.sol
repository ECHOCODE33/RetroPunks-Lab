// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { E_TraitsGroup, NUM_TRAIT_GROUPS } from "./common/Enums.sol";
import { CachedTraitGroups, TraitGroup, TraitsContext } from "./common/Structs.sol";
import { IAssets } from "./interfaces/IAssets.sol";
import { ISVGRenderer } from "./interfaces/ISVGRenderer.sol";
import { ITraits } from "./interfaces/ITraits.sol";
import { DynamicBuffer } from "./libraries/DynamicBuffer.sol";
import { TraitsLoader } from "./libraries/TraitsLoader.sol";
import { TraitsRenderer } from "./libraries/TraitsRenderer.sol";
import { Utils } from "./libraries/Utils.sol";

/**
 * @title SVGRenderer
 * @author ECHO
 */
contract SVGRenderer is ISVGRenderer {
    IAssets private immutable _ASSETS_CONTRACT;
    ITraits private immutable _TRAITS_CONTRACT;

    error BackgroundTraitsArrayIsEmpty();

    bytes private constant SVG_HEADER =
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><style>img{image-rendering:pixelated;shape-rendering:crispEdges;image-rendering:-moz-crisp-edges;}</style><g id="GeneratedImage"><foreignObject width="48" height="48"><img xmlns="http://www.w3.org/1999/xhtml" src="data:image/png;base64,';
    bytes private constant SVG_FOOTER = '" width="100%" height="100%"/></foreignObject></g></svg>';

    constructor(IAssets assetsContract, ITraits traitsContract) {
        _ASSETS_CONTRACT = assetsContract;
        _TRAITS_CONTRACT = traitsContract;
    }

    function renderSVG(uint16 tokenIdSeed, uint8 backgroundIndex, uint256 globalSeed) public view returns (string memory svg, string memory attributes) {
        bytes memory buffer = DynamicBuffer.allocate(20000);

        TraitsContext memory traits = _TRAITS_CONTRACT.generateTraitsContext(tokenIdSeed, backgroundIndex, globalSeed);
        CachedTraitGroups memory cachedTraitGroups = TraitsLoader.initCachedTraitGroups(NUM_TRAIT_GROUPS);

        _prepareCache(cachedTraitGroups, traits);

        if (traits.specialId > 0 && traits.specialId <= 7) return _renderPreRenderedSpecial(buffer, traits, cachedTraitGroups);

        TraitsRenderer.renderGridToSvg(_ASSETS_CONTRACT, buffer, cachedTraitGroups, traits);

        attributes = _getTraitsAsJson(cachedTraitGroups, traits);
        svg = string(buffer);
    }

    function _prepareCache(CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal view {
        cachedTraitGroups.traitGroups[uint256(E_TraitsGroup.Background_Group)] =
            TraitsLoader.loadAndCacheTraitGroup(_ASSETS_CONTRACT, cachedTraitGroups, uint256(E_TraitsGroup.Background_Group));

        if (traits.specialId > 0) {
            // Rendered Special 1s
            cachedTraitGroups.traitGroups[uint256(E_TraitsGroup.Special_1s_Group)] =
                TraitsLoader.loadAndCacheTraitGroup(_ASSETS_CONTRACT, cachedTraitGroups, uint256(E_TraitsGroup.Special_1s_Group));
        } else {
            // Normal NFT traits
            uint256 len = traits.traitsToRenderLength;
            for (uint256 i = 0; i < len;) {
                uint256 traitGroupIndex = uint8(traits.traitsToRender[i].traitGroup);

                cachedTraitGroups.traitGroups[traitGroupIndex] = TraitsLoader.loadAndCacheTraitGroup(_ASSETS_CONTRACT, cachedTraitGroups, traitGroupIndex);

                if (traits.traitsToRender[i].hasFiller) {
                    uint256 fillerGroupIdx = uint8(traits.traitsToRender[i].filler.traitGroup);
                    cachedTraitGroups.traitGroups[fillerGroupIdx] = TraitsLoader.loadAndCacheTraitGroup(_ASSETS_CONTRACT, cachedTraitGroups, fillerGroupIdx);
                }
                unchecked {
                    ++i;
                }
            }
        }
    }

    function _renderPreRenderedSpecial(bytes memory buffer, TraitsContext memory traits, CachedTraitGroups memory cachedTraitGroups)
        internal
        view
        returns (string memory svg, string memory attributes)
    {
        bytes memory rawPngBytes = _ASSETS_CONTRACT.loadAsset(traits.specialId + 100, false);

        Utils.concat(buffer, SVG_HEADER);
        Utils.concatBase64(buffer, rawPngBytes);
        Utils.concat(buffer, SVG_FOOTER);

        svg = string(buffer);

        uint16 specialIdx = traits.specialId - 1;
        string memory specialName = string(cachedTraitGroups.traitGroups[uint256(E_TraitsGroup.Special_1s_Group)].traits[specialIdx].traitName);

        bytes memory attributesBuffer = DynamicBuffer.allocate(500);
        Utils.concat(attributesBuffer, '"attributes":[');
        Utils.concat(attributesBuffer, _stringTrait("Special 1", specialName));
        Utils.concat(attributesBuffer, "]");

        attributes = string(attributesBuffer);
    }

    function _getTraitsAsJson(CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal pure returns (string memory) {
        bytes memory buffer = DynamicBuffer.allocate(2500);
        Utils.concat(buffer, '"attributes":[');

        Utils.concat(buffer, '{"display_type":"date","trait_type":"Birthday","value":');
        Utils.concat(buffer, bytes(Utils.toString(traits.birthday)));
        Utils.concat(buffer, "},");

        TraitGroup memory bgGroup = cachedTraitGroups.traitGroups[uint256(E_TraitsGroup.Background_Group)];
        if (bgGroup.traits.length == 0) revert BackgroundTraitsArrayIsEmpty();

        Utils.concat(buffer, _stringTrait("Background", string(bgGroup.traits[uint256(traits.background)].traitName)));

        if (traits.specialId > 0) {
            TraitGroup memory spGroup = cachedTraitGroups.traitGroups[uint256(E_TraitsGroup.Special_1s_Group)];
            uint256 specialIdx = traits.specialId - 1;
            if (specialIdx < spGroup.traits.length) {
                Utils.concat(buffer, ",");
                Utils.concat(buffer, _stringTrait("Special 1s", string(spGroup.traits[specialIdx].traitName)));
            }
        } else {
            uint256 len = traits.traitsToRenderLength;
            for (uint256 i = 0; i < len;) {
                if (traits.traitsToRender[i].traitGroup == E_TraitsGroup.Background_Group) {
                    unchecked {
                        ++i;
                    }
                    continue;
                }
                TraitGroup memory group = cachedTraitGroups.traitGroups[uint256(traits.traitsToRender[i].traitGroup)];
                uint256 traitIdx = traits.traitsToRender[i].traitIndex;

                if (group.traits.length > 0 && traitIdx < group.traits.length) {
                    Utils.concat(buffer, ",");
                    Utils.concat(buffer, _stringTrait(string(group.traitGroupName), string(group.traits[traitIdx].traitName)));
                }
                unchecked {
                    ++i;
                }
            }
        }

        Utils.concat(buffer, "]");
        return string(buffer);
    }

    function _stringTrait(string memory traitName, string memory traitValue) internal pure returns (bytes memory) {
        return abi.encodePacked('{"trait_type":"', traitName, '","value":"', traitValue, '"}');
    }
}
