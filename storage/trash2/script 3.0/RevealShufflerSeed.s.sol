// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import {RetroPunks} from "../src/RetroPunks.sol";

contract RevealShufflerSeed is Script {
    function run(address retroPunksAddress) external {
        vm.startBroadcast();

        RetroPunks retroPunks = RetroPunks(retroPunksAddress);

        // Use the same seed/nonce as in deployment (adjust if needed)
        uint256 seed = 9876;
        uint256 nonce = 5432;

        retroPunks.revealShufflerSeed(seed, nonce);

        console2.log("Shuffler seed revealed");

        vm.stopBroadcast();
    }
}