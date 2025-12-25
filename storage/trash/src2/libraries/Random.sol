// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title RandomCtx
 * @notice Context for deterministic random number generation
 */
struct RandomCtx {
    uint256 seed;
    uint256 counter;
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
    function initCtx(uint16 tokenIdSeed, uint256 globalSeed) internal pure returns (RandomCtx memory) {
        uint256 startingSeed = uint256(keccak256(abi.encodePacked(tokenIdSeed, globalSeed)));
        
        return RandomCtx({
            seed: startingSeed,
            counter: tokenIdSeed
        });
    }

    /**
     * @notice Generate next random number
     * @dev Mutates context for next call
     * @param ctx Random context (modified in place)
     * @return Random uint256
     */
    function rand(RandomCtx memory ctx) internal pure returns (uint256) {
        unchecked {
            ctx.counter++;
            ctx.seed = uint256(keccak256(abi.encodePacked(ctx.seed, ctx.counter)));
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
    function randRange(
        RandomCtx memory ctx,
        uint256 from,
        uint256 toInclusive
    ) internal pure returns (uint256) {
        unchecked {
            uint256 rangeSize = toInclusive - from + 1;
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
    function nextUint(RandomCtx memory ctx, uint256 max) internal pure returns (uint256) {
        unchecked {
            ctx.counter++;
            uint256 newSeed = uint256(keccak256(abi.encodePacked(ctx.seed, ctx.counter)));
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
    function weightedSelect(uint16[] memory probs, uint256 r) internal pure returns (uint256) {
        uint256 sum = 0;
        unchecked {
            for (uint256 i = 0; i < probs.length; i++) {
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
    function selectRandomTrait(
        RandomCtx memory rndCtx,
        uint16[] memory probs
    ) internal pure returns (uint256) {
        uint256 total = 0;
        unchecked {
            for (uint256 i = 0; i < probs.length; i++) {
                total += probs[i];
            }
        }

        uint256 r = nextUint(rndCtx, total);
        return weightedSelect(probs, r);
    }
}