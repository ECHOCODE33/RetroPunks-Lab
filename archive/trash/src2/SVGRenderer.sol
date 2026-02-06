// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Utils } from './libraries/Utils.sol';
import { TraitsUtils } from './libraries/TraitsUtils.sol';
import { DynamicBuffer } from './libraries/DynamicBuffer.sol';
import { TraitsContext, CachedTraitGroups, TraitGroup, TraitInfo } from './common/Structs.sol';
import { NUM_TRAIT_GROUPS, E_Special_1s, E_TraitsGroup } from "./common/Enums.sol";
import { IAssets } from './interfaces/IAssets.sol';
import { TraitsLoader } from './libraries/TraitsLoader.sol';
import { ISVGRenderer } from './interfaces/ISVGRenderer.sol';
import { TraitsRenderer } from './libraries/TraitsRenderer.sol';
import { ITraits } from './interfaces/ITraits.sol';

/**
 * @title SVGRenderer
 * @notice Orchestrates trait generation and SVG/JSON output
 * @dev Optimized for gas efficiency with minimal allocations
 * 
 * @author ECHO
 */
contract SVGRenderer is ISVGRenderer {
    IAssets private immutable _ASSETS_CONTRACT;
    ITraits private immutable _TRAITS_CONTRACT;

    /// @notice Color suffix mapping for trait name processing
    string[] internal colorSuffixes = [
        " 1", " 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9", " 10",
        " 11", " 12", " Left", " Right", " Black", " Brown", " Blonde",
        " Ginger", " Light", " Dark", " Shadow", " Fade", " Blue", " Green",
        " Orange", " Pink", " Purple", " Red", " Turquoise", " White",
        " Yellow", " Sky Blue", " Hot Pink", " Neon Blue", " Neon Green",
        " Neon Purple", " Neon Red", " Grey", " Navy", " Burgundy", " Beige",
        " Black Hat", " Brown Hat", " Blonde Hat", " Ginger Hat", " Blue Hat",
        " Green Hat", " Orange Hat", " Pink Hat", " Purple Hat", " Red Hat",
        " Turquoise Hat", " White Hat", " Yellow Hat"
    ];

    constructor(IAssets assetsContract, ITraits traitsContract) {
        _ASSETS_CONTRACT = assetsContract;
        _TRAITS_CONTRACT = traitsContract;
    }
    
    /**
     * @notice Render complete SVG and traits JSON for a token
     * @param tokenIdSeed Deterministic seed for trait generation
     * @param backgroundIndex Background selection (0 to NUM_BACKGROUND-1)
     * @param globalSeed Global randomness seed
     * @return svg Complete SVG markup
     * @return traitsAsString JSON-formatted traits for metadata
     */
    function renderSVG(
        uint16 tokenIdSeed,
        uint16 backgroundIndex,
        uint256 globalSeed
    ) public view returns (string memory svg, string memory traitsAsString) {
        // Allocate buffer (adjust size based on typical output)
        bytes memory buffer = DynamicBuffer.allocate(20000);

        // Initialize trait cache
        CachedTraitGroups memory cachedTraitGroups = TraitsLoader.initCachedTraitGroups(NUM_TRAIT_GROUPS);
        
        // Generate all traits
        TraitsContext memory traits = _TRAITS_CONTRACT.generateAllTraits(
            tokenIdSeed,
            backgroundIndex,
            globalSeed
        );

        // Handle special 1:1 pre-rendered characters
        if (_isPreRenderedSpecial(traits.specialId)) {
            return _renderPreRenderedSpecial(buffer, traits, cachedTraitGroups);
        }
    
        // Standard rendering path
        _generateSvg(buffer, cachedTraitGroups, _ASSETS_CONTRACT, traits);
        traitsAsString = _getTraitsAsJson(cachedTraitGroups, traits);

        svg = string(buffer);
    }

    /**
     * @notice Render HTML wrapper (placeholder for future animation)
     * @param svgContent SVG markup to embed
     * @return html HTML document (currently empty)
     */
    function renderHTML(bytes memory svgContent) public pure returns (string memory html) {
        // Reserved for future animated HTML wrapper
        // Could embed interactive JavaScript, CSS animations, etc.
        html = "";
    }

    /**
     * @dev Check if special ID is pre-rendered
     */
    function _isPreRenderedSpecial(uint16 specialId) private pure returns (bool) {
        if (specialId == 0) return false;
        
        uint idx = specialId - 1;
        return (
            idx == uint(E_Special_1s.Predator_Blue) ||
            idx == uint(E_Special_1s.Predator_Green) ||
            idx == uint(E_Special_1s.Predator_Red) ||
            idx == uint(E_Special_1s.Santa_Claus) ||
            idx == uint(E_Special_1s.Shadow_Ninja) ||
            idx == uint(E_Special_1s.The_Devil) ||
            idx == uint(E_Special_1s.The_Portrait)
        );
    }

    /**
     * @dev Render pre-rendered special character
     */
    function _renderPreRenderedSpecial(
        bytes memory buffer,
        TraitsContext memory traits,
        CachedTraitGroups memory cachedTraitGroups
    ) private view returns (string memory svg, string memory traitsAsString) {
        // Load base64-encoded PNG from assets
        bytes memory bytesBase64 = _ASSETS_CONTRACT.loadAssetOriginal(traits.specialId + 100);

        // Build SVG wrapper
        Utils.concat(buffer, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">');
        Utils.concat(buffer, '<style>img{image-rendering:pixelated;}</style>');
        Utils.concat(buffer, '<g id="GeneratedImage">');
        Utils.concat(buffer, '<foreignObject width="48" height="48">');
        Utils.concat(buffer, '<img xmlns="http://www.w3.org/1999/xhtml" src="data:image/png;base64,');
        Utils.concatBase64(buffer, bytesBase64);
        Utils.concat(buffer, '" width="100%" height="100%"/></foreignObject></g></svg>');

        svg = string(buffer);
        traitsAsString = _getTraitsAsJson(cachedTraitGroups, traits);
    }

    /**
     * @dev Generate SVG by loading and rendering all traits
     */
    function _generateSvg(
        bytes memory buffer,
        CachedTraitGroups memory cachedTraitGroups,
        IAssets assetsContract,
        TraitsContext memory traits
    ) internal view {
        // Load and cache all required trait groups
        for (uint i = 0; i < traits.traitsToRenderLength; i++) {
            uint traitGroupIndex = uint(traits.traitsToRender[i].traitGroup);
            TraitsLoader.loadAndCacheTraitGroup(assetsContract, cachedTraitGroups, traitGroupIndex);

            // Load filler trait group if present
            if (traits.traitsToRender[i].hasFiller) {
                uint fillerTraitGroupIndex = uint8(traits.traitsToRender[i].filler.traitGroup);
                TraitsLoader.loadAndCacheTraitGroup(assetsContract, cachedTraitGroups, fillerTraitGroupIndex);
            }
        }

        // Render traits to SVG
        TraitsRenderer.renderGridToSvg(buffer, assetsContract, cachedTraitGroups, traits);
    }

    /**
     * @dev Generate JSON attributes from traits
     */
    function _getTraitsAsJson(
        CachedTraitGroups memory cachedTraitGroups,
        TraitsContext memory traits
    ) internal view returns (string memory) {
        bytes memory buffer = DynamicBuffer.allocate(2000);
        Utils.concat(buffer, '"attributes":[');

        // Birthday attribute
        Utils.concat(buffer, '{"display_type":"date","trait_type":"Birthday","value":');
        Utils.concat(buffer, bytes(Utils.toString(traits.birthday)));
        Utils.concat(buffer, '}');

        // Trait attributes
        for (uint i = 0; i < traits.traitsToRenderLength; i++) {
            uint traitGroupIndex = uint(traits.traitsToRender[i].traitGroup);
            uint traitIndex = traits.traitsToRender[i].traitIndex;

            // Skip background in attributes
            if (traitGroupIndex == uint(E_TraitsGroup.Background_Group)) {
                continue;
            }

            TraitGroup memory traitGroup = cachedTraitGroups.traitGroups[traitGroupIndex];
            TraitInfo memory traitInfo = traitGroup.traits[traitIndex];

            Utils.concat(buffer, ',');

            // Process trait name (remove color suffixes)
            string memory baseName = TraitsUtils.getBaseTraitValue(
                E_TraitsGroup(traitGroup.traitGroupIndex),
                string(traitInfo.traitName),
                colorSuffixes
            );

            Utils.concat(buffer, _stringTrait(string(traitGroup.traitGroupName), baseName));
        }

        Utils.concat(buffer, ']');
        return string(buffer);
    }

    /**
     * @dev Format a string trait as JSON
     */
    function _stringTrait(
        string memory traitName,
        string memory traitValue
    ) internal pure returns (bytes memory) {
        return bytes(string.concat(
            '{"trait_type":"',
            traitName,
            '","value":"',
            traitValue,
            '"}'
        ));
    }
}