// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { SSTORE2 } from "./libraries/SSTORE2.sol";
import { LibZip } from "./libraries/LibZip.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IAssets } from "./interfaces/IAssets.sol";

/**
 * @title Assets
 * @notice Efficient on-chain asset storage using SSTORE2
 * @dev Assets are compressed with LibZip before storage
 * 
 * Gas Optimizations:
 * - Uses SSTORE2 for ~10x cheaper storage vs direct storage
 * - Compressed data reduces storage costs further
 * - Batch operations for multiple assets
 */
contract Assets is Ownable, IAssets {
    
    mapping(uint => address) private _assetsMap;
    
    event AssetAdded(uint indexed key, address indexed pointer, uint size);
    
    event AssetRemoved(uint indexed key);
    
    constructor() Ownable(msg.sender) {}

    /**
     * @notice Add a single compressed asset
     * @param key Unique identifier for this asset
     * @param asset Compressed asset data (use LibZip.flzCompress)
     */
    function addAsset(uint key, bytes memory asset) external onlyOwner {
        require(asset.length > 0, "Empty asset");
        
        address pointer = SSTORE2.write(asset);
        _assetsMap[key] = pointer;
        
        emit AssetAdded(key, pointer, asset.length);
    }
    
    /**
     * @notice Add multiple assets in one transaction (gas efficient)
     * @param keys Array of asset keys
     * @param assets Array of compressed asset data
     */
    function addAssetsBatch(uint[] calldata keys, bytes[] calldata assets) external onlyOwner {
        require(keys.length == assets.length, "Length mismatch");
        
        for (uint i = 0; i < keys.length; i++) {
            require(assets[i].length > 0, "Empty asset");
            
            address pointer = SSTORE2.write(assets[i]);
            _assetsMap[keys[i]] = pointer;
            
            emit AssetAdded(keys[i], pointer, assets[i].length);
        }
    }
    
    /**
     * @notice Remove an asset (frees up the key, but data remains in SSTORE2)
     * @param key Asset key to remove
     */
    function removeAsset(uint key) external onlyOwner {
        require(_assetsMap[key] != address(0), "Asset does not exist");
        
        delete _assetsMap[key];
        emit AssetRemoved(key);
    }

    /**
     * @notice Load asset in original compressed form
     * @param key Asset key
     * @return Compressed asset data
     */
    function loadAssetOriginal(uint key) external view returns (bytes memory) {
        return _loadAsset(key, false);
    }

    /**
     * @notice Load and decompress asset
     * @param key Asset key
     * @return Decompressed asset data
     */
    function loadAssetDecompressed(uint key) external view returns (bytes memory) {
        return _loadAsset(key, true);
    }

    /**
     * @dev Internal load function with optional decompression
     * @param key Asset key
     * @param decompress Whether to decompress the data
     * @return Asset data (compressed or decompressed)
     */
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