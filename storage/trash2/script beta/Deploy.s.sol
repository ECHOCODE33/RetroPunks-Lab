// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/Assets.sol";
import "../src/MaleProbs.sol";
import "../src/FemaleProbs.sol";
import "../src/Traits.sol";
import "../src/SVGRenderer.sol";
import "../src/RetroPunks.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy Assets contract
        console.log("Deploying Assets...");
        Assets assets = new Assets();
        console.log("Assets deployed at:", address(assets));

        // 2. Deploy Probability contracts
        console.log("Deploying MaleProbs...");
        MaleProbs maleProbs = new MaleProbs();
        console.log("MaleProbs deployed at:", address(maleProbs));

        console.log("Deploying FemaleProbs...");
        FemaleProbs femaleProbs = new FemaleProbs();
        console.log("FemaleProbs deployed at:", address(femaleProbs));

        // 3. Deploy Traits contract
        console.log("Deploying Traits...");
        Traits traits = new Traits(maleProbs, femaleProbs);
        console.log("Traits deployed at:", address(traits));

        // 4. Deploy SVGRenderer
        console.log("Deploying SVGRenderer...");
        SVGRenderer renderer = new SVGRenderer(assets, traits);
        console.log("SVGRenderer deployed at:", address(renderer));

        // 5. Generate seed commitments
        uint256 globalSeed = uint256(keccak256(abi.encodePacked(block.timestamp, "global")));
        uint256 globalNonce = uint256(keccak256(abi.encodePacked(block.timestamp, "global_nonce")));
        bytes32 globalSeedHash = keccak256(abi.encodePacked(globalSeed, globalNonce));

        uint256 shufflerSeed = uint256(keccak256(abi.encodePacked(block.timestamp, "shuffler")));
        uint256 shufflerNonce = uint256(keccak256(abi.encodePacked(block.timestamp, "shuffler_nonce")));
        bytes32 shufflerSeedHash = keccak256(abi.encodePacked(shufflerSeed, shufflerNonce));

        console.log("Global Seed:", globalSeed);
        console.log("Global Nonce:", globalNonce);
        console.log("Shuffler Seed:", shufflerSeed);
        console.log("Shuffler Nonce:", shufflerNonce);

        // 6. Deploy RetroPunks with seed commitments
        address[] memory allowedSeaDrop = new address[](0); // Empty for testing
        uint256 maxSupply = 10;

        console.log("Deploying RetroPunks...");
        RetroPunks retroPunks = new RetroPunks(
            renderer,
            globalSeedHash,
            shufflerSeedHash,
            maxSupply,
            allowedSeaDrop
        );
        console.log("RetroPunks deployed at:", address(retroPunks));

        // Save deployment addresses and seeds to file
        string memory deploymentInfo = string(abi.encodePacked(
            "ASSETS_ADDRESS=", vm.toString(address(assets)), "\n",
            "MALE_PROBS_ADDRESS=", vm.toString(address(maleProbs)), "\n",
            "FEMALE_PROBS_ADDRESS=", vm.toString(address(femaleProbs)), "\n",
            "TRAITS_ADDRESS=", vm.toString(address(traits)), "\n",
            "RENDERER_ADDRESS=", vm.toString(address(renderer)), "\n",
            "RETROPUNKS_ADDRESS=", vm.toString(address(retroPunks)), "\n",
            "GLOBAL_SEED=", vm.toString(globalSeed), "\n",
            "GLOBAL_NONCE=", vm.toString(globalNonce), "\n",
            "SHUFFLER_SEED=", vm.toString(shufflerSeed), "\n",
            "SHUFFLER_NONCE=", vm.toString(shufflerNonce), "\n"
        ));
        
        vm.writeFile("deployment.txt", deploymentInfo);
        console.log("Deployment info saved to deployment.txt");

        vm.stopBroadcast();
    }
}