// script/DeployAll.s.sol
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
        vm.startBroadcast();

        // Deploy Assets
        Assets assets = new Assets();

        // Deploy Probabilities
        FemaleProbabilities femaleProbs = new FemaleProbabilities();
        MaleProbabilities maleProbs = new MaleProbabilities();

        // Deploy Traits
        Traits traits = new Traits(maleProbs, femaleProbs);

        // Deploy SVGRenderer
        SVGRenderer renderer = new SVGRenderer(assets, traits);

        // Deploy RetroPunks
        // Dummy committed hashes (compute off-chain: keccak256(abi.encodePacked(seed, nonce)))
        bytes32 committedGlobalSeedHash = keccak256(abi.encodePacked(uint(12345), uint(67890))); // Example
        bytes32 committedShufflerSeedHash = keccak256(abi.encodePacked(uint(54321), uint(98765))); // Example
        uint maxSupply = 10000; // Example
        address[] memory allowedSeaDrop = new address[](1);
        allowedSeaDrop[0] = address(0); // Dummy, or your SeaDrop contract address

        RetroPunks retroPunks = new RetroPunks(renderer, committedGlobalSeedHash, committedShufflerSeedHash, maxSupply, allowedSeaDrop);

        console.log("Assets deployed at: ", address(assets));
        console.log("FemaleProbabilities at: ", address(femaleProbs));
        console.log("MaleProbabilities at: ", address(maleProbs));
        console.log("Traits at: ", address(traits));
        console.log("SVGRenderer at: ", address(renderer));
        console.log("RetroPunks at: ", address(retroPunks));

        vm.stopBroadcast();
    }
}