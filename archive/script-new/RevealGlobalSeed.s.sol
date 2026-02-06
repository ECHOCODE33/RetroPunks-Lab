// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { RetroPunks } from "../src/RetroPunks.sol";
import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

contract RevealGlobalSeed is Script {
    address retroPunksAddress = vm.envAddress("RETROPUNKS");

    // Replace these with your actual committed Global Seed and Nonce
    uint256 constant GLOBAL_SEED = 9836428957; // Your seed value
    uint256 constant GLOBAL_NONCE = 2829003893; // Your nonce value

    // ====================== SCRIPT LOGIC ======================

    function run() external {
        RetroPunks retroPunks = RetroPunks(retroPunksAddress);

        console.log("Preparing to reveal global seed on RetroPunks contract:");
        console.logAddress(retroPunksAddress);
        console.log("Global Seed: %s", uint256(GLOBAL_SEED));
        console.log("Global Nonce: %s", uint256(GLOBAL_NONCE));
        console.log("----------------------------------------");

        // Verification step: Check if the provided seed/nonce match the on-chain commitment
        bytes32 expectedHash = keccak256(abi.encodePacked(uint256(GLOBAL_SEED), uint256(GLOBAL_NONCE)));
        bytes32 committedHash = retroPunks.COMMITTED_GLOBAL_SEED_HASH();

        console.log("Committed hash on-chain: %s", vm.toString(committedHash));
        console.log("Calculated hash from values: %s", vm.toString(expectedHash));

        if (expectedHash != committedHash) {
            console.log("WARNING: Hash mismatch! Are you using the correct seed/nonce?");
            revert("Hashes do not match, check your seed/nonce constants");
        } else {
            console.log("Hash matches, ready to reveal!");
        }

        vm.startBroadcast();

        // Reveals the seed used for individual trait generation
        retroPunks.revealGlobalSeed(GLOBAL_SEED, GLOBAL_NONCE);

        console.log("Global seed successfully revealed!");
        console.log("Traits are now mathematically determined based on this seed.");

        vm.stopBroadcast();
    }
}
