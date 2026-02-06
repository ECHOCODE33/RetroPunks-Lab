// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import {Assets} from "../src/Assets.sol";
import {LibZip} from "../src/libraries/LibZip.sol";

contract AddAssets is Script {
    Assets assets;

    uint256 constant NUM_SPECIAL_1S = 16;
    uint256 constant NUM_BACKGROUND = 11;

    function run() external {
        vm.startBroadcast();

        address assetsAddr = vm.envAddress("ASSETS_ADDRESS");
        assets = Assets(assetsAddr);

        console.log("Adding assets to:", assetsAddr);

        // Add all asset groups
        addSpecialAssets();
        addBackgroundAssets();
        addMaleAssets();
        addFemaleAssets();
        addOtherAssets();

        console.log("All assets added successfully!");

        vm.stopBroadcast();
    }

    // Helper: Generate minimal valid trait group data
    function generateTraitGroup(string memory groupName, uint32[] memory palette, string[] memory traitNames) internal pure returns (bytes memory) {
        bytes memory data;

        // Group name length + name
        data = abi.encodePacked(
            uint8(bytes(groupName).length),
            bytes(groupName)
        );

        // Palette size (big-endian) + colors
        data = abi.encodePacked(
            data,
            uint8(palette.length >> 8),
            uint8(palette.length & 0xFF)
        );
        for (uint i = 0; i < palette.length; i++) {
            data = abi.encodePacked(data, palette[i]);
        }

        // Index byte size (1 for palettes < 256)
        uint8 indexByteSize = palette.length > 255 ? 2 : 1;
        data = abi.encodePacked(data, indexByteSize);

        // Trait count
        data = abi.encodePacked(data, uint8(traitNames.length));

        // Each trait: minimal 1x1 pixel
        for (uint i = 0; i < traitNames.length; i++) {
            bytes memory traitName = bytes(traitNames[i]);

            // Trait header: pixelCount(2) + bounds(4) + layerType(1) + nameLen(1)
            data = abi.encodePacked(
                data,
                uint8(0),
                uint8(1), // 1 pixel
                uint8(0),
                uint8(0), // x1, y1
                uint8(0),
                uint8(0), // x2, y2
                uint8(0), // layerType
                uint8(traitName.length)
            );

            // Trait name
            data = abi.encodePacked(data, traitName);

            // RLE data: 1 pixel with color index 0
            data = abi.encodePacked(data, uint8(1)); // run length 1
            if (indexByteSize == 1) {
                data = abi.encodePacked(data, uint8(0));
            } else {
                data = abi.encodePacked(data, uint8(0), uint8(0));
            }
        }

        return data;
    }

    function addSpecialAssets() internal {
        console.log("Adding special assets...");

        // Special 1s trait group
        string[] memory specialNames = new string[](NUM_SPECIAL_1S);
        specialNames[0] = "Ancient Mummy";
        specialNames[1] = "CyberApe";
        specialNames[2] = "Old Skeleton";
        specialNames[3] = "Pig";
        specialNames[4] = "Predator Blue";
        specialNames[5] = "Predator Green";
        specialNames[6] = "Predator Red";
        specialNames[7] = "Santa Claus";
        specialNames[8] = "Shadow Ninja";
        specialNames[9] = "Slenderman";
        specialNames[10] = "The Clown";
        specialNames[11] = "The Devil";
        specialNames[12] = "The Pirate";
        specialNames[13] = "The Portrait";
        specialNames[14] = "The Witch";
        specialNames[15] = "The Wizard";

        uint32[] memory palette = new uint32[](1);
        palette[0] = 0x00000000; // Transparent

        bytes memory specialData = generateTraitGroup(
            "Special 1s",
            palette,
            specialNames
        );
        assets.addAsset(0, LibZip.flzCompress(specialData));

        // Dummy pre-rendered PNGs (1x1 transparent)
        bytes
            memory dummyPNG = hex"89504E470D0A1A0A0000000D49484452000000010000000108060000001C0E010300000006504C544500000000000000000026000000014944415478DA63600000000049454E44AE426082";
        for (uint i = 101; i <= 116; i++) {
            assets.addAsset(i, dummyPNG);
        }
    }

    function addBackgroundAssets() internal {
        console.log("Adding background assets...");

        // Expanded palette with more colors
        uint32[] memory palette = new uint32[](11);
        palette[0] = 0x87CEEBFF; // Sky blue
        palette[1] = 0x1E90FFFF; // Dodger blue
        palette[2] = 0x32CD32FF; // Lime green
        palette[3] = 0xFF4500FF; // Orange red for lava
        palette[4] = 0xFFA500FF; // Orange
        palette[5] = 0xFF69B4FF; // Hot pink
        palette[6] = 0x9370DBFF; // Medium purple
        palette[7] = 0xFF0000FF; // Red
        palette[8] = 0x40E0D0FF; // Turquoise
        palette[9] = 0xFFFF00FF; // Yellow
        palette[10] = 0x000000FF; // Black (备用)

        // Build background trait group
        bytes memory data;

        // Group name
        string memory groupName = "Background";
        data = abi.encodePacked(
            uint8(bytes(groupName).length),
            bytes(groupName)
        );

        // Palette size + colors
        data = abi.encodePacked(data, uint8(palette.length >> 8), uint8(palette.length & 0xFF));
        for (uint i = 0; i < palette.length; i++) {
            data = abi.encodePacked(data, palette[i]);
        }

        // Index byte size 1
        data = abi.encodePacked(data, uint8(1));

        // Trait count 11
        data = abi.encodePacked(data, uint8(NUM_BACKGROUND));

        // Add traits
        // Standard: solid sky blue
        data = abi.encodePacked(
            data,
            _buildBackgroundTrait("Standard", 2, 0, 0, 0, 0, _arr(0))
        );

        // Blue: vertical gradient sky to dodger
        data = abi.encodePacked(
            data,
            _buildBackgroundTrait("Blue", 3, 0, 0, 0, 48, _arr2(0, 1))
        );

        // Green: solid lime
        data = abi.encodePacked(
            data,
            _buildBackgroundTrait("Green", 2, 0, 0, 0, 0, _arr(2))
        );

        // Lava: vertical orange red to black? But adjust
        data = abi.encodePacked(
            data,
            _buildBackgroundTrait("Lava", 3, 0, 0, 0, 48, _arr2(3, 10))
        );

        // Orange: solid orange
        data = abi.encodePacked(
            data,
            _buildBackgroundTrait("Orange", 2, 0, 0, 0, 0, _arr(4))
        );

        // Pink: solid hot pink
        data = abi.encodePacked(
            data,
            _buildBackgroundTrait("Pink", 2, 0, 0, 0, 0, _arr(5))
        );

        // Purple: solid medium purple
        data = abi.encodePacked(
            data,
            _buildBackgroundTrait("Purple", 2, 0, 0, 0, 0, _arr(6))
        );

        // Red: solid red
        data = abi.encodePacked(
            data,
            _buildBackgroundTrait("Red", 2, 0, 0, 0, 0, _arr(7))
        );

        // Sky Blue: vertical sky to dodger
        data = abi.encodePacked(
            data,
            _buildBackgroundTrait("Sky Blue", 3, 0, 0, 0, 48, _arr2(0, 1))
        );

        // Turquoise: solid turquoise
        data = abi.encodePacked(
            data,
            _buildBackgroundTrait("Turquoise", 2, 0, 0, 0, 0, _arr(8))
        );

        // Yellow: solid yellow
        data = abi.encodePacked(
            data,
            _buildBackgroundTrait("Yellow", 2, 0, 0, 0, 0, _arr(9))
        );

        assets.addAsset(1, LibZip.flzCompress(data));

        // No background images for test
    }

    // Updated build for background: pixelCount=0, add numColors after name
    function _buildBackgroundTrait(string memory name, uint8 layerType, uint8 x1, uint8 y1, uint8 x2, uint8 y2, uint8[] memory colorIndices) internal pure returns (bytes memory) {
        bytes memory traitName = bytes(name);

        bytes memory result = abi.encodePacked(
            uint8(0),
            uint8(0), // pixelCount = 0
            x1,
            y1,
            x2,
            y2,
            layerType,
            uint8(traitName.length),
            traitName,
            uint8(colorIndices.length)
        );

        for (uint i = 0; i < colorIndices.length; i++) {
            result = abi.encodePacked(result, colorIndices[i]);
        }

        return result;
    }

    // Helper: create single-element array
    function _arr(uint8 val) internal pure returns (uint8[] memory) {
        uint8[] memory arr = new uint8[](1);
        arr[0] = val;
        return arr;
    }

    // Helper: create two-element array
    function _arr2(uint8 val1, uint8 val2) internal pure returns (uint8[] memory) {
        uint8[] memory arr = new uint8[](2);
        arr[0] = val1;
        arr[1] = val2;
        return arr;
    }

    function addMaleAssets() internal {
        console.log("Adding male assets...");

        uint32[] memory palette = new uint32[](4);
        palette[0] = 0xFFDBACFF; // Skin
        palette[1] = 0x8B4513FF; // Brown
        palette[2] = 0x000000FF; // Black
        palette[3] = 0xFFFFFFFF; // White

        // Male Skin
        string[] memory skinNames = new string[](3);
        skinNames[0] = "None";
        skinNames[1] = "Human 1";
        skinNames[2] = "Alien";
        assets.addAsset(
            2,
            LibZip.flzCompress(
                generateTraitGroup("Male Skin", palette, skinNames)
            )
        );

        // Male Eyes
        string[] memory eyeNames = new string[](3);
        eyeNames[0] = "None";
        eyeNames[1] = "Left";
        eyeNames[2] = "Right";
        assets.addAsset(
            3,
            LibZip.flzCompress(
                generateTraitGroup("Male Eyes", palette, eyeNames)
            )
        );

        // Male Face
        string[] memory faceNames = new string[](2);
        faceNames[0] = "None";
        faceNames[1] = "Mole";
        assets.addAsset(
            4,
            LibZip.flzCompress(
                generateTraitGroup("Male Face", palette, faceNames)
            )
        );

        // Male Chain
        string[] memory chainNames = new string[](2);
        chainNames[0] = "None";
        chainNames[1] = "Chain Gold";
        assets.addAsset(
            5,
            LibZip.flzCompress(
                generateTraitGroup("Male Chain", palette, chainNames)
            )
        );

        // Male Earring
        string[] memory earringNames = new string[](2);
        earringNames[0] = "None";
        earringNames[1] = "Earring Gold";
        assets.addAsset(
            6,
            LibZip.flzCompress(
                generateTraitGroup("Male Earring", palette, earringNames)
            )
        );

        // Male Facial Hair
        string[] memory facialHairNames = new string[](3);
        facialHairNames[0] = "None";
        facialHairNames[1] = "Beard Black";
        facialHairNames[2] = "Mustache Brown";
        assets.addAsset(
            7,
            LibZip.flzCompress(
                generateTraitGroup("Male Facial Hair", palette, facialHairNames)
            )
        );

        // Male Mask
        string[] memory maskNames = new string[](2);
        maskNames[0] = "None";
        maskNames[1] = "Medical Mask";
        assets.addAsset(
            8,
            LibZip.flzCompress(
                generateTraitGroup("Male Mask", palette, maskNames)
            )
        );

        // Male Scarf
        string[] memory scarfNames = new string[](2);
        scarfNames[0] = "None";
        scarfNames[1] = "Blue Scarf";
        assets.addAsset(
            9,
            LibZip.flzCompress(
                generateTraitGroup("Male Scarf", palette, scarfNames)
            )
        );

        // Male Hair
        string[] memory hairNames = new string[](3);
        hairNames[0] = "None";
        hairNames[1] = "Afro Black";
        hairNames[2] = "Buzz Cut";
        assets.addAsset(
            10,
            LibZip.flzCompress(
                generateTraitGroup("Male Hair", palette, hairNames)
            )
        );

        // Male Hat Hair
        string[] memory hatHairNames = new string[](2);
        hatHairNames[0] = "None";
        hatHairNames[1] = "Buzz Cut Hat";
        assets.addAsset(
            11,
            LibZip.flzCompress(
                generateTraitGroup("Male Hat Hair", palette, hatHairNames)
            )
        );

        // Male Headwear
        string[] memory headwearNames = new string[](3);
        headwearNames[0] = "None";
        headwearNames[1] = "Cap Blue";
        headwearNames[2] = "Beanie Red";
        assets.addAsset(
            12,
            LibZip.flzCompress(
                generateTraitGroup("Male Headwear", palette, headwearNames)
            )
        );

        // Male Eye Wear
        string[] memory eyeWearNames = new string[](3);
        eyeWearNames[0] = "None";
        eyeWearNames[1] = "Regular Glasses";
        eyeWearNames[2] = "Shades Blue";
        assets.addAsset(
            13,
            LibZip.flzCompress(
                generateTraitGroup("Male Eye Wear", palette, eyeWearNames)
            )
        );
    }

    function addFemaleAssets() internal {
        console.log("Adding female assets...");

        uint32[] memory palette = new uint32[](4);
        palette[0] = 0xFFDBACFF; // Skin
        palette[1] = 0x8B4513FF; // Brown
        palette[2] = 0x000000FF; // Black
        palette[3] = 0xFFFFFFFF; // White

        // Female Skin
        string[] memory skinNames = new string[](3);
        skinNames[0] = "None";
        skinNames[1] = "Human 1";
        skinNames[2] = "Alien";
        assets.addAsset(
            14,
            LibZip.flzCompress(
                generateTraitGroup("Female Skin", palette, skinNames)
            )
        );

        // Female Eyes
        string[] memory eyeNames = new string[](3);
        eyeNames[0] = "None";
        eyeNames[1] = "Left";
        eyeNames[2] = "Right";
        assets.addAsset(
            15,
            LibZip.flzCompress(
                generateTraitGroup("Female Eyes", palette, eyeNames)
            )
        );

        // Female Face
        string[] memory faceNames = new string[](2);
        faceNames[0] = "None";
        faceNames[1] = "Mole";
        assets.addAsset(
            16,
            LibZip.flzCompress(
                generateTraitGroup("Female Face", palette, faceNames)
            )
        );

        // Female Chain
        string[] memory chainNames = new string[](2);
        chainNames[0] = "None";
        chainNames[1] = "Chain Gold";
        assets.addAsset(
            17,
            LibZip.flzCompress(
                generateTraitGroup("Female Chain", palette, chainNames)
            )
        );

        // Female Earring
        string[] memory earringNames = new string[](2);
        earringNames[0] = "None";
        earringNames[1] = "Earring Gold";
        assets.addAsset(
            18,
            LibZip.flzCompress(
                generateTraitGroup("Female Earring", palette, earringNames)
            )
        );

        // Female Mask
        string[] memory maskNames = new string[](2);
        maskNames[0] = "None";
        maskNames[1] = "Medical Mask";
        assets.addAsset(
            19,
            LibZip.flzCompress(
                generateTraitGroup("Female Mask", palette, maskNames)
            )
        );

        // Female Scarf
        string[] memory scarfNames = new string[](2);
        scarfNames[0] = "None";
        scarfNames[1] = "Blue Scarf";
        assets.addAsset(
            20,
            LibZip.flzCompress(
                generateTraitGroup("Female Scarf", palette, scarfNames)
            )
        );

        // Female Hair
        string[] memory hairNames = new string[](3);
        hairNames[0] = "None";
        hairNames[1] = "Afro Black";
        hairNames[2] = "Bob Black";
        assets.addAsset(
            21,
            LibZip.flzCompress(
                generateTraitGroup("Female Hair", palette, hairNames)
            )
        );

        // Female Hat Hair
        string[] memory hatHairNames = new string[](2);
        hatHairNames[0] = "None";
        hatHairNames[1] = "Bob Black Hat";
        assets.addAsset(
            22,
            LibZip.flzCompress(
                generateTraitGroup("Female Hat Hair", palette, hatHairNames)
            )
        );

        // Female Headwear
        string[] memory headwearNames = new string[](3);
        headwearNames[0] = "None";
        headwearNames[1] = "Cap Blue";
        headwearNames[2] = "Beanie Red";
        assets.addAsset(
            23,
            LibZip.flzCompress(
                generateTraitGroup("Female Headwear", palette, headwearNames)
            )
        );

        // Female Eye Wear
        string[] memory eyeWearNames = new string[](3);
        eyeWearNames[0] = "None";
        eyeWearNames[1] = "Regular Glasses";
        eyeWearNames[2] = "Shades Blue";
        assets.addAsset(
            24,
            LibZip.flzCompress(
                generateTraitGroup("Female Eye Wear", palette, eyeWearNames)
            )
        );
    }

    function addOtherAssets() internal {
        console.log("Adding mouth and filler assets...");

        uint32[] memory palette = new uint32[](2);
        palette[0] = 0xFF0000FF; // Red
        palette[1] = 0xFFFFFFFF; // White

        // Mouth
        string[] memory mouthNames = new string[](3);
        mouthNames[0] = "None";
        mouthNames[1] = "Smile";
        mouthNames[2] = "Cigarette";
        assets.addAsset(
            25,
            LibZip.flzCompress(generateTraitGroup("Mouth", palette, mouthNames))
        );

        // Filler Traits
        string[] memory fillerNames = new string[](4);
        fillerNames[0] = "None";
        fillerNames[1] = "Female Robot Headwear Cover";
        fillerNames[2] = "Male Pumpkin Headwear Cover";
        fillerNames[3] = "Male Robot Headwear Cover";
        assets.addAsset(
            26,
            LibZip.flzCompress(
                generateTraitGroup("Filler Traits", palette, fillerNames)
            )
        );
    }
}