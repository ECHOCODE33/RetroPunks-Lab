// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/Assets.sol";
import "../src/libraries/LibZip.sol";

contract VerifyAssetsScript is Script {
    using LibZip for bytes;
    
    function run() external view {
        address assetsAddress = vm.envAddress("ASSETS_ADDRESS");
        Assets assets = Assets(assetsAddress);
        
        console.log("=== Verifying Male Skin Group (key 2) ===");
        _verifyTraitGroup(assets, 2);
        
        console.log("\n=== Verifying Background Group (key 1) ===");
        _verifyTraitGroup(assets, 1);
        
        console.log("\n=== Verifying Background Image (key 1008) ===");
        bytes memory bgImage = assets.loadAssetOriginal(1008);
        console.log("Background image size:", bgImage.length, "bytes");
        console.log("Is PNG?", bgImage[0] == 0x89 && bgImage[1] == 0x50);
    }
    
    function _verifyTraitGroup(Assets assets, uint key) internal view {
        bytes memory compressed = assets.loadAssetOriginal(key);
        console.log("Compressed size:", compressed.length, "bytes");