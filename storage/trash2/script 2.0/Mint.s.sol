// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import { RetroPunks } from "../src/RetroPunks.sol";

contract MintScript is Script {
    function run() external {
        address retroPunksAddress = 0x998abeb3E57409262aE5b751f60747921B33613E; // Replace
        RetroPunks retroPunks = RetroPunks(retroPunksAddress);

        address to = msg.sender; // Or test addr
        uint256 quantity = 5; // Example

        vm.startBroadcast();
        retroPunks.ownerMint(to, quantity); // Or simulate public mint if SeaDrop set
        vm.stopBroadcast();
    }
}