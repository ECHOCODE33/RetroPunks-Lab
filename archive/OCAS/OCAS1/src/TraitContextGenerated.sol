// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { Random, RandomCtx } from "./common/Random.sol";
import { IAssetsSSTORE2 } from "./sstore2/IAssetsSSTORE2.sol";
import { Utils } from "./common/Utils.sol";
import { DynamicBuffer } from "./common/DynamicBuffer.sol";

uint constant NUM_0_Special_1s = 6;
uint constant NUM_1_Type = 12;
uint constant NUM_2_Tattoos = 15;
uint constant NUM_3_Clothes = 26;
uint constant NUM_3b_Clothes = 11;
uint constant NUM_4_Jewellery = 8;
uint constant NUM_5_Hair = 120;
uint constant NUM_5b_Hat_Hair = 49;
uint constant NUM_6_Eyes = 11;
uint constant NUM_6b_Eye_Wear = 32;
uint constant NUM_7_Lip_Gloss = 4;
uint constant NUM_8_Teeth = 16;
uint constant NUM_8b_Ape_Teeth = 11;
uint constant NUM_9_Facial_Hair = 25;
uint constant NUM_10_Headwear = 53;
uint constant NUM_10b_Skeleton_Hoodie_Filler = 1;
uint constant NUM_11_Smoking = 3;
uint constant NUM_Background = 103;
uint constant NUM_Mouth = 11;

uint constant NUM_New_Fillers = 8;

enum E_0_Special_1s {
    Ant_Blue,
    Ant_Green,
    Ant_Red,
    Ant_Teal,
    Ant_Yellow,
    Blueprint
}

enum E_1_Type {
    Alien,
    Ape,
    Demonic,
    Human_1,
    Human_2,
    Human_3,
    Human_4,
    Human_5,
    Human_6,
    Radioactive,
    Skeleton,
    Zombie
}

enum E_2_Tattoos {
    None,
    Alligator,
    Checkerboard,
    Crucifix,
    Diamond,
    Elephant_Colour,
    Elephant,
    Mandalla_Colour,
    Mandalla,
    Skull_X_Bones,
    Sleeves_Colour,
    Sleeves,
    Spider_Web,
    Tear_Drop,
    Tribal_Face_Tat
}

enum E_3_Clothes {
    Bare_Chest,
    Croptop_Black,
    Croptop_Blue,
    Croptop_Burgundy,
    Croptop_Green,
    Croptop_Pink,
    Croptop_Red,
    Croptop_White,
    Long_Sleeved_Shirt_Black,
    Long_Sleeved_Shirt_Blue,
    Long_Sleeved_Shirt_Burgundy,
    Long_Sleeved_Shirt_Green,
    Long_Sleeved_Shirt_Red,
    Long_Sleeved_Shirt_White,
    Tshirt_Black,
    Tshirt_Blue,
    Tshirt_Burgundy,
    Tshirt_Green,
    Tshirt_Red,
    Tshirt_White,
    Vest_Black,
    Vest_Blue,
    Vest_Burgundy,
    Vest_Green,
    Vest_Red,
    Vest_White
}

enum E_3b_Clothes {
    None,
    Leather_Jacket_Black,
    Leather_Jacket_Cream,
    Leather_Jacket_Red,
    Open_Shirt_Baby_Blue,
    Open_Shirt_Black,
    Open_Shirt_Pink,
    Open_Shirt_Red,
    Open_Shirt_Teal,
    Open_Shirt_White,
    Open_Shirt_Yellow
}

enum E_4_Jewellery {
    None,
    Diamond_Chain,
    Diamond_Earring,
    Gold_Bracelet_Left,
    Gold_Bracelet_Right,
    Gold_Chain,
    Gold_Choker,
    Gold_Earring
}

enum E_5_Hair {
    Shaved,
    Beehive_White,
    Beehive_Mint,
    Beehive_Lavender,
    Beehive_Ginger,
    Beehive_Flamingo,
    Beehive_Brown,
    Beehive_Blonde,
    Beehive_Black,
    Bald_Mullet_Black,
    Bald_Mullet_Blonde,
    Bald_Mullet_Brown,
    Bald_Mullet_White,
    Brit_Pop_Cut_Black,
    Brit_Pop_Cut_Blonde,
    Brit_Pop_Cut_Brown,
    Brit_Pop_Cut_Ginger,
    Buzz_Cut_Black,
    Buzz_Cut_Blonde,
    Buzz_Cut_Brown,
    Buzz_Cut_Ginger,
    Clean_Cut_Black,
    Clean_Cut_Blonde,
    Clean_Cut_Brown,
    Clean_Cut_Flamingo,
    Clean_Cut_Ginger,
    Clean_Cut_Lavender,
    Clean_Cut_Mint,
    Flat_Top_Black,
    Flat_Top_Blonde,
    Fro_Black,
    Fro_Blonde,
    Fro_Blue,
    Fro_Green,
    Fro_Red,
    Funky_Black,
    Funky_Blonde,
    Funky_Blue,
    Funky_Brown,
    Funky_Ginger,
    Funky_Green,
    Funky_Purple,
    Funky_Red,
    Funky_Teal,
    Funky_White,
    Hillbilly_Black_Skeleton,
    Hillbilly_Black,
    Hillbilly_Blonde_Skeleton,
    Hillbilly_Blonde,
    Hillbilly_Blue_Skeleton,
    Hillbilly_Blue,
    Hillbilly_Brown_Skeleton,
    Hillbilly_Brown,
    Hillbilly_Ginger_Skeleton,
    Hillbilly_Ginger,
    Hillbilly_Green_Skeleton,
    Hillbilly_Green,
    Hillbilly_Purple_Skeleton,
    Hillbilly_Purple,
    Hillbilly_Red_Skeleton,
    Hillbilly_Red,
    Hillbilly_White_Skeleton,
    Hillbilly_White,
    Locks_Black,
    Locks_Blonde,
    Locks_Blue,
    Locks_Brown,
    Locks_Ginger,
    Locks_Green,
    Locks_Purple,
    Locks_Red,
    Locks_White,
    Long_Straight_Black,
    Long_Straight_Blonde,
    Long_Straight_Brown,
    Long_Straight_Flamingo,
    Long_Straight_Ginger,
    Long_Straight_Lavender,
    Long_Straight_Mint,
    Long_Wavy_Black,
    Long_Wavy_Blonde,
    Long_Wavy_Brown,
    Marine_Cut_Black,
    Marine_Cut_Blonde,
    Messy_Black,
    Messy_Blonde,
    Messy_Brown,
    Messy_Ginger,
    Mohawk_Black,
    Mohawk_Blonde,
    Mohawk_Blue,
    Mohawk_Ginger,
    Mohawk_Green,
    Mohawk_Purple,
    Mohawk_Red,
    Mohawk_Teal,
    Mohawk_White,
    Neat_Black,
    Neat_Blonde,
    Neat_Brown,
    Neat_Ginger,
    Pig_Tails_Black,
    Pig_Tails_Blonde,
    Pig_Tails_Flamingo,
    Quiff_Black,
    Quiff_Blonde,
    Quiff_Brown,
    Spikey_Black,
    Spikey_Blonde,
    Spikey_Blue,
    Spikey_Brown,
    Spikey_Ginger,
    Spikey_Green,
    Spikey_Purple,
    Spikey_Red,
    Spikey_White,
    Tight_Black,
    Tight_Blonde,
    Tight_Brown,
    Tight_Ginger
}

enum E_5b_Hat_Hair {
    None,
    Funky_Black_Hat,
    Funky_Blonde_Hat,
    Funky_Blue_Hat,
    Funky_Brown_Hat,
    Funky_Ginger_Hat,
    Funky_Green_Hat,
    Funky_Purple_Hat,
    Funky_Red_Hat,
    Funky_Teal_Hat,
    Funky_White_Hat,
    Hillbilly_Black_Hat,
    Hillbilly_Blonde_Hat,
    Hillbilly_Blue_Hat,
    Hillbilly_Brown_Hat,
    Hillbilly_Ginger_Hat,
    Hillbilly_Green_Hat,
    Hillbilly_Purple_Hat,
    Hillbilly_Red_Hat,
    Hillbilly_White_Hat,
    Long_Straight_Black_Hat,
    Long_Straight_Blonde_Hat,
    Long_Straight_Brown_Hat,
    Long_Straight_Flamingo_Hat,
    Long_Straight_Ginger_Hat,
    Long_Straight_Lavender_Hat,
    Long_Straight_Mint_Hat,
    Long_Wavy_Black_Hat,
    Long_Wavy_Blonde_Hat,
    Long_Wavy_Brown_Hat,
    Long_Wavy_Flamingo_Hat,
    Long_Wavy_Ginger_Hat,
    Long_Wavy_Lavender_Hat,
    Long_Wavy_Mint_Hat,
    Long_Wavy_White_Hat,
    Neat_Black_Hat,
    Neat_Blonde_Hat,
    Neat_Brown_Hat,
    Neat_Ginger_Hat,
    Regular_Black_Hat,
    Regular_Blonde_Hat,
    Regular_Blue_Hat,
    Regular_Brown_Hat,
    Regular_Ginger_Hat,
    Regular_Green_Hat,
    Regular_Purple_Hat,
    Regular_Red_Hat,
    Regular_Teal_Hat,
    Regular_White_Hat
}

enum E_6_Eyes {
    Blind,
    Confused,
    Left,
    Posessed,
    Right,
    Smokey_Blue,
    Smokey_Green,
    Smokey_Purple,
    Tired_Confused,
    Tired_Left,
    Tired_Right
}

enum E_6b_Eye_Wear {
    None,
    _3d_Glasses_Black,
    _3d_Glasses,
    Aviators_Xl,
    Aviators,
    Beach_Shades,
    Big_Shades_Aqua,
    Big_Shades_Black,
    Big_Shades_Pink,
    Big_Shades_Red_Lens,
    Big_Shades_White,
    Blue_Frame_Shades,
    Eye_Mask,
    Eye_Patch_Left,
    Eye_Patch_Right,
    Fancy_Shades,
    Fly_Shades,
    Geek_Glasses_Black,
    Geek_Glasses_Red,
    Green_Frame_Shades,
    Pink_Frame_Shades,
    Red_Frame_Shades,
    Red_Lens_Bad_Boys,
    Retro_Shades,
    Shades,
    Vibey_Shades,
    Vintage_Shades,
    Vr_Blue,
    Vr_Green,
    Vr_Red,
    White_Frame_Shades,
    Yellow_Frame_Shades
}

enum E_7_Lip_Gloss {
    None,
    Lip_Gloss_Pink,
    Lip_Gloss_Purple,
    Lip_Gloss_Red
}

enum E_8_Teeth {
    None,
    Diamond_Grill,
    Fangs,
    Full_Teeth,
    Gold_Grill_Skeleton,
    Gold_Grill,
    Gold_Tooth_Left_Skeleton,
    Gold_Tooth_Left,
    Gold_Tooth_Right_Skeleton,
    Gold_Tooth_Right,
    Golden_Fangs,
    Golden_Hobo_Teeth,
    Hobo_Teeth,
    Missing_Tooth_Left,
    Missing_Tooth_Right,
    Rainbow_Grill
}

enum E_8b_Ape_Teeth {
    None,
    Diamond_Grill_Ape,
    Fangs_Ape,
    Full_Teeth_Ape,
    Gold_Grill_Ape,
    Gold_Tooth_Left_Ape,
    Gold_Tooth_Right_Ape,
    Golden_Fangs_Ape,
    Golden_Jungle_Teeth,
    Jungle_Teeth,
    Rainbow_Grill_Ape
}

enum E_9_Facial_Hair {
    None,
    Devastating_Beard_Black,
    Devastating_Beard_Brown,
    Devastating_Beard_Ginger,
    Devastating_Beard_White,
    Epic_Beard_Black,
    Epic_Beard_Blue,
    Epic_Beard_Brown,
    Epic_Beard_Ginger,
    Epic_Beard_Green,
    Epic_Beard_Purple,
    Epic_Beard_Red,
    Handlebar_Tash_Black,
    Handlebar_Tash_Brown,
    Handlebar_Tash_Ginger,
    Handlebar_Tash_White,
    Scruffy_Beard_Black,
    Scruffy_Beard_Brown,
    Scruffy_Beard_Ginger,
    Scruffy_Beard_White,
    Tight_Beard_Black,
    Tight_Beard_Brown,
    Tight_Beard_Ginger,
    Tight_Beard_White,
    Wizard_Beard
}

enum E_10_Headwear {
    None,
    Backwards_Cap_Black,
    Backwards_Cap_Blue,
    Backwards_Cap_Green,
    Backwards_Cap_Red,
    Backwards_Cap_Yellow,
    Bandana_Black,
    Bandana_Blue,
    Bandana_Red,
    Bandana_White,
    Biker_Hat,
    Bucket_Hat,
    Captain_Hat,
    Doo_Rag_Black,
    Doo_Rag_Blue,
    Doo_Rag_Red,
    Doo_Rag_White,
    Fez,
    Gangster_Hat,
    Hoodie_Black,
    Hoodie_Blue,
    Hoodie_Grey,
    Hoodie_Purple,
    Hoodie_Red,
    Jungle_Hat,
    Party_Hat,
    Pirate_Hat,
    Pork_Pie_Black,
    Pork_Pie_Brown,
    Pork_Pie_Cream,
    Sailer_Hat,
    Sheriff_Hat,
    Sherpa_Hat,
    Skull_X_Bones_Cap_Black,
    Skull_X_Bones_Cap_Double_Black,
    Skull_X_Bones_Cap_Red,
    Sweat_Band_Blue,
    Sweat_Band_Green,
    Sweat_Band_Red,
    Sweat_Band_Yellow,
    Top_Hat_Blue_Sash,
    Top_Hat_Purple_Sash,
    Trucker_Cap_Black,
    Trucker_Cap_Blue,
    Trucker_Cap_Green,
    Trucker_Cap_Purple,
    Trucker_Cap_Red,
    Trucker_Cap_Yellow,
    Wooly_Hat_Black,
    Wooly_Hat_Brown,
    Wooly_Hat_Grey,
    Wooly_Hat_Pink,
    Halo
}

enum E_10b_Skeleton_Hoodie_Filler {
    Skeleton_Hoodie_Filler
}

enum E_11_Smoking {
    No,
    Cigar,
    Cigarette
}

enum E_Background {
    Air_Force_Dark,
    Air_Force_Light,
    Air_Force_Washedout,
    Air_Force,
    Ant_Blue,
    Ant_Green,
    Ant_Red,
    Ant_Teal,
    Ant_Yellow,
    Black,
    Brick_Dust_Dark,
    Brick_Dust_Light,
    Brick_Dust_Washedout,
    Brick_Dust,
    Charcoal_Dark,
    Charcoal_Light,
    Charcoal,
    Flamingo_Dark,
    Flamingo_Extra_Dark,
    Flamingo_Washedout,
    Flamingo,
    Gradient_Basic_Inverted,
    Gradient_Basic,
    Gradient_California_Sunrise,
    Gradient_Deep_Vibes_Inverted,
    Gradient_Deep_Vibes,
    Gradient_Dreamy_Inverted,
    Gradient_Dreamy,
    Gradient_Flamingo_Inverted,
    Gradient_Flamingo,
    Gradient_Galactic_Inverted,
    Gradient_Galactic,
    Gradient_Mermaid_Inverted,
    Gradient_Mermaid,
    Gradient_Mono_Inverted,
    Gradient_Mono,
    Gradient_Neon,
    Gradient_Pond_Water_Inverted,
    Gradient_Pond_Water,
    Gradient_Purple_Basic_Inverted,
    Gradient_Purple_Basic,
    Gradient_Purple_Haze_Inverted,
    Gradient_Purple_Haze,
    Gradient_Sepia_Inverted,
    Gradient_Sepia,
    Gradient_Standard_Inverted,
    Gradient_Standard,
    Gradient_Vibey_Inverted,
    Gradient_Vibey,
    Idigo_Bro,
    Jelly_Bean_Dark,
    Jelly_Bean_Light,
    Jelly_Bean_Washedout,
    Jelly_Bean,
    Lemon_Daiquiri,
    Lime_And_Soda,
    Nam_Dark,
    Nam_Light,
    Nam_Washedout,
    Nam,
    Off_White,
    Open_Water,
    Pastel_Blue,
    Pastel_Green,
    Pastel_Orange,
    Pastel_Red,
    Pastel_Yellow,
    Pink_Monster,
    Red_Riding_Hood,
    Regal_Blue_Dark,
    Regal_Blue_Light,
    Regal_Blue_Washedout,
    Regal_Blue,
    Rocky_Dark,
    Rocky_Light,
    Rocky_Washedout,
    Rocky,
    Royal_Dark,
    Royal_Flush,
    Royal_Light,
    Royal_Washedout,
    Royal,
    Sand_Dune_Dark,
    Sand_Dune_Light,
    Sand_Dune_Washedout,
    Sand_Dune,
    Standard_Bright,
    Standard_Dark,
    Standard_Light,
    Standard_Washedout,
    Standard,
    Sunflower_Washedout,
    Sunflower,
    Tan_Dark,
    Tan_Washedout,
    Tan,
    Tangerine_Pie,
    Transparent,
    Valencia,
    Violet_Dark,
    Violet_Extra_Dark,
    Violet_Washedout,
    Violet
}

enum E_Mouth {
    Alien_Mouth,
    Ape_Mouth,
    Demonic_Mouth,
    Human_1_Mouth,
    Human_2_Mouth,
    Human_3_Mouth,
    Human_4_Mouth,
    Human_5_Mouth,
    Human_6_Mouth,
    Radioactive_Mouth,
    Zombie_Mouth
}

enum E_New_Fillers {
    Brit_Pop_Black_Filler,
    Brit_Pop_Blonde_Filler,
    Brit_Pop_Brown_Filler,
    Brit_Pop_Ginger_Filler,
    Long_Wavy_Black_Filler,
    Long_Wavy_Blonde_Filler,
    Long_Wavy_Brown_Filler,
    Sherpa_Hat_Filler
}

enum E_TraitsGroup {
    E_0_Special_1s_Group,
    E_1_Type_Group,
    E_2_Tattoos_Group,
    E_3_Clothes_Group,
    E_3b_Clothes_Group,
    E_4_Jewellery_Group,
    E_5_Hair_Group,
    E_5b_Hat_Hair_Group,
    E_6_Eyes_Group,
    E_6b_Eye_Wear_Group,
    E_7_Lip_Gloss_Group,
    E_8_Teeth_Group,
    E_8b_Ape_Teeth_Group,
    E_9_Facial_Hair_Group,
    E_10_Headwear_Group,
    E_10b_Skeleton_Hoodie_Filler_Group,
    E_11_Smoking_Group,
    E_Background_Group,
    E_Mouth_Group,
    E_New_Fillers_Group
}

uint constant NUM_TRAIT_GROUPS = 20;


library TraitContextGenerated {

    function random_0_Special_1s(RandomCtx memory rndCtx, uint32[6] memory probabilities) internal pure returns (E_0_Special_1s) {
        uint32[] memory probArray = new uint32[](6);
        for (uint i = 0; i < 6; i++) {
            probArray[i] = probabilities[i];
        }
        return E_0_Special_1s(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_0_Special_1s enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_0_Special_1s_Group;
    }

    function random_1_Type(RandomCtx memory rndCtx, uint32[12] memory probabilities) internal pure returns (E_1_Type) {
        uint32[] memory probArray = new uint32[](12);
        for (uint i = 0; i < 12; i++) {
            probArray[i] = probabilities[i];
        }
        return E_1_Type(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_1_Type enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_1_Type_Group;
    }

    function random_2_Tattoos(RandomCtx memory rndCtx, uint32[15] memory probabilities) internal pure returns (E_2_Tattoos) {
        uint32[] memory probArray = new uint32[](15);
        for (uint i = 0; i < 15; i++) {
            probArray[i] = probabilities[i];
        }
        return E_2_Tattoos(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_2_Tattoos enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_2_Tattoos_Group;
    }

    function random_3_Clothes(RandomCtx memory rndCtx, uint32[26] memory probabilities) internal pure returns (E_3_Clothes) {
        uint32[] memory probArray = new uint32[](26);
        for (uint i = 0; i < 26; i++) {
            probArray[i] = probabilities[i];
        }
        return E_3_Clothes(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_3_Clothes enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_3_Clothes_Group;
    }

    function random_3b_Clothes(RandomCtx memory rndCtx, uint32[11] memory probabilities) internal pure returns (E_3b_Clothes) {
        uint32[] memory probArray = new uint32[](11);
        for (uint i = 0; i < 11; i++) {
            probArray[i] = probabilities[i];
        }
        return E_3b_Clothes(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_3b_Clothes enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_3b_Clothes_Group;
    }

    function random_4_Jewellery(RandomCtx memory rndCtx, uint32[8] memory probabilities) internal pure returns (E_4_Jewellery) {
        uint32[] memory probArray = new uint32[](8);
        for (uint i = 0; i < 8; i++) {
            probArray[i] = probabilities[i];
        }
        return E_4_Jewellery(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_4_Jewellery enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_4_Jewellery_Group;
    }

    function random_5_Hair(RandomCtx memory rndCtx, uint32[120] memory probabilities) internal pure returns (E_5_Hair) {
        uint32[] memory probArray = new uint32[](120);
        for (uint i = 0; i < 120; i++) {
            probArray[i] = probabilities[i];
        }
        return E_5_Hair(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_5_Hair enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_5_Hair_Group;
    }

    function random_5b_Hat_Hair(RandomCtx memory rndCtx, uint32[49] memory probabilities) internal pure returns (E_5b_Hat_Hair) {
        uint32[] memory probArray = new uint32[](49);
        for (uint i = 0; i < 49; i++) {
            probArray[i] = probabilities[i];
        }
        return E_5b_Hat_Hair(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_5b_Hat_Hair enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_5b_Hat_Hair_Group;
    }

    function random_6_Eyes(RandomCtx memory rndCtx, uint32[11] memory probabilities) internal pure returns (E_6_Eyes) {
        uint32[] memory probArray = new uint32[](11);
        for (uint i = 0; i < 11; i++) {
            probArray[i] = probabilities[i];
        }
        return E_6_Eyes(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_6_Eyes enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_6_Eyes_Group;
    }

    function random_6b_Eye_Wear(RandomCtx memory rndCtx, uint32[32] memory probabilities) internal pure returns (E_6b_Eye_Wear) {
        uint32[] memory probArray = new uint32[](32);
        for (uint i = 0; i < 32; i++) {
            probArray[i] = probabilities[i];
        }
        return E_6b_Eye_Wear(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_6b_Eye_Wear enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_6b_Eye_Wear_Group;
    }

    function random_7_Lip_Gloss(RandomCtx memory rndCtx, uint32[4] memory probabilities) internal pure returns (E_7_Lip_Gloss) {
        uint32[] memory probArray = new uint32[](4);
        for (uint i = 0; i < 4; i++) {
            probArray[i] = probabilities[i];
        }
        return E_7_Lip_Gloss(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_7_Lip_Gloss enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_7_Lip_Gloss_Group;
    }

    function random_8_Teeth(RandomCtx memory rndCtx, uint32[16] memory probabilities) internal pure returns (E_8_Teeth) {
        uint32[] memory probArray = new uint32[](16);
        for (uint i = 0; i < 16; i++) {
            probArray[i] = probabilities[i];
        }
        return E_8_Teeth(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_8_Teeth enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_8_Teeth_Group;
    }

    function random_8b_Ape_Teeth(RandomCtx memory rndCtx, uint32[11] memory probabilities) internal pure returns (E_8b_Ape_Teeth) {
        uint32[] memory probArray = new uint32[](11);
        for (uint i = 0; i < 11; i++) {
            probArray[i] = probabilities[i];
        }
        return E_8b_Ape_Teeth(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_8b_Ape_Teeth enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_8b_Ape_Teeth_Group;
    }

    function random_9_Facial_Hair(RandomCtx memory rndCtx, uint32[25] memory probabilities) internal pure returns (E_9_Facial_Hair) {
        uint32[] memory probArray = new uint32[](25);
        for (uint i = 0; i < 25; i++) {
            probArray[i] = probabilities[i];
        }
        return E_9_Facial_Hair(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_9_Facial_Hair enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_9_Facial_Hair_Group;
    }

    function random_10_Headwear(RandomCtx memory rndCtx, uint32[53] memory probabilities) internal pure returns (E_10_Headwear) {
        uint32[] memory probArray = new uint32[](53);
        for (uint i = 0; i < 53; i++) {
            probArray[i] = probabilities[i];
        }
        return E_10_Headwear(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_10_Headwear enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_10_Headwear_Group;
    }

    function random_10b_Skeleton_Hoodie_Filler(RandomCtx memory rndCtx, uint32[1] memory probabilities) internal pure returns (E_10b_Skeleton_Hoodie_Filler) {
        uint32[] memory probArray = new uint32[](1);
        for (uint i = 0; i < 1; i++) {
            probArray[i] = probabilities[i];
        }
        return E_10b_Skeleton_Hoodie_Filler(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_10b_Skeleton_Hoodie_Filler enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_10b_Skeleton_Hoodie_Filler_Group;
    }

    function random_11_Smoking(RandomCtx memory rndCtx, uint32[3] memory probabilities) internal pure returns (E_11_Smoking) {
        uint32[] memory probArray = new uint32[](3);
        for (uint i = 0; i < 3; i++) {
            probArray[i] = probabilities[i];
        }
        return E_11_Smoking(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_11_Smoking enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_11_Smoking_Group;
    }

    function random_Background(RandomCtx memory rndCtx, uint32[103] memory probabilities) internal pure returns (E_Background) {
        uint32[] memory probArray = new uint32[](103);
        for (uint i = 0; i < 103; i++) {
            probArray[i] = probabilities[i];
        }
        return E_Background(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_Background enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_Background_Group;
    }

    function random_Mouth(RandomCtx memory rndCtx, uint32[11] memory probabilities) internal pure returns (E_Mouth) {
        uint32[] memory probArray = new uint32[](11);
        for (uint i = 0; i < 11; i++) {
            probArray[i] = probabilities[i];
        }
        return E_Mouth(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_Mouth enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_Mouth_Group;
    }

    function random_New_Fillers(RandomCtx memory rndCtx, uint32[8] memory probabilities) internal pure returns (E_New_Fillers) {
        uint32[] memory probArray = new uint32[](8);
        for (uint i = 0; i < 8; i++) {
            probArray[i] = probabilities[i];
        }
        return E_New_Fillers(Random.randWithProbabilities(rndCtx, probArray));
    }
    function traitEnumToTraitGroupEnum(E_New_Fillers enumValue) internal pure returns (E_TraitsGroup) {
        return E_TraitsGroup.E_New_Fillers_Group;
    }

}