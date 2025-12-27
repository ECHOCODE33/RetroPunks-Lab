// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import { Assets } from "../src/Assets.sol";
import { console } from "forge-std/console.sol";

contract VerifyAssets is Script {
    function run() external {
        Assets assets = Assets(0x851356ae760d987E095750cCeb3bC6014560891C);

        uint[] memory keys = new uint[](35);

        // ################ Trait Groups (0–26) ################
        keys[0] = 0;   // Special_1s_Group
        keys[1] = 1;   // Background
        keys[2] = 2;   // Male Skin
        keys[3] = 3;   // Male Eyes
        keys[4] = 4;   // Male Face
        keys[5] = 5;   // Male Chain
        keys[6] = 6;   // Male Earring
        keys[7] = 7;   // Male Facial Hair
        keys[8] = 8;   // Male Mask
        keys[9] = 9;   // Male Scarf
        keys[10] = 10; // Male Hair
        keys[11] = 11; // Male Hat Hair
        keys[12] = 12; // Male Headwear
        keys[13] = 13; // Male Eye Wear

        keys[14] = 14; // Female Skin
        keys[15] = 15; // Female Eyes
        keys[16] = 16; // Female Face
        keys[17] = 17; // Female Chain
        keys[18] = 18; // Female Earring
        keys[19] = 19; // Female Mask
        keys[20] = 20; // Female Scarf
        keys[21] = 21; // Female Hair
        keys[22] = 22; // Female Hat Hair
        keys[23] = 23; // Female Headwear
        keys[24] = 24; // Female Eye Wear

        keys[25] = 25; // Mouth
        keys[26] = 26; // Filler Traits

        // ################ Pre-Rendered Special 1s (105–114) ################
        keys[27] = 105; // Predator Blue
        keys[28] = 106; // Predator Green
        keys[29] = 107; // Predator Red
        keys[30] = 108; // Santa Claus
        keys[31] = 109; // Shadow Ninja
        keys[32] = 112; // The Devil
        keys[33] = 114; // The Portrait

        // ################ Background Images ################
        keys[34] = 1000; // Rainbow

        // Verify each asset
        for (uint i = 0; i < keys.length; i++) {
            (bool success, bytes memory data) = address(assets).call(
                abi.encodeWithSignature("loadAssetDecompressed(uint256)", keys[i])
            );

            string memory message = string.concat(
                "Key: ", vm.toString(keys[i]),
                " | success: ", success ? "true" : "false",
                " | size: ", vm.toString(data.length)
            );
            console.log(message);
        }
    }
}