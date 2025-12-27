// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.30;

// import { IFemaleProbs } from './interfaces/IFemaleProbs.sol';
// import { E_Female_Skin, E_Female_Eyes, E_Female_Face, E_Female_Chain, E_Female_Earring, E_Female_Scarf, E_Female_Mask, E_Female_Hair, E_Female_Hat_Hair, E_Female_Headwear, E_Female_Eye_Wear } from "./common/Enums.sol";
// import { TraitsContext} from './common/Structs.sol';
// import { RandomCtx, Random } from "./libraries/Random.sol";
// import { TraitsLib } from "./libraries/TraitsLib.sol";

// /**
//  * @author ECHO
//  */

// contract FemaleProbs is IFemaleProbs {

//     function selectFemaleSkin(RandomCtx memory rndCtx) external pure returns (E_Female_Skin) {
//         uint16[] memory probs = new uint16[](26);
        
//         probs[uint(E_Female_Skin.None)] = 0;
//         probs[uint(E_Female_Skin.Human_1)] = 750;
//         probs[uint(E_Female_Skin.Human_2)] = 750;
//         probs[uint(E_Female_Skin.Human_3)] = 750;
//         probs[uint(E_Female_Skin.Human_4)] = 750;
//         probs[uint(E_Female_Skin.Human_5)] = 750;
//         probs[uint(E_Female_Skin.Human_6)] = 750;
//         probs[uint(E_Female_Skin.Human_7)] = 750;
//         probs[uint(E_Female_Skin.Human_8)] = 750;
//         probs[uint(E_Female_Skin.Human_9)] = 750;
//         probs[uint(E_Female_Skin.Human_10)] = 750;
//         probs[uint(E_Female_Skin.Human_11)] = 750;
//         probs[uint(E_Female_Skin.Human_12)] = 750;
//         probs[uint(E_Female_Skin.Zombie)] = 300;
//         probs[uint(E_Female_Skin.Ape)] = 225;
//         probs[uint(E_Female_Skin.Zombie_Ape)] = 150;
//         probs[uint(E_Female_Skin.Robot)] = 90;
//         probs[uint(E_Female_Skin.Glitch)] = 65;
//         probs[uint(E_Female_Skin.Ghost)] = 45;
//         probs[uint(E_Female_Skin.Alien)] = 25;
//         probs[uint(E_Female_Skin.Mummy)] = 25;
//         probs[uint(E_Female_Skin.Skeleton)] = 22;
//         probs[uint(E_Female_Skin.Goblin)] = 20;
//         probs[uint(E_Female_Skin.Demon)] = 15;
//         probs[uint(E_Female_Skin.Vampire)] = 10;
//         probs[uint(E_Female_Skin.Invisible)] = 8;

//         uint selected = Random.selectRandomTrait(rndCtx, probs);

//         return E_Female_Skin(selected);
//     }

//     function selectFemaleEyes(TraitsContext calldata traits, RandomCtx memory rndCtx) external pure returns (E_Female_Eyes) {
//         uint16[] memory probs = new uint16[](31);

//         if (TraitsLib.femaleIsGhost(traits)) {
//             probs[uint(E_Female_Eyes.Ghost_Left)] = 5000;
//             probs[uint(E_Female_Eyes.Ghost_Right)] = 5000;
//         }

//         else {
//             // None = 0
//                 probs[uint(E_Female_Eyes.None)] = 0;

//             // Human Eyes = 9850
//                 probs[uint(E_Female_Eyes.Left)] = 4125;
//                 probs[uint(E_Female_Eyes.Right)] = 4125;

//                 probs[uint(E_Female_Eyes.Tired_Left)] = 500;
//                 probs[uint(E_Female_Eyes.Tired_Right)] = 500;

//                 probs[uint(E_Female_Eyes.Confused)] = 250;
            
//                 probs[uint(E_Female_Eyes.Tired_Confused)] = 125;

//                 probs[uint(E_Female_Eyes.Closed)] = 100;
//                 probs[uint(E_Female_Eyes.Wink)] = 75;
                
//                 probs[uint(E_Female_Eyes.Blind)] = 50;


//             // Eye Shadow = 240
//                 probs[uint(E_Female_Eyes.Eye_Shadow_Blue)] = 30;
//                 probs[uint(E_Female_Eyes.Eye_Shadow_Green)] = 30;
//                 probs[uint(E_Female_Eyes.Eye_Shadow_Orange)] = 30;
//                 probs[uint(E_Female_Eyes.Eye_Shadow_Pink)] = 30;
//                 probs[uint(E_Female_Eyes.Eye_Shadow_Purple)] = 30;
//                 probs[uint(E_Female_Eyes.Eye_Shadow_Red)] = 30;
//                 probs[uint(E_Female_Eyes.Eye_Shadow_Turquoise)] = 30;
//                 probs[uint(E_Female_Eyes.Eye_Shadow_Yellow)] = 30;

//             // Clown Eyes = 100
//                 probs[uint(E_Female_Eyes.Clown_Eyes_Blue)] = 11;
//                 probs[uint(E_Female_Eyes.Clown_Eyes_Green)] = 11;
//                 probs[uint(E_Female_Eyes.Clown_Eyes_Orange)] = 11;
//                 probs[uint(E_Female_Eyes.Clown_Eyes_Pink)] = 11;
//                 probs[uint(E_Female_Eyes.Clown_Eyes_Purple)] = 11;
//                 probs[uint(E_Female_Eyes.Clown_Eyes_Red)] = 11;
//                 probs[uint(E_Female_Eyes.Clown_Eyes_Sky_Blue)] = 11;
//                 probs[uint(E_Female_Eyes.Clown_Eyes_Turquoise)] = 11;
//                 probs[uint(E_Female_Eyes.Clown_Eyes_Yellow)] = 11;

//             // Possessed = 50
//                 probs[uint(E_Female_Eyes.Possessed_Left)] = 25;
//                 probs[uint(E_Female_Eyes.Possessed_Right)] = 25;
//         }

//         uint selected = Random.selectRandomTrait(rndCtx, probs);

//         return E_Female_Eyes(selected);
//     }

//     function selectFemaleFace(TraitsContext calldata traits, RandomCtx memory rndCtx) external pure returns (E_Female_Face) {
//         uint16[] memory probs = new uint16[](19);

//         if (TraitsLib.femaleIsHuman(traits) || TraitsLib.femaleIsZombie(traits)) {
//             // Humans & Zombies can have all face traits

//             // None = 9377
//                 probs[uint(E_Female_Face.None)] = 9377;

//             // Mole = 200
//                 probs[uint(E_Female_Face.Mole)] = 200;
            
//             // Tattoos = 155
//                 probs[uint(E_Female_Face.Cross_Tattoo)] = 35;
//                 probs[uint(E_Female_Face.Jet_Tattoo)] = 22;
//                 probs[uint(E_Female_Face.Shotgun_Tattoo)] = 20;
//                 probs[uint(E_Female_Face.Gun_Tattoo)] = 18;
//                 probs[uint(E_Female_Face.Armor_Tattoo)] = 16;
//                 probs[uint(E_Female_Face.Sword_Tattoo)] = 14;
//                 probs[uint(E_Female_Face.Axe_Tattoo)] = 12;
//                 probs[uint(E_Female_Face.Heart_Tattoo)] = 10;
//                 probs[uint(E_Female_Face.X_Tattoo)] = 8;
       

//             // Blush = 125
//                 probs[uint(E_Female_Face.Blush)] = 125;

//             // Bandage = 75
//                 probs[uint(E_Female_Face.Bandage)] = 75;

//             // Bionic Eyes = 40
//                 probs[uint(E_Female_Face.Bionic_Eyes)] = 16;
//                 probs[uint(E_Female_Face.Left_Bionic_Eye)] = 12;
//                 probs[uint(E_Female_Face.Right_Bionic_Eye)] = 12;

//             // Cybereye = 20
//                 probs[uint(E_Female_Face.Cybereye_Left)] = 10;
//                 probs[uint(E_Female_Face.Cybereye_Right)] = 10;

//             // Cyberface = 8
//                 probs[uint(E_Female_Face.Cyberface)] = 8;
//         }

//         else if (TraitsLib.femaleIsApe(traits) || TraitsLib.femaleIsZombieApe(traits)) {
//             // Ape, Yeti, Zombie Ape can only get mole / bandage / bionic eyes / cybereyes
            
//             // None = 9377
//                 probs[uint(E_Female_Face.None)] = 9377;

//             // Mole = 200
//                 probs[uint(E_Female_Face.Mole)] = 200;

//             // Bandage = 75
//                 probs[uint(E_Female_Face.Bandage)] = 75;

//             // Bionic Eyes = 40
//                 probs[uint(E_Female_Face.Bionic_Eyes)] = 16;
//                 probs[uint(E_Female_Face.Left_Bionic_Eye)] = 12;
//                 probs[uint(E_Female_Face.Right_Bionic_Eye)] = 12;

//             // Cybereye = 20
//                 probs[uint(E_Female_Face.Cybereye_Left)] = 10;
//                 probs[uint(E_Female_Face.Cybereye_Right)] = 10;
//         }

//         else if (TraitsLib.femaleIsAlien(traits) || TraitsLib.femaleIsDemon(traits) || TraitsLib.femaleIsGhost(traits) || TraitsLib.femaleIsGlitch(traits) || TraitsLib.femaleIsGoblin(traits) || TraitsLib.femaleIsSkeleton(traits) || TraitsLib.femaleIsVampire(traits)) {
//             /// Aliens, Demons, Ghosts, Glitch, Goblins, Skeletons, Vampires can only get mole / tattoos / bandage
        
//             // None = 9570
//                 probs[uint(E_Female_Face.None)] = 9570;

//             // Mole = 200
//                 probs[uint(E_Female_Face.Mole)] = 200;
            
//             // Tattoos = 155
//                 probs[uint(E_Female_Face.Cross_Tattoo)] = 35;
//                 probs[uint(E_Female_Face.Jet_Tattoo)] = 22;
//                 probs[uint(E_Female_Face.Shotgun_Tattoo)] = 20;
//                 probs[uint(E_Female_Face.Gun_Tattoo)] = 18;
//                 probs[uint(E_Female_Face.Armor_Tattoo)] = 16;
//                 probs[uint(E_Female_Face.Sword_Tattoo)] = 14;
//                 probs[uint(E_Female_Face.Axe_Tattoo)] = 12;
//                 probs[uint(E_Female_Face.Heart_Tattoo)] = 10;
//                 probs[uint(E_Female_Face.X_Tattoo)] = 8;

//             // Bandage = 75
//                 probs[uint(E_Female_Face.Bandage)] = 75;
//         }

//         else {
//             // Invisible, Mummy, Robot, Snowman have no face traits
//             return E_Female_Face.None;
//         }

//         uint selected = Random.selectRandomTrait(rndCtx, probs);

//         return E_Female_Face(selected);
//     }

//     function selectFemaleChain(RandomCtx memory rndCtx) external pure returns (E_Female_Chain) {
//         uint16[] memory probs = new uint16[](9);

//         // None = 9000 (90%)
//             probs[uint(E_Female_Chain.None)] = 9000;

//         // Chain = 1000 (10%)
//             probs[uint(E_Female_Chain.Chain_Onyx)] = 350;
//             probs[uint(E_Female_Chain.Chain_Amethyst)] = 250;
//             probs[uint(E_Female_Chain.Chain_Gold)] = 140;
//             probs[uint(E_Female_Chain.Chain_Sapphire)] = 100;
//             probs[uint(E_Female_Chain.Chain_Emerald)] = 75;
//             probs[uint(E_Female_Chain.Chain_Ruby)] = 50;
//             probs[uint(E_Female_Chain.Chain_Diamond)] = 25;
//             probs[uint(E_Female_Chain.Chain_Pink_Diamond)] = 10;
        
//         uint selected = Random.selectRandomTrait(rndCtx, probs);

//         return E_Female_Chain(selected);
//     }

//     function selectFemaleEarring(RandomCtx memory rndCtx) external pure returns (E_Female_Earring) {
//         uint16[] memory probs = new uint16[](9);
        
//         // None = 9000
//             probs[uint(E_Female_Earring.None)] = 9000;

//         // Earring = 1000
//             probs[uint(E_Female_Earring.Earring_Onyx)] = 350;
//             probs[uint(E_Female_Earring.Earring_Amethyst)] = 250;
//             probs[uint(E_Female_Earring.Earring_Gold)] = 140;
//             probs[uint(E_Female_Earring.Earring_Sapphire)] = 100;
//             probs[uint(E_Female_Earring.Earring_Emerald)] = 75;
//             probs[uint(E_Female_Earring.Earring_Ruby)] = 50;
//             probs[uint(E_Female_Earring.Earring_Diamond)] = 25;
//             probs[uint(E_Female_Earring.Earring_Pink_Diamond)] = 10;
        
//         uint selected = Random.selectRandomTrait(rndCtx, probs);

//         return E_Female_Earring(selected);
//     }

//     function selectFemaleScarf(RandomCtx memory rndCtx) external pure returns (E_Female_Scarf) {
//         uint16[] memory probs = new uint16[](4);
        
//         // None = 9900
//             probs[uint(E_Female_Scarf.None)] = 9900;

//         // Scarf = 100
//             probs[uint(E_Female_Scarf.Blue_Scarf)] = 40;
//             probs[uint(E_Female_Scarf.Green_Scarf)] = 30;
//             probs[uint(E_Female_Scarf.Red_Scarf)] = 30;

//         uint selected = Random.selectRandomTrait(rndCtx, probs);

//         return E_Female_Scarf(selected);
//     }

//     function selectFemaleMask(RandomCtx memory rndCtx) external pure returns (E_Female_Mask) {
//         uint16[] memory probs = new uint16[](21);
        
//         // None = 9535
//             probs[uint(E_Female_Mask.None)] = 9535;

//         // Medical Mask = 240
//             probs[uint(E_Female_Mask.Medical_Mask)] = 40;
//             probs[uint(E_Female_Mask.Medical_Mask_Blue)] = 25;
//             probs[uint(E_Female_Mask.Medical_Mask_Green)] = 25;
//             probs[uint(E_Female_Mask.Medical_Mask_Orange)] = 25;
//             probs[uint(E_Female_Mask.Medical_Mask_Pink)] = 25;
//             probs[uint(E_Female_Mask.Medical_Mask_Purple)] = 25;
//             probs[uint(E_Female_Mask.Medical_Mask_Red)] = 25;
//             probs[uint(E_Female_Mask.Medical_Mask_Turquoise)] = 25;
//             probs[uint(E_Female_Mask.Medical_Mask_Yellow)] = 25;

//         // Bandana Mask = 120
//             probs[uint(E_Female_Mask.Bandana_Mask_Blue)] = 30;
//             probs[uint(E_Female_Mask.Bandana_Mask_Green)] = 30;
//             probs[uint(E_Female_Mask.Bandana_Mask_Purple)] = 30;
//             probs[uint(E_Female_Mask.Bandana_Mask_Red)] = 30;
        
//         // Ninja Mask = 60
//             probs[uint(E_Female_Mask.Ninja_Mask_Black)] = 10;
//             probs[uint(E_Female_Mask.Ninja_Mask_Blue)] = 10;
//             probs[uint(E_Female_Mask.Ninja_Mask_Brown)] = 10;
//             probs[uint(E_Female_Mask.Ninja_Mask_Purple)] = 10;
//             probs[uint(E_Female_Mask.Ninja_Mask_Red)] = 10;

//         // Gas Mask = 30
//             probs[uint(E_Female_Mask.Gas_Mask)] = 30;

//         // Metal Mask = 15
//             probs[uint(E_Female_Mask.Metal_Mask)] = 15;

//         uint selected = Random.selectRandomTrait(rndCtx, probs);

//         return E_Female_Mask(selected);
//     }

//     function selectFemaleHair(TraitsContext calldata traits, RandomCtx memory rndCtx) external pure returns (E_Female_Hair) {
//         uint16[] memory probs = new uint16[](195);
        
//         if (TraitsLib.femaleIsHuman(traits) || TraitsLib.femaleIsZombie(traits)) {
//             probs[uint(E_Female_Hair.None)] = 400;
//         }

//         else if (TraitsLib.femaleIsRobot(traits) || TraitsLib.femaleIsMummy(traits) || TraitsLib.femaleIsVampire(traits)) {
//             return E_Female_Hair.None;
//         }

//         else {
//             probs[uint(E_Female_Hair.None)] = 1200;
//         }
    
//         // Afro = 900
//             probs[uint(E_Female_Hair.Afro_Black)] = 225;
//             probs[uint(E_Female_Hair.Afro_Brown)] = 150;
//             probs[uint(E_Female_Hair.Afro_Blonde)] = 125;
//             probs[uint(E_Female_Hair.Afro_Ginger)] = 100;
//             probs[uint(E_Female_Hair.Afro_White)] = 76;

//             probs[uint(E_Female_Hair.Afro_Blue)] = 32;
//             probs[uint(E_Female_Hair.Afro_Green)] = 32;
//             probs[uint(E_Female_Hair.Afro_Orange)] = 32;
//             probs[uint(E_Female_Hair.Afro_Pink)] = 32;
//             probs[uint(E_Female_Hair.Afro_Purple)] = 32;
//             probs[uint(E_Female_Hair.Afro_Red)] = 32;
//             probs[uint(E_Female_Hair.Afro_Turquoise)] = 32;

//         // Bob = 900
//             probs[uint(E_Female_Hair.Bob_Black)] = 225;
//             probs[uint(E_Female_Hair.Bob_Brown)] = 150;
//             probs[uint(E_Female_Hair.Bob_Blonde)] = 125;
//             probs[uint(E_Female_Hair.Bob_Ginger)] = 100;
//             probs[uint(E_Female_Hair.Bob_White)] = 76;

//             probs[uint(E_Female_Hair.Bob_Blue)] = 32;
//             probs[uint(E_Female_Hair.Bob_Green)] = 32;
//             probs[uint(E_Female_Hair.Bob_Orange)] = 32;
//             probs[uint(E_Female_Hair.Bob_Pink)] = 32;
//             probs[uint(E_Female_Hair.Bob_Purple)] = 32;
//             probs[uint(E_Female_Hair.Bob_Red)] = 32;
//             probs[uint(E_Female_Hair.Bob_Turquoise)] = 32;

//         // Curly Hair = 900
//             probs[uint(E_Female_Hair.Curly_Hair_Black)] = 225;
//             probs[uint(E_Female_Hair.Curly_Hair_Brown)] = 150;
//             probs[uint(E_Female_Hair.Curly_Hair_Blonde)] = 125;
//             probs[uint(E_Female_Hair.Curly_Hair_Ginger)] = 100;
//             probs[uint(E_Female_Hair.Curly_Hair_White)] = 75;

//             probs[uint(E_Female_Hair.Curly_Hair_Blue)] = 32;
//             probs[uint(E_Female_Hair.Curly_Hair_Green)] = 32;
//             probs[uint(E_Female_Hair.Curly_Hair_Orange)] = 32;
//             probs[uint(E_Female_Hair.Curly_Hair_Pink)] = 32;
//             probs[uint(E_Female_Hair.Curly_Hair_Purple)] = 32;
//             probs[uint(E_Female_Hair.Curly_Hair_Red)] = 32;
//             probs[uint(E_Female_Hair.Curly_Hair_Turquoise)] = 32;

//         // Pigtails = 900
//             probs[uint(E_Female_Hair.Pigtails_Black)] = 225;
//             probs[uint(E_Female_Hair.Pigtails_Brown)] = 150;
//             probs[uint(E_Female_Hair.Pigtails_Blonde)] = 125;
//             probs[uint(E_Female_Hair.Pigtails_Ginger)] = 100;
//             probs[uint(E_Female_Hair.Pigtails_White)] = 76;

//             probs[uint(E_Female_Hair.Pigtails_Blue)] = 32;
//             probs[uint(E_Female_Hair.Pigtails_Green)] = 32;
//             probs[uint(E_Female_Hair.Pigtails_Orange)] = 32;
//             probs[uint(E_Female_Hair.Pigtails_Pink)] = 32;
//             probs[uint(E_Female_Hair.Pigtails_Purple)] = 32;
//             probs[uint(E_Female_Hair.Pigtails_Red)] = 32;
//             probs[uint(E_Female_Hair.Pigtails_Turquoise)] = 32;

//         // Short Straight Hair = 900
//             probs[uint(E_Female_Hair.Short_Straight_Hair_Black)] = 225;
//             probs[uint(E_Female_Hair.Short_Straight_Hair_Brown)] = 150;
//             probs[uint(E_Female_Hair.Short_Straight_Hair_Blonde)] = 125;
//             probs[uint(E_Female_Hair.Short_Straight_Hair_Ginger)] = 100;
//             probs[uint(E_Female_Hair.Short_Straight_Hair_White)] = 76;

//             probs[uint(E_Female_Hair.Short_Straight_Hair_Blue)] = 32;
//             probs[uint(E_Female_Hair.Short_Straight_Hair_Green)] = 32;
//             probs[uint(E_Female_Hair.Short_Straight_Hair_Orange)] = 32;
//             probs[uint(E_Female_Hair.Short_Straight_Hair_Pink)] = 32;
//             probs[uint(E_Female_Hair.Short_Straight_Hair_Purple)] = 32;
//             probs[uint(E_Female_Hair.Short_Straight_Hair_Red)] = 32;
//             probs[uint(E_Female_Hair.Short_Straight_Hair_Turquoise)] = 32;
        
//         // Straight Hair = 900
//             probs[uint(E_Female_Hair.Straight_Hair_Black)] = 225;
//             probs[uint(E_Female_Hair.Straight_Hair_Brown)] = 150;
//             probs[uint(E_Female_Hair.Straight_Hair_Blonde)] = 125;
//             probs[uint(E_Female_Hair.Straight_Hair_Ginger)] = 100;
//             probs[uint(E_Female_Hair.Straight_Hair_White)] = 76;

//             probs[uint(E_Female_Hair.Straight_Hair_Blue)] = 32;
//             probs[uint(E_Female_Hair.Straight_Hair_Green)] = 32;
//             probs[uint(E_Female_Hair.Straight_Hair_Orange)] = 32;
//             probs[uint(E_Female_Hair.Straight_Hair_Pink)] = 32;
//             probs[uint(E_Female_Hair.Straight_Hair_Purple)] = 32;
//             probs[uint(E_Female_Hair.Straight_Hair_Red)] = 32;
//             probs[uint(E_Female_Hair.Straight_Hair_Turquoise)] = 32;
        
//         // Long Straight Hair = 850
//             probs[uint(E_Female_Hair.Long_Straight_Hair_Black)] = 210;
//             probs[uint(E_Female_Hair.Long_Straight_Hair_Brown)] = 150;
//             probs[uint(E_Female_Hair.Long_Straight_Hair_Blonde)] = 120;
//             probs[uint(E_Female_Hair.Long_Straight_Hair_Ginger)] = 100;
//             probs[uint(E_Female_Hair.Long_Straight_Hair_White)] = 60;

//             probs[uint(E_Female_Hair.Long_Straight_Hair_Blue)] = 30;
//             probs[uint(E_Female_Hair.Long_Straight_Hair_Green)] = 30;
//             probs[uint(E_Female_Hair.Long_Straight_Hair_Orange)] = 30;
//             probs[uint(E_Female_Hair.Long_Straight_Hair_Pink)] = 30;
//             probs[uint(E_Female_Hair.Long_Straight_Hair_Purple)] = 30;
//             probs[uint(E_Female_Hair.Long_Straight_Hair_Red)] = 30;
//             probs[uint(E_Female_Hair.Long_Straight_Hair_Turquoise)] = 30;

//         // Pompadour = 850
//             probs[uint(E_Female_Hair.Pompadour_Black)] = 210;
//             probs[uint(E_Female_Hair.Pompadour_Brown)] = 150;
//             probs[uint(E_Female_Hair.Pompadour_Blonde)] = 120;
//             probs[uint(E_Female_Hair.Pompadour_Ginger)] = 100;
//             probs[uint(E_Female_Hair.Pompadour_White)] = 60;

//             probs[uint(E_Female_Hair.Pompadour_Blue)] = 30;
//             probs[uint(E_Female_Hair.Pompadour_Green)] = 30;
//             probs[uint(E_Female_Hair.Pompadour_Orange)] = 30;
//             probs[uint(E_Female_Hair.Pompadour_Pink)] = 30;
//             probs[uint(E_Female_Hair.Pompadour_Purple)] = 30;
//             probs[uint(E_Female_Hair.Pompadour_Red)] = 30;
//             probs[uint(E_Female_Hair.Pompadour_Turquoise)] = 30;

//         // Stringy Hair = 350
//             probs[uint(E_Female_Hair.Stringy_Hair_Black)] = 75;
//             probs[uint(E_Female_Hair.Stringy_Hair_Brown)] = 65;
//             probs[uint(E_Female_Hair.Stringy_Hair_Blonde)] = 50;
//             probs[uint(E_Female_Hair.Stringy_Hair_Ginger)] = 45;
//             probs[uint(E_Female_Hair.Stringy_Hair_White)] = 31;

//             probs[uint(E_Female_Hair.Stringy_Hair_Blue)] = 12;
//             probs[uint(E_Female_Hair.Stringy_Hair_Green)] = 12;
//             probs[uint(E_Female_Hair.Stringy_Hair_Orange)] = 12;
//             probs[uint(E_Female_Hair.Stringy_Hair_Pink)] = 12;
//             probs[uint(E_Female_Hair.Stringy_Hair_Purple)] = 12;
//             probs[uint(E_Female_Hair.Stringy_Hair_Red)] = 12;
//             probs[uint(E_Female_Hair.Stringy_Hair_Turquoise)] = 12;

//         // Sidecut = 350
//             probs[uint(E_Female_Hair.Sidecut_Black)] = 75;
//             probs[uint(E_Female_Hair.Sidecut_Brown)] = 65;
//             probs[uint(E_Female_Hair.Sidecut_Blonde)] = 50;
//             probs[uint(E_Female_Hair.Sidecut_Ginger)] = 45;
//             probs[uint(E_Female_Hair.Sidecut_White)] = 31;

//             probs[uint(E_Female_Hair.Sidecut_Blue)] = 12;
//             probs[uint(E_Female_Hair.Sidecut_Green)] = 12;
//             probs[uint(E_Female_Hair.Sidecut_Orange)] = 12;
//             probs[uint(E_Female_Hair.Sidecut_Pink)] = 12;
//             probs[uint(E_Female_Hair.Sidecut_Purple)] = 12;
//             probs[uint(E_Female_Hair.Sidecut_Red)] = 12;
//             probs[uint(E_Female_Hair.Sidecut_Turquoise)] = 12;

//         // Messy Hair = 350
//             probs[uint(E_Female_Hair.Messy_Hair_Black)] = 75;
//             probs[uint(E_Female_Hair.Messy_Hair_Brown)] = 65;
//             probs[uint(E_Female_Hair.Messy_Hair_Blonde)] = 50;
//             probs[uint(E_Female_Hair.Messy_Hair_Ginger)] = 45;
//             probs[uint(E_Female_Hair.Messy_Hair_White)] = 31;

//             probs[uint(E_Female_Hair.Messy_Hair_Blue)] = 12;
//             probs[uint(E_Female_Hair.Messy_Hair_Green)] = 12;
//             probs[uint(E_Female_Hair.Messy_Hair_Orange)] = 12;
//             probs[uint(E_Female_Hair.Messy_Hair_Pink)] = 12;
//             probs[uint(E_Female_Hair.Messy_Hair_Purple)] = 12;
//             probs[uint(E_Female_Hair.Messy_Hair_Red)] = 12;
//             probs[uint(E_Female_Hair.Messy_Hair_Turquoise)] = 12;
        
//         // Wild Hair = 350
//             probs[uint(E_Female_Hair.Wild_Hair_Black)] = 75;
//             probs[uint(E_Female_Hair.Wild_Hair_Brown)] = 65;
//             probs[uint(E_Female_Hair.Wild_Hair_Blonde)] = 50;
//             probs[uint(E_Female_Hair.Wild_Hair_Ginger)] = 45;
//             probs[uint(E_Female_Hair.Wild_Hair_White)] = 31;
            
//             probs[uint(E_Female_Hair.Wild_Hair_Blue)] = 12;
//             probs[uint(E_Female_Hair.Wild_Hair_Green)] = 12;
//             probs[uint(E_Female_Hair.Wild_Hair_Orange)] = 12;
//             probs[uint(E_Female_Hair.Wild_Hair_Pink)] = 12;
//             probs[uint(E_Female_Hair.Wild_Hair_Purple)] = 12;
//             probs[uint(E_Female_Hair.Wild_Hair_Red)] = 12;
//             probs[uint(E_Female_Hair.Wild_Hair_Turquoise)] = 12;
        
//         // Mohawk = 300
//             probs[uint(E_Female_Hair.Mohawk_Black)] = 75;
//             probs[uint(E_Female_Hair.Mohawk_Brown)] = 55;
//             probs[uint(E_Female_Hair.Mohawk_Blonde)] = 45;
//             probs[uint(E_Female_Hair.Mohawk_Ginger)] = 35;
//             probs[uint(E_Female_Hair.Mohawk_White)] = 17;

//             probs[uint(E_Female_Hair.Mohawk_Blue)] = 7;
//             probs[uint(E_Female_Hair.Mohawk_Green)] = 7;
//             probs[uint(E_Female_Hair.Mohawk_Orange)] = 7;
//             probs[uint(E_Female_Hair.Mohawk_Pink)] = 7;
//             probs[uint(E_Female_Hair.Mohawk_Purple)] = 7;
//             probs[uint(E_Female_Hair.Mohawk_Red)] = 7;
//             probs[uint(E_Female_Hair.Mohawk_Turquoise)] = 7;

//             probs[uint(E_Female_Hair.Mohawk_Neon_Blue)] = 6;
//             probs[uint(E_Female_Hair.Mohawk_Neon_Green)] = 6;
//             probs[uint(E_Female_Hair.Mohawk_Neon_Purple)] = 6;
//             probs[uint(E_Female_Hair.Mohawk_Neon_Red)] = 6;

//         // Short Mohawk = 300
//             probs[uint(E_Female_Hair.Short_Mohawk_Black)] = 73;
//             probs[uint(E_Female_Hair.Short_Mohawk_Brown)] = 55;
//             probs[uint(E_Female_Hair.Short_Mohawk_Blonde)] = 45;
//             probs[uint(E_Female_Hair.Short_Mohawk_Ginger)] = 35;
//             probs[uint(E_Female_Hair.Short_Mohawk_White)] = 15;

//             probs[uint(E_Female_Hair.Short_Mohawk_Blue)] = 11;
//             probs[uint(E_Female_Hair.Short_Mohawk_Green)] = 11;
//             probs[uint(E_Female_Hair.Short_Mohawk_Orange)] = 11;
//             probs[uint(E_Female_Hair.Short_Mohawk_Pink)] = 11;
//             probs[uint(E_Female_Hair.Short_Mohawk_Purple)] = 11;
//             probs[uint(E_Female_Hair.Short_Mohawk_Red)] = 11;
//             probs[uint(E_Female_Hair.Short_Mohawk_Turquoise)] = 11;

//         // Sharp Mohawk = 250
//             probs[uint(E_Female_Hair.Sharp_Mohawk_Black)] = 60;
//             probs[uint(E_Female_Hair.Sharp_Mohawk_Blonde)] = 45;
//             probs[uint(E_Female_Hair.Sharp_Mohawk_Brown)] = 35;
//             probs[uint(E_Female_Hair.Sharp_Mohawk_Ginger)] = 20;
//             probs[uint(E_Female_Hair.Sharp_Mohawk_White)] = 15;

//             probs[uint(E_Female_Hair.Sharp_Mohawk_Blue)] = 9;
//             probs[uint(E_Female_Hair.Sharp_Mohawk_Green)] = 9;
//             probs[uint(E_Female_Hair.Sharp_Mohawk_Orange)] = 9;
//             probs[uint(E_Female_Hair.Sharp_Mohawk_Pink)] = 9;
//             probs[uint(E_Female_Hair.Sharp_Mohawk_Purple)] = 9;
//             probs[uint(E_Female_Hair.Sharp_Mohawk_Red)] = 9;
//             probs[uint(E_Female_Hair.Sharp_Mohawk_Turquoise)] = 9;

//             probs[uint(E_Female_Hair.Sharp_Mohawk_Neon_Blue)] = 3;
//             probs[uint(E_Female_Hair.Sharp_Mohawk_Neon_Green)] = 3;
//             probs[uint(E_Female_Hair.Sharp_Mohawk_Neon_Purple)] = 3;
//             probs[uint(E_Female_Hair.Sharp_Mohawk_Neon_Red)] = 3;

//         // Curled Mohawk = 246
//             probs[uint(E_Female_Hair.Curled_Mohawk_Blue)] = 41;
//             probs[uint(E_Female_Hair.Curled_Mohawk_Green)] = 41;
//             probs[uint(E_Female_Hair.Curled_Mohawk_Orange)] = 41;
//             probs[uint(E_Female_Hair.Curled_Mohawk_Pink)] = 41;
//             probs[uint(E_Female_Hair.Curled_Mohawk_Purple)] = 41;
//             probs[uint(E_Female_Hair.Curled_Mohawk_Red)] = 41;

//         uint selected = Random.selectRandomTrait(rndCtx, probs);

//         return E_Female_Hair(selected);
//     }

//     function selectFemaleHatHair(TraitsContext calldata traits, RandomCtx memory rndCtx) external pure returns (E_Female_Hat_Hair) {
//         uint16[] memory probs = new uint16[](133);
        
//         if (TraitsLib.femaleIsHuman(traits) || TraitsLib.femaleIsZombie(traits)) {
//             probs[uint(E_Female_Hat_Hair.None)] = 400;
//         }

//         else if (TraitsLib.femaleIsRobot(traits) || TraitsLib.femaleIsMummy(traits) || TraitsLib.femaleIsVampire(traits)) {
//             return E_Female_Hat_Hair.None;
//         }

//         else {
//             probs[uint(E_Female_Hat_Hair.None)] = 800;
//         }

//         // Bob Hat = 900
//             probs[uint(E_Female_Hat_Hair.Bob_Black_Hat)] = 225;
//             probs[uint(E_Female_Hat_Hair.Bob_Brown_Hat)] = 150;
//             probs[uint(E_Female_Hat_Hair.Bob_Blonde_Hat)] = 125;
//             probs[uint(E_Female_Hat_Hair.Bob_Ginger_Hat)] = 100;
//             probs[uint(E_Female_Hat_Hair.Bob_White_Hat)] = 75;

//             probs[uint(E_Female_Hat_Hair.Bob_Blue_Hat)] = 33;
//             probs[uint(E_Female_Hat_Hair.Bob_Green_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Bob_Orange_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Bob_Pink_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Bob_Purple_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Bob_Red_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Bob_Turquoise_Hat)] = 32;

//         // Curly Hair Hat = 900
//             probs[uint(E_Female_Hat_Hair.Curly_Hair_Black_Hat)] = 225;
//             probs[uint(E_Female_Hat_Hair.Curly_Hair_Brown_Hat)] = 150;
//             probs[uint(E_Female_Hat_Hair.Curly_Hair_Blonde_Hat)] = 125;
//             probs[uint(E_Female_Hat_Hair.Curly_Hair_Ginger_Hat)] = 100;
//             probs[uint(E_Female_Hat_Hair.Curly_Hair_White_Hat)] = 75;

//             probs[uint(E_Female_Hat_Hair.Curly_Hair_Blue_Hat)] = 33;
//             probs[uint(E_Female_Hat_Hair.Curly_Hair_Green_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Curly_Hair_Orange_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Curly_Hair_Pink_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Curly_Hair_Purple_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Curly_Hair_Red_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Curly_Hair_Turquoise_Hat)] = 32;

//         // Short Straight Hair Hat = 900
//             probs[uint(E_Female_Hat_Hair.Short_Straight_Hair_Black_Hat)] = 225;
//             probs[uint(E_Female_Hat_Hair.Short_Straight_Hair_Brown_Hat)] = 150;
//             probs[uint(E_Female_Hat_Hair.Short_Straight_Hair_Blonde_Hat)] = 125;
//             probs[uint(E_Female_Hat_Hair.Short_Straight_Hair_Ginger_Hat)] = 100;
//             probs[uint(E_Female_Hat_Hair.Short_Straight_Hair_White_Hat)] = 75;

//             probs[uint(E_Female_Hat_Hair.Short_Straight_Hair_Blue_Hat)] = 33;
//             probs[uint(E_Female_Hat_Hair.Short_Straight_Hair_Green_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Short_Straight_Hair_Orange_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Short_Straight_Hair_Pink_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Short_Straight_Hair_Purple_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Short_Straight_Hair_Red_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Short_Straight_Hair_Turquoise_Hat)] = 32;

//         // Straight Hair Hat = 900
//             probs[uint(E_Female_Hat_Hair.Straight_Hair_Black_Hat)] = 225;
//             probs[uint(E_Female_Hat_Hair.Straight_Hair_Brown_Hat)] = 150;
//             probs[uint(E_Female_Hat_Hair.Straight_Hair_Blonde_Hat)] = 125;
//             probs[uint(E_Female_Hat_Hair.Straight_Hair_Ginger_Hat)] = 100;
//             probs[uint(E_Female_Hat_Hair.Straight_Hair_White_Hat)] = 75;

//             probs[uint(E_Female_Hat_Hair.Straight_Hair_Blue_Hat)] = 33;
//             probs[uint(E_Female_Hat_Hair.Straight_Hair_Green_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Straight_Hair_Orange_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Straight_Hair_Pink_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Straight_Hair_Purple_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Straight_Hair_Red_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Straight_Hair_Turquoise_Hat)] = 32;

//         // Long Straight Hair Hat = 850
//             probs[uint(E_Female_Hat_Hair.Long_Straight_Hair_Black_Hat)] = 208;
//             probs[uint(E_Female_Hat_Hair.Long_Straight_Hair_Brown_Hat)] = 150;
//             probs[uint(E_Female_Hat_Hair.Long_Straight_Hair_Blonde_Hat)] = 120;
//             probs[uint(E_Female_Hat_Hair.Long_Straight_Hair_Ginger_Hat)] = 100;
//             probs[uint(E_Female_Hat_Hair.Long_Straight_Hair_White_Hat)] = 60;

//             probs[uint(E_Female_Hat_Hair.Long_Straight_Hair_Blue_Hat)] = 32;
//             probs[uint(E_Female_Hat_Hair.Long_Straight_Hair_Green_Hat)] = 30;
//             probs[uint(E_Female_Hat_Hair.Long_Straight_Hair_Orange_Hat)] = 30;
//             probs[uint(E_Female_Hat_Hair.Long_Straight_Hair_Pink_Hat)] = 30;
//             probs[uint(E_Female_Hat_Hair.Long_Straight_Hair_Purple_Hat)] = 30;
//             probs[uint(E_Female_Hat_Hair.Long_Straight_Hair_Red_Hat)] = 30;
//             probs[uint(E_Female_Hat_Hair.Long_Straight_Hair_Turquoise_Hat)] = 30;

//         // Pompadour Hat = 850
//             probs[uint(E_Female_Hat_Hair.Pompadour_Black_Hat)] = 208;
//             probs[uint(E_Female_Hat_Hair.Pompadour_Brown_Hat)] = 150;
//             probs[uint(E_Female_Hat_Hair.Pompadour_Blonde_Hat)] = 120;
//             probs[uint(E_Female_Hat_Hair.Pompadour_Ginger_Hat)] = 100;
//             probs[uint(E_Female_Hat_Hair.Pompadour_White_Hat)] = 60;

//             probs[uint(E_Female_Hat_Hair.Pompadour_Blue_Hat)] = 31;
//             probs[uint(E_Female_Hat_Hair.Pompadour_Green_Hat)] = 31;
//             probs[uint(E_Female_Hat_Hair.Pompadour_Orange_Hat)] = 30;
//             probs[uint(E_Female_Hat_Hair.Pompadour_Pink_Hat)] = 30;
//             probs[uint(E_Female_Hat_Hair.Pompadour_Purple_Hat)] = 30;
//             probs[uint(E_Female_Hat_Hair.Pompadour_Red_Hat)] = 30;
//             probs[uint(E_Female_Hat_Hair.Pompadour_Turquoise_Hat)] = 30;

//         // Stringy Hair Hat = 350
//             probs[uint(E_Female_Hat_Hair.Stringy_Hair_Black_Hat)] = 75;
//             probs[uint(E_Female_Hat_Hair.Stringy_Hair_Brown_Hat)] = 65;
//             probs[uint(E_Female_Hat_Hair.Stringy_Hair_Blonde_Hat)] = 50;
//             probs[uint(E_Female_Hat_Hair.Stringy_Hair_Ginger_Hat)] = 45;
//             probs[uint(E_Female_Hat_Hair.Stringy_Hair_White_Hat)] = 28;

//             probs[uint(E_Female_Hat_Hair.Stringy_Hair_Blue_Hat)] = 13;
//             probs[uint(E_Female_Hat_Hair.Stringy_Hair_Green_Hat)] = 13;
//             probs[uint(E_Female_Hat_Hair.Stringy_Hair_Orange_Hat)] = 13;
//             probs[uint(E_Female_Hat_Hair.Stringy_Hair_Pink_Hat)] = 12;
//             probs[uint(E_Female_Hat_Hair.Stringy_Hair_Purple_Hat)] = 12;
//             probs[uint(E_Female_Hat_Hair.Stringy_Hair_Red_Hat)] = 12;
//             probs[uint(E_Female_Hat_Hair.Stringy_Hair_Turquoise_Hat)] = 12;

//         // Sidecut Hat = 350
//             probs[uint(E_Female_Hat_Hair.Sidecut_Black_Hat)] = 75;
//             probs[uint(E_Female_Hat_Hair.Sidecut_Brown_Hat)] = 65;
//             probs[uint(E_Female_Hat_Hair.Sidecut_Blonde_Hat)] = 50;
//             probs[uint(E_Female_Hat_Hair.Sidecut_Ginger_Hat)] = 45;
//             probs[uint(E_Female_Hat_Hair.Sidecut_White_Hat)] = 28;

//             probs[uint(E_Female_Hat_Hair.Sidecut_Blue_Hat)] = 13;
//             probs[uint(E_Female_Hat_Hair.Sidecut_Green_Hat)] = 13;
//             probs[uint(E_Female_Hat_Hair.Sidecut_Orange_Hat)] = 13;
//             probs[uint(E_Female_Hat_Hair.Sidecut_Pink_Hat)] = 12;
//             probs[uint(E_Female_Hat_Hair.Sidecut_Purple_Hat)] = 12;
//             probs[uint(E_Female_Hat_Hair.Sidecut_Red_Hat)] = 12;
//             probs[uint(E_Female_Hat_Hair.Sidecut_Turquoise_Hat)] = 12;

//         // Messy Hair Hat = 350
//             probs[uint(E_Female_Hat_Hair.Messy_Hair_Black_Hat)] = 75;
//             probs[uint(E_Female_Hat_Hair.Messy_Hair_Brown_Hat)] = 65;
//             probs[uint(E_Female_Hat_Hair.Messy_Hair_Blonde_Hat)] = 50;
//             probs[uint(E_Female_Hat_Hair.Messy_Hair_Ginger_Hat)] = 45;
//             probs[uint(E_Female_Hat_Hair.Messy_Hair_White_Hat)] = 28;

//             probs[uint(E_Female_Hat_Hair.Messy_Hair_Blue_Hat)] = 13;
//             probs[uint(E_Female_Hat_Hair.Messy_Hair_Green_Hat)] = 13;
//             probs[uint(E_Female_Hat_Hair.Messy_Hair_Orange_Hat)] = 13;
//             probs[uint(E_Female_Hat_Hair.Messy_Hair_Pink_Hat)] = 12;
//             probs[uint(E_Female_Hat_Hair.Messy_Hair_Purple_Hat)] = 12;
//             probs[uint(E_Female_Hat_Hair.Messy_Hair_Red_Hat)] = 12;
//             probs[uint(E_Female_Hat_Hair.Messy_Hair_Turquoise_Hat)] = 12;

//         // Wild Hair Hat = 350
//             probs[uint(E_Female_Hat_Hair.Wild_Hair_Black_Hat)] = 75;
//             probs[uint(E_Female_Hat_Hair.Wild_Hair_Brown_Hat)] = 65;
//             probs[uint(E_Female_Hat_Hair.Wild_Hair_Blonde_Hat)] = 50;
//             probs[uint(E_Female_Hat_Hair.Wild_Hair_Ginger_Hat)] = 45;
//             probs[uint(E_Female_Hat_Hair.Wild_Hair_White_Hat)] = 28;

//             probs[uint(E_Female_Hat_Hair.Wild_Hair_Blue_Hat)] = 13;
//             probs[uint(E_Female_Hat_Hair.Wild_Hair_Green_Hat)] = 13;
//             probs[uint(E_Female_Hat_Hair.Wild_Hair_Orange_Hat)] = 13;
//             probs[uint(E_Female_Hat_Hair.Wild_Hair_Pink_Hat)] = 12;
//             probs[uint(E_Female_Hat_Hair.Wild_Hair_Purple_Hat)] = 12;
//             probs[uint(E_Female_Hat_Hair.Wild_Hair_Red_Hat)] = 12;
//             probs[uint(E_Female_Hat_Hair.Wild_Hair_Turquoise_Hat)] = 12;
        
//         // Short Mohawk Hat = 300
//             probs[uint(E_Female_Hat_Hair.Short_Mohawk_Black_Hat)] = 75;
//             probs[uint(E_Female_Hat_Hair.Short_Mohawk_Brown_Hat)] = 55;
//             probs[uint(E_Female_Hat_Hair.Short_Mohawk_Blonde_Hat)] = 45;
//             probs[uint(E_Female_Hat_Hair.Short_Mohawk_Ginger_Hat)] = 35;
//             probs[uint(E_Female_Hat_Hair.Short_Mohawk_White_Hat)] = 15;

//             probs[uint(E_Female_Hat_Hair.Short_Mohawk_Blue_Hat)] = 11;
//             probs[uint(E_Female_Hat_Hair.Short_Mohawk_Green_Hat)] = 11;
//             probs[uint(E_Female_Hat_Hair.Short_Mohawk_Orange_Hat)] = 11;
//             probs[uint(E_Female_Hat_Hair.Short_Mohawk_Pink_Hat)] = 11;
//             probs[uint(E_Female_Hat_Hair.Short_Mohawk_Purple_Hat)] = 11;
//             probs[uint(E_Female_Hat_Hair.Short_Mohawk_Red_Hat)] = 10;
//             probs[uint(E_Female_Hat_Hair.Short_Mohawk_Turquoise_Hat)] = 10;

//         uint selected = Random.selectRandomTrait(rndCtx, probs);

//         return E_Female_Hat_Hair(selected);
//     }

//     function selectFemaleHeadwear(RandomCtx memory rndCtx) external pure returns (E_Female_Headwear) {
//         uint16[] memory probs = new uint16[](131);

//         // None = 871
//             probs[uint(E_Female_Headwear.None)] = 871;
//         // Tier 1 = 5123

//             // Sweatband = 850
//                 probs[uint(E_Female_Headwear.Sweatband_Black)] = 85;
//                 probs[uint(E_Female_Headwear.Sweatband_Blue)] = 85;
//                 probs[uint(E_Female_Headwear.Sweatband_Green)] = 85;
//                 probs[uint(E_Female_Headwear.Sweatband_Orange)] = 85;
//                 probs[uint(E_Female_Headwear.Sweatband_Pink)] = 85;
//                 probs[uint(E_Female_Headwear.Sweatband_Purple)] = 85;
//                 probs[uint(E_Female_Headwear.Sweatband_Red)] = 85;
//                 probs[uint(E_Female_Headwear.Sweatband_Turquoise)] = 85;
//                 probs[uint(E_Female_Headwear.Sweatband_White)] = 85;
//                 probs[uint(E_Female_Headwear.Sweatband_Yellow)] = 85;

//             // Cap = 750
//                 probs[uint(E_Female_Headwear.Cap_Blue)] = 150;
//                 probs[uint(E_Female_Headwear.Cap_Green)] = 150;
//                 probs[uint(E_Female_Headwear.Cap_Purple)] = 150;
//                 probs[uint(E_Female_Headwear.Cap_Red)] = 150;
//                 probs[uint(E_Female_Headwear.Cap)] = 150;

//             // Backwards Cap = 730
//                 probs[uint(E_Female_Headwear.Backwards_Cap_Blue)] = 146;
//                 probs[uint(E_Female_Headwear.Backwards_Cap_Green)] = 146;
//                 probs[uint(E_Female_Headwear.Backwards_Cap_Grey)] = 146;
//                 probs[uint(E_Female_Headwear.Backwards_Cap_Purple)] = 146;
//                 probs[uint(E_Female_Headwear.Backwards_Cap_Red)] = 146;

//             // Snapback Cap = 720
//                 probs[uint(E_Female_Headwear.Snapback_Cap_Blue)] = 90;
//                 probs[uint(E_Female_Headwear.Snapback_Cap_Green)] = 90;
//                 probs[uint(E_Female_Headwear.Snapback_Cap_Orange)] = 90;
//                 probs[uint(E_Female_Headwear.Snapback_Cap_Pink)] = 90;
//                 probs[uint(E_Female_Headwear.Snapback_Cap_Purple)] = 90;
//                 probs[uint(E_Female_Headwear.Snapback_Cap_Red)] = 90;
//                 probs[uint(E_Female_Headwear.Snapback_Cap_Turquoise)] = 90;
//                 probs[uint(E_Female_Headwear.Snapback_Cap_Yellow)] = 90;

//             // Beanie = 720
//                 probs[uint(E_Female_Headwear.Beanie_Blue)] = 80;
//                 probs[uint(E_Female_Headwear.Beanie_Brown)] = 80;
//                 probs[uint(E_Female_Headwear.Beanie_Green)] = 80;
//                 probs[uint(E_Female_Headwear.Beanie_Orange)] = 80;
//                 probs[uint(E_Female_Headwear.Beanie_Pink)] = 80;
//                 probs[uint(E_Female_Headwear.Beanie_Purple)] = 80;
//                 probs[uint(E_Female_Headwear.Beanie_Red)] = 80;
//                 probs[uint(E_Female_Headwear.Beanie_Turquoise)] = 80;
//                 probs[uint(E_Female_Headwear.Beanie_White)] = 80;

//             // Winter Hat = 696
//                 probs[uint(E_Female_Headwear.Winter_Hat_Blue)] = 87;
//                 probs[uint(E_Female_Headwear.Winter_Hat_Brown)] = 87;
//                 probs[uint(E_Female_Headwear.Winter_Hat_Green)] = 87;
//                 probs[uint(E_Female_Headwear.Winter_Hat_Orange)] = 87;
//                 probs[uint(E_Female_Headwear.Winter_Hat_Pink)] = 87;
//                 probs[uint(E_Female_Headwear.Winter_Hat_Purple)] = 87;
//                 probs[uint(E_Female_Headwear.Winter_Hat_Red)] = 87;
//                 probs[uint(E_Female_Headwear.Winter_Hat_Turquoise)] = 87;

//             // Bandana = 657
//                 probs[uint(E_Female_Headwear.Bandana_Black)] = 73;
//                 probs[uint(E_Female_Headwear.Bandana_Blue)] = 73;
//                 probs[uint(E_Female_Headwear.Bandana_Green)] = 73;
//                 probs[uint(E_Female_Headwear.Bandana_Orange)] = 73;
//                 probs[uint(E_Female_Headwear.Bandana_Pink)] = 73;
//                 probs[uint(E_Female_Headwear.Bandana_Purple)] = 73;
//                 probs[uint(E_Female_Headwear.Bandana_Red)] = 73;
//                 probs[uint(E_Female_Headwear.Bandana_Turquoise)] = 73;
//                 probs[uint(E_Female_Headwear.Bandana_White)] = 73;
//         // Tier 2 = 2485

//             // Headphones = 375
//                 probs[uint(E_Female_Headwear.Headphones)] = 375;
        
//             // Hoodie = 370
//                 probs[uint(E_Female_Headwear.Hoodie_Blue)] = 74;
//                 probs[uint(E_Female_Headwear.Hoodie_Green)] = 74;
//                 probs[uint(E_Female_Headwear.Hoodie_Purple)] = 74;
//                 probs[uint(E_Female_Headwear.Hoodie_Red)] = 74;
//                 probs[uint(E_Female_Headwear.Hoodie)] = 74;

//             // Visor = 364
//                 probs[uint(E_Female_Headwear.Visor_Black)] = 91;
//                 probs[uint(E_Female_Headwear.Visor_Blue)] = 91;
//                 probs[uint(E_Female_Headwear.Visor_Red)] = 91;
//                 probs[uint(E_Female_Headwear.Visor_White)] = 91;
        
//             // Tassle Hat = 352
//                 probs[uint(E_Female_Headwear.Tassle_Hat_Blue)] = 44;
//                 probs[uint(E_Female_Headwear.Tassle_Hat_Green)] = 44;
//                 probs[uint(E_Female_Headwear.Tassle_Hat_Orange)] = 44;
//                 probs[uint(E_Female_Headwear.Tassle_Hat_Pink)] = 44;
//                 probs[uint(E_Female_Headwear.Tassle_Hat_Purple)] = 44;
//                 probs[uint(E_Female_Headwear.Tassle_Hat_Red)] = 44;
//                 probs[uint(E_Female_Headwear.Tassle_Hat_Sky_Blue)] = 44;
//                 probs[uint(E_Female_Headwear.Tassle_Hat_Turquoise)] = 44;
        
//             // Sherpa Hat = 348
//                 probs[uint(E_Female_Headwear.Sherpa_Hat_Blue)] = 116;
//                 probs[uint(E_Female_Headwear.Sherpa_Hat_Brown)] = 116;
//                 probs[uint(E_Female_Headwear.Sherpa_Hat_Red)] = 116;
            
//             // Welding Goggles = 340
//                 probs[uint(E_Female_Headwear.Welding_Goggles)] = 340;

//             // Ninja Headband = 336
//                 probs[uint(E_Female_Headwear.Ninja_Headband_Black)] = 48;
//                 probs[uint(E_Female_Headwear.Ninja_Headband_Blue)] = 48;
//                 probs[uint(E_Female_Headwear.Ninja_Headband_Brown)] = 48;
//                 probs[uint(E_Female_Headwear.Ninja_Headband_Green)] = 48;
//                 probs[uint(E_Female_Headwear.Ninja_Headband_Orange)] = 48;
//                 probs[uint(E_Female_Headwear.Ninja_Headband_Purple)] = 48;
//                 probs[uint(E_Female_Headwear.Ninja_Headband_Red)] = 48;

//         // Tier 3 = 983
                
//             // Aviator Helmet = 225
//                 probs[uint(E_Female_Headwear.Aviator_Helmet)] = 225;

//             // Cowgirl Hat = 216
//                 probs[uint(E_Female_Headwear.Cowgirl_Hat_Beige)] = 24;
//                 probs[uint(E_Female_Headwear.Cowgirl_Hat_Black)] = 24;
//                 probs[uint(E_Female_Headwear.Cowgirl_Hat_Burgundy)] = 24;
//                 probs[uint(E_Female_Headwear.Cowgirl_Hat_Dark)] = 24;
//                 probs[uint(E_Female_Headwear.Cowgirl_Hat_Grey)] = 24;
//                 probs[uint(E_Female_Headwear.Cowgirl_Hat_Light)] = 24;
//                 probs[uint(E_Female_Headwear.Cowgirl_Hat_Navy)] = 24;
//                 probs[uint(E_Female_Headwear.Cowgirl_Hat_White)] = 24;
//                 probs[uint(E_Female_Headwear.Cowgirl_Hat)] = 24;
        
//             // Cavalier Hat = 200
//                 probs[uint(E_Female_Headwear.Cavalier_Hat)] = 200;

//             // Beret = 192
//                 probs[uint(E_Female_Headwear.Beret_Black)] = 64;
//                 probs[uint(E_Female_Headwear.Beret_Blue)] = 64;
//                 probs[uint(E_Female_Headwear.Beret_Red)] = 64;

//             // Military Beret = 150
//                 probs[uint(E_Female_Headwear.Military_Beret_Brown)] = 50;
//                 probs[uint(E_Female_Headwear.Military_Beret_Green)] = 50;
//                 probs[uint(E_Female_Headwear.Military_Beret_Red)] = 50;   
        
//         // Tier 4 = 538

//                 // Police Cap = 75
//                     probs[uint(E_Female_Headwear.Police_Cap)] = 75;

//                 // Santa Hat = 65
//                     probs[uint(E_Female_Headwear.Santa_Hat_Green)] = 40;
//                     probs[uint(E_Female_Headwear.Santa_Hat)] = 25;

//                 // Jester Hat = 65
//                     probs[uint(E_Female_Headwear.Jester_Hat)] = 65;

//                 // Kitty Ears = 60
//                     probs[uint(E_Female_Headwear.Kitty_Ears_Brown)] = 15;
//                     probs[uint(E_Female_Headwear.Kitty_Ears_Pink)] = 15;
//                     probs[uint(E_Female_Headwear.Kitty_Ears_Purple)] = 15;
//                     probs[uint(E_Female_Headwear.Kitty_Ears_White)] = 15;

//                 // Viking Hat = 55
//                     probs[uint(E_Female_Headwear.Viking_Hat)] = 55;  

//                 // Pirate Hat = 50
//                     probs[uint(E_Female_Headwear.Pirate_Hat)] = 50;

//                 // Cloak = 42
//                     probs[uint(E_Female_Headwear.Cloak_Black)] = 6;
//                     probs[uint(E_Female_Headwear.Cloak)] = 6;
//                     probs[uint(E_Female_Headwear.Cloak_Blue)] = 6;
//                     probs[uint(E_Female_Headwear.Cloak_Green)] = 6;
//                     probs[uint(E_Female_Headwear.Cloak_Purple)] = 6;
//                     probs[uint(E_Female_Headwear.Cloak_Red)] = 6;
//                     probs[uint(E_Female_Headwear.Cloak_White)] = 6;

//                 // Witch Hat = 40
//                     probs[uint(E_Female_Headwear.Witch_Hat_Blue)] = 5;
//                     probs[uint(E_Female_Headwear.Witch_Hat_Green)] = 5;
//                     probs[uint(E_Female_Headwear.Witch_Hat_Orange)] = 5;
//                     probs[uint(E_Female_Headwear.Witch_Hat_Pink)] = 5;
//                     probs[uint(E_Female_Headwear.Witch_Hat_Purple)] = 5;
//                     probs[uint(E_Female_Headwear.Witch_Hat_Red)] = 5;
//                     probs[uint(E_Female_Headwear.Witch_Hat_Turquoise)] = 5;
//                     probs[uint(E_Female_Headwear.Witch_Hat)] = 5;

//                 // Tiara = 35
//                     probs[uint(E_Female_Headwear.Tiara_Silver)] = 25;
//                     probs[uint(E_Female_Headwear.Tiara_Gold)] = 10;

//                 // Halo = 30
//                     probs[uint(E_Female_Headwear.Halo)] = 30;

//                 // Devil Horns = 15
//                     probs[uint(E_Female_Headwear.Demon_Horns)] = 15;

//                 // Queen Crown = 3
//                     probs[uint(E_Female_Headwear.Queen_Crown)] = 3;
        
        

//         uint selected = Random.selectRandomTrait(rndCtx, probs);

//         return E_Female_Headwear(selected);
//     }

//     function selectFemaleEyeWear(RandomCtx memory rndCtx) external pure returns (E_Female_Eye_Wear) {
//         uint16[] memory probs = new uint16[](122);

//         // None = 968
//             probs[uint(E_Female_Eye_Wear.None)] = 968;

//         // Tier 1 = 4144

//             // Regular Shades = 628
//                 probs[uint(E_Female_Eye_Wear.Regular_Glasses)] = 628;

//             // Square Glasses = 576
//                 probs[uint(E_Female_Eye_Wear.Square_Glasses)] = 64;
//                 probs[uint(E_Female_Eye_Wear.Square_Glasses_Blue)] = 64;
//                 probs[uint(E_Female_Eye_Wear.Square_Glasses_Green)] = 64;
//                 probs[uint(E_Female_Eye_Wear.Square_Glasses_Orange)] = 64;
//                 probs[uint(E_Female_Eye_Wear.Square_Glasses_Pink)] = 64;
//                 probs[uint(E_Female_Eye_Wear.Square_Glasses_Purple)] = 64;
//                 probs[uint(E_Female_Eye_Wear.Square_Glasses_Red)] = 64;
//                 probs[uint(E_Female_Eye_Wear.Square_Glasses_Turquoise)] = 64;
//                 probs[uint(E_Female_Eye_Wear.Square_Glasses_Yellow)] = 64;

//             // Circle Glasses = 576
//                 probs[uint(E_Female_Eye_Wear.Circle_Glasses)] = 64;
//                 probs[uint(E_Female_Eye_Wear.Circle_Glasses_Blue)] = 64;
//                 probs[uint(E_Female_Eye_Wear.Circle_Glasses_Green)] = 64;
//                 probs[uint(E_Female_Eye_Wear.Circle_Glasses_Orange)] = 64;
//                 probs[uint(E_Female_Eye_Wear.Circle_Glasses_Pink)] = 64;
//                 probs[uint(E_Female_Eye_Wear.Circle_Glasses_Purple)] = 64;
//                 probs[uint(E_Female_Eye_Wear.Circle_Glasses_Red)] = 64;
//                 probs[uint(E_Female_Eye_Wear.Circle_Glasses_Turquoise)] = 64;
//                 probs[uint(E_Female_Eye_Wear.Circle_Glasses_Yellow)] = 64;

//             // Horn Rimmed Glasses = 570
//                 probs[uint(E_Female_Eye_Wear.Horn_Rimmed_Glasses)] = 570;

//             // Nerd Glasses = 560
//                 probs[uint(E_Female_Eye_Wear.Nerd_Glasses)] = 560;

//             // Shades = 550
//                 probs[uint(E_Female_Eye_Wear.Shades_Blue)] = 50;
//                 probs[uint(E_Female_Eye_Wear.Shades_Gold)] = 50;
//                 probs[uint(E_Female_Eye_Wear.Shades_Green)] = 50;
//                 probs[uint(E_Female_Eye_Wear.Shades_Hot_Pink)] = 50;
//                 probs[uint(E_Female_Eye_Wear.Shades_Orange)] = 50;
//                 probs[uint(E_Female_Eye_Wear.Shades_Pink)] = 50;
//                 probs[uint(E_Female_Eye_Wear.Shades_Purple)] = 50;
//                 probs[uint(E_Female_Eye_Wear.Shades_Red)] = 50;
//                 probs[uint(E_Female_Eye_Wear.Shades_Sky_Blue)] = 50;
//                 probs[uint(E_Female_Eye_Wear.Shades_Turquoise)] = 50;
//                 probs[uint(E_Female_Eye_Wear.Shades_Yellow)] = 50;

//             // Eye Mask = 540
//                 probs[uint(E_Female_Eye_Wear.Eye_Mask)] = 540;
        

//         // Tier 2 = 3000

//             // Big Shades = 506
//                 probs[uint(E_Female_Eye_Wear.Big_Shades_Blue)] = 46;
//                 probs[uint(E_Female_Eye_Wear.Big_Shades_Golden)] = 46;
//                 probs[uint(E_Female_Eye_Wear.Big_Shades_Green)] = 46;
//                 probs[uint(E_Female_Eye_Wear.Big_Shades_Hot_Pink)] = 46;
//                 probs[uint(E_Female_Eye_Wear.Big_Shades_Orange)] = 46;
//                 probs[uint(E_Female_Eye_Wear.Big_Shades_Pink)] = 46;
//                 probs[uint(E_Female_Eye_Wear.Big_Shades_Purple)] = 46;
//                 probs[uint(E_Female_Eye_Wear.Big_Shades_Red)] = 46;
//                 probs[uint(E_Female_Eye_Wear.Big_Shades_Sky_Blue)] = 46;
//                 probs[uint(E_Female_Eye_Wear.Big_Shades_Turquoise)] = 46;
//                 probs[uint(E_Female_Eye_Wear.Big_Shades_Yellow)] = 46;

//             // 3D Glasses = 475
//                 probs[uint(E_Female_Eye_Wear._3D_Glasses)] = 475;

//             // Blue Light Blocking Glasses = 475
//                 probs[uint(E_Female_Eye_Wear.Blue_Light_Blocking_Glasses)] = 475;

//             // Retro Shades = 425
//                 probs[uint(E_Female_Eye_Wear.Retro_Shades)] = 425;

//             // Gangster Shades = 400
//                 probs[uint(E_Female_Eye_Wear.Gangster_Shades)] = 400;

//             // Heart Shades = 372
//                 probs[uint(E_Female_Eye_Wear.Heart_Shades_Blue)] = 62;
//                 probs[uint(E_Female_Eye_Wear.Heart_Shades_Green)] = 62;
//                 probs[uint(E_Female_Eye_Wear.Heart_Shades_Orange)] = 62;
//                 probs[uint(E_Female_Eye_Wear.Heart_Shades_Pink)] = 62;
//                 probs[uint(E_Female_Eye_Wear.Heart_Shades_Purple)] = 62;
//                 probs[uint(E_Female_Eye_Wear.Heart_Shades)] = 62;

//             // Steampunk Glasses = 347
//                 probs[uint(E_Female_Eye_Wear.Steampunk_Glasses)] = 347;
        

//         // Tier 3 = 1500

//             // Eye Patch = 317
//                 probs[uint(E_Female_Eye_Wear.Eye_Patch)] = 317;

//             // Enhanced 3D Glasses = 280
//                 probs[uint(E_Female_Eye_Wear.Enhanced_3D_Glasses)] = 280;

//             // Pirate Eye Patch = 225
//                 probs[uint(E_Female_Eye_Wear.Pirate_Eye_Patch)] = 225;

//             // Futuristic Shades = 196
//                 probs[uint(E_Female_Eye_Wear.Futuristic_Shades_Blue)] = 28;
//                 probs[uint(E_Female_Eye_Wear.Futuristic_Shades_Green)] = 28;
//                 probs[uint(E_Female_Eye_Wear.Futuristic_Shades_Orange)] = 28;
//                 probs[uint(E_Female_Eye_Wear.Futuristic_Shades_Pink)] = 28;
//                 probs[uint(E_Female_Eye_Wear.Futuristic_Shades_Purple)] = 28;
//                 probs[uint(E_Female_Eye_Wear.Futuristic_Shades_Red)] = 28;
//                 probs[uint(E_Female_Eye_Wear.Futuristic_Shades_Turquoise)] = 28;

//             // Bionic Eye Patch = 160
//                 probs[uint(E_Female_Eye_Wear.Bionic_Eye_Patch_Blue)] = 20;
//                 probs[uint(E_Female_Eye_Wear.Bionic_Eye_Patch_Green)] = 20;
//                 probs[uint(E_Female_Eye_Wear.Bionic_Eye_Patch_Orange)] = 20;
//                 probs[uint(E_Female_Eye_Wear.Bionic_Eye_Patch_Pink)] = 20;
//                 probs[uint(E_Female_Eye_Wear.Bionic_Eye_Patch_Purple)] = 20;
//                 probs[uint(E_Female_Eye_Wear.Bionic_Eye_Patch_Red)] = 20;
//                 probs[uint(E_Female_Eye_Wear.Bionic_Eye_Patch_Turquoise)] = 20;
//                 probs[uint(E_Female_Eye_Wear.Bionic_Eye_Patch_Yellow)] = 20;

//             // VR Headset = 132
//                 probs[uint(E_Female_Eye_Wear.VR_Headset_Blue)] = 33;
//                 probs[uint(E_Female_Eye_Wear.VR_Headset_Green)] = 33;
//                 probs[uint(E_Female_Eye_Wear.VR_Headset_Red)] = 33;
//                 probs[uint(E_Female_Eye_Wear.VR_Headset)] = 33;

//             // AR Headset = 110
//                 probs[uint(E_Female_Eye_Wear.AR_Headset_Blue)] = 22;
//                 probs[uint(E_Female_Eye_Wear.AR_Headset_Green)] = 22;
//                 probs[uint(E_Female_Eye_Wear.AR_Headset_Pink)] = 22;
//                 probs[uint(E_Female_Eye_Wear.AR_Headset_Purple)] = 22;
//                 probs[uint(E_Female_Eye_Wear.AR_Headset_Red)] = 22;
                
//             // AR Shades: 80
//                 probs[uint(E_Female_Eye_Wear.AR_Shades_Blue)] = 10;
//                 probs[uint(E_Female_Eye_Wear.AR_Shades_Green)] = 10;
//                 probs[uint(E_Female_Eye_Wear.AR_Shades_Orange)] = 10;
//                 probs[uint(E_Female_Eye_Wear.AR_Shades_Pink)] = 10;
//                 probs[uint(E_Female_Eye_Wear.AR_Shades_Purple)] = 10;
//                 probs[uint(E_Female_Eye_Wear.AR_Shades_Red)] = 10;
//                 probs[uint(E_Female_Eye_Wear.AR_Shades_Turquoise)] = 10;
//                 probs[uint(E_Female_Eye_Wear.AR_Shades_Yellow)] = 10;


//         // Tier 4 = 214

//             // Rainbow Shades = 69
//                 probs[uint(E_Female_Eye_Wear.Rainbow_Shades)] = 69;

//             // XR Headset = 45
//                 probs[uint(E_Female_Eye_Wear.XR_Headset_Blue)] = 5;
//                 probs[uint(E_Female_Eye_Wear.XR_Headset_Green)] = 5;
//                 probs[uint(E_Female_Eye_Wear.XR_Headset_Orange)] = 5;
//                 probs[uint(E_Female_Eye_Wear.XR_Headset_Pink)] = 5;
//                 probs[uint(E_Female_Eye_Wear.XR_Headset_Purple)] = 5;
//                 probs[uint(E_Female_Eye_Wear.XR_Headset_Red)] = 5;
//                 probs[uint(E_Female_Eye_Wear.XR_Headset_Sky_Blue)] = 5;
//                 probs[uint(E_Female_Eye_Wear.XR_Headset_Turquoise)] = 5;
//                 probs[uint(E_Female_Eye_Wear.XR_Headset_Yellow)] = 5;

//             // Matrix Headset = 40
//                 probs[uint(E_Female_Eye_Wear.Matrix_Headset_Blue)] = 5;
//                 probs[uint(E_Female_Eye_Wear.Matrix_Headset_Green)] = 5;
//                 probs[uint(E_Female_Eye_Wear.Matrix_Headset_Orange)] = 5;
//                 probs[uint(E_Female_Eye_Wear.Matrix_Headset_Pink)] = 5;
//                 probs[uint(E_Female_Eye_Wear.Matrix_Headset_Purple)] = 5;
//                 probs[uint(E_Female_Eye_Wear.Matrix_Headset_Red)] = 5;
//                 probs[uint(E_Female_Eye_Wear.Matrix_Headset_Turquoise)] = 5;
//                 probs[uint(E_Female_Eye_Wear.Matrix_Headset_Yellow)] = 5;

//             // Scouter = 27
//                 probs[uint(E_Female_Eye_Wear.Scouter_Blue)] = 3;
//                 probs[uint(E_Female_Eye_Wear.Scouter_Green)] = 3;
//                 probs[uint(E_Female_Eye_Wear.Scouter_Orange)] = 3;
//                 probs[uint(E_Female_Eye_Wear.Scouter_Pink)] = 3;
//                 probs[uint(E_Female_Eye_Wear.Scouter_Purple)] = 3;
//                 probs[uint(E_Female_Eye_Wear.Scouter_Red)] = 3;
//                 probs[uint(E_Female_Eye_Wear.Scouter_Turquoise)] = 3;
//                 probs[uint(E_Female_Eye_Wear.Scouter_Yellow)] = 3;
//                 probs[uint(E_Female_Eye_Wear.Scouter)] = 3;

//             // Cyclops Visor = 23
//                 probs[uint(E_Female_Eye_Wear.Cyclops_Visor)] = 23;

//             // Laser Beam = 10
//                 probs[uint(E_Female_Eye_Wear.Laser_Beam)] = 4;
//                 probs[uint(E_Female_Eye_Wear.Laser_Beam_Blue)] = 3;
//                 probs[uint(E_Female_Eye_Wear.Laser_Beam_Green)] = 3;

//         uint selected = Random.selectRandomTrait(rndCtx, probs);

//         return E_Female_Eye_Wear(selected);
//     }
// }