// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import { Assets } from "../src/Assets.sol";

contract AddAsset is Script {
    function run() external {

        address assetsAddr = 0x135daAd83D2069c1211daf1A5262cf9De2B6ea33;

        Assets assets = Assets(assetsAddr);

        vm.startBroadcast();

        uint256 key = 10;

        bytes memory asset = hex"";

        assets.addAsset(key, asset);

        vm.stopBroadcast();
    }
}