// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {RetroPunks} from "../src/RetroPunks.sol";


contract RevealShufflerSeed is Script {

    address constant retroPunksAddress = 0x7A7741eBfAD78ce204395ba1dd0B516b40e79102;

    uint256 constant SHUFFLER_SEED_PART1 = 7393514293;
    uint256 constant SHUFFLER_SEED_PART2 = 3904021486;

    // ====================== SCRIPT LOGIC ======================

    function run() external {
        RetroPunks retroPunks = RetroPunks(retroPunksAddress);

        console.log("Preparing to reveal shuffler seed on RetroPunks contract:");
        console.logAddress(retroPunksAddress);
        console.log("Seed Part 1: %s", uint256(SHUFFLER_SEED_PART1));
        console.log("Seed Part 2: %s", uint256(SHUFFLER_SEED_PART2));
        console.log("----------------------------------------");

        bytes32 expectedHash = keccak256(
            abi.encodePacked(uint256(SHUFFLER_SEED_PART1), uint256(SHUFFLER_SEED_PART2))
        );

        bytes32 committedHash = retroPunks.COMMITTED_SHUFFLER_SEED_HASH();

        console.log("Committed hash on-chain: %s", vm.toString(committedHash));
        console.log("Calculated hash from seeds: %s", vm.toString(expectedHash));

        if (expectedHash != committedHash) {
            console.log("WARNING: Hash mismatch! Are you using the correct seed values?");
            revert("Hashes do not match, check your seed constants");
        } else {
            console.log("Hash matches, ready to reveal!");
        }

        vm.startBroadcast();

        retroPunks.revealShufflerSeed(SHUFFLER_SEED_PART1, SHUFFLER_SEED_PART2);

        console.log("Shuffler seed successfully revealed!");
        console.log("Transaction sent, shuffle order is now fixed and public.");

        vm.stopBroadcast();
    }
}