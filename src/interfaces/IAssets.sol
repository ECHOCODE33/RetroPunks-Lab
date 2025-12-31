// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

interface IAssets {
    function addAssetsBatch(uint256[] calldata keys, bytes[] calldata assets) external;
    function removeAssetsBatch(uint256[] calldata keys) external;
    function loadAsset(uint256 key, bool decompress) external view returns (bytes memory);
}