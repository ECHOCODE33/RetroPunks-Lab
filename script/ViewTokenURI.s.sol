// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {RetroPunks} from "../src/RetroPunks.sol";

/**
 * @title ViewTokenURI (Simple & Correct)
 * @notice Super-simple view-only script to fetch and print the full tokenURI.
 *
 * Your RetroPunks contract already returns the complete base64-encoded data URI
 * from tokenURI() — no need for manual decoding in the script.
 *
 * This version just:
 * - Calls tokenURI(tokenId)
 * - Prints the entire string
 *
 * You can then:
 *   • Paste it directly into any browser → instantly see your NFT
 *   • Copy it for OpenSea/Zora/etc. metadata testing
 *
 * No Base64 decoding, no substring math → zero chance of overflow/panic.
 */
contract ViewTokenURI is Script {

    // ====================== CONFIGURATION ======================

    // Your deployed RetroPunks contract address
    address constant retroPunksAddress = 0x9E545E3C0baAB3E08CdfD552C960A1050f373042;

    // CHANGE THIS: Token ID you want to view
    uint256 constant TOKEN_ID = 1;

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