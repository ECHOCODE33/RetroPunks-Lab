// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import {RetroPunks} from "../src/RetroPunks.sol";

contract GetTokenURI is Script {
    function run(address retroPunksAddress, uint256 tokenId) external view {
        RetroPunks retroPunks = RetroPunks(retroPunksAddress);

        string memory uri = retroPunks.tokenURI(tokenId);

        console2.log("TokenURI for tokenId", tokenId, ":");
        console2.log(uri);
    }
}