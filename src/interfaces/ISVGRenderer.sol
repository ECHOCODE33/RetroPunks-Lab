// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { IAssets } from '../interfaces/IAssets.sol';

interface ISVGRenderer {
    function renderSVG(uint16 tokenIdSeed, uint8 backgroundIndex, uint256 globalSeed) external view returns (string memory svg, string memory attributes);
}