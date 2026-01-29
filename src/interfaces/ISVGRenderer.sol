// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

interface ISVGRenderer {
    function renderSVG(uint16 tokenIdSeed, uint8 backgroundIndex, uint256 globalSeed) external view returns (string memory svg, string memory attributes);
}
