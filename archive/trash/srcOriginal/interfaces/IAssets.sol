// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


interface IAssets {
    function addAsset(uint key, bytes memory asset) external;
    function loadAssetOriginal(uint key) external view returns (bytes memory);
    function loadAssetDecompressed(uint key) external view returns (bytes memory);
}