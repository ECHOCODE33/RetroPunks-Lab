// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { Assets } from "../src/Assets.sol";
import { PreRevealSVGRenderer } from "../src/PreRevealSVGRenderer.sol";
// import { Rarities } from "../src/Rarities.sol";
import { RetroPunks } from "../src/RetroPunks.sol";
import { SVGRenderer } from "../src/SVGRenderer.sol";
import { Traits } from "../src/Traits.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        Assets assets = new Assets();

        Traits traits = new Traits();

        PreRevealSVGRenderer prerenderer = new PreRevealSVGRenderer(Assets(address(assets)));

        SVGRenderer renderer = new SVGRenderer(Assets(address(assets)), Traits(address(traits)));

        bytes32 committedGlobalSeedHash = keccak256(abi.encodePacked(uint256(9836428957), uint256(2829003893)));
        bytes32 committedShufflerSeedHash = keccak256(abi.encodePacked(uint256(7393514293), uint256(3904021486)));

        uint256 maxSupply = 25;
        address[] memory allowedSeaDrop = new address[](1);
        allowedSeaDrop[0] = 0x00005EA00Ac477B1030CE78506496e8C2dE24bf5;

        RetroPunks retroPunks = new RetroPunks(PreRevealSVGRenderer(address(prerenderer)), committedGlobalSeedHash, committedShufflerSeedHash, maxSupply, allowedSeaDrop);

        console.log("Assets::", address(assets));
        console.log("Traits:", address(traits));
        console.log("PreRevealSVGRenderer:", address(prerenderer));
        console.log("SVGRenderer:", address(renderer));
        console.log("RetroPunks:", address(retroPunks));

        vm.stopBroadcast();
    }
}
