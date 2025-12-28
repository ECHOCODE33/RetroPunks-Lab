// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { E_Female_Skin, E_Female_Eyes, E_Female_Face, E_Female_Chain, E_Female_Earring, E_Female_Scarf, E_Female_Mask, E_Female_Hair, E_Female_Hat_Hair, E_Female_Headwear, E_Female_Eye_Wear } from "../common/Enums.sol";
import { TraitsContext } from '../common/Structs.sol';
import { LibPRNG } from "../libraries/LibPRNG.sol";


interface IFemaleProbs {
    function selectFemaleSkin(LibPRNG.PRNG memory prng) external pure returns (E_Female_Skin);
    function selectFemaleEyes(TraitsContext calldata traits, LibPRNG.PRNG memory prng) external pure returns (E_Female_Eyes);
    function selectFemaleFace(TraitsContext calldata traits, LibPRNG.PRNG memory prng) external pure returns (E_Female_Face);
    function selectFemaleChain(LibPRNG.PRNG memory prng) external pure returns (E_Female_Chain);
    function selectFemaleScarf(LibPRNG.PRNG memory prng) external pure returns (E_Female_Scarf);
    function selectFemaleEarring(LibPRNG.PRNG memory prng) external pure returns (E_Female_Earring);
    function selectFemaleMask(LibPRNG.PRNG memory prng) external pure returns (E_Female_Mask);
    function selectFemaleHair(TraitsContext calldata traits, LibPRNG.PRNG memory prng) external pure returns (E_Female_Hair);
    function selectFemaleHatHair(TraitsContext calldata traits, LibPRNG.PRNG memory prng) external pure returns (E_Female_Hat_Hair);
    function selectFemaleHeadwear(LibPRNG.PRNG memory prng) external pure returns (E_Female_Headwear);
    function selectFemaleEyeWear(LibPRNG.PRNG memory prng) external pure returns (E_Female_Eye_Wear);
}       