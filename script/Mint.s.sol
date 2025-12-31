// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {RetroPunks} from "../src/RetroPunks.sol";


contract Mint is Script {

    // ====================== CONFIGURATION ======================

    address constant retroPunksAddress = 0x167B5eD0fda3e2AE51282695B250E55cBC60615D;

    address constant recipient = 0x6A5ebe005B8Ef3d8ACdA293EFE5CD956a46b2457;

    uint256 constant QUANTITY = 50;

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