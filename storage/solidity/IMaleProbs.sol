// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { E_Male_Skin, E_Male_Eyes, E_Male_Face, E_Male_Chain, E_Male_Earring, E_Male_Scarf, E_Male_Facial_Hair, E_Male_Mask, E_Male_Hair, E_Male_Hat_Hair, E_Male_Headwear, E_Male_Eye_Wear, E_Mouth } from "../common/Enums.sol";
import { TraitsContext } from '../common/Structs.sol';
import { LibPRNG } from "../libraries/LibPRNG.sol";


interface IMaleProbs {
    function selectMaleSkin(LibPRNG.PRNG memory prng) external pure returns (E_Male_Skin);
    function selectMaleEyes(TraitsContext calldata traits, LibPRNG.PRNG memory prng) external pure returns (E_Male_Eyes);
    function selectMaleFace(TraitsContext calldata traits, LibPRNG.PRNG memory prng) external pure returns (E_Male_Face);
    function selectMaleChain(LibPRNG.PRNG memory prng) external pure returns (E_Male_Chain);
    function selectMaleScarf(LibPRNG.PRNG memory prng) external pure returns (E_Male_Scarf);
    function selectMaleEarring(LibPRNG.PRNG memory prng) external pure returns (E_Male_Earring);
    function selectMaleFacialHair(TraitsContext calldata traits, LibPRNG.PRNG memory prng) external pure returns (E_Male_Facial_Hair);
    function selectMaleMask(LibPRNG.PRNG memory prng) external pure returns (E_Male_Mask);
    function selectMaleHair(TraitsContext calldata traits, LibPRNG.PRNG memory prng) external pure returns (E_Male_Hair);
    function selectMaleHatHair(TraitsContext calldata traits, LibPRNG.PRNG memory prng) external pure returns (E_Male_Hat_Hair);
    function selectMaleHeadwear(LibPRNG.PRNG memory prng) external pure returns (E_Male_Headwear);
    function selectMaleEyeWear(LibPRNG.PRNG memory prng) external pure returns (E_Male_Eye_Wear);
    function selectMouth(TraitsContext calldata traits, LibPRNG.PRNG memory prng) external pure returns (E_Mouth);
}       