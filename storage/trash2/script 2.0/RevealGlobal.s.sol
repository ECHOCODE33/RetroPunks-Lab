// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import { RetroPunks } from "../src/RetroPunks.sol";

contract RevealGlobalScript is Script {
    function run() external {
        address retroPunksAddress = 0x998abeb3E57409262aE5b751f60747921B33613E; // Replace
        RetroPunks retroPunks = RetroPunks(retroPunksAddress);

        uint256 seed = 123; // Matches dummy
        uint256 nonce = 456;

        vm.startBroadcast();
        retroPunks.revealGlobalSeed(seed, nonce);
        vm.stopBroadcast();
    }
}