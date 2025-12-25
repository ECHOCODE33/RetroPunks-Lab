// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/Assets.sol";
import "../src/libraries/LibZip.sol";

contract UploadAssetsScript is Script {
    using LibZip for bytes;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address assetsAddress = vm.envAddress("ASSETS_ADDRESS");
        
        vm.startBroadcast(deployerPrivateKey);
        
        Assets assets = Assets(assetsAddress);
        
        console.log("=== Uploading Trait Groups ===");
        
        // Upload Male Skin Group (Group 2)
        bytes memory maleSkinData = _createMaleSkinGroup();
        assets.addAsset(2, maleSkinData.flzCompress());
        console.log("Uploaded Male Skin Group (key 2)");
        
        // Upload Male Eyes Group (Group 3)
        bytes memory maleEyesData = _createMaleEyesGroup();
        assets.addAsset(3, maleEyesData.flzCompress());
        console.log("Uploaded Male Eyes Group (key 3)");
        
        // Upload Background Group (Group 1)
        bytes memory backgroundData = _createBackgroundGroup();
        assets.addAsset(1, backgroundData.flzCompress());
        console.log("Uploaded Background Group (key 1)");
        
        console.log("\n=== Uploading Background Images ===");
        
        // Upload Background Image (key 1000 + enum value)
        bytes memory skyBlueImage = _createDummyPNG();
        assets.addAsset(1008, skyBlueImage); // Sky_Blue = 8
        console.log("Uploaded Sky Blue Background Image (key 1008)");
        
        console.log("\n=== Uploading Pre-rendered Specials ===");
        
        // Upload Pre-rendered Special 1 (key 100 + specialId)
        bytes memory predatorBlueImage = _createDummyPNG();
        assets.addAsset(105, predatorBlueImage); // Predator_Blue specialId=5
        console.log("Uploaded Predator Blue Special (key 105)");
        
        vm.stopBroadcast();
    }
    
    // ========================================================================
    // TRAIT GROUP BUILDERS
    // ========================================================================
    
    function _createMaleSkinGroup() internal pure returns (bytes memory) {
        bytes memory data;
        
        // 1. Group Name: "Male Skin"
        data = abi.encodePacked(
            uint8(9),                    // Name length
            "Male Skin"                  // Name
        );
        
        // 2. Palette (5 colors for this example)
        uint32[] memory palette = new uint32[](5);
        palette[0] = 0xFFD7B5FF; // Skin tone 1
        palette[1] = 0xE8B896FF; // Skin tone 2
        palette[2] = 0xC89968FF; // Skin tone 3
        palette[3] = 0x8B6F47FF; // Skin tone 4
        palette[4] = 0x5f5d6eFF; // MAGIC_TRANSPARENT
        
        data = abi.encodePacked(
            data,
            uint16(5)                    // Palette size (big-endian)
        );
        
        for (uint i = 0; i < 5; i++) {
            data = abi.encodePacked(data, palette[i]);
        }
        
        // 3. Metadata
        data = abi.encodePacked(
            data,
            uint8(1),                    // Index byte size (1 byte per palette index)
            uint8(2)                     // Trait count (2 traits for demo)
        );
        
        // 4. Trait 1: "Human 1" - Simple 4x4 square
        data = abi.encodePacked(
            data,
            uint16(16),                  // Pixel count (4x4 = 16 pixels)
            uint8(22), uint8(22),        // x1, y1 (top-left)
            uint8(25), uint8(25),        // x2, y2 (bottom-right)
            uint8(0),                    // Layer type
            uint8(7),                    // Trait name length
            "Human 1"                    // Trait name
        );
        
        // RLE Data: All pixels use palette index 0 (skin tone 1)
        // Run of 4 pixels, then repeat 4 times for 4 rows
        data = abi.encodePacked(
            data,
            uint8(4), uint8(0),          // Run: 4 pixels, color index 0
            uint8(4), uint8(0),
            uint8(4), uint8(0),
            uint8(4), uint8(0)
        );
        
        // 5. Trait 2: "Human 2" - 4x4 with transparency
        data = abi.encodePacked(
            data,
            uint16(16),                  // Pixel count
            uint8(22), uint8(22),
            uint8(25), uint8(25),
            uint8(0),
            uint8(7),
            "Human 2"
        );
        
        // RLE: Mix of colors with transparency
        data = abi.encodePacked(
            data,
            uint8(2), uint8(1),          // 2 pixels of color index 1
            uint8(2), uint8(4),          // 2 transparent pixels
            uint8(4), uint8(1),          // 4 pixels of color index 1
            uint8(4), uint8(1),
            uint8(4)