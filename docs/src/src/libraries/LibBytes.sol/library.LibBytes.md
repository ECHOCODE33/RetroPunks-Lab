# LibBytes
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/libraries/LibBytes.sol)

**Author:**
Solady (https://github.com/vectorized/solady/blob/main/src/utils/LibBytes.sol)

Library for byte related operations.


## State Variables
### NOT_FOUND
The constant returned when the `search` is not found in the bytes.


```solidity
uint256 internal constant NOT_FOUND = type(uint256).max
```


## Functions
### set

Sets the value of the bytes storage `$` to `s`.


```solidity
function set(BytesStorage storage $, bytes memory s) internal;
```

### setCalldata

Sets the value of the bytes storage `$` to `s`.


```solidity
function setCalldata(BytesStorage storage $, bytes calldata s) internal;
```

### clear

Sets the value of the bytes storage `$` to the empty bytes.


```solidity
function clear(BytesStorage storage $) internal;
```

### isEmpty

Returns whether the value stored is `$` is the empty bytes "".


```solidity
function isEmpty(BytesStorage storage $) internal view returns (bool);
```

### length

Returns the length of the value stored in `$`.


```solidity
function length(BytesStorage storage $) internal view returns (uint256 result);
```

### get

Returns the value stored in `$`.


```solidity
function get(BytesStorage storage $) internal view returns (bytes memory result);
```

### uint8At

Returns the uint8 at index `i`. If out-of-bounds, returns 0.


```solidity
function uint8At(BytesStorage storage $, uint256 i) internal view returns (uint8 result);
```

### replace

Returns `subject` all occurrences of `needle` replaced with `replacement`.


```solidity
function replace(bytes memory subject, bytes memory needle, bytes memory replacement) internal pure returns (bytes memory result);
```

### indexOf

Returns the byte index of the first location of `needle` in `subject`,
needleing from left to right, starting from `from`.
Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `needle` is not found.


```solidity
function indexOf(bytes memory subject, bytes memory needle, uint256 from) internal pure returns (uint256 result);
```

### indexOfByte

Returns the byte index of the first location of `needle` in `subject`,
needleing from left to right, starting from `from`. Optimized for byte needles.
Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `needle` is not found.


```solidity
function indexOfByte(bytes memory subject, bytes1 needle, uint256 from) internal pure returns (uint256 result);
```

### indexOfByte

Returns the byte index of the first location of `needle` in `subject`,
needleing from left to right. Optimized for byte needles.
Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `needle` is not found.


```solidity
function indexOfByte(bytes memory subject, bytes1 needle) internal pure returns (uint256 result);
```

### indexOf

Returns the byte index of the first location of `needle` in `subject`,
needleing from left to right.
Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `needle` is not found.


```solidity
function indexOf(bytes memory subject, bytes memory needle) internal pure returns (uint256);
```

### lastIndexOf

Returns the byte index of the first location of `needle` in `subject`,
needleing from right to left, starting from `from`.
Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `needle` is not found.


```solidity
function lastIndexOf(bytes memory subject, bytes memory needle, uint256 from) internal pure returns (uint256 result);
```

### lastIndexOf

Returns the byte index of the first location of `needle` in `subject`,
needleing from right to left.
Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `needle` is not found.


```solidity
function lastIndexOf(bytes memory subject, bytes memory needle) internal pure returns (uint256);
```

### contains

Returns true if `needle` is found in `subject`, false otherwise.


```solidity
function contains(bytes memory subject, bytes memory needle) internal pure returns (bool);
```

### startsWith

Returns whether `subject` starts with `needle`.


```solidity
function startsWith(bytes memory subject, bytes memory needle) internal pure returns (bool result);
```

### endsWith

Returns whether `subject` ends with `needle`.


```solidity
function endsWith(bytes memory subject, bytes memory needle) internal pure returns (bool result);
```

### repeat

Returns `subject` repeated `times`.


```solidity
function repeat(bytes memory subject, uint256 times) internal pure returns (bytes memory result);
```

### slice

Returns a copy of `subject` sliced from `start` to `end` (exclusive).
`start` and `end` are byte offsets.


```solidity
function slice(bytes memory subject, uint256 start, uint256 end) internal pure returns (bytes memory result);
```

### slice

Returns a copy of `subject` sliced from `start` to the end of the bytes.
`start` is a byte offset.


```solidity
function slice(bytes memory subject, uint256 start) internal pure returns (bytes memory result);
```

### sliceCalldata

Returns a copy of `subject` sliced from `start` to `end` (exclusive).
`start` and `end` are byte offsets. Faster than Solidity's native slicing.


```solidity
function sliceCalldata(bytes calldata subject, uint256 start, uint256 end) internal pure returns (bytes calldata result);
```

### sliceCalldata

Returns a copy of `subject` sliced from `start` to the end of the bytes.
`start` is a byte offset. Faster than Solidity's native slicing.


```solidity
function sliceCalldata(bytes calldata subject, uint256 start) internal pure returns (bytes calldata result);
```

### truncate

Reduces the size of `subject` to `n`.
If `n` is greater than the size of `subject`, this will be a no-op.


```solidity
function truncate(bytes memory subject, uint256 n) internal pure returns (bytes memory result);
```

### truncatedCalldata

Returns a copy of `subject`, with the length reduced to `n`.
If `n` is greater than the size of `subject`, this will be a no-op.


```solidity
function truncatedCalldata(bytes calldata subject, uint256 n) internal pure returns (bytes calldata result);
```

### indicesOf

Returns all the indices of `needle` in `subject`.
The indices are byte offsets.


```solidity
function indicesOf(bytes memory subject, bytes memory needle) internal pure returns (uint256[] memory result);
```

### split

Returns an arrays of bytess based on the `delimiter` inside of the `subject` bytes.


```solidity
function split(bytes memory subject, bytes memory delimiter) internal pure returns (bytes[] memory result);
```

### concat

Returns a concatenated bytes of `a` and `b`.
Cheaper than `bytes.concat()` and does not de-align the free memory pointer.


```solidity
function concat(bytes memory a, bytes memory b) internal pure returns (bytes memory result);
```

### eq

Returns whether `a` equals `b`.


```solidity
function eq(bytes memory a, bytes memory b) internal pure returns (bool result);
```

### eqs

Returns whether `a` equals `b`, where `b` is a null-terminated small bytes.


```solidity
function eqs(bytes memory a, bytes32 b) internal pure returns (bool result);
```

### cmp

Returns 0 if `a == b`, -1 if `a < b`, +1 if `a > b`.
If `a` == b[:a.length]`, and `a.length < b.length`, returns -1.


```solidity
function cmp(bytes memory a, bytes memory b) internal pure returns (int256 result);
```

### directReturn

Directly returns `a` without copying.


```solidity
function directReturn(bytes memory a) internal pure;
```

### directReturn

Directly returns `a` with minimal copying.


```solidity
function directReturn(bytes[] memory a) internal pure;
```

### load

Returns the word at `offset`, without any bounds checks.


```solidity
function load(bytes memory a, uint256 offset) internal pure returns (bytes32 result);
```

### loadCalldata

Returns the word at `offset`, without any bounds checks.


```solidity
function loadCalldata(bytes calldata a, uint256 offset) internal pure returns (bytes32 result);
```

### staticStructInCalldata

Returns a slice representing a static struct in the calldata. Performs bounds checks.


```solidity
function staticStructInCalldata(bytes calldata a, uint256 offset) internal pure returns (bytes calldata result);
```

### dynamicStructInCalldata

Returns a slice representing a dynamic struct in the calldata. Performs bounds checks.


```solidity
function dynamicStructInCalldata(bytes calldata a, uint256 offset) internal pure returns (bytes calldata result);
```

### bytesInCalldata

Returns bytes in calldata. Performs bounds checks.


```solidity
function bytesInCalldata(bytes calldata a, uint256 offset) internal pure returns (bytes calldata result);
```

### checkInCalldata

Checks if `x` is in `a`. Assumes `a` has been checked.


```solidity
function checkInCalldata(bytes calldata x, bytes calldata a) internal pure;
```

### checkInCalldata

Checks if `x` is in `a`. Assumes `a` has been checked.


```solidity
function checkInCalldata(bytes[] calldata x, bytes calldata a) internal pure;
```

### emptyCalldata

Returns empty calldata bytes. For silencing the compiler.


```solidity
function emptyCalldata() internal pure returns (bytes calldata result);
```

### msbToAddress

Returns the most significant 20 bytes as an address.


```solidity
function msbToAddress(bytes32 x) internal pure returns (address);
```

### lsbToAddress

Returns the least significant 20 bytes as an address.


```solidity
function lsbToAddress(bytes32 x) internal pure returns (address);
```

## Structs
### BytesStorage
Goated bytes storage struct that totally MOGs, no cap, fr.
Uses less gas and bytecode than Solidity's native bytes storage. It's meta af.
Packs length with the first 31 bytes if <255 bytes, so it’s mad tight.


```solidity
struct BytesStorage {
    bytes32 _spacer;
}
```

