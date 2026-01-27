// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {TraitsContext} from "./TraitsContextStructs.sol";

/**
 * @author EtoVass
 */

interface IProbabilities {
    function getBodyTypeProbabilties() external view returns (uint32[12] memory);
    function getMaleClothesProbabilities() external view returns (uint32[26] memory);
    function getFemaleClothesProbabilities() external view returns (uint32[26] memory);
    function getHairProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[] memory);
    function getHatHairProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[49] memory);
    function getClothes2Probabilities(TraitsContext calldata traitsContext) external view returns (uint32[11] memory);
    function getEyesProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[11] memory);
    function getEyewearProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[32] memory);
    function getLipGlossProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[4] memory);
    function getTeethProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[16] memory);
    function getSkeletonTeethProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[16] memory);
    function getApeTeethProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[11] memory);
    function getFacialHairProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[25] memory);
    function getHeadwearProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[] memory);
}