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

    address constant ASSETS = 0xCdE4E9bd6B1CA111A475BFC4Cf45CB9e7ACC44Cb;
    address constant TRAITS = 0xb43B2e7e8C606856E3b91fd8c6062E8fd8f652AB;
    address constant RETROPUNKS = 0x7A7741eBfAD78ce204395ba1dd0B516b40e79102;

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