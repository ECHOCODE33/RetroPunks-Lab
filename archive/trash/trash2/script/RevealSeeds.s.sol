// script/RevealSeeds.s.sol
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import {RetroPunks} from "../src/RetroPunks.sol";

contract RevealSeeds is Script {
    function run() external {
        vm.startBroadcast();


        address retroAddr = vm.envAddress("RETRO_PUNKS_ADDRESS");
        RetroPunks retroPunks = RetroPunks(retroAddr);

        uint shufflerSeed = 54321;
        uint shufflerNonce = 98765;
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);


        // uint globalSeed = 12345;
        // uint globalNonce = 67890;
        // retroPunks.revealGlobalSeed(globalSeed, globalNonce);

        console.log("Seeds revealed!");

        vm.stopBroadcast();
    }
}