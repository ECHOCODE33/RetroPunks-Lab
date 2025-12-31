// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { TraitsContext, MaleTraits, FemaleTraits } from '../common/Structs.sol';
import { LibPRNG } from "../libraries/LibPRNG.sol";


interface IProbs {
    function selectAllFemaleTraits(TraitsContext memory ctx, LibPRNG.PRNG memory prng) external pure returns (FemaleTraits memory);
    function selectAllMaleTraits(TraitsContext memory ctx, LibPRNG.PRNG memory prng) external pure returns (MaleTraits memory);
}       