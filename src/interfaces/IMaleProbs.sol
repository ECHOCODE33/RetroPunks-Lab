// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { E_Male_Skin, E_Male_Eyes, E_Male_Face, E_Male_Chain, E_Male_Earring, E_Male_Scarf, E_Male_Facial_Hair, E_Male_Mask, E_Male_Hair, E_Male_Hat_Hair, E_Male_Headwear, E_Male_Eye_Wear, E_Mouth } from "../common/Enums.sol";
import { TraitsContext } from '../common/Structs.sol';
import { RandomCtx } from "../libraries/Random.sol";


interface IMaleProbs {
    function selectMaleSkin(RandomCtx memory rndCtx) external pure returns (E_Male_Skin);
    function selectMaleEyes(TraitsContext calldata traits, RandomCtx memory rndCtx) external pure returns (E_Male_Eyes);
    function selectMaleFace(TraitsContext calldata traits, RandomCtx memory rndCtx) external pure returns (E_Male_Face);
    function selectMaleChain(RandomCtx memory rndCtx) external pure returns (E_Male_Chain);
    function selectMaleScarf(RandomCtx memory rndCtx) external pure returns (E_Male_Scarf);
    function selectMaleEarring(RandomCtx memory rndCtx) external pure returns (E_Male_Earring);
    function selectMaleFacialHair(TraitsContext calldata traits, RandomCtx memory rndCtx) external pure returns (E_Male_Facial_Hair);
    function selectMaleMask(RandomCtx memory rndCtx) external pure returns (E_Male_Mask);
    function selectMaleHair(TraitsContext calldata traits, RandomCtx memory rndCtx) external pure returns (E_Male_Hair);
    function selectMaleHatHair(TraitsContext calldata traits, RandomCtx memory rndCtx) external pure returns (E_Male_Hat_Hair);
    function selectMaleHeadwear(RandomCtx memory rndCtx) external pure returns (E_Male_Headwear);
    function selectMaleEyeWear(RandomCtx memory rndCtx) external pure returns (E_Male_Eye_Wear);
    function selectMouth(TraitsContext calldata traits, RandomCtx memory rndCtx) external pure returns (E_Mouth);
}       