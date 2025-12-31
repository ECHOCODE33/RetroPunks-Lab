// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import {RetroPunks, TokenMetadata} from "../src/RetroPunks.sol";

contract MintAndTest is Script {
    function run() external {
        vm.startBroadcast();

        address retroAddr = vm.envAddress("RETRO_PUNKS_ADDRESS");
        RetroPunks retroPunks = RetroPunks(retroAddr);

        console.log("=== MINTING TOKENS ===");
        console.log("RetroPunks address:", retroAddr);
        console.log("Owner:", retroPunks.owner());
        console.log("Shuffler seed revealed:", retroPunks.shufflerSeedRevealed());
        console.log("Global seed revealed:", retroPunks.globalSeedRevealed());

        // Check if shuffler seed is revealed (required for minting)
        require(retroPunks.shufflerSeedRevealed(), "Shuffler seed must be revealed before minting!");

        // Mint tokens
        uint256 quantityToMint = 5;
        console.log("\nMinting", quantityToMint, "tokens to", msg.sender);
        
        retroPunks.ownerMint(msg.sender, quantityToMint);
        
        console.log("Successfully minted", quantityToMint, "tokens!");
        console.log("Total supply:", retroPunks.totalSupply());

        // Test metadata (only works after global seed reveal)
        if (retroPunks.globalSeedRevealed()) {
            console.log("\n=== TESTING TOKEN METADATA ===");
            
            for (uint i = 1; i <= quantityToMint; i++) {
                console.log("\n--- Token #", i, " ---");
                
                // CORRECTED LINE: Uppercase 'RetroPunks' defines the type
                TokenMetadata memory metadata = retroPunks.getTokenMetadata(i);
                
                console.log("Token ID Seed:", metadata.tokenIdSeed);
                console.log("Background Index:", metadata.backgroundIndex);
                console.log("Name:", metadata.name);
                
                // Get token URI
                string memory uri = retroPunks.tokenURI(i);
                console.log("Token URI length:", bytes(uri).length);
                
                if (bytes(uri).length > 200) {
                    console.log("Token URI preview (first 200 chars):");
                    console.log(_substring(uri, 0, 200));
                    console.log("...");
                } else {
                    console.log("Token URI:", uri);
                }
            }
        } else {
            console.log("\n=== METADATA NOT AVAILABLE YET ===");
            console.log("Global seed must be revealed to view token metadata");
            console.log("Run RevealGlobalSeed.s.sol after minting is complete");
        }

        console.log("\n=== MINT AND TEST COMPLETE ===");

        vm.stopBroadcast();
    }

    function _substring(string memory str, uint startIndex, uint endIndex) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        for (uint i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        return string(result);
    }
}