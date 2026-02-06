// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { IAssets } from "./interfaces/IAssets.sol";
import { LibZip } from "./libraries/LibZip.sol";
import { SSTORE2 } from "./libraries/SSTORE2.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Assets
 * @author ECHO
 * @notice Efficient on-chain asset storage, optimized for gas efficiency
 * @dev Batch operations using SSTORE2 & LZ77 compression
 */
contract Assets is Ownable, IAssets {
    error EmptyAssetInBatch();
    error AssetKeyLengthMismatch();
    error AssetDoesNotExist();

    mapping(uint256 => address) private _assets;

    constructor() Ownable(msg.sender) { }

    function addAssetsBatch(uint256[] calldata keys, bytes[] calldata assets) external onlyOwner {
        uint256 length = keys.length;
        if (length != assets.length) revert AssetKeyLengthMismatch();

        for (uint256 i = 0; i < length;) {
            if (assets[i].length == 0) revert EmptyAssetInBatch();

            _assets[keys[i]] = SSTORE2.write(assets[i]);

            unchecked { ++i; }
        }
    }

    function removeAssetsBatch(uint256[] calldata keys) external onlyOwner {
        uint256 length = keys.length;
        for (uint256 i = 0; i < length;) {
            delete _assets[keys[i]];
            unchecked {
                ++i;
            }
        }
    }

    function loadAsset(uint256 key, bool decompress) external view returns (bytes memory) {
        address pointer = _assets[key];

        if (pointer == address(0)) revert AssetDoesNotExist();

        bytes memory asset = SSTORE2.read(pointer);

        if (decompress) asset = LibZip.flzDecompress(asset);

        return asset;
    }
}
