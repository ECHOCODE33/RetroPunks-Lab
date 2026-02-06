// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { IMaleProbabilities } from './interfaces/IMaleProbabilities.sol';
import { E_Male_Skin, E_Male_Eyes, E_Male_Face, E_Male_Chain, E_Male_Earring, E_Male_Scarf, E_Male_Facial_Hair, E_Male_Mask, E_Male_Hair, E_Male_Hat_Hair, E_Male_Headwear, E_Male_Eye_Wear, E_Female_Skin, E_Female_Eyes, E_Female_Face, E_Female_Chain, E_Female_Earring, E_Female_Scarf, E_Female_Mask, E_Female_Hair, E_Female_Hat_Hair, E_Female_Headwear, E_Female_Eye_Wear, E_Mouth, E_Mouth } from "./common/Enums.sol";
import { TraitsContext} from './common/Structs.sol';
import { RandomCtx, Random } from "./libraries/Random.sol";
import { TraitsUtils } from "./libraries/TraitsUtils.sol";


contract MaleProbabilities is IMaleProbabilities {

    function selectMaleSkinType(RandomCtx memory rndCtx) external pure returns (E_Male_Skin) {
        uint16[] memory probs = new uint16[](28);
        
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
        uint16[] memory probs = new uint16[](29);

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
            probs[uint(E_Male_Eyes.Ghost_Left)] = 0;
            probs[uint(E_Male_Eyes.Ghost_Right)] = 0;
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

    function selectMaleScarf(RandomCtx memory rndCtx) external pure returns (E_Male_Scarf) {
        uint16[] memory probs = new uint16[](9);

        // None = 9900
            probs[uint(E_Male_Scarf.None)] = 9900;

        // Scarf = 100
            probs[uint(E_Male_Scarf.Blue_Scarf)] = 40;
            probs[uint(E_Male_Scarf.Green_Scarf)] = 30;
            probs[uint(E_Male_Scarf.Red_Scarf)] = 30;
        
        uint selected = Random.selectRandomTrait(rndCtx, probs);

        return E_Male_Scarf(selected);
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

        // None = 9535
            probs[uint(E_Male_Mask.None)] = 9535;

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

        // Gas Mask = 30
            probs[uint(E_Male_Mask.Gas_Mask)] = 30;

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
                probs[uint(E_Male_Headwear.Cloak)] = 7;
                probs[uint(E_Male_Headwear.Cloak_Blue)] = 7;
                probs[uint(E_Male_Headwear.Cloak_Green)] = 7;
                probs[uint(E_Male_Headwear.Cloak_Purple)] = 7;
                probs[uint(E_Male_Headwear.Cloak_Red)] = 7;
                probs[uint(E_Male_Headwear.Cloak_White)] = 7;
            
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
        uint16[] memory probs = new uint16[](127);
        
        // None = 1000
            probs[uint(E_Male_Eye_Wear.None)] = 1000;

        // Tier 1 = 4000
            
            // Regular Shades = 628
                probs[uint(E_Male_Eye_Wear.Regular_Glasses)] = 628;

            // Square Glasses = 576
                probs[uint(E_Male_Eye_Wear.Square_Glasses_Blue)] = 72;
                probs[uint(E_Male_Eye_Wear.Square_Glasses_Green)] = 72;
                probs[uint(E_Male_Eye_Wear.Square_Glasses_Orange)] = 72;
                probs[uint(E_Male_Eye_Wear.Square_Glasses_Pink)] = 72;
                probs[uint(E_Male_Eye_Wear.Square_Glasses_Purple)] = 72;
                probs[uint(E_Male_Eye_Wear.Square_Glasses_Red)] = 72;
                probs[uint(E_Male_Eye_Wear.Square_Glasses_Turquoise)] = 72;
                probs[uint(E_Male_Eye_Wear.Square_Glasses_Yellow)] = 72;

            // Circle Glasses = 576
                probs[uint(E_Male_Eye_Wear.Circle_Glasses_Blue)] = 72;
                probs[uint(E_Male_Eye_Wear.Circle_Glasses_Green)] = 72;
                probs[uint(E_Male_Eye_Wear.Circle_Glasses_Orange)] = 72;
                probs[uint(E_Male_Eye_Wear.Circle_Glasses_Pink)] = 72;
                probs[uint(E_Male_Eye_Wear.Circle_Glasses_Purple)] = 72;
                probs[uint(E_Male_Eye_Wear.Circle_Glasses_Red)] = 72;
                probs[uint(E_Male_Eye_Wear.Circle_Glasses_Turquoise)] = 72;
                probs[uint(E_Male_Eye_Wear.Circle_Glasses_Yellow)] = 72;

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
        uint16[] memory probs = new uint16[](11);

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

