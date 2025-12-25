// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import {RetroPunks} from "../src/RetroPunks.sol";

contract RevealGlobalSeed is Script {
    function run(address retroPunksAddress) external {
        vm.startBroadcast();

        RetroPunks retroPunks = RetroPunks(retroPunksAddress);

        // Use the same seed/nonce as in deployment (adjust if needed)
        uint256 seed = 1234;
        uint256 nonce = 5678;

        retroPunks.revealGlobalSeed(seed, nonce);

        console2.log("Global seed revealed");

        vm.stopBroadcast();
    }
}