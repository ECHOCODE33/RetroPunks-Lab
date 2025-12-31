// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { E_Mouth } from "../common/Enums.sol";
import { TraitsContext, MaleTraits } from '../common/Structs.sol';
import { LibPRNG } from "../libraries/LibPRNG.sol";


interface IMaleProbs {
    function selectAllMaleTraits(TraitsContext memory ctx, LibPRNG.PRNG memory prng) external pure returns (MaleTraits memory);
    function selectMouth(TraitsContext memory ctx, LibPRNG.PRNG memory prng) external pure returns (E_Mouth);
}       