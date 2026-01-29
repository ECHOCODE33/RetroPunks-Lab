// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Assets} from "../src/Assets.sol"; // Adjust path to your Assets contract

contract CheckMouthAsset is Script {
    function run() external view {
        // Replace with your Assets contract address from the deployment
        address assetsAddress = 0x959922bE3CAee4b8Cd9a407cc3ac1C251C2007B1;

        Assets assets = Assets(assetsAddress);

        // Call loadAsset (decompressed) for key 25 (Mouth Group)
        bytes memory data = assets.loadAsset(25, true);

        // Log the length — should be >0 for valid data (e.g., hundreds of bytes for RLE + headers)
        console.log("Decompressed Length for Key 25: %s", data.length);

        // Log the full data (hex) — if empty, it will show nothing or 0x
        console.logBytes(data);

        // If length == 0, it's the problem
        if (data.length == 0) {
            console.log("WARNING: Decompressed data is EMPTY, this causes TraitGroupNotLoaded");
        } else {
            console.log("SUCCESS: Data exists, check if it's valid RLE");
        }
    }
}
