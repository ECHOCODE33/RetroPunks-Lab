// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { IMaleProbs } from "./interfaces/IMaleProbs.sol";
import { E_Male_Skin, E_Male_Eyes, E_Male_Face, E_Male_Chain, E_Male_Earring, E_Male_Scarf, E_Male_Facial_Hair, E_Male_Mask, E_Male_Hair, E_Male_Hat_Hair, E_Male_Headwear, E_Male_Eye_Wear, E_Female_Skin, E_Female_Eyes, E_Female_Face, E_Female_Chain, E_Female_Earring, E_Female_Scarf, E_Female_Mask, E_Female_Hair, E_Female_Hat_Hair, E_Female_Headwear, E_Female_Eye_Wear, E_Mouth } from "./common/Enums.sol";
import { TraitsContext} from "./common/Structs.sol";
import { LibPRNG } from "./libraries/LibPRNG.sol";
import { TraitsLib } from "./libraries/TraitsLib.sol";

/**
 * @author ECHO
 */

contract MaleProbs is IMaleProbs {

    function _selectRandomTrait(LibPRNG.PRNG memory prng, bytes memory packedWeights, uint256 totalWeight) internal pure returns (uint256) {
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

    function selectMaleSkin(LibPRNG.PRNG memory prng) external pure returns (E_Male_Skin) {
        bytes memory packed = hex"0000002300AF000C002D0037000E02EE02EE02EE02EE02EE02EE02EE02EE02EE02EE02EE02EE000800160010003C0012001E000A0050012C0078";
        return E_Male_Skin(_selectRandomTrait(prng, packed, 10000));
    }

    function selectMaleEyes(TraitsContext calldata ctx, LibPRNG.PRNG memory prng) external pure returns (E_Male_Eyes) {
        if (TraitsLib.maleIsGhost(ctx)) {
            // 50/50 chance for Ghost Eyes
            return LibPRNG.uniform(prng, 10000) < 5000 ? E_Male_Eyes.Ghost_Left : E_Male_Eyes.Ghost_Right;
        }

        bytes memory packed = hex"000000320064000B000B000B000B000B000B000B000B000B00FA101D00190019101D007D01F401F4004C";
        return E_Male_Eyes(_selectRandomTrait(prng, packed, 10000));
    }

    function selectMaleFace(TraitsContext calldata ctx, LibPRNG.PRNG memory prng) external pure returns (E_Male_Face) {
        bytes memory packed;
        uint256 totalWeight;
        
        if (TraitsLib.maleIsHuman(ctx) || TraitsLib.maleIsZombie(ctx)) {
            // Human/Zombie weights
            packed = hex"249500120010004B00100023000A000A0008000C00140008000C00C8003C000C000A000E00320016";
            totalWeight = 9973;
        } 

        else if (TraitsLib.maleIsApe(ctx) || TraitsLib.maleIsYeti(ctx) || TraitsLib.maleIsZombieApe(ctx)) {
            // Ape weights (Only Mole, Bandage, War Paint, Bionics, Cybereyes)
            packed = hex"249500000000004B00100000000A000A0000000000000000000C00C80000000C0000000000320000";
            totalWeight = 9750;
        } 

        else if (TraitsLib.maleIsAlien(ctx) || TraitsLib.maleIsDemon(ctx) || TraitsLib.maleIsGhost(ctx) || TraitsLib.maleIsGlitch(ctx) || TraitsLib.maleIsGoblin(ctx) || TraitsLib.maleIsPumpkin(ctx) || TraitsLib.maleIsSkeleton(ctx) || TraitsLib.maleIsVampire(ctx)) {
            // All other weights (Only Mole, Tattoos, Bandage)
            packed = hex"249500120010004B00000023000000000000000C00140008000000C800000000000A000E00000016";
            totalWeight = 9795;
        }

        else {
            return E_Male_Face.None;
        }

        return E_Male_Face(_selectRandomTrait(prng, packed, totalWeight));
    }

     function selectMaleChain(LibPRNG.PRNG memory prng) external pure returns (E_Male_Chain) {
        bytes memory packed = hex"232800FA0019004B008C015E000A00320064";
        return E_Male_Chain(_selectRandomTrait(prng, packed, 10000));
    }

    function selectMaleEarring(LibPRNG.PRNG memory prng) external pure returns (E_Male_Earring) {
        bytes memory packed = hex"232800FA0019004B008C015E000A00320064";
        return E_Male_Earring(_selectRandomTrait(prng, packed, 10000));
    }

    function selectMaleScarf(LibPRNG.PRNG memory prng) external pure returns (E_Male_Scarf) {
        bytes memory packed = hex"26AC0028001E001E";
        return E_Male_Scarf(_selectRandomTrait(prng, packed, 10000));
    }

    function selectMaleFacialHair(TraitsContext calldata ctx, LibPRNG.PRNG memory prng) external pure returns (E_Male_Facial_Hair) {
        if (!TraitsLib.maleIsHuman(ctx) && !TraitsLib.maleIsZombie(ctx) && !TraitsLib.maleIsGhost(ctx)) {
            return E_Male_Facial_Hair.None;
        }

        bytes memory packed;
        uint256 totalWeight;

        if (TraitsLib.maleIsGhost(ctx)) {
            // Ghost Weights (Shadow traits only)
            packed = hex"13880000000000000000006000000000002A0000002A001900000000000000000000000000000000000000000000000000190000000000000000001B0000000000000000000000000000000000000000000000000000000000000000001E00000000000000000000000000000000001400000000000000000000000000000000000000000000000000000000000000000023000000000000000000190000000000000000000000000000000000140000";
            totalWeight = 5387;
        } 
        
        else {
            // Normal Weights (Human/Zombie)
            packed = hex"1388005A0041002D00190060004B003C002A0032002A00190023006900500032001E009B00730050002800640055003C0019002D006B00570043001B002F00460032002300140028001E0014000A008C0069004600280078005F004B001E0032004B003C00230014005A004B003700140028005F004B003200190037002D0019000F002D00230019000F00820069005000230037005F004B003C0019002D003C002D001E00140041003700280014001E";
            totalWeight = 10000;
        }

        return E_Male_Facial_Hair(_selectRandomTrait(prng, packed, totalWeight));
    }

    function selectMaleMask(LibPRNG.PRNG memory prng) external pure returns (E_Male_Mask) {
        bytes memory packed = hex"253A001E001E001E001E001E002800190019001900190019001900190019000F000F000A000A000A000A000A";
        return E_Male_Mask(_selectRandomTrait(prng, packed, 10000));
    }

    function selectMaleHair(TraitsContext calldata ctx, LibPRNG.PRNG memory prng) external pure returns (E_Male_Hair) {
        uint256 noneWeight;

        if (TraitsLib.maleIsRobot(ctx) || TraitsLib.maleIsMummy(ctx) || TraitsLib.maleIsVampire(ctx)) {
            return E_Male_Hair.None;
        } 
        
        else if (TraitsLib.maleIsHuman(ctx) || TraitsLib.maleIsZombie(ctx)) {
            noneWeight = 400;
        } 
        
        else {
            noneWeight = 1200;
        }

        uint256 total = 9579 + noneWeight;
        
        if (1 + LibPRNG.uniform(prng, total) <= noneWeight) {
            return E_Male_Hair.None;
        }

        bytes memory packed = hex"000000C80078001900B4006400190019001900190019001900E1008C00C80064005500FA00C800AF00B900E100A500070007000700070007000700070012000E0002000A0007000200020002000200020002000200040004000300030003000300C80096001A00AF0075001A001A001A001A001A001A001A00230019001E0014000F000C0007000200090006000200020002000200020002000200460032003C0028001E003B00230007002D001E00070007000700070007000700070046001E003C0019000F00C80078001900B40064001900190019001900190019001900060003000200040002000200010001000100010002000200020002000200020096004B001900370023002D0019000F000400020002000300010002000100010001000100020002000200020002000204B000060004000100050002000100010001000100010001000104B00037002D00230019000F0014000C000300100008000300030003000300030003000300320028001E0014000A0010000C0003000E0009000300030003000300030003000300C80078001900B400640019001900190019001900190019";
        return E_Male_Hair(_selectRandomTrait(prng, packed, 9579));
    }

    function selectMaleHatHair(TraitsContext calldata ctx, LibPRNG.PRNG memory prng) external pure returns (E_Male_Hat_Hair) {
        uint256 noneWeight;
        
        if (TraitsLib.maleIsRobot(ctx) || TraitsLib.maleIsMummy(ctx) || TraitsLib.maleIsVampire(ctx)) {
            return E_Male_Hat_Hair.None;
        }

        else if (TraitsLib.maleIsHuman(ctx) || TraitsLib.maleIsZombie(ctx)) {
            noneWeight = 400;
        }

        else {
            noneWeight = 800;
        }
        
        uint256 total = 7580 + noneWeight;
        
        if (1 + LibPRNG.uniform(prng, total) <= noneWeight) {
            return E_Male_Hat_Hair.None;
        }

        bytes memory packed = hex"000000E100C8008C0064005500C800AF00B900E100A500FA00C80096001A00AF0075001A001A001A001A001A001A001A000C00090002000700060002000200020002000200020002003B00230007002D001E000700070007000700070007000700C80078001900B4006400190019001900190019001900190096004B001904B000060004000100050002000100010001000100010001000104B00014000C00030010000800030003000300030003000300030032001E00280014000A00C800B40019007800640019001900190019001900190019";
        return E_Male_Hat_Hair(_selectRandomTrait(prng, packed, 7580));
    }

    function selectMaleHeadwear(LibPRNG.PRNG memory prng) external pure returns (E_Male_Headwear) {
        bytes memory packed = hex"03BB007E007E007E007E007E003E003E003E003E003E003E003E003E003E004400440044004400440044004400440044003000300030006E0010001000100010001000100010008200820082008200820096000600060006000600060006000601270012001200120012001200120012001200120069000F00420042004200420042000F000F000F000F000F000F000F000F000F001E01450040004000400040004000410003000F000F000F000F002200220022006400290029002900290029002900290032004B002D0014006400640064004E004E004E004E004E004E004E004E004B004B004B004B004B004B004B004B004B004B00260026002600260026002600260026000E000E000E000E000E000E000E000E000E0037004E004E004E004E01220010001000100010001000100010004B004B004B004B004B004B004B004B00050005000500050005000500050005";
        return E_Male_Headwear(_selectRandomTrait(prng, packed, 10000));
    }

    function selectMaleEyeWear(LibPRNG.PRNG memory prng) external pure returns (E_Male_Eye_Wear) {
        bytes memory packed = hex"03E801DB00160016001600160016000A000A000A000A000A000A000A000A002E002E002E002E002E002E002E002E002E002E002E0014001400140014001400140014001401DB00400040004000400040004000400040004000170118021C013D001C001C001C001C001C001C001C0190003E003E003E003E003E003E023A00040003000300050005000500050005000500050005007D007D0230000900090009000900E10045027401A900030003000300030003000300030003000300320032003200320032003200320032003200320032004000400040004000400040004000400040015B0021002100210021000500050005000500050005000500050005";
        return E_Male_Eye_Wear(_selectRandomTrait(prng, packed, 10000));
    }

    function selectMouth(TraitsContext calldata ctx, LibPRNG.PRNG memory prng) external pure returns (E_Mouth) {   
        if (TraitsLib.isFemale(ctx)) {
            bytes memory packed = hex"1FDB007D001E00C800320096009600FA0032000F0014000F001E0014002300320064000A001900640064012C0014";
            return E_Mouth(_selectRandomTrait(prng, packed, 10000));
        }

        else if (TraitsLib.maleHasBlackFacialHair(ctx)) {
            bytes memory packed = hex"1FDB007D001E00C800320096009600FA0032000F0014000000000000000000320064000A001900640064012C0014";
            return E_Mouth(_selectRandomTrait(prng, packed, 9900));
        }

        else {
            bytes memory packed = hex"1FDB007D001E00C800320096009600FA0032000F0014000000000000000000320064000A001900000000012C0014";
            return E_Mouth(_selectRandomTrait(prng, packed, 9700));
        }
    }
}