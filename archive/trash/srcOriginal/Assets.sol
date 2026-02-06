// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { SSTORE2 } from "./libraries/SSTORE2.sol";
import { LibZip } from "./libraries/LibZip.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IAssets } from "./interfaces/IAssets.sol";

contract Assets is Ownable, IAssets {

    mapping(uint => address) private _assetsMap;

    constructor() Ownable(msg.sender) {}

    function addAsset(uint key, bytes memory asset) external onlyOwner {
        address pointer = SSTORE2.write(asset); 
        _assetsMap[key] = pointer;
    }

    function loadAssetOriginal(uint key) external view returns (bytes memory) {
        return _loadAsset(key, false);
    }

    function loadAssetDecompressed(uint key) external view returns (bytes memory) {
        return _loadAsset(key, true);
    }

    function _loadAsset(uint key, bool decompress) internal view returns (bytes memory) {
        address pointer = _assetsMap[key];

        require(pointer != address(0), "Asset does not exist");

        bytes memory asset = SSTORE2.read(pointer);

        if (decompress) {
            asset = LibZip.flzDecompress(asset);
        }

        return asset;
    }
}