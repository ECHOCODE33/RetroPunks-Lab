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

    function selectRandomTrait(RandomCtx memory rndCtx, uint16[] memory probs) internal pure returns (uint) {
        uint total = 0;
        unchecked {
            for (uint i = 0; i < probs.length; i++) {
                total += probs[i];
            }
        }

        uint r = rand(rndCtx) % total;

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

    function _weightedSelect(uint16[] memory probs, uint r) internal pure returns (uint) {
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
}