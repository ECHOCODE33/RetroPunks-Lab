// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { TraitsContext, CachedTraitGroups } from './TraitsContextStructs.sol';

/** 
 * @author EtoVass
 */

interface ITraits {
    function generateAllTraits(uint tokenId, uint backgroundIndex, uint seed) external view returns (TraitsContext memory);
}