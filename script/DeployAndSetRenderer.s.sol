// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import {Script, console2} from "forge-std/Script.sol";
import {ISVGRenderer} from "../src/interfaces/ISVGRenderer.sol";
import {IAssets} from "../src/interfaces/IAssets.sol";
import {ITraits} from "../src/interfaces/ITraits.sol";
import {PreRevealSVGRenderer} from "../src/PreRevealSVGRenderer.sol";
import {SVGRenderer} from "../src/SVGRenderer.sol";
import {RetroPunks} from "../src/RetroPunks.sol";

contract DeployAndSetRenderer is Script {
    address constant ASSETS = 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512;
    address constant TRAITS = 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0;
    address constant RETROPUNKS = 0x5FC8d32690cc91D4c39d9d3abcBD16989F875707;

    function run() external {
        vm.startBroadcast();

        // PreRevealSVGRenderer newRenderer = new PreRevealSVGRenderer(
        //     IAssets(ASSETS)
        // );

        SVGRenderer newRenderer = new SVGRenderer(IAssets(ASSETS), ITraits(TRAITS));

        console2.log("New Renderer deployed at:", address(newRenderer));

        RetroPunks(RETROPUNKS).setRenderer(ISVGRenderer(address(newRenderer)));

        console2.log("New RetroPunks renderer set");

        vm.stopBroadcast();
    }
}
