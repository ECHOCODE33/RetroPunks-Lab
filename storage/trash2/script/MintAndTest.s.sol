// script/MintAndTest.s.sol
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import {RetroPunks} from "../src/RetroPunks.sol";

contract MintAndTest is Script {
    function run() external {
        vm.startBroadcast();

        address retroAddr = vm.envAddress("RETRO_PUNKS_ADDRESS");
        RetroPunks retroPunks = RetroPunks(retroAddr);

        retroPunks.ownerMint(msg.sender, 1);

        // Test tokenURI (after global seed reveal)
        string memory uri = retroPunks.tokenURI(1);
        console.log("Token URI for #1: ", uri);

        vm.stopBroadcast();
    }
}