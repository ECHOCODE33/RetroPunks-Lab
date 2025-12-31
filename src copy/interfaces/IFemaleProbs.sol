// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { TraitsContext, FemaleTraits } from '../common/Structs.sol';
import { LibPRNG } from "../libraries/LibPRNG.sol";


interface IFemaleProbs {
    function selectAllFemaleTraits(TraitsContext memory ctx, LibPRNG.PRNG memory prng) external pure returns (FemaleTraits memory);
}       