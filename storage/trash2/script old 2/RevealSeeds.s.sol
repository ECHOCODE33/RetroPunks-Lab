// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import {RetroPunks} from "../src/RetroPunks.sol";

contract RevealSeeds is Script {
    function run() external {
        vm.startBroadcast();

        address retroAddr = vm.envAddress("RETRO_PUNKS_ADDRESS");
        RetroPunks retroPunks = RetroPunks(retroAddr);

        // These must match the values used in DeployAll.s.sol
        uint256 shufflerSeed = vm.envUint("SHUFFLER_SEED");
        uint256 shufflerNonce = vm.envUint("SHUFFLER_NONCE");

        console.log("=== REVEALING SHUFFLER SEED ===");
        
        // Reveal shuffler seed (MUST be done before minting)
        if (!retroPunks.shufflerSeedRevealed()) {
            console.log("Revealing shuffler seed:", shufflerSeed);
            retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
            console.log("Shuffler seed revealed successfully!");
        } else {
            console.log("Shuffler seed already revealed");
        }

        console.log("=== REVEAL COMPLETE ===");

        vm.stopBroadcast();
    }
}