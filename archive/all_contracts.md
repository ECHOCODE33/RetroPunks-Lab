### MaleProbs.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { IMaleProbs } from './interfaces/IMaleProbs.sol';
import { E_Male_Skin, E_Male_Eyes, E_Male_Face, E_Male_Chain, E_Male_Earring, E_Male_Scarf, E_Male_Facial_Hair, E_Male_Mask, E_Male_Hair, E_Male_Hat_Hair, E_Male_Headwear, E_Male_Eye_Wear, E_Female_Skin, E_Female_Eyes, E_Female_Face, E_Female_Chain, E_Female_Earring, E_Female_Scarf, E_Female_Mask, E_Female_Hair, E_Female_Hat_Hair, E_Female_Headwear, E_Female_Eye_Wear, E_Mouth } from "./common/Enums.sol";
import { TraitsContext} from './common/Structs.sol';
import { RandomCtx, Random } from "./libraries/Random.sol";
import { TraitsUtils } from "./libraries/TraitsUtils.sol";

/**
 * @author ECHO
 */

contract MaleProbs is IMaleProbs {

    function selectMaleSkin(RandomCtx memory rndCtx) external pure returns (E_Male_Skin) {
        uint16[] memory probs = new uint16[](29);
        
        probs[uint(E_Male_Skin.None)] = 0;
        probs[uint(E_Male_Skin.Human_1)] = 750;
        probs[uint(E_Male_Skin.Human_2)] = 750;
        probs[uint(E_Male_Skin.Human_3)] = 750;
        probs[uint(E_Male_Skin.Human_4)] = 750;
        probs[uint(E_Male_Skin.Human_5)] = 750;
        probs[uint(E_Male_Skin.Human_6)] = 750;
        probs[uint(E_Male_Skin.Human_7)] = 750;
        probs[uint(E_Male_Skin.Human_8)] = 750;
        probs[uint(E_Male_Skin.Human_9)] = 750;
        probs[uint(E_Male_Skin.Human_10)] = 750;
        probs[uint(E_Male_Skin.Human_11)] = 750;
        probs[uint(E_Male_Skin.Human_12)] = 750;
        probs[uint(E_Male_Skin.Zombie)] =   300;
        probs[uint(E_Male_Skin.Ape)] = 175;
        probs[uint(E_Male_Skin.Zombie_Ape)] = 120;
        probs[uint(E_Male_Skin.Yeti)] = 80;
        probs[uint(E_Male_Skin.Robot)] = 60;
        probs[uint(E_Male_Skin.Glitch)] = 55;
        probs[uint(E_Male_Skin.Ghost)] = 45;
        probs[uint(E_Male_Skin.Alien)] = 35;
        probs[uint(E_Male_Skin.Snowman)] = 30;
        probs[uint(E_Male_Skin.Mummy)] = 22;
        probs[uint(E_Male_Skin.Skeleton)] = 18;
        probs[uint(E_Male_Skin.Pumpkin)] = 16;
        probs[uint(E_Male_Skin.Goblin)] = 14;
        probs[uint(E_Male_Skin.Demon)] = 12;
        probs[uint(E_Male_Skin.Vampire)] = 10;
        probs[uint(E_Male_Skin.Invisible)] = 8;

        uint selected = Random.selectRandomTrait(rndCtx, probs);

        return E_Male_Skin(selected);
    } 

    function selectMaleEyes(TraitsContext calldata traits, RandomCtx memory rndCtx) external pure returns (E_Male_Eyes) {
        uint16[] memory probs = new uint16[](23);

        if (TraitsUtils.maleIsGhost(traits)) {
            probs[uint(E_Male_Eyes.Ghost_Left)] = 5000;
            probs[uint(E_Male_Eyes.Ghost_Right)] = 5000;
        }

        else {
            probs[uint(E_Male_Eyes.None)] = 0;
            probs[uint(E_Male_Eyes.Left)] = 4125;
            probs[uint(E_Male_Eyes.Right)] = 4125;
            probs[uint(E_Male_Eyes.Tired_Left)] = 500;
            probs[uint(E_Male_Eyes.Tired_Right)] = 500;
            probs[uint(E_Male_Eyes.Confused)] = 250;
            probs[uint(E_Male_Eyes.Tired_Confused)] = 125;
            probs[uint(E_Male_Eyes.Closed)] = 100;
            probs[uint(E_Male_Eyes.Wink)] = 76;
            probs[uint(E_Male_Eyes.Blind)] = 50;
            probs[uint(E_Male_Eyes.Clown_Eyes_Blue)] = 11;
            probs[uint(E_Male_Eyes.Clown_Eyes_Green)] = 11;
            probs[uint(E_Male_Eyes.Clown_Eyes_Orange)] = 11;
            probs[uint(E_Male_Eyes.Clown_Eyes_Pink)] = 11;
            probs[uint(E_Male_Eyes.Clown_Eyes_Purple)] = 11;
            probs[uint(E_Male_Eyes.Clown_Eyes_Red)] = 11;
            probs[uint(E_Male_Eyes.Clown_Eyes_Sky_Blue)] = 11;
            probs[uint(E_Male_Eyes.Clown_Eyes_Turquoise)] = 11;
            probs[uint(E_Male_Eyes.Clown_Eyes_Yellow)] = 11;
            probs[uint(E_Male_Eyes.Possessed_Left)] = 25;
            probs[uint(E_Male_Eyes.Possessed_Right)] = 25;
        }

        uint selected = Random.selectRandomTrait(rndCtx, probs);

        return E_Male_Eyes(selected);
    }

    function selectMaleFace(TraitsContext calldata traits, RandomCtx memory rndCtx) external pure returns (E_Male_Face) {
        uint16[] memory probs = new uint16[](20);
        
        if (TraitsUtils.maleIsHuman(traits) || TraitsUtils.maleIsZombie(traits)) {
            //• Humans & Zombies can have all face traits
            
            // None = 9365
                probs[uint(E_Male_Face.None)] = 9365;

            // Mole = 200
                probs[uint(E_Male_Face.Mole)] = 200;

            // Tattoos = 155
                probs[uint(E_Male_Face.Cross_Tattoo)] = 35;
                probs[uint(E_Male_Face.X_Tattoo)] = 22;
                probs[uint(E_Male_Face.Heart_Tattoo)] = 20;
                probs[uint(E_Male_Face.Armor_Tattoo)] = 18;
                probs[uint(E_Male_Face.Axe_Tattoo)] = 16;
                probs[uint(E_Male_Face.Sword_Tattoo)] = 14;
                probs[uint(E_Male_Face.Gun_Tattoo)] = 12;
                probs[uint(E_Male_Face.Shotgun_Tattoo)] = 10;
                probs[uint(E_Male_Face.Jet_Tattoo)] = 8;

            // Bandage = 75
                probs[uint(E_Male_Face.Bandage)] = 75;

            // Nosebleed = 60
                probs[uint(E_Male_Face.Nosebleed)] = 60;

            // War Paint = 50
                probs[uint(E_Male_Face.War_Paint)] = 50;

            // Bionic Eyes = 40
                probs[uint(E_Male_Face.Bionic_Eyes)] = 16;
                probs[uint(E_Male_Face.Left_Bionic_Eye)] = 12;
                probs[uint(E_Male_Face.Right_Bionic_Eye)] = 12;

            // Cybereye = 20
                probs[uint(E_Male_Face.Cybereye_Left)] = 10;
                probs[uint(E_Male_Face.Cybereye_Right)] = 10;

            // Cyberface = 8
                probs[uint(E_Male_Face.Cyberface)] = 8;
        }

        else if (TraitsUtils.maleIsApe(traits) || TraitsUtils.maleIsYeti(traits) || TraitsUtils.maleIsZombieApe(traits)) {
            //• Ape, Yeti, Zombie Ape can only get mole / bandage / war paint / bionic eyes / cybereyes / full face gas mask
            
            // None = 9365
                probs[uint(E_Male_Face.None)] = 9365;

            // Mole = 200
                probs[uint(E_Male_Face.Mole)] = 200;

            // Bandage = 75
                probs[uint(E_Male_Face.Bandage)] = 75;

            // War Paint = 50
                probs[uint(E_Male_Face.War_Paint)] = 50;

            // Bionic Eyes = 40
                probs[uint(E_Male_Face.Bionic_Eyes)] = 16;
                probs[uint(E_Male_Face.Left_Bionic_Eye)] = 12;
                probs[uint(E_Male_Face.Right_Bionic_Eye)] = 12;

            // Cybereye = 20
                probs[uint(E_Male_Face.Cybereye_Left)] = 10;
                probs[uint(E_Male_Face.Cybereye_Right)] = 10;
        }

        else if (TraitsUtils.maleIsAlien(traits) || TraitsUtils.maleIsDemon(traits) || TraitsUtils.maleIsGhost(traits) || TraitsUtils.maleIsGlitch(traits) || TraitsUtils.maleIsGoblin(traits) || TraitsUtils.maleIsPumpkin(traits) || TraitsUtils.maleIsSkeleton(traits) || TraitsUtils.maleIsVampire(traits)) {
            // Aliens, Demons, Ghosts, Glitch, Goblins, Pumpkins, Skeletons, Vampires can only get mole / tattoos / bandage

            // None = 9365
                probs[uint(E_Male_Face.None)] = 9365;

            // Mole = 200
                probs[uint(E_Male_Face.Mole)] = 200;

            // Tattoos = 155
                probs[uint(E_Male_Face.Cross_Tattoo)] = 35;
                probs[uint(E_Male_Face.X_Tattoo)] = 22;
                probs[uint(E_Male_Face.Heart_Tattoo)] = 20;
                probs[uint(E_Male_Face.Armor_Tattoo)] = 18;
                probs[uint(E_Male_Face.Axe_Tattoo)] = 16;
                probs[uint(E_Male_Face.Sword_Tattoo)] = 14;
                probs[uint(E_Male_Face.Gun_Tattoo)] = 12;
                probs[uint(E_Male_Face.Shotgun_Tattoo)] = 10;
                probs[uint(E_Male_Face.Jet_Tattoo)] = 8;

            // Bandage = 75
                probs[uint(E_Male_Face.Bandage)] = 75;
        }

        else {
            // Invisible, Mummy, Robot, Snowman have no face traits
            return E_Male_Face.None;
        }

        uint selected = Random.selectRandomTrait(rndCtx, probs);

        return E_Male_Face(selected);
    }

    function selectMaleChain(RandomCtx memory rndCtx) external pure returns (E_Male_Chain) {
        uint16[] memory probs = new uint16[](9);

        // None = 9000 (90%)
            probs[uint(E_Male_Chain.None)] = 9000;

        // Chain = 1000 (10%)
            probs[uint(E_Male_Chain.Chain_Onyx)] = 350;
            probs[uint(E_Male_Chain.Chain_Amethyst)] = 250;
            probs[uint(E_Male_Chain.Chain_Gold)] = 140;
            probs[uint(E_Male_Chain.Chain_Sapphire)] = 100;
            probs[uint(E_Male_Chain.Chain_Emerald)] = 75;
            probs[uint(E_Male_Chain.Chain_Ruby)] = 50;
            probs[uint(E_Male_Chain.Chain_Diamond)] = 25;
            probs[uint(E_Male_Chain.Chain_Pink_Diamond)] = 10;

        uint selected = Random.selectRandomTrait(rndCtx, probs);

        return E_Male_Chain(selected);
    }

    function selectMaleEarring(RandomCtx memory rndCtx) external pure returns (E_Male_Earring) {
        uint16[] memory probs = new uint16[](9);

        // None = 9000
            probs[uint(E_Male_Earring.None)] = 9000;

        // Earring = 1000
            probs[uint(E_Male_Earring.Earring_Onyx)] = 350;
            probs[uint(E_Male_Earring.Earring_Amethyst)] = 250;
            probs[uint(E_Male_Earring.Earring_Gold)] = 140;
            probs[uint(E_Male_Earring.Earring_Sapphire)] = 100;
            probs[uint(E_Male_Earring.Earring_Emerald)] = 75;
            probs[uint(E_Male_Earring.Earring_Ruby)] = 50;
            probs[uint(E_Male_Earring.Earring_Diamond)] = 25;
            probs[uint(E_Male_Earring.Earring_Pink_Diamond)] = 10;

        uint selected = Random.selectRandomTrait(rndCtx, probs);

        return E_Male_Earring(selected);
    }

    function selectMaleScarf(RandomCtx memory rndCtx) external pure returns (E_Male_Scarf) {
        uint16[] memory probs = new uint16[](4);

        // None = 9900
            probs[uint(E_Male_Scarf.None)] = 9900;

        // Scarf = 100
            probs[uint(E_Male_Scarf.Blue_Scarf)] = 40;
            probs[uint(E_Male_Scarf.Green_Scarf)] = 30;
            probs[uint(E_Male_Scarf.Red_Scarf)] = 30;
        
        uint selected = Random.selectRandomTrait(rndCtx, probs);

        return E_Male_Scarf(selected);
    }

    function selectMaleFacialHair(TraitsContext calldata traits, RandomCtx memory rndCtx) external pure returns (E_Male_Facial_Hair) {
        uint16[] memory probs = new uint16[](88);
        
        if (!TraitsUtils.maleIsHuman(traits) && !TraitsUtils.maleIsZombie(traits) && !TraitsUtils.maleIsGhost(traits)) {
            return E_Male_Facial_Hair.None;
        }

        else if (TraitsUtils.maleIsGhost(traits)) {
            // Can only have shadow facial hair
            probs[uint(E_Male_Facial_Hair.None)] = 5000;
            probs[uint(E_Male_Facial_Hair.Beard)] = 96;
            probs[uint(E_Male_Facial_Hair.Beard_Dark)] = 42;
            probs[uint(E_Male_Facial_Hair.Beard_Light)] = 42;
            probs[uint(E_Male_Facial_Hair.Beard_Shadow)] = 25;
            probs[uint(E_Male_Facial_Hair.Chinstrap_Shadow)] = 25;
            probs[uint(E_Male_Facial_Hair.Circle_Beard_Shadow)] = 27;
            probs[uint(E_Male_Facial_Hair.Goatee_Shadow)] = 30;
            probs[uint(E_Male_Facial_Hair.Horseshoe_Shadow)] = 20;
            probs[uint(E_Male_Facial_Hair.Mustache_Shadow)] = 35;
            probs[uint(E_Male_Facial_Hair.Muttonchops_Shadow)] = 25;
            probs[uint(E_Male_Facial_Hair.Walrus_Shadow)] = 20;
        }

        else {
            // None = 5000
                probs[uint(E_Male_Facial_Hair.None)] = 5000;

            // Anchor Beard = 225
                probs[uint(E_Male_Facial_Hair.Anchor_Beard_Black)] = 90;
                probs[uint(E_Male_Facial_Hair.Anchor_Beard_Brown)] = 65;
                probs[uint(E_Male_Facial_Hair.Anchor_Beard_Ginger)] = 45;
                probs[uint(E_Male_Facial_Hair.Anchor_Beard_White)] = 25;

            // Beard = 425
                probs[uint(E_Male_Facial_Hair.Beard)] = 96;
                probs[uint(E_Male_Facial_Hair.Beard_Dark)] = 42;
                probs[uint(E_Male_Facial_Hair.Beard_Light)] = 42;

                probs[uint(E_Male_Facial_Hair.Beard_Black)] = 75;
                probs[uint(E_Male_Facial_Hair.Beard_Brown)] = 60;
                probs[uint(E_Male_Facial_Hair.Beard_Ginger)] = 50;
                probs[uint(E_Male_Facial_Hair.Beard_White)] = 35;
                probs[uint(E_Male_Facial_Hair.Beard_Shadow)] = 25;

            // Big Beard = 265
                probs[uint(E_Male_Facial_Hair.Big_Beard_Black)] = 105;
                probs[uint(E_Male_Facial_Hair.Big_Beard_Brown)] = 80;
                probs[uint(E_Male_Facial_Hair.Big_Beard_Ginger)] = 50;
                probs[uint(E_Male_Facial_Hair.Big_Beard_White)] = 30;

            // Chin Goatee = 390
                probs[uint(E_Male_Facial_Hair.Chin_Goatee_Black)] = 155;
                probs[uint(E_Male_Facial_Hair.Chin_Goatee_Brown)] = 115;
                probs[uint(E_Male_Facial_Hair.Chin_Goatee_Ginger)] = 80;
                probs[uint(E_Male_Facial_Hair.Chin_Goatee_White)] = 40;

            // Chinstrap = 315
                probs[uint(E_Male_Facial_Hair.Chinstrap_Black)] = 100;
                probs[uint(E_Male_Facial_Hair.Chinstrap_Brown)] = 85;
                probs[uint(E_Male_Facial_Hair.Chinstrap_Ginger)] = 60;
                probs[uint(E_Male_Facial_Hair.Chinstrap_White)] = 45;
                probs[uint(E_Male_Facial_Hair.Chinstrap_Shadow)] = 25;

            // Circle Beard = 335
                probs[uint(E_Male_Facial_Hair.Circle_Beard_Black)] = 107;
                probs[uint(E_Male_Facial_Hair.Circle_Beard_Brown)] = 87;
                probs[uint(E_Male_Facial_Hair.Circle_Beard_Ginger)] = 67;
                probs[uint(E_Male_Facial_Hair.Circle_Beard_White)] = 47;
                probs[uint(E_Male_Facial_Hair.Circle_Beard_Shadow)] = 27;

            // Dutch = 175
                probs[uint(E_Male_Facial_Hair.Dutch_Black)] = 70;
                probs[uint(E_Male_Facial_Hair.Dutch_Brown)] = 50;
                probs[uint(E_Male_Facial_Hair.Dutch_Ginger)] = 35;
                probs[uint(E_Male_Facial_Hair.Dutch_White)] = 20;

            // Fu Manchu = 100
                probs[uint(E_Male_Facial_Hair.Fu_Manchu_Black)] = 40;
                probs[uint(E_Male_Facial_Hair.Fu_Manchu_Brown)] = 30;
                probs[uint(E_Male_Facial_Hair.Fu_Manchu_Ginger)] = 20;
                probs[uint(E_Male_Facial_Hair.Fu_Manchu_White)] = 10;

            // Full Goatee = 355
                probs[uint(E_Male_Facial_Hair.Full_Goatee_Black)] = 140;
                probs[uint(E_Male_Facial_Hair.Full_Goatee_Brown)] = 105;
                probs[uint(E_Male_Facial_Hair.Full_Goatee_Ginger)] = 70;
                probs[uint(E_Male_Facial_Hair.Full_Goatee_White)] = 40;

            // Goatee = 370
                probs[uint(E_Male_Facial_Hair.Goatee_Black)] = 120;
                probs[uint(E_Male_Facial_Hair.Goatee_Brown)] = 95;
                probs[uint(E_Male_Facial_Hair.Goatee_Ginger)] = 75;
                probs[uint(E_Male_Facial_Hair.Goatee_White)] = 50;
                probs[uint(E_Male_Facial_Hair.Goatee_Shadow)] = 30;

            // Handlebar = 190
                probs[uint(E_Male_Facial_Hair.Handlebar_Black)] = 75;
                probs[uint(E_Male_Facial_Hair.Handlebar_Brown)] = 60;
                probs[uint(E_Male_Facial_Hair.Handlebar_Ginger)] = 35;
                probs[uint(E_Male_Facial_Hair.Handlebar_White)] = 20;

            // Horeshoe = 280
                probs[uint(E_Male_Facial_Hair.Horseshoe_Black)] = 90;
                probs[uint(E_Male_Facial_Hair.Horseshoe_Brown)] = 75;
                probs[uint(E_Male_Facial_Hair.Horseshoe_Ginger)] = 55;
                probs[uint(E_Male_Facial_Hair.Horseshoe_White)] = 40;
                probs[uint(E_Male_Facial_Hair.Horseshoe_Shadow)] = 20;

            // Long Beard = 245
                probs[uint(E_Male_Facial_Hair.Long_Beard_Black)] = 95;
                probs[uint(E_Male_Facial_Hair.Long_Beard_Brown)] = 75;
                probs[uint(E_Male_Facial_Hair.Long_Beard_Ginger)] = 50;
                probs[uint(E_Male_Facial_Hair.Long_Beard_White)] = 25;

            // Luxurious Beard = 140
                probs[uint(E_Male_Facial_Hair.Luxurious_Beard_Black)] = 55;
                probs[uint(E_Male_Facial_Hair.Luxurious_Beard_Brown)] = 45;
                probs[uint(E_Male_Facial_Hair.Luxurious_Beard_Ginger)] = 25;
                probs[uint(E_Male_Facial_Hair.Luxurious_Beard_White)] = 15;

            // Luxurious Full Goatee = 120
                probs[uint(E_Male_Facial_Hair.Luxurious_Full_Goatee_Black)] = 45;
                probs[uint(E_Male_Facial_Hair.Luxurious_Full_Goatee_Brown)] = 35;
                probs[uint(E_Male_Facial_Hair.Luxurious_Full_Goatee_Ginger)] = 25;
                probs[uint(E_Male_Facial_Hair.Luxurious_Full_Goatee_White)] = 15;

            // Mustache = 405
                probs[uint(E_Male_Facial_Hair.Mustache_Black)] = 130;
                probs[uint(E_Male_Facial_Hair.Mustache_Brown)] = 105;
                probs[uint(E_Male_Facial_Hair.Mustache_Ginger)] = 80;
                probs[uint(E_Male_Facial_Hair.Mustache_White)] = 55;
                probs[uint(E_Male_Facial_Hair.Mustache_Shadow)] = 35;

            // Muttonchops = 300
                probs[uint(E_Male_Facial_Hair.Muttonchops_Black)] = 95;
                probs[uint(E_Male_Facial_Hair.Muttonchops_Brown)] = 75;
                probs[uint(E_Male_Facial_Hair.Muttonchops_Ginger)] = 60;
                probs[uint(E_Male_Facial_Hair.Muttonchops_White)] = 45;
                probs[uint(E_Male_Facial_Hair.Muttonchops_Shadow)] = 25;

            // Pymarid Mustache = 155
                probs[uint(E_Male_Facial_Hair.Pyramid_Mustache_Black)] = 60;
                probs[uint(E_Male_Facial_Hair.Pyramid_Mustache_Brown)] = 45;
                probs[uint(E_Male_Facial_Hair.Pyramid_Mustache_Ginger)] = 30;
                probs[uint(E_Male_Facial_Hair.Pyramid_Mustache_White)] = 20;

            // Walrus = 210
                probs[uint(E_Male_Facial_Hair.Walrus_Black)] = 65;
                probs[uint(E_Male_Facial_Hair.Walrus_Brown)] = 55;
                probs[uint(E_Male_Facial_Hair.Walrus_Ginger)] = 40;
                probs[uint(E_Male_Facial_Hair.Walrus_White)] = 30;
                probs[uint(E_Male_Facial_Hair.Walrus_Shadow)] = 20;
        }

        uint selected = Random.selectRandomTrait(rndCtx, probs);

        return E_Male_Facial_Hair(selected);
    }

    function selectMaleMask(RandomCtx memory rndCtx) external pure returns (E_Male_Mask) {
        uint16[] memory probs = new uint16[](22);

        // None = 9520
            probs[uint(E_Male_Mask.None)] = 9520;

        // Medical Mask = 240
            probs[uint(E_Male_Mask.Medical_Mask)] = 40;
            probs[uint(E_Male_Mask.Medical_Mask_Blue)] = 25;
            probs[uint(E_Male_Mask.Medical_Mask_Green)] = 25;
            probs[uint(E_Male_Mask.Medical_Mask_Orange)] = 25;
            probs[uint(E_Male_Mask.Medical_Mask_Pink)] = 25;
            probs[uint(E_Male_Mask.Medical_Mask_Purple)] = 25;
            probs[uint(E_Male_Mask.Medical_Mask_Red)] = 25;
            probs[uint(E_Male_Mask.Medical_Mask_Turquoise)] = 25;
            probs[uint(E_Male_Mask.Medical_Mask_Yellow)] = 25;

        // Bandana Mask = 120
            probs[uint(E_Male_Mask.Bandana_Mask_Blue)] = 30;
            probs[uint(E_Male_Mask.Bandana_Mask_Green)] = 30;
            probs[uint(E_Male_Mask.Bandana_Mask_Purple)] = 30;
            probs[uint(E_Male_Mask.Bandana_Mask_Red)] = 30;
        
        // Ninja Mask = 60
            probs[uint(E_Male_Mask.Ninja_Mask_Black)] = 10;
            probs[uint(E_Male_Mask.Ninja_Mask_Blue)] = 10;
            probs[uint(E_Male_Mask.Ninja_Mask_Brown)] = 10;
            probs[uint(E_Male_Mask.Ninja_Mask_Purple)] = 10;
            probs[uint(E_Male_Mask.Ninja_Mask_Red)] = 10;

        // Gas Mask = 45
            probs[uint(E_Male_Mask.Gas_Mask)] = 30;
            probs[uint(E_Male_Mask.Military_Gas_Mask)] = 15;

        // Metal Mask = 15
            probs[uint(E_Male_Mask.Metal_Mask)] = 15;

        uint selected = Random.selectRandomTrait(rndCtx, probs);

        return E_Male_Mask(selected);
    }

    function selectMaleHair(TraitsContext calldata traits, RandomCtx memory rndCtx) external pure returns (E_Male_Hair) {
        uint16[] memory probs = new uint16[](212);

        if (TraitsUtils.maleIsHuman(traits) || TraitsUtils.maleIsZombie(traits)) {
            probs[uint(E_Male_Hair.None)] = 400;
        }

        else if (TraitsUtils.maleIsRobot(traits) || TraitsUtils.maleIsMummy(traits) || TraitsUtils.maleIsVampire(traits)) {
            return E_Male_Hair.None;
        }

        else {
            probs[uint(E_Male_Hair.None)] = 1200;
        }

        // Afro: 800
            probs[uint(E_Male_Hair.Afro_Black)] = 200;
            probs[uint(E_Male_Hair.Afro_Brown)] = 180;
            probs[uint(E_Male_Hair.Afro_Blonde)] = 120;
            probs[uint(E_Male_Hair.Afro_Ginger)] = 100;

            probs[uint(E_Male_Hair.Afro_Blue)] = 25;
            probs[uint(E_Male_Hair.Afro_Green)] = 25;
            probs[uint(E_Male_Hair.Afro_Orange)] = 25;
            probs[uint(E_Male_Hair.Afro_Pink)] = 25;
            probs[uint(E_Male_Hair.Afro_Purple)] = 25;
            probs[uint(E_Male_Hair.Afro_Red)] = 25;
            probs[uint(E_Male_Hair.Afro_Turquoise)] = 25;
            probs[uint(E_Male_Hair.Afro_White)] = 25;

        // Bowl Cut: 750
            probs[uint(E_Male_Hair.Bowl_Cut_Black)] = 225;
            probs[uint(E_Male_Hair.Bowl_Cut_Brown)] = 200;
            probs[uint(E_Male_Hair.Bowl_Cut_Blonde)] = 140;
            probs[uint(E_Male_Hair.Bowl_Cut_Ginger)] = 100;
            probs[uint(E_Male_Hair.Bowl_Cut_White)] = 85;

        // Buzz Cut: 1200
            probs[uint(E_Male_Hair.Buzz_Cut)] = 250;
            probs[uint(E_Male_Hair.Buzz_Cut_Fade)] = 225;
            probs[uint(E_Male_Hair.Buzz_Cut_Black)] = 200;
            probs[uint(E_Male_Hair.Buzz_Cut_Brown)] = 185;
            probs[uint(E_Male_Hair.Buzz_Cut_Blonde)] = 175;
            probs[uint(E_Male_Hair.Buzz_Cut_Ginger)] = 165;

        // Clown Hair: 70
            probs[uint(E_Male_Hair.Clown_Hair_Blue)] = 7;
            probs[uint(E_Male_Hair.Clown_Hair_Green)] = 7;
            probs[uint(E_Male_Hair.Clown_Hair_Orange)] = 7;
            probs[uint(E_Male_Hair.Clown_Hair_Pink)] = 7;
            probs[uint(E_Male_Hair.Clown_Hair_Purple)] = 7;
            probs[uint(E_Male_Hair.Clown_Hair_Red)] = 7;
            probs[uint(E_Male_Hair.Clown_Hair_Turquoise)] = 7;

        // Crazy Hair: 65
            probs[uint(E_Male_Hair.Crazy_Hair_Black)] = 18;
            probs[uint(E_Male_Hair.Crazy_Hair_Blonde)] = 14;
            probs[uint(E_Male_Hair.Crazy_Hair_Brown)] = 10;
            probs[uint(E_Male_Hair.Crazy_Hair_Ginger)] = 7;

            probs[uint(E_Male_Hair.Crazy_Hair_Blue)] = 2;
            probs[uint(E_Male_Hair.Crazy_Hair_Green)] = 2;
            probs[uint(E_Male_Hair.Crazy_Hair_Orange)] = 2;
            probs[uint(E_Male_Hair.Crazy_Hair_Pink)] = 2;
            probs[uint(E_Male_Hair.Crazy_Hair_Purple)] = 2;
            probs[uint(E_Male_Hair.Crazy_Hair_Red)] = 2;
            probs[uint(E_Male_Hair.Crazy_Hair_Turquoise)] = 2;
            probs[uint(E_Male_Hair.Crazy_Hair_White)] = 2;

        // Curled Mohawk: 20
            probs[uint(E_Male_Hair.Curled_Mohawk_Blue)] = 4;
            probs[uint(E_Male_Hair.Curled_Mohawk_Green)] = 4;
            probs[uint(E_Male_Hair.Curled_Mohawk_Orange)] = 3;
            probs[uint(E_Male_Hair.Curled_Mohawk_Pink)] = 3;
            probs[uint(E_Male_Hair.Curled_Mohawk_Purple)] = 3;
            probs[uint(E_Male_Hair.Curled_Mohawk_Red)] = 3;

        // Curly Hair: 850
            probs[uint(E_Male_Hair.Curly_Hair_Black)] = 200;
            probs[uint(E_Male_Hair.Curly_Hair_Brown)] = 175;
            probs[uint(E_Male_Hair.Curly_Hair_Blonde)] = 150;
            probs[uint(E_Male_Hair.Curly_Hair_Ginger)] = 117;

            probs[uint(E_Male_Hair.Curly_Hair_Blue)] = 26;
            probs[uint(E_Male_Hair.Curly_Hair_Green)] = 26;
            probs[uint(E_Male_Hair.Curly_Hair_Orange)] = 26;
            probs[uint(E_Male_Hair.Curly_Hair_Pink)] = 26;
            probs[uint(E_Male_Hair.Curly_Hair_Purple)] = 26;
            probs[uint(E_Male_Hair.Curly_Hair_Red)] = 26;
            probs[uint(E_Male_Hair.Curly_Hair_Turquoise)] = 26;
            probs[uint(E_Male_Hair.Curly_Hair_White)] = 26;

        // Curtains: 125
            probs[uint(E_Male_Hair.Curtains_Black)] = 35;
            probs[uint(E_Male_Hair.Curtains_Brown)] = 30;
            probs[uint(E_Male_Hair.Curtains_Blonde)] = 25;
            probs[uint(E_Male_Hair.Curtains_Ginger)] = 20;
            probs[uint(E_Male_Hair.Curtains_White)] = 15;

        // Electric Hair: 50
            probs[uint(E_Male_Hair.Electric_Hair_Black)] = 12;
            probs[uint(E_Male_Hair.Electric_Hair_Brown)] = 9;
            probs[uint(E_Male_Hair.Electric_Hair_Blonde)] = 7;
            probs[uint(E_Male_Hair.Electric_Hair_Ginger)] = 6;

            probs[uint(E_Male_Hair.Electric_Hair_Blue)] = 2;
            probs[uint(E_Male_Hair.Electric_Hair_Green)] = 2;
            probs[uint(E_Male_Hair.Electric_Hair_Orange)] = 2;
            probs[uint(E_Male_Hair.Electric_Hair_Pink)] = 2;
            probs[uint(E_Male_Hair.Electric_Hair_Purple)] = 2;
            probs[uint(E_Male_Hair.Electric_Hair_Red)] = 2;
            probs[uint(E_Male_Hair.Electric_Hair_Turquoise)] = 2;
            probs[uint(E_Male_Hair.Electric_Hair_White)] = 2;

        // Flat Top: 250
            probs[uint(E_Male_Hair.Flat_Top_Black)] = 70;
            probs[uint(E_Male_Hair.Flat_Top_Brown)] = 60;
            probs[uint(E_Male_Hair.Flat_Top_Blonde)] = 50;
            probs[uint(E_Male_Hair.Flat_Top_Ginger)] = 40;
            probs[uint(E_Male_Hair.Flat_Top_White)] = 30;

        // Funky Hair: 225
            probs[uint(E_Male_Hair.Funky_Hair_Black)] = 59;
            probs[uint(E_Male_Hair.Funky_Hair_Brown)] = 45;
            probs[uint(E_Male_Hair.Funky_Hair_Blonde)] = 35;
            probs[uint(E_Male_Hair.Funky_Hair_Ginger)] = 30;

            probs[uint(E_Male_Hair.Funky_Hair_Blue)] = 7;
            probs[uint(E_Male_Hair.Funky_Hair_Green)] = 7;
            probs[uint(E_Male_Hair.Funky_Hair_Orange)] = 7;
            probs[uint(E_Male_Hair.Funky_Hair_Pink)] = 7;
            probs[uint(E_Male_Hair.Funky_Hair_Purple)] = 7;
            probs[uint(E_Male_Hair.Funky_Hair_Red)] = 7;
            probs[uint(E_Male_Hair.Funky_Hair_Turquoise)] = 7;
            probs[uint(E_Male_Hair.Funky_Hair_White)] = 7;

        // Man Bun: 200
            probs[uint(E_Male_Hair.Man_Bun_Black)] = 70;
            probs[uint(E_Male_Hair.Man_Bun_Brown)] = 60;
            probs[uint(E_Male_Hair.Man_Bun_Blonde)] = 30;
            probs[uint(E_Male_Hair.Man_Bun_Ginger)] = 25;
            probs[uint(E_Male_Hair.Man_Bun_White)] = 15;

        // Messy Hair: 800
            probs[uint(E_Male_Hair.Messy_Hair_Black)] = 200;
            probs[uint(E_Male_Hair.Messy_Hair_Brown)] = 180;
            probs[uint(E_Male_Hair.Messy_Hair_Blonde)] = 120;
            probs[uint(E_Male_Hair.Messy_Hair_Ginger)] = 100;

            probs[uint(E_Male_Hair.Messy_Hair_Blue)] = 25;
            probs[uint(E_Male_Hair.Messy_Hair_Green)] = 25;
            probs[uint(E_Male_Hair.Messy_Hair_Orange)] = 25;
            probs[uint(E_Male_Hair.Messy_Hair_Pink)] = 25;
            probs[uint(E_Male_Hair.Messy_Hair_Purple)] = 25;
            probs[uint(E_Male_Hair.Messy_Hair_Red)] = 25;
            probs[uint(E_Male_Hair.Messy_Hair_Turquoise)] = 25;
            probs[uint(E_Male_Hair.Messy_Hair_White)] = 25;
            
        // Mohawk: 35
            probs[uint(E_Male_Hair.Mohawk_Black)] = 6;
            probs[uint(E_Male_Hair.Mohawk_Brown)] = 4;
            probs[uint(E_Male_Hair.Mohawk_Blonde)] = 3;
            probs[uint(E_Male_Hair.Mohawk_Ginger)] = 2;

            probs[uint(E_Male_Hair.Mohawk_Blue)] = 2;
            probs[uint(E_Male_Hair.Mohawk_Green)] = 2;
            probs[uint(E_Male_Hair.Mohawk_Orange)] = 2;
            probs[uint(E_Male_Hair.Mohawk_Pink)] = 2;
            probs[uint(E_Male_Hair.Mohawk_Purple)] = 2;
            probs[uint(E_Male_Hair.Mohawk_Red)] = 2;
            probs[uint(E_Male_Hair.Mohawk_Turquoise)] = 2;
            probs[uint(E_Male_Hair.Mohawk_White)] = 2;

            probs[uint(E_Male_Hair.Mohawk_Neon_Blue)] = 1;
            probs[uint(E_Male_Hair.Mohawk_Neon_Green)] = 1;
            probs[uint(E_Male_Hair.Mohawk_Neon_Purple)] = 1;
            probs[uint(E_Male_Hair.Mohawk_Neon_Red)] = 1;

        // Old Hair: 250
            probs[uint(E_Male_Hair.Old_Hair_Black)] = 150;
            probs[uint(E_Male_Hair.Old_Hair_Grey)] = 75;
            probs[uint(E_Male_Hair.Old_Hair_White)] = 25;

        // Quiff: 175
            probs[uint(E_Male_Hair.Quiff_Black)] = 55;
            probs[uint(E_Male_Hair.Quiff_Brown)] = 45;
            probs[uint(E_Male_Hair.Quiff_Blonde)] = 35;
            probs[uint(E_Male_Hair.Quiff_Ginger)] = 25;
            probs[uint(E_Male_Hair.Quiff_White)] = 15;

        // Sharp Mohawk: 30
            probs[uint(E_Male_Hair.Sharp_Mohawk_Black)] = 4;
            probs[uint(E_Male_Hair.Sharp_Mohawk_Brown)] = 3;
            probs[uint(E_Male_Hair.Sharp_Mohawk_Blonde)] = 2;
            probs[uint(E_Male_Hair.Sharp_Mohawk_Ginger)] = 1;

            probs[uint(E_Male_Hair.Sharp_Mohawk_Blue)] = 2;
            probs[uint(E_Male_Hair.Sharp_Mohawk_Green)] = 2;
            probs[uint(E_Male_Hair.Sharp_Mohawk_Orange)] = 2;
            probs[uint(E_Male_Hair.Sharp_Mohawk_Pink)] = 2;
            probs[uint(E_Male_Hair.Sharp_Mohawk_Purple)] = 2;
            probs[uint(E_Male_Hair.Sharp_Mohawk_Red)] = 2;
            probs[uint(E_Male_Hair.Sharp_Mohawk_Turquoise)] = 2;
            probs[uint(E_Male_Hair.Sharp_Mohawk_White)] = 2;

            probs[uint(E_Male_Hair.Sharp_Mohawk_Neon_Blue)] = 1;
            probs[uint(E_Male_Hair.Sharp_Mohawk_Neon_Green)] = 1;
            probs[uint(E_Male_Hair.Sharp_Mohawk_Neon_Purple)] = 1;
            probs[uint(E_Male_Hair.Sharp_Mohawk_Neon_Red)] = 1;
            
        // Shaved Head: 1200
            probs[uint(E_Male_Hair.Shaved_Head)] = 1200;

        // Short Mohawk: 25
            probs[uint(E_Male_Hair.Short_Mohawk_Black)] = 6;
            probs[uint(E_Male_Hair.Short_Mohawk_Brown)] = 5;
            probs[uint(E_Male_Hair.Short_Mohawk_Blonde)] = 4;
            probs[uint(E_Male_Hair.Short_Mohawk_Ginger)] = 2;

            probs[uint(E_Male_Hair.Short_Mohawk_Blue)] = 1;
            probs[uint(E_Male_Hair.Short_Mohawk_Green)] = 1;
            probs[uint(E_Male_Hair.Short_Mohawk_Orange)] = 1;
            probs[uint(E_Male_Hair.Short_Mohawk_Pink)] = 1;
            probs[uint(E_Male_Hair.Short_Mohawk_Purple)] = 1;
            probs[uint(E_Male_Hair.Short_Mohawk_Red)] = 1;
            probs[uint(E_Male_Hair.Short_Mohawk_Turquoise)] = 1;
            probs[uint(E_Male_Hair.Short_Mohawk_White)] = 1;

        // Side Line: 1200
            probs[uint(E_Male_Hair.Side_Line)] = 1200;

        // Slickback Hair: 175
            probs[uint(E_Male_Hair.Slickback_Hair_Black)] = 55;
            probs[uint(E_Male_Hair.Slickback_Hair_Blonde)] = 45;
            probs[uint(E_Male_Hair.Slickback_Hair_Brown)] = 35;
            probs[uint(E_Male_Hair.Slickback_Hair_Ginger)] = 25;
            probs[uint(E_Male_Hair.Slickback_Hair_White)] = 15;

        // Spikey: 80
            probs[uint(E_Male_Hair.Spikey_Hair_Black)] = 20;
            probs[uint(E_Male_Hair.Spikey_Hair_Brown)] = 16;
            probs[uint(E_Male_Hair.Spikey_Hair_Blonde)] = 12;
            probs[uint(E_Male_Hair.Spikey_Hair_Ginger)] = 8;

            probs[uint(E_Male_Hair.Spikey_Hair_Blue)] = 3;
            probs[uint(E_Male_Hair.Spikey_Hair_Green)] = 3;
            probs[uint(E_Male_Hair.Spikey_Hair_Orange)] = 3;
            probs[uint(E_Male_Hair.Spikey_Hair_Pink)] = 3;
            probs[uint(E_Male_Hair.Spikey_Hair_Purple)] = 3;
            probs[uint(E_Male_Hair.Spikey_Hair_Red)] = 3;
            probs[uint(E_Male_Hair.Spikey_Hair_Turquoise)] = 3;
            probs[uint(E_Male_Hair.Spikey_Hair_White)] = 3;

        // Superstar Hair: 150
            probs[uint(E_Male_Hair.Superstar_Hair_Black)] = 50;
            probs[uint(E_Male_Hair.Superstar_Hair_Blonde)] = 40;
            probs[uint(E_Male_Hair.Superstar_Hair_Brown)] = 30;
            probs[uint(E_Male_Hair.Superstar_Hair_Ginger)] = 20;
            probs[uint(E_Male_Hair.Superstar_Hair_White)] = 10;

        // Tall Spikey: 75
            probs[uint(E_Male_Hair.Tall_Spikey_Hair_Black)] = 16;
            probs[uint(E_Male_Hair.Tall_Spikey_Hair_Brown)] = 14;
            probs[uint(E_Male_Hair.Tall_Spikey_Hair_Blonde)] = 12;
            probs[uint(E_Male_Hair.Tall_Spikey_Hair_Ginger)] = 9;

            probs[uint(E_Male_Hair.Tall_Spikey_Hair_Blue)] = 3;
            probs[uint(E_Male_Hair.Tall_Spikey_Hair_Green)] = 3;
            probs[uint(E_Male_Hair.Tall_Spikey_Hair_Orange)] = 3;
            probs[uint(E_Male_Hair.Tall_Spikey_Hair_Pink)] = 3;
            probs[uint(E_Male_Hair.Tall_Spikey_Hair_Purple)] = 3;
            probs[uint(E_Male_Hair.Tall_Spikey_Hair_Red)] = 3;
            probs[uint(E_Male_Hair.Tall_Spikey_Hair_Turquoise)] = 3;
            probs[uint(E_Male_Hair.Tall_Spikey_Hair_White)] = 3;
            
        // Wild Hair: 800
            probs[uint(E_Male_Hair.Wild_Hair_Black)] = 200;
            probs[uint(E_Male_Hair.Wild_Hair_Brown)] = 180;
            probs[uint(E_Male_Hair.Wild_Hair_Blonde)] = 120;
            probs[uint(E_Male_Hair.Wild_Hair_Ginger)] = 100;

            probs[uint(E_Male_Hair.Wild_Hair_Blue)] = 25;
            probs[uint(E_Male_Hair.Wild_Hair_Green)] = 25;
            probs[uint(E_Male_Hair.Wild_Hair_Orange)] = 25;
            probs[uint(E_Male_Hair.Wild_Hair_Pink)] = 25;
            probs[uint(E_Male_Hair.Wild_Hair_Purple)] = 25;
            probs[uint(E_Male_Hair.Wild_Hair_Red)] = 25;
            probs[uint(E_Male_Hair.Wild_Hair_Turquoise)] = 25;
            probs[uint(E_Male_Hair.Wild_Hair_White)] = 25;

        uint selected = Random.selectRandomTrait(rndCtx, probs);

        return E_Male_Hair(selected);
    }

    function selectMaleHatHair(TraitsContext calldata traits, RandomCtx memory rndCtx) external pure returns (E_Male_Hat_Hair) {
        uint16[] memory probs = new uint16[](106);

        if (TraitsUtils.maleIsRobot(traits) || TraitsUtils.maleIsMummy(traits) || TraitsUtils.maleIsVampire(traits)) {
            return E_Male_Hat_Hair.None;
        }

        else if (TraitsUtils.maleIsHuman(traits) || TraitsUtils.maleIsZombie(traits)) {
            probs[uint(E_Male_Hat_Hair.None)] = 400;
        }

        else {
            probs[uint(E_Male_Hat_Hair.None)] = 800;
        }
        
        // Buzz Cut = 1200
            probs[uint(E_Male_Hat_Hair.Buzz_Cut_Hat)] = 250;
            probs[uint(E_Male_Hat_Hair.Buzz_Cut_Fade_Hat)] = 225;
            probs[uint(E_Male_Hat_Hair.Buzz_Cut_Black_Hat)] = 200;
            probs[uint(E_Male_Hat_Hair.Buzz_Cut_Brown_Hat)] = 185;
            probs[uint(E_Male_Hat_Hair.Buzz_Cut_Blonde_Hat)] = 175;
            probs[uint(E_Male_Hat_Hair.Buzz_Cut_Ginger_Hat)] = 165;

        // Shaved Head = 1200
            probs[uint(E_Male_Hat_Hair.Shaved_Head_Hat)] = 1200;

        // Side Line = 1200
            probs[uint(E_Male_Hat_Hair.Side_Line_Hat)] = 1200;

        // Curly Hair = 850
            probs[uint(E_Male_Hat_Hair.Curly_Hair_Black_Hat)] = 200;
            probs[uint(E_Male_Hat_Hair.Curly_Hair_Brown_Hat)] = 175;
            probs[uint(E_Male_Hat_Hair.Curly_Hair_Blonde_Hat)] = 150;
            probs[uint(E_Male_Hat_Hair.Curly_Hair_Ginger_Hat)] = 117;
            
            probs[uint(E_Male_Hat_Hair.Curly_Hair_Blue_Hat)] = 26;
            probs[uint(E_Male_Hat_Hair.Curly_Hair_Green_Hat)] = 26;
            probs[uint(E_Male_Hat_Hair.Curly_Hair_Orange_Hat)] = 26;
            probs[uint(E_Male_Hat_Hair.Curly_Hair_Pink_Hat)] = 26;
            probs[uint(E_Male_Hat_Hair.Curly_Hair_Purple_Hat)] = 26;
            probs[uint(E_Male_Hat_Hair.Curly_Hair_Red_Hat)] = 26;
            probs[uint(E_Male_Hat_Hair.Curly_Hair_Turquoise_Hat)] = 26;
            probs[uint(E_Male_Hat_Hair.Curly_Hair_White_Hat)] = 26;

        // Messy Hair = 800
            probs[uint(E_Male_Hat_Hair.Messy_Hair_Black_Hat)] = 200;
            probs[uint(E_Male_Hat_Hair.Messy_Hair_Brown_Hat)] = 180;
            probs[uint(E_Male_Hat_Hair.Messy_Hair_Blonde_Hat)] = 120;
            probs[uint(E_Male_Hat_Hair.Messy_Hair_Ginger_Hat)] = 100;

            probs[uint(E_Male_Hat_Hair.Messy_Hair_Blue_Hat)] = 25;
            probs[uint(E_Male_Hat_Hair.Messy_Hair_Green_Hat)] = 25;
            probs[uint(E_Male_Hat_Hair.Messy_Hair_Orange_Hat)] = 25;
            probs[uint(E_Male_Hat_Hair.Messy_Hair_Pink_Hat)] = 25;
            probs[uint(E_Male_Hat_Hair.Messy_Hair_Purple_Hat)] = 25;
            probs[uint(E_Male_Hat_Hair.Messy_Hair_Red_Hat)] = 25;
            probs[uint(E_Male_Hat_Hair.Messy_Hair_Turquoise_Hat)] = 25;
            probs[uint(E_Male_Hat_Hair.Messy_Hair_White_Hat)] = 25;

        // Wild Hair = 800
            probs[uint(E_Male_Hat_Hair.Wild_Hair_Black_Hat)] = 200;
            probs[uint(E_Male_Hat_Hair.Wild_Hair_Blonde_Hat)] = 180;
            probs[uint(E_Male_Hat_Hair.Wild_Hair_Brown_Hat)] = 120;
            probs[uint(E_Male_Hat_Hair.Wild_Hair_Ginger_Hat)] = 100;

            probs[uint(E_Male_Hat_Hair.Wild_Hair_Blue_Hat)] = 25;
            probs[uint(E_Male_Hat_Hair.Wild_Hair_Green_Hat)] = 25;
            probs[uint(E_Male_Hat_Hair.Wild_Hair_Orange_Hat)] = 25;
            probs[uint(E_Male_Hat_Hair.Wild_Hair_Pink_Hat)] = 25;
            probs[uint(E_Male_Hat_Hair.Wild_Hair_Purple_Hat)] = 25;
            probs[uint(E_Male_Hat_Hair.Wild_Hair_Red_Hat)] = 25;
            probs[uint(E_Male_Hat_Hair.Wild_Hair_Turquoise_Hat)] = 25;
            probs[uint(E_Male_Hat_Hair.Wild_Hair_White_Hat)] = 25;

        // Bowl Cut = 750
            probs[uint(E_Male_Hat_Hair.Bowl_Cut_Black_Hat)] = 225;
            probs[uint(E_Male_Hat_Hair.Bowl_Cut_Blonde_Hat)] = 200;
            probs[uint(E_Male_Hat_Hair.Bowl_Cut_Brown_Hat)] = 140;
            probs[uint(E_Male_Hat_Hair.Bowl_Cut_Ginger_Hat)] = 100;
            probs[uint(E_Male_Hat_Hair.Bowl_Cut_White_Hat)] = 85;

        // Old Hair = 250
            probs[uint(E_Male_Hat_Hair.Old_Hair_Black_Hat)] = 150;
            probs[uint(E_Male_Hat_Hair.Old_Hair_Grey_Hat)] = 75;
            probs[uint(E_Male_Hat_Hair.Old_Hair_White_Hat)] = 25;

        // Funky Hair = 225
            probs[uint(E_Male_Hat_Hair.Funky_Hair_Black_Hat)] = 59;
            probs[uint(E_Male_Hat_Hair.Funky_Hair_Brown_Hat)] = 45;
            probs[uint(E_Male_Hat_Hair.Funky_Hair_Blonde_Hat)] = 35;
            probs[uint(E_Male_Hat_Hair.Funky_Hair_Ginger_Hat)] = 30;

            probs[uint(E_Male_Hat_Hair.Funky_Hair_Blue_Hat)] = 7;
            probs[uint(E_Male_Hat_Hair.Funky_Hair_Green_Hat)] = 7;
            probs[uint(E_Male_Hat_Hair.Funky_Hair_Orange_Hat)] = 7;
            probs[uint(E_Male_Hat_Hair.Funky_Hair_Pink_Hat)] = 7;
            probs[uint(E_Male_Hat_Hair.Funky_Hair_Purple_Hat)] = 7;
            probs[uint(E_Male_Hat_Hair.Funky_Hair_Red_Hat)] = 7;
            probs[uint(E_Male_Hat_Hair.Funky_Hair_Turquoise_Hat)] = 7;
            probs[uint(E_Male_Hat_Hair.Funky_Hair_White_Hat)] = 7;
        
        // Superstar Hair = 150
            probs[uint(E_Male_Hat_Hair.Superstar_Hair_Black_Hat)] = 50;
            probs[uint(E_Male_Hat_Hair.Superstar_Hair_Brown_Hat)] = 40;
            probs[uint(E_Male_Hat_Hair.Superstar_Hair_Blonde_Hat)] = 30;
            probs[uint(E_Male_Hat_Hair.Superstar_Hair_Ginger_Hat)] = 20;
            probs[uint(E_Male_Hat_Hair.Superstar_Hair_White_Hat)] = 10;

        // Spikey = 80
            probs[uint(E_Male_Hat_Hair.Spikey_Black_Hat)] = 20;
            probs[uint(E_Male_Hat_Hair.Spikey_Brown_Hat)] = 16;
            probs[uint(E_Male_Hat_Hair.Spikey_Blonde_Hat)] = 12;
            probs[uint(E_Male_Hat_Hair.Spikey_Ginger_Hat)] = 8;

            probs[uint(E_Male_Hat_Hair.Spikey_Blue_Hat)] = 3;
            probs[uint(E_Male_Hat_Hair.Spikey_Green_Hat)] = 3;
            probs[uint(E_Male_Hat_Hair.Spikey_Orange_Hat)] = 3;
            probs[uint(E_Male_Hat_Hair.Spikey_Pink_Hat)] = 3;
            probs[uint(E_Male_Hat_Hair.Spikey_Purple_Hat)] = 3;
            probs[uint(E_Male_Hat_Hair.Spikey_Red_Hat)] = 3;
            probs[uint(E_Male_Hat_Hair.Spikey_Turquoise_Hat)] = 3;
            probs[uint(E_Male_Hat_Hair.Spikey_White_Hat)] = 3;

        // Electric Hair = 50
            probs[uint(E_Male_Hat_Hair.Electric_Hair_Black_Hat)] = 12;
            probs[uint(E_Male_Hat_Hair.Electric_Hair_Blonde_Hat)] = 9;
            probs[uint(E_Male_Hat_Hair.Electric_Hair_Brown_Hat)] = 7;
            probs[uint(E_Male_Hat_Hair.Electric_Hair_Ginger_Hat)] = 6;

            probs[uint(E_Male_Hat_Hair.Electric_Hair_Blue_Hat)] = 2;
            probs[uint(E_Male_Hat_Hair.Electric_Hair_Green_Hat)] = 2;
            probs[uint(E_Male_Hat_Hair.Electric_Hair_Orange_Hat)] = 2;
            probs[uint(E_Male_Hat_Hair.Electric_Hair_Pink_Hat)] = 2;
            probs[uint(E_Male_Hat_Hair.Electric_Hair_Purple_Hat)] = 2;
            probs[uint(E_Male_Hat_Hair.Electric_Hair_Red_Hat)] = 2;
            probs[uint(E_Male_Hat_Hair.Electric_Hair_Turquoise_Hat)] = 2;
            probs[uint(E_Male_Hat_Hair.Electric_Hair_White_Hat)] = 2;

        // Short Mohawk = 25
            probs[uint(E_Male_Hat_Hair.Short_Mohawk_Black_Hat)] = 6;
            probs[uint(E_Male_Hat_Hair.Short_Mohawk_Brown_Hat)] = 5;
            probs[uint(E_Male_Hat_Hair.Short_Mohawk_Blonde_Hat)] = 4;
            probs[uint(E_Male_Hat_Hair.Short_Mohawk_Ginger_Hat)] = 2;

            probs[uint(E_Male_Hat_Hair.Short_Mohawk_Blue_Hat)] = 1;
            probs[uint(E_Male_Hat_Hair.Short_Mohawk_Green_Hat)] = 1;
            probs[uint(E_Male_Hat_Hair.Short_Mohawk_Orange_Hat)] = 1;
            probs[uint(E_Male_Hat_Hair.Short_Mohawk_Pink_Hat)] = 1;
            probs[uint(E_Male_Hat_Hair.Short_Mohawk_Purple_Hat)] = 1;
            probs[uint(E_Male_Hat_Hair.Short_Mohawk_Red_Hat)] = 1;
            probs[uint(E_Male_Hat_Hair.Short_Mohawk_Turquoise_Hat)] = 1;
            probs[uint(E_Male_Hat_Hair.Short_Mohawk_White_Hat)] = 1;

        uint selected = Random.selectRandomTrait(rndCtx, probs);

        return E_Male_Hat_Hair(selected);
    }

    function selectMaleHeadwear(RandomCtx memory rndCtx) external pure returns (E_Male_Headwear) {
        uint16[] memory probs = new uint16[](169);

        // None = 955
            probs[uint(E_Male_Headwear.None)] = 955;
        //
        // Tier 1 = 4424

            // Sweatband = 750
                probs[uint(E_Male_Headwear.Sweatband_Black)] = 75;
                probs[uint(E_Male_Headwear.Sweatband_Blue)] = 75;
                probs[uint(E_Male_Headwear.Sweatband_Green)] = 75;
                probs[uint(E_Male_Headwear.Sweatband_Orange)] = 75;
                probs[uint(E_Male_Headwear.Sweatband_Pink)] = 75;
                probs[uint(E_Male_Headwear.Sweatband_Purple)] = 75;
                probs[uint(E_Male_Headwear.Sweatband_Red)] = 75;
                probs[uint(E_Male_Headwear.Sweatband_Turquoise)] = 75;
                probs[uint(E_Male_Headwear.Sweatband_White)] = 75;
                probs[uint(E_Male_Headwear.Sweatband_Yellow)] = 75;

            // Cap = 650
                probs[uint(E_Male_Headwear.Cap_Blue)] = 130;
                probs[uint(E_Male_Headwear.Cap_Green)] = 130;
                probs[uint(E_Male_Headwear.Cap_Purple)] = 130;
                probs[uint(E_Male_Headwear.Cap_Red)] = 130;
                probs[uint(E_Male_Headwear.Cap)] = 130;

            // Backwards Cap = 630
                probs[uint(E_Male_Headwear.Backwards_Cap_Blue)] = 126;
                probs[uint(E_Male_Headwear.Backwards_Cap_Green)] = 126;
                probs[uint(E_Male_Headwear.Backwards_Cap_Purple)] = 126;
                probs[uint(E_Male_Headwear.Backwards_Cap_Red)] = 126;
                probs[uint(E_Male_Headwear.Backwards_Cap)] = 126;

            // Snapback Cap = 624
                probs[uint(E_Male_Headwear.Snapback_Cap_Blue)] = 78;
                probs[uint(E_Male_Headwear.Snapback_Cap_Green)] = 78;
                probs[uint(E_Male_Headwear.Snapback_Cap_Orange)] = 78;
                probs[uint(E_Male_Headwear.Snapback_Cap_Pink)] = 78;
                probs[uint(E_Male_Headwear.Snapback_Cap_Purple)] = 78;
                probs[uint(E_Male_Headwear.Snapback_Cap_Red)] = 78;
                probs[uint(E_Male_Headwear.Snapback_Cap_Turquoise)] = 78;
                probs[uint(E_Male_Headwear.Snapback_Cap_Yellow)] = 78;
                
            // Beanie = 612
                probs[uint(E_Male_Headwear.Beanie_Blue)] = 68;
                probs[uint(E_Male_Headwear.Beanie_Brown)] = 68;
                probs[uint(E_Male_Headwear.Beanie_Green)] = 68;
                probs[uint(E_Male_Headwear.Beanie_Orange)] = 68;
                probs[uint(E_Male_Headwear.Beanie_Pink)] = 68;
                probs[uint(E_Male_Headwear.Beanie_Purple)] = 68;
                probs[uint(E_Male_Headwear.Beanie_Red)] = 68;
                probs[uint(E_Male_Headwear.Beanie_Turquoise)] = 68;
                probs[uint(E_Male_Headwear.Beanie_White)] = 68;

            // Winter Hat = 600
                probs[uint(E_Male_Headwear.Winter_Hat_Blue)] = 75;
                probs[uint(E_Male_Headwear.Winter_Hat_Brown)] = 75;
                probs[uint(E_Male_Headwear.Winter_Hat_Green)] = 75;
                probs[uint(E_Male_Headwear.Winter_Hat_Orange)] = 75;
                probs[uint(E_Male_Headwear.Winter_Hat_Pink)] = 75;
                probs[uint(E_Male_Headwear.Winter_Hat_Purple)] = 75;
                probs[uint(E_Male_Headwear.Winter_Hat_Red)] = 75;
                probs[uint(E_Male_Headwear.Winter_Hat_Turquoise)] = 75;

            // Bandana = 558
                probs[uint(E_Male_Headwear.Bandana_Black)] = 62;
                probs[uint(E_Male_Headwear.Bandana_Blue)] = 62;
                probs[uint(E_Male_Headwear.Bandana_Green)] = 62;
                probs[uint(E_Male_Headwear.Bandana_Orange)] = 62;
                probs[uint(E_Male_Headwear.Bandana_Pink)] = 62;
                probs[uint(E_Male_Headwear.Bandana_Purple)] = 62;
                probs[uint(E_Male_Headwear.Bandana_Red)] = 62;
                probs[uint(E_Male_Headwear.Bandana_Turquoise)] = 62;
                probs[uint(E_Male_Headwear.Bandana_White)] = 62;


        // Tier 2 = 2763

            // Durag = 330
                probs[uint(E_Male_Headwear.Durag_Black)] = 66;
                probs[uint(E_Male_Headwear.Durag_Blue)] = 66;
                probs[uint(E_Male_Headwear.Durag_Grey)] = 66;
                probs[uint(E_Male_Headwear.Durag_Red)] = 66;
                probs[uint(E_Male_Headwear.Durag_White)] = 66;

            // Headphones = 325
                probs[uint(E_Male_Headwear.Headphones)] = 325;

            // Hoodie = 320
                probs[uint(E_Male_Headwear.Hoodie)] = 64;
                probs[uint(E_Male_Headwear.Hoodie_Blue)] = 64;
                probs[uint(E_Male_Headwear.Hoodie_Green)] = 64;
                probs[uint(E_Male_Headwear.Hoodie_Purple)] = 64;
                probs[uint(E_Male_Headwear.Hoodie_Red)] = 64;

            // Visor = 312
                probs[uint(E_Male_Headwear.Visor_Black)] = 78;
                probs[uint(E_Male_Headwear.Visor_Blue)] = 78;
                probs[uint(E_Male_Headwear.Visor_Red)] = 78;
                probs[uint(E_Male_Headwear.Visor_White)] = 78;

            // Tassle Hat = 304
                probs[uint(E_Male_Headwear.Tassle_Hat_Blue)] = 38;
                probs[uint(E_Male_Headwear.Tassle_Hat_Green)] = 38;
                probs[uint(E_Male_Headwear.Tassle_Hat_Orange)] = 38;
                probs[uint(E_Male_Headwear.Tassle_Hat_Pink)] = 38;
                probs[uint(E_Male_Headwear.Tassle_Hat_Purple)] = 38;
                probs[uint(E_Male_Headwear.Tassle_Hat_Red)] = 38;
                probs[uint(E_Male_Headwear.Tassle_Hat_Sky_Blue)] = 38;
                probs[uint(E_Male_Headwear.Tassle_Hat_Turquoise)] = 38;

            // Sherpa Hat = 300
                probs[uint(E_Male_Headwear.Sherpa_Hat_Blue)] = 100;
                probs[uint(E_Male_Headwear.Sherpa_Hat_Brown)] = 100;
                probs[uint(E_Male_Headwear.Sherpa_Hat_Red)] = 100;

            // Construction Hat = 295
                probs[uint(E_Male_Headwear.Construction_Hat)] = 295; 

            // Welding Goggles = 290
                probs[uint(E_Male_Headwear.Welding_Goggles)] = 290;

            // Ninja Headband = 287
                probs[uint(E_Male_Headwear.Ninja_Headband_Black)] = 41;
                probs[uint(E_Male_Headwear.Ninja_Headband_Blue)] = 41;
                probs[uint(E_Male_Headwear.Ninja_Headband_Brown)] = 41;
                probs[uint(E_Male_Headwear.Ninja_Headband_Green)] = 41;
                probs[uint(E_Male_Headwear.Ninja_Headband_Orange)] = 41;
                probs[uint(E_Male_Headwear.Ninja_Headband_Purple)] = 41;
                probs[uint(E_Male_Headwear.Ninja_Headband_Red)] = 41;

        // Tier 3 = 1358

            // Cowboy Hat = 162
                    probs[uint(E_Male_Headwear.Cowboy_Hat)] = 18;
                    probs[uint(E_Male_Headwear.Cowboy_Hat_Beige)] = 18;
                    probs[uint(E_Male_Headwear.Cowboy_Hat_Black)] = 18;
                    probs[uint(E_Male_Headwear.Cowboy_Hat_Burgundy)] = 18;
                    probs[uint(E_Male_Headwear.Cowboy_Hat_Dark)] = 18;
                    probs[uint(E_Male_Headwear.Cowboy_Hat_Grey)] = 18;
                    probs[uint(E_Male_Headwear.Cowboy_Hat_Light)] = 18;
                    probs[uint(E_Male_Headwear.Cowboy_Hat_Navy)] = 18;
                    probs[uint(E_Male_Headwear.Cowboy_Hat_White)] = 18;
            
            // Cavalier Hat = 150
                probs[uint(E_Male_Headwear.Cavalier_Hat)] = 150;

            // Beret = 144
                probs[uint(E_Male_Headwear.Beret_Black)] = 48;
                probs[uint(E_Male_Headwear.Beret_Blue)] = 48;
                probs[uint(E_Male_Headwear.Beret_Red)] = 48;

            // Fedora = 135
                probs[uint(E_Male_Headwear.Fedora)] = 15;
                probs[uint(E_Male_Headwear.Fedora_Black)] = 15;
                probs[uint(E_Male_Headwear.Fedora_Beige)] = 15;
                probs[uint(E_Male_Headwear.Fedora_Burgundy)] = 15;
                probs[uint(E_Male_Headwear.Fedora_Dark)] = 15;
                probs[uint(E_Male_Headwear.Fedora_Grey)] = 15;
                probs[uint(E_Male_Headwear.Fedora_Light)] = 15;
                probs[uint(E_Male_Headwear.Fedora_Navy)] = 15;
                probs[uint(E_Male_Headwear.Fedora_White)] = 15;

            // Top Hat = 126
                probs[uint(E_Male_Headwear.Top_Hat)] = 14;
                probs[uint(E_Male_Headwear.Top_Hat_Beige)] = 14;
                probs[uint(E_Male_Headwear.Top_Hat_Black)] = 14;
                probs[uint(E_Male_Headwear.Top_Hat_Burgundy)] = 14;
                probs[uint(E_Male_Headwear.Top_Hat_Dark)] = 14;
                probs[uint(E_Male_Headwear.Top_Hat_Grey)] = 14;
                probs[uint(E_Male_Headwear.Top_Hat_Light)] = 14;
                probs[uint(E_Male_Headwear.Top_Hat_Navy)] = 14;
                probs[uint(E_Male_Headwear.Top_Hat_White)] = 14;

            // Bowler Hat = 112
                probs[uint(E_Male_Headwear.Bowler_Hat_Black)] = 16;
                probs[uint(E_Male_Headwear.Bowler_Hat_Beige)] = 16;
                probs[uint(E_Male_Headwear.Bowler_Hat_Brown)] = 16;
                probs[uint(E_Male_Headwear.Bowler_Hat_Burgundy)] = 16;
                probs[uint(E_Male_Headwear.Bowler_Hat_Grey)] = 16;
                probs[uint(E_Male_Headwear.Bowler_Hat_Navy)] = 16;
                probs[uint(E_Male_Headwear.Bowler_Hat_White)] = 16;
                
            // Wide Bowler Hat = 112
                probs[uint(E_Male_Headwear.Wide_Bowler_Hat_Beige)] = 16;
                probs[uint(E_Male_Headwear.Wide_Bowler_Hat_Black)] = 16;
                probs[uint(E_Male_Headwear.Wide_Bowler_Hat_Brown)] = 16;
                probs[uint(E_Male_Headwear.Wide_Bowler_Hat_Burgundy)] = 16;
                probs[uint(E_Male_Headwear.Wide_Bowler_Hat_Grey)] = 16;
                probs[uint(E_Male_Headwear.Wide_Bowler_Hat_Navy)] = 16;
                probs[uint(E_Male_Headwear.Wide_Bowler_Hat_White)] = 16;

            // Boater = 110
                probs[uint(E_Male_Headwear.Boater)] = 110;

            // Deerstalker Hat = 105
                probs[uint(E_Male_Headwear.Deerstalker_Hat)] = 105;

            // Military Beret = 102
                probs[uint(E_Male_Headwear.Military_Beret_Brown)] = 34;
                probs[uint(E_Male_Headwear.Military_Beret_Green)] = 34;
                probs[uint(E_Male_Headwear.Military_Beret_Red)] = 34;
        
            // Military Helmet = 100
                probs[uint(E_Male_Headwear.Military_Helmet)] = 100;
        
        // Tier 4 = 500

            // Police Hat = 75
                probs[uint(E_Male_Headwear.Police_Hat)] = 75;

            // Santa Hat = 65
                probs[uint(E_Male_Headwear.Santa_Hat)] = 45;
                probs[uint(E_Male_Headwear.Santa_Hat_Green)] = 20;

            // Jester Hat = 65
                probs[uint(E_Male_Headwear.Jester_Hat)] = 65;

            // Kitty Ears = 60
                probs[uint(E_Male_Headwear.Kitty_Ears_Brown)] = 15;
                probs[uint(E_Male_Headwear.Kitty_Ears_Pink)] = 15;
                probs[uint(E_Male_Headwear.Kitty_Ears_Purple)] = 15;
                probs[uint(E_Male_Headwear.Kitty_Ears_White)] = 15;

            // Viking Hat = 55
                probs[uint(E_Male_Headwear.Viking_Hat)] = 55;
        
            // Pirate Hat = 50
                probs[uint(E_Male_Headwear.Pirate_Hat)] = 50;

            // Cloak = 42
                probs[uint(E_Male_Headwear.Cloak_Black)] = 6;
                probs[uint(E_Male_Headwear.Cloak)] = 6;
                probs[uint(E_Male_Headwear.Cloak_Blue)] = 6;
                probs[uint(E_Male_Headwear.Cloak_Green)] = 6;
                probs[uint(E_Male_Headwear.Cloak_Purple)] = 6;
                probs[uint(E_Male_Headwear.Cloak_Red)] = 6;
                probs[uint(E_Male_Headwear.Cloak_White)] = 6;
            
            // Wizard Hat = 40
                probs[uint(E_Male_Headwear.Wizard_Hat_Blue)] = 5;
                probs[uint(E_Male_Headwear.Wizard_Hat_Green)] = 5;
                probs[uint(E_Male_Headwear.Wizard_Hat_Orange)] = 5;
                probs[uint(E_Male_Headwear.Wizard_Hat_Pink)] = 5;
                probs[uint(E_Male_Headwear.Wizard_Hat_Purple)] = 5;
                probs[uint(E_Male_Headwear.Wizard_Hat_Red)] = 5;
                probs[uint(E_Male_Headwear.Wizard_Hat_Turquoise)] = 5;
                probs[uint(E_Male_Headwear.Wizard_Hat)] = 5;

            // Halo = 30
                probs[uint(E_Male_Headwear.Halo)] = 30;

            // Devil Horns = 15
                probs[uint(E_Male_Headwear.Demon_Horns)] = 15;

            // King Crown = 3
                probs[uint(E_Male_Headwear.King_Crown)] = 3;

        uint selected = Random.selectRandomTrait(rndCtx, probs);

        return E_Male_Headwear(selected);
    }

    function selectMaleEyeWear(RandomCtx memory rndCtx) external pure returns (E_Male_Eye_Wear) {
        uint16[] memory probs = new uint16[](128);
        
        // None = 1000
            probs[uint(E_Male_Eye_Wear.None)] = 1000;

        // Tier 1 = 4000
            
            // Regular Shades = 628
                probs[uint(E_Male_Eye_Wear.Regular_Glasses)] = 628;

            // Square Glasses = 576
                probs[uint(E_Male_Eye_Wear.Square_Glasses)] = 64;
                probs[uint(E_Male_Eye_Wear.Square_Glasses_Blue)] = 64;
                probs[uint(E_Male_Eye_Wear.Square_Glasses_Green)] = 64;
                probs[uint(E_Male_Eye_Wear.Square_Glasses_Orange)] = 64;
                probs[uint(E_Male_Eye_Wear.Square_Glasses_Pink)] = 64;
                probs[uint(E_Male_Eye_Wear.Square_Glasses_Purple)] = 64;
                probs[uint(E_Male_Eye_Wear.Square_Glasses_Red)] = 64;
                probs[uint(E_Male_Eye_Wear.Square_Glasses_Turquoise)] = 64;
                probs[uint(E_Male_Eye_Wear.Square_Glasses_Yellow)] = 64;

            // Circle Glasses = 576
                probs[uint(E_Male_Eye_Wear.Circle_Glasses)] = 64;
                probs[uint(E_Male_Eye_Wear.Circle_Glasses_Blue)] = 64;
                probs[uint(E_Male_Eye_Wear.Circle_Glasses_Green)] = 64;
                probs[uint(E_Male_Eye_Wear.Circle_Glasses_Orange)] = 64;
                probs[uint(E_Male_Eye_Wear.Circle_Glasses_Pink)] = 64;
                probs[uint(E_Male_Eye_Wear.Circle_Glasses_Purple)] = 64;
                probs[uint(E_Male_Eye_Wear.Circle_Glasses_Red)] = 64;
                probs[uint(E_Male_Eye_Wear.Circle_Glasses_Turquoise)] = 64;
                probs[uint(E_Male_Eye_Wear.Circle_Glasses_Yellow)] = 64;

            // Horn Rimmed Glasses = 570
                probs[uint(E_Male_Eye_Wear.Horn_Rimmed_Glasses)] = 570;

            // Nerd Glasses = 560
                probs[uint(E_Male_Eye_Wear.Nerd_Glasses)] = 560;

            // Shades = 550
                probs[uint(E_Male_Eye_Wear.Shades_Blue)] = 50;
                probs[uint(E_Male_Eye_Wear.Shades_Gold)] = 50;
                probs[uint(E_Male_Eye_Wear.Shades_Green)] = 50;
                probs[uint(E_Male_Eye_Wear.Shades_Hot_Pink)] = 50;
                probs[uint(E_Male_Eye_Wear.Shades_Orange)] = 50;
                probs[uint(E_Male_Eye_Wear.Shades_Pink)] = 50;
                probs[uint(E_Male_Eye_Wear.Shades_Purple)] = 50;
                probs[uint(E_Male_Eye_Wear.Shades_Red)] = 50;
                probs[uint(E_Male_Eye_Wear.Shades_Sky_Blue)] = 50;
                probs[uint(E_Male_Eye_Wear.Shades_Turquoise)] = 50;
                probs[uint(E_Male_Eye_Wear.Shades_Yellow)] = 50;

            // Eye Mask = 540
                probs[uint(E_Male_Eye_Wear.Eye_Mask)] = 540;

        // Tier 2 = 3000
            
            // Big Shades = 506
                probs[uint(E_Male_Eye_Wear.Big_Shades_Blue)] = 46;
                probs[uint(E_Male_Eye_Wear.Big_Shades_Golden)] = 46;
                probs[uint(E_Male_Eye_Wear.Big_Shades_Green)] = 46;
                probs[uint(E_Male_Eye_Wear.Big_Shades_Hot_Pink)] = 46;
                probs[uint(E_Male_Eye_Wear.Big_Shades_Orange)] = 46;
                probs[uint(E_Male_Eye_Wear.Big_Shades_Pink)] = 46;
                probs[uint(E_Male_Eye_Wear.Big_Shades_Purple)] = 46;
                probs[uint(E_Male_Eye_Wear.Big_Shades_Red)] = 46;
                probs[uint(E_Male_Eye_Wear.Big_Shades_Sky_Blue)] = 46;
                probs[uint(E_Male_Eye_Wear.Big_Shades_Turquoise)] = 46;
                probs[uint(E_Male_Eye_Wear.Big_Shades_Yellow)] = 46;

            // 3D Glasses = 475
                probs[uint(E_Male_Eye_Wear._3D_Glasses)] = 475;

            // Blue Light Blocking Glasses = 475
                probs[uint(E_Male_Eye_Wear.Blue_Light_Blocking_Glasses)] = 475;

            // Retro Shades = 425
                probs[uint(E_Male_Eye_Wear.Retro_Shades)] = 425;

            // Gangster Shades = 400
                probs[uint(E_Male_Eye_Wear.Gangster_Shades)] = 400;

            // Heart Shades = 372
                probs[uint(E_Male_Eye_Wear.Heart_Shades_Blue)] = 62;
                probs[uint(E_Male_Eye_Wear.Heart_Shades_Green)] = 62;
                probs[uint(E_Male_Eye_Wear.Heart_Shades_Orange)] = 62;
                probs[uint(E_Male_Eye_Wear.Heart_Shades_Pink)] = 62;
                probs[uint(E_Male_Eye_Wear.Heart_Shades_Purple)] = 62;
                probs[uint(E_Male_Eye_Wear.Heart_Shades)] = 62;

            // Steampunk Glasses = 347
                probs[uint(E_Male_Eye_Wear.Steampunk_Glasses)] = 347;

        // Tier 3 = 1750
            
            // Eye Patch = 317
                probs[uint(E_Male_Eye_Wear.Eye_Patch)] = 317;

            // Enhanced 3D Glasses = 280
                probs[uint(E_Male_Eye_Wear.Enhanced_3D_Glasses)] = 280;

            // Monocle = 250
                probs[uint(E_Male_Eye_Wear.Monocle_Left)] = 125;
                probs[uint(E_Male_Eye_Wear.Monocle_Right)] = 125;

            // Pirate Eye Patch = 225
                probs[uint(E_Male_Eye_Wear.Pirate_Eye_Patch)] = 225;

            // Futuristic Shades = 196
                probs[uint(E_Male_Eye_Wear.Futuristic_Shades_Blue)] = 28;
                probs[uint(E_Male_Eye_Wear.Futuristic_Shades_Green)] = 28;
                probs[uint(E_Male_Eye_Wear.Futuristic_Shades_Orange)] = 28;
                probs[uint(E_Male_Eye_Wear.Futuristic_Shades_Pink)] = 28;
                probs[uint(E_Male_Eye_Wear.Futuristic_Shades_Purple)] = 28;
                probs[uint(E_Male_Eye_Wear.Futuristic_Shades_Red)] = 28;
                probs[uint(E_Male_Eye_Wear.Futuristic_Shades_Turquoise)] = 28;

            // Bionic Eye Patch = 160
                probs[uint(E_Male_Eye_Wear.Bionic_Eye_Patch_Blue)] = 20;
                probs[uint(E_Male_Eye_Wear.Bionic_Eye_Patch_Green)] = 20;
                probs[uint(E_Male_Eye_Wear.Bionic_Eye_Patch_Orange)] = 20;
                probs[uint(E_Male_Eye_Wear.Bionic_Eye_Patch_Pink)] = 20;
                probs[uint(E_Male_Eye_Wear.Bionic_Eye_Patch_Purple)] = 20;
                probs[uint(E_Male_Eye_Wear.Bionic_Eye_Patch_Red)] = 20;
                probs[uint(E_Male_Eye_Wear.Bionic_Eye_Patch_Turquoise)] = 20;
                probs[uint(E_Male_Eye_Wear.Bionic_Eye_Patch_Yellow)] = 20;

            // VR Headset = 132
                probs[uint(E_Male_Eye_Wear.VR_Headset_Blue)] = 33;
                probs[uint(E_Male_Eye_Wear.VR_Headset_Green)] = 33;
                probs[uint(E_Male_Eye_Wear.VR_Headset_Red)] = 33;
                probs[uint(E_Male_Eye_Wear.VR_Headset)] = 33;

            // AR Headset = 110
                probs[uint(E_Male_Eye_Wear.AR_Headset_Blue)] = 22;
                probs[uint(E_Male_Eye_Wear.AR_Headset_Green)] = 22;
                probs[uint(E_Male_Eye_Wear.AR_Headset_Pink)] = 22;
                probs[uint(E_Male_Eye_Wear.AR_Headset_Purple)] = 22;
                probs[uint(E_Male_Eye_Wear.AR_Headset_Red)] = 22;

            // AR Shades: 80
                probs[uint(E_Male_Eye_Wear.AR_Shades_Blue)] = 10;
                probs[uint(E_Male_Eye_Wear.AR_Shades_Green)] = 10;
                probs[uint(E_Male_Eye_Wear.AR_Shades_Orange)] = 10;
                probs[uint(E_Male_Eye_Wear.AR_Shades_Pink)] = 10;
                probs[uint(E_Male_Eye_Wear.AR_Shades_Purple)] = 10;
                probs[uint(E_Male_Eye_Wear.AR_Shades_Red)] = 10;
                probs[uint(E_Male_Eye_Wear.AR_Shades_Turquoise)] = 10;
                probs[uint(E_Male_Eye_Wear.AR_Shades_Yellow)] = 10;

        // Tier 4 = 250
            
            // Rainbow Shades = 69
                probs[uint(E_Male_Eye_Wear.Rainbow_Shades)] = 69;

            // XR Headset = 45
                probs[uint(E_Male_Eye_Wear.XR_Headset_Blue)] = 5;
                probs[uint(E_Male_Eye_Wear.XR_Headset_Green)] = 5;
                probs[uint(E_Male_Eye_Wear.XR_Headset_Orange)] = 5;
                probs[uint(E_Male_Eye_Wear.XR_Headset_Pink)] = 5;
                probs[uint(E_Male_Eye_Wear.XR_Headset_Purple)] = 5;
                probs[uint(E_Male_Eye_Wear.XR_Headset_Red)] = 5;
                probs[uint(E_Male_Eye_Wear.XR_Headset_Sky_Blue)] = 5;
                probs[uint(E_Male_Eye_Wear.XR_Headset_Turquoise)] = 5;
                probs[uint(E_Male_Eye_Wear.XR_Headset_Yellow)] = 5;

            // Matrix Headset = 40
                probs[uint(E_Male_Eye_Wear.Matrix_Headset_Blue)] = 5;
                probs[uint(E_Male_Eye_Wear.Matrix_Headset_Green)] = 5;
                probs[uint(E_Male_Eye_Wear.Matrix_Headset_Orange)] = 5;
                probs[uint(E_Male_Eye_Wear.Matrix_Headset_Pink)] = 5;
                probs[uint(E_Male_Eye_Wear.Matrix_Headset_Purple)] = 5;
                probs[uint(E_Male_Eye_Wear.Matrix_Headset_Red)] = 5;
                probs[uint(E_Male_Eye_Wear.Matrix_Headset_Turquoise)] = 5;
                probs[uint(E_Male_Eye_Wear.Matrix_Headset_Yellow)] = 5;

            // Ninja Eye Mask: 36
                probs[uint(E_Male_Eye_Wear.Ninja_Eye_Mask_Blue)] = 9;
                probs[uint(E_Male_Eye_Wear.Ninja_Eye_Mask_Orange)] = 9;
                probs[uint(E_Male_Eye_Wear.Ninja_Eye_Mask_Purple)] = 9;
                probs[uint(E_Male_Eye_Wear.Ninja_Eye_Mask_Red)] = 9;

            // Scouter = 27
                probs[uint(E_Male_Eye_Wear.Scouter_Blue)] = 3;
                probs[uint(E_Male_Eye_Wear.Scouter_Green)] = 3;
                probs[uint(E_Male_Eye_Wear.Scouter_Orange)] = 3;
                probs[uint(E_Male_Eye_Wear.Scouter_Pink)] = 3;
                probs[uint(E_Male_Eye_Wear.Scouter_Purple)] = 3;
                probs[uint(E_Male_Eye_Wear.Scouter_Red)] = 3;
                probs[uint(E_Male_Eye_Wear.Scouter_Turquoise)] = 3;
                probs[uint(E_Male_Eye_Wear.Scouter_Yellow)] = 3;
                probs[uint(E_Male_Eye_Wear.Scouter)] = 3;

            // Cyclops Visor = 23
                probs[uint(E_Male_Eye_Wear.Cyclops_Visor)] = 23;

            // Laser Beam = 10
                probs[uint(E_Male_Eye_Wear.Laser_Beam)] = 4;
                probs[uint(E_Male_Eye_Wear.Laser_Beam_Blue)] = 3;
                probs[uint(E_Male_Eye_Wear.Laser_Beam_Green)] = 3;
        
        uint selected = Random.selectRandomTrait(rndCtx, probs);

        return E_Male_Eye_Wear(selected);
    }

    function selectMouth(TraitsContext calldata traits, RandomCtx memory rndCtx) external pure returns (E_Mouth) {
        uint16[] memory probs = new uint16[](23);

        if (TraitsUtils.isFemale(traits)) {
            // Lip Gloss = 100
                probs[uint(E_Mouth.Lip_Gloss_Red)] = 35;
                probs[uint(E_Mouth.Lip_Gloss_Pink)] = 30;
                probs[uint(E_Mouth.Lip_Gloss_Purple)] = 20;
                probs[uint(E_Mouth.Lip_Gloss_Blue)] = 15;
        }

        if (TraitsUtils.maleHasBlackFacialHair(traits)) {
            // Facial Expressions = 200
                probs[uint(E_Mouth.Smirk)] = 100;
                probs[uint(E_Mouth.Smile)] = 100;
        }

        // None = 8155
            probs[uint(E_Mouth.None)] = 8155;

        // Smoking = 1050
            probs[uint(E_Mouth.Vape)] = 300;
            probs[uint(E_Mouth.Cigarette)] = 250;
            probs[uint(E_Mouth.Blunt)] = 200;
            probs[uint(E_Mouth.Cigar)] = 150;
            probs[uint(E_Mouth.Pipe)] = 100;
            probs[uint(E_Mouth.Old_Fashioned_Pipe)] = 50;

        // Buck Teeth = 150
            probs[uint(E_Mouth.Buck_Teeth)] = 150;

        // Blood = 125
            probs[uint(E_Mouth.Blood)] = 125;

        // Bubble Gum = 80
            probs[uint(E_Mouth.Bubble_Gum)] = 50;
            probs[uint(E_Mouth.Blue_Bubble_Gum)] = 30;

        // Grill = 60
            probs[uint(E_Mouth.Silver_Grill)] = 25;
            probs[uint(E_Mouth.Gold_Grill)] = 20;
            probs[uint(E_Mouth.Diamond_Grill)] = 15;
        
        // Clown Lips = 50
            probs[uint(E_Mouth.Clown_Lips)] = 50;

        // Vomit = 30
            probs[uint(E_Mouth.Vomit)] = 20;
            probs[uint(E_Mouth.Rainbow_Vomit)] = 10;
        
        uint selected = Random.selectRandomTrait(rndCtx, probs);

        return E_Mouth(selected);
    }
}
```

### SVGRenderer.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Utils } from './libraries/Utils.sol';
import { TraitsUtils } from './libraries/TraitsUtils.sol';
import { DynamicBuffer } from './libraries/DynamicBuffer.sol';
import { TraitsContext, CachedTraitGroups, TraitGroup, TraitInfo } from './common/Structs.sol';
import { NUM_TRAIT_GROUPS, E_Special_1s, E_TraitsGroup } from "./common/Enums.sol";
import { IAssets } from './interfaces/IAssets.sol';
import { TraitsLoader } from './libraries/TraitsLoader.sol';
import { ISVGRenderer } from './interfaces/ISVGRenderer.sol';
import { TraitsRenderer } from './libraries/TraitsRenderer.sol';
import { ITraits } from './interfaces/ITraits.sol';


contract SVGRenderer is ISVGRenderer {
    IAssets private immutable _ASSETS_CONTRACT;
    ITraits private immutable _TRAITS_CONTRACT;

    string[] internal suffixes = [
        " 1",
        " 2",
        " 3",
        " 4",
        " 5",
        " 6",
        " 7",
        " 8",
        " 9",
        " 10",
        " 11",
        " 12",
        " Left",
        " Right",
        " Black",
        " Brown",
        " Blonde",
        " Ginger",
        " Light",
        " Dark",
        " Shadow",
        " Fade",
        " Blue",
        " Green",
        " Orange",
        " Pink",
        " Purple",
        " Red",
        " Turquoise",
        " White",
        " Yellow",
        " Sky Blue",
        " Hot Pink",
        " Neon Blue",
        " Neon Green",
        " Neon Purple",
        " Neon Red",
        " Grey",
        " Navy",
        " Burgundy",
        " Beige",
        " Black Hat",
        " Brown Hat",
        " Blonde Hat",
        " Ginger Hat",
        " Blue Hat",
        " Green Hat",
        " Orange Hat",
        " Pink Hat",
        " Purple Hat",
        " Red Hat",
        " Turquoise Hat",
        " White Hat",
        " Yellow Hat"
    ];

    constructor(IAssets assetsContract, ITraits traitsContract) {
        _ASSETS_CONTRACT = assetsContract;
        _TRAITS_CONTRACT = traitsContract;
    }

    function renderSVG(uint16 tokenIdSeed, uint16 backgroundIndex, uint256 globalSeed) public view returns (string memory svg, string memory traitsAsString) {
        bytes memory buffer = DynamicBuffer.allocate(40000);
        CachedTraitGroups memory cachedTraitGroups = TraitsLoader.initCachedTraitGroups(NUM_TRAIT_GROUPS);
        
        TraitsContext memory traits = _TRAITS_CONTRACT.generateAllTraits(tokenIdSeed, backgroundIndex, globalSeed);

        _prepareCache(cachedTraitGroups, traits);

        if (_isPreRenderedSpecial(traits.specialId)) {
            return _renderPreRenderedSpecial(buffer, traits, cachedTraitGroups);
        }

        // Standard rendering path
        TraitsRenderer.renderGridToSvg(_ASSETS_CONTRACT, buffer, cachedTraitGroups, traits);
        traitsAsString = _getTraitsAsJson(cachedTraitGroups, traits);
        svg = string(buffer);
    }

    function renderHTML(bytes memory svgContent) public pure returns (string memory html) {
        html = "";
    }

    function _prepareCache(CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal view {
        // 1. Always load background
        TraitsLoader.loadAndCacheTraitGroup(_ASSETS_CONTRACT, cachedTraitGroups, uint(E_TraitsGroup.Background_Group));

        // 2. If it's any special, load the Special Name Group
        if (traits.specialId > 0) {
            TraitsLoader.loadAndCacheTraitGroup(_ASSETS_CONTRACT, cachedTraitGroups, uint(E_TraitsGroup.Special_1s_Group));
        }

        // 3. Only load standard trait groups if it's NOT a pre-rendered special
        if (!_isPreRenderedSpecial(traits.specialId)) {
            for (uint i = 0; i < traits.traitsToRenderLength; i++) {
                uint traitGroupIndex = uint8(traits.traitsToRender[i].traitGroup);
                TraitsLoader.loadAndCacheTraitGroup(_ASSETS_CONTRACT, cachedTraitGroups, traitGroupIndex);

                if (traits.traitsToRender[i].hasFiller) {
                    uint fillerTraitGroupIndex = uint8(traits.traitsToRender[i].filler.traitGroup);
                    TraitsLoader.loadAndCacheTraitGroup(_ASSETS_CONTRACT, cachedTraitGroups, fillerTraitGroupIndex);
                }
            }
        }
    }

    function _isPreRenderedSpecial(uint16 specialId) private pure returns (bool) {
        if (specialId == 0) return false;
        
        uint idx = specialId - 1;
        return (
            idx == uint(E_Special_1s.Predator_Blue) ||
            idx == uint(E_Special_1s.Predator_Green) ||
            idx == uint(E_Special_1s.Predator_Red) ||
            idx == uint(E_Special_1s.Santa_Claus) ||
            idx == uint(E_Special_1s.Shadow_Ninja) ||
            idx == uint(E_Special_1s.The_Devil) ||
            idx == uint(E_Special_1s.The_Portrait)
        );
    }

    function _renderPreRenderedSpecial(bytes memory buffer, TraitsContext memory traits, CachedTraitGroups memory cachedTraitGroups) private view returns (string memory svg, string memory traitsAsString) {
        /*
            Predator_Blue  --> key 105
            Predator_Green --> key 106  
            Predator_Red   --> key 107
            Santa_Claus    --> key 108
            Shadow_Ninja   --> key 109
            The_Devil      --> key 112
            The_Portrait   --> key 114
        */
        bytes memory rawPngBytes = _ASSETS_CONTRACT.loadAssetOriginal(traits.specialId + 100);

        Utils.concat(buffer, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">');
        Utils.concat(buffer, '<style>img{image-rendering:pixelated;}</style>');
        Utils.concat(buffer, '<g id="GeneratedImage">');
        Utils.concat(buffer, '<foreignObject width="48" height="48">');
        Utils.concat(buffer, '<img xmlns="http://www.w3.org/1999/xhtml" src="data:image/png;base64,');
        Utils.concatBase64(buffer, rawPngBytes);
        Utils.concat(buffer, '" width="100%" height="100%"/></foreignObject></g></svg>');

        svg = string(buffer);
        traitsAsString = _getTraitsAsJson(cachedTraitGroups, traits);
    }

    function _getTraitsAsJson(CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal view returns (string memory) {
        bytes memory buffer = DynamicBuffer.allocate(2000);
        Utils.concat(buffer, '"attributes":[');

        // 1. Birthday attribute (Always present)
        Utils.concat(buffer, '{"display_type":"date","trait_type":"Birthday","value":');
        Utils.concat(buffer, bytes(Utils.toString(traits.birthday)));
        Utils.concat(buffer, '}');

        // 2. Special Trait Name (Fetched dynamically from Assets)
        if (traits.specialId > 0) {
            TraitGroup memory specialGroup = cachedTraitGroups.traitGroups[uint(E_TraitsGroup.Special_1s_Group)];
            uint specialIdx = traits.specialId - 1;

            // Verify index is within the loaded asset group bounds
            if (specialIdx < specialGroup.traits.length) {
                Utils.concat(buffer, ',');
                string memory specName = string(specialGroup.traits[specialIdx].traitName);
                Utils.concat(buffer, _stringTrait("Special", specName));
            }
        }

        // 3. Standard Traits Loop
        // We wrap this in a check: if it's pre-rendered, we skip standard traits entirely.
        // This prevents Panic 0x32 if Traits.sol mistakenly assigned "ghost" traits.
        if (!_isPreRenderedSpecial(traits.specialId)) {
            for (uint i = 0; i < traits.traitsToRenderLength; i++) {
                uint traitGroupIndex = uint(traits.traitsToRender[i].traitGroup);
                uint traitIndex = traits.traitsToRender[i].traitIndex;

                // Skip background to avoid duplicates (rendered separately in most implementations)
                if (traitGroupIndex == uint(E_TraitsGroup.Background_Group)) {
                    continue;
                }

                TraitGroup memory traitGroup = cachedTraitGroups.traitGroups[traitGroupIndex];
                
                // Safety check: Ensure the group was actually loaded and the index is valid
                if (traitGroup.traits.length > 0 && traitIndex < traitGroup.traits.length) {
                    TraitInfo memory traitInfo = traitGroup.traits[traitIndex];
                    Utils.concat(buffer, ',');

                    // Remove numeric suffixes (e.g., "Mouth 1" -> "Mouth")
                    string memory baseName = TraitsUtils.getBaseTraitValue(
                        E_TraitsGroup(traitGroup.traitGroupIndex),
                        string(traitInfo.traitName),
                        suffixes
                    );

                    Utils.concat(buffer, _stringTrait(string(traitGroup.traitGroupName), baseName));
                }
            }
        }

        Utils.concat(buffer, ']');
        return string(buffer);
    }

    function _stringTrait(string memory traitName, string memory traitValue) internal pure returns (bytes memory) {
        return bytes(string.concat(
            '{"trait_type":"',
            traitName,
            '","value":"',
            traitValue,
            '"}'
        ));
    }
}
```

### Traits.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { IFemaleProbs } from './interfaces/IFemaleProbs.sol';
import { IMaleProbs } from './interfaces/IMaleProbs.sol';
import { Random, RandomCtx } from "./libraries/Random.sol";
import { TraitsContext, TraitToRender, FillerTrait } from "./common/Structs.sol";
import { NUM_SPECIAL_1S, E_Sex, E_Special_1s, E_Background, E_Male_Skin, E_Male_Eyes, E_Male_Face, E_Male_Chain, E_Male_Earring, E_Male_Scarf, E_Male_Facial_Hair, E_Male_Mask, E_Male_Hair, E_Male_Hat_Hair, E_Male_Headwear, E_Male_Eye_Wear, E_Female_Skin, E_Female_Eyes, E_Female_Face, E_Female_Chain, E_Female_Earring, E_Female_Scarf, E_Female_Mask, E_Female_Hair, E_Female_Hat_Hair, E_Female_Headwear, E_Female_Eye_Wear, E_Mouth, E_Filler_Traits, E_TraitsGroup } from "./common/Enums.sol";
import { TraitsUtils } from "./libraries/TraitsUtils.sol";
import { ITraits } from './interfaces/ITraits.sol';

error TraitsArrayOverflow(uint8 currentLength, uint8 maxLength);
error InvalidTraitIndex(uint8 traitGroupIndex, uint8 traitIndex);

contract Traits is ITraits {

    IMaleProbs public immutable MALE_PROBS_CONTRACT;
    IFemaleProbs public immutable FEMALE_PROBS_CONTRACT;

    constructor(IMaleProbs _maleProbsContract, IFemaleProbs _femaleProbsContract) {
        MALE_PROBS_CONTRACT = _maleProbsContract;
        FEMALE_PROBS_CONTRACT = _femaleProbsContract;
    }

    function generateAllTraits(uint16 _tokenIdSeed, uint16 _backgroundIndex, uint256 _globalSeed) external view returns (TraitsContext memory) {
        RandomCtx memory rndCtx = Random.initCtx(_tokenIdSeed, _globalSeed);
        TraitsContext memory traits;
        traits.traitsToRender = new TraitToRender[](15);
        traits.tokenIdSeed = _tokenIdSeed;
        traits.globalSeed = _globalSeed;

        // Check for Special first
        if (_tokenIdSeed < NUM_SPECIAL_1S) {
            traits.specialId = _tokenIdSeed + 1;
        }

        // Birthday
        uint32 minDate = 4102444800; 
        uint32 maxDate = 4133941199; 
        traits.birthday = uint32(Random.randRange(rndCtx, minDate, maxDate));

        // Handle Special Cases
        if (traits.specialId > 0) {
            uint specialIdx = traits.specialId - 1;
            
            // If it's a PRE-RENDERED special (7 total)
            if (_isPreRendered(specialIdx)) {
                // Do NOT add background, do NOT add mouth, just return.
                // (We don't even add the special trait to traitsToRender because the renderer will handle the PNG and the JSON name separately)
                return traits; 
            } 
            
            // If it's a LAYERED special (the other 7)
            traits.background = E_Background(_backgroundIndex);
            _addBackground(traits);
            _addSpecial(traits, specialIdx);
            return traits; // Stop here!
        }

        // 4. Select Male / Female
        traits.sex = Random.randBool(rndCtx, 6600) ? E_Sex.Male : E_Sex.Female;

        // === MALE TRAITS ===
        if (traits.sex == E_Sex.Male) {
            // Select all traits
            traits.background = E_Background(_backgroundIndex);
            _addBackground(traits);

            traits.maleSkin = MALE_PROBS_CONTRACT.selectMaleSkin(rndCtx);
            traits.maleEyes = MALE_PROBS_CONTRACT.selectMaleEyes(traits, rndCtx);
            traits.maleFace = MALE_PROBS_CONTRACT.selectMaleFace(traits, rndCtx);
            traits.maleChain = MALE_PROBS_CONTRACT.selectMaleChain(rndCtx);
            traits.maleEarring = MALE_PROBS_CONTRACT.selectMaleEarring(rndCtx);
            traits.maleFacialHair = MALE_PROBS_CONTRACT.selectMaleFacialHair(traits, rndCtx);
            traits.maleMask = MALE_PROBS_CONTRACT.selectMaleMask(rndCtx);
            traits.maleScarf = MALE_PROBS_CONTRACT.selectMaleScarf(rndCtx);
            traits.maleHair = MALE_PROBS_CONTRACT.selectMaleHair(traits, rndCtx);
            traits.maleHatHair = MALE_PROBS_CONTRACT.selectMaleHatHair(traits, rndCtx);
            traits.maleHeadwear = MALE_PROBS_CONTRACT.selectMaleHeadwear(rndCtx);
            traits.maleEyeWear = MALE_PROBS_CONTRACT.selectMaleEyeWear(rndCtx);

            // Add traits in rendering order (back to front)
            _addMaleSkin(traits);
            _addMaleEyes(traits);
            _addMaleFace(traits);
            _addMaleChain(traits);
            _addMaleEarring(traits);

            // 80% Facial Hair, 10% Mask, 10% nothing
            if (TraitsUtils.maleHasFacialHair(traits)) {
                _addMaleFacialHair(traits);
            } else {
                _addMaleMask(traits); 
            }

            _addMaleScarf(traits);
            
            // 60% chance of headwear
            if (TraitsUtils.maleHasHeadwear(traits)) {
                // 0.6 x 0.5 = 30% chance of hat hair
                _addMaleHatHair(traits);
            } else {
                // 0.4 x 0.9 = 36% chance of regular hair
                // 0.4 x 0.1 = 4% chance of nothing (bald)
                _addMaleHair(traits);
            }

            _addMaleHeadwear(traits);
            _addMaleEyeWear(traits);
        }

        // === FEMALE TRAITS ===
        else {
            // Select all traits
            traits.background = E_Background(_backgroundIndex);
            _addBackground(traits);

            traits.femaleSkin = FEMALE_PROBS_CONTRACT.selectFemaleSkin(rndCtx);
            traits.femaleEyes = FEMALE_PROBS_CONTRACT.selectFemaleEyes(traits, rndCtx);
            traits.femaleFace = FEMALE_PROBS_CONTRACT.selectFemaleFace(traits, rndCtx);
            traits.femaleChain = FEMALE_PROBS_CONTRACT.selectFemaleChain(rndCtx);
            traits.femaleEarring = FEMALE_PROBS_CONTRACT.selectFemaleEarring(rndCtx);
            traits.femaleMask = FEMALE_PROBS_CONTRACT.selectFemaleMask(rndCtx);
            traits.femaleScarf = FEMALE_PROBS_CONTRACT.selectFemaleScarf(rndCtx);
            traits.femaleHair = FEMALE_PROBS_CONTRACT.selectFemaleHair(traits, rndCtx);
            traits.femaleHatHair = FEMALE_PROBS_CONTRACT.selectFemaleHatHair(traits, rndCtx);
            traits.femaleHeadwear = FEMALE_PROBS_CONTRACT.selectFemaleHeadwear(rndCtx);
            traits.femaleEyeWear = FEMALE_PROBS_CONTRACT.selectFemaleEyeWear(rndCtx);

            // Add traits in rendering order (back to front)
            _addFemaleSkin(traits);
            _addFemaleEyes(traits);
            _addFemaleFace(traits);
            _addFemaleChain(traits);
            _addFemaleEarring(traits);
            _addFemaleMask(traits);
            _addFemaleScarf(traits);

            // Hat hair or regular hair
            if (TraitsUtils.femaleHasHeadwear(traits)) {
                _addFemaleHatHair(traits);
            } else {
                _addFemaleHair(traits);
            }
            
            _addFemaleHeadwear(traits);
            _addFemaleEyeWear(traits);
        }

        // === MOUTH (Shared) ===
        traits.mouth = MALE_PROBS_CONTRACT.selectMouth(traits, rndCtx);
        
        // Only render mouth if not wearing a mask
        if (!TraitsUtils.femaleHasMask(traits) && !TraitsUtils.maleHasMask(traits)) {
            _addMouth(traits);
        }

        return traits;
    }

    function _isPreRendered(uint specialIdx) internal pure returns (bool) {
        return (
            specialIdx == uint(E_Special_1s.Predator_Blue) ||
            specialIdx == uint(E_Special_1s.Predator_Green) ||
            specialIdx == uint(E_Special_1s.Predator_Red) ||
            specialIdx == uint(E_Special_1s.Santa_Claus) ||
            specialIdx == uint(E_Special_1s.Shadow_Ninja) ||
            specialIdx == uint(E_Special_1s.The_Devil) ||
            specialIdx == uint(E_Special_1s.The_Portrait)
        );
    }

    // ========================================================================
    // INTERNAL TRAIT FUNCTIONS
    // ========================================================================

    function _addSpecial(TraitsContext memory traits, uint specialIdx) internal pure {
        _addTraitToRender(traits, E_TraitsGroup.Special_1s_Group, uint8(specialIdx));
    }

    // === MALE TRAITS ===

    function _addMaleSkin(TraitsContext memory traits) internal pure {
        _addTraitToRender(traits, E_TraitsGroup.Male_Skin_Group, uint8(traits.maleSkin));
    } 
    
    function _addMaleEyes(TraitsContext memory traits) internal pure {
        if (traits.maleEyes == E_Male_Eyes.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Eyes_Group, uint8(traits.maleEyes));
    }

    function _addMaleFace(TraitsContext memory traits) internal pure {
        if (traits.maleFace == E_Male_Face.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Face_Group, uint8(traits.maleFace));
    }

    function _addMaleChain(TraitsContext memory traits) internal pure {
        if (traits.maleChain == E_Male_Chain.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Chain_Group, uint8(traits.maleChain));
    }

    function _addMaleScarf(TraitsContext memory traits) internal pure {
        if (traits.maleScarf == E_Male_Scarf.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Scarf_Group, uint8(traits.maleScarf));
    }

    function _addMaleEarring(TraitsContext memory traits) internal pure {
        if (traits.maleEarring == E_Male_Earring.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Earring_Group, uint8(traits.maleEarring));
    }

    function _addMaleFacialHair(TraitsContext memory traits) internal pure {
        if (traits.maleFacialHair == E_Male_Facial_Hair.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Facial_Hair_Group, uint8(traits.maleFacialHair));
    }

    function _addMaleMask(TraitsContext memory traits) internal pure {
        if (traits.maleMask == E_Male_Mask.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Mask_Group, uint8(traits.maleMask));
    }

    function _addMaleHair(TraitsContext memory traits) internal pure {
        if (traits.maleHair == E_Male_Hair.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Hair_Group, uint8(traits.maleHair));
    }

    function _addMaleHatHair(TraitsContext memory traits) internal pure {
        if (traits.maleHatHair == E_Male_Hat_Hair.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Hat_Hair_Group, uint8(traits.maleHatHair));
    }

    function _addMaleHeadwear(TraitsContext memory traits) internal pure {
        if (traits.maleHeadwear == E_Male_Headwear.None) return;

        _addTraitToRender(traits, E_TraitsGroup.Male_Headwear_Group, uint8(traits.maleHeadwear));
        
        // Add filler traits for certain skin types to cover headwear properly
        if (traits.maleSkin == E_Male_Skin.Robot) {
            _addFillerTrait(traits, E_TraitsGroup.Filler_Traits_Group, uint8(E_Filler_Traits.Male_Robot_Headwear_Cover));
        }

        if (traits.maleSkin == E_Male_Skin.Pumpkin) {
            _addFillerTrait(traits, E_TraitsGroup.Filler_Traits_Group, uint8(E_Filler_Traits.Male_Pumpkin_Headwear_Cover));
        }
    }

    function _addMaleEyeWear(TraitsContext memory traits) internal pure {
        if (traits.maleEyeWear == E_Male_Eye_Wear.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Eye_Wear_Group, uint8(traits.maleEyeWear));
    }

    // === FEMALE TRAITS ===

    function _addFemaleSkin(TraitsContext memory traits) internal pure {
        _addTraitToRender(traits, E_TraitsGroup.Female_Skin_Group, uint8(traits.femaleSkin));
    }

    function _addFemaleEyes(TraitsContext memory traits) internal pure {
        if (traits.femaleEyes == E_Female_Eyes.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Eyes_Group, uint8(traits.femaleEyes));
    }

    function _addFemaleFace(TraitsContext memory traits) internal pure {
        if (traits.femaleFace == E_Female_Face.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Face_Group, uint8(traits.femaleFace));
    }

    function _addFemaleChain(TraitsContext memory traits) internal pure {
        if (traits.femaleChain == E_Female_Chain.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Chain_Group, uint8(traits.femaleChain));
    }

    function _addFemaleScarf(TraitsContext memory traits) internal pure {
        if (traits.femaleScarf == E_Female_Scarf.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Scarf_Group, uint8(traits.femaleScarf));
    }

    function _addFemaleEarring(TraitsContext memory traits) internal pure {
        if (traits.femaleEarring == E_Female_Earring.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Earring_Group, uint8(traits.femaleEarring));
    }

    function _addFemaleMask(TraitsContext memory traits) internal pure {
        if (traits.femaleMask == E_Female_Mask.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Mask_Group, uint8(traits.femaleMask));
    }

    function _addFemaleHair(TraitsContext memory traits) internal pure {
        if (traits.femaleHair == E_Female_Hair.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Hair_Group, uint8(traits.femaleHair));
    }

    function _addFemaleHatHair(TraitsContext memory traits) internal pure {
        if (traits.femaleHatHair == E_Female_Hat_Hair.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Hat_Hair_Group, uint8(traits.femaleHatHair));
    }

    function _addFemaleHeadwear(TraitsContext memory traits) internal pure {
        if (traits.femaleHeadwear == E_Female_Headwear.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Headwear_Group, uint8(traits.femaleHeadwear));

        // Add filler trait for robot skin
        if (traits.femaleSkin == E_Female_Skin.Robot) {
            _addFillerTrait(traits, E_TraitsGroup.Filler_Traits_Group, uint8(E_Filler_Traits.Female_Robot_Headwear_Cover));
        }
    }

    function _addFemaleEyeWear(TraitsContext memory traits) internal pure {
        if (traits.femaleEyeWear == E_Female_Eye_Wear.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Eye_Wear_Group, uint8(traits.femaleEyeWear));
    }

    // === SHARED TRAITS ===

    function _addMouth(TraitsContext memory traits) internal pure {
        if (traits.mouth == E_Mouth.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Mouth_Group, uint8(traits.mouth));
    }

    function _addBackground(TraitsContext memory traits) internal pure {
        _addTraitToRender(traits, E_TraitsGroup.Background_Group, uint8(traits.background));
    }

    // ========================================================================
    // TRAIT RENDERING HELPERS
    // ========================================================================

    function _addTraitToRender(TraitsContext memory _ctx, E_TraitsGroup _traitGroup, uint8 _traitIndex) internal pure {
        // CRITICAL: Check if we're about to overflow the array
        if (_ctx.traitsToRenderLength >= _ctx.traitsToRender.length) {
            revert TraitsArrayOverflow(_ctx.traitsToRenderLength, uint8(_ctx.traitsToRender.length));
        }
        
        TraitToRender memory traitToRender;
        traitToRender.traitGroup = _traitGroup;
        traitToRender.traitIndex = _traitIndex;
        traitToRender.hasFiller = false;
        
        _ctx.traitsToRender[_ctx.traitsToRenderLength] = traitToRender;
        _ctx.traitsToRenderLength++;
    }

    function _addFillerTrait(TraitsContext memory _traits, E_TraitsGroup _traitGroup, uint8 _traitIndex) internal pure {
        // CRITICAL: Ensure we have at least one trait to add filler to
        if (_traits.traitsToRenderLength == 0) {
            revert("Cannot add filler: no traits exist");
        }
        
        FillerTrait memory filler;
        filler.traitGroup = _traitGroup;
        filler.traitIndex = _traitIndex;
        
        uint idx = _traits.traitsToRenderLength - 1;
        _traits.traitsToRender[idx].hasFiller = true;
        _traits.traitsToRender[idx].filler = filler;
    }
}
```

### RetroPunks.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { ISVGRenderer } from "./interfaces/ISVGRenderer.sol";
import { NUM_SPECIAL_1S, NUM_BACKGROUND, E_Special_1s, E_Background } from "./common/Enums.sol";
import { Utils } from "./libraries/Utils.sol";
import { FisherYatesShuffler } from "./interfaces/FisherYatesShuffler.sol";
import { ERC721SeaDropPausableAndQueryable } from "./seadrop/extensions/ERC721SeaDropPausableAndQueryable.sol";

/**
 * @author ECHO
 */

struct TokenMetadata {
    uint16 tokenIdSeed;
    uint16 backgroundIndex;
    string name;
}

event GlobalSeedRevealed(uint256 seed);
event ShufflerSeedRevealed(uint256 seed);
event BackgroundChanged(uint256 indexed tokenId, uint256 indexed backgroundIndex, address indexed owner);
event NameChanged(uint256 indexed tokenId, string indexed name, address indexed owner);

contract RetroPunks is ERC721SeaDropPausableAndQueryable, FisherYatesShuffler {
    uint public globalSeed;
    uint public shufflerSeed;

    ISVGRenderer public renderer;

    bool public mintIsClosed = false;

    // tokenId -> TokenMetadata
    mapping(uint => TokenMetadata) public globalTokenMetadata; 

    bytes32 public committedGlobalSeedHash;
    bytes32 public committedShufflerSeedHash;
    bool public globalSeedRevealed = false;
    bool public shufflerSeedRevealed = false;

    constructor(
        ISVGRenderer _rendererParam,
        bytes32 _committedGlobalSeedHashParam,
        bytes32 _committedShufflerSeedHashParam,
        uint _maxSupplyParam,
        address[] memory allowedSeaDropParam
    ) ERC721SeaDropPausableAndQueryable("RetroPunks", "RPNKS", allowedSeaDropParam) {
        committedGlobalSeedHash = _committedGlobalSeedHashParam;
        committedShufflerSeedHash = _committedShufflerSeedHashParam;
        renderer = _rendererParam;
        _maxSupply = _maxSupplyParam;
    }

    function setRenderer(ISVGRenderer _renderer) public onlyOwner {
        renderer = _renderer;

        // Emit an event with the update.
        if (totalSupply() != 0) {
            emit BatchMetadataUpdate(1, _nextTokenId() - 1);
        }
    }

    function setBackground(uint tokenId, uint backgroundIndex) public onlyTokenOwner(tokenId) notSpecial(tokenId) {
        require(
            backgroundIndex < NUM_BACKGROUND, 
            string.concat("Invalid background index, must be between 0 and ", Utils.toString(NUM_BACKGROUND - 1))
        );

        globalTokenMetadata[tokenId].backgroundIndex = uint16(backgroundIndex);
    
        emit BatchMetadataUpdate(tokenId, tokenId);
        emit BackgroundChanged(tokenId, backgroundIndex, msg.sender);
    }

    function setName(uint tokenId, string memory name) public onlyTokenOwner(tokenId) notSpecial(tokenId) {
        bytes memory b = bytes(name);
        require(b.length > 0 && b.length <= 32, "Name 1-32 chars");

        for (uint i = 0; i < b.length; ) {
            bytes1 c = b[i];
            require(
                (c >= 0x30 && c <= 0x39) || // 0-9
                (c >= 0x41 && c <= 0x5A) || // A-Z
                (c >= 0x61 && c <= 0x7A) || // a-z
                c == 0x20 || c == 0x21 || c == 0x2D || c == 0x2E || 
                c == 0x3F || c == 0x5F || c == 0x26 || c == 0x27,
                "Invalid character in name"
            );
            unchecked { ++i; }
        }

        globalTokenMetadata[tokenId].name = name;

        emit BatchMetadataUpdate(tokenId, tokenId);
        emit NameChanged(tokenId, name, msg.sender);
    }

    function resetName(uint256 tokenId) public onlyTokenOwner(tokenId) notSpecial(tokenId) {
        string memory defaultName = string.concat('RetroPunk #', Utils.toString(tokenId));
        globalTokenMetadata[tokenId].name = defaultName;

        emit BatchMetadataUpdate(tokenId, tokenId);
        emit NameChanged(tokenId, defaultName, msg.sender);
    }

    function getDefaultBackgroundIndex() public pure returns (uint16) {
        return uint16(uint(E_Background.Standard));
    }

    // Reveal globalSeed (call after mint closes)
    function revealGlobalSeed(uint256 _seed, uint256 _nonce) external onlyOwner {
        require(!globalSeedRevealed, "Global seed already revealed");
        require(keccak256(abi.encodePacked(_seed, _nonce)) == committedGlobalSeedHash, "Invalid reveal");
        
        globalSeed = _seed;
        globalSeedRevealed = true;
        
        emit GlobalSeedRevealed(_seed);
        if (totalSupply() != 0) {
            emit BatchMetadataUpdate(1, _nextTokenId() - 1);  // Refresh metadata if needed
        }
    }

    // Reveal shufflerSeed (call before mint starts)
    function revealShufflerSeed(uint256 _seed, uint256 _nonce) external onlyOwner {
        require(!shufflerSeedRevealed, "Shuffler seed already revealed");
        require(keccak256(abi.encodePacked(_seed, _nonce)) == committedShufflerSeedHash, "Invalid reveal");
        
        shufflerSeed = _seed;
        shufflerSeedRevealed = true;
        
        emit ShufflerSeedRevealed(_seed);
    }

    function _saveNewSeed(uint tokenId, uint remaining) internal {
        require(shufflerSeedRevealed, "Shuffler seed not revealed yet");  // Require shuffler seed reveal
        
        require(remaining > 0, "No remaining elements");

        uint seed = drawNextElement(shufflerSeed, msg.sender, remaining);
        
        globalTokenMetadata[tokenId] = TokenMetadata({
            tokenIdSeed: uint16(seed),
            backgroundIndex: getDefaultBackgroundIndex(),
            name: string.concat('RetroPunk #', string(Utils.toString(tokenId)))
        });
    }
    
    function getTokenMetadata(uint256 tokenId) public view returns (TokenMetadata memory) {
        require(_exists(tokenId), "Token does not exist");
        return globalTokenMetadata[tokenId];
    }

    function _getTokenMetadata(uint256 tokenId) internal view returns (TokenMetadata memory) {
        return globalTokenMetadata[tokenId];
    }

    modifier tokenExists(uint _tokenId) {
        require(_exists(_tokenId), "URI query for nonexistent token");
        _;
    }

    modifier onlyTokenOwner(uint _tokenId) {
        require(
            ownerOf(_tokenId) == msg.sender,
            "The caller is not the owner of the token"
        );
        _;
    }

    modifier notSpecial(uint256 tokenId) {
    uint16 tokenIdSeed = globalTokenMetadata[tokenId].tokenIdSeed;
    
    // Only block pre-rendered specials from customization
    // Layered specials (Pig, Slenderman, The Witch, The Wizard) can be customized
        if (tokenIdSeed < NUM_SPECIAL_1S) {
            uint specialIdx = tokenIdSeed;
            
            // Check if this is a pre-rendered special
            bool isPreRendered = (
                specialIdx == uint(E_Special_1s.Predator_Blue) ||
                specialIdx == uint(E_Special_1s.Predator_Green) ||
                specialIdx == uint(E_Special_1s.Predator_Red) ||
                specialIdx == uint(E_Special_1s.Santa_Claus) ||
                specialIdx == uint(E_Special_1s.Shadow_Ninja) ||
                specialIdx == uint(E_Special_1s.The_Devil) ||
                specialIdx == uint(E_Special_1s.The_Portrait)
            );
            
            if (isPreRendered) {
                revert("Pre-rendered specials cannot be customized");
            }
        }
        _;
    }

    function _addInternalMintMetadata(uint256 quantity) internal {
        require(shufflerSeedRevealed, "Shuffler seed not revealed yet");  // Block minting until revealed
        
        uint256 currentTokenId = totalSupply();

        for(uint256 tokenId = currentTokenId; tokenId < currentTokenId + quantity; tokenId++) {
            _saveNewSeed(tokenId + 1, _maxSupply - tokenId); // plus 1 because tokenIds start at 1
        }
    }

    function _checkMaxSupply(uint256 quantity) internal view {
        // Extra safety check to ensure the max supply is not exceeded.
        if (_totalMinted() + quantity > maxSupply()) {
            revert MintQuantityExceedsMaxSupply(
                _totalMinted() + quantity,
                maxSupply()
            );
        }    
    }

    function closeMint() public onlyOwner {
        mintIsClosed = true;
    }

    // override ERC721a mint to add metadata on every mint
    function _mint(address to, uint256 quantity) internal override {
        if (mintIsClosed) {
            revert("Mint is permanently closed");
        }
        
        _checkMaxSupply(quantity);
        _addInternalMintMetadata(quantity);
        super._mint(to, quantity);
        
        // Automatically close mint when max supply reached
        if (_totalMinted() >= maxSupply()) {
            mintIsClosed = true;
        }
    }

    uint public ownerMintsRemaining = 10;
    
    function ownerMint(address toAddress, uint256 quantity) public onlyOwner nonReentrant {
        require(ownerMintsRemaining >= quantity, "Not enough owner mints remaining");
        ownerMintsRemaining -= quantity;

        _checkMaxSupply(quantity);
        _safeMint(toAddress, quantity);
    }

    function tokenURI(uint256 tokenId) public tokenExists(tokenId) view override returns (string memory) {
        TokenMetadata memory tokenMetadata = _getTokenMetadata(tokenId);
        return renderDataUri(tokenId, tokenMetadata.tokenIdSeed, tokenMetadata.backgroundIndex, tokenMetadata.name, globalSeed);
    }

    /**
     * @notice Renders an NFT token as a complete data URI containing JSON metadata
     * @dev This function generates the complete metadata for an NFT including SVG image, 
     *      attributes, and optional HTML animation. The result is returned as a base64-encoded
     *      data URI that can be directly used as a token URI.
     * 
     * @param _tokenId The unique identifier of the NFT token as seen in the marketplace. Determined by the order of minting.
     * @param _tokenIdSeed The deterministic seed used to generate this token's traits, assigned at random at mint time.
     * @param _backgroundIndex The index of the background to use (0 to NUM_BACKGROUND-1)
     * @param _name The name of the NFT character
     * @param _globalSeed The global seed used for trait generation randomness / consistency
     * 
     * @return A base64-encoded data URI containing the complete JSON metadata with:
     *         - name: Token name with ID
     *         - description: Collection description
     *         - attributes: Trait attributes from the renderer
     *         - image: Base64-encoded SVG image
     *         - animation_url: Base64-encoded HTML animation (if available)
     */
    function renderDataUri(uint256 _tokenId, uint16 _tokenIdSeed, uint16 _backgroundIndex, string memory _name, uint256 _globalSeed) internal view returns (string memory) {
        string memory svg;
        string memory attributes;
        string memory html;

        (svg, attributes) = renderer.renderSVG(_tokenIdSeed, _backgroundIndex, _globalSeed);
        html = renderer.renderHTML(bytes(svg));

        string memory displayName = keccak256(bytes(_name)) == keccak256(bytes(string.concat("RetroPunk #", Utils.toString(_tokenId)))) 
            ? _name 
            : string.concat("RetroPunk #", Utils.toString(_tokenId), ": ", _name);

        string memory json = string.concat(
            '{"name":"', displayName,
            '","description":"RetroPunks",',
            attributes,',',
            '"image":"data:image/svg+xml;base64,',
            Utils.encodeBase64(bytes(svg)),
            '"');

        if (bytes(html).length > 0) {
            json = string.concat(json, ',"animation_url":"data:text/html;base64,', Utils.encodeBase64(bytes(html)), '"}');
        } else {
            json = string.concat(json, '}');
        }
        
        return string.concat(
            "data:application/json;base64,",
            Utils.encodeBase64(bytes(json))
        );
    }
}
```

### Assets.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { SSTORE2 } from "./libraries/SSTORE2.sol";
import { LibZip } from "./libraries/LibZip.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IAssets } from "./interfaces/IAssets.sol";

/**
 * @title Assets
 * @notice Efficient on-chain asset storage using SSTORE2 & LZ77 compression
 *
 * @author ECHO
 */

contract Assets is Ownable, IAssets {
    
    mapping(uint => address) private _assetsMap;
    
    event AssetAdded(uint indexed key, address indexed pointer, uint size);
    
    event AssetRemoved(uint indexed key);
    
    constructor() Ownable(msg.sender) {}

    function addAsset(uint key, bytes memory asset) external onlyOwner {
        require(asset.length > 0, "Empty asset");
        
        address pointer = SSTORE2.write(asset);
        _assetsMap[key] = pointer;
        
        emit AssetAdded(key, pointer, asset.length);
    }
    
    function addAssetsBatch(uint[] calldata keys, bytes[] calldata assets) external onlyOwner {
        require(keys.length == assets.length, "Length mismatch between keys an assets");
        
        for (uint i = 0; i < keys.length; i++) {
            require(assets[i].length > 0, "Empty asset");
            
            address pointer = SSTORE2.write(assets[i]);
            _assetsMap[keys[i]] = pointer;
            
            emit AssetAdded(keys[i], pointer, assets[i].length);
        }
    }

    function removeAsset(uint key) external onlyOwner {
        require(_assetsMap[key] != address(0), "Asset does not exist");
        
        delete _assetsMap[key];
        emit AssetRemoved(key);
    }
    
    function removeAssetsBatch(uint[] calldata keys) external onlyOwner {
        for (uint i = 0; i < keys.length; i++) {
            uint key = keys[i];

            delete _assetsMap[key];
            
            emit AssetRemoved(key);
        }
    }

    function loadAssetOriginal(uint key) external view returns (bytes memory) {
        return _loadAsset(key, false);
    }

    function loadAssetDecompressed(uint key) external view returns (bytes memory) {
        return _loadAsset(key, true);
    }

    function _loadAsset(uint key, bool decompress) internal view returns (bytes memory) {
        address pointer = _assetsMap[key];
        require(pointer != address(0), "Asset does not exist");

        bytes memory asset = SSTORE2.read(pointer);

        if (decompress) {
            asset = LibZip.flzDecompress(asset);
        }

        return asset;
    }
}
```

### libraries/TraitsLoader.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { IAssets } from '../interfaces/IAssets.sol';
import { TraitGroup, TraitInfo, CachedTraitGroups } from '../common/Structs.sol';

library TraitsLoader {
    function initCachedTraitGroups(uint _traitGroupsLength) public pure returns (CachedTraitGroups memory) {
        return CachedTraitGroups({ 
            traitGroups: new TraitGroup[](_traitGroupsLength), 
            traitGroupsLoaded: new bool[](_traitGroupsLength) 
        });
    }

    function loadAndCacheTraitGroup(IAssets _assetsContract, CachedTraitGroups memory _cachedTraitGroups, uint _traitGroupIndex) public view returns (TraitGroup memory) {
        if (_cachedTraitGroups.traitGroupsLoaded[_traitGroupIndex]) {
            return _cachedTraitGroups.traitGroups[_traitGroupIndex];
        }

        TraitGroup memory traitGroup;
        traitGroup.traitGroupIndex = _traitGroupIndex;
        
        bytes memory traitGroupData = _assetsContract.loadAssetDecompressed(_traitGroupIndex);
        
        uint index = 0;
        
        traitGroup.traitGroupName = _decodeTraitGroupName(traitGroupData, index);
        index += 1 + traitGroup.traitGroupName.length;
        
        (traitGroup.paletteRgba, index) = _decodeTraitGroupPalette(traitGroupData, index);

        traitGroup.paletteIndexByteSize = uint8(traitGroupData[index]);
        index++;

        uint8 traitCount = uint8(traitGroupData[index]);
        index++;

        traitGroup.traits = new TraitInfo[](traitCount);

        for (uint i = 0; i < traitCount; i++) {
            TraitInfo memory t;
            
            // Read 2 bytes Big Endian for pixel count
            uint16 traitPixelCount = uint16(uint8(traitGroupData[index])) << 8 | uint16(uint8(traitGroupData[index + 1]));
            
            t.x1 = uint8(traitGroupData[index + 2]);
            t.y1 = uint8(traitGroupData[index + 3]);
            t.x2 = uint8(traitGroupData[index + 4]);
            t.y2 = uint8(traitGroupData[index + 5]);
            t.layerType = uint8(traitGroupData[index + 6]);
            uint8 traitNameLength = uint8(traitGroupData[index + 7]);
            
            index += 8; 

            t.traitName = new bytes(traitNameLength);
            _memoryCopy(t.traitName, 0, traitGroupData, index, traitNameLength);
            index += traitNameLength;

            uint256 rleStartIndex = index;

            // --- BLOCK SCOPE START (To prevent Stack Too Deep) ---
            {
                uint256 pixelsTracked = 0;
                uint8 pSize = traitGroup.paletteIndexByteSize;
                
                if (traitPixelCount > 0) {
                    while (pixelsTracked < traitPixelCount) {
                        if (index >= traitGroupData.length) revert("RLE data truncated");
                        
                        uint8 runLength = uint8(traitGroupData[index++]);
                        
                        if (index + pSize > traitGroupData.length) revert("RLE palette index overflow");
                        index += pSize;

                        pixelsTracked += runLength;

                        if (pixelsTracked > traitPixelCount) revert("RLE exceeds trait pixel count");
                    }
                }
            }
            // --- BLOCK SCOPE END ---

            uint256 rleByteLength = index - rleStartIndex;
            t.traitData = new bytes(rleByteLength);
            _memoryCopy(t.traitData, 0, traitGroupData, rleStartIndex, rleByteLength);

            traitGroup.traits[i] = t;
        }
    
        _cachedTraitGroups.traitGroups[_traitGroupIndex] = traitGroup;
        _cachedTraitGroups.traitGroupsLoaded[_traitGroupIndex] = true;
        return traitGroup;
    }
    
    function _decodeTraitGroupName(bytes memory traitGroupData, uint startIndex) internal pure returns (bytes memory) {
        uint8 nameLength = uint8(traitGroupData[startIndex]);
        bytes memory name = new bytes(nameLength);
        _memoryCopy(name, 0, traitGroupData, startIndex + 1, nameLength);
        return name;
    }

    function _decodeTraitGroupPalette(bytes memory traitGroupData, uint startIndex) internal pure returns (uint32[] memory paletteRgba, uint nextIndex) {
        // Read 2 bytes Big Endian for palette size
        uint16 paletteSize = uint16(uint8(traitGroupData[startIndex])) << 8 | uint16(uint8(traitGroupData[startIndex + 1]));
        
        // If palette is empty (common for Background Images), return early
        if (paletteSize == 0) {
            return (new uint32[](0), startIndex + 2);
        }

        paletteRgba = new uint32[](paletteSize);
        uint cursor = startIndex + 2;
        
        // Safety check for data length
        require(traitGroupData.length >= cursor + (paletteSize * 4), "Insufficient palette data");
        
        for (uint i = 0; i < paletteSize; i++) {
            uint32 color;
            assembly {
                color := shr(224, mload(add(add(traitGroupData, 32), cursor)))
            }
            paletteRgba[i] = color;
            cursor += 4;
        }

        nextIndex = cursor;
    }

    function _memoryCopy(bytes memory dest, uint destOffset, bytes memory src, uint srcOffset, uint len) internal pure {
        assembly {
            let destPtr := add(add(dest, 32), destOffset)
            let srcPtr := add(add(src, 32), srcOffset)
            let endPtr := add(srcPtr, len)
            for {} lt(add(srcPtr, 31), endPtr) {} {
                mstore(destPtr, mload(srcPtr))
                srcPtr := add(srcPtr, 32)
                destPtr := add(destPtr, 32)
            }
            for {} lt(srcPtr, endPtr) {} {
                mstore8(destPtr, byte(0, mload(srcPtr)))
                srcPtr := add(srcPtr, 1)
                destPtr := add(destPtr, 1)
            }
        }
    }
}
```

### libraries/TraitsUtils.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { TraitsContext } from "../common/Structs.sol";
import { E_TraitsGroup, E_Sex, E_Male_Skin, E_Male_Eyes, E_Male_Face, E_Male_Chain, E_Male_Earring, E_Male_Scarf, E_Male_Facial_Hair, E_Male_Mask, E_Male_Hair, E_Male_Hat_Hair, E_Male_Headwear, E_Male_Eye_Wear, E_Female_Skin, E_Female_Eyes, E_Female_Face, E_Female_Chain, E_Female_Earring, E_Female_Scarf, E_Female_Mask, E_Female_Hair, E_Female_Hat_Hair, E_Female_Headwear, E_Female_Eye_Wear, E_Mouth } from "../common/Enums.sol";


/// @author ECHO


library TraitsUtils {

    function getBaseTraitValue(E_TraitsGroup group, string memory traitName, string[] memory colorSuffixes) internal pure returns (string memory) {
        if (
            group == E_TraitsGroup.Male_Skin_Group ||
            group == E_TraitsGroup.Female_Skin_Group ||
            group == E_TraitsGroup.Male_Facial_Hair_Group ||
            group == E_TraitsGroup.Male_Hair_Group ||
            group == E_TraitsGroup.Male_Hat_Hair_Group ||
            group == E_TraitsGroup.Male_Eye_Wear_Group ||
            group == E_TraitsGroup.Female_Hair_Group ||
            group == E_TraitsGroup.Female_Hat_Hair_Group ||
            group == E_TraitsGroup.Female_Eye_Wear_Group
        ) {
            return _removeColorSuffix(traitName, colorSuffixes);
        }
        return traitName;
    }

    function _removeColorSuffix(string memory traitName, string[] memory colorSuffixes) internal pure returns (string memory) {
        bytes memory traitNameBytes = bytes(traitName);

        for (uint256 suffixIndex = 0; suffixIndex < colorSuffixes.length; suffixIndex++) {
            bytes memory currentSuffixBytes = bytes(colorSuffixes[suffixIndex]);

            if (traitNameBytes.length > currentSuffixBytes.length) {
                bool suffixMatches = true;

                // Check if the ending of traitName matches the current suffix
                for (uint256 j = 0; j < currentSuffixBytes.length; j++) {
                    if (
                        traitNameBytes[traitNameBytes.length - currentSuffixBytes.length + j] !=
                        currentSuffixBytes[j]
                    ) {
                        suffixMatches = false;
                        break;
                    }
                }

                if (suffixMatches) {
                    // Slice off the suffix to create the base name
                    bytes memory baseNameBytes = new bytes(traitNameBytes.length - currentSuffixBytes.length);
                    for (uint256 i = 0; i < baseNameBytes.length; i++) {
                        baseNameBytes[i] = traitNameBytes[i];
                    }
                    return string(baseNameBytes);
                }
            }
        }

        return traitName;
    }

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
        return traits.maleFacialHair == E_Male_Facial_Hair.Anchor_Beard_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Beard_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Big_Beard_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Chin_Goatee_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Chinstrap_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Circle_Beard_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Dutch_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Fu_Manchu_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Full_Goatee_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Goatee_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Handlebar_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Horseshoe_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Long_Beard_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Luxurious_Beard_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Luxurious_Full_Goatee_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Mustache_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Muttonchops_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Pyramid_Mustache_Black ||
                   traits.maleFacialHair == E_Male_Facial_Hair.Walrus_Black;
    }
}
```

### libraries/PNG48x48.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Utils } from './Utils.sol';

struct BitMap {
    uint32[48][48] pixels;  // 0xRRGGBBAA 
}

library PNG48x48 {
    uint32 constant MAGIC_TRANSPARENT = 0x5f5d6eFF;
    
    function renderPixelToBitMap(BitMap memory bitMap, uint x, uint y, uint32 src) internal pure {
        uint32 srcA = src & 0xFF;
        if (srcA == 0) return;
        
        uint32 srcR = (src >> 24) & 0xFF;
        uint32 srcG = (src >> 16) & 0xFF;
        uint32 srcB = (src >> 8) & 0xFF;
        
        uint32 dst = bitMap.pixels[x][y];
        uint32 dstA = dst & 0xFF;
        
        if (dstA == 0) {
            bitMap.pixels[x][y] = src;
            return;
        }
        
        if (srcA == 255) {
            bitMap.pixels[x][y] = src;
            return;
        }
        
        uint32 dstR = (dst >> 24) & 0xFF;
        uint32 dstG = (dst >> 16) & 0xFF;
        uint32 dstB = (dst >> 8) & 0xFF;
        
        uint32 blended;
        assembly {
            let invA := sub(255, srcA)
            let outA := add(srcA, div(add(mul(dstA, invA), 127), 255))
            if iszero(outA) { outA := 1 }
            
            let outR := div(add(mul(srcR, srcA), div(mul(mul(dstR, dstA), invA), 255)), outA)
            let outG := div(add(mul(srcG, srcA), div(mul(mul(dstG, dstA), invA), 255)), outA)
            let outB := div(add(mul(srcB, srcA), div(mul(mul(dstB, dstA), invA), 255)), outA)
            
            blended := or(or(or(shl(24, outR), shl(16, outG)), shl(8, outB)), outA)
        }
        
        bitMap.pixels[x][y] = blended;
    }

    function toURLEncodedPNG(BitMap memory bmp) internal pure returns (string memory) {
        _applyChromaKey(bmp);
        bytes memory png = toPNG(bmp);
        return string.concat("data:image/png;base64,", Utils.encodeBase64(png));
    }

    function _applyChromaKey(BitMap memory bmp) private pure {
        unchecked {
            for (uint256 x = 0; x < 48; ++x) {
                for (uint256 y = 0; y < 48; ++y) {
                    if (bmp.pixels[x][y] == MAGIC_TRANSPARENT) {
                        bmp.pixels[x][y] = 0x00000000;
                    }
                }
            }
        }
    }

    bytes constant _PNG_SIG = hex"89504E470D0A1A0A";
    bytes constant _IHDR =
        hex"0000000D" hex"49484452"
        hex"00000030" hex"00000030"
        hex"08" hex"06" hex"00" hex"00" hex"00"
        hex"5702F987";

    bytes constant _IEND =
        hex"00000000" hex"49454E44" hex"AE426082";

    function toPNG(BitMap memory bmp) internal pure returns (bytes memory) {
        bytes memory raw = _packScanLines(bmp);
        bytes memory zLib = _makeZlibStored(raw);
        bytes memory idat = _makeChunk("IDAT", zLib);

        return bytes.concat(_PNG_SIG, _IHDR, idat, _IEND);
    }

    function _packScanLines(BitMap memory bmp) private pure returns (bytes memory raw) {
        raw = new bytes(48 * (1 + 48 * 4));
        uint256 k;
        
        unchecked {
            for (uint256 y; y < 48; ++y) {
                raw[k++] = 0x00;
                
                for (uint256 x; x < 48; ++x) {
                    uint32 p = bmp.pixels[x][y];
                    
                    raw[k++] = bytes1(uint8(p >> 24)); // R
                    raw[k++] = bytes1(uint8(p >> 16)); // G
                    raw[k++] = bytes1(uint8(p >> 8));  // B
                    raw[k++] = bytes1(uint8(p));       // A
                }
            }
        }
    }

    function _makeZlibStored(bytes memory raw) private pure returns (bytes memory z) {
        uint256 len = raw.length;
        
        bytes memory hdr = abi.encodePacked(
            bytes2(0x7801),
            bytes1(0x01),
            _u16le(uint16(len)),
            _u16le(~uint16(len))
        );
        
        uint32 adler = _adler32(raw);
        z = bytes.concat(hdr, raw, _u32be(adler));
    }

    function _makeChunk(bytes4 t, bytes memory d) private pure returns (bytes memory) {
        uint32 crc = _crc32(bytes.concat(t, d));
        return bytes.concat(_u32be(uint32(d.length)), t, d, _u32be(crc));
    }

    function _adler32(bytes memory buf) private pure returns (uint32) {
        uint256 a = 1;
        uint256 b = 0;
        
        unchecked {
            for (uint256 i; i < buf.length; ++i) {
                a += uint8(buf[i]);
                if (a >= 65521) a -= 65521;
                b += a;
                if (b >= 65521) b -= 65521;
            }
        }
        
        return uint32((b << 16) | a);
    }

    function _crc32(bytes memory data) private pure returns (uint32) {
        uint32 crc = 0xFFFFFFFF;
        
        unchecked {
            for (uint256 i; i < data.length; ++i) {
                crc ^= uint8(data[i]);
                for (uint8 k = 0; k < 8; ++k) {
                    crc = (crc >> 1) ^ ((crc & 1) == 1 ? 0xEDB88320 : 0);
                }
            }
        }
        
        return ~crc;
    }

    function _u32be(uint32 v) private pure returns (bytes4) {
        return bytes4(abi.encodePacked(
            bytes1(uint8(v >> 24)),
            bytes1(uint8(v >> 16)),
            bytes1(uint8(v >> 8)),
            bytes1(uint8(v))
        ));
    }

    function _u16le(uint16 v) private pure returns (bytes2) {
        return bytes2(abi.encodePacked(
            bytes1(uint8(v)),
            bytes1(uint8(v >> 8))
        ));
    }
}
```


### libraries/Division.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Utils } from "./Utils.sol";
import { LibString } from "./LibString.sol";

/**
 * @author EtoVass
 */

library Division {
    using Utils for int256;

    function divisionStr(uint8 decimalPlaces, int256 numerator, int256 denominator) pure internal returns(string memory) {
        string memory result;
        (, , result) = _division(decimalPlaces, numerator, denominator);

        bytes memory b = bytes(result);
        uint last = b.length - 1;

        // Loop backwards to find the last non-zero character
        while (last > 0 && b[last] == "0") {
            last--;
        }

        // If we stopped at the decimal point, trim that too
        if (b[last] == ".") {
            last--;
        }

        return LibString.slice(result, 0, last + 1);
    }

    function _division(uint8 decimalPlaces, int256 numerator, int256 denominator) pure internal returns(int256 quotient, int256 remainder, string memory result) {
        unchecked {
            int256 factor = int256(10 ** decimalPlaces); // 40
            quotient = numerator / denominator; // 4.1666
            bool rounding = 2 * ((numerator * factor) % denominator) >=
                denominator;
            remainder = ((numerator * factor) / denominator) % factor;
            if (rounding) {
                remainder += 1;
            }
            if (remainder < 0) remainder = -remainder;
            result = string(
                abi.encodePacked(
                    quotient.toString(),
                    ".",
                    _numToFixedLengthStr(decimalPlaces, remainder)
                )
            );
        }
    }

    function _numToFixedLengthStr(uint decimalPlaces, int256 num) pure internal returns(string memory result) {
        unchecked {
            if (num < 0) num = -num;

            bytes memory byteString;
            for (uint i = 0; i < decimalPlaces; i++) {
                uint digit = uint(num % 10);  // Always Positive
                byteString = abi.encodePacked(LibString.toString(digit), byteString);
                num = num / 10;
            }
            // Pad with leading zeros if the number was smaller than decimalPlaces
            while (byteString.length < decimalPlaces) {
                byteString = abi.encodePacked("0", byteString);
            }
            result = string(byteString);
        }
    }
}
```

### libraries/TraitsRenderer.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { TraitInfo, TraitGroup, CachedTraitGroups, TraitsContext } from '../common/Structs.sol';
import { E_TraitsGroup, E_Background_Type } from '../common/Enums.sol';
import { IAssets } from '../interfaces/IAssets.sol';
import { Utils } from './Utils.sol';
import { BitMap, PNG48x48 } from './PNG48x48.sol';
import { Division } from './Division.sol';

// CUSTOM ERRORS FOR DEBUGGING
error TraitIndexOutOfBounds(uint8 traitGroupIndex, uint8 traitIndex, uint256 maxIndex);
error PaletteIndexOutOfBounds(uint16 colorIdx, uint256 paletteSize);
error PixelCoordinatesOutOfBounds(uint8 x, uint8 y);

library TraitsRenderer {
    
    function renderGridToSvg(IAssets assetsContract, bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal view {
        Utils.concat(buffer, '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">');  
        Utils.concat(buffer, '<style>img{image-rendering:pixelated;}</style>');
        
        Utils.concat(buffer, '<g id="Background">');
        _renderBackground(assetsContract, buffer, cachedTraitGroups, traits);
        Utils.concat(buffer, '</g>');
    
        BitMap memory bitMap;

        for (uint i = 0; i < traits.traitsToRenderLength; i++) {
            if (traits.traitsToRender[i].traitGroup == E_TraitsGroup.Background_Group) continue;

            _renderTraitGroup(
                bitMap,
                cachedTraitGroups,
                uint8(traits.traitsToRender[i].traitGroup),
                traits.traitsToRender[i].traitIndex
            );

            if (traits.traitsToRender[i].hasFiller) {
                _renderTraitGroup(
                    bitMap,
                    cachedTraitGroups,
                    uint8(traits.traitsToRender[i].filler.traitGroup),
                    traits.traitsToRender[i].filler.traitIndex
                );
            }
        }

        string memory urlEncodedPNG = PNG48x48.toURLEncodedPNG(bitMap);
        Utils.concat(buffer, '<g id="GeneratedImage">');
        Utils.concat(buffer, '<foreignObject width="48" height="48"><img xmlns="http://www.w3.org/1999/xhtml" src="');
        Utils.concat(buffer, bytes(urlEncodedPNG));
        Utils.concat(buffer, '" width="100%" height="100%"/></foreignObject></g></svg>');
    }

    function _renderBackground(IAssets assetsContract, bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) private view {
        uint bgGroupIndex = uint8(E_TraitsGroup.Background_Group);
        TraitGroup memory bgTraitGroup = cachedTraitGroups.traitGroups[bgGroupIndex];
        
        // Inside _renderBackground in TraitsRenderer.sol
        if (uint8(traits.background) >= bgTraitGroup.traits.length) {
            // Check if length is 0 first to avoid the 0 - 1 underflow
            uint256 maxIdx = bgTraitGroup.traits.length > 0 ? bgTraitGroup.traits.length - 1 : 0;
            revert TraitIndexOutOfBounds(uint8(bgGroupIndex), uint8(traits.background), maxIdx);
        }
        
        TraitInfo memory trait = bgTraitGroup.traits[uint8(traits.background)];
        
        E_Background_Type bg = E_Background_Type(trait.layerType);

        if (bg == E_Background_Type.Solid) {
            uint16 paletteIdx = _decodePaletteIndex(trait.traitData, 0, bgTraitGroup.paletteIndexByteSize);
            
            if (paletteIdx >= bgTraitGroup.paletteRgba.length) {
                revert PaletteIndexOutOfBounds(paletteIdx, bgTraitGroup.paletteRgba.length);
            }
            
            uint32 color = bgTraitGroup.paletteRgba[paletteIdx];
            Utils.concat(buffer, '<rect width="48" height="48" fill="');
            _writeHexColor(buffer, color);
            Utils.concat(buffer, '"/>');
            return;
        }

        else if (bg == E_Background_Type.Background_Image) {
            bytes memory pngBase64 = assetsContract.loadAssetOriginal(1000 + uint(traits.background));
            Utils.concat(buffer, '<foreignObject width="48" height="48">');
            Utils.concat(buffer, '<img xmlns="http://www.w3.org/1999/xhtml" src="data:image/png;base64,');
            Utils.concatBase64(buffer, pngBase64);
            Utils.concat(buffer, '" width="100%" height="100%" /></foreignObject>');
            return;
        }

        else if (bg == E_Background_Type.Radial) {
            bytes memory gradientIdx = bytes(Utils.toString(uint(traits.background)));
            Utils.concat(buffer, '<defs><radialGradient id="bg-');
            Utils.concat(buffer, gradientIdx);
            Utils.concat(buffer, '">');
            _renderSmoothGradientStops(buffer, cachedTraitGroups, bgGroupIndex, trait);
            Utils.concat(buffer, '</radialGradient></defs><rect width="48" height="48" fill="url(#bg-');
            Utils.concat(buffer, gradientIdx);
            Utils.concat(buffer, ')"/>');
            return;
        }

        else {
            bytes memory gradientIdx = bytes(Utils.toString(uint(traits.background)));
            Utils.concat(buffer, '<defs><linearGradient id="bg-');
            Utils.concat(buffer, gradientIdx);
            Utils.concat(buffer, '" x1="');
            Utils.concat(buffer, bytes(Utils.toString(trait.x1)));
            Utils.concat(buffer, '" y1="');
            Utils.concat(buffer, bytes(Utils.toString(trait.y1)));
            Utils.concat(buffer, '" x2="');
            Utils.concat(buffer, bytes(Utils.toString(trait.x2)));
            Utils.concat(buffer, '" y2="');
            Utils.concat(buffer, bytes(Utils.toString(trait.y2)));
            Utils.concat(buffer, '">');

            bool isPixelated = (uint8(bg) % 2 == 0) && (uint8(bg) >= uint8(E_Background_Type.P_Vertical));
            
            if (isPixelated) {
                _renderPixelGradientStops(buffer, cachedTraitGroups, bgGroupIndex, trait);
            } else {
                _renderSmoothGradientStops(buffer, cachedTraitGroups, bgGroupIndex, trait);
            }
            
            Utils.concat(buffer, '</linearGradient></defs><rect width="48" height="48" fill="url(#bg-');
            Utils.concat(buffer, gradientIdx);
            Utils.concat(buffer, ')"/>');
        }
    }

    function _renderTraitGroup(BitMap memory bitMap, CachedTraitGroups memory cachedTraitGroups, uint8 traitGroupIndex, uint8 traitIndex) internal pure {
        TraitGroup memory group = cachedTraitGroups.traitGroups[traitGroupIndex];
        
        if (traitIndex >= group.traits.length) {
            revert TraitIndexOutOfBounds(traitGroupIndex, traitIndex, group.traits.length - 1);
        }
        
        TraitInfo memory trait = group.traits[traitIndex];
        
        bytes memory data = trait.traitData;
        uint256 ptr = 0;
        uint256 totalData = data.length;
        
        // Use uint instead of uint8 — safe for 48x48 and beyond
        uint currX = trait.x1;
        uint currY = trait.y1;

        while (ptr < totalData) {
            uint8 run = uint8(data[ptr++]);
            uint16 colorIdx;
            
            if (group.paletteIndexByteSize == 1) {
                colorIdx = uint16(uint8(data[ptr++]));
            } else {
                colorIdx = (uint16(uint8(data[ptr++])) << 8) | uint16(uint8(data[ptr++]));
            }

            if (colorIdx >= group.paletteRgba.length) {
                revert PaletteIndexOutOfBounds(colorIdx, group.paletteRgba.length);
            }

            uint32 rgba = group.paletteRgba[colorIdx];

            for (uint8 i = 0; i < run; i++) {
                // Now safe — no wrap-around possible
                if (currX >= 48 || currY >= 48) {
                    revert PixelCoordinatesOutOfBounds(uint8(currX), uint8(currY));
                }
                
                if (rgba & 0xFF > 0) {
                    PNG48x48.renderPixelToBitMap(bitMap, uint8(currX), uint8(currY), rgba);
                }
                
                currX++;
                if (currX > trait.x2) {
                    currX = trait.x1;
                    currY++;
                }
            }
        }
    }

    function _renderPixelGradientStops(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, uint traitGroupIndex, TraitInfo memory trait) private pure {
        TraitGroup memory traitGroup = cachedTraitGroups.traitGroups[traitGroupIndex];
        if (trait.traitData.length == 0) return;
        uint numStops = trait.traitData.length / traitGroup.paletteIndexByteSize;
        int scale = 1000000;
        
        for (uint i = 0; i < numStops; i++) {
            uint16 idx = _decodePaletteIndex(trait.traitData, i * traitGroup.paletteIndexByteSize, traitGroup.paletteIndexByteSize);
            
            // BOUNDS CHECK: Validate palette index
            if (idx >= traitGroup.paletteRgba.length) {
                revert PaletteIndexOutOfBounds(idx, traitGroup.paletteRgba.length);
            }
            
            uint32 color = traitGroup.paletteRgba[idx];
            
            bytes memory startOffset = bytes(Division.divisionStr(4, (int(i) * 100 * scale) / int(numStops), scale));
            bytes memory endOffset = bytes(Division.divisionStr(4, (int(i + 1) * 100 * scale) / int(numStops), scale));
            
            Utils.concat(buffer, '<stop offset="'); 
            Utils.concat(buffer, startOffset); 
            Utils.concat(buffer, '%" '); 
            _writeColorStop(buffer, color);
            Utils.concat(buffer, '/><stop offset="'); 
            Utils.concat(buffer, endOffset); 
            Utils.concat(buffer, '%" '); 
            _writeColorStop(buffer, color);
            Utils.concat(buffer, '/>');
        }
    }

    function _renderSmoothGradientStops(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, uint traitGroupIndex, TraitInfo memory trait) private pure {
        TraitGroup memory traitGroup = cachedTraitGroups.traitGroups[traitGroupIndex];
        if (trait.traitData.length == 0) return;
        uint numStops = trait.traitData.length / traitGroup.paletteIndexByteSize;
        
        if (numStops == 1) {
            uint16 idx = _decodePaletteIndex(trait.traitData, 0, traitGroup.paletteIndexByteSize);
            
            // BOUNDS CHECK
            if (idx >= traitGroup.paletteRgba.length) {
                revert PaletteIndexOutOfBounds(idx, traitGroup.paletteRgba.length);
            }
            
            uint32 color = traitGroup.paletteRgba[idx];
            Utils.concat(buffer, '<stop offset="0%" '); _writeColorStop(buffer, color); Utils.concat(buffer, '/>');
            Utils.concat(buffer, '<stop offset="100%" '); _writeColorStop(buffer, color); Utils.concat(buffer, '/>');
            return;
        }

        int scale = 1000000;
        for (uint i = 0; i < numStops; i++) {
            uint16 idx = _decodePaletteIndex(trait.traitData, i * traitGroup.paletteIndexByteSize, traitGroup.paletteIndexByteSize);
            
            // BOUNDS CHECK
            if (idx >= traitGroup.paletteRgba.length) {
                revert PaletteIndexOutOfBounds(idx, traitGroup.paletteRgba.length);
            }
            
            uint32 color = traitGroup.paletteRgba[idx];

            bytes memory offset = bytes(Division.divisionStr(4, (int(i) * 100 * scale) / int(numStops - 1), scale));
            
            Utils.concat(buffer, '<stop offset="');
            Utils.concat(buffer, offset);
            Utils.concat(buffer, '%" ');
            _writeColorStop(buffer, color);
            Utils.concat(buffer, '/>');
        }
    }

    function _decodePaletteIndex(bytes memory data, uint offset, uint8 byteSize) internal pure returns (uint16) {
        if (byteSize == 1) return uint16(uint8(data[offset]));
        // Big-endian (high byte first)
        return (uint16(uint8(data[offset])) << 8) | uint16(uint8(data[offset + 1]));
    }

    function _writeColorStop(bytes memory buffer, uint32 packedRgba) internal pure {
        uint256 r = (packedRgba >> 24) & 0xFF;
        uint256 g = (packedRgba >> 16) & 0xFF;
        uint256 b = (packedRgba >> 8) & 0xFF;
        uint256 a = packedRgba & 0xFF;

        Utils.concat(buffer, 'stop-color="rgb(');
        Utils.concat(buffer, bytes(Utils.toString(r)));
        Utils.concat(buffer, ',');
        Utils.concat(buffer, bytes(Utils.toString(g)));
        Utils.concat(buffer, ',');
        Utils.concat(buffer, bytes(Utils.toString(b)));
        Utils.concat(buffer, ')"');
        
        if (a < 255) {
            Utils.concat(buffer, ' stop-opacity="');
            Utils.concat(buffer, bytes(Division.divisionStr(2, int(a), 255)));
            Utils.concat(buffer, '"');
        }
    }

    function _writeHexColor(bytes memory buffer, uint32 rgba) private pure {
        bytes16 hexChars = "0123456789abcdef";

        uint256 r = (rgba >> 24) & 0xFF;
        uint256 g = (rgba >> 16) & 0xFF;
        uint256 b = (rgba >> 8) & 0xFF;
        uint256 a = rgba & 0xFF;

        Utils.concat(buffer, "#");
        Utils.concat(buffer, abi.encodePacked(
            hexChars[r >> 4], hexChars[r & 0xf],
            hexChars[g >> 4], hexChars[g & 0xf],
            hexChars[b >> 4], hexChars[b & 0xf],
            hexChars[a >> 4], hexChars[a & 0xf]
        ));
    }
}
```

### libraries/Random.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title RandomCtx
 * @notice Context for deterministic random number generation
 */
struct RandomCtx {
    uint seed;
    uint counter;
}

/**
 * @title Random
 * @notice Gas-optimized deterministic random number generation
 * @dev Uses keccak256 for cryptographically secure randomness
 */
library Random {

    /**
     * @notice Initialize random context
     * @param tokenIdSeed Unique seed per token
     * @param globalSeed Collection-wide seed
     * @return Initialized random context
     */
    function initCtx(uint16 tokenIdSeed, uint globalSeed) internal pure returns (RandomCtx memory) {
        uint startingSeed = uint(keccak256(abi.encodePacked(tokenIdSeed, globalSeed)));
        
        return RandomCtx({
            seed: startingSeed,
            counter: tokenIdSeed
        });
    }

    /**
     * @notice Generate next random number
     * @dev Mutates context for next call
     * @param ctx Random context (modified in place)
     * @return Random uint
     */
    function rand(RandomCtx memory ctx) internal pure returns (uint) {
        unchecked {
            ctx.counter++;
            ctx.seed = uint(keccak256(abi.encodePacked(ctx.seed, ctx.counter)));
            return ctx.seed;
        }
    }

    /**
     * @notice Generate random number in range [from, toInclusive]
     * @param ctx Random context
     * @param from Minimum value (inclusive)
     * @param toInclusive Maximum value (inclusive)
     * @return Random number in range
     */
    function randRange(RandomCtx memory ctx, uint from, uint toInclusive) internal pure returns (uint) {
        unchecked {
            uint rangeSize = toInclusive - from + 1;
            return from + (rand(ctx) % rangeSize);
        }
    }

    /**
     * @notice Generate random boolean with probability
     * @param ctx Random context
     * @param probability Probability out of 10000 (e.g., 6600 = 66%)
     * @return True if random value <= probability
     */
    function randBool(RandomCtx memory ctx, uint16 probability) internal pure returns (bool) {
        unchecked {
            return randRange(ctx, 1, 10000) <= probability;
        }
    }

    /**
     * @notice Generate random uint with max value
     * @param ctx Random context
     * @param max Maximum value (exclusive)
     * @return Random uint in [0, max)
     */
    function nextUint(RandomCtx memory ctx, uint max) internal pure returns (uint) {
        unchecked {
            ctx.counter++;
            uint newSeed = uint(keccak256(abi.encodePacked(ctx.seed, ctx.counter)));
            ctx.seed = newSeed;
            return newSeed % max;
        }
    }

    /**
     * @notice Select index based on weighted probabilities
     * @param probs Array of probability weights
     * @param r Random value to use for selection
     * @return Selected index
     */
    function weightedSelect(uint16[] memory probs, uint r) internal pure returns (uint) {
        uint sum = 0;
        unchecked {
            for (uint i = 0; i < probs.length; i++) {
                sum += probs[i];
                if (r < sum) {
                    return i;
                }
            }
        }
        revert("Selection failed");
    }

    /**
     * @notice Select random trait using weighted probabilities
     * @param rndCtx Random context
     * @param probs Array of probability weights (sum should equal total)
     * @return Selected trait index
     */
    function selectRandomTrait(RandomCtx memory rndCtx, uint16[] memory probs) internal pure returns (uint) {
        uint total = 0;
        unchecked {
            for (uint i = 0; i < probs.length; i++) {
                total += probs[i];
            }
        }

        uint r = nextUint(rndCtx, total);
        return weightedSelect(probs, r);
    }
}
```

### libraries/Utils.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { DynamicBuffer } from './DynamicBuffer.sol';

library Utils {

    function toString(bytes32 _bytes32) internal pure returns (string memory) {
        return string(toByteArray(_bytes32));
    }

    function toString(uint value) internal pure returns (string memory str) {
        /// @solidity memory-safe-assembly
        assembly {
            // The maximum value of a uint contains 78 digits (1 byte per digit), but
            // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
            // We will need 1 word for the trailing zeros padding, 1 word for the length,
            // and 3 words for a maximum of 78 digits.
            str := add(mload(0x40), 0x80)
            // Update the free memory pointer to allocate.
            mstore(0x40, add(str, 0x20))
            // Zeroize the slot after the string.
            mstore(str, 0)

            // Cache the end of the memory to calculate the length later.
            let end := str

            let w := not(0) // Tsk.
            // We write the string from rightmost digit to leftmost digit.
            // The following is essentially a do-while loop that also handles the zero case.
            for { let temp := value } 1 {} {
                str := add(str, w) // `sub(str, 1)`.
                // Write the character to the pointer.
                // The ASCII index of the '0' character is 48.
                mstore8(str, add(48, mod(temp, 10)))
                // Keep dividing `temp` until zero.
                temp := div(temp, 10)
                if iszero(temp) { break }
            }

            let length := sub(end, str)
            // Move the pointer 32 bytes leftwards to make room for the length.
            str := sub(str, 0x20)
            // Store the length.
            mstore(str, length)
        }
    }

    function toString(int256 value) internal pure returns (string memory str) {
        if (value >= 0) {
            return toString(uint(value));
        }
        unchecked {
            str = toString(uint(-value));
        }
        /// @solidity memory-safe-assembly
        assembly {
            // We still have some spare memory space on the left,
            // as we have allocated 3 words (96 bytes) for up to 78 digits.
            let length := mload(str) // Load the string length.
            mstore(str, 0x2d) // Store the '-' character.
            str := sub(str, 1) // Move back the string pointer by a byte.
            mstore(str, add(length, 1)) // Update the string length.
        }
    }

    function toByteArray(bytes32 _bytes32) internal pure returns (bytes memory) {
        uint8 i = 0;
        while(i < 32 && _bytes32[i] != 0) {
            i++;
        }
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return bytesArray;
    }

    function concat(bytes memory buffer, bytes memory c1) internal pure {
        DynamicBuffer.appendSafe(buffer, c1);
    }
    
    function concatBase64(bytes memory buffer, bytes memory c1) internal pure {
        DynamicBuffer.appendSafeBase64(buffer, c1, false, false);
    }

    function encodeBase64(bytes memory data) internal pure returns (string memory result) {
        result = _encodeBase64(data, false, false);
    }

    function _encodeBase64(bytes memory data, bool fileSafe, bool noPadding) internal pure returns (string memory result) {
        /// @solidity memory-safe-assembly
        assembly {
            let dataLength := mload(data)

            if dataLength {
                // Multiply by 4/3 rounded up.
                // The `shl(2, ...)` is equivalent to multiplying by 4.
                let encodedLength := shl(2, div(add(dataLength, 2), 3))

                // Set `result` to point to the start of the free memory.
                result := mload(0x40)

                // Store the table into the scratch space.
                // Offsetted by -1 byte so that the `mload` will load the character.
                // We will rewrite the free memory pointer at `0x40` later with
                // the allocated size.
                // The magic constant 0x0670 will turn "-_" into "+/".
                mstore(0x1f, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdef")
                mstore(0x3f, xor("ghijklmnopqrstuvwxyz0123456789-_", mul(iszero(fileSafe), 0x0670)))

                // Skip the first slot, which stores the length.
                let ptr := add(result, 0x20)
                let end := add(ptr, encodedLength)

                // Run over the input, 3 bytes at a time.
                for {} 1 {} {
                    data := add(data, 3) // Advance 3 bytes.
                    let input := mload(data)

                    // Write 4 bytes. Optimized for fewer stack operations.
                    mstore8(0, mload(and(shr(18, input), 0x3F)))
                    mstore8(1, mload(and(shr(12, input), 0x3F)))
                    mstore8(2, mload(and(shr(6, input), 0x3F)))
                    mstore8(3, mload(and(input, 0x3F)))
                    mstore(ptr, mload(0x00))

                    ptr := add(ptr, 4) // Advance 4 bytes.
                    if iszero(lt(ptr, end)) { break }
                }
                mstore(0x40, add(end, 0x20)) // Allocate the memory.
                // Equivalent to `o = [0, 2, 1][dataLength % 3]`.
                let o := div(2, mod(dataLength, 3))
                // Offset `ptr` and pad with '='. We can simply write over the end.
                mstore(sub(ptr, o), shl(240, 0x3d3d))
                // Set `o` to zero if there is padding.
                o := mul(iszero(iszero(noPadding)), o)
                mstore(sub(ptr, o), 0) // Zeroize the slot after the string.
                mstore(result, sub(encodedLength, o)) // Store the length.
            }
        }
    }
}
```

### common/Structs.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { E_Sex, E_Background, E_Male_Skin, E_Male_Eyes, E_Male_Face, E_Male_Chain, E_Male_Earring, E_Male_Scarf, E_Male_Facial_Hair, E_Male_Mask, E_Male_Hair, E_Male_Hat_Hair, E_Male_Headwear, E_Male_Eye_Wear, E_Female_Skin, E_Female_Eyes, E_Female_Face, E_Female_Chain, E_Female_Earring, E_Female_Scarf, E_Female_Mask, E_Female_Hair, E_Female_Hat_Hair, E_Female_Headwear, E_Female_Eye_Wear, E_Mouth, E_TraitsGroup } from "./Enums.sol";

/**
 * @author ECHO
 */

struct TraitsContext {
    
    TraitToRender[] traitsToRender;
    uint8 traitsToRenderLength;

    uint16 tokenIdSeed;
    uint256 globalSeed;
    
    uint16 specialId;

    uint32 birthday;

    E_Sex sex;
    
    E_Background background;

    E_Male_Skin maleSkin;
    E_Male_Eyes maleEyes;
    E_Male_Face maleFace;
    E_Male_Chain maleChain;
    E_Male_Earring maleEarring;
    E_Male_Scarf maleScarf;
    E_Male_Facial_Hair maleFacialHair;
    E_Male_Mask maleMask;
    E_Male_Hair maleHair;
    E_Male_Hat_Hair maleHatHair;
    E_Male_Headwear maleHeadwear;
    E_Male_Eye_Wear maleEyeWear;

    E_Female_Skin femaleSkin;
    E_Female_Eyes femaleEyes;
    E_Female_Face femaleFace;
    E_Female_Chain femaleChain;
    E_Female_Earring femaleEarring;
    E_Female_Scarf femaleScarf;
    E_Female_Mask femaleMask;
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
    uint traitGroupIndex;
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
```

### common/Enums.sol
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

uint8 constant NUM_BACKGROUND = 6;
uint8 constant NUM_SPECIAL_1S = 16;
uint8 constant NUM_TRAIT_GROUPS = 27;

// S = Gradient Smooth
// P = Gradient Pixelated
enum E_Background_Type {
    None, // not a background
    Background_Image,
    Solid,

    S_Vertical,
    P_Vertical,
    S_Vertical_Inverse,
    P_Vertical_Inverse,

    S_Horizontal,
    P_Horizontal,
    S_Horizontal_Inverse,
    P_Horizontal_Inverse,

    S_Diagonal,
    P_Diagonal,
    S_Diagonal_Inverse,
    P_Diagonal_Inverse,

    S_Reverse_Diagonal,
    P_Reverse_Diagonal,
    S_Reverse_Diagonal_Inverse,
    P_Reverse_Diagonal_Inverse,

    Radial
}

enum E_Sex {
    Male,
    Female
}

enum E_TraitsGroup {
    Special_1s_Group,
    Background_Group,
    Male_Skin_Group,
    Male_Eyes_Group,
    Male_Face_Group,
    Male_Chain_Group,
    Male_Earring_Group,
    Male_Facial_Hair_Group,
    Male_Mask_Group,
    Male_Scarf_Group,
    Male_Hair_Group,
    Male_Hat_Hair_Group,
    Male_Headwear_Group,
    Male_Eye_Wear_Group,
    Female_Skin_Group,
    Female_Eyes_Group,
    Female_Face_Group,
    Female_Chain_Group,
    Female_Earring_Group,
    Female_Mask_Group,
    Female_Scarf_Group,
    Female_Hair_Group,
    Female_Hat_Hair_Group,
    Female_Headwear_Group,
    Female_Eye_Wear_Group,
    Mouth_Group,
    Filler_Traits_Group
}

enum E_Special_1s {
    Ancient_Mummy,
    CyberApe,
    Old_Skeleton,
    Pig,
    Predator_Blue,
    Predator_Green,
    Predator_Red,
    Santa_Claus,
    Shadow_Ninja,
    Slenderman,
    The_Clown,
    The_Devil,
    The_Pirate,
    The_Portrait,
    The_Witch,
    The_Wizard
}

enum E_Background {
    Rainbow,
    Standard,
    Smooth_Vertical,
    Smooth_Horizontal,
    Diagonal_Gradient
}

enum E_Male_Skin {
    None,
    Alien,
    Ape,
    Demon,
    Ghost,
    Glitch,
    Goblin,
    Human_1,
    Human_10,
    Human_11,
    Human_12,
    Human_2,
    Human_3,
    Human_4,
    Human_5,
    Human_6,
    Human_7,
    Human_8,
    Human_9,
    Invisible,
    Mummy,
    Pumpkin,
    Robot,
    Skeleton,
    Snowman,
    Vampire,
    Yeti,
    Zombie_Ape,
    Zombie
}

enum E_Male_Eyes {
    None,
    Blind,
    Closed,
    Clown_Eyes_Blue,
    Clown_Eyes_Green,
    Clown_Eyes_Orange,
    Clown_Eyes_Pink,
    Clown_Eyes_Purple,
    Clown_Eyes_Red,
    Clown_Eyes_Sky_Blue,
    Clown_Eyes_Turquoise,
    Clown_Eyes_Yellow,
    Confused,
    Ghost_Left,
    Ghost_Right,
    Left,
    Possessed_Left,
    Possessed_Right,
    Right,
    Tired_Confused,
    Tired_Left,
    Tired_Right,
    Wink
}

enum E_Male_Face {
    None,
    Armor_Tattoo,
    Axe_Tattoo,
    Bandage,
    Bionic_Eyes,
    Cross_Tattoo,
    Cybereye_Left,
    Cybereye_Right,
    Cyberface,
    Gun_Tattoo,
    Heart_Tattoo,
    Jet_Tattoo,
    Left_Bionic_Eye,
    Mole,
    Nosebleed,
    Right_Bionic_Eye,
    Shotgun_Tattoo,
    Sword_Tattoo,
    War_Paint,
    X_Tattoo
}

enum E_Male_Chain {
    None,
    Chain_Amethyst,
    Chain_Diamond,
    Chain_Emerald,
    Chain_Gold,
    Chain_Onyx,
    Chain_Pink_Diamond,
    Chain_Ruby,
    Chain_Sapphire
}

enum E_Male_Earring {
    None,
    Earring_Amethyst,
    Earring_Diamond,
    Earring_Emerald,
    Earring_Gold,
    Earring_Onyx,
    Earring_Pink_Diamond,
    Earring_Ruby,
    Earring_Sapphire
}

enum E_Male_Scarf {
    None,
    Blue_Scarf,
    Green_Scarf,
    Red_Scarf
}

enum E_Male_Facial_Hair {
    None,
    Anchor_Beard_Black,
    Anchor_Beard_Brown,
    Anchor_Beard_Ginger,
    Anchor_Beard_White,
    Beard_Black,
    Beard_Brown,
    Beard_Dark,
    Beard_Ginger,
    Beard_Light,
    Beard_Shadow,
    Beard_White,
    Beard,
    Big_Beard_Black,
    Big_Beard_Brown,
    Big_Beard_Ginger,
    Big_Beard_White,
    Chin_Goatee_Black,
    Chin_Goatee_Brown,
    Chin_Goatee_Ginger,
    Chin_Goatee_White,
    Chinstrap_Black,
    Chinstrap_Brown,
    Chinstrap_Ginger,
    Chinstrap_Shadow,
    Chinstrap_White,
    Circle_Beard_Black,
    Circle_Beard_Brown,
    Circle_Beard_Ginger,
    Circle_Beard_Shadow,
    Circle_Beard_White,
    Dutch_Black,
    Dutch_Brown,
    Dutch_Ginger,
    Dutch_White,
    Fu_Manchu_Black,
    Fu_Manchu_Brown,
    Fu_Manchu_Ginger,
    Fu_Manchu_White,
    Full_Goatee_Black,
    Full_Goatee_Brown,
    Full_Goatee_Ginger,
    Full_Goatee_White,
    Goatee_Black,
    Goatee_Brown,
    Goatee_Ginger,
    Goatee_Shadow,
    Goatee_White,
    Handlebar_Black,
    Handlebar_Brown,
    Handlebar_Ginger,
    Handlebar_White,
    Horseshoe_Black,
    Horseshoe_Brown,
    Horseshoe_Ginger,
    Horseshoe_Shadow,
    Horseshoe_White,
    Long_Beard_Black,
    Long_Beard_Brown,
    Long_Beard_Ginger,
    Long_Beard_White,
    Luxurious_Beard_Black,
    Luxurious_Beard_Brown,
    Luxurious_Beard_Ginger,
    Luxurious_Beard_White,
    Luxurious_Full_Goatee_Black,
    Luxurious_Full_Goatee_Brown,
    Luxurious_Full_Goatee_Ginger,
    Luxurious_Full_Goatee_White,
    Mustache_Black,
    Mustache_Brown,
    Mustache_Ginger,
    Mustache_Shadow,
    Mustache_White,
    Muttonchops_Black,
    Muttonchops_Brown,
    Muttonchops_Ginger,
    Muttonchops_Shadow,
    Muttonchops_White,
    Pyramid_Mustache_Black,
    Pyramid_Mustache_Brown,
    Pyramid_Mustache_Ginger,
    Pyramid_Mustache_White,
    Walrus_Black,
    Walrus_Brown,
    Walrus_Ginger,
    Walrus_Shadow,
    Walrus_White
}

enum E_Male_Mask {
    None,
    Bandana_Mask_Blue,
    Bandana_Mask_Green,
    Bandana_Mask_Purple,
    Bandana_Mask_Red,
    Gas_Mask,
    Medical_Mask_Blue,
    Medical_Mask_Green,
    Medical_Mask_Orange,
    Medical_Mask_Pink,
    Medical_Mask_Purple,
    Medical_Mask_Red,
    Medical_Mask_Turquoise,
    Medical_Mask_Yellow,
    Medical_Mask,
    Metal_Mask,
    Military_Gas_Mask,
    Ninja_Mask_Black,
    Ninja_Mask_Blue,
    Ninja_Mask_Brown,
    Ninja_Mask_Purple,
    Ninja_Mask_Red
}

enum E_Male_Hair {
    None,
    Afro_Black,
    Afro_Blonde,
    Afro_Blue,
    Afro_Brown,
    Afro_Ginger,
    Afro_Green,
    Afro_Orange,
    Afro_Pink,
    Afro_Purple,
    Afro_Red,
    Afro_Turquoise,
    Afro_White,
    Bowl_Cut_Black,
    Bowl_Cut_Blonde,
    Bowl_Cut_Brown,
    Bowl_Cut_Ginger,
    Bowl_Cut_White,
    Buzz_Cut_Black,
    Buzz_Cut_Blonde,
    Buzz_Cut_Brown,
    Buzz_Cut_Fade,
    Buzz_Cut_Ginger,
    Buzz_Cut,
    Clown_Hair_Blue,
    Clown_Hair_Green,
    Clown_Hair_Orange,
    Clown_Hair_Pink,
    Clown_Hair_Purple,
    Clown_Hair_Red,
    Clown_Hair_Turquoise,
    Crazy_Hair_Black,
    Crazy_Hair_Blonde,
    Crazy_Hair_Blue,
    Crazy_Hair_Brown,
    Crazy_Hair_Ginger,
    Crazy_Hair_Green,
    Crazy_Hair_Orange,
    Crazy_Hair_Pink,
    Crazy_Hair_Purple,
    Crazy_Hair_Red,
    Crazy_Hair_Turquoise,
    Crazy_Hair_White,
    Curled_Mohawk_Blue,
    Curled_Mohawk_Green,
    Curled_Mohawk_Orange,
    Curled_Mohawk_Pink,
    Curled_Mohawk_Purple,
    Curled_Mohawk_Red,
    Curly_Hair_Black,
    Curly_Hair_Blonde,
    Curly_Hair_Blue,
    Curly_Hair_Brown,
    Curly_Hair_Ginger,
    Curly_Hair_Green,
    Curly_Hair_Orange,
    Curly_Hair_Pink,
    Curly_Hair_Purple,
    Curly_Hair_Red,
    Curly_Hair_Turquoise,
    Curly_Hair_White,
    Curtains_Black,
    Curtains_Blonde,
    Curtains_Brown,
    Curtains_Ginger,
    Curtains_White,
    Electric_Hair_Black,
    Electric_Hair_Blonde,
    Electric_Hair_Blue,
    Electric_Hair_Brown,
    Electric_Hair_Ginger,
    Electric_Hair_Green,
    Electric_Hair_Orange,
    Electric_Hair_Pink,
    Electric_Hair_Purple,
    Electric_Hair_Red,
    Electric_Hair_Turquoise,
    Electric_Hair_White,
    Flat_Top_Black,
    Flat_Top_Blonde,
    Flat_Top_Brown,
    Flat_Top_Ginger,
    Flat_Top_White,
    Funky_Hair_Black,
    Funky_Hair_Blonde,
    Funky_Hair_Blue,
    Funky_Hair_Brown,
    Funky_Hair_Ginger,
    Funky_Hair_Green,
    Funky_Hair_Orange,
    Funky_Hair_Pink,
    Funky_Hair_Purple,
    Funky_Hair_Red,
    Funky_Hair_Turquoise,
    Funky_Hair_White,
    Man_Bun_Black,
    Man_Bun_Blonde,
    Man_Bun_Brown,
    Man_Bun_Ginger,
    Man_Bun_White,
    Messy_Hair_Black,
    Messy_Hair_Blonde,
    Messy_Hair_Blue,
    Messy_Hair_Brown,
    Messy_Hair_Ginger,
    Messy_Hair_Green,
    Messy_Hair_Orange,
    Messy_Hair_Pink,
    Messy_Hair_Purple,
    Messy_Hair_Red,
    Messy_Hair_Turquoise,
    Messy_Hair_White,
    Mohawk_Black,
    Mohawk_Blonde,
    Mohawk_Blue,
    Mohawk_Brown,
    Mohawk_Ginger,
    Mohawk_Green,
    Mohawk_Neon_Blue,
    Mohawk_Neon_Green,
    Mohawk_Neon_Purple,
    Mohawk_Neon_Red,
    Mohawk_Orange,
    Mohawk_Pink,
    Mohawk_Purple,
    Mohawk_Red,
    Mohawk_Turquoise,
    Mohawk_White,
    Old_Hair_Black,
    Old_Hair_Grey,
    Old_Hair_White,
    Quiff_Black,
    Quiff_Blonde,
    Quiff_Brown,
    Quiff_Ginger,
    Quiff_White,
    Sharp_Mohawk_Black,
    Sharp_Mohawk_Blonde,
    Sharp_Mohawk_Blue,
    Sharp_Mohawk_Brown,
    Sharp_Mohawk_Ginger,
    Sharp_Mohawk_Green,
    Sharp_Mohawk_Neon_Blue,
    Sharp_Mohawk_Neon_Green,
    Sharp_Mohawk_Neon_Purple,
    Sharp_Mohawk_Neon_Red,
    Sharp_Mohawk_Orange,
    Sharp_Mohawk_Pink,
    Sharp_Mohawk_Purple,
    Sharp_Mohawk_Red,
    Sharp_Mohawk_Turquoise,
    Sharp_Mohawk_White,
    Shaved_Head,
    Short_Mohawk_Black,
    Short_Mohawk_Blonde,
    Short_Mohawk_Blue,
    Short_Mohawk_Brown,
    Short_Mohawk_Ginger,
    Short_Mohawk_Green,
    Short_Mohawk_Orange,
    Short_Mohawk_Pink,
    Short_Mohawk_Purple,
    Short_Mohawk_Red,
    Short_Mohawk_Turquoise,
    Short_Mohawk_White,
    Side_Line,
    Slickback_Hair_Black,
    Slickback_Hair_Blonde,
    Slickback_Hair_Brown,
    Slickback_Hair_Ginger,
    Slickback_Hair_White,
    Spikey_Hair_Black,
    Spikey_Hair_Blonde,
    Spikey_Hair_Blue,
    Spikey_Hair_Brown,
    Spikey_Hair_Ginger,
    Spikey_Hair_Green,
    Spikey_Hair_Orange,
    Spikey_Hair_Pink,
    Spikey_Hair_Purple,
    Spikey_Hair_Red,
    Spikey_Hair_Turquoise,
    Spikey_Hair_White,
    Superstar_Hair_Black,
    Superstar_Hair_Blonde,
    Superstar_Hair_Brown,
    Superstar_Hair_Ginger,
    Superstar_Hair_White,
    Tall_Spikey_Hair_Black,
    Tall_Spikey_Hair_Blonde,
    Tall_Spikey_Hair_Blue,
    Tall_Spikey_Hair_Brown,
    Tall_Spikey_Hair_Ginger,
    Tall_Spikey_Hair_Green,
    Tall_Spikey_Hair_Orange,
    Tall_Spikey_Hair_Pink,
    Tall_Spikey_Hair_Purple,
    Tall_Spikey_Hair_Red,
    Tall_Spikey_Hair_Turquoise,
    Tall_Spikey_Hair_White,
    Wild_Hair_Black,
    Wild_Hair_Blonde,
    Wild_Hair_Blue,
    Wild_Hair_Brown,
    Wild_Hair_Ginger,
    Wild_Hair_Green,
    Wild_Hair_Orange,
    Wild_Hair_Pink,
    Wild_Hair_Purple,
    Wild_Hair_Red,
    Wild_Hair_Turquoise,
    Wild_Hair_White
}

enum E_Male_Hat_Hair {
    None,
    Bowl_Cut_Black_Hat,
    Bowl_Cut_Blonde_Hat,
    Bowl_Cut_Brown_Hat,
    Bowl_Cut_Ginger_Hat,
    Bowl_Cut_White_Hat,
    Buzz_Cut_Black_Hat,
    Buzz_Cut_Blonde_Hat,
    Buzz_Cut_Brown_Hat,
    Buzz_Cut_Fade_Hat,
    Buzz_Cut_Ginger_Hat,
    Buzz_Cut_Hat,
    Curly_Hair_Black_Hat,
    Curly_Hair_Blonde_Hat,
    Curly_Hair_Blue_Hat,
    Curly_Hair_Brown_Hat,
    Curly_Hair_Ginger_Hat,
    Curly_Hair_Green_Hat,
    Curly_Hair_Orange_Hat,
    Curly_Hair_Pink_Hat,
    Curly_Hair_Purple_Hat,
    Curly_Hair_Red_Hat,
    Curly_Hair_Turquoise_Hat,
    Curly_Hair_White_Hat,
    Electric_Hair_Black_Hat,
    Electric_Hair_Blonde_Hat,
    Electric_Hair_Blue_Hat,
    Electric_Hair_Brown_Hat,
    Electric_Hair_Ginger_Hat,
    Electric_Hair_Green_Hat,
    Electric_Hair_Orange_Hat,
    Electric_Hair_Pink_Hat,
    Electric_Hair_Purple_Hat,
    Electric_Hair_Red_Hat,
    Electric_Hair_Turquoise_Hat,
    Electric_Hair_White_Hat,
    Funky_Hair_Black_Hat,
    Funky_Hair_Blonde_Hat,
    Funky_Hair_Blue_Hat,
    Funky_Hair_Brown_Hat,
    Funky_Hair_Ginger_Hat,
    Funky_Hair_Green_Hat,
    Funky_Hair_Orange_Hat,
    Funky_Hair_Pink_Hat,
    Funky_Hair_Purple_Hat,
    Funky_Hair_Red_Hat,
    Funky_Hair_Turquoise_Hat,
    Funky_Hair_White_Hat,
    Messy_Hair_Black_Hat,
    Messy_Hair_Blonde_Hat,
    Messy_Hair_Blue_Hat,
    Messy_Hair_Brown_Hat,
    Messy_Hair_Ginger_Hat,
    Messy_Hair_Green_Hat,
    Messy_Hair_Orange_Hat,
    Messy_Hair_Pink_Hat,
    Messy_Hair_Purple_Hat,
    Messy_Hair_Red_Hat,
    Messy_Hair_Turquoise_Hat,
    Messy_Hair_White_Hat,
    Old_Hair_Black_Hat,
    Old_Hair_Grey_Hat,
    Old_Hair_White_Hat,
    Shaved_Head_Hat,
    Short_Mohawk_Black_Hat,
    Short_Mohawk_Blonde_Hat,
    Short_Mohawk_Blue_Hat,
    Short_Mohawk_Brown_Hat,
    Short_Mohawk_Ginger_Hat,
    Short_Mohawk_Green_Hat,
    Short_Mohawk_Orange_Hat,
    Short_Mohawk_Pink_Hat,
    Short_Mohawk_Purple_Hat,
    Short_Mohawk_Red_Hat,
    Short_Mohawk_Turquoise_Hat,
    Short_Mohawk_White_Hat,
    Side_Line_Hat,
    Spikey_Black_Hat,
    Spikey_Blonde_Hat,
    Spikey_Blue_Hat,
    Spikey_Brown_Hat,
    Spikey_Ginger_Hat,
    Spikey_Green_Hat,
    Spikey_Orange_Hat,
    Spikey_Pink_Hat,
    Spikey_Purple_Hat,
    Spikey_Red_Hat,
    Spikey_Turquoise_Hat,
    Spikey_White_Hat,
    Superstar_Hair_Black_Hat,
    Superstar_Hair_Blonde_Hat,
    Superstar_Hair_Brown_Hat,
    Superstar_Hair_Ginger_Hat,
    Superstar_Hair_White_Hat,
    Wild_Hair_Black_Hat,
    Wild_Hair_Blonde_Hat,
    Wild_Hair_Blue_Hat,
    Wild_Hair_Brown_Hat,
    Wild_Hair_Ginger_Hat,
    Wild_Hair_Green_Hat,
    Wild_Hair_Orange_Hat,
    Wild_Hair_Pink_Hat,
    Wild_Hair_Purple_Hat,
    Wild_Hair_Red_Hat,
    Wild_Hair_Turquoise_Hat,
    Wild_Hair_White_Hat
}

enum E_Male_Headwear {
    None,
    Backwards_Cap_Blue,
    Backwards_Cap_Green,
    Backwards_Cap_Purple,
    Backwards_Cap_Red,
    Backwards_Cap,
    Bandana_Black,
    Bandana_Blue,
    Bandana_Green,
    Bandana_Orange,
    Bandana_Pink,
    Bandana_Purple,
    Bandana_Red,
    Bandana_Turquoise,
    Bandana_White,
    Beanie_Blue,
    Beanie_Brown,
    Beanie_Green,
    Beanie_Orange,
    Beanie_Pink,
    Beanie_Purple,
    Beanie_Red,
    Beanie_Turquoise,
    Beanie_White,
    Beret_Black,
    Beret_Blue,
    Beret_Red,
    Boater,
    Bowler_Hat_Beige,
    Bowler_Hat_Black,
    Bowler_Hat_Brown,
    Bowler_Hat_Burgundy,
    Bowler_Hat_Grey,
    Bowler_Hat_Navy,
    Bowler_Hat_White,
    Cap_Blue,
    Cap_Green,
    Cap_Purple,
    Cap_Red,
    Cap,
    Cavalier_Hat,
    Cloak_Black,
    Cloak_Blue,
    Cloak_Green,
    Cloak_Purple,
    Cloak_Red,
    Cloak_White,
    Cloak,
    Construction_Hat,
    Cowboy_Hat_Beige,
    Cowboy_Hat_Black,
    Cowboy_Hat_Burgundy,
    Cowboy_Hat_Dark,
    Cowboy_Hat_Grey,
    Cowboy_Hat_Light,
    Cowboy_Hat_Navy,
    Cowboy_Hat_White,
    Cowboy_Hat,
    Deerstalker_Hat,
    Demon_Horns,
    Durag_Black,
    Durag_Blue,
    Durag_Grey,
    Durag_Red,
    Durag_White,
    Fedora_Beige,
    Fedora_Black,
    Fedora_Burgundy,
    Fedora_Dark,
    Fedora_Grey,
    Fedora_Light,
    Fedora_Navy,
    Fedora_White,
    Fedora,
    Halo,
    Headphones,
    Hoodie_Blue,
    Hoodie_Green,
    Hoodie_Purple,
    Hoodie_Red,
    Hoodie,
    Jester_Hat,
    King_Crown,
    Kitty_Ears_Brown,
    Kitty_Ears_Pink,
    Kitty_Ears_Purple,
    Kitty_Ears_White,
    Military_Beret_Brown,
    Military_Beret_Green,
    Military_Beret_Red,
    Military_Helmet,
    Ninja_Headband_Black,
    Ninja_Headband_Blue,
    Ninja_Headband_Brown,
    Ninja_Headband_Green,
    Ninja_Headband_Orange,
    Ninja_Headband_Purple,
    Ninja_Headband_Red,
    Pirate_Hat,
    Police_Hat,
    Santa_Hat_Green,
    Santa_Hat,
    Sherpa_Hat_Blue,
    Sherpa_Hat_Brown,
    Sherpa_Hat_Red,
    Snapback_Cap_Blue,
    Snapback_Cap_Green,
    Snapback_Cap_Orange,
    Snapback_Cap_Pink,
    Snapback_Cap_Purple,
    Snapback_Cap_Red,
    Snapback_Cap_Turquoise,
    Snapback_Cap_Yellow,
    Sweatband_Black,
    Sweatband_Blue,
    Sweatband_Green,
    Sweatband_Orange,
    Sweatband_Pink,
    Sweatband_Purple,
    Sweatband_Red,
    Sweatband_Turquoise,
    Sweatband_White,
    Sweatband_Yellow,
    Tassle_Hat_Blue,
    Tassle_Hat_Green,
    Tassle_Hat_Orange,
    Tassle_Hat_Pink,
    Tassle_Hat_Purple,
    Tassle_Hat_Red,
    Tassle_Hat_Sky_Blue,
    Tassle_Hat_Turquoise,
    Top_Hat_Beige,
    Top_Hat_Black,
    Top_Hat_Burgundy,
    Top_Hat_Dark,
    Top_Hat_Grey,
    Top_Hat_Light,
    Top_Hat_Navy,
    Top_Hat_White,
    Top_Hat,
    Viking_Hat,
    Visor_Black,
    Visor_Blue,
    Visor_Red,
    Visor_White,
    Welding_Goggles,
    Wide_Bowler_Hat_Beige,
    Wide_Bowler_Hat_Black,
    Wide_Bowler_Hat_Brown,
    Wide_Bowler_Hat_Burgundy,
    Wide_Bowler_Hat_Grey,
    Wide_Bowler_Hat_Navy,
    Wide_Bowler_Hat_White,
    Winter_Hat_Blue,
    Winter_Hat_Brown,
    Winter_Hat_Green,
    Winter_Hat_Orange,
    Winter_Hat_Pink,
    Winter_Hat_Purple,
    Winter_Hat_Red,
    Winter_Hat_Turquoise,
    Wizard_Hat_Blue,
    Wizard_Hat_Green,
    Wizard_Hat_Orange,
    Wizard_Hat_Pink,
    Wizard_Hat_Purple,
    Wizard_Hat_Red,
    Wizard_Hat_Turquoise,
    Wizard_Hat
}

enum E_Male_Eye_Wear {
    None,
    _3D_Glasses,
    AR_Headset_Blue,
    AR_Headset_Green,
    AR_Headset_Pink,
    AR_Headset_Purple,
    AR_Headset_Red,
    AR_Shades_Blue,
    AR_Shades_Green,
    AR_Shades_Orange,
    AR_Shades_Pink,
    AR_Shades_Purple,
    AR_Shades_Red,
    AR_Shades_Turquoise,
    AR_Shades_Yellow,
    Big_Shades_Blue,
    Big_Shades_Golden,
    Big_Shades_Green,
    Big_Shades_Hot_Pink,
    Big_Shades_Orange,
    Big_Shades_Pink,
    Big_Shades_Purple,
    Big_Shades_Red,
    Big_Shades_Sky_Blue,
    Big_Shades_Turquoise,
    Big_Shades_Yellow,
    Bionic_Eye_Patch_Blue,
    Bionic_Eye_Patch_Green,
    Bionic_Eye_Patch_Orange,
    Bionic_Eye_Patch_Pink,
    Bionic_Eye_Patch_Purple,
    Bionic_Eye_Patch_Red,
    Bionic_Eye_Patch_Turquoise,
    Bionic_Eye_Patch_Yellow,
    Blue_Light_Blocking_Glasses,
    Circle_Glasses_Blue,
    Circle_Glasses_Green,
    Circle_Glasses_Orange,
    Circle_Glasses_Pink,
    Circle_Glasses_Purple,
    Circle_Glasses_Red,
    Circle_Glasses_Turquoise,
    Circle_Glasses_Yellow,
    Circle_Glasses,
    Cyclops_Visor,
    Enhanced_3D_Glasses,
    Eye_Mask,
    Eye_Patch,
    Futuristic_Shades_Blue,
    Futuristic_Shades_Green,
    Futuristic_Shades_Orange,
    Futuristic_Shades_Pink,
    Futuristic_Shades_Purple,
    Futuristic_Shades_Red,
    Futuristic_Shades_Turquoise,
    Gangster_Shades,
    Heart_Shades_Blue,
    Heart_Shades_Green,
    Heart_Shades_Orange,
    Heart_Shades_Pink,
    Heart_Shades_Purple,
    Heart_Shades,
    Horn_Rimmed_Glasses,
    Laser_Beam_Blue,
    Laser_Beam_Green,
    Laser_Beam,
    Matrix_Headset_Blue,
    Matrix_Headset_Green,
    Matrix_Headset_Orange,
    Matrix_Headset_Pink,
    Matrix_Headset_Purple,
    Matrix_Headset_Red,
    Matrix_Headset_Turquoise,
    Matrix_Headset_Yellow,
    Monocle_Left,
    Monocle_Right,
    Nerd_Glasses,
    Ninja_Eye_Mask_Blue,
    Ninja_Eye_Mask_Orange,
    Ninja_Eye_Mask_Purple,
    Ninja_Eye_Mask_Red,
    Pirate_Eye_Patch,
    Rainbow_Shades,
    Regular_Glasses,
    Retro_Shades,
    Scouter_Blue,
    Scouter_Green,
    Scouter_Orange,
    Scouter_Pink,
    Scouter_Purple,
    Scouter_Red,
    Scouter_Turquoise,
    Scouter_Yellow,
    Scouter,
    Shades_Blue,
    Shades_Gold,
    Shades_Green,
    Shades_Hot_Pink,
    Shades_Orange,
    Shades_Pink,
    Shades_Purple,
    Shades_Red,
    Shades_Sky_Blue,
    Shades_Turquoise,
    Shades_Yellow,
    Square_Glasses_Blue,
    Square_Glasses_Green,
    Square_Glasses_Orange,
    Square_Glasses_Pink,
    Square_Glasses_Purple,
    Square_Glasses_Red,
    Square_Glasses_Turquoise,
    Square_Glasses_Yellow,
    Square_Glasses,
    Steampunk_Glasses,
    VR_Headset_Blue,
    VR_Headset_Green,
    VR_Headset_Red,
    VR_Headset,
    XR_Headset_Blue,
    XR_Headset_Green,
    XR_Headset_Orange,
    XR_Headset_Pink,
    XR_Headset_Purple,
    XR_Headset_Red,
    XR_Headset_Sky_Blue,
    XR_Headset_Turquoise,
    XR_Headset_Yellow
}

enum E_Female_Skin {
    None,
    Alien,
    Ape,
    Demon,
    Ghost,
    Glitch,
    Goblin,
    Human_1,
    Human_10,
    Human_11,
    Human_12,
    Human_2,
    Human_3,
    Human_4,
    Human_5,
    Human_6,
    Human_7,
    Human_8,
    Human_9,
    Invisible,
    Mummy,
    Robot,
    Skeleton,
    Vampire,
    Zombie_Ape,
    Zombie
}

enum E_Female_Eyes {
    None,
    Blind,
    Closed,
    Clown_Eyes_Blue,
    Clown_Eyes_Green,
    Clown_Eyes_Orange,
    Clown_Eyes_Pink,
    Clown_Eyes_Purple,
    Clown_Eyes_Red,
    Clown_Eyes_Sky_Blue,
    Clown_Eyes_Turquoise,
    Clown_Eyes_Yellow,
    Confused,
    Eye_Shadow_Blue,
    Eye_Shadow_Green,
    Eye_Shadow_Orange,
    Eye_Shadow_Pink,
    Eye_Shadow_Purple,
    Eye_Shadow_Red,
    Eye_Shadow_Turquoise,
    Eye_Shadow_Yellow,
    Ghost_Left,
    Ghost_Right,
    Left,
    Possessed_Left,
    Possessed_Right,
    Right,
    Tired_Confused,
    Tired_Left,
    Tired_Right,
    Wink
}

enum E_Female_Face {
    None,
    Armor_Tattoo,
    Axe_Tattoo,
    Bandage,
    Bionic_Eyes,
    Blush,
    Cross_Tattoo,
    Cybereye_Left,
    Cybereye_Right,
    Cyberface,
    Gun_Tattoo,
    Heart_Tattoo,
    Jet_Tattoo,
    Left_Bionic_Eye,
    Mole,
    Right_Bionic_Eye,
    Shotgun_Tattoo,
    Sword_Tattoo,
    X_Tattoo
}

enum E_Female_Chain {
    None,
    Chain_Amethyst,
    Chain_Diamond,
    Chain_Emerald,
    Chain_Gold,
    Chain_Onyx,
    Chain_Pink_Diamond,
    Chain_Ruby,
    Chain_Sapphire
}

enum E_Female_Earring {
    None,
    Earring_Amethyst,
    Earring_Diamond,
    Earring_Emerald,
    Earring_Gold,
    Earring_Onyx,
    Earring_Pink_Diamond,
    Earring_Ruby,
    Earring_Sapphire
}

enum E_Female_Scarf {
    None,
    Blue_Scarf,
    Green_Scarf,
    Red_Scarf
}

enum E_Female_Mask {
    None,
    Bandana_Mask_Blue,
    Bandana_Mask_Green,
    Bandana_Mask_Purple,
    Bandana_Mask_Red,
    Gas_Mask,
    Medical_Mask_Blue,
    Medical_Mask_Green,
    Medical_Mask_Orange,
    Medical_Mask_Pink,
    Medical_Mask_Purple,
    Medical_Mask_Red,
    Medical_Mask_Turquoise,
    Medical_Mask_Yellow,
    Medical_Mask,
    Metal_Mask,
    Ninja_Mask_Black,
    Ninja_Mask_Blue,
    Ninja_Mask_Brown,
    Ninja_Mask_Purple,
    Ninja_Mask_Red
}

enum E_Female_Hair {
    None,
    Afro_Black,
    Afro_Blonde,
    Afro_Blue,
    Afro_Brown,
    Afro_Ginger,
    Afro_Green,
    Afro_Orange,
    Afro_Pink,
    Afro_Purple,
    Afro_Red,
    Afro_Turquoise,
    Afro_White,
    Bob_Black,
    Bob_Blonde,
    Bob_Blue,
    Bob_Brown,
    Bob_Ginger,
    Bob_Green,
    Bob_Orange,
    Bob_Pink,
    Bob_Purple,
    Bob_Red,
    Bob_Turquoise,
    Bob_White,
    Curled_Mohawk_Blue,
    Curled_Mohawk_Green,
    Curled_Mohawk_Orange,
    Curled_Mohawk_Pink,
    Curled_Mohawk_Purple,
    Curled_Mohawk_Red,
    Curly_Hair_Black,
    Curly_Hair_Blonde,
    Curly_Hair_Blue,
    Curly_Hair_Brown,
    Curly_Hair_Ginger,
    Curly_Hair_Green,
    Curly_Hair_Orange,
    Curly_Hair_Pink,
    Curly_Hair_Purple,
    Curly_Hair_Red,
    Curly_Hair_Turquoise,
    Curly_Hair_White,
    Long_Straight_Hair_Black,
    Long_Straight_Hair_Blonde,
    Long_Straight_Hair_Blue,
    Long_Straight_Hair_Brown,
    Long_Straight_Hair_Ginger,
    Long_Straight_Hair_Green,
    Long_Straight_Hair_Orange,
    Long_Straight_Hair_Pink,
    Long_Straight_Hair_Purple,
    Long_Straight_Hair_Red,
    Long_Straight_Hair_Turquoise,
    Long_Straight_Hair_White,
    Messy_Hair_Black,
    Messy_Hair_Blonde,
    Messy_Hair_Blue,
    Messy_Hair_Brown,
    Messy_Hair_Ginger,
    Messy_Hair_Green,
    Messy_Hair_Orange,
    Messy_Hair_Pink,
    Messy_Hair_Purple,
    Messy_Hair_Red,
    Messy_Hair_Turquoise,
    Messy_Hair_White,
    Mohawk_Black,
    Mohawk_Blonde,
    Mohawk_Blue,
    Mohawk_Brown,
    Mohawk_Ginger,
    Mohawk_Green,
    Mohawk_Neon_Blue,
    Mohawk_Neon_Green,
    Mohawk_Neon_Purple,
    Mohawk_Neon_Red,
    Mohawk_Orange,
    Mohawk_Pink,
    Mohawk_Purple,
    Mohawk_Red,
    Mohawk_Turquoise,
    Mohawk_White,
    Pigtails_Black,
    Pigtails_Blonde,
    Pigtails_Blue,
    Pigtails_Brown,
    Pigtails_Ginger,
    Pigtails_Green,
    Pigtails_Orange,
    Pigtails_Pink,
    Pigtails_Purple,
    Pigtails_Red,
    Pigtails_Turquoise,
    Pigtails_White,
    Pompadour_Black,
    Pompadour_Blonde,
    Pompadour_Blue,
    Pompadour_Brown,
    Pompadour_Ginger,
    Pompadour_Green,
    Pompadour_Orange,
    Pompadour_Pink,
    Pompadour_Purple,
    Pompadour_Red,
    Pompadour_Turquoise,
    Pompadour_White,
    Sharp_Mohawk_Black,
    Sharp_Mohawk_Blonde,
    Sharp_Mohawk_Blue,
    Sharp_Mohawk_Brown,
    Sharp_Mohawk_Ginger,
    Sharp_Mohawk_Green,
    Sharp_Mohawk_Neon_Blue,
    Sharp_Mohawk_Neon_Green,
    Sharp_Mohawk_Neon_Purple,
    Sharp_Mohawk_Neon_Red,
    Sharp_Mohawk_Orange,
    Sharp_Mohawk_Pink,
    Sharp_Mohawk_Purple,
    Sharp_Mohawk_Red,
    Sharp_Mohawk_Turquoise,
    Sharp_Mohawk_White,
    Short_Mohawk_Black,
    Short_Mohawk_Blonde,
    Short_Mohawk_Blue,
    Short_Mohawk_Brown,
    Short_Mohawk_Ginger,
    Short_Mohawk_Green,
    Short_Mohawk_Orange,
    Short_Mohawk_Pink,
    Short_Mohawk_Purple,
    Short_Mohawk_Red,
    Short_Mohawk_Turquoise,
    Short_Mohawk_White,
    Short_Straight_Hair_Black,
    Short_Straight_Hair_Blonde,
    Short_Straight_Hair_Blue,
    Short_Straight_Hair_Brown,
    Short_Straight_Hair_Ginger,
    Short_Straight_Hair_Green,
    Short_Straight_Hair_Orange,
    Short_Straight_Hair_Pink,
    Short_Straight_Hair_Purple,
    Short_Straight_Hair_Red,
    Short_Straight_Hair_Turquoise,
    Short_Straight_Hair_White,
    Sidecut_Black,
    Sidecut_Blonde,
    Sidecut_Blue,
    Sidecut_Brown,
    Sidecut_Ginger,
    Sidecut_Green,
    Sidecut_Orange,
    Sidecut_Pink,
    Sidecut_Purple,
    Sidecut_Red,
    Sidecut_Turquoise,
    Sidecut_White,
    Straight_Hair_Black,
    Straight_Hair_Blonde,
    Straight_Hair_Blue,
    Straight_Hair_Brown,
    Straight_Hair_Ginger,
    Straight_Hair_Green,
    Straight_Hair_Orange,
    Straight_Hair_Pink,
    Straight_Hair_Purple,
    Straight_Hair_Red,
    Straight_Hair_Turquoise,
    Straight_Hair_White,
    Stringy_Hair_Black,
    Stringy_Hair_Blonde,
    Stringy_Hair_Blue,
    Stringy_Hair_Brown,
    Stringy_Hair_Ginger,
    Stringy_Hair_Green,
    Stringy_Hair_Orange,
    Stringy_Hair_Pink,
    Stringy_Hair_Purple,
    Stringy_Hair_Red,
    Stringy_Hair_Turquoise,
    Stringy_Hair_White,
    Wild_Hair_Black,
    Wild_Hair_Blonde,
    Wild_Hair_Blue,
    Wild_Hair_Brown,
    Wild_Hair_Ginger,
    Wild_Hair_Green,
    Wild_Hair_Orange,
    Wild_Hair_Pink,
    Wild_Hair_Purple,
    Wild_Hair_Red,
    Wild_Hair_Turquoise,
    Wild_Hair_White
}

enum E_Female_Hat_Hair {
    None,
    Bob_Black_Hat,
    Bob_Blonde_Hat,
    Bob_Blue_Hat,
    Bob_Brown_Hat,
    Bob_Ginger_Hat,
    Bob_Green_Hat,
    Bob_Orange_Hat,
    Bob_Pink_Hat,
    Bob_Purple_Hat,
    Bob_Red_Hat,
    Bob_Turquoise_Hat,
    Bob_White_Hat,
    Curly_Hair_Black_Hat,
    Curly_Hair_Blonde_Hat,
    Curly_Hair_Blue_Hat,
    Curly_Hair_Brown_Hat,
    Curly_Hair_Ginger_Hat,
    Curly_Hair_Green_Hat,
    Curly_Hair_Orange_Hat,
    Curly_Hair_Pink_Hat,
    Curly_Hair_Purple_Hat,
    Curly_Hair_Red_Hat,
    Curly_Hair_Turquoise_Hat,
    Curly_Hair_White_Hat,
    Long_Straight_Hair_Black_Hat,
    Long_Straight_Hair_Blonde_Hat,
    Long_Straight_Hair_Blue_Hat,
    Long_Straight_Hair_Brown_Hat,
    Long_Straight_Hair_Ginger_Hat,
    Long_Straight_Hair_Green_Hat,
    Long_Straight_Hair_Orange_Hat,
    Long_Straight_Hair_Pink_Hat,
    Long_Straight_Hair_Purple_Hat,
    Long_Straight_Hair_Red_Hat,
    Long_Straight_Hair_Turquoise_Hat,
    Long_Straight_Hair_White_Hat,
    Messy_Hair_Black_Hat,
    Messy_Hair_Blonde_Hat,
    Messy_Hair_Blue_Hat,
    Messy_Hair_Brown_Hat,
    Messy_Hair_Ginger_Hat,
    Messy_Hair_Green_Hat,
    Messy_Hair_Orange_Hat,
    Messy_Hair_Pink_Hat,
    Messy_Hair_Purple_Hat,
    Messy_Hair_Red_Hat,
    Messy_Hair_Turquoise_Hat,
    Messy_Hair_White_Hat,
    Pompadour_Black_Hat,
    Pompadour_Blonde_Hat,
    Pompadour_Blue_Hat,
    Pompadour_Brown_Hat,
    Pompadour_Ginger_Hat,
    Pompadour_Green_Hat,
    Pompadour_Orange_Hat,
    Pompadour_Pink_Hat,
    Pompadour_Purple_Hat,
    Pompadour_Red_Hat,
    Pompadour_Turquoise_Hat,
    Pompadour_White_Hat,
    Short_Mohawk_Black_Hat,
    Short_Mohawk_Blonde_Hat,
    Short_Mohawk_Blue_Hat,
    Short_Mohawk_Brown_Hat,
    Short_Mohawk_Ginger_Hat,
    Short_Mohawk_Green_Hat,
    Short_Mohawk_Orange_Hat,
    Short_Mohawk_Pink_Hat,
    Short_Mohawk_Purple_Hat,
    Short_Mohawk_Red_Hat,
    Short_Mohawk_Turquoise_Hat,
    Short_Mohawk_White_Hat,
    Short_Straight_Hair_Black_Hat,
    Short_Straight_Hair_Blonde_Hat,
    Short_Straight_Hair_Blue_Hat,
    Short_Straight_Hair_Brown_Hat,
    Short_Straight_Hair_Ginger_Hat,
    Short_Straight_Hair_Green_Hat,
    Short_Straight_Hair_Orange_Hat,
    Short_Straight_Hair_Pink_Hat,
    Short_Straight_Hair_Purple_Hat,
    Short_Straight_Hair_Red_Hat,
    Short_Straight_Hair_Turquoise_Hat,
    Short_Straight_Hair_White_Hat,
    Sidecut_Black_Hat,
    Sidecut_Blonde_Hat,
    Sidecut_Blue_Hat,
    Sidecut_Brown_Hat,
    Sidecut_Ginger_Hat,
    Sidecut_Green_Hat,
    Sidecut_Orange_Hat,
    Sidecut_Pink_Hat,
    Sidecut_Purple_Hat,
    Sidecut_Red_Hat,
    Sidecut_Turquoise_Hat,
    Sidecut_White_Hat,
    Straight_Hair_Black_Hat,
    Straight_Hair_Blonde_Hat,
    Straight_Hair_Blue_Hat,
    Straight_Hair_Brown_Hat,
    Straight_Hair_Ginger_Hat,
    Straight_Hair_Green_Hat,
    Straight_Hair_Orange_Hat,
    Straight_Hair_Pink_Hat,
    Straight_Hair_Purple_Hat,
    Straight_Hair_Red_Hat,
    Straight_Hair_Turquoise_Hat,
    Straight_Hair_White_Hat,
    Stringy_Hair_Black_Hat,
    Stringy_Hair_Blonde_Hat,
    Stringy_Hair_Blue_Hat,
    Stringy_Hair_Brown_Hat,
    Stringy_Hair_Ginger_Hat,
    Stringy_Hair_Green_Hat,
    Stringy_Hair_Orange_Hat,
    Stringy_Hair_Pink_Hat,
    Stringy_Hair_Purple_Hat,
    Stringy_Hair_Red_Hat,
    Stringy_Hair_Turquoise_Hat,
    Stringy_Hair_White_Hat,
    Wild_Hair_Black_Hat,
    Wild_Hair_Blonde_Hat,
    Wild_Hair_Blue_Hat,
    Wild_Hair_Brown_Hat,
    Wild_Hair_Ginger_Hat,
    Wild_Hair_Green_Hat,
    Wild_Hair_Orange_Hat,
    Wild_Hair_Pink_Hat,
    Wild_Hair_Purple_Hat,
    Wild_Hair_Red_Hat,
    Wild_Hair_Turquoise_Hat,
    Wild_Hair_White_Hat
}

enum E_Female_Headwear {
    None,
    Aviator_Helmet,
    Backwards_Cap_Blue,
    Backwards_Cap_Green,
    Backwards_Cap_Grey,
    Backwards_Cap_Purple,
    Backwards_Cap_Red,
    Bandana_Black,
    Bandana_Blue,
    Bandana_Green,
    Bandana_Orange,
    Bandana_Pink,
    Bandana_Purple,
    Bandana_Red,
    Bandana_Turquoise,
    Bandana_White,
    Beanie_Blue,
    Beanie_Brown,
    Beanie_Green,
    Beanie_Orange,
    Beanie_Pink,
    Beanie_Purple,
    Beanie_Red,
    Beanie_Turquoise,
    Beanie_White,
    Beret_Black,
    Beret_Blue,
    Beret_Red,
    Cap_Blue,
    Cap_Green,
    Cap_Purple,
    Cap_Red,
    Cap,
    Cavalier_Hat,
    Cloak_Black,
    Cloak_Blue,
    Cloak_Green,
    Cloak_Purple,
    Cloak_Red,
    Cloak_White,
    Cloak,
    Cowgirl_Hat_Beige,
    Cowgirl_Hat_Black,
    Cowgirl_Hat_Burgundy,
    Cowgirl_Hat_Dark,
    Cowgirl_Hat_Grey,
    Cowgirl_Hat_Light,
    Cowgirl_Hat_Navy,
    Cowgirl_Hat_White,
    Cowgirl_Hat,
    Demon_Horns,
    Halo,
    Headphones,
    Hoodie_Blue,
    Hoodie_Green,
    Hoodie_Purple,
    Hoodie_Red,
    Hoodie,
    Jester_Hat,
    Kitty_Ears_Brown,
    Kitty_Ears_Pink,
    Kitty_Ears_Purple,
    Kitty_Ears_White,
    Military_Beret_Brown,
    Military_Beret_Green,
    Military_Beret_Red,
    Ninja_Headband_Black,
    Ninja_Headband_Blue,
    Ninja_Headband_Brown,
    Ninja_Headband_Green,
    Ninja_Headband_Orange,
    Ninja_Headband_Purple,
    Ninja_Headband_Red,
    Pirate_Hat,
    Police_Cap,
    Queen_Crown,
    Santa_Hat_Green,
    Santa_Hat,
    Sherpa_Hat_Blue,
    Sherpa_Hat_Brown,
    Sherpa_Hat_Red,
    Snapback_Cap_Blue,
    Snapback_Cap_Green,
    Snapback_Cap_Orange,
    Snapback_Cap_Pink,
    Snapback_Cap_Purple,
    Snapback_Cap_Red,
    Snapback_Cap_Turquoise,
    Snapback_Cap_Yellow,
    Sweatband_Black,
    Sweatband_Blue,
    Sweatband_Green,
    Sweatband_Orange,
    Sweatband_Pink,
    Sweatband_Purple,
    Sweatband_Red,
    Sweatband_Turquoise,
    Sweatband_White,
    Sweatband_Yellow,
    Tassle_Hat_Blue,
    Tassle_Hat_Green,
    Tassle_Hat_Orange,
    Tassle_Hat_Pink,
    Tassle_Hat_Purple,
    Tassle_Hat_Red,
    Tassle_Hat_Sky_Blue,
    Tassle_Hat_Turquoise,
    Tiara_Gold,
    Tiara_Silver,
    Viking_Hat,
    Visor_Black,
    Visor_Blue,
    Visor_Red,
    Visor_White,
    Welding_Goggles,
    Winter_Hat_Blue,
    Winter_Hat_Brown,
    Winter_Hat_Green,
    Winter_Hat_Orange,
    Winter_Hat_Pink,
    Winter_Hat_Purple,
    Winter_Hat_Red,
    Winter_Hat_Turquoise,
    Witch_Hat_Blue,
    Witch_Hat_Green,
    Witch_Hat_Orange,
    Witch_Hat_Pink,
    Witch_Hat_Purple,
    Witch_Hat_Red,
    Witch_Hat_Turquoise,
    Witch_Hat
}

enum E_Female_Eye_Wear {
    None,
    _3D_Glasses,
    AR_Headset_Blue,
    AR_Headset_Green,
    AR_Headset_Pink,
    AR_Headset_Purple,
    AR_Headset_Red,
    AR_Shades_Blue,
    AR_Shades_Green,
    AR_Shades_Orange,
    AR_Shades_Pink,
    AR_Shades_Purple,
    AR_Shades_Red,
    AR_Shades_Turquoise,
    AR_Shades_Yellow,
    Big_Shades_Blue,
    Big_Shades_Golden,
    Big_Shades_Green,
    Big_Shades_Hot_Pink,
    Big_Shades_Orange,
    Big_Shades_Pink,
    Big_Shades_Purple,
    Big_Shades_Red,
    Big_Shades_Sky_Blue,
    Big_Shades_Turquoise,
    Big_Shades_Yellow,
    Bionic_Eye_Patch_Blue,
    Bionic_Eye_Patch_Green,
    Bionic_Eye_Patch_Orange,
    Bionic_Eye_Patch_Pink,
    Bionic_Eye_Patch_Purple,
    Bionic_Eye_Patch_Red,
    Bionic_Eye_Patch_Turquoise,
    Bionic_Eye_Patch_Yellow,
    Blue_Light_Blocking_Glasses,
    Circle_Glasses_Blue,
    Circle_Glasses_Green,
    Circle_Glasses_Orange,
    Circle_Glasses_Pink,
    Circle_Glasses_Purple,
    Circle_Glasses_Red,
    Circle_Glasses_Turquoise,
    Circle_Glasses_Yellow,
    Circle_Glasses,
    Cyclops_Visor,
    Enhanced_3D_Glasses,
    Eye_Mask,
    Eye_Patch,
    Futuristic_Shades_Blue,
    Futuristic_Shades_Green,
    Futuristic_Shades_Orange,
    Futuristic_Shades_Pink,
    Futuristic_Shades_Purple,
    Futuristic_Shades_Red,
    Futuristic_Shades_Turquoise,
    Gangster_Shades,
    Heart_Shades_Blue,
    Heart_Shades_Green,
    Heart_Shades_Orange,
    Heart_Shades_Pink,
    Heart_Shades_Purple,
    Heart_Shades,
    Horn_Rimmed_Glasses,
    Laser_Beam_Blue,
    Laser_Beam_Green,
    Laser_Beam,
    Matrix_Headset_Blue,
    Matrix_Headset_Green,
    Matrix_Headset_Orange,
    Matrix_Headset_Pink,
    Matrix_Headset_Purple,
    Matrix_Headset_Red,
    Matrix_Headset_Turquoise,
    Matrix_Headset_Yellow,
    Nerd_Glasses,
    Pirate_Eye_Patch,
    Rainbow_Shades,
    Regular_Glasses,
    Retro_Shades,
    Scouter_Blue,
    Scouter_Green,
    Scouter_Orange,
    Scouter_Pink,
    Scouter_Purple,
    Scouter_Red,
    Scouter_Turquoise,
    Scouter_Yellow,
    Scouter,
    Shades_Blue,
    Shades_Gold,
    Shades_Green,
    Shades_Hot_Pink,
    Shades_Orange,
    Shades_Pink,
    Shades_Purple,
    Shades_Red,
    Shades_Sky_Blue,
    Shades_Turquoise,
    Shades_Yellow,
    Square_Glasses_Blue,
    Square_Glasses_Green,
    Square_Glasses_Orange,
    Square_Glasses_Pink,
    Square_Glasses_Purple,
    Square_Glasses_Red,
    Square_Glasses_Turquoise,
    Square_Glasses_Yellow,
    Square_Glasses,
    Steampunk_Glasses,
    VR_Headset_Blue,
    VR_Headset_Green,
    VR_Headset_Red,
    VR_Headset,
    XR_Headset_Blue,
    XR_Headset_Green,
    XR_Headset_Orange,
    XR_Headset_Pink,
    XR_Headset_Purple,
    XR_Headset_Red,
    XR_Headset_Sky_Blue,
    XR_Headset_Turquoise,
    XR_Headset_Yellow
}

enum E_Mouth {
    None,
    Blood,
    Blue_Bubble_Gum,
    Blunt,
    Bubble_Gum,
    Buck_Teeth,
    Cigar,
    Cigarette,
    Clown_Lips,
    Diamond_Grill,
    Gold_Grill,
    Lip_Gloss_Blue,
    Lip_Gloss_Pink,
    Lip_Gloss_Purple,
    Lip_Gloss_Red,
    Old_Fashioned_Pipe,
    Pipe,
    Rainbow_Vomit,
    Silver_Grill,
    Smile,
    Smirk,
    Vape,
    Vomit
}

enum E_Filler_Traits {
    None,
    Female_Robot_Headwear_Cover,
    Male_Pumpkin_Headwear_Cover,
    Male_Robot_Headwear_Cover
}
```
