// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { IFemaleProbs } from './interfaces/IFemaleProbs.sol';
import { E_Female_Skin, E_Female_Eyes, E_Female_Face, E_Female_Chain, E_Female_Earring, E_Female_Scarf, E_Female_Mask, E_Female_Hair, E_Female_Hat_Hair, E_Female_Headwear, E_Female_Eye_Wear } from "./common/Enums.sol";
import { TraitsContext, FemaleTraits } from './common/Structs.sol';
import { LibPRNG } from "./libraries/LibPRNG.sol";
import { LibTraits } from "./libraries/LibTraits.sol";

/**
 * @author ECHO
 */

contract FemaleProbs is IFemaleProbs {

    bytes private constant SKIN_PROBS = hex"0000001900E1000F002D0041001402EE02EE02EE02EE02EE02EE02EE02EE02EE02EE02EE02EE00080019005A0016000A012C0096";
    
    bytes private constant EYES_PROBS = hex"000000320064000B000B000B000B000B000B000B000B000B00FA001E001E001E001E001E001E001E001E101D00190019101D007D01F401F4004B";

    bytes private constant FACE_PROBS_A = hex"24A10010000C004B0010007D0023000A000A00080012000A0016000C00C8000C0014000E0008";
    bytes private constant FACE_PROBS_B = hex"25C100000000004B001000000000000A000A0000000000000000000C00C8000C000000000000";
    bytes private constant FACE_PROBS_C = hex"25620010000C004B0000000000230000000000000012000A0016000000C800000014000E0008";

    bytes private constant CHAIN_PROBS = hex"232800FA0019004B008C015E000A00320064";

    bytes private constant EARRING_PROBS = hex"232800FA0019004B008C015E000A00320064";

    bytes private constant MASK_PROBS = hex"253F001E001E001E001E001E002800190019001900190019001900190019000F000A000A000A000A000A";

    bytes private constant SCARF_PROBS = hex"26AC0028001E001E";

    bytes private constant HAIR_PROBS = hex"000000E1007D002000960064002000200020002000200020004C00E1007D002000960064002000200020002000200020004C00290029002900290029002900E1007D002000960064002000200020002000200020004B00D20078001E00960064001E001E001E001E001E001E003C004B0032000C0041002D000C000C000C000C000C000C001F004B002D0007003700230007000600060006000600070007000700070007001100E1007D002000960064002000200020002000200020004C00D20078001E00960064001E001E001E001E001E001E003C003C002D0009002300140009000300030003000300090009000900090009000F0049002D000B00370023000B000B000B000B000B000B000F00E1007D002000960064002000200020002000200020004C004B0032000C0041002D000C000C000C000C000C000C001F00E1007D002000960064002000200020002000200020004C004B0032000C0041002D000C000C000C000C000C000C001F004B0032000C0041002D000C000C000C000C000C000C001F";

    bytes private constant HAT_HAIR_PROBS = hex"000000E1007D002100960064002000200020002000200020004B00E1007D002100960064002000200020002000200020004B00D00078002000960064001E001E001E001E001E001E003C004B0032000D0041002D000D000D000C000C000C000C001C00D00078001F00960064001F001E001E001E001E001E003C004B002D000B00370023000B000B000B000B000A000A000F00E1007D002100960064002000200020002000200020004B004B0032000D0041002D000D000D000C000C000C000C001C00E1007D002100960064002000200020002000200020004B004B0032000D0041002D000D000D000C000C000C000C001C004B0032000D0041002D000D000D000C000C000C000C001C";

    bytes private constant HEADWEAR_PROBS = hex"036700E1009200920092009200920049004900490049004900490049004900490050005000500050005000500050005000500040004000400096009600960096009600C80006000600060006000600060006001800180018001800180018001800180018000F001E0177004A004A004A004A004A0041000F000F000F000F00320032003200300030003000300030003000300032004B000300190028007400740074005A005A005A005A005A005A005A005A0055005500550055005500550055005500550055002C002C002C002C002C002C002C002C000A00190037005B005B005B005B01540057005700570057005700570057005700050005000500050005000500050005";

    bytes private constant EYEWEAR_PROBS = hex"03C801DB00160016001600160016000A000A000A000A000A000A000A000A002E002E002E002E002E002E002E002E002E002E002E0014001400140014001400140014001401DB00400040004000400040004000400040004000170118021C013D001C001C001C001C001C001C001C0190003E003E003E003E003E003E023A00040003000300050005000500050005000500050005023000E10045027401A900030003000300030003000300030003000300320032003200320032003200320032003200320032004000400040004000400040004000400040015B0021002100210021000500050005000500050005000500050005";


    function selectAllFemaleTraits(TraitsContext memory ctx, LibPRNG.PRNG memory prng) external pure returns (FemaleTraits memory) {

        FemaleTraits memory selected;

        selected.skin = selectFemaleSkin(prng);

        TraitsContext memory tempCtx = ctx;

        tempCtx.femaleSkin = selected.skin; // Select skin first and then the rest using updated context

        selected.eyes = selectFemaleEyes(tempCtx, prng);
        selected.face = selectFemaleFace(tempCtx, prng);
        selected.chain = selectFemaleChain(prng);
        selected.earring = selectFemaleEarring(prng);
        selected.mask = selectFemaleMask(prng);
        selected.scarf = selectFemaleScarf(prng);
        selected.hair = selectFemaleHair(tempCtx, prng);
        selected.hatHair = selectFemaleHatHair(tempCtx, prng);
        selected.headwear = selectFemaleHeadwear(prng);
        selected.eyeWear = selectFemaleEyeWear(prng);

        return selected;
    }

    function selectRandomTrait(LibPRNG.PRNG memory prng, bytes memory packedWeights, uint256 totalWeight) public pure returns (uint256) {
        if (totalWeight == 0) {
            revert("totalWeight must be > 0");
        }
        uint256 r = LibPRNG.uniform(prng, totalWeight);
        
        uint256 currentSum = 0;
        uint256 len = packedWeights.length;
        
        // Each weight is 2 bytes (uint16)
        for (uint256 i = 0; i < len; i += 2) {
            uint16 weight;
            
            assembly {
                // Load 2 bytes from packedWeights at index i. Skip 32 bytes length prefix.
                weight := shr(240, mload(add(add(packedWeights, 32), i)))
            }

            currentSum += weight;
            if (r < currentSum) {
                return i / 2;
            }
        }

        revert("Selection failed");
    }

    function selectFemaleSkin(LibPRNG.PRNG memory prng) public pure returns (E_Female_Skin) {
        return E_Female_Skin(selectRandomTrait(prng, SKIN_PROBS, 10000));
    }

    function selectFemaleEyes(TraitsContext memory ctx, LibPRNG.PRNG memory prng) public pure returns (E_Female_Eyes) {
        if (LibTraits.femaleIsGhost(ctx)) {
            return LibPRNG.uniform(prng, 10000) < 5000 ? E_Female_Eyes.Ghost_Left : E_Female_Eyes.Ghost_Right;
        }

        return E_Female_Eyes(selectRandomTrait(prng, EYES_PROBS, 10239));
    }

    function selectFemaleFace(TraitsContext memory ctx, LibPRNG.PRNG memory prng) public pure returns (E_Female_Face) {
        bytes memory packed;
        uint256 totalWeight;
        
        if (LibTraits.femaleIsHuman(ctx) || LibTraits.femaleIsZombie(ctx)) {
            // Human/Zombie weights
            packed = FACE_PROBS_A;
            totalWeight = 10000;
        } 

        else if (LibTraits.femaleIsApe(ctx) || LibTraits.femaleIsZombieApe(ctx)) {
            // Ape weights (Only Mole, Bandage, War Paint, Bionics, Cybereyes)
            packed = FACE_PROBS_B;
            totalWeight = 10000;
        } 

        else if (LibTraits.femaleIsAlien(ctx) || LibTraits.femaleIsDemon(ctx) || LibTraits.femaleIsGhost(ctx) || LibTraits.femaleIsGlitch(ctx) || LibTraits.femaleIsGoblin(ctx) || LibTraits.femaleIsSkeleton(ctx) || LibTraits.femaleIsVampire(ctx)) {
            // All other weights (Only Mole, Tattoos, Bandage)
            packed = FACE_PROBS_C;
            totalWeight = 10000;
        }

        else {
            return E_Female_Face.None;
        }

        return E_Female_Face(selectRandomTrait(prng, packed, totalWeight));
    }

    function selectFemaleChain(LibPRNG.PRNG memory prng) public pure returns (E_Female_Chain) {
        return E_Female_Chain(selectRandomTrait(prng, CHAIN_PROBS, 10000));
    }

    function selectFemaleEarring(LibPRNG.PRNG memory prng) public pure returns (E_Female_Earring) {
        return E_Female_Earring(selectRandomTrait(prng, EARRING_PROBS, 10000));
    }

    function selectFemaleMask(LibPRNG.PRNG memory prng) public pure returns (E_Female_Mask) {
        return E_Female_Mask(selectRandomTrait(prng, MASK_PROBS, 9990));
    }

    function selectFemaleScarf(LibPRNG.PRNG memory prng) public pure returns (E_Female_Scarf) {
        return E_Female_Scarf(selectRandomTrait(prng, SCARF_PROBS, 10000));
    }

    function selectFemaleHair(TraitsContext memory ctx, LibPRNG.PRNG memory prng) public pure returns (E_Female_Hair) {
        uint256 noneWeight;
        
        if (LibTraits.femaleIsRobot(ctx) || LibTraits.femaleIsMummy(ctx) || LibTraits.femaleIsVampire(ctx)) {
            return E_Female_Hair.None;
        }

        else if (LibTraits.femaleIsHuman(ctx) || LibTraits.femaleIsZombie(ctx)) {
            noneWeight = 400;
        }

        else {
            noneWeight = 1200;
        }

        uint256 total = 9595 + noneWeight;
        
        if (1 + LibPRNG.uniform(prng, total) <= noneWeight) {
            return E_Female_Hair.None;
        }

        return E_Female_Hair(selectRandomTrait(prng, HAIR_PROBS, 9595));
    }

    function selectFemaleHatHair(TraitsContext memory ctx, LibPRNG.PRNG memory prng) public pure returns (E_Female_Hat_Hair) {
        uint256 noneWeight;
        
        if (LibTraits.femaleIsRobot(ctx) || LibTraits.femaleIsMummy(ctx) || LibTraits.femaleIsVampire(ctx)) {
            return E_Female_Hat_Hair.None;
        }

        else if (LibTraits.femaleIsHuman(ctx) || LibTraits.femaleIsZombie(ctx)) {
            noneWeight = 400;
        }

        else {
            noneWeight = 1200;
        }

        uint256 total = 7000 + noneWeight;

        if (1 + LibPRNG.uniform(prng, total) <= noneWeight) {
            return E_Female_Hat_Hair.None;
        }

        return E_Female_Hat_Hair(selectRandomTrait(prng, HAT_HAIR_PROBS, 7000));
    }

    function selectFemaleHeadwear(LibPRNG.PRNG memory prng) public pure returns (E_Female_Headwear) {
        return E_Female_Headwear(selectRandomTrait(prng, HEADWEAR_PROBS, 9997));
    }

    function selectFemaleEyeWear(LibPRNG.PRNG memory prng) public pure returns (E_Female_Eye_Wear) {
        return E_Female_Eye_Wear(selectRandomTrait(prng, EYEWEAR_PROBS, 9682));
    }
}