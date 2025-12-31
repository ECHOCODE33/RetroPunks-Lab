// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { IProbs } from './interfaces/IProbs.sol';
import { E_Male_Skin, E_Male_Eyes, E_Male_Face, E_Male_Chain, E_Male_Earring, E_Male_Scarf, E_Male_Facial_Hair, E_Male_Mask, E_Male_Hair, E_Male_Hat_Hair, E_Male_Headwear, E_Male_Eye_Wear, E_Female_Skin, E_Female_Eyes, E_Female_Face, E_Female_Chain, E_Female_Earring, E_Female_Scarf, E_Female_Mask, E_Female_Hair, E_Female_Hat_Hair, E_Female_Headwear, E_Female_Eye_Wear, E_Female_Skin, E_Female_Eyes, E_Female_Face, E_Female_Chain, E_Female_Earring, E_Female_Scarf, E_Female_Mask, E_Female_Hair, E_Female_Hat_Hair, E_Female_Headwear, E_Female_Eye_Wear, E_Mouth } from "./common/Enums.sol";
import { TraitsContext, MaleTraits, FemaleTraits } from './common/Structs.sol';
import { LibPRNG } from "./libraries/LibPRNG.sol";
import { LibTraits } from "./libraries/LibTraits.sol";

/**
 * @author ECHO
 */

contract Probs is IProbs {

    // ---------- Male Probs ---------- //

        bytes private constant M_SKIN = hex"0000002300AF000C002D0037000E02EE02EE02EE02EE02EE02EE02EE02EE02EE02EE02EE02EE000800160010003C0012001E000A0050012C0078";

        bytes private constant M_EYES = hex"000000320064000B000B000B000B000B000B000B000B000B00FA00000000101D00190019101D007D01F401F4004C";

        bytes private constant M_FACE_A = hex"249500120010004B00100023000A000A0008000C00140008000C00C8003C000C000A000E00320016";
        bytes private constant M_FACE_B = hex"249500000000004B00100000000A000A0000000000000000000C00C80000000C0000000000320000";
        bytes private constant M_FACE_C = hex"249500120010004B00000023000000000000000C00140008000000C800000000000A000E00000016";
        
        bytes private constant M_CHAIN = hex"232800FA0019004B008C015E000A00320064";

        bytes private constant M_EARRING = hex"232800FA0019004B008C015E000A00320064";
        
        bytes private constant M_FACIAL_HAIR_A = hex"13880000000000000000006000000000002A0000002A001900000000000000000000000000000000000000000000000000190000000000000000001B0000000000000000000000000000000000000000000000000000000000000000001E00000000000000000000000000000000001400000000000000000000000000000000000000000000000000000000000000000023000000000000000000190000000000000000000000000000000000140000";
        bytes private constant M_FACIAL_HAIR_B = hex"1388005A0041002D00190060004B003C002A0032002A00190023006900500032001E009B00730050002800640055003C0019002D006B00570043001B002F00460032002300140028001E0014000A008C0069004600280078005F004B001E0032004B003C00230014005A004B003700140028005F004B003200190037002D0019000F002D00230019000F00820069005000230037005F004B003C0019002D003C002D001E00140041003700280014001E";
        
        bytes private constant M_MASK = hex"253A001E001E001E001E001E002800190019001900190019001900190019000F000F000A000A000A000A000A";

        bytes private constant M_SCARF = hex"26AC0028001E001E";

        bytes private constant M_HAIR = hex"000000C80078001900B4006400190019001900190019001900E1008C00C80064005500FA00C800AF00B900E100A500070007000700070007000700070012000E0002000A0007000200020002000200020002000200040004000300030003000300C80096001A00AF0075001A001A001A001A001A001A001A00230019001E0014000F000C0007000200090006000200020002000200020002000200460032003C0028001E003B00230007002D001E00070007000700070007000700070046001E003C0019000F00C80078001900B40064001900190019001900190019001900060003000200040002000200010001000100010002000200020002000200020096004B001900370023002D0019000F000400020002000300010002000100010001000100020002000200020002000204B000060004000100050002000100010001000100010001000104B00037002D00230019000F0014000C000300100008000300030003000300030003000300320028001E0014000A0010000C0003000E0009000300030003000300030003000300C80078001900B400640019001900190019001900190019";

        bytes private constant M_HAT_HAIR = hex"000000E100C8008C0064005500C800AF00B900E100A500FA00C80096001A00AF0075001A001A001A001A001A001A001A000C00090002000700060002000200020002000200020002003B00230007002D001E000700070007000700070007000700C80078001900B4006400190019001900190019001900190096004B001904B000060004000100050002000100010001000100010001000104B00014000C00030010000800030003000300030003000300030032001E00280014000A00C800B40019007800640019001900190019001900190019";

        bytes private constant M_HEADWEAR = hex"03BB007E007E007E007E007E003E003E003E003E003E003E003E003E003E004400440044004400440044004400440044003000300030006E0010001000100010001000100010008200820082008200820096000600060006000600060006000601270012001200120012001200120012001200120069000F00420042004200420042000F000F000F000F000F000F000F000F000F001E01450040004000400040004000410003000F000F000F000F002200220022006400290029002900290029002900290032004B002D0014006400640064004E004E004E004E004E004E004E004E004B004B004B004B004B004B004B004B004B004B00260026002600260026002600260026000E000E000E000E000E000E000E000E000E0037004E004E004E004E01220010001000100010001000100010004B004B004B004B004B004B004B004B00050005000500050005000500050005";

        bytes private constant M_EYEWEAR = hex"03E801DB00160016001600160016000A000A000A000A000A000A000A000A002E002E002E002E002E002E002E002E002E002E002E0014001400140014001400140014001401DB00400040004000400040004000400040004000170118021C013D001C001C001C001C001C001C001C0190003E003E003E003E003E003E023A00040003000300050005000500050005000500050005007D007D0230000900090009000900E10045027401A900030003000300030003000300030003000300320032003200320032003200320032003200320032004000400040004000400040004000400040015B0021002100210021000500050005000500050005000500050005";
    
        bytes private constant MOUTH_A = hex"1FDB007D001E00C800320096009600FA0032000F0014000F001E0014002300320064000A001900640064012C0014";
        bytes private constant MOUTH_B = hex"1FDB007D001E00C800320096009600FA0032000F0014000000000000000000320064000A001900640064012C0014";
        bytes private constant MOUTH_C = hex"1FDB007D001E00C800320096009600FA0032000F0014000000000000000000320064000A001900000000012C0014";

    // ---------- Female Probs ---------- //

        bytes private constant F_SKIN = hex"0000001900E1000F002D0041001402EE02EE02EE02EE02EE02EE02EE02EE02EE02EE02EE02EE00080019005A0016000A012C0096";

        bytes private constant F_EYES = hex"000000320064000B000B000B000B000B000B000B000B000B00FA001E001E001E001E001E001E001E001E101D00190019101D007D01F401F4004B";

        bytes private constant F_FACE_A = hex"24A10010000C004B0010007D0023000A000A00080012000A0016000C00C8000C0014000E0008";
        bytes private constant F_FACE_B = hex"25C100000000004B001000000000000A000A0000000000000000000C00C8000C000000000000";
        bytes private constant F_FACE_C = hex"25620010000C004B0000000000230000000000000012000A0016000000C800000014000E0008";

        bytes private constant F_CHAIN = hex"232800FA0019004B008C015E000A00320064";

        bytes private constant F_EARRING = hex"232800FA0019004B008C015E000A00320064";

        bytes private constant F_MASK = hex"253F001E001E001E001E001E002800190019001900190019001900190019000F000A000A000A000A000A";

        bytes private constant F_SCARF = hex"26AC0028001E001E";

        bytes private constant F_HAIR = hex"000000E1007D002000960064002000200020002000200020004C00E1007D002000960064002000200020002000200020004C00290029002900290029002900E1007D002000960064002000200020002000200020004B00D20078001E00960064001E001E001E001E001E001E003C004B0032000C0041002D000C000C000C000C000C000C001F004B002D0007003700230007000600060006000600070007000700070007001100E1007D002000960064002000200020002000200020004C00D20078001E00960064001E001E001E001E001E001E003C003C002D0009002300140009000300030003000300090009000900090009000F0049002D000B00370023000B000B000B000B000B000B000F00E1007D002000960064002000200020002000200020004C004B0032000C0041002D000C000C000C000C000C000C001F00E1007D002000960064002000200020002000200020004C004B0032000C0041002D000C000C000C000C000C000C001F004B0032000C0041002D000C000C000C000C000C000C001F";

        bytes private constant F_HAT_HAIR = hex"000000E1007D002100960064002000200020002000200020004B00E1007D002100960064002000200020002000200020004B00D00078002000960064001E001E001E001E001E001E003C004B0032000D0041002D000D000D000C000C000C000C001C00D00078001F00960064001F001E001E001E001E001E003C004B002D000B00370023000B000B000B000B000A000A000F00E1007D002100960064002000200020002000200020004B004B0032000D0041002D000D000D000C000C000C000C001C00E1007D002100960064002000200020002000200020004B004B0032000D0041002D000D000D000C000C000C000C001C004B0032000D0041002D000D000D000C000C000C000C001C";

        bytes private constant F_HEADWEAR = hex"036700E1009200920092009200920049004900490049004900490049004900490050005000500050005000500050005000500040004000400096009600960096009600C80006000600060006000600060006001800180018001800180018001800180018000F001E0177004A004A004A004A004A0041000F000F000F000F00320032003200300030003000300030003000300032004B000300190028007400740074005A005A005A005A005A005A005A005A0055005500550055005500550055005500550055002C002C002C002C002C002C002C002C000A00190037005B005B005B005B01540057005700570057005700570057005700050005000500050005000500050005";

        bytes private constant F_EYEWEAR = hex"03C801DB00160016001600160016000A000A000A000A000A000A000A000A002E002E002E002E002E002E002E002E002E002E002E0014001400140014001400140014001401DB00400040004000400040004000400040004000170118021C013D001C001C001C001C001C001C001C0190003E003E003E003E003E003E023A00040003000300050005000500050005000500050005023000E10045027401A900030003000300030003000300030003000300320032003200320032003200320032003200320032004000400040004000400040004000400040015B0021002100210021000500050005000500050005000500050005";

    function selectAllMaleTraits(TraitsContext memory ctx, LibPRNG.PRNG memory prng) external pure returns (MaleTraits memory) {

        MaleTraits memory m;

        m.skin = selectMaleSkin(prng);

        TraitsContext memory tempCtx = ctx;

        tempCtx.maleSkin = m.skin; // Select skin first and then the rest using updated context

        m.eyes = selectMaleEyes(tempCtx, prng);
        m.face = selectMaleFace(tempCtx, prng);
        m.chain = selectMaleChain(prng);
        m.earring = selectMaleEarring(prng);
        m.facialHair = selectMaleFacialHair(tempCtx, prng);
        m.mask = selectMaleMask(prng);
        m.scarf = selectMaleScarf(prng);
        m.hair = selectMaleHair(tempCtx, prng);
        m.hatHair = selectMaleHatHair(tempCtx, prng);
        m.headwear = selectMaleHeadwear(prng);
        m.eyeWear = selectMaleEyeWear(prng);
        m.mouth = selectMouth(tempCtx, prng);

        return m;
    }

    function selectAllFemaleTraits(TraitsContext memory ctx, LibPRNG.PRNG memory prng) external pure returns (FemaleTraits memory) {

        FemaleTraits memory f;

        f.skin = selectFemaleSkin(prng);

        TraitsContext memory tempCtx = ctx;

        tempCtx.femaleSkin = f.skin; // Select skin first and then the rest using updated context

        f.eyes = selectFemaleEyes(tempCtx, prng);
        f.face = selectFemaleFace(tempCtx, prng);
        f.chain = selectFemaleChain(prng);
        f.earring = selectFemaleEarring(prng);
        f.mask = selectFemaleMask(prng);
        f.scarf = selectFemaleScarf(prng);
        f.hair = selectFemaleHair(tempCtx, prng);
        f.hatHair = selectFemaleHatHair(tempCtx, prng);
        f.headwear = selectFemaleHeadwear(prng);
        f.eyeWear = selectFemaleEyeWear(prng);
        f.mouth = selectMouth(tempCtx, prng);

        return f;
    }

    function selectRandomTrait(LibPRNG.PRNG memory prng, bytes memory packedWeights, uint256 totalWeight) internal pure returns (uint256) {
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

    function selectMaleSkin(LibPRNG.PRNG memory prng) internal pure returns (E_Male_Skin) {
        return E_Male_Skin(selectRandomTrait(prng, M_SKIN, 10000));
    }

    function selectMaleEyes(TraitsContext memory ctx, LibPRNG.PRNG memory prng) internal pure returns (E_Male_Eyes) {
        if (LibTraits.maleIsGhost(ctx)) {
            // 50/50 chance for Ghost Eyes
            return LibPRNG.uniform(prng, 10000) < 5000 ? E_Male_Eyes.Ghost_Left : E_Male_Eyes.Ghost_Right;
        }

        return E_Male_Eyes(selectRandomTrait(prng, M_EYES, 10000));
    }

    function selectMaleFace(TraitsContext memory ctx, LibPRNG.PRNG memory prng) internal pure returns (E_Male_Face) {
        bytes memory packed;
        uint256 totalWeight;
        
        if (LibTraits.maleIsHuman(ctx) || LibTraits.maleIsZombie(ctx)) {
            // Human/Zombie weights
            packed = M_FACE_A;
            totalWeight = 9973;
        } 

        else if (LibTraits.maleIsApe(ctx) || LibTraits.maleIsYeti(ctx) || LibTraits.maleIsZombieApe(ctx)) {
            // Ape weights (Only Mole, Bandage, War Paint, Bionics, Cybereyes)
            packed = M_FACE_B;
            totalWeight = 9750;
        } 

        else if (LibTraits.maleIsAlien(ctx) || LibTraits.maleIsDemon(ctx) || LibTraits.maleIsGhost(ctx) || LibTraits.maleIsGlitch(ctx) || LibTraits.maleIsGoblin(ctx) || LibTraits.maleIsPumpkin(ctx) || LibTraits.maleIsSkeleton(ctx) || LibTraits.maleIsVampire(ctx)) {
            // All other weights (Only Mole, Tattoos, Bandage)
            packed = M_FACE_C;
            totalWeight = 9795;
        }

        else {
            return E_Male_Face.None;
        }

        return E_Male_Face(selectRandomTrait(prng, packed, totalWeight));
    }

    function selectMaleChain(LibPRNG.PRNG memory prng) internal pure returns (E_Male_Chain) {
        return E_Male_Chain(selectRandomTrait(prng, M_CHAIN, 10000));
    }

    function selectMaleEarring(LibPRNG.PRNG memory prng) internal pure returns (E_Male_Earring) {
        return E_Male_Earring(selectRandomTrait(prng, M_EARRING, 10000));
    }

    function selectMaleFacialHair(TraitsContext memory ctx, LibPRNG.PRNG memory prng) internal pure returns (E_Male_Facial_Hair) {
        if (!LibTraits.maleIsHuman(ctx) && !LibTraits.maleIsZombie(ctx) && !LibTraits.maleIsGhost(ctx)) {
            return E_Male_Facial_Hair.None;
        }

        bytes memory packed;
        uint256 totalWeight;

        if (LibTraits.maleIsGhost(ctx)) {
            // Ghost Weights (Shadow traits only)
            packed = M_FACIAL_HAIR_A;
            totalWeight = 5387;
        } 
        
        else {
            // Normal Weights (Human/Zombie)
            packed = M_FACIAL_HAIR_B;
            totalWeight = 10000;
        }

        return E_Male_Facial_Hair(selectRandomTrait(prng, packed, totalWeight));
    }

    function selectMaleMask(LibPRNG.PRNG memory prng) internal pure returns (E_Male_Mask) {
        return E_Male_Mask(selectRandomTrait(prng, M_MASK, 10000));
    }

    function selectMaleScarf(LibPRNG.PRNG memory prng) internal pure returns (E_Male_Scarf) {
        return E_Male_Scarf(selectRandomTrait(prng, M_SCARF, 10000));
    }

    function selectMaleHair(TraitsContext memory ctx, LibPRNG.PRNG memory prng) internal pure returns (E_Male_Hair) {
        uint256 noneWeight;

        if (LibTraits.maleIsRobot(ctx) || LibTraits.maleIsMummy(ctx) || LibTraits.maleIsVampire(ctx)) {
            return E_Male_Hair.None;
        } 
        
        else if (LibTraits.maleIsHuman(ctx) || LibTraits.maleIsZombie(ctx)) {
            noneWeight = 400;
        } 
        
        else {
            noneWeight = 1200;
        }

        uint256 total = 9579 + noneWeight;
        
        if (1 + LibPRNG.uniform(prng, total) <= noneWeight) {
            return E_Male_Hair.None;
        }

        return E_Male_Hair(selectRandomTrait(prng, M_HAIR, 9579));
    }

    function selectMaleHatHair(TraitsContext memory ctx, LibPRNG.PRNG memory prng) internal pure returns (E_Male_Hat_Hair) {
        uint256 noneWeight;
        
        if (LibTraits.maleIsRobot(ctx) || LibTraits.maleIsMummy(ctx) || LibTraits.maleIsVampire(ctx)) {
            return E_Male_Hat_Hair.None;
        }

        else if (LibTraits.maleIsHuman(ctx) || LibTraits.maleIsZombie(ctx)) {
            noneWeight = 400;
        }

        else {
            noneWeight = 800;
        }
        
        uint256 total = 7580 + noneWeight;
        
        if (1 + LibPRNG.uniform(prng, total) <= noneWeight) {
            return E_Male_Hat_Hair.None;
        }

        return E_Male_Hat_Hair(selectRandomTrait(prng, M_HAT_HAIR, 7580));
    }

    function selectMaleHeadwear(LibPRNG.PRNG memory prng) internal pure returns (E_Male_Headwear) {
        return E_Male_Headwear(selectRandomTrait(prng, M_HEADWEAR, 10000));
    }

    function selectMaleEyeWear(LibPRNG.PRNG memory prng) internal pure returns (E_Male_Eye_Wear) {
        return E_Male_Eye_Wear(selectRandomTrait(prng, M_EYEWEAR, 10000));
    }

    function selectFemaleSkin(LibPRNG.PRNG memory prng) internal pure returns (E_Female_Skin) {
        return E_Female_Skin(selectRandomTrait(prng, F_SKIN, 10000));
    }

    function selectFemaleEyes(TraitsContext memory ctx, LibPRNG.PRNG memory prng) internal pure returns (E_Female_Eyes) {
        if (LibTraits.femaleIsGhost(ctx)) {
            return LibPRNG.uniform(prng, 10000) < 5000 ? E_Female_Eyes.Ghost_Left : E_Female_Eyes.Ghost_Right;
        }

        return E_Female_Eyes(selectRandomTrait(prng, F_EYES, 10239));
    }

    function selectFemaleFace(TraitsContext memory ctx, LibPRNG.PRNG memory prng) internal pure returns (E_Female_Face) {
        bytes memory packed;
        uint256 totalWeight;
        
        if (LibTraits.femaleIsHuman(ctx) || LibTraits.femaleIsZombie(ctx)) {
            // Human/Zombie weights
            packed = F_FACE_A;
            totalWeight = 10000;
        } 

        else if (LibTraits.femaleIsApe(ctx) || LibTraits.femaleIsZombieApe(ctx)) {
            // Ape weights (Only Mole, Bandage, War Paint, Bionics, Cybereyes)
            packed = F_FACE_B;
            totalWeight = 10000;
        } 

        else if (LibTraits.femaleIsAlien(ctx) || LibTraits.femaleIsDemon(ctx) || LibTraits.femaleIsGhost(ctx) || LibTraits.femaleIsGlitch(ctx) || LibTraits.femaleIsGoblin(ctx) || LibTraits.femaleIsSkeleton(ctx) || LibTraits.femaleIsVampire(ctx)) {
            // All other weights (Only Mole, Tattoos, Bandage)
            packed = F_FACE_C;
            totalWeight = 10000;
        }

        else {
            return E_Female_Face.None;
        }

        return E_Female_Face(selectRandomTrait(prng, packed, totalWeight));
    }

    function selectFemaleChain(LibPRNG.PRNG memory prng) internal pure returns (E_Female_Chain) {
        return E_Female_Chain(selectRandomTrait(prng, F_CHAIN, 10000));
    }

    function selectFemaleEarring(LibPRNG.PRNG memory prng) internal pure returns (E_Female_Earring) {
        return E_Female_Earring(selectRandomTrait(prng, F_EARRING, 10000));
    }

    function selectFemaleMask(LibPRNG.PRNG memory prng) internal pure returns (E_Female_Mask) {
        return E_Female_Mask(selectRandomTrait(prng, F_MASK, 9990));
    }

    function selectFemaleScarf(LibPRNG.PRNG memory prng) internal pure returns (E_Female_Scarf) {
        return E_Female_Scarf(selectRandomTrait(prng, F_SCARF, 10000));
    }

    function selectFemaleHair(TraitsContext memory ctx, LibPRNG.PRNG memory prng) internal pure returns (E_Female_Hair) {
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

        return E_Female_Hair(selectRandomTrait(prng, F_HAIR, 9595));
    }

    function selectFemaleHatHair(TraitsContext memory ctx, LibPRNG.PRNG memory prng) internal pure returns (E_Female_Hat_Hair) {
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

        return E_Female_Hat_Hair(selectRandomTrait(prng, F_HAT_HAIR, 7000));
    }

    function selectFemaleHeadwear(LibPRNG.PRNG memory prng) internal pure returns (E_Female_Headwear) {
        return E_Female_Headwear(selectRandomTrait(prng, F_HEADWEAR, 9997));
    }

    function selectFemaleEyeWear(LibPRNG.PRNG memory prng) internal pure returns (E_Female_Eye_Wear) {
        return E_Female_Eye_Wear(selectRandomTrait(prng, F_EYEWEAR, 9682));
    }

    function selectMouth(TraitsContext memory ctx, LibPRNG.PRNG memory prng) internal pure returns (E_Mouth) {
        if (LibTraits.isFemale(ctx)) {
            bytes memory packed = MOUTH_A;
            return E_Mouth(selectRandomTrait(prng, packed, 10000));
        }

        else if (LibTraits.maleHasBlackFacialHair(ctx)) {
            return E_Mouth(selectRandomTrait(prng, MOUTH_B, 9900));
        }

        else {
            return E_Mouth(selectRandomTrait(prng, MOUTH_C, 9700));
        }
    }
}