// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { TraitsContext } from "../common/Structs.sol";
import { E_Sex, E_Male_Skin, E_Male_Facial_Hair, E_Male_Mask, E_Male_Headwear, E_Female_Skin, E_Female_Mask, E_Female_Headwear } from "../common/Enums.sol";


/// @author ECHO


library LibTraits {

    function isMale(TraitsContext memory traits) internal pure returns (bool) {
        return traits.sex == E_Sex.Male;
    }

    function isFemale(TraitsContext memory traits) internal pure returns (bool) {
        return traits.sex == E_Sex.Female;
    }

    function maleIsHuman(TraitsContext memory traits) internal pure returns (bool) {
        return uint8(traits.maleSkin) >= uint8(E_Male_Skin.Human_1) && uint8(traits.maleSkin) <= uint8(E_Male_Skin.Human_12);
    }

    function maleIsAlien(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleSkin == E_Male_Skin.Alien;
    }

    function maleIsApe(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleSkin == E_Male_Skin.Ape;
    }

    function maleIsDemon(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleSkin == E_Male_Skin.Demon;
    }

    function maleIsGhost(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleSkin == E_Male_Skin.Ghost;
    }

    function maleIsGlitch(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleSkin == E_Male_Skin.Glitch;
    }

    function maleIsGoblin(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleSkin == E_Male_Skin.Goblin;
    }

    function maleIsInvisible(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleSkin == E_Male_Skin.Invisible;
    }

    function maleIsMummy(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleSkin == E_Male_Skin.Mummy;
    }

    function maleIsPumpkin(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleSkin == E_Male_Skin.Pumpkin;
    }

    function maleIsRobot(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleSkin == E_Male_Skin.Robot;
    }

    function maleIsSkeleton(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleSkin == E_Male_Skin.Skeleton;
    }

    function maleIsSnowman(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleSkin == E_Male_Skin.Snowman;
    }

    function maleIsVampire(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleSkin == E_Male_Skin.Vampire;
    }

    function maleIsYeti(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleSkin == E_Male_Skin.Yeti;
    }
    
    function maleIsZombieApe(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleSkin == E_Male_Skin.Zombie_Ape;
    }

    function maleIsZombie(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleSkin == E_Male_Skin.Zombie;
    }

    function femaleIsHuman(TraitsContext memory traits) internal pure returns (bool) {
        return uint8(traits.femaleSkin) >= uint8(E_Female_Skin.Human_1) && uint8(traits.femaleSkin) <= uint8(E_Female_Skin.Human_12);
    }

    function femaleIsAlien(TraitsContext memory traits) internal pure returns (bool) {
        return traits.femaleSkin == E_Female_Skin.Alien;
    }

    function femaleIsApe(TraitsContext memory traits) internal pure returns (bool) {
        return traits.femaleSkin == E_Female_Skin.Ape;
    }

    function femaleIsDemon(TraitsContext memory traits) internal pure returns (bool) {
        return traits.femaleSkin == E_Female_Skin.Demon;
    }

    function femaleIsGhost(TraitsContext memory traits) internal pure returns (bool) {
        return traits.femaleSkin == E_Female_Skin.Ghost;
    }

    function femaleIsGlitch(TraitsContext memory traits) internal pure returns (bool) {
        return traits.femaleSkin == E_Female_Skin.Glitch;
    }

    function femaleIsGoblin(TraitsContext memory traits) internal pure returns (bool) {
        return traits.femaleSkin == E_Female_Skin.Goblin;
    }

    function femaleIsInvisible(TraitsContext memory traits) internal pure returns (bool) {
        return traits.femaleSkin == E_Female_Skin.Invisible;
    }

    function femaleIsMummy(TraitsContext memory traits) internal pure returns (bool) {
        return traits.femaleSkin == E_Female_Skin.Mummy;
    }

    function femaleIsRobot(TraitsContext memory traits) internal pure returns (bool) {
        return traits.femaleSkin == E_Female_Skin.Robot;
    }

    function femaleIsSkeleton(TraitsContext memory traits) internal pure returns (bool) {
        return traits.femaleSkin == E_Female_Skin.Skeleton;
    }

    function femaleIsVampire(TraitsContext memory traits) internal pure returns (bool) {
        return traits.femaleSkin == E_Female_Skin.Vampire;
    }
    
    function femaleIsZombieApe(TraitsContext memory traits) internal pure returns (bool) {
        return traits.femaleSkin == E_Female_Skin.Zombie_Ape;
    }

    function femaleIsZombie(TraitsContext memory traits) internal pure returns (bool) {
        return traits.femaleSkin == E_Female_Skin.Zombie;
    }


    function maleHasHeadwear(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleHeadwear != E_Male_Headwear.None;
    }

    function femaleHasHeadwear(TraitsContext memory traits) internal pure returns (bool) {
        return traits.femaleHeadwear != E_Female_Headwear.None;
    }

    function maleHasMask(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleMask != E_Male_Mask.None;
    }

    function femaleHasMask(TraitsContext memory traits) internal pure returns (bool) {
        return traits.femaleMask != E_Female_Mask.None;
    }
    
    function maleHasFacialHair(TraitsContext memory traits) internal pure returns (bool) {
        return traits.maleFacialHair != E_Male_Facial_Hair.None;
    }

    function maleHasBlackFacialHair(TraitsContext memory traits) internal pure returns (bool) {
        unchecked {
            return (IS_BLACK_FACIAL_HAIR & (uint256(1) << uint256(traits.maleFacialHair))) != 0;
        }
    }

    uint256 private constant IS_BLACK_FACIAL_HAIR = (
        (uint256(1) << uint256(E_Male_Facial_Hair.Anchor_Beard_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Beard_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Big_Beard_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Chin_Goatee_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Chinstrap_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Circle_Beard_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Dutch_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Fu_Manchu_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Full_Goatee_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Goatee_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Handlebar_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Horseshoe_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Long_Beard_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Luxurious_Beard_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Luxurious_Full_Goatee_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Mustache_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Muttonchops_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Pyramid_Mustache_Black)) |
        (uint256(1) << uint256(E_Male_Facial_Hair.Walrus_Black))
    );
}