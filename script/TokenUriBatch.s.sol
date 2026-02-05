// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { RetroPunks } from "../src/RetroPunks.sol";
import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

contract TokenUriBatch is Script {
    // ====================== CONFIGURATION ======================

    // Your deployed RetroPunks contract address
    address retroPunksAddress = 0x41571C3bD1Bf9107282bcA1829f16b316d6F67bc;

    // CHANGE THIS: The highest Token ID you want to view
    uint256 constant MAX_TOKEN_ID_TO_VIEW = 15;

    // ====================== SCRIPT LOGIC ======================

    function run() external view {
        RetroPunks retroPunks = RetroPunks(retroPunksAddress);
        uint256 currentTotalSupply = retroPunks.totalSupply();

        console.log("--- RetroPunks Batch URI Fetcher ---");
        console.log("Contract: %s", retroPunksAddress);
        console.log("Current Total Supply: %s", currentTotalSupply);
        console.log("----------------------------------------");

        // Loop from 1 to the specified maximum
        for (uint256 i = 1; i <= MAX_TOKEN_ID_TO_VIEW; i++) {
            // Check if token exists to avoid script revert
            try retroPunks.ownerOf(i) returns (address owner) {
                string memory uri = retroPunks.tokenURI(i);

                console.log("RetroPunk #%s", i);
                console.log(uri);
                console.log("----------------------------------------");
                console.log("");
            } catch {
                console.log("RetroPunk #%s: [Not Minted Yet]", i);
                console.log("----------------------------------------");
            }
        }

        console.log("DONE!");
    }
}
