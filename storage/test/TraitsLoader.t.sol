// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import { TraitsLoader } from "../src/libraries/TraitsLoader.sol";
import { IAssets } from "../src/interfaces/IAssets.sol";
import { TraitGroup, TraitInfo, CachedTraitGroups } from "../src/common/Structs.sol";

// ----------------------------------------------------------------------------
// 1. Mock Asset Contract
// ----------------------------------------------------------------------------
contract MockAssets is IAssets {
    mapping(uint256 => bytes) private _assets;

    function addAsset(uint256 key, bytes memory asset) external override {
        _assets[key] = asset;
    }

    function loadAssetDecompressed(uint256 key) external view override returns (bytes memory) {
        return _assets[key];
    }

    function loadAssetOriginal(uint256 key) external view override returns (bytes memory) {
        return _assets[key];
    }
}

// ----------------------------------------------------------------------------
// 2. Main Test Contract
// ----------------------------------------------------------------------------
contract TraitsLoaderTest is Test {
    MockAssets assetsContract;

    function setUp() public {
        assetsContract = new MockAssets();
    }
    function test_DeepLoadAndLogTraitGroup() public {
        // ====================================================================
        // PASTE YOUR HEX STRING HERE
        // ====================================================================
        bytes memory dummyAsset = hex"0a4261636b67726f756e640008f24e4eff000000ffffffffff333333ffccccccffff0000ff00ff00ff0000ffff010500000000000001075261696e626f77000100000000020952656420536f6c696400000200000001030f536d6f6f746820566572746963616c01020002000001000711536d6f6f746820486f72697a6f6e74616c03040003000001010b11446961676f6e616c204772616469656e74050607"; 

        if (dummyAsset.length == 0) {
            console.log("Error: dummyAsset is empty. Please paste your hex string.");
            return;
        }

        uint256 groupId = 1;
        assetsContract.addAsset(groupId, dummyAsset);

        // Initialize cache
        CachedTraitGroups memory cache = TraitsLoader.initCachedTraitGroups(10);
        
        console.log("\n--- STARTING DEEP TRAIT GROUP DECODE ---");

        TraitGroup memory result;
        
        // Using the proxy to allow try/catch on library calls
        try this.runLoaderProxy(address(assetsContract), cache, groupId) returns (TraitGroup memory _result) {
            result = _result;
        } catch Error(string memory reason) {
            console.log("Revert Reason:", reason);
            fail();
            return;
        } catch (bytes memory lowLevelData) {
            console.log("Low-level Revert:");
            console.logBytes(lowLevelData);
            fail();
            return;
        }

        // ====================================================================
        // LOGGING: TraitGroup Struct
        // ====================================================================
        console.log("===================================================");
        console.log("STRUCT: TraitGroup");
        console.log("===================================================");
        console.log("traitGroupIndex:     ", result.traitGroupIndex);
        console.log("traitGroupName:      ", string(result.traitGroupName));
        console.log("paletteIndexByteSize:", result.paletteIndexByteSize);
        console.log("Traits Count:        ", result.traits.length);
        console.log("Palette Size:        ", result.paletteRgba.length);

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

        // ====================================================================
        // LOGGING: TraitInfo Structs
        // ====================================================================
        console.log("\n===================================================");
        console.log("STRUCT: TraitInfo (Array)");
        console.log("===================================================");

        for (uint256 i = 0; i < result.traits.length; i++) {
            TraitInfo memory t = result.traits[i];
            
            console.log("\n---------------------------------------------------");
            console.log(string.concat("Trait ", vm.toString(i)));
            console.log("---------------------------------------------------");
            console.log("traitName: ", string(t.traitName));
            console.log("layerType: ", t.layerType);
            console.log("x1:        ", t.x1);
            console.log("y1:        ", t.y1);
            console.log("x2:        ", t.x2);
            console.log("y2:        ", t.y2);
            console.log("traitData (Raw RLE Bytes):");
            console.logBytes(t.traitData);
            console.log(string.concat("traitData Length: ", vm.toString(t.traitData.length), " bytes"));
        }
        
        console.log("\n--- DECODE COMPLETE ---");
    }

    // Helper to allow try/catch block usage on library calls
    function runLoaderProxy(
        address _assets, 
        CachedTraitGroups memory _cache, 
        uint _idx
    ) external view returns (TraitGroup memory) {
        return TraitsLoader.loadAndCacheTraitGroup(IAssets(_assets), _cache, _idx);
    }
}