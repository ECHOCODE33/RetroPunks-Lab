// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {Assets} from "../src/Assets.sol";

/**
 * @title VerifyAssetsScript
 * @notice Script to verify that all your expected assets are correctly stored
 *         in the Assets contract.
 *
 * Features:
 * - Checks if each key has a non-zero pointer (asset exists).
 * - Optionally loads and decompresses the asset to confirm it can be read.
 * - Prints the actual decompressed size for your reference.
 * - Clean, simple console output without any emojis or special unicode characters.
 *
 * How to use:
 * 1. Update assetsAddress with your deployed Assets contract.
 * 2. Fill in the EXPECTED_ASSETS in setUp() with keys and names (same as upload script).
 * 3. Set FULL_VERIFICATION = true to load+decompress (recommended).
 * 4. Run with `forge script` (no --broadcast needed – view only).
 */
contract VerifyAssets is Script {
    address constant assetsAddress = 0xa513E6E4b8f2a923D98304ec87F64353C4D5C853;

    bool constant FULL_VERIFICATION = false;

    // ====================== EXPECTED ASSETS ======================

    struct ExpectedAsset {
        uint256 key;
        string name;
    }

    ExpectedAsset[] private EXPECTED_ASSETS;

    function setUp() public {
        EXPECTED_ASSETS.push(ExpectedAsset(0, "Special 1s"));
        EXPECTED_ASSETS.push(ExpectedAsset(1, "Background"));
        EXPECTED_ASSETS.push(ExpectedAsset(2, "Male Skin"));
        EXPECTED_ASSETS.push(ExpectedAsset(3, "Male Eyes"));
        EXPECTED_ASSETS.push(ExpectedAsset(4, "Male Face"));
        EXPECTED_ASSETS.push(ExpectedAsset(5, "Male Chain"));
        EXPECTED_ASSETS.push(ExpectedAsset(6, "Male Earring"));
        EXPECTED_ASSETS.push(ExpectedAsset(7, "Male Facial Hair"));
        EXPECTED_ASSETS.push(ExpectedAsset(8, "Male Mask"));
        EXPECTED_ASSETS.push(ExpectedAsset(9, "Male Scarf"));
        EXPECTED_ASSETS.push(ExpectedAsset(10, "Male Hair"));
        EXPECTED_ASSETS.push(ExpectedAsset(11, "Male Hat Hair"));
        EXPECTED_ASSETS.push(ExpectedAsset(12, "Male Headwear"));
        EXPECTED_ASSETS.push(ExpectedAsset(13, "Male Eye Wear"));
        EXPECTED_ASSETS.push(ExpectedAsset(14, "Female Skin"));
        EXPECTED_ASSETS.push(ExpectedAsset(15, "Female Eyes"));
        EXPECTED_ASSETS.push(ExpectedAsset(16, "Female Face"));
        EXPECTED_ASSETS.push(ExpectedAsset(17, "Female Chain"));
        EXPECTED_ASSETS.push(ExpectedAsset(18, "Female Earring"));
        EXPECTED_ASSETS.push(ExpectedAsset(19, "Female Mask"));
        EXPECTED_ASSETS.push(ExpectedAsset(20, "Female Scarf"));
        EXPECTED_ASSETS.push(ExpectedAsset(21, "Female Hair"));
        EXPECTED_ASSETS.push(ExpectedAsset(22, "Female Hat Hair"));
        EXPECTED_ASSETS.push(ExpectedAsset(23, "Female Headwear"));
        EXPECTED_ASSETS.push(ExpectedAsset(24, "Female Eye Wear"));
        EXPECTED_ASSETS.push(ExpectedAsset(25, "Mouth"));
        EXPECTED_ASSETS.push(ExpectedAsset(26, "Filler Traits"));

        EXPECTED_ASSETS.push(ExpectedAsset(105, "Predator Blue"));
        EXPECTED_ASSETS.push(ExpectedAsset(106, "Predator Green"));
        EXPECTED_ASSETS.push(ExpectedAsset(107, "Predator Red"));
        EXPECTED_ASSETS.push(ExpectedAsset(108, "Santa Claus"));
        EXPECTED_ASSETS.push(ExpectedAsset(109, "Shadow Ninja"));
        EXPECTED_ASSETS.push(ExpectedAsset(112, "The Devil"));
        EXPECTED_ASSETS.push(ExpectedAsset(114, "The Portrait"));

        EXPECTED_ASSETS.push(ExpectedAsset(1000, "Rainbow"));
    }

    // ====================== SCRIPT LOGIC ======================

    function run() external view {
        Assets assets = Assets(assetsAddress); // Use interface to avoid internal access

        console.log("Starting verification of Assets contract:");
        console.logAddress(assetsAddress);
        console.log("Total assets to verify: %s", EXPECTED_ASSETS.length);
        console.log(
            "Full verification (decompress): %s",
            FULL_VERIFICATION ? "YES" : "NO"
        );
        console.log("----------------------------------------");

        uint successCount = 0;
        uint failureCount = 0;

        for (uint i = 0; i < EXPECTED_ASSETS.length; i++) {
            ExpectedAsset memory expected = EXPECTED_ASSETS[i];
            uint256 key = expected.key;

            // First: check if the asset exists at all (using a view call that reverts if missing)
            bool exists = true;
            try assets.loadAssetOriginal(key) returns (bytes memory) {
                // If we reach here, the key exists
            } catch {
                exists = false;
            }
            if (!exists) {
                console.log(
                    "[FAIL] Key %s (%s): MISSING (no asset stored)",
                    key,
                    expected.name
                );
                failureCount++;
                continue;
            }

            if (!FULL_VERIFICATION) {
                console.log("[OK] Key %s (%s): EXISTS", key, expected.name);
                successCount++;
                continue;
            }

            // Full verification: try to load and decompress
            try assets.loadAssetDecompressed(key) returns (
                bytes memory decompressed
            ) {
                if (bytes(expected.name).length > 0) {
                    console.log(
                        "[OK] Key %s (%s): VERIFIED (decompressed size: %s bytes)",
                        key,
                        expected.name,
                        decompressed.length
                    );
                } else {
                    console.log(
                        "[OK] Key %s: VERIFIED (decompressed size: %s bytes)",
                        key,
                        decompressed.length
                    );
                }
                successCount++;
            } catch {
                console.log(
                    "[FAIL] Key %s (%s): FAILED TO DECOMPRESS",
                    key,
                    expected.name
                );
                failureCount++;
            }
        }

        console.log("==========================================");
        if (failureCount == 0) {
            console.log("ALL %s ASSETS VERIFIED SUCCESSFULLY!", successCount);
        } else {
            console.log(
                "VERIFICATION COMPLETE: %s SUCCESS | %s FAILED",
                successCount,
                failureCount
            );
        }
    }
}
