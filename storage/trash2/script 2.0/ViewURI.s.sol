// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import { RetroPunks } from "../src/RetroPunks.sol";

contract ViewURIScript is Script {
    function run() external view {
        address retroPunksAddress = 0x998abeb3E57409262aE5b751f60747921B33613E; // Replace
        RetroPunks retroPunks = RetroPunks(retroPunksAddress);

        uint256 tokenId = 3; // Example
        string memory uri = retroPunks.tokenURI(tokenId);
        console.log(uri); // View in console
    }
}