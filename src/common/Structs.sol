// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {E_Sex, E_Background, E_Male_Skin, E_Male_Eyes, E_Male_Face, E_Male_Chain, E_Male_Earring, E_Male_Scarf, E_Male_Facial_Hair, E_Male_Mask, E_Male_Hair, E_Male_Hat_Hair, E_Male_Headwear, E_Male_Eye_Wear, E_Female_Skin, E_Female_Eyes, E_Female_Face, E_Female_Chain, E_Female_Earring, E_Female_Scarf, E_Female_Mask, E_Female_Hair, E_Female_Hat_Hair, E_Female_Headwear, E_Female_Eye_Wear, E_Mouth, E_TraitsGroup} from "./Enums.sol";

/**
 * @author ECHO
 */

struct TraitsContext {


    TraitToRender[] traitsToRender;
    uint8 traitsToRenderLength;

    uint16 tokenIdSeed;

    uint16 specialId;

    uint32 birthday;

    E_Sex sex;

    E_Background background;

    E_Male_Skin maleSkin;
    E_Male_Eyes maleEyes;
    E_Male_Face maleFace;
    E_Male_Chain maleChain;
    E_Male_Earring maleEarring;
    E_Male_Facial_Hair maleFacialHair;
    E_Male_Mask maleMask;
    E_Male_Scarf maleScarf;
    E_Male_Hair maleHair;
    E_Male_Hat_Hair maleHatHair;
    E_Male_Headwear maleHeadwear;
    E_Male_Eye_Wear maleEyeWear;

    E_Female_Skin femaleSkin;
    E_Female_Eyes femaleEyes;
    E_Female_Face femaleFace;
    E_Female_Chain femaleChain;
    E_Female_Earring femaleEarring;
    E_Female_Mask femaleMask;
    E_Female_Scarf femaleScarf;
    E_Female_Hair femaleHair;
    E_Female_Hat_Hair femaleHatHair;
    E_Female_Headwear femaleHeadwear;
    E_Female_Eye_Wear femaleEyeWear;

    E_Mouth mouth;
}

struct TraitToRender {
    E_TraitsGroup traitGroup;
    uint8 traitIndex;

    bool hasFiller;
    FillerTrait filler;
}

struct FillerTrait {
    E_TraitsGroup traitGroup;
    uint8 traitIndex;
}

struct CachedTraitGroups {
    TraitGroup[] traitGroups;
    bool[] traitGroupsLoaded;
}

struct TraitGroup {
    uint256 traitGroupIndex;
    bytes traitGroupName;
    uint32[] paletteRgba;

    TraitInfo[] traits;
    uint8 paletteIndexByteSize;
}

struct TraitInfo {
    bytes traitName;
    uint8 layerType;
    uint8 x1;
    uint8 y1;
    uint8 x2;
    uint8 y2;
    bytes traitData;
}

struct MaleTraits {
    E_Male_Skin skin;
    E_Male_Eyes eyes;
    E_Male_Face face;
    E_Male_Chain chain;
    E_Male_Earring earring;
    E_Male_Facial_Hair facialHair;
    E_Male_Mask mask;
    E_Male_Scarf scarf;
    E_Male_Hair hair;
    E_Male_Hat_Hair hatHair;
    E_Male_Headwear headwear;
    E_Male_Eye_Wear eyeWear;
    E_Mouth mouth;
}

struct FemaleTraits {
    E_Female_Skin skin;
    E_Female_Eyes eyes;
    E_Female_Face face;
    E_Female_Chain chain;
    E_Female_Earring earring;
    E_Female_Mask mask;
    E_Female_Scarf scarf;
    E_Female_Hair hair;
    E_Female_Hat_Hair hatHair;
    E_Female_Headwear headwear;
    E_Female_Eye_Wear eyeWear;
    E_Mouth mouth;
}
