// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

struct RandomCtx {
    uint256 seed;
    uint256 counter;
}

library Random {

    function initCtx(uint16 tokenIdSeed, uint256 globalSeed) internal pure returns (RandomCtx memory) {
        uint256 startingSeed = uint256(keccak256(abi.encodePacked(tokenIdSeed, globalSeed)));
        
        return RandomCtx({ seed: startingSeed, counter: tokenIdSeed });
    }

    function rand(RandomCtx memory ctx) internal pure returns (uint256) {
        ctx.counter++;
        ctx.seed = uint256(keccak256(abi.encodePacked(ctx.seed, ctx.counter)));
 
        return ctx.seed;
    }

    function randRange(RandomCtx memory ctx, uint256 from, uint256 toInclusive) internal pure returns (uint256) {
        unchecked {
            uint256 rangeSize = toInclusive - from + 1;
            return from + (rand(ctx) % rangeSize);
        }
    }

    function randBool(RandomCtx memory ctx, uint16 probability) internal pure returns (bool) {
        return randRange(ctx, 1, 10000) <= probability;
    }

    function nextUint(RandomCtx memory ctx, uint max) internal pure returns (uint) {
        ctx.counter++;
        uint256 newSeed = uint256(keccak256(abi.encodePacked(ctx.seed, ctx.counter)));
        ctx.seed = newSeed;
        return newSeed % max;
    }

    function weightedSelect(uint16[] memory probs, uint r) internal pure returns (uint) {
        uint sum = 0;
        for (uint i = 0; i < probs.length; i++) {
            sum += probs[i];
            if (r < sum) {
                return i;
            }
        }
        revert("Selection failed");
    }

    function selectRandomTrait(RandomCtx memory rndCtx, uint16[] memory probs) internal pure returns (uint) {
        uint total = 0;
        for (uint i = 0; i < probs.length; i++) {
            total += probs[i];
        }

        uint r = nextUint(rndCtx, total);

        return weightedSelect(probs, r);
    }
}
