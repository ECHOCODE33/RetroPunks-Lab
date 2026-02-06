// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { SSTORE2 } from "./SSTORE2.sol";
import { LibZip } from "./LibZip.sol";
import { IAssetsSSTORE2 } from "./IAssetsSSTORE2.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @author EtoVass
 */

struct FS {
    mapping (uint key => address) assets;
}

contract AssetsSSTORE2 is Ownable, IAssetsSSTORE2 {
    FS private fs;

    constructor() Ownable(msg.sender) {}

    function addAsset(uint key, bytes memory asset) external onlyOwner {
        fs.assets[key] = SSTORE2.write(asset);
    }
    /*
        Loads the asset and decompresses it.
    */
    function loadAsset(uint key) external view returns (bytes memory) {
        return loadAssetInternal(key, false);
    }

    /*
        Loads the asset and optionally decompress it.
    */
    function loadAsset(uint key, bool decompress) external view returns (bytes memory) {
        return loadAssetInternal(key, decompress);
    }

    function loadAssetInternal(uint key, bool decompress) internal view returns (bytes memory) {
        address pointer = fs.assets[key];

        require(pointer != address(0), "Asset does not exist");
        
        bytes memory asset = SSTORE2.read(pointer);
        
        if (decompress) {
            return LibZip.flzDecompress(asset);
        }
        
        return asset;
    }
}