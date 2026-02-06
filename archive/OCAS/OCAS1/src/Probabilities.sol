// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IProbabilities} from "./IProbabilities.sol";
import {E_1_Type, E_3_Clothes, E_5_Hair, NUM_5_Hair, E_5b_Hat_Hair, E_3b_Clothes, E_6_Eyes, E_6b_Eye_Wear, 
        E_7_Lip_Gloss, E_8_Teeth, E_8b_Ape_Teeth, E_9_Facial_Hair, E_10_Headwear, NUM_10_Headwear} from "./TraitContextGenerated.sol";
import {TraitsUtils} from "./TraitsUtils.sol";
import {TraitsContext} from "./TraitsContextStructs.sol";

/**
 * @author EtoVass
 */

contract Probabilities is IProbabilities {
    function getBodyTypeProbabilties() external view returns (uint32[12] memory) {
        uint32[12] memory probabilities;
        
        probabilities[uint(E_1_Type.Alien)]       = 30; 
        probabilities[uint(E_1_Type.Ape)]         = 70; 
        probabilities[uint(E_1_Type.Human_1)]    = 1550; 
        probabilities[uint(E_1_Type.Human_2)]    = 1550;
        probabilities[uint(E_1_Type.Human_3)]    = 1550; 
        probabilities[uint(E_1_Type.Human_4)]    = 1550; 
        probabilities[uint(E_1_Type.Human_5)]    = 1550; 
        probabilities[uint(E_1_Type.Human_6)]    = 1550; 
        probabilities[uint(E_1_Type.Radioactive)] = 40; 
        probabilities[uint(E_1_Type.Skeleton)]    = 70; 
        probabilities[uint(E_1_Type.Zombie)]      = 500; 
        probabilities[uint(E_1_Type.Demonic)]     = 25; 

        return probabilities;
    }

    function getMaleClothesProbabilities() external view returns (uint32[26] memory) {
        uint32[26] memory probabilities;
        
        probabilities[uint(E_3_Clothes.Bare_Chest)]                 = 3800;
        probabilities[uint(E_3_Clothes.Croptop_Black)]              = 50;
        probabilities[uint(E_3_Clothes.Croptop_Blue)]               = 50;
        probabilities[uint(E_3_Clothes.Croptop_Pink)]               = 20;
        probabilities[uint(E_3_Clothes.Croptop_Red)]                = 50;
        probabilities[uint(E_3_Clothes.Croptop_Burgundy)]           = 40;
        probabilities[uint(E_3_Clothes.Croptop_Green)]              = 50;
        probabilities[uint(E_3_Clothes.Croptop_White)]              = 50;
        probabilities[uint(E_3_Clothes.Tshirt_Black)]               = 700;
        probabilities[uint(E_3_Clothes.Tshirt_Blue)]                = 700;
        probabilities[uint(E_3_Clothes.Tshirt_Green)]               = 700;
        probabilities[uint(E_3_Clothes.Tshirt_Red)]                 = 650;
        probabilities[uint(E_3_Clothes.Tshirt_Burgundy)]            = 700;
        probabilities[uint(E_3_Clothes.Tshirt_White)]               = 700;
        probabilities[uint(E_3_Clothes.Vest_Black)]                 = 700;
        probabilities[uint(E_3_Clothes.Vest_Blue)]                  = 700;
        probabilities[uint(E_3_Clothes.Vest_Green)]                 = 700;
        probabilities[uint(E_3_Clothes.Vest_Red)]                   = 700;
        probabilities[uint(E_3_Clothes.Vest_Burgundy)]              = 700;
        probabilities[uint(E_3_Clothes.Vest_White)]                 = 700;
        probabilities[uint(E_3_Clothes.Long_Sleeved_Shirt_White)]   = 650; 
        probabilities[uint(E_3_Clothes.Long_Sleeved_Shirt_Green)]   = 650; 
        probabilities[uint(E_3_Clothes.Long_Sleeved_Shirt_Red)]     = 500; 
        probabilities[uint(E_3_Clothes.Long_Sleeved_Shirt_Blue)]    = 650; 
        probabilities[uint(E_3_Clothes.Long_Sleeved_Shirt_Burgundy)]= 650; 
        probabilities[uint(E_3_Clothes.Long_Sleeved_Shirt_Black)]   = 650; 

        return probabilities;
    }

    function getFemaleClothesProbabilities() external view returns (uint32[26] memory) {
        uint32[26] memory probabilities;
        
        probabilities[uint(E_3_Clothes.Bare_Chest)]                 = 50;
        probabilities[uint(E_3_Clothes.Croptop_Black)]              = 950;
        probabilities[uint(E_3_Clothes.Croptop_Blue)]               = 950;
        probabilities[uint(E_3_Clothes.Croptop_Pink)]               = 950;
        probabilities[uint(E_3_Clothes.Croptop_Red)]                = 950;
        probabilities[uint(E_3_Clothes.Croptop_White)]              = 950;
        probabilities[uint(E_3_Clothes.Croptop_Burgundy)]           = 600;
        probabilities[uint(E_3_Clothes.Croptop_Green)]              = 950;
        probabilities[uint(E_3_Clothes.Tshirt_Black)]               = 300;
        probabilities[uint(E_3_Clothes.Tshirt_Blue)]                = 200;
        probabilities[uint(E_3_Clothes.Tshirt_Green)]               = 200;
        probabilities[uint(E_3_Clothes.Tshirt_Red)]                 = 300;
        probabilities[uint(E_3_Clothes.Tshirt_Burgundy)]            = 200;
        probabilities[uint(E_3_Clothes.Tshirt_White)]               = 300;
        probabilities[uint(E_3_Clothes.Vest_Black)]                 = 950;
        probabilities[uint(E_3_Clothes.Vest_Blue)]                  = 950;
        probabilities[uint(E_3_Clothes.Vest_Green)]                 = 950;
        probabilities[uint(E_3_Clothes.Vest_Red)]                   = 950;
        probabilities[uint(E_3_Clothes.Vest_Burgundy)]              = 950;
        probabilities[uint(E_3_Clothes.Vest_White)]                 = 950;  
        probabilities[uint(E_3_Clothes.Long_Sleeved_Shirt_White)]   = 25; 
        probabilities[uint(E_3_Clothes.Long_Sleeved_Shirt_Green)]   = 25; 
        probabilities[uint(E_3_Clothes.Long_Sleeved_Shirt_Red)]     = 25; 
        probabilities[uint(E_3_Clothes.Long_Sleeved_Shirt_Blue)]    = 25; 
        probabilities[uint(E_3_Clothes.Long_Sleeved_Shirt_Burgundy)]= 25; 
        probabilities[uint(E_3_Clothes.Long_Sleeved_Shirt_Black)]   = 25; 

        return probabilities;
    }

    function getHairProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[] memory) {
        uint32[] memory probabilities = TraitsUtils.createProbabilityArray(NUM_5_Hair, 1000);
    
        if (traitsContext.masculine) {
            // skip beehive hair
            probabilities[uint(E_5_Hair.Beehive_Brown)] = 0;
            probabilities[uint(E_5_Hair.Beehive_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Beehive_Black)] = 0;
            probabilities[uint(E_5_Hair.Beehive_White)] = 0;
            probabilities[uint(E_5_Hair.Beehive_Ginger)] = 0;
            probabilities[uint(E_5_Hair.Beehive_Lavender)] = 0;
            probabilities[uint(E_5_Hair.Beehive_Mint)] = 0;
            probabilities[uint(E_5_Hair.Beehive_Flamingo)] = 0;
            probabilities[uint(E_5_Hair.Long_Straight_Lavender)] = 0;
            probabilities[uint(E_5_Hair.Long_Straight_Flamingo)] = 0;
            probabilities[uint(E_5_Hair.Long_Straight_Mint)] = 0;
            probabilities[uint(E_5_Hair.Pig_Tails_Flamingo)] = 0;  

        }  else {
            // set higher probability for some feminine hair types
            probabilities[uint(E_5_Hair.Beehive_Brown)]  = 1700;
            probabilities[uint(E_5_Hair.Beehive_Blonde)] = 1700;
            probabilities[uint(E_5_Hair.Beehive_Black)]  = 1700;
            probabilities[uint(E_5_Hair.Beehive_White)]  = 1400;
            probabilities[uint(E_5_Hair.Beehive_Ginger)] = 1400;
            probabilities[uint(E_5_Hair.Beehive_Lavender)] = 1200;
            probabilities[uint(E_5_Hair.Beehive_Mint)] = 1200;
            probabilities[uint(E_5_Hair.Beehive_Flamingo)] = 1200;
            probabilities[uint(E_5_Hair.Pig_Tails_Black)] = 1500;
            probabilities[uint(E_5_Hair.Pig_Tails_Blonde)] = 1500;
            probabilities[uint(E_5_Hair.Pig_Tails_Flamingo)] = 1100;   
            probabilities[uint(E_5_Hair.Long_Wavy_Brown)] = 1400;
            probabilities[uint(E_5_Hair.Long_Wavy_Blonde)] = 1400;
            probabilities[uint(E_5_Hair.Long_Wavy_Black)] = 1400;
            probabilities[uint(E_5_Hair.Long_Straight_Black)] = 1400;
            probabilities[uint(E_5_Hair.Long_Straight_Brown)] = 1400;
            probabilities[uint(E_5_Hair.Long_Straight_Blonde)] = 1400;
            probabilities[uint(E_5_Hair.Long_Straight_Lavender)] = 1100;
            probabilities[uint(E_5_Hair.Long_Straight_Flamingo)] = 1100;
            probabilities[uint(E_5_Hair.Long_Straight_Mint)] = 1100;
            probabilities[uint(E_5_Hair.Long_Straight_Ginger)] = 1100;
                  
        }


        if (TraitsUtils.isSkeleton(traitsContext)) {     
            // skip neat hair for skeletons
            // all brown should be commented out for skeletons as doesnt look great except for hilbily 
            // probabilities[uint(E_5_Hair.Shaved)] = 1000;
            probabilities[uint(E_5_Hair.Beehive_Brown)] = 0;
            probabilities[uint(E_5_Hair.Beehive_Blonde)] = 50;
            probabilities[uint(E_5_Hair.Beehive_Black)] = 400;
            probabilities[uint(E_5_Hair.Beehive_White)] = 300;
            probabilities[uint(E_5_Hair.Beehive_Ginger)] = 50;
            probabilities[uint(E_5_Hair.Beehive_Lavender)] = 200;
            probabilities[uint(E_5_Hair.Beehive_Mint)] = 200;
            probabilities[uint(E_5_Hair.Beehive_Flamingo)] = 300;
            probabilities[uint(E_5_Hair.Neat_Black)] = 0;
            probabilities[uint(E_5_Hair.Neat_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Neat_Ginger)] = 0;
            probabilities[uint(E_5_Hair.Neat_Brown)] = 0;
            probabilities[uint(E_5_Hair.Marine_Cut_Black)] = 0;
            probabilities[uint(E_5_Hair.Marine_Cut_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Flat_Top_Black)] = 0;
            probabilities[uint(E_5_Hair.Flat_Top_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Bald_Mullet_White)] = 900;
            probabilities[uint(E_5_Hair.Bald_Mullet_Brown)] = 700;
            probabilities[uint(E_5_Hair.Bald_Mullet_Blonde)] = 400;
            probabilities[uint(E_5_Hair.Fro_Blue)] = 300;
            probabilities[uint(E_5_Hair.Fro_Green)] = 550;
            probabilities[uint(E_5_Hair.Fro_Red)] = 550;
            probabilities[uint(E_5_Hair.Fro_Blonde)] = 550;
            probabilities[uint(E_5_Hair.Funky_Blonde)] = 700;
            probabilities[uint(E_5_Hair.Funky_Ginger)] = 800;
            probabilities[uint(E_5_Hair.Funky_Green)] = 900;
            probabilities[uint(E_5_Hair.Funky_Purple)] = 700;
            probabilities[uint(E_5_Hair.Funky_Red)] = 900;
            probabilities[uint(E_5_Hair.Funky_White)] = 900;
            probabilities[uint(E_5_Hair.Funky_Brown)] = 0;
            probabilities[uint(E_5_Hair.Funky_Blue)] = 500;
            probabilities[uint(E_5_Hair.Funky_Teal)] = 700;
            // probabilities[uint(E_5_Hair.Locks_Black)] = 900;
            // probabilities[uint(E_5_Hair.Locks_Blonde)] = 900;
            probabilities[uint(E_5_Hair.Locks_Ginger)] = 850;
            probabilities[uint(E_5_Hair.Locks_Brown)] = 0;
            probabilities[uint(E_5_Hair.Locks_Green)] = 900;
            probabilities[uint(E_5_Hair.Locks_Red)] = 900;
            probabilities[uint(E_5_Hair.Locks_White)] = 800;
            probabilities[uint(E_5_Hair.Locks_Blue)] = 600;
            probabilities[uint(E_5_Hair.Locks_Purple)] = 750;
            probabilities[uint(E_5_Hair.Mohawk_Teal)] = 800;
            probabilities[uint(E_5_Hair.Mohawk_White)] = 900;
            probabilities[uint(E_5_Hair.Mohawk_Ginger)] = 800;
            probabilities[uint(E_5_Hair.Mohawk_Green)] = 900;
            probabilities[uint(E_5_Hair.Mohawk_Blue)] = 600;
            probabilities[uint(E_5_Hair.Mohawk_Red)] = 900;
            probabilities[uint(E_5_Hair.Mohawk_Black)] = 900;
            probabilities[uint(E_5_Hair.Mohawk_Blonde)] = 700;
            probabilities[uint(E_5_Hair.Mohawk_Purple)] = 900;
            probabilities[uint(E_5_Hair.Spikey_Purple)] = 800;
            probabilities[uint(E_5_Hair.Spikey_Ginger)] = 800;
            probabilities[uint(E_5_Hair.Spikey_Blue)] = 500;
            probabilities[uint(E_5_Hair.Spikey_Green)] = 900;
            probabilities[uint(E_5_Hair.Spikey_Red)] = 900;
            probabilities[uint(E_5_Hair.Spikey_Brown)] = 0;
            probabilities[uint(E_5_Hair.Spikey_White)] = 900;
            probabilities[uint(E_5_Hair.Quiff_Blonde)] = 700;
            probabilities[uint(E_5_Hair.Quiff_Black)] = 800;
            probabilities[uint(E_5_Hair.Quiff_Brown)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Black)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Brown)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_White)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Green)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Brown)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Red)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Blue)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Purple)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Ginger)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Black_Skeleton)] = 900;  // HILLBILLY HAIR FOR SKELETONS 
            probabilities[uint(E_5_Hair.Hillbilly_Brown_Skeleton)] = 700;
            probabilities[uint(E_5_Hair.Hillbilly_Blonde_Skeleton)] = 700;
            probabilities[uint(E_5_Hair.Hillbilly_White_Skeleton)] = 900;
            probabilities[uint(E_5_Hair.Hillbilly_Green_Skeleton)] = 800;
            probabilities[uint(E_5_Hair.Hillbilly_Red_Skeleton)] = 800;
            probabilities[uint(E_5_Hair.Hillbilly_Blue_Skeleton)] = 600;
            probabilities[uint(E_5_Hair.Hillbilly_Purple_Skeleton)] = 800;
            probabilities[uint(E_5_Hair.Hillbilly_Ginger_Skeleton)] = 700;
            probabilities[uint(E_5_Hair.Tight_Brown)] = 0;
            probabilities[uint(E_5_Hair.Tight_Black)] = 900;
            probabilities[uint(E_5_Hair.Tight_Blonde)] = 600;
            probabilities[uint(E_5_Hair.Tight_Ginger)] = 600;
            probabilities[uint(E_5_Hair.Long_Wavy_Brown)] = 0;
            probabilities[uint(E_5_Hair.Long_Wavy_Blonde)] = 400;
            probabilities[uint(E_5_Hair.Long_Wavy_Black)] = 500;
            probabilities[uint(E_5_Hair.Long_Straight_Black)] = 800;
            probabilities[uint(E_5_Hair.Long_Straight_Brown)] = 0;
            probabilities[uint(E_5_Hair.Long_Straight_Blonde)] = 500;
            probabilities[uint(E_5_Hair.Long_Straight_Ginger)] = 500;
            probabilities[uint(E_5_Hair.Long_Straight_Lavender)] = 600;
            probabilities[uint(E_5_Hair.Long_Straight_Flamingo)] = 600;
            probabilities[uint(E_5_Hair.Long_Straight_Mint)] = 700;
            probabilities[uint(E_5_Hair.Buzz_Cut_Black)] = 800;
            probabilities[uint(E_5_Hair.Buzz_Cut_Blonde)] = 400;
            probabilities[uint(E_5_Hair.Buzz_Cut_Ginger)] = 500;
            probabilities[uint(E_5_Hair.Buzz_Cut_Brown)] = 0;
            probabilities[uint(E_5_Hair.Brit_Pop_Cut_Black)] = 0;
            probabilities[uint(E_5_Hair.Brit_Pop_Cut_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Brit_Pop_Cut_Ginger)] = 0;
            probabilities[uint(E_5_Hair.Brit_Pop_Cut_Brown)] = 0;
            probabilities[uint(E_5_Hair.Clean_Cut_Brown)] = 0;
            probabilities[uint(E_5_Hair.Clean_Cut_Black)] = 900;
            probabilities[uint(E_5_Hair.Clean_Cut_Blonde)] = 400;
            probabilities[uint(E_5_Hair.Clean_Cut_Lavender)] = 600;
            probabilities[uint(E_5_Hair.Clean_Cut_Ginger)] = 500;
            probabilities[uint(E_5_Hair.Clean_Cut_Mint)] = 600;
            probabilities[uint(E_5_Hair.Clean_Cut_Flamingo)] = 600;
            probabilities[uint(E_5_Hair.Pig_Tails_Black)] = 600;
            probabilities[uint(E_5_Hair.Pig_Tails_Blonde)] = 400;  
            probabilities[uint(E_5_Hair.Pig_Tails_Flamingo)] = 600;  
            probabilities[uint(E_5_Hair.Messy_Ginger)] = 400;
        } 
        else if (TraitsUtils.isAlien(traitsContext) || TraitsUtils.isRadioactive(traitsContext) || TraitsUtils.isDemonic(traitsContext)) {
            probabilities[uint(E_5_Hair.Neat_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Bald_Mullet_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Beehive_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Marine_Cut_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Flat_Top_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Funky_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Spikey_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Locks_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Quiff_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Long_Wavy_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Long_Straight_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Buzz_Cut_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Brit_Pop_Cut_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Clean_Cut_Blonde)] = 0;
            probabilities[uint(E_5_Hair.Pig_Tails_Blonde)] = 0;  
        } else {
            // set other probabilities here
            // probabilities[uint(E_5_Hair.Shaved)] = 900;
            probabilities[uint(E_5_Hair.Bald_Mullet_White)] = 800;
            probabilities[uint(E_5_Hair.Bald_Mullet_Brown)] = 900;
            probabilities[uint(E_5_Hair.Bald_Mullet_Blonde)] = 850;
            probabilities[uint(E_5_Hair.Flat_Top_Black)] = 950;
            probabilities[uint(E_5_Hair.Flat_Top_Blonde)] = 950;
            probabilities[uint(E_5_Hair.Neat_Black)] = 900;
            probabilities[uint(E_5_Hair.Neat_Blonde)] = 850;
            probabilities[uint(E_5_Hair.Neat_Brown)] = 850;
            probabilities[uint(E_5_Hair.Neat_Ginger)] = 600;
            probabilities[uint(E_5_Hair.Fro_Blue)] = 150;
            probabilities[uint(E_5_Hair.Fro_Green)] = 250;
            probabilities[uint(E_5_Hair.Fro_Red)] = 400;
            probabilities[uint(E_5_Hair.Fro_Blonde)] = 900;
            probabilities[uint(E_5_Hair.Funky_Blonde)] = 900;
            probabilities[uint(E_5_Hair.Funky_Ginger)] = 800;
            probabilities[uint(E_5_Hair.Funky_Green)] = 600;
            probabilities[uint(E_5_Hair.Funky_Purple)] = 450;
            probabilities[uint(E_5_Hair.Funky_Red)] = 600;
            probabilities[uint(E_5_Hair.Funky_Brown)] = 900; 
            probabilities[uint(E_5_Hair.Funky_White)] = 550;
            probabilities[uint(E_5_Hair.Funky_Blue)] = 100;
            probabilities[uint(E_5_Hair.Funky_Teal)] = 550;
            // probabilities[uint(E_5_Hair.Locks_Black)] = 900;
            // probabilities[uint(E_5_Hair.Locks_Blonde)] = 900;
            probabilities[uint(E_5_Hair.Locks_Ginger)] = 850;
            probabilities[uint(E_5_Hair.Locks_Green)] = 850;
            probabilities[uint(E_5_Hair.Locks_Red)] = 850;
            probabilities[uint(E_5_Hair.Locks_Blue)] = 400;
            probabilities[uint(E_5_Hair.Locks_White)] = 650;
            probabilities[uint(E_5_Hair.Locks_Purple)] = 550;
            // probabilities[uint(E_5_Hair.Locks_Brown)] = 650;
            probabilities[uint(E_5_Hair.Marine_Cut_Black)] = 900;
            probabilities[uint(E_5_Hair.Marine_Cut_Blonde)] = 900;
            probabilities[uint(E_5_Hair.Mohawk_Teal)] = 700;
            probabilities[uint(E_5_Hair.Mohawk_White)] = 650;
            probabilities[uint(E_5_Hair.Mohawk_Ginger)] = 850;
            probabilities[uint(E_5_Hair.Mohawk_Blue)] = 200;
            probabilities[uint(E_5_Hair.Mohawk_Green)] = 800;
            probabilities[uint(E_5_Hair.Mohawk_Red)] = 800;
            probabilities[uint(E_5_Hair.Mohawk_Black)] = 900;
            probabilities[uint(E_5_Hair.Mohawk_Blonde)] = 900;
            probabilities[uint(E_5_Hair.Mohawk_Purple)] = 700;
            probabilities[uint(E_5_Hair.Quiff_Blonde)] = 900;
            probabilities[uint(E_5_Hair.Quiff_Black)] = 900;
            probabilities[uint(E_5_Hair.Quiff_Brown)] = 90;
            probabilities[uint(E_5_Hair.Spikey_Purple)] = 500;
            probabilities[uint(E_5_Hair.Spikey_Ginger)] = 550;
            probabilities[uint(E_5_Hair.Spikey_Green)] = 700;
            probabilities[uint(E_5_Hair.Spikey_Blue)] = 400;
            probabilities[uint(E_5_Hair.Spikey_Red)] = 700;
            probabilities[uint(E_5_Hair.Spikey_Brown)] = 900;
            probabilities[uint(E_5_Hair.Spikey_White)] = 700;
            // probabilities[uint(E_5_Hair.Hillbilly_Black)] = 900; // defaulting to 1000 if commented out 
            // probabilities[uint(E_5_Hair.Hillbilly_Brown)] = 900;
            // probabilities[uint(E_5_Hair.Hillbilly_Blonde)] = 900;
            probabilities[uint(E_5_Hair.Hillbilly_White)] = 550;
            probabilities[uint(E_5_Hair.Hillbilly_Green)] = 750;
            probabilities[uint(E_5_Hair.Hillbilly_Red)] = 750;
            probabilities[uint(E_5_Hair.Hillbilly_Blue)] = 150;
            probabilities[uint(E_5_Hair.Hillbilly_Purple)] = 90;
            probabilities[uint(E_5_Hair.Hillbilly_Ginger)] = 800;
            probabilities[uint(E_5_Hair.Hillbilly_Black_Skeleton)] = 0; // HILLBILLY HAIR FOR SKELETONS ZERO'D OUT
            probabilities[uint(E_5_Hair.Hillbilly_Brown_Skeleton)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Blonde_Skeleton)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_White_Skeleton)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Green_Skeleton)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Red_Skeleton)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Blue_Skeleton)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Purple_Skeleton)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Ginger_Skeleton)] = 0;
            probabilities[uint(E_5_Hair.Tight_Black)] = 900;
            probabilities[uint(E_5_Hair.Tight_Blonde)] = 900;
            probabilities[uint(E_5_Hair.Tight_Brown)] = 900;
            probabilities[uint(E_5_Hair.Tight_Ginger)] = 800;
            probabilities[uint(E_5_Hair.Long_Wavy_Brown)] = 550;
            probabilities[uint(E_5_Hair.Long_Wavy_Blonde)] = 550;
            probabilities[uint(E_5_Hair.Long_Wavy_Black)] = 550;
            probabilities[uint(E_5_Hair.Long_Straight_Black)] = 750;
            probabilities[uint(E_5_Hair.Long_Straight_Brown)] = 700;
            probabilities[uint(E_5_Hair.Long_Straight_Blonde)] = 750;
            probabilities[uint(E_5_Hair.Long_Straight_Lavender)] = 300;
            probabilities[uint(E_5_Hair.Long_Straight_Flamingo)] = 300;
            probabilities[uint(E_5_Hair.Long_Straight_Mint)] = 250;
            // probabilities[uint(E_5_Hair.Buzz_Cut_Black)] = 800;
            // probabilities[uint(E_5_Hair.Buzz_Cut_Blonde)] = 800;
            probabilities[uint(E_5_Hair.Buzz_Cut_Ginger)] = 800;
            probabilities[uint(E_5_Hair.Buzz_Cut_Brown)] = 900;
            probabilities[uint(E_5_Hair.Brit_Pop_Cut_Black)] = 700;
            probabilities[uint(E_5_Hair.Brit_Pop_Cut_Blonde)] = 700;
            probabilities[uint(E_5_Hair.Brit_Pop_Cut_Ginger)] = 200;
            probabilities[uint(E_5_Hair.Brit_Pop_Cut_Brown)] = 750;
            probabilities[uint(E_5_Hair.Clean_Cut_Brown)] = 900;
            // probabilities[uint(E_5_Hair.Clean_Cut_Black)] = 900;
            // probabilities[uint(E_5_Hair.Clean_Cut_Blonde)] = 900;
            probabilities[uint(E_5_Hair.Clean_Cut_Lavender)] = 500;
            probabilities[uint(E_5_Hair.Clean_Cut_Ginger)] = 750;
            probabilities[uint(E_5_Hair.Clean_Cut_Mint)] = 700;
            probabilities[uint(E_5_Hair.Clean_Cut_Flamingo)] = 650;
            probabilities[uint(E_5_Hair.Pig_Tails_Black)] = 800;
            probabilities[uint(E_5_Hair.Pig_Tails_Blonde)] = 400;  
            probabilities[uint(E_5_Hair.Messy_Ginger)] = 600;
        }

        if (TraitsUtils.isHuman6(traitsContext) || !TraitsUtils.isHuman(traitsContext)){
            // set other probabilities here
            probabilities[uint(E_5_Hair.Beehive_Brown)] = 0;
            probabilities[uint(E_5_Hair.Bald_Mullet_Brown)] = 0;
            probabilities[uint(E_5_Hair.Neat_Brown)] = 0;
            probabilities[uint(E_5_Hair.Funky_Brown)] = 0;
            probabilities[uint(E_5_Hair.Locks_Brown)] = 0;
            probabilities[uint(E_5_Hair.Spikey_Brown)] = 0;
            probabilities[uint(E_5_Hair.Hillbilly_Brown)] = 0;
            probabilities[uint(E_5_Hair.Long_Wavy_Brown)] = 0;
            probabilities[uint(E_5_Hair.Long_Straight_Brown)] = 0;
            probabilities[uint(E_5_Hair.Messy_Brown)] = 0;
            probabilities[uint(E_5_Hair.Quiff_Brown)] = 0;
            probabilities[uint(E_5_Hair.Tight_Brown)] = 0;
            probabilities[uint(E_5_Hair.Buzz_Cut_Brown)] = 0;
            probabilities[uint(E_5_Hair.Clean_Cut_Brown)] = 0;
            probabilities[uint(E_5_Hair.Brit_Pop_Cut_Brown)] = 0;
        }

        return probabilities;
    }

    function getHatHairProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[49] memory) {
        uint32[49] memory probabilities;

        probabilities[uint(E_5b_Hat_Hair.None)]             = 6000; 
        probabilities[uint(E_5b_Hat_Hair.Funky_Black_Hat)]  = 950;
        probabilities[uint(E_5b_Hat_Hair.Funky_Blonde_Hat)] = 950;
        probabilities[uint(E_5b_Hat_Hair.Funky_Ginger_Hat)] = 650;
        probabilities[uint(E_5b_Hat_Hair.Funky_Green_Hat)]  = 500;
        probabilities[uint(E_5b_Hat_Hair.Funky_Purple_Hat)] = 300;
        probabilities[uint(E_5b_Hat_Hair.Funky_Brown_Hat)] = 900;
        probabilities[uint(E_5b_Hat_Hair.Funky_Red_Hat)]    = 500;
        probabilities[uint(E_5b_Hat_Hair.Funky_White_Hat)]  = 300;
        probabilities[uint(E_5b_Hat_Hair.Funky_Blue_Hat)]   = 100;
        probabilities[uint(E_5b_Hat_Hair.Funky_Teal_Hat)]   = 450;
        probabilities[uint(E_5b_Hat_Hair.Hillbilly_Black_Hat)] = 950;
        probabilities[uint(E_5b_Hat_Hair.Hillbilly_Blonde_Hat)] = 950;
        probabilities[uint(E_5b_Hat_Hair.Hillbilly_Brown_Hat)] = 900;
        probabilities[uint(E_5b_Hat_Hair.Hillbilly_Ginger_Hat)] = 700;
        probabilities[uint(E_5b_Hat_Hair.Hillbilly_Green_Hat)] = 500;
        probabilities[uint(E_5b_Hat_Hair.Hillbilly_Red_Hat)] = 500;
        probabilities[uint(E_5b_Hat_Hair.Hillbilly_Purple_Hat)] = 300;
        probabilities[uint(E_5b_Hat_Hair.Hillbilly_White_Hat)] = 300;
        probabilities[uint(E_5b_Hat_Hair.Hillbilly_Blue_Hat)] = 100;
        probabilities[uint(E_5b_Hat_Hair.Neat_Black_Hat)]   = 950;
        probabilities[uint(E_5b_Hat_Hair.Neat_Blonde_Hat)]  = 950;
        probabilities[uint(E_5b_Hat_Hair.Neat_Ginger_Hat)]  = 800;
        probabilities[uint(E_5b_Hat_Hair.Neat_Brown_Hat)]  = 900;
        probabilities[uint(E_5b_Hat_Hair.Long_Straight_Black_Hat)]  = 950;
        probabilities[uint(E_5b_Hat_Hair.Long_Straight_Blonde_Hat)]  = 950;
        probabilities[uint(E_5b_Hat_Hair.Long_Straight_Flamingo_Hat)]  = 400;
        probabilities[uint(E_5b_Hat_Hair.Long_Straight_Mint_Hat)]  = 500;
        probabilities[uint(E_5b_Hat_Hair.Long_Straight_Lavender_Hat)]  = 400;
        probabilities[uint(E_5b_Hat_Hair.Long_Straight_Brown_Hat)]  = 900;
        probabilities[uint(E_5b_Hat_Hair.Long_Straight_Ginger_Hat)]  = 800;

        probabilities[uint(E_5b_Hat_Hair.Regular_Black_Hat)]  = 950;
        probabilities[uint(E_5b_Hat_Hair.Regular_Blonde_Hat)]  = 950;
        probabilities[uint(E_5b_Hat_Hair.Regular_Brown_Hat)]  = 850;
        probabilities[uint(E_5b_Hat_Hair.Regular_Ginger_Hat)]  = 800;
        probabilities[uint(E_5b_Hat_Hair.Regular_Green_Hat)]  = 400;
        probabilities[uint(E_5b_Hat_Hair.Regular_Red_Hat)]  = 500;
        probabilities[uint(E_5b_Hat_Hair.Regular_Purple_Hat)]  = 300;
        probabilities[uint(E_5b_Hat_Hair.Regular_Teal_Hat)]  = 400;
        probabilities[uint(E_5b_Hat_Hair.Regular_White_Hat)]  = 300;
        probabilities[uint(E_5b_Hat_Hair.Regular_Blue_Hat)]  = 150;

        if (!traitsContext.masculine) {
            probabilities[uint(E_5b_Hat_Hair.Long_Wavy_Black_Hat)] = 1000;
            probabilities[uint(E_5b_Hat_Hair.Long_Wavy_Blonde_Hat)] = 1000;
            probabilities[uint(E_5b_Hat_Hair.Long_Wavy_Brown_Hat)] = 1000;
            probabilities[uint(E_5b_Hat_Hair.Long_Wavy_Ginger_Hat)] = 1000;
            probabilities[uint(E_5b_Hat_Hair.Long_Wavy_Flamingo_Hat)] = 600;
            probabilities[uint(E_5b_Hat_Hair.Long_Wavy_Lavender_Hat)] = 600;
            probabilities[uint(E_5b_Hat_Hair.Long_Wavy_Mint_Hat)] = 600;
            probabilities[uint(E_5b_Hat_Hair.Long_Wavy_White_Hat)] = 600;
        }  else {
            probabilities[uint(E_5b_Hat_Hair.Long_Wavy_Black_Hat)] = 0;
            probabilities[uint(E_5b_Hat_Hair.Long_Wavy_Blonde_Hat)] = 0;
            probabilities[uint(E_5b_Hat_Hair.Long_Wavy_Brown_Hat)] = 0;
            probabilities[uint(E_5b_Hat_Hair.Long_Wavy_Ginger_Hat)] = 0;
            probabilities[uint(E_5b_Hat_Hair.Long_Wavy_Flamingo_Hat)] = 0;
            probabilities[uint(E_5b_Hat_Hair.Long_Wavy_Lavender_Hat)] = 0;
            probabilities[uint(E_5b_Hat_Hair.Long_Wavy_Mint_Hat)] = 0;
            probabilities[uint(E_5b_Hat_Hair.Long_Wavy_White_Hat)] = 0;

        }
        
        if (TraitsUtils.isSkeleton(traitsContext)) {
            // skip certain hair for skeletons
            probabilities[uint(E_5b_Hat_Hair.Neat_Black_Hat)] = 0;
            probabilities[uint(E_5b_Hat_Hair.Neat_Blonde_Hat)] = 0;
            probabilities[uint(E_5b_Hat_Hair.Neat_Brown_Hat)] = 0;
            probabilities[uint(E_5b_Hat_Hair.Neat_Ginger_Hat)] = 0;
            // probabilities[uint(E_5b_Hat_Hair.Regular_Black_Hat)]  = 0;
            // probabilities[uint(E_5b_Hat_Hair.Regular_Blonde_Hat)]  = 0;
            // probabilities[uint(E_5b_Hat_Hair.Regular_Brown_Hat)]  = 0;
            // probabilities[uint(E_5b_Hat_Hair.Regular_Ginger_Hat)]  = 0;
            // probabilities[uint(E_5b_Hat_Hair.Regular_Green_Hat)]  = 0;
            // probabilities[uint(E_5b_Hat_Hair.Regular_Red_Hat)]  = 0;
            // probabilities[uint(E_5b_Hat_Hair.Regular_Purple_Hat)]  = 0;
            // probabilities[uint(E_5b_Hat_Hair.Regular_Teal_Hat)]  = 0;
            // probabilities[uint(E_5b_Hat_Hair.Regular_White_Hat)]  = 0;
            // probabilities[uint(E_5b_Hat_Hair.Regular_Blue_Hat)]  = 0;

        }

        if (TraitsUtils.isAlien(traitsContext) || TraitsUtils.isRadioactive(traitsContext) || TraitsUtils.isDemonic(traitsContext) || TraitsUtils.isSkeleton(traitsContext) || TraitsUtils.isApe(traitsContext)) {
            // special probabolity for alien and radioactive hat hair 
            probabilities[uint(E_5b_Hat_Hair.None)]             = 5000; 
            probabilities[uint(E_5b_Hat_Hair.Funky_Black_Hat)]  = 900;
            probabilities[uint(E_5b_Hat_Hair.Funky_Blonde_Hat)] = 0;
            probabilities[uint(E_5b_Hat_Hair.Funky_Ginger_Hat)] = 400;
            probabilities[uint(E_5b_Hat_Hair.Funky_Green_Hat)]  = 700;
            probabilities[uint(E_5b_Hat_Hair.Funky_Purple_Hat)] = 600;
            probabilities[uint(E_5b_Hat_Hair.Funky_Brown_Hat)] = 0;
            probabilities[uint(E_5b_Hat_Hair.Funky_Red_Hat)]    = 700;
            probabilities[uint(E_5b_Hat_Hair.Funky_White_Hat)]  = 500;
            probabilities[uint(E_5b_Hat_Hair.Funky_Blue_Hat)]   = 400;
            probabilities[uint(E_5b_Hat_Hair.Funky_Teal_Hat)]   = 700;
            probabilities[uint(E_5b_Hat_Hair.Hillbilly_Black_Hat)] = 900;
            probabilities[uint(E_5b_Hat_Hair.Hillbilly_Blonde_Hat)] = 0;
            probabilities[uint(E_5b_Hat_Hair.Hillbilly_Brown_Hat)] = 0;
            probabilities[uint(E_5b_Hat_Hair.Hillbilly_Ginger_Hat)] = 400;
            probabilities[uint(E_5b_Hat_Hair.Hillbilly_Green_Hat)] = 700;
            probabilities[uint(E_5b_Hat_Hair.Hillbilly_Red_Hat)] = 700;
            probabilities[uint(E_5b_Hat_Hair.Hillbilly_Purple_Hat)] = 500;
            probabilities[uint(E_5b_Hat_Hair.Hillbilly_White_Hat)] = 400;
            probabilities[uint(E_5b_Hat_Hair.Hillbilly_Blue_Hat)] = 300;

            probabilities[uint(E_5b_Hat_Hair.Neat_Black_Hat)]   = 600;
            probabilities[uint(E_5b_Hat_Hair.Neat_Blonde_Hat)]  = 0;
            probabilities[uint(E_5b_Hat_Hair.Neat_Brown_Hat)]  = 0;
            probabilities[uint(E_5b_Hat_Hair.Neat_Ginger_Hat)]  = 0;
            probabilities[uint(E_5b_Hat_Hair.Long_Straight_Black_Hat)]  = 500;
            probabilities[uint(E_5b_Hat_Hair.Long_Straight_Blonde_Hat)]  = 0;
            probabilities[uint(E_5b_Hat_Hair.Long_Straight_Flamingo_Hat)]  = 600;
            probabilities[uint(E_5b_Hat_Hair.Long_Straight_Mint_Hat)]  = 700;
            probabilities[uint(E_5b_Hat_Hair.Long_Straight_Lavender_Hat)]  = 700;
            probabilities[uint(E_5b_Hat_Hair.Long_Straight_Brown_Hat)]  = 0;
            probabilities[uint(E_5b_Hat_Hair.Long_Straight_Ginger_Hat)]  = 300;

                        
            probabilities[uint(E_5b_Hat_Hair.Regular_Black_Hat)]  = 800;
            probabilities[uint(E_5b_Hat_Hair.Regular_Blonde_Hat)]  = 0;
            probabilities[uint(E_5b_Hat_Hair.Regular_Brown_Hat)]  = 0;
            probabilities[uint(E_5b_Hat_Hair.Regular_Ginger_Hat)]  = 700;
            probabilities[uint(E_5b_Hat_Hair.Regular_Green_Hat)]  = 500;
            probabilities[uint(E_5b_Hat_Hair.Regular_Red_Hat)]  = 500;
            probabilities[uint(E_5b_Hat_Hair.Regular_Purple_Hat)]  = 400;
            probabilities[uint(E_5b_Hat_Hair.Regular_Teal_Hat)]  = 500;
            probabilities[uint(E_5b_Hat_Hair.Regular_White_Hat)]  = 400;
            probabilities[uint(E_5b_Hat_Hair.Regular_Blue_Hat)]  = 300;

        }

        if (TraitsUtils.isHuman6(traitsContext)){
            probabilities[uint(E_5b_Hat_Hair.Funky_Brown_Hat)] = 0;
            probabilities[uint(E_5b_Hat_Hair.Neat_Brown_Hat)]  = 0;
            probabilities[uint(E_5b_Hat_Hair.Long_Straight_Brown_Hat)]  = 0;
            probabilities[uint(E_5b_Hat_Hair.Hillbilly_Brown_Hat)] = 0;
            probabilities[uint(E_5b_Hat_Hair.Regular_Blonde_Hat)]  = 0;
            probabilities[uint(E_5b_Hat_Hair.Long_Wavy_Brown_Hat)] = 0;
        }

        return probabilities;
    }

    function getClothes2Probabilities(TraitsContext calldata traitsContext) external view returns (uint32[11] memory) {
        uint32[11] memory probabilities;

        if (TraitsUtils.hasLongSleeves(traitsContext) || TraitsUtils.hasTshirt(traitsContext) || TraitsUtils.hasVest(traitsContext) || TraitsUtils.hasCropTop(traitsContext)) {
            // Prevent some open shirts colours from being chosen if any other clothes selected above^^^^^^
            probabilities[uint(E_3b_Clothes.None)]                  = 0;
            probabilities[uint(E_3b_Clothes.Open_Shirt_Black)]      = 1000; 
            probabilities[uint(E_3b_Clothes.Open_Shirt_White)]      = 1000;
            probabilities[uint(E_3b_Clothes.Open_Shirt_Pink)]       = 0;
            probabilities[uint(E_3b_Clothes.Open_Shirt_Baby_Blue)]  = 0;
            probabilities[uint(E_3b_Clothes.Open_Shirt_Teal)]       = 0;
            probabilities[uint(E_3b_Clothes.Open_Shirt_Yellow)]     = 0;
            probabilities[uint(E_3b_Clothes.Open_Shirt_Red)]        = 0;
            probabilities[uint(E_3b_Clothes.Leather_Jacket_Cream)]  = 800;
            probabilities[uint(E_3b_Clothes.Leather_Jacket_Black)]  = 800;
            probabilities[uint(E_3b_Clothes.Leather_Jacket_Red)]    = 400;
        } else {
            probabilities[uint(E_3b_Clothes.None)]                  = 0;
            probabilities[uint(E_3b_Clothes.Open_Shirt_Black)]       = 1000;
            probabilities[uint(E_3b_Clothes.Open_Shirt_White)]      = 1000;
            probabilities[uint(E_3b_Clothes.Open_Shirt_Pink)]       = 600;
            probabilities[uint(E_3b_Clothes.Open_Shirt_Baby_Blue)]  = 750;
            probabilities[uint(E_3b_Clothes.Open_Shirt_Teal)]       = 850;
            probabilities[uint(E_3b_Clothes.Open_Shirt_Yellow)]     = 850;
            probabilities[uint(E_3b_Clothes.Open_Shirt_Red)]        = 850;
            probabilities[uint(E_3b_Clothes.Leather_Jacket_Cream)]  = 800;
            probabilities[uint(E_3b_Clothes.Leather_Jacket_Black)]  = 800;
            probabilities[uint(E_3b_Clothes.Leather_Jacket_Red)]    = 400;
        }


        return probabilities;
    }

    function getEyesProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[11] memory) {
        uint32[11] memory probabilities;
        probabilities[uint(E_6_Eyes.Blind)]          = 6;
        probabilities[uint(E_6_Eyes.Confused)]       = 650;
        probabilities[uint(E_6_Eyes.Left)]           = 1000;
        probabilities[uint(E_6_Eyes.Posessed)]       = 12;
        probabilities[uint(E_6_Eyes.Right)]          = 950;
        probabilities[uint(E_6_Eyes.Smokey_Blue)]    = 40;
        probabilities[uint(E_6_Eyes.Smokey_Green)]   = 30;
        probabilities[uint(E_6_Eyes.Smokey_Purple)]  = 50;
        probabilities[uint(E_6_Eyes.Tired_Confused)] = 300;
        probabilities[uint(E_6_Eyes.Tired_Left)]     = 450;
        probabilities[uint(E_6_Eyes.Tired_Right)]    = 500;

        if (!traitsContext.masculine) {
            // feminine has higher probability of smokey eyes
            probabilities[uint(E_6_Eyes.Smokey_Blue)]     = 1800;
            probabilities[uint(E_6_Eyes.Smokey_Green)]    = 2000;
            probabilities[uint(E_6_Eyes.Smokey_Purple)]   = 2200;
        }

        return probabilities;
    }

    function getEyewearProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[32] memory) {
        uint32[32] memory probabilities;
        
        probabilities[uint(E_6b_Eye_Wear.None)]             = 0;
        probabilities[uint(E_6b_Eye_Wear._3d_Glasses)]      = 750;
        probabilities[uint(E_6b_Eye_Wear._3d_Glasses_Black)] = 250;
        probabilities[uint(E_6b_Eye_Wear.Beach_Shades)]     = 1000;
        probabilities[uint(E_6b_Eye_Wear.Big_Shades_Black)] = 600;
        probabilities[uint(E_6b_Eye_Wear.Big_Shades_White)] = 400;
        probabilities[uint(E_6b_Eye_Wear.Big_Shades_Aqua)] = 70;
        probabilities[uint(E_6b_Eye_Wear.Big_Shades_Pink)]   = 30;
        probabilities[uint(E_6b_Eye_Wear.Big_Shades_Red_Lens)] = 50;
        probabilities[uint(E_6b_Eye_Wear.Vintage_Shades)]     = 20;
        probabilities[uint(E_6b_Eye_Wear.White_Frame_Shades)] = 800;
        probabilities[uint(E_6b_Eye_Wear.Blue_Frame_Shades)] = 80;
        probabilities[uint(E_6b_Eye_Wear.Red_Frame_Shades)] = 130;
        probabilities[uint(E_6b_Eye_Wear.Green_Frame_Shades)] = 50;
        probabilities[uint(E_6b_Eye_Wear.Yellow_Frame_Shades)] = 25;
        probabilities[uint(E_6b_Eye_Wear.Pink_Frame_Shades)] = 20;
        probabilities[uint(E_6b_Eye_Wear.Aviators)]         = 900;
        probabilities[uint(E_6b_Eye_Wear.Aviators_Xl)]      = 400;
        probabilities[uint(E_6b_Eye_Wear.Eye_Mask)]         = 850;
        probabilities[uint(E_6b_Eye_Wear.Eye_Patch_Right)]  = 750;
        probabilities[uint(E_6b_Eye_Wear.Eye_Patch_Left)]   = 150;
        probabilities[uint(E_6b_Eye_Wear.Fly_Shades)]       = 750;
        probabilities[uint(E_6b_Eye_Wear.Geek_Glasses_Black)] = 500;
        probabilities[uint(E_6b_Eye_Wear.Geek_Glasses_Red)] = 350;
        probabilities[uint(E_6b_Eye_Wear.Vibey_Shades)]     = 950;
        probabilities[uint(E_6b_Eye_Wear.Retro_Shades)]     = 1000;
        probabilities[uint(E_6b_Eye_Wear.Fancy_Shades)]     = 900;
        probabilities[uint(E_6b_Eye_Wear.Shades)]           = 1000;
        probabilities[uint(E_6b_Eye_Wear.Vr_Blue)]          = 100;
        probabilities[uint(E_6b_Eye_Wear.Vr_Green)]         = 600;
        probabilities[uint(E_6b_Eye_Wear.Vr_Red)]           = 250;
        probabilities[uint(E_6b_Eye_Wear.Red_Lens_Bad_Boys)]= 250; 

        if (TraitsUtils.isSkeleton(traitsContext)) {
            // skip eye patch for skeletons
            probabilities[uint(E_6b_Eye_Wear.Eye_Patch_Right)]  = 0;
            probabilities[uint(E_6b_Eye_Wear.Eye_Patch_Left)]   = 0;
        }
        

        if (!TraitsUtils.isHuman(traitsContext)) {
            // Skip eye mask for apes, zombies, skeletons, aliens, and radioactive - So only for humans 
            probabilities[uint(E_6b_Eye_Wear.Eye_Mask)] = 0;
            probabilities[uint(E_6b_Eye_Wear.Geek_Glasses_Black)] = 0;
            probabilities[uint(E_6b_Eye_Wear.Geek_Glasses_Red)] = 0;
        }

        return probabilities;
    }
    
    function getLipGlossProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[4] memory) {
        uint32[4] memory probabilities;
        
        probabilities[uint(E_7_Lip_Gloss.None)]             = 4500; 
        probabilities[uint(E_7_Lip_Gloss.Lip_Gloss_Purple)] = 3000; 
        probabilities[uint(E_7_Lip_Gloss.Lip_Gloss_Red)]    = 3000; 
        probabilities[uint(E_7_Lip_Gloss.Lip_Gloss_Pink)]    = 200; 

        return probabilities;
    }

    function getTeethProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[16] memory) {
        uint32[16] memory probabilities;

        if  (TraitsUtils.isRadioactive(traitsContext) || TraitsUtils.isAlien(traitsContext) || TraitsUtils.isDemonic(traitsContext)) {         
            // teeth probabilities for aliens and radioactive and demonic 
            probabilities[uint(E_8_Teeth.Gold_Grill_Skeleton)]            = 0;
            probabilities[uint(E_8_Teeth.Gold_Tooth_Right_Skeleton)]      = 0; // only for skleleton 
            probabilities[uint(E_8_Teeth.Gold_Tooth_Left_Skeleton)]       = 0; // only for skleleton 
            probabilities[uint(E_8_Teeth.None)]                           = 1250;
            probabilities[uint(E_8_Teeth.Fangs)]                          = 1250;
            probabilities[uint(E_8_Teeth.Golden_Fangs)]                   = 200;

            if (TraitsUtils.hasTightWhite(traitsContext)) {
                probabilities[uint(E_8_Teeth.Full_Teeth)]           = 0;
            } else {
                probabilities[uint(E_8_Teeth.Full_Teeth)]           = 800;
            }
            probabilities[uint(E_8_Teeth.Gold_Grill)]                   = 200;
            probabilities[uint(E_8_Teeth.Gold_Tooth_Right)]             = 50;
            probabilities[uint(E_8_Teeth.Gold_Tooth_Left)]              = 50;
            probabilities[uint(E_8_Teeth.Hobo_Teeth)]                   = 1250;
            probabilities[uint(E_8_Teeth.Missing_Tooth_Left)]           = 250; 
            probabilities[uint(E_8_Teeth.Missing_Tooth_Right)]          = 10; /// possibly remove 
            probabilities[uint(E_8_Teeth.Diamond_Grill)]                = 120;
            probabilities[uint(E_8_Teeth.Rainbow_Grill)]                = 70;
            probabilities[uint(E_8_Teeth.Golden_Hobo_Teeth)]            = 300;
        } else { 
            // teeth probability for everyone else 
            probabilities[uint(E_8_Teeth.Gold_Grill_Skeleton)]            = 0;
            probabilities[uint(E_8_Teeth.Gold_Tooth_Right_Skeleton)]      = 0; // only for skleleton 
            probabilities[uint(E_8_Teeth.Gold_Tooth_Left_Skeleton)]       = 0; // only for skleleton 
            probabilities[uint(E_8_Teeth.None)]                           = 1500;
            probabilities[uint(E_8_Teeth.Fangs)]                          = 400;
            probabilities[uint(E_8_Teeth.Golden_Fangs)]                   = 100;

            if (TraitsUtils.hasTightWhite(traitsContext)) {
                probabilities[uint(E_8_Teeth.Full_Teeth)]           = 0;
            } else {
                probabilities[uint(E_8_Teeth.Full_Teeth)]           = 1500;
            }
            probabilities[uint(E_8_Teeth.Gold_Grill)]                   = 250;
            probabilities[uint(E_8_Teeth.Gold_Tooth_Right)]             = 400;
            probabilities[uint(E_8_Teeth.Gold_Tooth_Left)]              = 50;
            probabilities[uint(E_8_Teeth.Hobo_Teeth)]                   = 300;
            probabilities[uint(E_8_Teeth.Missing_Tooth_Left)]           = 250; 
            probabilities[uint(E_8_Teeth.Missing_Tooth_Right)]          = 10; /// possibly remove 
            probabilities[uint(E_8_Teeth.Diamond_Grill)]                = 120;
            probabilities[uint(E_8_Teeth.Rainbow_Grill)]                = 30;
            probabilities[uint(E_8_Teeth.Golden_Hobo_Teeth)]            = 140;
        }

        if (TraitsUtils.hasEyeMask(traitsContext)) {
            probabilities[uint(E_8_Teeth.Fangs)]                        = 0;
        }

        if (TraitsUtils.hasTightBeard(traitsContext)) {
            probabilities[uint(E_8_Teeth.None)]                         = 0;
            // probabilities[uint(E_8_Teeth.Gold_Tooth_Right)]  = 0; //changed from gold tooth R/L skeleton 
            // probabilities[uint(E_8_Teeth.Gold_Tooth_Left)]   = 0; //changed from gold tooth R/L skeleton 
        }

        return probabilities;
    }

    function getSkeletonTeethProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[16] memory) {
        uint32[16] memory probabilities;    
        
        probabilities[uint(E_8_Teeth.None)]                      = 6500;
        probabilities[uint(E_8_Teeth.Gold_Tooth_Right_Skeleton)] = 800;
        probabilities[uint(E_8_Teeth.Gold_Tooth_Left_Skeleton)]  = 550;
        probabilities[uint(E_8_Teeth.Gold_Grill_Skeleton)]       = 200;

        return probabilities;
    }

    function getApeTeethProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[11] memory) { 
        uint32[11] memory probabilities;
        
        probabilities[uint(E_8b_Ape_Teeth.None)]                                = 1200;
        probabilities[uint(E_8b_Ape_Teeth.Jungle_Teeth)]                        = 1200;
        probabilities[uint(E_8b_Ape_Teeth.Fangs_Ape)]                           = 1200;
        probabilities[uint(E_8b_Ape_Teeth.Golden_Fangs_Ape)]                    = 800;
        probabilities[uint(E_8b_Ape_Teeth.Full_Teeth_Ape)]                      = 1000;
        probabilities[uint(E_8b_Ape_Teeth.Gold_Grill_Ape)]                      = 700;
        probabilities[uint(E_8b_Ape_Teeth.Gold_Tooth_Right_Ape)]                = 700;
        probabilities[uint(E_8b_Ape_Teeth.Gold_Tooth_Left_Ape)]                 = 400;
        probabilities[uint(E_8b_Ape_Teeth.Rainbow_Grill_Ape)]                   = 300;
        probabilities[uint(E_8b_Ape_Teeth.Golden_Jungle_Teeth)]                 = 700;
        probabilities[uint(E_8b_Ape_Teeth.Diamond_Grill_Ape)]                   = 600;


        return probabilities;
    }

    function getFacialHairProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[25] memory) {
        uint32[25] memory probabilities;

        probabilities[uint(E_9_Facial_Hair.None)]                    = 0;
        probabilities[uint(E_9_Facial_Hair.Devastating_Beard_Black)] = 900;
        probabilities[uint(E_9_Facial_Hair.Devastating_Beard_Brown)] = 900;
        probabilities[uint(E_9_Facial_Hair.Devastating_Beard_Ginger)] = 850;
        probabilities[uint(E_9_Facial_Hair.Devastating_Beard_White)] = 800;
        probabilities[uint(E_9_Facial_Hair.Epic_Beard_Black)]        = 900;
        probabilities[uint(E_9_Facial_Hair.Epic_Beard_Brown)]        = 900;
        probabilities[uint(E_9_Facial_Hair.Epic_Beard_Ginger)]       = 850;
        probabilities[uint(E_9_Facial_Hair.Epic_Beard_Red)]          = 18;
        probabilities[uint(E_9_Facial_Hair.Epic_Beard_Blue)]         = 20;
        probabilities[uint(E_9_Facial_Hair.Epic_Beard_Green)]        = 22;
        probabilities[uint(E_9_Facial_Hair.Epic_Beard_Purple)]       = 25;
        probabilities[uint(E_9_Facial_Hair.Handlebar_Tash_Black)]    = 850;
        probabilities[uint(E_9_Facial_Hair.Handlebar_Tash_Brown)]    = 850;
        probabilities[uint(E_9_Facial_Hair.Handlebar_Tash_White)]    = 750;
        probabilities[uint(E_9_Facial_Hair.Handlebar_Tash_Ginger)]   = 800;
        probabilities[uint(E_9_Facial_Hair.Scruffy_Beard_Black)]     = 900;
        probabilities[uint(E_9_Facial_Hair.Scruffy_Beard_Brown)]     = 900;
        probabilities[uint(E_9_Facial_Hair.Scruffy_Beard_White)]     = 800;
        probabilities[uint(E_9_Facial_Hair.Scruffy_Beard_Ginger)]    = 850;
        probabilities[uint(E_9_Facial_Hair.Tight_Beard_Black)]       = 850;
        probabilities[uint(E_9_Facial_Hair.Tight_Beard_Brown)]       = 850;
        probabilities[uint(E_9_Facial_Hair.Tight_Beard_White)]       = 800;
        probabilities[uint(E_9_Facial_Hair.Tight_Beard_Ginger)]      = 850;
        probabilities[uint(E_9_Facial_Hair.Wizard_Beard)]            = 600;

        if (TraitsUtils.isHuman6(traitsContext)){
            probabilities[uint(E_9_Facial_Hair.Devastating_Beard_Brown)] = 0;
            probabilities[uint(E_9_Facial_Hair.Epic_Beard_Brown)]        = 0;
            probabilities[uint(E_9_Facial_Hair.Handlebar_Tash_Brown)]    = 0;
            probabilities[uint(E_9_Facial_Hair.Scruffy_Beard_Brown)]     = 0;
            probabilities[uint(E_9_Facial_Hair.Tight_Beard_Brown)]       = 0;
        }

        return probabilities;
    }

    function getHeadwearProbabilities(TraitsContext calldata traitsContext) external view returns (uint32[] memory) {
        uint32[] memory probabilities = TraitsUtils.createProbabilityArray(NUM_10_Headwear, 1000); // 1000 is the default probability
        probabilities[uint(E_10_Headwear.None)] = 0;
        probabilities[uint(E_10_Headwear.Halo)] = 0;
        // set custom probabilities for headwear
        probabilities[uint(E_10_Headwear.Hoodie_Blue)]          = 60;
        probabilities[uint(E_10_Headwear.Hoodie_Grey)]          = 130;
        probabilities[uint(E_10_Headwear.Hoodie_Red)]           = 40;
        probabilities[uint(E_10_Headwear.Hoodie_Purple)]        = 20;
        probabilities[uint(E_10_Headwear.Hoodie_Black)]         = 100;
        // probabilities[uint(E_10_Headwear.Fez)]                  = 900;
        probabilities[uint(E_10_Headwear.Party_Hat)]            = 950;
        probabilities[uint(E_10_Headwear.Pirate_Hat)]           = 850;
        probabilities[uint(E_10_Headwear.Skull_X_Bones_Cap_Black)]      = 750;
        probabilities[uint(E_10_Headwear.Skull_X_Bones_Cap_Double_Black)] = 400;
        probabilities[uint(E_10_Headwear.Skull_X_Bones_Cap_Red)]        = 200;
        probabilities[uint(E_10_Headwear.Sherpa_Hat)]           = 850;
        probabilities[uint(E_10_Headwear.Sheriff_Hat)]          = 900;
        probabilities[uint(E_10_Headwear.Sailer_Hat)]           = 750;
        probabilities[uint(E_10_Headwear.Top_Hat_Blue_Sash)]    = 850;
        probabilities[uint(E_10_Headwear.Top_Hat_Purple_Sash)]  = 150;
        probabilities[uint(E_10_Headwear.Wooly_Hat_Brown)]      = 600;
        probabilities[uint(E_10_Headwear.Wooly_Hat_Grey)]       = 350;
        probabilities[uint(E_10_Headwear.Wooly_Hat_Black)]      = 250;
        probabilities[uint(E_10_Headwear.Wooly_Hat_Pink)]       = 150;
        probabilities[uint(E_10_Headwear.Backwards_Cap_Green)]  = 150;
        probabilities[uint(E_10_Headwear.Backwards_Cap_Yellow)] = 75;
        probabilities[uint(E_10_Headwear.Backwards_Cap_Black)]  = 600;
        probabilities[uint(E_10_Headwear.Backwards_Cap_Blue)]   = 600; 
        probabilities[uint(E_10_Headwear.Backwards_Cap_Red)]    = 600;
        probabilities[uint(E_10_Headwear.Bandana_Red)]          = 200;
        probabilities[uint(E_10_Headwear.Bandana_White)]        = 650;
        probabilities[uint(E_10_Headwear.Bandana_Black)]        = 350;
        probabilities[uint(E_10_Headwear.Bandana_Blue)]         = 150;
        probabilities[uint(E_10_Headwear.Bucket_Hat)]           = 900; 
        probabilities[uint(E_10_Headwear.Doo_Rag_Black)]        = 500;
        probabilities[uint(E_10_Headwear.Doo_Rag_Blue)]         = 200;
        probabilities[uint(E_10_Headwear.Doo_Rag_Red)]          = 100;
        probabilities[uint(E_10_Headwear.Doo_Rag_White)]        = 400;
        probabilities[uint(E_10_Headwear.Sweat_Band_Yellow)]    = 350;
        probabilities[uint(E_10_Headwear.Sweat_Band_Green)]     = 300;
        probabilities[uint(E_10_Headwear.Sweat_Band_Blue)]      = 650;
        probabilities[uint(E_10_Headwear.Sweat_Band_Red)]       = 650;
        probabilities[uint(E_10_Headwear.Trucker_Cap_Yellow)]   = 75; 
        probabilities[uint(E_10_Headwear.Trucker_Cap_Green)]    = 150;
        probabilities[uint(E_10_Headwear.Trucker_Cap_Purple)]   = 100;
        probabilities[uint(E_10_Headwear.Trucker_Cap_Black)]    = 750;
        probabilities[uint(E_10_Headwear.Trucker_Cap_Blue)]     = 750;
        probabilities[uint(E_10_Headwear.Trucker_Cap_Red)]      = 750;
        probabilities[uint(E_10_Headwear.Gangster_Hat)]         = 650;
        probabilities[uint(E_10_Headwear.Pork_Pie_Cream)]       = 450;
        probabilities[uint(E_10_Headwear.Pork_Pie_Black)]       = 300;
        probabilities[uint(E_10_Headwear.Pork_Pie_Brown)]       = 750;
        probabilities[uint(E_10_Headwear.Captain_Hat)]          = 950;
        probabilities[uint(E_10_Headwear.Biker_Hat)]            = 800;

        if (TraitsUtils.isSkeleton(traitsContext)) {   
            probabilities[uint(E_10_Headwear.Doo_Rag_Black)]        = 0;
            probabilities[uint(E_10_Headwear.Doo_Rag_Blue)]         = 0;
            probabilities[uint(E_10_Headwear.Doo_Rag_Red)]          = 0;
            probabilities[uint(E_10_Headwear.Doo_Rag_White)]        = 0;
        }

        return probabilities;
    }
}