// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { TraitsContext } from "./TraitsContextStructs.sol";
import { E_1_Type, E_6b_Eye_Wear, E_10_Headwear, E_3_Clothes, E_5_Hair, E_9_Facial_Hair, E_3b_Clothes } from "./TraitContextGenerated.sol";

/**
 * @author EtoVass
 */

library TraitsUtils {
    function isHuman(TraitsContext memory traits) internal pure returns (bool) {
        return traits.bodyType == E_1_Type.Human_1 ||
               traits.bodyType == E_1_Type.Human_2 ||
               traits.bodyType == E_1_Type.Human_3 ||
               traits.bodyType == E_1_Type.Human_4 ||
               traits.bodyType == E_1_Type.Human_5 ||
               traits.bodyType == E_1_Type.Human_6;
    }

    function isHuman6(TraitsContext memory traits) internal pure returns (bool) {
        return traits.bodyType == E_1_Type.Human_6;
    }

    function isAlien(TraitsContext memory traits) internal pure returns (bool) {
        return traits.bodyType == E_1_Type.Alien;
    }

    function isApe(TraitsContext memory traits) internal pure returns (bool) {
        return traits.bodyType == E_1_Type.Ape;
    }
    
    function isRadioactive(TraitsContext memory traits) internal pure returns (bool) {
        return traits.bodyType == E_1_Type.Radioactive;
    }

    function isZombie(TraitsContext memory traits) internal pure returns (bool) {
        return traits.bodyType == E_1_Type.Zombie;
    }

    function isDemonic(TraitsContext memory traits) internal pure returns (bool) {
        return traits.bodyType == E_1_Type.Demonic;
    }

    function isSkeleton(TraitsContext memory traits) internal pure returns (bool) {
        return traits.bodyType == E_1_Type.Skeleton;
    }

    function hasEyePatchOrNone(E_6b_Eye_Wear eyeWear) internal pure returns (bool) {
        if (
        eyeWear == E_6b_Eye_Wear.Eye_Patch_Left || 
        eyeWear == E_6b_Eye_Wear.Eye_Patch_Right || 
        eyeWear == E_6b_Eye_Wear.None) {
            return true;
        }
        return false;
    }

    function createProbabilityArray(uint lenght, uint32 commonProbability) internal pure returns (uint32[] memory) {
        uint32[] memory probabilities = new uint32[](lenght);
        for (uint i = 0; i < lenght; i++) {
            probabilities[i] = commonProbability;
        }
        return probabilities;
    }

    function hasHeadwear(TraitsContext memory traits) internal pure returns (bool) {
        return traits.headwear != E_10_Headwear.None;
    }

    function hasHoodie(TraitsContext memory traits) internal pure returns (bool) {
        return 
            traits.headwear == E_10_Headwear.Hoodie_Blue || 
            traits.headwear == E_10_Headwear.Hoodie_Grey || 
            traits.headwear == E_10_Headwear.Hoodie_Black || 
            traits.headwear == E_10_Headwear.Hoodie_Purple || 
            traits.headwear == E_10_Headwear.Hoodie_Red;
    }

    function hasCropTop(TraitsContext memory traits) internal pure returns (bool) {
        return 
            traits.clothes == E_3_Clothes.Croptop_Black || 
            traits.clothes == E_3_Clothes.Croptop_Blue || 
            traits.clothes == E_3_Clothes.Croptop_Pink || 
            traits.clothes == E_3_Clothes.Croptop_Red || 
            traits.clothes == E_3_Clothes.Croptop_Green || 
            traits.clothes == E_3_Clothes.Croptop_Burgundy || 
            traits.clothes == E_3_Clothes.Croptop_White;
    }

    function hasTshirt(TraitsContext memory traits) internal pure returns (bool) {
        return 
            traits.clothes == E_3_Clothes.Tshirt_Black || 
            traits.clothes == E_3_Clothes.Tshirt_Blue || 
            traits.clothes == E_3_Clothes.Tshirt_Green || 
            traits.clothes == E_3_Clothes.Tshirt_Red || 
            traits.clothes == E_3_Clothes.Tshirt_Burgundy || 
            traits.clothes == E_3_Clothes.Tshirt_White;
    }

    function hasVest(TraitsContext memory traits) internal pure returns (bool) {
        return 
            traits.clothes == E_3_Clothes.Vest_Black || 
            traits.clothes == E_3_Clothes.Vest_Blue || 
            traits.clothes == E_3_Clothes.Vest_Green || 
            traits.clothes == E_3_Clothes.Vest_Red || 
            traits.clothes == E_3_Clothes.Vest_Burgundy || 
            traits.clothes == E_3_Clothes.Vest_White;
    }

    function hasBareChest(TraitsContext memory traits) internal pure returns (bool) {
        return traits.clothes == E_3_Clothes.Bare_Chest;
    }

    function hasBigBeard(TraitsContext memory traits) internal pure returns (bool) {
        return 
            traits.facialHair == E_9_Facial_Hair.Devastating_Beard_Black || 
            traits.facialHair == E_9_Facial_Hair.Devastating_Beard_Brown || 
            traits.facialHair == E_9_Facial_Hair.Devastating_Beard_White || 
            traits.facialHair == E_9_Facial_Hair.Devastating_Beard_Ginger|| 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Black || 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Brown || 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Ginger ||
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Red || 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Blue || 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Green || 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Purple ||  
            traits.facialHair == E_9_Facial_Hair.Wizard_Beard;

    }

    function hasEpicBeard(TraitsContext memory traits) internal pure returns (bool) {
        return 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Black || 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Brown || 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Ginger ||
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Red || 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Blue || 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Green || 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Purple ||  
            traits.facialHair == E_9_Facial_Hair.Wizard_Beard;
    }

    // added by 8-Bit
    function hasLongSleeves(TraitsContext memory traits) internal pure returns (bool) {  
        return 
            traits.clothes == E_3_Clothes.Long_Sleeved_Shirt_White || 
            traits.clothes == E_3_Clothes.Long_Sleeved_Shirt_Red || 
            traits.clothes == E_3_Clothes.Long_Sleeved_Shirt_Blue || 
            traits.clothes == E_3_Clothes.Long_Sleeved_Shirt_Green || 
            traits.clothes == E_3_Clothes.Long_Sleeved_Shirt_Burgundy || 
            traits.clothes == E_3_Clothes.Long_Sleeved_Shirt_Black; 
    }

    function hasJacket(TraitsContext memory traits) internal pure returns (bool) {
        return 
            traits.clothes2 == E_3b_Clothes.Leather_Jacket_Black || 
            traits.clothes2 == E_3b_Clothes.Leather_Jacket_Cream ||
            traits.clothes2 == E_3b_Clothes.Leather_Jacket_Red;
    }

    function hasWavyHair(TraitsContext memory traits) internal pure returns (bool) {  
        return 
            traits.hair == E_5_Hair.Long_Wavy_Black || 
            traits.hair == E_5_Hair.Long_Wavy_Blonde || 
            traits.hair == E_5_Hair.Long_Wavy_Brown;
    }

    function hasSherpaHat(TraitsContext memory traits) internal pure returns (bool) {
        return traits.headwear == E_10_Headwear.Sherpa_Hat;
    }

    function hasEyeMask(TraitsContext memory traits) internal pure returns (bool) {
        return traits.eyeWear == E_6b_Eye_Wear.Eye_Mask;
    }

    function hasVR(TraitsContext memory traits) internal pure returns (bool) {
        return 
            traits.eyeWear == E_6b_Eye_Wear.Vr_Blue || 
            traits.eyeWear == E_6b_Eye_Wear.Vr_Green || 
            traits.eyeWear == E_6b_Eye_Wear.Vr_Red;
    }    
    
    function hasBeard(TraitsContext memory traits) internal pure returns (bool) {
        return 
            traits.facialHair == E_9_Facial_Hair.Devastating_Beard_Black || 
            traits.facialHair == E_9_Facial_Hair.Devastating_Beard_Brown || 
            traits.facialHair == E_9_Facial_Hair.Devastating_Beard_White || 
            traits.facialHair == E_9_Facial_Hair.Devastating_Beard_Ginger|| 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Black || 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Brown || 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Ginger || 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Red || 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Blue || 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Green || 
            traits.facialHair == E_9_Facial_Hair.Epic_Beard_Purple || 
            traits.facialHair == E_9_Facial_Hair.Wizard_Beard || 
            traits.facialHair == E_9_Facial_Hair.Scruffy_Beard_Black || 
            traits.facialHair == E_9_Facial_Hair.Scruffy_Beard_Brown || 
            traits.facialHair == E_9_Facial_Hair.Scruffy_Beard_White || 
            traits.facialHair == E_9_Facial_Hair.Scruffy_Beard_Ginger || 
            traits.facialHair == E_9_Facial_Hair.Tight_Beard_Black || 
            traits.facialHair == E_9_Facial_Hair.Tight_Beard_Brown || 
            traits.facialHair == E_9_Facial_Hair.Tight_Beard_Ginger || 
            traits.facialHair == E_9_Facial_Hair.Tight_Beard_White;
    }
    
    function hasTightBeard(TraitsContext memory traits) internal pure returns (bool) {
        return 
            traits.facialHair == E_9_Facial_Hair.Tight_Beard_Black || 
            traits.facialHair == E_9_Facial_Hair.Tight_Beard_Brown || 
            traits.facialHair == E_9_Facial_Hair.Tight_Beard_Ginger || 
            traits.facialHair == E_9_Facial_Hair.Tight_Beard_White;
    }

    function hasTightWhite(TraitsContext memory traits) internal pure returns (bool) {
        return 
            traits.facialHair == E_9_Facial_Hair.Tight_Beard_White;
    }



    function hasBritPopHair(TraitsContext memory traits) internal pure returns (bool) {
        return 
            traits.hair == E_5_Hair.Brit_Pop_Cut_Black || 
            traits.hair == E_5_Hair.Brit_Pop_Cut_Blonde || 
            traits.hair == E_5_Hair.Brit_Pop_Cut_Ginger || 
            traits.hair == E_5_Hair.Brit_Pop_Cut_Brown; 
    }

        
    function removeFromArray(int8[] memory array, int8 value) internal pure returns (int8[] memory) {
        // check if the value is in the array   
        bool found = false;
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
                found = true;
                break;
            }
        }
        if (!found) {
            return array;
        }

        int8[] memory newArray = new int8[](array.length - 1);
        uint index = 0;
        for (uint i = 0; i < array.length; i++) {
            if (array[i] != value) {
                newArray[index] = array[i]; 
                index++;
            }
        }
        return newArray;
    }

    function shortenArray(int8[] memory array, uint newLength) internal pure returns (int8[] memory) {
        if (array.length <= newLength) {
            return array;
        }
        int8[] memory newArray = new int8[](newLength);
        for (uint i = 0; i < newLength; i++) {
            newArray[i] = array[i];
        }
        return newArray;
    }

    function putOnFrontOrOverride(int8[] memory array, int8 value) internal pure {
        if (array.length < 1) return;

        // check if the value is in the array   
        int index = -1;
        for (uint i = 0; i < array.length; i++) {
            if (array[i] == value) {
                index = int(i);
                break;
            }
        }

        // [13, 54, 74, 34, 14, 18]
        
        if (index == -1) {
            array[0] = value;
        } else {
            // swap the value with the first element
            array[uint(index)] = array[0];
            array[0] = value;
        }
    }
}

