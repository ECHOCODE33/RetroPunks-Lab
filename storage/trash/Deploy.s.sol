// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {Assets} from "../src/Assets.sol";
import {Traits} from "../src/Traits.sol";
import {SVGRenderer} from "../src/SVGRenderer.sol";
import {RetroPunks} from "../src/RetroPunks.sol";
import {MaleProbabilities} from "../src/MaleProbabilities.sol";
import {FemaleProbabilities} from "../src/FemaleProbabilities.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();

        console.log("Deploying contracts...");

        // 1. Deploy Assets
        Assets assets = new Assets();
        console.log("Assets deployed at:", address(assets));

        // 2. Deploy Probability contracts
        MaleProbabilities maleProbs = new MaleProbabilities();
        FemaleProbabilities femaleProbs = new FemaleProbabilities();
        console.log("Male Probabilities:", address(maleProbs));
        console.log("Female Probabilities:", address(femaleProbs));

        // 3. Deploy Traits
        Traits traits = new Traits(maleProbs, femaleProbs);
        console.log("Traits deployed at:", address(traits));

        // 4. Deploy SVGRenderer
        SVGRenderer renderer = new SVGRenderer(assets, traits);
        console.log("SVGRenderer deployed at:", address(renderer));

        // 5. Deploy RetroPunks
        bytes32 globalSeedHash = keccak256(abi.encodePacked(uint256(12345), uint256(67890)));
        bytes32 shufflerSeedHash = keccak256(abi.encodePacked(uint256(11111), uint256(22222)));
        
        address[] memory allowedSeaDrop = new address[](0);
        
        RetroPunks retroPunks = new RetroPunks(
            renderer,
            globalSeedHash,
            shufflerSeedHash,
            10000, // max supply
            allowedSeaDrop
        );
        console.log("RetroPunks deployed at:", address(retroPunks));

        vm.stopBroadcast();

        // Save addresses to file for easy reference
        console.log("\n=== Deployment Summary ===");
        console.log("Assets:", address(assets));
        console.log("Traits:", address(traits));
        console.log("SVGRenderer:", address(renderer));
        console.log("RetroPunks:", address(retroPunks));
    }
}