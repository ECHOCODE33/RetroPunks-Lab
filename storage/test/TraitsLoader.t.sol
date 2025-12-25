// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/libraries/TraitsLoader.sol";
import "../src/libraries/LibZip.sol"; 
import "../src/common/Structs.sol";
import "../src/interfaces/IAssets.sol";

contract MockAssets is IAssets {
    mapping(uint => bytes) internal assets;

    function addAsset(uint key, bytes memory asset) external {
        require(asset.length > 0, "Empty asset");
        assets[key] = asset; 
    }

    function loadAssetDecompressed(uint key) external view override returns (bytes memory) {
        bytes memory asset = assets[key];
        return LibZip.flzDecompress(asset);
    }

    function loadAssetOriginal(uint key) external view override returns (bytes memory) {
        return assets[key];
    }
}

contract TraitsLoaderTest is Test {
    MockAssets mock;

    function setUp() public {
        mock = new MockAssets();
    }

    function test_loadCustomBytes() public {

        bytes memory customData = hex"";
        
        mock.addAsset(99, customData);
        
        CachedTraitGroups memory cached = TraitsLoader.initCachedTraitGroups(100);
        TraitGroup memory group = TraitsLoader.loadAndCacheTraitGroup(IAssets(address(mock)), cached, 99);

        console.log("\nDecoded Group Name:", string(group.traitGroupName));
        console.log("Palette Size:", group.paletteRgba.length);
        console.log("Trait Count:", group.traits.length);
    }
}