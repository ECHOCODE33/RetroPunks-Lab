// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @author EtoVass
 */

interface IAssetsSSTORE2 {
    function addAsset(uint key, bytes memory asset) external;
    function loadAsset(uint key) external view returns (bytes memory);
    function loadAsset(uint key, bool decompress) external view returns (bytes memory);
}