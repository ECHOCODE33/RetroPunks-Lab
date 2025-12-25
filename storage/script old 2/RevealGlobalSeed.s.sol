// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import {RetroPunks} from "../src/RetroPunks.sol";

contract RevealGlobalSeed is Script {
    function run() external {
        vm.startBroadcast();

        address retroAddr = vm.envAddress("RETRO_PUNKS_ADDRESS");
        RetroPunks retroPunks = RetroPunks(retroAddr);

        // These must match the values used in DeployAll.s.sol
        uint256 globalSeed = vm.envUint("GLOBAL_SEED");
        uint256 globalNonce = vm.envUint("GLOBAL_NONCE");

        console.log("=== REVEALING GLOBAL SEED ===");
        console.log("This should be done AFTER minting is complete");
        
        // Reveal global seed
        if (!retroPunks.globalSeedRevealed()) {
            console.log("Revealing global seed:", globalSeed);
            retroPunks.revealGlobalSeed(globalSeed, globalNonce);
            console.log("Global seed revealed successfully!");
            console.log("\nAll token metadata is now available!");
        } else {
            console.log("Global seed already revealed");
        }

        console.log("=== GLOBAL SEED REVEAL COMPLETE ===");

        vm.stopBroadcast();
    }
}