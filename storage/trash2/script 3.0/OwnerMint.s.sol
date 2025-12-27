// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import {RetroPunks} from "../src/RetroPunks.sol";

contract OwnerMint is Script {
    function run(address retroPunksAddress, address to) external {
        vm.startBroadcast();

        RetroPunks retroPunks = RetroPunks(retroPunksAddress);

        uint256 quantity = 1; // Mint 1 NFT
        retroPunks.ownerMint(to, quantity);

        console2.log("Minted", quantity, "NFT(s) to", to);

        vm.stopBroadcast();
    }
}