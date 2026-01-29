// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {RetroPunks} from "../src/RetroPunks.sol";

contract ViewTokenURI is Script {
    // ====================== CONFIGURATION ======================

    // Your deployed RetroPunks contract address
    address constant retroPunksAddress = 0x5FC8d32690cc91D4c39d9d3abcBD16989F875707;

    // CHANGE THIS: Token ID you want to view
    uint256 constant TOKEN_ID = 2;

    // ====================== SCRIPT LOGIC ======================

    function run() external view {
        RetroPunks retroPunks = RetroPunks(retroPunksAddress);

        // Check if token exists
        address owner;
        try retroPunks.ownerOf(TOKEN_ID) returns (address _owner) {
            owner = _owner;
        } catch {
            console.log("ERROR: Token #%s has not been minted yet", TOKEN_ID);
            return;
        }

        console.log("RetroPunk #%s", TOKEN_ID);
        console.log("Owner: %s", owner);
        console.log("Contract: %s", retroPunksAddress);
        console.log("----------------------------------------");
        console.log("Fetching tokenURI...");

        string memory uri = retroPunks.tokenURI(TOKEN_ID);

        console.log("Full tokenURI:");
        console.log(uri);
        console.log("----------------------------------------");
        console.log("SUCCESS!");
    }
}
