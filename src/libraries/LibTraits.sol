// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import {TraitsContext} from "../common/Structs.sol";
import {E_Sex, E_TraitsGroup, E_Background, E_Male_Skin, E_Male_Eyes, E_Male_Face, E_Male_Chain, E_Male_Earring, E_Male_Scarf, E_Male_Facial_Hair, E_Male_Mask, E_Male_Hair, E_Male_Hat_Hair, E_Male_Headwear, E_Male_Eye_Wear, E_Female_Skin, E_Female_Eyes, E_Female_Face, E_Female_Chain, E_Female_Earring, E_Female_Scarf, E_Female_Mask, E_Female_Hair, E_Female_Hat_Hair, E_Female_Headwear, E_Female_Eye_Wear, E_Mouth} from "../common/Enums.sol";

/// @author ECHO

library LibTraits {
    uint256 private constant FACIAL_HAIR_IS_BLACK =
        ((uint256(1) << uint256(E_Male_Facial_Hair.Anchor_Beard_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Beard_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Big_Beard_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Chin_Goatee_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Chinstrap_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Circle_Beard_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Dutch_Black))
            | (uint256(1) << uint256(E_Male_Facial_Hair.Fu_Manchu_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Full_Goatee_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Goatee_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Handlebar_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Horseshoe_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Long_Beard_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Luxurious_Beard_Black))
            | (uint256(1) << uint256(E_Male_Facial_Hair.Luxurious_Full_Goatee_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Mustache_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Muttonchops_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Pyramid_Mustache_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Walrus_Black)));

    uint256 private constant MALE_EYEWEAR_IS_EYE_PATCH =
        ((1 << uint256(E_Male_Eye_Wear.Bionic_Eye_Patch_Blue)) | (1 << uint256(E_Male_Eye_Wear.Bionic_Eye_Patch_Green)) | (1 << uint256(E_Male_Eye_Wear.Bionic_Eye_Patch_Orange)) | (1 << uint256(E_Male_Eye_Wear.Bionic_Eye_Patch_Pink)) | (1 << uint256(E_Male_Eye_Wear.Bionic_Eye_Patch_Purple)) | (1 << uint256(E_Male_Eye_Wear.Bionic_Eye_Patch_Red)) | (1 << uint256(E_Male_Eye_Wear.Bionic_Eye_Patch_Turquoise)) | (1 << uint256(E_Male_Eye_Wear.Bionic_Eye_Patch_Yellow))
            | (1 << uint256(E_Male_Eye_Wear.Eye_Patch)) | (1 << uint256(E_Male_Eye_Wear.Pirate_Eye_Patch)) | (1 << uint256(E_Male_Eye_Wear.Eye_Mask)));

    uint256 private constant MALE_HEADWEAR_IS_CLOAK_OR_HOODIE =
        ((uint256(1) << uint256(E_Male_Headwear.Cloak_Black)) | (uint256(1) << uint256(E_Male_Headwear.Cloak_Blue)) | (uint256(1) << uint256(E_Male_Headwear.Cloak_Green)) | (uint256(1) << uint256(E_Male_Headwear.Cloak_Purple)) | (uint256(1) << uint256(E_Male_Headwear.Cloak_Red)) | (uint256(1) << uint256(E_Male_Headwear.Cloak_White)) | (uint256(1) << uint256(E_Male_Headwear.Cloak)) | (uint256(1) << uint256(E_Male_Headwear.Hoodie_Blue)) | (uint256(1) << uint256(E_Male_Headwear.Hoodie_Green))
            | (uint256(1) << uint256(E_Male_Headwear.Hoodie_Purple)) | (uint256(1) << uint256(E_Male_Headwear.Hoodie_Red)) | (uint256(1) << uint256(E_Male_Headwear.Hoodie)) | (uint256(1) << uint256(E_Male_Headwear.Sherpa_Hat_Blue)) | (uint256(1) << uint256(E_Male_Headwear.Sherpa_Hat_Brown)) | (uint256(1) << uint256(E_Male_Headwear.Sherpa_Hat_Red)));

    uint256 private constant FEMALE_EYEWEAR_IS_EYE_PATCH =
        ((1 << uint256(E_Female_Eye_Wear.Bionic_Eye_Patch_Blue)) | (1 << uint256(E_Female_Eye_Wear.Bionic_Eye_Patch_Green)) | (1 << uint256(E_Female_Eye_Wear.Bionic_Eye_Patch_Orange)) | (1 << uint256(E_Female_Eye_Wear.Bionic_Eye_Patch_Pink)) | (1 << uint256(E_Female_Eye_Wear.Bionic_Eye_Patch_Purple)) | (1 << uint256(E_Female_Eye_Wear.Bionic_Eye_Patch_Red)) | (1 << uint256(E_Female_Eye_Wear.Bionic_Eye_Patch_Turquoise)) | (1 << uint256(E_Female_Eye_Wear.Bionic_Eye_Patch_Yellow))
            | (1 << uint256(E_Female_Eye_Wear.Eye_Patch)) | (1 << uint256(E_Female_Eye_Wear.Pirate_Eye_Patch)) | (1 << uint256(E_Female_Eye_Wear.Eye_Mask)));

    uint256 private constant FEMALE_HEADWEAR_IS_CLOAK_OR_HOODIE =
        ((uint256(1) << uint256(E_Female_Headwear.Cloak_Black)) | (uint256(1) << uint256(E_Female_Headwear.Cloak_Blue)) | (uint256(1) << uint256(E_Female_Headwear.Cloak_Green)) | (uint256(1) << uint256(E_Female_Headwear.Cloak_Purple)) | (uint256(1) << uint256(E_Female_Headwear.Cloak_Red)) | (uint256(1) << uint256(E_Female_Headwear.Cloak_White)) | (uint256(1) << uint256(E_Female_Headwear.Cloak)) | (uint256(1) << uint256(E_Female_Headwear.Hoodie_Blue))
            | (uint256(1) << uint256(E_Female_Headwear.Hoodie_Green)) | (uint256(1) << uint256(E_Female_Headwear.Hoodie_Purple)) | (uint256(1) << uint256(E_Female_Headwear.Hoodie_Red)) | (uint256(1) << uint256(E_Female_Headwear.Hoodie)) | (uint256(1) << uint256(E_Female_Headwear.Sherpa_Hat_Blue)) | (uint256(1) << uint256(E_Female_Headwear.Sherpa_Hat_Brown)) | (uint256(1) << uint256(E_Female_Headwear.Sherpa_Hat_Red)));

    function maleHasBlackFacialHair(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return (FACIAL_HAIR_IS_BLACK & (uint256(1) << uint256(traits.maleFacialHair))) != 0;
        }
    }

    function maleEyeWearIsEyePatch(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return (MALE_EYEWEAR_IS_EYE_PATCH & (1 << uint256(traits.maleEyeWear))) != 0;
        }
    }

    function maleHeadwearIsCloakOrHoodie(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return (MALE_HEADWEAR_IS_CLOAK_OR_HOODIE & (uint256(1) << uint256(traits.maleHeadwear))) != 0;
        }
    }

    function femaleEyeWearIsEyePatch(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return (FEMALE_EYEWEAR_IS_EYE_PATCH & (1 << uint256(traits.femaleEyeWear))) != 0;
        }
    }

    function femaleHeadwearIsCloakOrHoodie(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return (FEMALE_HEADWEAR_IS_CLOAK_OR_HOODIE & (uint256(1) << uint256(traits.femaleHeadwear))) != 0;
        }
    }

    function isMale(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.sex == E_Sex.Male;
        }
    }

    function isFemale(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.sex == E_Sex.Female;
        }
    }

    function maleIsHuman(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleSkin >= E_Male_Skin.Human_1 && traits.maleSkin <= E_Male_Skin.Human_12;
        }
    }

    function maleIsAlien(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleSkin == E_Male_Skin.Alien;
        }
    }

    function maleIsApe(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleSkin == E_Male_Skin.Ape;
        }
    }

    function maleIsDemon(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleSkin == E_Male_Skin.Demon;
        }
    }

    function maleIsGhost(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleSkin == E_Male_Skin.Ghost;
        }
    }

    function maleIsGlitch(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleSkin == E_Male_Skin.Glitch;
        }
    }

    function maleIsGoblin(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleSkin == E_Male_Skin.Goblin;
        }
    }

    function maleIsInvisible(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleSkin == E_Male_Skin.Invisible;
        }
    }

    function maleIsMummy(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleSkin == E_Male_Skin.Mummy;
        }
    }

    function maleIsPumpkin(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleSkin == E_Male_Skin.Pumpkin;
        }
    }

    function maleIsRobot(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleSkin == E_Male_Skin.Robot;
        }
    }

    function maleIsSkeleton(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleSkin == E_Male_Skin.Skeleton;
        }
    }

    function maleIsSnowman(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleSkin == E_Male_Skin.Snowman;
        }
    }

    function maleIsVampire(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleSkin == E_Male_Skin.Vampire;
        }
    }

    function maleIsYeti(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleSkin == E_Male_Skin.Yeti;
        }
    }

    function maleIsZombieApe(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleSkin == E_Male_Skin.Zombie_Ape;
        }
    }

    function maleIsZombie(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleSkin == E_Male_Skin.Zombie;
        }
    }

    function femaleIsHuman(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.femaleSkin >= E_Female_Skin.Human_1 && traits.femaleSkin <= E_Female_Skin.Human_12;
        }
    }

    function femaleIsAlien(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.femaleSkin == E_Female_Skin.Alien;
        }
    }

    function femaleIsApe(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.femaleSkin == E_Female_Skin.Ape;
        }
    }

    function femaleIsDemon(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.femaleSkin == E_Female_Skin.Demon;
        }
    }

    function femaleIsGhost(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.femaleSkin == E_Female_Skin.Ghost;
        }
    }

    function femaleIsGlitch(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.femaleSkin == E_Female_Skin.Glitch;
        }
    }

    function femaleIsGoblin(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.femaleSkin == E_Female_Skin.Goblin;
        }
    }

    function femaleIsInvisible(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.femaleSkin == E_Female_Skin.Invisible;
        }
    }

    function femaleIsMummy(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.femaleSkin == E_Female_Skin.Mummy;
        }
    }

    function femaleIsRobot(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.femaleSkin == E_Female_Skin.Robot;
        }
    }

    function femaleIsSkeleton(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.femaleSkin == E_Female_Skin.Skeleton;
        }
    }

    function femaleIsVampire(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.femaleSkin == E_Female_Skin.Vampire;
        }
    }

    function femaleIsZombieApe(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.femaleSkin == E_Female_Skin.Zombie_Ape;
        }
    }

    function femaleIsZombie(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.femaleSkin == E_Female_Skin.Zombie;
        }
    }

    function maleHasHeadwear(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleHeadwear != E_Male_Headwear.None;
        }
    }

    function femaleHasHeadwear(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.femaleHeadwear != E_Female_Headwear.None;
        }
    }

    function maleHasMask(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleMask != E_Male_Mask.None;
        }
    }

    function femaleHasMask(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.femaleMask != E_Female_Mask.None;
        }
    }

    function maleHasFacialHair(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return traits.maleFacialHair != E_Male_Facial_Hair.None;
        }
    }
}
