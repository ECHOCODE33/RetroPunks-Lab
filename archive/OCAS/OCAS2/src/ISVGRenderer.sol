// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @author EtoVass
 */

interface ISVGRenderer {
    function renderSVG(uint tokenIdSeed, uint backgroundIndex, uint seed) external view returns (string memory svg, string memory traitsAsString);
    function renderHTML(bytes memory svgContent) external view returns (string memory html);
}