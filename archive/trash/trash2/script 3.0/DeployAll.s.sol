// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import {Assets} from "../src/Assets.sol";
import {FemaleProbs} from "../src/FemaleProbs.sol";
import {MaleProbs} from "../src/MaleProbs.sol";
import {Traits} from "../src/Traits.sol";
import {SVGRenderer} from "../src/SVGRenderer.sol";
import {RetroPunks} from "../src/RetroPunks.sol";

contract DeployAll is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy Assets
        Assets assets = new Assets();

        // Deploy FemaleProbs
        FemaleProbs femaleProbs = new FemaleProbs();

        // Deploy MaleProbs
        MaleProbs maleProbs = new MaleProbs();

        // Deploy Traits
        Traits traits = new Traits(maleProbs, femaleProbs);

        // Deploy SVGRenderer
        SVGRenderer renderer = new SVGRenderer(assets, traits);

        // Example committed hashes (based on seed=1234, nonce=5678 for global; seed=9876, nonce=5432 for shuffler)
        bytes32 committedGlobalSeedHash = keccak256(abi.encodePacked(uint256(1234), uint256(5678)));
        bytes32 committedShufflerSeedHash = keccak256(abi.encodePacked(uint256(9876), uint256(5432)));

        // Deploy RetroPunks (maxSupply=100 for testing, empty allowedSeaDrop)
        address[] memory allowedSeaDrop = new address[](0);
        RetroPunks retroPunks = new RetroPunks(renderer, committedGlobalSeedHash, committedShufflerSeedHash, 100, allowedSeaDrop);

        // Log addresses
        console2.log("Assets deployed at:", address(assets));
        console2.log("FemaleProbs deployed at:", address(femaleProbs));
        console2.log("MaleProbs deployed at:", address(maleProbs));
        console2.log("Traits deployed at:", address(traits));
        console2.log("SVGRenderer deployed at:", address(renderer));
        console2.log("RetroPunks deployed at:", address(retroPunks));

        vm.stopBroadcast();
    }
}