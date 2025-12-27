// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import { MaleProbs } from "../src/MaleProbs.sol";
import { FemaleProbs } from "../src/FemaleProbs.sol";
import { Assets } from "../src/Assets.sol";
import { Traits } from "../src/Traits.sol";
import { SVGRenderer } from "../src/SVGRenderer.sol";
import { RetroPunks } from "../src/RetroPunks.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy Probs
        MaleProbs maleProbs = new MaleProbs();
        FemaleProbs femaleProbs = new FemaleProbs();

        // Deploy Assets (empty)
        Assets assets = new Assets();

        // Deploy Traits
        Traits traits = new Traits(maleProbs, femaleProbs);

        // Deploy SVGRenderer
        SVGRenderer renderer = new SVGRenderer(assets, traits);

        // Committed hashes (dummy for test; compute keccak256(abi.encodePacked(seed, nonce)) for real)
        bytes32 committedGlobal = keccak256(abi.encodePacked(uint256(123), uint256(456)));
        bytes32 committedShuffler = keccak256(abi.encodePacked(uint256(789), uint256(1011)));

        // Deploy RetroPunks
        address[] memory allowedSeaDrop = new address[](0); // Empty for test
        RetroPunks retroPunks = new RetroPunks(renderer, committedGlobal, committedShuffler, 30, allowedSeaDrop);

        // Transfer Assets ownership to RetroPunks owner if needed (optional)
        // assets.transferOwnership(address(retroPunks));

        vm.stopBroadcast();

        console.log("MaleProbs:", address(maleProbs));
        console.log("FemaleProbs:", address(femaleProbs));
        console.log("Assets:", address(assets));
        console.log("Traits:", address(traits));
        console.log("SVGRenderer:", address(renderer));
        console.log("RetroPunks:", address(retroPunks));
    }
}