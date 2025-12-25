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
        bytes memory dummyAsset = hex"0b46656d616c652046616365000c00000000333333ff000000ff000000ccff0000ffff005533404040ff00000066d9a682ffbf8760ff0000008000000099011300000000000000044e6f6e650014121e1621000c41726d6f7220546174746f6f02030100020301000303020003030200030301000010121e1521000a41786520546174746f6f01000307020001030107010001030100010701030300000c101e151f000742616e6461676502080209040802090208003812181f1b000b42696f6e696320457965730402060008020600040202040202060002040202020402020600020402020020101e1f1f0005426c75736804050a0006050a000205000c131e1521000c43726f737320546174746f6f01000103010003030100010302000103010000541a141f21000d4379626572657965204c656674020004010200060102060401020602010e020204040202040e0202000401020004010400020104000201008c0c141521000e43796265726579652052696768740400040106000401040004010206020102000401020606010602040106020401020202040202040102020204020204010602040106020801020008010400040106000401040002000e101d2f0009437962657266616365040004010c0004010a000201020604010800020102060401080008010800080108000a0106000a01040002010602040104000201060204010400020102020204020204010400020102020204020204010400020106020401040002010602040106000c0104000c010400080102000401020008010200040102000e0102000e010200060106000201020006010600020104000c0104000c0104000201020006010600020102000601060004010c0004010c0006010a0006010a0006010a00060106000006131e151f000a47756e20546174746f6f040302000014121e1621000c486561727420546174746f6f010001030100010301000503010003030300010302000009131e1520000a4a657420546174746f6f0303010002030200010300101c181f1b000f4c6566742042696f6e6963204579650802020402020204020200041220132100044d6f6c65040a00101218151b001052696768742042696f6e69632045796508020204020202040202000a121e161f000e53686f7467756e20546174746f6f0103020b030304000010121e1521000c53776f726420546174746f6f0300010701030100010702000103020001070100010301000009131e152000085820546174746f6f010301000103010001030100010301000103"; 

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