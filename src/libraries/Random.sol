// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

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

    function initCtx(uint16 tokenIdSeed, uint globalSeed) internal pure returns (RandomCtx memory) {
        uint startingSeed = uint(keccak256(abi.encodePacked(tokenIdSeed, globalSeed)));
        
        return RandomCtx({
            seed: startingSeed,
            counter: tokenIdSeed
        });
    }

    function rand(RandomCtx memory ctx) internal pure returns (uint) {
        ctx.counter++;

        ctx.seed = uint(keccak256(abi.encodePacked(ctx.seed, ctx.counter)));

        return ctx.seed;
    }

    function randBool(RandomCtx memory ctx, uint16 probability) internal pure returns (bool) {
        return randRange(ctx, 1, 10000) <= probability;
    }
 
    function randRange(RandomCtx memory ctx, uint fromInclusive, uint toInclusive) internal pure returns (uint) {
        unchecked {
            uint rangeSize = toInclusive - fromInclusive + 1;
            return fromInclusive + (rand(ctx) % rangeSize);
        }
    }
    
    function selectRandomTrait(RandomCtx memory ctx, bytes memory packedWeights, uint256 totalWeight) internal pure returns (uint256) {
        if (totalWeight == 0) {
            revert("totalWeight must be > 0");
        }
        uint256 r = rand(ctx) % totalWeight;
        
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
}