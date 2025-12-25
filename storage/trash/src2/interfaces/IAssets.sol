// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

interface IAssets {
    function addAsset(uint key, bytes memory asset) external;
    function addAssetsBatch(uint[] calldata keys, bytes[] calldata assets) external;
    function removeAsset(uint key) external;
    function loadAssetOriginal(uint key) external view returns (bytes memory);
    function loadAssetDecompressed(uint key) external view returns (bytes memory);
}
