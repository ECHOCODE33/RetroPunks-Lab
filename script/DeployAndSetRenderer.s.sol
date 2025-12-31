// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { Script, console2 } from "forge-std/Script.sol";
import { PreRevealSVGRenderer } from "../src/PreRevealSVGRenderer.sol";
import { RetroPunks } from "../src/RetroPunks.sol";
import { IAssets } from "../src/interfaces/IAssets.sol";
import { ISVGRenderer } from "../src/interfaces/ISVGRenderer.sol";

contract DeployAndSetRenderer is Script {

    address constant ASSETS_CONTRACT_ADDRESS = 0xCB911868Df32dF10B954821f37FC4Ce7e2261742;
    address constant RETRO_PUNKS_ADDRESS = 0x167B5eD0fda3e2AE51282695B250E55cBC60615D;

    function run() external {

        vm.startBroadcast();

        PreRevealSVGRenderer newRenderer = new PreRevealSVGRenderer(
            IAssets(ASSETS_CONTRACT_ADDRESS)
        );

        console2.log("New Renderer deployed at:", address(newRenderer));

        RetroPunks(RETRO_PUNKS_ADDRESS).setRenderer(ISVGRenderer(address(newRenderer)));

        console2.log("RetroPunks renderer updated successfully.");

        vm.stopBroadcast();
    }
}