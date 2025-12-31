// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import { Assets } from "../src/Assets.sol";
import { IAssets } from "../src/interfaces/IAssets.sol";
import { TraitsLoader } from "../src/libraries/TraitsLoader.sol";
import { TraitGroup, TraitInfo, CachedTraitGroups } from "../src/common/Structs.sol";

contract TraitsLoaderTest is Test {
    Assets public assetsContract;

    function setUp() public {
        assetsContract = new Assets();
    }

    function test_DeepLoadAndLogTraitGroup() public {
        // ====================================================================
        // PASTE YOUR HEX STRING HERE
        // ====================================================================
        bytes memory dummyAsset = hex"";

        if (dummyAsset.length == 0) {
            console.log("Error: dummyAsset is empty. Please paste your hex string.");
            return;
        }

        uint256 groupId = 0;
        assetsContract.addAsset(groupId, dummyAsset);

        CachedTraitGroups memory cache = TraitsLoader.initCachedTraitGroups(30);

        console.log("\n--- STARTING DEEP TRAIT GROUP DECODE ---");

        TraitGroup memory result;

        try this.runLoaderProxy(address(assetsContract), cache, groupId) returns (TraitGroup memory _result) {
            result = _result;
        } catch Error(string memory reason) {
            console.log("Revert Reason:", reason);
            fail();
            return;
        } catch (bytes memory lowLevelData) {
            console.log("Low-level Revert. Data length:", lowLevelData.length);
            fail();
            return;
        }

        _logResults(result);
    }

    // ================================================================
    // PRETTY LOGGING
    // ================================================================
    function _logResults(TraitGroup memory result) internal pure {
        console.log("===================================================");
        console.log("STRUCT: TraitGroup");
        console.log("===================================================");
        console.log("traitGroupIndex:     ", result.traitGroupIndex);
        console.log("traitGroupName:      ", string(result.traitGroupName));
        console.log("paletteIndexByteSize:", result.paletteIndexByteSize);
        console.log("Traits Count:        ", result.traits.length);
        console.log("Palette Size:        ", result.paletteRgba.length);

        // ---------------- PALETTE ----------------
        console.log("\n--- paletteRgba ---");
        for (uint256 p = 0; p < result.paletteRgba.length; p++) {
            uint32 color = result.paletteRgba[p];
            console.log(string.concat("Index ", vm.toString(p), ":"));
            console.logBytes4(bytes4(color));
            console.log(
                string.concat(
                    "  R:", vm.toString(uint8(color >> 24)),
                    " G:", vm.toString(uint8(color >> 16)),
                    " B:", vm.toString(uint8(color >> 8)),
                    " A:", vm.toString(uint8(color))
                )
            );
        }

        // ---------------- TRAITS ----------------
        console.log("\n===================================================");
        console.log("STRUCT: TraitInfo (Array)");
        console.log("===================================================");

        for (uint256 i = 0; i < result.traits.length; i++) {
            TraitInfo memory t = result.traits[i];

            console.log("\n---------------------------------------------------");
            console.log(string.concat("Trait ", vm.toString(i)));
            console.log("---------------------------------------------------");
            console.log("traitName: ", "'", string(t.traitName), "'");
            console.log("layerType: ", t.layerType);
            console.log("x1:        ", t.x1);
            console.log("y1:        ", t.y1);
            console.log("x2:        ", t.x2);
            console.log("y2:        ", t.y2);

            // console.log("traitData (Raw RLE Bytes):");
            // console.logBytes(t.traitData);
            console.log(
                string.concat(
                    "traitData Length: ",
                    vm.toString(t.traitData.length),
                    " bytes"
                )
            );
        }
    }

    // ================================================================
    // PROXY CALL (to allow try/catch on library)
    // ================================================================
    function runLoaderProxy(
        address _assets,
        CachedTraitGroups memory _cache,
        uint _idx
    ) external view returns (TraitGroup memory) {
        return TraitsLoader.loadAndCacheTraitGroup(IAssets(_assets), _cache, _idx);
    }
}
