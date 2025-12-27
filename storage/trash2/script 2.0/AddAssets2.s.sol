// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import { Assets } from "../src/Assets.sol";
import { LibZip } from "../src/libraries/LibZip.sol";

contract AddAssetsScript is Script {
    function run() external {
        
        address assetsAddress = 0xA51c1fc2f0D1a1b8494Ed1FE312d7C3a78Ed91C0; // Replace with your deployed Assets contract address
        Assets assets = Assets(assetsAddress);

        vm.startBroadcast();

        uint[] memory keys = new uint[](35); 
        bytes[] memory rawAssets = new bytes[](35);


        // ################ Trait Groups ################ \\
            // 0: Special_1s_Group
            keys[0] = 0;
            rawAssets[0] = hex"";

            // 1: Background
            keys[1] = 1;
            rawAssets[1] = hex"";

            // 2: Male Skin
            keys[2] = 2;
            rawAssets[2] = hex"";

            // 3: Male Eyes
            keys[3] = 3;
            rawAssets[3] = hex"";

            // 4: Male Face
            keys[4] = 4;
            rawAssets[4] = hex"";

            // 5: Male Chain
            keys[5] = 5;
            rawAssets[5] = hex"";

            // 6: Male Earring
            keys[6] = 6;
            rawAssets[6] = hex"";

            // 7: Male Facial Hair
            keys[7] = 7;
            rawAssets[7] = hex"";

            // 8: Male Mask
            keys[8] = 8;
            rawAssets[8] = hex"";

            // 9: Male Scarf
            keys[9] = 9;
            rawAssets[9] = hex"";

            // 10: Male Hair
            keys[10] = 10;
            rawAssets[10] = hex"";

            // 11: Male Hat Hair
            keys[11] = 11;
            rawAssets[11] = hex"";

            // 12: Male Headwear
            keys[12] = 12;
            rawAssets[12] = hex"";

            // 13: Male Eye Wear
            keys[13] = 13;
            rawAssets[13] = hex"";



            // 14: Female Skin
            keys[14] = 14;
            rawAssets[14] = hex"";

            // 15: Female Eyes
            keys[15] = 15;
            rawAssets[15] = hex"";

            // 16: Female Face
            keys[16] = 16;
            rawAssets[16] = hex"";

            // 17: Female Chain
            keys[17] = 17;
            rawAssets[17] = hex"";

            // 18: Female Earring
            keys[18] = 18;
            rawAssets[18] = hex"";

            // 19: Female Mask
            keys[19] = 19;
            rawAssets[19] = hex"";

            // 20: Female Scarf
            keys[20] = 20;
            rawAssets[20] = hex"";

            // 21: Female Hair
            keys[21] = 21;
            rawAssets[21] = hex"";

            // 22: Female Hat Hair
            keys[22] = 22;
            rawAssets[22] = hex"";

            // 23: Female Headwear
            keys[23] = 23;
            rawAssets[23] = hex"";

            // 24: Female Eye Wear
            keys[24] = 24;
            rawAssets[24] = hex"";



            // 25: Mouth
            keys[25] = 25;
            rawAssets[25] = hex"";

            // 26: Filler Traits
            keys[26] = 26;
            rawAssets[26] = hex"";



        // ################ Pre-Rendered Special 1s ################ \\
            // Predator Blue
            keys[27] = 105; 
            rawAssets[27] = hex"";

            // Predator Green
            keys[28] = 106;
            rawAssets[28] = hex"";

            // Predator Red
            keys[29] = 107;
            rawAssets[29] = hex"";

            // Santa Claus
            keys[30] = 108;
            rawAssets[30] = hex"";

            // Shadow Ninja
            keys[31] = 109;
            rawAssets[31] = hex"";

            // The Devil
            keys[32] = 112;
            rawAssets[32] = hex"";

            // The Portrait
            keys[33] = 114;
            rawAssets[33] = hex"";


        // ################ Background Images ################ \\
            // Rainbow
            keys[34] = 1000;
            rawAssets[34] = hex"";

        bytes[] memory finalAssets = new bytes[](35);

        for (uint256 i = 0; i < rawAssets.length; i++) {
            if (rawAssets[i].length == 0) continue;

            // Skip compression for Rainbow and Pre-Rendered Specials
            if (
                keys[i] == 1000 ||
                keys[i] == 105 ||
                keys[i] == 106 ||
                keys[i] == 107 ||
                keys[i] == 108 ||
                keys[i] == 109 ||
                keys[i] == 112 ||
                keys[i] == 114
            ) {
                finalAssets[i] = rawAssets[i];
                console.log("Adding Raw Asset (No Compression):", keys[i]);
            } else {
                finalAssets[i] = LibZip.flzCompress(rawAssets[i]);
                console.log("Adding Compressed Asset:", keys[i]);
            }
        }

        uint batchSize = 10; 
        for (uint256 start = 0; start < keys.length; start += batchSize) {
            uint256 end = start + batchSize > keys.length ? keys.length : start + batchSize;

            uint[] memory batchKeys = new uint[](end - start);
            bytes[] memory batchAssets = new bytes[](end - start);

            for (uint256 j = 0; j < end - start; j++) {
                batchKeys[j] = keys[start + j];
                batchAssets[j] = finalAssets[start + j];
            }

            assets.addAssetsBatch(batchKeys, batchAssets);
            console.log("Successfully added batch from index", start, "to", end - 1);
        }

        vm.stopBroadcast();
    }
}
