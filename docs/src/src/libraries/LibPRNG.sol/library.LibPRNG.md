# LibPRNG
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/libraries/LibPRNG.sol)

**Authors:**
Solady (https://github.com/vectorized/solady/blob/main/src/utils/LibPRNG.sol), LazyShuffler based on NextShuffler by aschlosberg (divergencearran)
(https://github.com/divergencetech/ethier/blob/main/contracts/random/NextShuffler.sol)

Library for generating pseudorandom numbers.


## State Variables
### WAD
The scalar of ETH and most ERC20s.


```solidity
uint256 internal constant WAD = 1e18
```


## Functions
### seed

Seeds the `prng` with `state`.


```solidity
function seed(PRNG memory prng, uint256 state) internal pure;
```

### next

Returns the next pseudorandom uint256.
All bits of the returned uint256 pass the NIST Statistical Test Suite.


```solidity
function next(PRNG memory prng) internal pure returns (uint256 result);
```

### uniform

Returns a pseudorandom uint256, uniformly distributed
between 0 (inclusive) and `upper` (exclusive).
If your modulus is big, this method is recommended
for uniform sampling to avoid modulo bias.
For uniform sampling across all uint256 values,
or for small enough moduli such that the bias is negligible,
use [next](/src/libraries/LibPRNG.sol/library.LibPRNG.md#next) instead.


```solidity
function uniform(PRNG memory prng, uint256 upper) internal pure returns (uint256 result);
```

### standardNormalWad

Returns a sample from the standard normal distribution denominated in `WAD`.


```solidity
function standardNormalWad(PRNG memory prng) internal pure returns (int256 result);
```

### exponentialWad

Returns a sample from the unit exponential distribution denominated in `WAD`.


```solidity
function exponentialWad(PRNG memory prng) internal pure returns (uint256 result);
```

### shuffle

Shuffles the array in-place with Fisher-Yates shuffle.


```solidity
function shuffle(PRNG memory prng, uint256[] memory a) internal pure;
```

### shuffle

Shuffles the array in-place with Fisher-Yates shuffle.


```solidity
function shuffle(PRNG memory prng, int256[] memory a) internal pure;
```

### shuffle

Shuffles the array in-place with Fisher-Yates shuffle.


```solidity
function shuffle(PRNG memory prng, address[] memory a) internal pure;
```

### shuffle

Partially shuffles the array in-place with Fisher-Yates shuffle.
The first `k` elements will be uniformly sampled without replacement.


```solidity
function shuffle(PRNG memory prng, uint256[] memory a, uint256 k) internal pure;
```

### shuffle

Partially shuffles the array in-place with Fisher-Yates shuffle.
The first `k` elements will be uniformly sampled without replacement.


```solidity
function shuffle(PRNG memory prng, int256[] memory a, uint256 k) internal pure;
```

### shuffle

Partially shuffles the array in-place with Fisher-Yates shuffle.
The first `k` elements will be uniformly sampled without replacement.


```solidity
function shuffle(PRNG memory prng, address[] memory a, uint256 k) internal pure;
```

### shuffle

Shuffles the bytes in-place with Fisher-Yates shuffle.


```solidity
function shuffle(PRNG memory prng, bytes memory a) internal pure;
```

### initialize

Initializes the state for lazy-shuffling the range `[0..n)`.
Reverts if `n == 0 || n >= 2**32 - 1`.
Reverts if `$` has already been initialized.
If you need to reduce the length after initialization, just use a fresh new `$`.


```solidity
function initialize(LazyShuffler storage $, uint256 n) internal;
```

### grow

Increases the length of `$`.
Reverts if `$` has not been initialized.


```solidity
function grow(LazyShuffler storage $, uint256 n) internal;
```

### restart

Restarts the shuffler by setting `numShuffled` to zero,
such that all elements can be drawn again.
Restarting does NOT clear the internal permutation, nor changes the length.
Even with the same sequence of randomness, reshuffling can yield different results.


```solidity
function restart(LazyShuffler storage $) internal;
```

### numShuffled

Returns the number of elements that have been shuffled.


```solidity
function numShuffled(LazyShuffler storage $) internal view returns (uint256 result);
```

### length

Returns the length of `$`.
Returns zero if `$` is not initialized, else a non-zero value less than `2**32 - 1`.


```solidity
function length(LazyShuffler storage $) internal view returns (uint256 result);
```

### initialized

Returns if `$` has been initialized.


```solidity
function initialized(LazyShuffler storage $) internal view returns (bool result);
```

### finished

Returns if there are any more elements left to shuffle.
Reverts if `$` is not initialized.


```solidity
function finished(LazyShuffler storage $) internal view returns (bool result);
```

### get

Returns the current value stored at `index`, accounting for all historical shuffling.
Reverts if `index` is greater than or equal to the `length` of `$`.


```solidity
function get(LazyShuffler storage $, uint256 index) internal view returns (uint256 result);
```

### next

Does a single Fisher-Yates shuffle step, increments the `numShuffled` in `$`,
and returns the next value in the shuffled range.
`randomness` can be taken from a good-enough source, or a higher quality source like VRF.
Reverts if there are no more values to shuffle, which includes the case if `$` is not initialized.


```solidity
function next(LazyShuffler storage $, uint256 randomness) internal returns (uint256 chosen);
```

### _toUints

Reinterpret cast to an uint256 array.


```solidity
function _toUints(int256[] memory a) private pure returns (uint256[] memory casted);
```

### _toUints

Reinterpret cast to an uint256 array.


```solidity
function _toUints(address[] memory a) private pure returns (uint256[] memory casted);
```

## Errors
### InvalidInitialLazyShufflerLength
The initial length must be greater than zero and less than `2**32 - 1`.


```solidity
error InvalidInitialLazyShufflerLength();
```

### InvalidNewLazyShufflerLength
The new length must not be less than the current length.


```solidity
error InvalidNewLazyShufflerLength();
```

### LazyShufflerNotInitialized
The lazy shuffler has not been initialized.


```solidity
error LazyShufflerNotInitialized();
```

### LazyShufflerAlreadyInitialized
Cannot double initialize the lazy shuffler.


```solidity
error LazyShufflerAlreadyInitialized();
```

### LazyShuffleFinished
The lazy shuffle has finished.


```solidity
error LazyShuffleFinished();
```

### LazyShufflerGetOutOfBounds
The queried index is out of bounds.


```solidity
error LazyShufflerGetOutOfBounds();
```

## Structs
### PRNG
A pseudorandom number state in memory.


```solidity
struct PRNG {
    uint256 state;
}
```

### LazyShuffler
A lazy Fisher-Yates shuffler for a range `[0..n)` in storage.


```solidity
struct LazyShuffler {
    // Bits Layout:
    // - [0..31]    `numShuffled`
    // - [32..223]  `permutationSlot`
    // - [224..255] `length`
    uint256 _state;
}
```

