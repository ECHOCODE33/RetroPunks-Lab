// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

struct RandomCtx {
    uint256 seed;
    uint256 counter;
}

library Random {
    function initCtx(uint tokenId, uint seed, uint multiplier) internal pure returns (RandomCtx memory) {
        uint startingSeed = uint(keccak256(abi.encode(tokenId * multiplier, seed)));
        return RandomCtx({
            seed: startingSeed,
            counter: tokenId * multiplier
        });
    }

    function initCtx(uint tokenId, uint seed) internal pure returns (RandomCtx memory) {
        return initCtx(tokenId, seed, 1);
    }

    function initCtxFromBlock(uint tokenId, uint seed, uint multiplier) internal view returns (RandomCtx memory) {
        uint startingSeed = uint(keccak256(abi.encode(tokenId * multiplier, seed, block.timestamp, block.prevrandao, block.number)));
        return RandomCtx(startingSeed, tokenId * multiplier);      
    }

    function initCtxFromBlock(uint tokenId, uint seed) internal view returns (RandomCtx memory) {
        return initCtxFromBlock(tokenId, seed, 1);
    }


    function randInt(RandomCtx memory ctx) internal pure returns (uint256) {
        ctx.counter++;

        ctx.seed = uint(keccak256(
            abi.encode(
                ctx.seed, ctx.counter
            )
        ));
        
        return ctx.seed;
    }

    /**
     
        10_000 == 100%

     */
    function randBool(RandomCtx memory ctx, int probability) internal pure returns (bool) {
        return randRange(ctx, 0, 9999) <= probability;
    }
    
    function randRange(RandomCtx memory ctx, int from, int to) internal pure returns (int256) { unchecked {
        if (from > to) {
            to = from;
        }
        uint rnd = randInt(ctx);

        return from + int(rnd >> 1) % (to - from + 1);
    }}

    function randomArray(RandomCtx memory ctx, int8 from, int8 to) internal pure returns (int8[] memory result) {
        uint8 len = uint8(to - from + 1);
        result = new int8[](len);

        for (int8 i = from; i <= to; i++) {
            result[uint8(i - from)] = i;
        }

        for (uint8 i = 0; i < len; i++) {
            uint8 n = uint8(int8(randRange(ctx, 0, int(uint(len-1)))));

            int8 tmp = result[n];
            result[n] = result[i];
            result[i] = tmp;
        }
    }

    function weightedRandomArray(RandomCtx memory ctx, uint32[] memory weights) internal pure returns (uint8[] memory) {
        uint[] memory array = new uint[](weights.length);

        for (uint8 i = 0; i < weights.length; i++) {
            array[i] = uint(randRange(ctx, 1, int(int32(weights[i])))) << 8 | i;
        }

        // Sort array in-place (descending by random value)
        for (uint i = 0; i < array.length; i++) {
            for (uint j = i + 1; j < array.length; j++) {
                if (array[j] > array[i]) {
                    uint temp = array[i];
                    array[i] = array[j];
                    array[j] = temp;
                }
            }
        }

        uint8[] memory result = new uint8[](weights.length);
        
        for (uint8 i = 0; i < weights.length; i++) {
            result[i] = uint8(array[i] & 0xFF);
        }

        return result;
    }

    function randWithProbabilities(RandomCtx memory ctx, uint32[] memory probabilities) internal pure returns (uint8) { unchecked {
        uint probSum = 0;

        for (uint8 i = 0; i < probabilities.length; i++) {
            probSum += uint(probabilities[i]);
        }

        int rnd = Random.randRange(ctx, 1, int(probSum));

        probSum = 0;
        for (uint8 i = 0; i < probabilities.length; i++) {
            probSum += uint(probabilities[i]);

            if (int(probSum) >= rnd) {
                return i;
            }
        }

        return 0;
    }}

    function probabilityArray(uint32 a0, uint32 a1) internal pure returns (uint32[] memory) {
        uint32[] memory result = new uint32[](2);
        result[0] = a0;
        result[1] = a1;
        return result;    
    } 

    function probabilityArray(uint32 a0, uint32 a1, uint32 a2) internal pure returns (uint32[] memory) {
        uint32[] memory result = new uint32[](3);
        result[0] = a0;
        result[1] = a1;
        result[2] = a2;
        return result;    
    } 

    function probabilityArray(uint32 a0, uint32 a1, uint32 a2, uint32 a3) internal pure returns (uint32[] memory) {
        uint32[] memory result = new uint32[](4);
        result[0] = a0;
        result[1] = a1;
        result[2] = a2;
        result[3] = a3;
        return result;    
    } 

    function probabilityArray(uint32 a0, uint32 a1, uint32 a2, uint32 a3, uint32 a4) internal pure returns (uint32[] memory) {
        uint32[] memory result = new uint32[](5);
        result[0] = a0;
        result[1] = a1;
        result[2] = a2;
        result[3] = a3;
        result[4] = a4;
        return result;    
    }

    function probabilityArray(uint32 a0, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5) internal pure returns (uint32[] memory) {
        uint32[] memory result = new uint32[](6);
        result[0] = a0;
        result[1] = a1;
        result[2] = a2;
        result[3] = a3;
        result[4] = a4;
        result[5] = a5;
        return result;    
    }

    function probabilityArray(uint32 a0, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5, uint32 a6) internal pure returns (uint32[] memory) {
        uint32[] memory result = new uint32[](7);
        result[0] = a0;
        result[1] = a1;
        result[2] = a2;
        result[3] = a3;
        result[4] = a4;
        result[5] = a5;
        result[6] = a6;
        return result;    
    }

    function probabilityArray(uint32 a0, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5, uint32 a6, uint32 a7) internal pure returns (uint32[] memory) {
        uint32[] memory result = new uint32[](8);
        result[0] = a0;
        result[1] = a1;
        result[2] = a2;
        result[3] = a3;
        result[4] = a4;
        result[5] = a5;
        result[6] = a6;
        result[7] = a7;
        return result;    
    }

    function probabilityArray(uint32 a0, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5, uint32 a6, uint32 a7, uint32 a8) internal pure returns (uint32[] memory) {
        uint32[] memory result = new uint32[](9);
        result[0] = a0;
        result[1] = a1;
        result[2] = a2;
        result[3] = a3;
        result[4] = a4;
        result[5] = a5;
        result[6] = a6;
        result[7] = a7;
        result[8] = a8;
        return result;    
    }

    function probabilityArray(uint32 a0, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5, uint32 a6, uint32 a7, uint32 a8, uint32 a9) internal pure returns (uint32[] memory) {
        uint32[] memory result = new uint32[](10);
        result[0] = a0;
        result[1] = a1;
        result[2] = a2;
        result[3] = a3;
        result[4] = a4;
        result[5] = a5;
        result[6] = a6;
        result[7] = a7;
        result[8] = a8;
        result[9] = a9;
        return result;    
    }
}