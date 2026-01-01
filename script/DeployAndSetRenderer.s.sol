// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { Script, console2 } from "forge-std/Script.sol";
import { ISVGRenderer } from "../src/interfaces/ISVGRenderer.sol";
import { IAssets } from "../src/interfaces/IAssets.sol";
import { ITraits } from "../src/interfaces/ITraits.sol";
import { PreRevealSVGRenderer } from "../src/PreRevealSVGRenderer.sol";
import { SVGRenderer } from "../src/SVGRenderer.sol";
import { RetroPunks } from "../src/RetroPunks.sol";

contract DeployAndSetRenderer is Script {

    address constant ASSETS = 0x4FF1f57Eb6aEf73fA402b4Cc0D2Ccb76bA4A7da2;
    address constant TRAITS = 0x21C8b15c5f74E3104FD1204C5E18d55e9b24C8C7;
    address constant RETROPUNKS = 0xcbB15f83A48e98767dD0C1C9459EEA26469079c4;

    function run() external {

        vm.startBroadcast();

        // PreRevealSVGRenderer newRenderer = new PreRevealSVGRenderer(
        //     IAssets(ASSETS)
        // );

        SVGRenderer newRenderer = new SVGRenderer(
            IAssets(ASSETS),
            ITraits(TRAITS)
        );

        console2.log("New Renderer deployed at:", address(newRenderer));

        RetroPunks(RETROPUNKS).setRenderer(ISVGRenderer(address(newRenderer)));

        console2.log("New RetroPunks renderer set");

        vm.stopBroadcast();
    }
}