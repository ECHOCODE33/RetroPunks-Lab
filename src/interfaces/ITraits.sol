// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { TraitsContext } from '../common/Structs.sol';


interface ITraits {
    function generateAllTraits(uint16 _tokenIdSeed, uint16 _backgroundIndex, uint _seed) external view returns (TraitsContext memory);
}