// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {RetroPunks} from "../src/RetroPunks.sol";

/**
 * @title Mint
 * @notice Simple and safe script to perform owner mints on RetroPunks.
 *
 * Use this as the contract owner to mint reserved NFTs (up to 10 total).
 * You can mint any quantity ≤ remaining ownerMintsRemaining in one transaction.
 *
 * Requirements:
 * - You must be the owner of the RetroPunks contract.
 * - ownerMintsRemaining must be ≥ quantity you request.
 * - Total supply + quantity must not exceed maxSupply.
 *
 * Mints directly to the address you specify (usually your wallet).
 */
contract Mint is Script {

    // ====================== CONFIGURATION ======================

    address constant retroPunksAddress = 0x0165878A594ca255338adfa4d48449f69242Eb8F;

    address constant recipient = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    uint256 constant QUANTITY = 4;

    // ====================== SCRIPT LOGIC ======================

    function run() external {
        RetroPunks retroPunks = RetroPunks(retroPunksAddress);

        // Fetch current state for clear logging
        uint256 remainingOwnerMints = retroPunks.ownerMintsRemaining();
        uint256 currentSupply = retroPunks.totalSupply();
        uint256 maxSupply = retroPunks.maxSupply();

        console.log("Preparing owner mint on RetroPunks:");
        console.log("Contract: %s", retroPunksAddress);
        console.log("Recipient: %s", recipient);
        console.log("Quantity requested: %s", QUANTITY);
        console.log("Owner mints remaining: %s", remainingOwnerMints);
        console.log("Current supply: %s / %s", currentSupply, maxSupply);
        console.log("----------------------------------------");

        // Safety checks
        require(QUANTITY > 0, "Quantity must be > 0");
        require(QUANTITY <= remainingOwnerMints, "Not enough owner mints remaining");
        require(currentSupply + QUANTITY <= maxSupply, "Would exceed max supply");

        vm.startBroadcast();

        retroPunks.ownerMint(recipient, QUANTITY);

        vm.stopBroadcast();

        console.log("SUCCESS: %s RetroPunk(s) minted to %s!", QUANTITY, recipient);
        console.log("New supply: %s / %s", currentSupply + QUANTITY, maxSupply);
        console.log("Owner mints remaining: %s", remainingOwnerMints - QUANTITY);
    }
}