// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import { RetroPunks } from "../src/RetroPunks.sol";

contract RevealShufflerScript is Script {
    function run() external {
        address retroPunksAddress = 0x998abeb3E57409262aE5b751f60747921B33613E; // Replace
        RetroPunks retroPunks = RetroPunks(retroPunksAddress);

        uint256 seed = 789; // Matches dummy committed
        uint256 nonce = 1011;

        vm.startBroadcast();
        retroPunks.revealShufflerSeed(seed, nonce);
        vm.stopBroadcast();
    }
}