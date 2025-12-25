// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {RetroPunks} from "../src/RetroPunks.sol";

/**
 * @title RevealShufflerSeed
 * @notice Script to reveal the committed shuffler seed on your RetroPunks contract.
 *
 * Use this BEFORE minting starts (or at least before any tokens are minted that would use the shuffled order).
 * Revealing early ensures fairness — everyone can see the final shuffle order in advance.
 *
 * Requirements:
 * - You must be the owner of the RetroPunks contract (the deployer).
 * - You must know the original shuffler seed values used during deployment.
 *
 * From your original Deploy script:
 *   committedShufflerSeedHash = keccak256(abi.encodePacked(uint256(1112131415), uint256(1617181920)))
 * So the actual seed parts are:
 *   uint128 seed1 = 1112131415;
 *   uint128 seed2 = 1617181920;
 */
contract RevealShufflerSeed is Script {

    address constant retroPunksAddress = 0x9E545E3C0baAB3E08CdfD552C960A1050f373042;

    uint256 constant SHUFFLER_SEED_PART1 = 1112131415;
    uint256 constant SHUFFLER_SEED_PART2 = 1617181920;

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

        bytes32 committedHash = retroPunks.committedShufflerSeedHash();

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