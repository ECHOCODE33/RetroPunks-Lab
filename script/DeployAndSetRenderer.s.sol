// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

// import { PreRevealSVGRenderer } from "../src/PreRevealSVGRenderer.sol";
import { RetroPunks } from "../src/RetroPunks.sol";
import { SVGRenderer } from "../src/SVGRenderer.sol";
// import { IAssets } from "../src/interfaces/IAssets.sol";
import { ISVGRenderer } from "../src/interfaces/ISVGRenderer.sol";
// import { ITraits } from "../src/interfaces/ITraits.sol";
import { Script, console2 } from "forge-std/Script.sol";

contract DeployAndSetRenderer is Script {
    address ASSETS = vm.envAddress("ASSETS");
    address TRAITS = vm.envAddress("TRAITS");
    address RENDERER = vm.envAddress("SVG_RENDERER");
    address RETROPUNKS = vm.envAddress("RETROPUNKS");

    function run() external {
        vm.startBroadcast();

        /* PreRevealSVGRenderer newRenderer = new PreRevealSVGRenderer(
            IAssets(ASSETS)
        ); */

        // SVGRenderer newRenderer = new SVGRenderer(IAssets(ASSETS), ITraits(TRAITS));

        console2.log("New Renderer deployed at:", address(RENDERER));

        RetroPunks(RETROPUNKS).setRenderer(ISVGRenderer(address(RENDERER)), true);

        console2.log("New RetroPunks renderer set");

        vm.stopBroadcast();
    }
}
