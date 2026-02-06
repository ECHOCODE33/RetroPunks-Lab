// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/RetroPunks.sol";

contract ViewTokenScript is Script {
    function run() external view {
        address retroPunksAddress = vm.envAddress("RETROPUNKS_ADDRESS");
        uint256 tokenId = vm.envUint("TOKEN_ID");
        
        RetroPunks retroPunks = RetroPunks(retroPunksAddress);
        
        string memory tokenURI = retroPunks.tokenURI(tokenId);
        console.log("Token URI for token", tokenId);
        console.log(tokenURI);
        
        // Save to file for viewing
        vm.writeFile(
            string(abi.encodePacked("token_", vm.toString(tokenId), ".json")),
            tokenURI
        );
        console.log("Saved to token_", vm.toString(tokenId), ".json");
    }
}