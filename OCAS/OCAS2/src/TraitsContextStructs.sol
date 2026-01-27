// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./TraitContextGenerated.sol";

/**
 * @author EtoVass
 */

struct TraitInfo2 {
    bytes traitName;

    uint8 x1;
    uint8 y1;
    uint8 x2;
    uint8 y2;

    uint8[] traitData;
}

struct TraitGroup {
    uint traitGroupIndex;
    bytes traitGroupName;
    string[] palette;
    uint32[] paletteRgba;

    TraitInfo2[] traits;
}

struct CachedTraitGroups {
    TraitGroup[] traitGroups;
    bool[] traitGroupsLoaded;
}

struct FillerTrait {
    E_TraitsGroup traitGroup;
    uint8 traitIndex;
}

struct TraitToRender {
    E_TraitsGroup traitGroup;
    uint8 traitIndex;
    int8 traitId;

    bool hasFiller;
    bool fillerRenderedAtTheEnd;
    FillerTrait filler;
}

struct TraitsContext {
    E_Background background;

    TraitToRender[] traitsToRender;
    uint traitsToRenderLength;

    uint numTattoos;
    uint numJewelry;
    bool masculine;
    bool isAngel;

    E_1_Type bodyType;
    E_Mouth mouth;
    E_10_Headwear headwear;
    E_3_Clothes clothes;
    E_3b_Clothes clothes2;
    E_6b_Eye_Wear eyeWear;
    E_5_Hair hair;
    E_9_Facial_Hair facialHair;

    uint tattooId;
    uint jewelryId; 
    uint clothesId;

    uint specialId;

    uint tokenId;
    uint tokenIdSeed;
}
