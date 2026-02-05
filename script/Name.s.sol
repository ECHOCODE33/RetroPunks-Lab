// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

// Define the interface to read the struct from the mapping directly
interface IRetroPunks {
    // The public mapping 'globalTokenMetadata' returns (uint16, uint8, string)
    function globalTokenMetadata(uint256 tokenId) external view returns (uint16 seed, uint8 bg, string memory name);
}

contract Name is Script {
    address constant RETRO_PUNKS_ADDRESS = 0x5FC8d32690cc91D4c39d9d3abcBD16989F875707;

    function run() external view {
        IRetroPunks retroPunks = IRetroPunks(RETRO_PUNKS_ADDRESS);

        console.log("Fetching names for tokens 1 to 350...");
        console.log("-------------------------------------");

        for (uint256 tokenId = 1; tokenId <= 350; tokenId++) {
            // We use try/catch so the script continues even if a specific token doesn't exist
            try retroPunks.globalTokenMetadata(tokenId) returns (uint16, uint8, string memory name) {
                console.log("Token #%s: %s", tokenId, name);
            } catch {
                console.log("Token #%s: [DOES NOT EXIST / REVERTED]", tokenId);
            }
        }
    }
}
