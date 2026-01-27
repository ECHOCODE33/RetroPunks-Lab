// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { Random, RandomCtx } from './common/Random.sol';
import "./TraitContextGenerated.sol";
import { TraitsUtils } from './TraitsUtils.sol';
import "./TraitsContextStructs.sol";
import { ITraits } from './ITraits.sol';
import { IProbabilities } from './IProbabilities.sol';

/**

 For probabilities
    100% == 10000;
    10% == 1000;
    1% == 100;
    0.1% == 10;
    0.01% == 1;
 */

contract Traits is ITraits {
    IProbabilities public immutable probabilitiesContract;

    constructor(IProbabilities _probabilitiesContract) {
        probabilitiesContract = _probabilitiesContract;
    }

    function generateAllTraits(uint tokenId, uint backgroundIndex, uint seed) external view returns (TraitsContext memory) {
        RandomCtx memory rndCtx = Random.initCtx(tokenId, seed, 1);

        uint specialId = 0;

        if (tokenId < NUM_0_Special_1s) {
            specialId = tokenId + 1;
        }

        TraitsContext memory traits;
        traits.masculine = Random.randBool(rndCtx, 8600); // 86% chance maculine
        traits.traitsToRender = new TraitToRender[](30);
        traits.specialId = specialId;
        traits.tokenId = tokenId;
        traits.tokenIdSeed = seed;
        

        if (specialId >= 1) {
            add_0_Special(traits, specialId - 1);
        } else {
            (traits.bodyType, traits.mouth) = selectBodyType(rndCtx);
            add_1_BodyType(traits);

            if (TraitsUtils.isHuman(traits)) {
                traits.isAngel = Random.randBool(rndCtx, 20); // 0.2% chance for dead for humans
            }

            traits.headwear = select_headwear(rndCtx, traits);

            traits.clothes = select_clothes(rndCtx, traits);
            traits.clothes2 = select_clothes2(rndCtx, traits);
            traits.eyeWear = select_eye_wear(rndCtx, traits);

            traits.hair = select_hair(rndCtx, traits);
            traits.facialHair = select_facial_hair(rndCtx, traits);

            add_2_Tattoos(rndCtx, traits);    

            add_3_Clothes(traits);

            if (TraitsUtils.hasHeadwear(traits)) {   
                add_5b_Hat_Hair(rndCtx, traits);
            } else {
                add_5_Hair(rndCtx, traits);
            }

            add_10_Headwear(traits);   

            add_4_Jewelry(rndCtx, traits);

            add_3b_Clothes(rndCtx, traits);

             
            addMouth(traits);

            if (TraitsUtils.isApe(traits)) {
                add_8b_Ape_Teeth(rndCtx, traits);
            } else {
                add_8_Teeth(rndCtx, traits);
            }

            add_7_Lip_Gloss(rndCtx, traits);
            
            add_9_Facial_Hair(traits);

            add_6_Eyes(rndCtx,traits);
            add_6b_Eye_Wear(traits);

            add_11_Smoking(rndCtx, traits);
        }

        traits.background = E_Background(backgroundIndex);
        addBackground(traits);
        
        return traits;
    }

    function add_0_Special(TraitsContext memory traits, uint specialId) internal pure {
        E_0_Special_1s special = E_0_Special_1s(specialId);
        addTraitToRender(traits, TraitContextGenerated.traitEnumToTraitGroupEnum(special), uint8(special));
    }

    function selectBodyType(RandomCtx memory rndCtx) internal view returns (E_1_Type bodyType, E_Mouth mouth) {
        uint32[NUM_1_Type] memory probabilities = probabilitiesContract.getBodyTypeProbabilties();

        bodyType = TraitContextGenerated.random_1_Type(rndCtx, probabilities);

        if (bodyType == E_1_Type.Alien) {
            mouth = E_Mouth.Alien_Mouth;
        } else if (bodyType == E_1_Type.Ape) {
            mouth = E_Mouth.Ape_Mouth;
        } else if (bodyType == E_1_Type.Human_1) {
            mouth = E_Mouth.Human_1_Mouth;
        } else if (bodyType == E_1_Type.Human_2) {
            mouth = E_Mouth.Human_2_Mouth;
        } else if (bodyType == E_1_Type.Human_3) {
            mouth = E_Mouth.Human_3_Mouth;
        } else if (bodyType == E_1_Type.Human_4) {
            mouth = E_Mouth.Human_4_Mouth;
        } else if (bodyType == E_1_Type.Human_5) {
            mouth = E_Mouth.Human_5_Mouth;
        } else if (bodyType == E_1_Type.Human_6) {
            mouth = E_Mouth.Human_6_Mouth;
        } else if (bodyType == E_1_Type.Radioactive) {
            mouth = E_Mouth.Radioactive_Mouth;
        } else if (bodyType == E_1_Type.Zombie) {
            mouth = E_Mouth.Zombie_Mouth;
        } else if (bodyType == E_1_Type.Demonic) {
            mouth = E_Mouth.Demonic_Mouth;
        }

        return (bodyType, mouth);
    }

    function add_1_BodyType(TraitsContext memory traitsContext) internal pure {
        addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(traitsContext.bodyType), uint8(traitsContext.bodyType));
    }

    function add_2_Tattoos(RandomCtx memory rndCtx, TraitsContext memory traitsContext) internal pure {
        // only humans and zombies can have tattoos 
        if (TraitsUtils.isAlien(traitsContext) || TraitsUtils.isSkeleton(traitsContext) || TraitsUtils.isApe(traitsContext)) return;        

        // if there is a hoodie or long sleeves, only one tattoo is allowed - tear drop tattoo
        if (TraitsUtils.hasHoodie(traitsContext) || TraitsUtils.hasLongSleeves(traitsContext) || (TraitsUtils.hasJacket(traitsContext) && !TraitsUtils.hasBareChest(traitsContext))) { 
            // 10% chance for tear drop tattoo
            if (Random.randBool(rndCtx, 1100)) {
                addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(E_2_Tattoos.Tear_Drop), uint8(E_2_Tattoos.Tear_Drop));
                traitsContext.numTattoos = 1;
            } else {
                traitsContext.numTattoos = 0;
            }
            return;
        }
        
        if (Random.randBool(rndCtx, 6400)) { // 64% chance for no tattoos 
            traitsContext.numTattoos = 0;
            return;
        }

        // 0 - body, 1 - sleeves, 2 - head/tear drop
        int8[] memory tattooTypes;
        bool canHaveBodyTattoottoo = false;

        if (TraitsUtils.hasCropTop(traitsContext) || TraitsUtils.hasTshirt(traitsContext)) {  
            // 1 or 2 tattoos
            // 45% chance for 1 tattoo, 55% chance for 2 tattoos
            traitsContext.numTattoos = 1 + Random.randWithProbabilities(rndCtx, Random.probabilityArray(45, 55)); //45 / 55 
            // skip body tattoos (0), only sleeves (1) and face tattoos (2) are possible
            tattooTypes = Random.randomArray(rndCtx, 1, 2);
        } else if (TraitsUtils.hasBareChest(traitsContext) || TraitsUtils.hasVest(traitsContext) ) {
            // 1 or 2 or 3 tattoos
            // 15% chance for 1 tattoo, 20% chance for 2 tattoos, 65% chance for 3 tattoos
            traitsContext.numTattoos = 1 + Random.randWithProbabilities(rndCtx, Random.probabilityArray(15, 20, 65)); //15, 20, 65 
            tattooTypes = Random.randomArray(rndCtx, 0, 2);
            canHaveBodyTattoottoo = true;
        } else {
            traitsContext.numTattoos = 0;
            return;
        }
        
        tattooTypes = TraitsUtils.shortenArray(tattooTypes, traitsContext.numTattoos);

        // remove face tattoo if wearing VR
        if (TraitsUtils.hasVR(traitsContext)) { 
            tattooTypes = TraitsUtils.removeFromArray(tattooTypes, 2);
        }

        // remove sleeves tattoo if wearing long sleeves or jackets 
        if (TraitsUtils.hasLongSleeves(traitsContext) || TraitsUtils.hasJacket(traitsContext)) {
            tattooTypes = TraitsUtils.removeFromArray(tattooTypes, 1);
        }

        // remove body tattoo if wearing a vest and big beard
        if (TraitsUtils.hasVest(traitsContext) && TraitsUtils.hasBigBeard(traitsContext)) {
            tattooTypes = TraitsUtils.removeFromArray(tattooTypes, 0);
        } else if (canHaveBodyTattoottoo) {
            // 50% chance to have a body tattoo first
            if (Random.randBool(rndCtx, 5000)) {
                TraitsUtils.putOnFrontOrOverride(tattooTypes, 0);
            }
        }

        // update numTattoos to match the new tattooTypes array
        traitsContext.numTattoos = tattooTypes.length;

        for (uint8 i = 0; i < tattooTypes.length; i++) {            
            if (tattooTypes[i] == 0) {
                uint32[15] memory bodyTattoosProbabilities;
                bodyTattoosProbabilities[uint(E_2_Tattoos.Alligator)]         = 2000;
                bodyTattoosProbabilities[uint(E_2_Tattoos.Crucifix)]          = 2000;
                bodyTattoosProbabilities[uint(E_2_Tattoos.Elephant)]          = 1800;

                if (TraitsUtils.hasVest(traitsContext)) {
                    bodyTattoosProbabilities[uint(E_2_Tattoos.Skull_X_Bones)] = 0;
                } else {
                    bodyTattoosProbabilities[uint(E_2_Tattoos.Skull_X_Bones)] = 1800;
                }
                
                bodyTattoosProbabilities[uint(E_2_Tattoos.Mandalla)]          = 1800;
                bodyTattoosProbabilities[uint(E_2_Tattoos.Diamond)]           = 1700;
                bodyTattoosProbabilities[uint(E_2_Tattoos.Checkerboard)]      = 1600;
                bodyTattoosProbabilities[uint(E_2_Tattoos.Elephant_Colour)]   = 800;
                bodyTattoosProbabilities[uint(E_2_Tattoos.Mandalla_Colour)]   = 700;

                E_2_Tattoos bodyTattoo = TraitContextGenerated.random_2_Tattoos(rndCtx, bodyTattoosProbabilities);

                addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(bodyTattoo), uint8(bodyTattoo));
            } else if (tattooTypes[i] == 1) {
                // sleeves tattoo
                uint32[15] memory sleeveTattoosProbabilities;
                sleeveTattoosProbabilities[uint(E_2_Tattoos.Sleeves)]         = 2000;
                sleeveTattoosProbabilities[uint(E_2_Tattoos.Sleeves_Colour)]  = 250;

                E_2_Tattoos sleevesTattoo = TraitContextGenerated.random_2_Tattoos(rndCtx, sleeveTattoosProbabilities);

                addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(sleevesTattoo), uint8(sleevesTattoo));
            } else if (tattooTypes[i] == 2) {
                addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(E_2_Tattoos.Tear_Drop), uint8(E_2_Tattoos.Tear_Drop));
            }   
        }
    }

    function select_clothes(RandomCtx memory rndCtx, TraitsContext memory traitsContext) internal view returns (E_3_Clothes) {
        // these types cannot have clothes 3, some of them can have 3b (skeleton and ape)
        if (TraitsUtils.isSkeleton(traitsContext) || TraitsUtils.isApe(traitsContext) || TraitsUtils.isAlien(traitsContext) || TraitsUtils.isRadioactive(traitsContext)|| TraitsUtils.isDemonic(traitsContext)) {
            return E_3_Clothes.Bare_Chest;
        }
        
        // angels have no clothes
        if (traitsContext.isAngel) return E_3_Clothes.Bare_Chest;

        // if there is a hoodie, we need to ensure that the clothes are not visible
        if (TraitsUtils.hasHoodie(traitsContext)) {
            return E_3_Clothes.Bare_Chest;
        }

        //traitsContext.canHaveTattoos = false;

        if (traitsContext.masculine) {
            // 40% chance of bare_chest 
            uint32[26] memory probabilities = probabilitiesContract.getMaleClothesProbabilities();
            return TraitContextGenerated.random_3_Clothes(rndCtx, probabilities);
        } else {
            // feminine clothes - no bare chest and no tshirts - only vest and croptop
            uint32[26] memory probabilities = probabilitiesContract.getFemaleClothesProbabilities();
            return TraitContextGenerated.random_3_Clothes(rndCtx, probabilities);
        }
    }

    function select_clothes2(RandomCtx memory rndCtx, TraitsContext memory traitsContext) internal view returns (E_3b_Clothes) {
        // Alien and Radioactive CANNOT have open shirts / jackets 
        //COMMENTED OUT BY 8BIT TO IMPROVE DUPLICATE STATS
        if (TraitsUtils.isAlien(traitsContext) || TraitsUtils.isRadioactive(traitsContext) || TraitsUtils.isDemonic(traitsContext) ) {
            return E_3b_Clothes.None;  //|| TraitsUtils.isApe(traitsContext)
        }

        // angels have no clothes
        if (traitsContext.isAngel) {
            return E_3b_Clothes.None;
        }

        // if there is a hoodie or long sleeves, we need to ensure that the clothes are not visible
        if (TraitsUtils.hasHoodie(traitsContext) || TraitsUtils.hasLongSleeves(traitsContext)) {
            return E_3b_Clothes.None;
        }

        if (!TraitsUtils.isSkeleton(traitsContext) && !TraitsUtils.isApe(traitsContext) && Random.randBool(rndCtx, 5500)) {
            return E_3b_Clothes.None; 

        } else if (TraitsUtils.isSkeleton(traitsContext) && Random.randBool(rndCtx, 4500)) {
            // % chance for Skeleton open shirt or jacket       
            return E_3b_Clothes.None; 
            
        } else if (TraitsUtils.isApe(traitsContext) && Random.randBool(rndCtx, 5000)) {
            // % chance for apes open shirt or jacket
            return E_3b_Clothes.None; 
        }

        uint32[11] memory probabilities = probabilitiesContract.getClothes2Probabilities(traitsContext);

        return TraitContextGenerated.random_3b_Clothes(rndCtx, probabilities);
    }

    function add_3_Clothes(TraitsContext memory traitsContext) internal pure {
        // if (traitsContext.clothes == E_3_Clothes.Bare_Chest) return;
        addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(traitsContext.clothes), uint8(traitsContext.clothes));
    }

    function add_3b_Clothes(RandomCtx memory rndCtx, TraitsContext memory traitsContext) internal pure {
        if (traitsContext.clothes2 == E_3b_Clothes.None) return;
        addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(traitsContext.clothes2), uint8(traitsContext.clothes2));
    }   

    function add_4_Jewelry(RandomCtx memory rndCtx, TraitsContext memory traitsContext) internal pure {
        // only humans, zombies, apes and skeletons can have jewelry
        if (!TraitsUtils.isHuman(traitsContext) && !TraitsUtils.isZombie(traitsContext) && 
            !TraitsUtils.isApe(traitsContext) && !TraitsUtils.isSkeleton(traitsContext)) return;

        uint targetNumJewelry = Random.randWithProbabilities(rndCtx, Random.probabilityArray(10000, 2200, 700, 65, 30, 5));
        
        if (targetNumJewelry == 0) return;

        uint8[] memory jewelryTypes = Random.weightedRandomArray(rndCtx, Random.probabilityArray(2000, 450, 200, 180, 140));

        for (uint8 i = 0; i < 5; i++) {
            if (jewelryTypes[i] == 0) {
                // earring
                if ((!TraitsUtils.isSkeleton(traitsContext)) && (!TraitsUtils.hasSherpaHat(traitsContext)) && 
                    (!TraitsUtils.hasWavyHair(traitsContext))) {
                    E_4_Jewellery jewelry = Random.randBool(rndCtx, 7300) ? E_4_Jewellery.Gold_Earring : E_4_Jewellery.Diamond_Earring; 
                    addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(jewelry), uint8(jewelry));
                    traitsContext.numJewelry++;
                }
            } else if (jewelryTypes[i] == 1) {
                // neck chain
                if (!TraitsUtils.hasEpicBeard(traitsContext)) {
                    E_4_Jewellery jewelry = Random.randBool(rndCtx, 7300) ? E_4_Jewellery.Gold_Chain : E_4_Jewellery.Diamond_Chain;
                    addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(jewelry), uint8(jewelry));
                    traitsContext.numJewelry++;
                }
            } else if (jewelryTypes[i] == 2) {
                // choker
                if (!TraitsUtils.hasBeard(traitsContext)) {
                    E_4_Jewellery jewelry = E_4_Jewellery.Gold_Choker;
                    addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(jewelry), uint8(jewelry));
                    traitsContext.numJewelry++;
                }
            } else if (jewelryTypes[i] == 3) {
                // right bracelet

                // if there is a hoodie, we need to ensure that not bracelets are possible
                if (TraitsUtils.hasHoodie(traitsContext) || TraitsUtils.hasLongSleeves(traitsContext) || TraitsUtils.hasJacket(traitsContext) ) { 
                    continue;
                }

                E_4_Jewellery jewelry = E_4_Jewellery.Gold_Bracelet_Right;
                addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(jewelry), uint8(jewelry));
                traitsContext.numJewelry++;
            } else if (jewelryTypes[i] == 4) {
                // left bracelet

                // if there is a hoodie, we need to ensure that not bracelets are possible
                if (TraitsUtils.hasHoodie(traitsContext) || TraitsUtils.hasLongSleeves(traitsContext) || TraitsUtils.hasJacket(traitsContext) ) { 
                    continue;
                }

                E_4_Jewellery jewelry = E_4_Jewellery.Gold_Bracelet_Left;
                addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(jewelry), uint8(jewelry));
                traitsContext.numJewelry++;
            }

            if (traitsContext.numJewelry >= targetNumJewelry) break; // stop if we have enough jewelry
        }
    }

    function select_hair(RandomCtx memory rndCtx, TraitsContext memory traitsContext) internal view returns (E_5_Hair) {
        uint32[] memory probabilities = probabilitiesContract.getHairProbabilities(traitsContext);
        E_5_Hair hair = E_5_Hair(Random.randWithProbabilities(rndCtx, probabilities));
        return hair;
    }
    
    function add_5_Hair(RandomCtx memory rndCtx, TraitsContext memory traitsContext) internal pure {        
        E_5_Hair hair = traitsContext.hair;
        addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(hair), uint8(hair));

        if (hair == E_5_Hair.Long_Wavy_Blonde) {
            addFillerTrait(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(E_New_Fillers.Long_Wavy_Blonde_Filler), uint8(E_New_Fillers.Long_Wavy_Blonde_Filler), true);
        } else if (hair == E_5_Hair.Long_Wavy_Brown) {
            addFillerTrait(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(E_New_Fillers.Long_Wavy_Brown_Filler), uint8(E_New_Fillers.Long_Wavy_Brown_Filler), true);
        } else if (hair == E_5_Hair.Long_Wavy_Black) {
            addFillerTrait(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(E_New_Fillers.Long_Wavy_Black_Filler), uint8(E_New_Fillers.Long_Wavy_Black_Filler), true);
        } else if (hair == E_5_Hair.Brit_Pop_Cut_Black) {
            addFillerTrait(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(E_New_Fillers.Brit_Pop_Black_Filler), uint8(E_New_Fillers.Brit_Pop_Black_Filler), true);    
        } else if (hair == E_5_Hair.Brit_Pop_Cut_Blonde) {
            addFillerTrait(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(E_New_Fillers.Brit_Pop_Blonde_Filler), uint8(E_New_Fillers.Brit_Pop_Blonde_Filler), true);    
        } else if (hair == E_5_Hair.Brit_Pop_Cut_Brown) {
            addFillerTrait(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(E_New_Fillers.Brit_Pop_Brown_Filler), uint8(E_New_Fillers.Brit_Pop_Brown_Filler), true);    
        } else if (hair == E_5_Hair.Brit_Pop_Cut_Ginger) {
            addFillerTrait(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(E_New_Fillers.Brit_Pop_Ginger_Filler), uint8(E_New_Fillers.Brit_Pop_Ginger_Filler), true);    
        }
        

        if (traitsContext.numTattoos >= 2 && hair == E_5_Hair.Shaved) {
            if (Random.randBool(rndCtx, 9000)) { // Modified this from 5000 to see how it effects things
                E_2_Tattoos headTat = Random.randBool(rndCtx, 7100) ? E_2_Tattoos.Spider_Web : E_2_Tattoos.Tribal_Face_Tat;
                addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(headTat), uint8(headTat));
                traitsContext.numTattoos++;
            }   
        }
    }

    function add_5b_Hat_Hair(RandomCtx memory rndCtx, TraitsContext memory traitsContext) internal view {
        // if (traitsContext.headwear == E_10_Headwear.Sherpa_Hat || traitsContext.headwear == E_10_Headwear.Doo_Rag_Black || traitsContext.headwear == E_10_Headwear.Doo_Rag_Blue || traitsContext.headwear == E_10_Headwear.Doo_Rag_Red || traitsContext.headwear == E_10_Headwear.Doo_Rag_White) {
        //     return;
        // }
        if (traitsContext.headwear == E_10_Headwear.Sherpa_Hat || 
            traitsContext.headwear == E_10_Headwear.Doo_Rag_Black || 
            traitsContext.headwear == E_10_Headwear.Doo_Rag_Blue || 
            traitsContext.headwear == E_10_Headwear.Doo_Rag_Red || 
            traitsContext.headwear == E_10_Headwear.Doo_Rag_White) {
            return;
        }
        
        uint32[49] memory probabilities = probabilitiesContract.getHatHairProbabilities(traitsContext);

        E_5b_Hat_Hair hatHair = TraitContextGenerated.random_5b_Hat_Hair(rndCtx, probabilities);

        if (hatHair == E_5b_Hat_Hair.None) return;

        addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(hatHair), uint8(hatHair));
    }

    function add_6_Eyes(RandomCtx memory rndCtx, TraitsContext memory traitsContext) internal view {
        // process only if there is no eye mask or eye patch
        if (!TraitsUtils.hasEyePatchOrNone(traitsContext.eyeWear)) return;   

        if (TraitsUtils.isSkeleton(traitsContext) || TraitsUtils.isAlien(traitsContext) || TraitsUtils.isApe(traitsContext)) return; // skeletons, aliens and apes have eyes as part of their bodies

        if (TraitsUtils.isRadioactive(traitsContext) || TraitsUtils.isZombie(traitsContext)) {
            // radioactive and zombies have only Left, Right or Confused eyes
            E_6_Eyes customEyes;
            int eyeType = Random.randRange(rndCtx, 1, 3);
            if (eyeType == 1) {
                customEyes = E_6_Eyes.Left;
            } else if (eyeType == 2) {
                customEyes = E_6_Eyes.Right;
            } else {
                customEyes = E_6_Eyes.Confused;
            }

            addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(customEyes), uint8(customEyes));

            return;
        }

        E_6_Eyes eyes;
        
        if (traitsContext.isAngel) {
            eyes = E_6_Eyes.Blind;
        } else if (TraitsUtils.isDemonic(traitsContext)) {
            eyes = E_6_Eyes.Posessed;
        } else {
            uint32[11] memory probabilities = probabilitiesContract.getEyesProbabilities(traitsContext);
            eyes = TraitContextGenerated.random_6_Eyes(rndCtx, probabilities);
        }
    
        //if (eyes == E_6_Eyes.Blind) return;
        addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(eyes), uint8(eyes));
    }

    function select_eye_wear(RandomCtx memory rndCtx, TraitsContext memory traitsContext) internal view returns (E_6b_Eye_Wear) {
        // angels have no eye wear
        if (traitsContext.isAngel) return E_6b_Eye_Wear.None;

        if (TraitsUtils.isSkeleton(traitsContext)) {
            if (Random.randBool(rndCtx, 5500)) { // 55% chance of skeleton having no eye wear 
                return E_6b_Eye_Wear.None;
            }
        }    
        else if (TraitsUtils.isAlien(traitsContext)) {
            if (Random.randBool(rndCtx, 5500)) { // 55% chance of alien having no eye wear 
                return E_6b_Eye_Wear.None;
            }   
        }
        else if (TraitsUtils.isApe(traitsContext)) {
            if (Random.randBool(rndCtx, 5500)) { // 55% chance of ape having no eye wear 
                return E_6b_Eye_Wear.None;
            }           
        } else {
            if (Random.randBool(rndCtx, 6100)) { // 61% chance of having no eye wear for everyone else
                return E_6b_Eye_Wear.None;
            }
        }

        uint32[32] memory probabilities = probabilitiesContract.getEyewearProbabilities(traitsContext);
        return E_6b_Eye_Wear(TraitContextGenerated.random_6b_Eye_Wear(rndCtx, probabilities));
    }

    function add_6b_Eye_Wear(TraitsContext memory traitsContext) internal pure {
        if (traitsContext.eyeWear == E_6b_Eye_Wear.None) return;

        addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(traitsContext.eyeWear), uint8(traitsContext.eyeWear));
    }

    function add_7_Lip_Gloss(RandomCtx memory rndCtx, TraitsContext memory traitsContext) internal view {
        // only humans and zombies can have lip gloss
        if (!TraitsUtils.isHuman(traitsContext) && !TraitsUtils.isZombie(traitsContext)) return;

        if ((traitsContext.masculine) || TraitsUtils.hasTightBeard(traitsContext)) return; //  only feminines can have lip gloss and no tight beards aslips covered

        uint32[4] memory probabilities = probabilitiesContract.getLipGlossProbabilities(traitsContext);
        E_7_Lip_Gloss lipGloss = TraitContextGenerated.random_7_Lip_Gloss(rndCtx, probabilities);

        if (lipGloss == E_7_Lip_Gloss.None) return;

        addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(lipGloss), uint8(lipGloss));
    }

    function add_8_Teeth(RandomCtx memory rndCtx, TraitsContext memory traitsContext) internal view {
        if (TraitsUtils.isSkeleton(traitsContext)) {
            uint32[16] memory skeletonTeethProbabilities = probabilitiesContract.getSkeletonTeethProbabilities(traitsContext);
            E_8_Teeth skeletonTeeth = TraitContextGenerated.random_8_Teeth(rndCtx, skeletonTeethProbabilities);

            // if (skeletonTeeth == E_8_Teeth.None) return;
            addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(skeletonTeeth), uint8(skeletonTeeth));

            return;
        }
    
        uint32[16] memory probabilities = probabilitiesContract.getTeethProbabilities(traitsContext);
        E_8_Teeth teeth = TraitContextGenerated.random_8_Teeth(rndCtx, probabilities);

        // if (teeth == E_8_Teeth.None) return; // do not add if None
        addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(teeth), uint8(teeth));
    }

    function add_8b_Ape_Teeth(RandomCtx memory rndCtx, TraitsContext memory traitsContext) internal view {
        uint32[11] memory apeTeethProbabilities = probabilitiesContract.getApeTeethProbabilities(traitsContext);
        E_8b_Ape_Teeth apeTeeth = TraitContextGenerated.random_8b_Ape_Teeth(rndCtx, apeTeethProbabilities);

        // if (apeTeeth == E_8b_Ape_Teeth.None) return; // do not add if None
        addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(apeTeeth), uint8(apeTeeth));
    }

    function select_facial_hair(RandomCtx memory rndCtx, TraitsContext memory traitsContext) internal view returns (E_9_Facial_Hair) {
        // only humans and zombies can have facial hair
        if (!TraitsUtils.isHuman(traitsContext) && !TraitsUtils.isZombie(traitsContext)) return E_9_Facial_Hair.None;

        if (!traitsContext.masculine){
            return E_9_Facial_Hair.None; //no facial hair for ladies! 
        } 
        else if (Random.randBool(rndCtx, 5900)) return E_9_Facial_Hair.None; // 60% chance for None

        uint32[25] memory probabilities = probabilitiesContract.getFacialHairProbabilities(traitsContext);
        E_9_Facial_Hair facialHair = TraitContextGenerated.random_9_Facial_Hair(rndCtx, probabilities);

        return facialHair;
    }

    function add_9_Facial_Hair(TraitsContext memory traitsContext) internal pure {
        E_9_Facial_Hair facialHair = traitsContext.facialHair;
        
        if (facialHair != E_9_Facial_Hair.None) {
            addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(facialHair), uint8(facialHair));
        }
    }

    function select_headwear(RandomCtx memory rndCtx, TraitsContext memory traitsContext) internal view returns (E_10_Headwear headwear) {
        if (traitsContext.isAngel) {
            return E_10_Headwear.Halo;
        }

        if (TraitsUtils.isSkeleton(traitsContext) || TraitsUtils.isAlien(traitsContext)) {
            if (Random.randBool(rndCtx, 5100)) { // 51% chance of skeleton or alien having no headwear 
                return E_10_Headwear.None;
            }
        }    
        else if (TraitsUtils.isApe(traitsContext)) {
            if (Random.randBool(rndCtx, 5100)) { // 51% chance of ape having no headwear 
                return E_10_Headwear.None;
            }           
        } 
        else {
            if (Random.randBool(rndCtx, 6100)) { // 61% chance of having no headwear for everyone else
                return E_10_Headwear.None;
            }
        }

        uint32[] memory probabilities = probabilitiesContract.getHeadwearProbabilities(traitsContext);
        return E_10_Headwear(Random.randWithProbabilities(rndCtx, probabilities));    
    }

    function add_10_Headwear(TraitsContext memory traitsContext) internal pure {
        if (!TraitsUtils.hasHeadwear(traitsContext)) return;

        addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(traitsContext.headwear), uint8(traitsContext.headwear));

        if (TraitsUtils.isSkeleton(traitsContext) && TraitsUtils.hasHoodie(traitsContext)) {
            // special filler for skeleton hoodies
            E_10b_Skeleton_Hoodie_Filler filler = E_10b_Skeleton_Hoodie_Filler.Skeleton_Hoodie_Filler;
            addFillerTrait(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(filler), uint8(filler), false);
        } 

        if (traitsContext.headwear == E_10_Headwear.Sherpa_Hat) {
            addFillerTrait(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(E_New_Fillers.Sherpa_Hat_Filler), uint8(E_New_Fillers.Sherpa_Hat_Filler), true);
        }
    }

    function add_11_Smoking(RandomCtx memory rndCtx, TraitsContext memory traitsContext) internal pure {
        // angels don't smoke
        if (traitsContext.isAngel) return;

        if (TraitsUtils.isSkeleton(traitsContext))  return;

        if (Random.randBool(rndCtx, 9800)) return; // 2% chance of smoking, 98% of not smoking

        E_11_Smoking smoking;
        if (Random.randBool(rndCtx, 6500)) {  // 65% / 35% ratio in favour of cigarette
            smoking = E_11_Smoking.Cigarette;
        } else {
            smoking = E_11_Smoking.Cigar;
        }

        addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(smoking), uint8(smoking));
    }

    function addMouth(TraitsContext memory traitsContext) internal pure {
        if (TraitsUtils.isSkeleton(traitsContext)) return; // skeletons have no mouth

        addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(traitsContext.mouth), uint8(traitsContext.mouth));
    }

    function addBackground(TraitsContext memory traitsContext) internal pure {
        addTraitToRender(traitsContext, TraitContextGenerated.traitEnumToTraitGroupEnum(traitsContext.background), uint8(traitsContext.background));
    }

    function addTraitToRender(TraitsContext memory _traitsContext, E_TraitsGroup _traitGroup, uint8 _traitIndex) internal pure {
        int8 traitId = -1;
        
        if (_traitGroup == E_TraitsGroup.E_2_Tattoos_Group) {
            traitId = int8(int(++_traitsContext.tattooId));
        } else if (_traitGroup == E_TraitsGroup.E_4_Jewellery_Group) {
            traitId = int8(int(++_traitsContext.jewelryId));
        } else if (_traitGroup == E_TraitsGroup.E_3_Clothes_Group || _traitGroup == E_TraitsGroup.E_3b_Clothes_Group) {
            traitId = int8(int(++_traitsContext.clothesId));
        }

        TraitToRender memory traitToRender;
        traitToRender.traitGroup = _traitGroup;
        traitToRender.traitIndex = _traitIndex;
        traitToRender.traitId = traitId;
        traitToRender.hasFiller = false;
        traitToRender.fillerRenderedAtTheEnd = false;
        _traitsContext.traitsToRender[_traitsContext.traitsToRenderLength] = traitToRender;
        _traitsContext.traitsToRenderLength++;
    }

    // special fillers than enhace some of the traits
    // attached only, this need to have at least one trait to enhance, i.e. traitsToRenderLength > 0
    function addFillerTrait(TraitsContext memory _traitsContext, E_TraitsGroup _traitGroup, uint8 _traitIndex, bool fillerRenderedAtTheEnd) internal pure {
        FillerTrait memory filler;
        filler.traitGroup = _traitGroup;
        filler.traitIndex = _traitIndex; 
        
        _traitsContext.traitsToRender[_traitsContext.traitsToRenderLength - 1].hasFiller = true;
        _traitsContext.traitsToRender[_traitsContext.traitsToRenderLength - 1].filler = filler;
        _traitsContext.traitsToRender[_traitsContext.traitsToRenderLength - 1].fillerRenderedAtTheEnd = fillerRenderedAtTheEnd;
    }
}