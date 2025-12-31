// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { IAssets } from "./interfaces/IAssets.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { SSTORE2 } from "./libraries/SSTORE2.sol";
import { LibZip } from "./libraries/LibZip.sol";

/**
 * @author ECHO
 */

contract Assets is Ownable, IAssets {
    error EmptyAsset();
    error EmptyAssetInBatch();
    error AssetKeyLengthMismatch();
    error AssetDoesNotExist();
    
    mapping(uint256 => address) private _assetsMap;

    constructor() Ownable(msg.sender) {}

    function addAsset(uint256 key, bytes calldata asset) external onlyOwner {
        if (asset.length == 0) revert EmptyAsset();
        
        address pointer = SSTORE2.write(asset);
        _assetsMap[key] = pointer;
    }
    
    function addAssetsBatch(uint256[] calldata keys, bytes[] calldata assets) external onlyOwner {
        uint256 length = keys.length;
        if (length != assets.length) revert AssetKeyLengthMismatch();
        
        for (uint256 i = 0; i < length; ) {
            if (assets[i].length == 0) revert EmptyAssetInBatch();
            
            _assetsMap[keys[i]] = SSTORE2.write(assets[i]);
            
            unchecked { ++i; }
        }
    }

    function removeAssets(uint256[] calldata keys) external onlyOwner {
        uint256 length = keys.length;
        for (uint256 i = 0; i < length; ) {
            delete _assetsMap[keys[i]];
            unchecked { ++i; }
        }
    }

    function loadAssetOriginal(uint key) external view returns (bytes memory) {
        return _loadAsset(key, false);
    }

    function loadAssetDecompressed(uint key) external view returns (bytes memory) {
        return _loadAsset(key, true);
    }

    function _loadAsset(uint key, bool decompress) internal view returns (bytes memory) {
        address pointer = _assetsMap[key];

        if (pointer == address(0)) revert AssetDoesNotExist();

        bytes memory asset = SSTORE2.read(pointer);

        if (decompress) {
            asset = LibZip.flzDecompress(asset);
        }

        return asset;
    }
}