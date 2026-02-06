// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import {Assets} from "../src/Assets.sol";
import {FemaleProbabilities} from "../src/FemaleProbabilities.sol";
import {MaleProbabilities} from "../src/MaleProbabilities.sol";
import {Traits} from "../src/Traits.sol";
import {SVGRenderer} from "../src/SVGRenderer.sol";
import {RetroPunks} from "../src/RetroPunks.sol";

contract DeployAll is Script {
    function run() external {
        // Seeds for commit-reveal (store these securely!)
        uint256 globalSeed = 123456789;
        uint256 globalNonce = 987654321;
        uint256 shufflerSeed = 111222333;
        uint256 shufflerNonce = 444555666;
        
        bytes32 committedGlobalSeedHash = keccak256(abi.encodePacked(globalSeed, globalNonce));
        bytes32 committedShufflerSeedHash = keccak256(abi.encodePacked(shufflerSeed, shufflerNonce));
        
        console.log("=== DEPLOYMENT STARTING ===");
        console.log("Global Seed:", globalSeed);
        console.log("Global Nonce:", globalNonce);
        console.log("Shuffler Seed:", shufflerSeed);
        console.log("Shuffler Nonce:", shufflerNonce);
        console.log("Global Hash:", vm.toString(committedGlobalSeedHash));
        console.log("Shuffler Hash:", vm.toString(committedShufflerSeedHash));
        
        vm.startBroadcast();

        // Deploy Assets
        Assets assets = new Assets();
        console.log("Assets deployed at:", address(assets));

        // Deploy Probabilities
        FemaleProbabilities femaleProbs = new FemaleProbabilities();
        console.log("FemaleProbabilities at:", address(femaleProbs));
        
        MaleProbabilities maleProbs = new MaleProbabilities();
        console.log("MaleProbabilities at:", address(maleProbs));

        // Deploy Traits
        Traits traits = new Traits(maleProbs, femaleProbs);
        console.log("Traits at:", address(traits));

        // Deploy SVGRenderer
        SVGRenderer renderer = new SVGRenderer(assets, traits);
        console.log("SVGRenderer at:", address(renderer));

        // Deploy RetroPunks
        uint maxSupply = 100; // Small for testing
        address[] memory allowedSeaDrop = new address[](0); // Empty for testing
        
        RetroPunks retroPunks = new RetroPunks(
            renderer,
            committedGlobalSeedHash,
            committedShufflerSeedHash,
            maxSupply,
            allowedSeaDrop
        );
        console.log("RetroPunks at:", address(retroPunks));

        console.log("\n=== DEPLOYMENT COMPLETE ===");
        console.log("Save these addresses to .env:");
        console.log("ASSETS_ADDRESS=", address(assets));
        console.log("FEMALE_PROBS_ADDRESS=", address(femaleProbs));
        console.log("MALE_PROBS_ADDRESS=", address(maleProbs));
        console.log("TRAITS_ADDRESS=", address(traits));
        console.log("RENDERER_ADDRESS=", address(renderer));
        console.log("RETRO_PUNKS_ADDRESS=", address(retroPunks));
        
        console.log("\nSave these for reveals:");
        console.log("GLOBAL_SEED=", globalSeed);
        console.log("GLOBAL_NONCE=", globalNonce);
        console.log("SHUFFLER_SEED=", shufflerSeed);
        console.log("SHUFFLER_NONCE=", shufflerNonce);

        vm.stopBroadcast();
    }
}