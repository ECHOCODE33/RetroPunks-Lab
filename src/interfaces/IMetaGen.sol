// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

interface IMetaGen {
    function generateMetadata(uint16 tokenIdSeed, uint8 backgroundIndex, uint256 globalSeed, uint8 _revealCollection)
        external
        view
        returns (string memory svg, string memory attributes);
}
