// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { SSTORE2 } from "./libraries/SSTORE2.sol";
import { LibZip } from "./libraries/LibZip.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IAssets } from "./interfaces/IAssets.sol";

/**
 * @title Assets
 * @notice Efficient on-chain asset storage using SSTORE2 & LZ77 compression
 *
 * @author ECHO
 */

contract Assets is Ownable, IAssets {

    error EmptyAsset();
    error EmptyAssetInBatch();
    error AssetKeyLengthMismatch();
    error AssetDoesNotExist();
    
    event AssetAdded(uint indexed key, address indexed pointer, uint size);
    event AssetRemoved(uint indexed key);
    
    mapping(uint => address) private _assetsMap;

    constructor() Ownable(msg.sender) {}

    function addAsset(uint key, bytes memory asset) external onlyOwner {
        if (asset.length == 0) revert EmptyAsset();
        
        address pointer = SSTORE2.write(asset);
        _assetsMap[key] = pointer;
        
        emit AssetAdded(key, pointer, asset.length);
    }
    
    function addAssetsBatch(uint[] calldata keys, bytes[] calldata assets) external onlyOwner {
        if (keys.length != assets.length) revert AssetKeyLengthMismatch();
        
        for (uint i = 0; i < keys.length; i++) {
            if (assets[i].length == 0) revert EmptyAssetInBatch();
            
            address pointer = SSTORE2.write(assets[i]);
            _assetsMap[keys[i]] = pointer;
            
            emit AssetAdded(keys[i], pointer, assets[i].length);
        }
    }

    function removeAsset(uint key) external onlyOwner {
        if (_assetsMap[key] == address(0)) revert AssetDoesNotExist();
        
        delete _assetsMap[key];
        emit AssetRemoved(key);
    }
    
    function removeAssetsBatch(uint[] calldata keys) external onlyOwner {
        for (uint i = 0; i < keys.length; i++) {
            uint key = keys[i];

            delete _assetsMap[key];
            
            emit AssetRemoved(key);
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