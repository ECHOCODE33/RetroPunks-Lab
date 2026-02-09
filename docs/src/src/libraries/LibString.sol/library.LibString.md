# LibString
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/libraries/LibString.sol)

**Authors:**
Solady (https://github.com/vectorized/solady/blob/main/src/utils/LibString.sol), Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/LibString.sol)

Library for converting numbers into strings and other string operations.

Note:
For performance and bytecode compactness, most of the string operations are restricted to
byte strings (7-bit ASCII), except where otherwise specified.
Usage of byte string operations on charsets with runes spanning two or more bytes
can lead to undefined behavior.


## State Variables
### NOT_FOUND
The constant returned when the `search` is not found in the string.


```solidity
uint256 internal constant NOT_FOUND = type(uint256).max
```


### ALPHANUMERIC_7_BIT_ASCII
Lookup for '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.


```solidity
uint128 internal constant ALPHANUMERIC_7_BIT_ASCII = 0x7fffffe07fffffe03ff000000000000
```


### LETTERS_7_BIT_ASCII
Lookup for 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.


```solidity
uint128 internal constant LETTERS_7_BIT_ASCII = 0x7fffffe07fffffe0000000000000000
```


### LOWERCASE_7_BIT_ASCII
Lookup for 'abcdefghijklmnopqrstuvwxyz'.


```solidity
uint128 internal constant LOWERCASE_7_BIT_ASCII = 0x7fffffe000000000000000000000000
```


### UPPERCASE_7_BIT_ASCII
Lookup for 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.


```solidity
uint128 internal constant UPPERCASE_7_BIT_ASCII = 0x7fffffe0000000000000000
```


### DIGITS_7_BIT_ASCII
Lookup for '0123456789'.


```solidity
uint128 internal constant DIGITS_7_BIT_ASCII = 0x3ff000000000000
```


### HEXDIGITS_7_BIT_ASCII
Lookup for '0123456789abcdefABCDEF'.


```solidity
uint128 internal constant HEXDIGITS_7_BIT_ASCII = 0x7e0000007e03ff000000000000
```


### OCTDIGITS_7_BIT_ASCII
Lookup for '01234567'.


```solidity
uint128 internal constant OCTDIGITS_7_BIT_ASCII = 0xff000000000000
```


### PRINTABLE_7_BIT_ASCII
Lookup for '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~ \t\n\r\x0b\x0c'.


```solidity
uint128 internal constant PRINTABLE_7_BIT_ASCII = 0x7fffffffffffffffffffffff00003e00
```


### PUNCTUATION_7_BIT_ASCII
Lookup for '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'.


```solidity
uint128 internal constant PUNCTUATION_7_BIT_ASCII = 0x78000001f8000001fc00fffe00000000
```


### WHITESPACE_7_BIT_ASCII
Lookup for ' \t\n\r\x0b\x0c'.


```solidity
uint128 internal constant WHITESPACE_7_BIT_ASCII = 0x100003e00
```


## Functions
### set

Sets the value of the string storage `$` to `s`.


```solidity
function set(StringStorage storage $, string memory s) internal;
```

### setCalldata

Sets the value of the string storage `$` to `s`.


```solidity
function setCalldata(StringStorage storage $, string calldata s) internal;
```

### clear

Sets the value of the string storage `$` to the empty string.


```solidity
function clear(StringStorage storage $) internal;
```

### isEmpty

Returns whether the value stored is `$` is the empty string "".


```solidity
function isEmpty(StringStorage storage $) internal view returns (bool);
```

### length

Returns the length of the value stored in `$`.


```solidity
function length(StringStorage storage $) internal view returns (uint256);
```

### get

Returns the value stored in `$`.


```solidity
function get(StringStorage storage $) internal view returns (string memory);
```

### uint8At

Returns the uint8 at index `i`. If out-of-bounds, returns 0.


```solidity
function uint8At(StringStorage storage $, uint256 i) internal view returns (uint8);
```

### bytesStorage

Helper to cast `$` to a `BytesStorage`.


```solidity
function bytesStorage(StringStorage storage $) internal pure returns (LibBytes.BytesStorage storage casted);
```

### toString

Returns the base 10 decimal representation of `value`.


```solidity
function toString(uint256 value) internal pure returns (string memory result);
```

### toString

Returns the base 10 decimal representation of `value`.


```solidity
function toString(int256 value) internal pure returns (string memory result);
```

### toHexString

Returns the hexadecimal representation of `value`,
left-padded to an input length of `byteCount` bytes.
The output is prefixed with "0x" encoded using 2 hexadecimal digits per byte,
giving a total length of `byteCount * 2 + 2` bytes.
Reverts if `byteCount` is too small for the output to contain all the digits.


```solidity
function toHexString(uint256 value, uint256 byteCount) internal pure returns (string memory result);
```

### toHexStringNoPrefix

Returns the hexadecimal representation of `value`,
left-padded to an input length of `byteCount` bytes.
The output is not prefixed with "0x" and is encoded using 2 hexadecimal digits per byte,
giving a total length of `byteCount * 2` bytes.
Reverts if `byteCount` is too small for the output to contain all the digits.


```solidity
function toHexStringNoPrefix(uint256 value, uint256 byteCount) internal pure returns (string memory result);
```

### toHexString

Returns the hexadecimal representation of `value`.
The output is prefixed with "0x" and encoded using 2 hexadecimal digits per byte.
As address are 20 bytes long, the output will left-padded to have
a length of `20 * 2 + 2` bytes.


```solidity
function toHexString(uint256 value) internal pure returns (string memory result);
```

### toMinimalHexString

Returns the hexadecimal representation of `value`.
The output is prefixed with "0x".
The output excludes leading "0" from the `toHexString` output.
`0x00: "0x0", 0x01: "0x1", 0x12: "0x12", 0x123: "0x123"`.


```solidity
function toMinimalHexString(uint256 value) internal pure returns (string memory result);
```

### toMinimalHexStringNoPrefix

Returns the hexadecimal representation of `value`.
The output excludes leading "0" from the `toHexStringNoPrefix` output.
`0x00: "0", 0x01: "1", 0x12: "12", 0x123: "123"`.


```solidity
function toMinimalHexStringNoPrefix(uint256 value) internal pure returns (string memory result);
```

### toHexStringNoPrefix

Returns the hexadecimal representation of `value`.
The output is encoded using 2 hexadecimal digits per byte.
As address are 20 bytes long, the output will left-padded to have
a length of `20 * 2` bytes.


```solidity
function toHexStringNoPrefix(uint256 value) internal pure returns (string memory result);
```

### toHexStringChecksummed

Returns the hexadecimal representation of `value`.
The output is prefixed with "0x", encoded using 2 hexadecimal digits per byte,
and the alphabets are capitalized conditionally according to
https://eips.ethereum.org/EIPS/eip-55


```solidity
function toHexStringChecksummed(address value) internal pure returns (string memory result);
```

### toHexString

Returns the hexadecimal representation of `value`.
The output is prefixed with "0x" and encoded using 2 hexadecimal digits per byte.


```solidity
function toHexString(address value) internal pure returns (string memory result);
```

### toHexStringNoPrefix

Returns the hexadecimal representation of `value`.
The output is encoded using 2 hexadecimal digits per byte.


```solidity
function toHexStringNoPrefix(address value) internal pure returns (string memory result);
```

### toHexString

Returns the hex encoded string from the raw bytes.
The output is encoded using 2 hexadecimal digits per byte.


```solidity
function toHexString(bytes memory raw) internal pure returns (string memory result);
```

### toHexStringNoPrefix

Returns the hex encoded string from the raw bytes.
The output is encoded using 2 hexadecimal digits per byte.


```solidity
function toHexStringNoPrefix(bytes memory raw) internal pure returns (string memory result);
```

### runeCount

Returns the number of UTF characters in the string.


```solidity
function runeCount(string memory s) internal pure returns (uint256 result);
```

### is7BitASCII

Returns if this string is a 7-bit ASCII string.
(i.e. all characters codes are in [0..127])


```solidity
function is7BitASCII(string memory s) internal pure returns (bool result);
```

### is7BitASCII

Returns if this string is a 7-bit ASCII string,
AND all characters are in the `allowed` lookup.
Note: If `s` is empty, returns true regardless of `allowed`.


```solidity
function is7BitASCII(string memory s, uint128 allowed) internal pure returns (bool result);
```

### to7BitASCIIAllowedLookup

Converts the bytes in the 7-bit ASCII string `s` to
an allowed lookup for use in `is7BitASCII(s, allowed)`.
To save runtime gas, you can cache the result in an immutable variable.


```solidity
function to7BitASCIIAllowedLookup(string memory s) internal pure returns (uint128 result);
```

### replace

Returns `subject` all occurrences of `needle` replaced with `replacement`.


```solidity
function replace(string memory subject, string memory needle, string memory replacement) internal pure returns (string memory);
```

### indexOf

Returns the byte index of the first location of `needle` in `subject`,
needleing from left to right, starting from `from`.
Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `needle` is not found.


```solidity
function indexOf(string memory subject, string memory needle, uint256 from) internal pure returns (uint256);
```

### indexOf

Returns the byte index of the first location of `needle` in `subject`,
needleing from left to right.
Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `needle` is not found.


```solidity
function indexOf(string memory subject, string memory needle) internal pure returns (uint256);
```

### lastIndexOf

Returns the byte index of the first location of `needle` in `subject`,
needleing from right to left, starting from `from`.
Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `needle` is not found.


```solidity
function lastIndexOf(string memory subject, string memory needle, uint256 from) internal pure returns (uint256);
```

### lastIndexOf

Returns the byte index of the first location of `needle` in `subject`,
needleing from right to left.
Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `needle` is not found.


```solidity
function lastIndexOf(string memory subject, string memory needle) internal pure returns (uint256);
```

### contains

Returns true if `needle` is found in `subject`, false otherwise.


```solidity
function contains(string memory subject, string memory needle) internal pure returns (bool);
```

### startsWith

Returns whether `subject` starts with `needle`.


```solidity
function startsWith(string memory subject, string memory needle) internal pure returns (bool);
```

### endsWith

Returns whether `subject` ends with `needle`.


```solidity
function endsWith(string memory subject, string memory needle) internal pure returns (bool);
```

### repeat

Returns `subject` repeated `times`.


```solidity
function repeat(string memory subject, uint256 times) internal pure returns (string memory);
```

### slice

Returns a copy of `subject` sliced from `start` to `end` (exclusive).
`start` and `end` are byte offsets.


```solidity
function slice(string memory subject, uint256 start, uint256 end) internal pure returns (string memory);
```

### slice

Returns a copy of `subject` sliced from `start` to the end of the string.
`start` is a byte offset.


```solidity
function slice(string memory subject, uint256 start) internal pure returns (string memory);
```

### indicesOf

Returns all the indices of `needle` in `subject`.
The indices are byte offsets.


```solidity
function indicesOf(string memory subject, string memory needle) internal pure returns (uint256[] memory);
```

### split

Returns an arrays of strings based on the `delimiter` inside of the `subject` string.


```solidity
function split(string memory subject, string memory delimiter) internal pure returns (string[] memory result);
```

### concat

Returns a concatenated string of `a` and `b`.
Cheaper than `string.concat()` and does not de-align the free memory pointer.


```solidity
function concat(string memory a, string memory b) internal pure returns (string memory);
```

### toCase

Returns a copy of the string in either lowercase or UPPERCASE.
WARNING! This function is only compatible with 7-bit ASCII strings.


```solidity
function toCase(string memory subject, bool toUpper) internal pure returns (string memory result);
```

### fromSmallString

Returns a string from a small bytes32 string.
`s` must be null-terminated, or behavior will be undefined.


```solidity
function fromSmallString(bytes32 s) internal pure returns (string memory result);
```

### normalizeSmallString

Returns the small string, with all bytes after the first null byte zeroized.


```solidity
function normalizeSmallString(bytes32 s) internal pure returns (bytes32 result);
```

### toSmallString

Returns the string as a normalized null-terminated small string.


```solidity
function toSmallString(string memory s) internal pure returns (bytes32 result);
```

### lower

Returns a lowercased copy of the string.
WARNING! This function is only compatible with 7-bit ASCII strings.


```solidity
function lower(string memory subject) internal pure returns (string memory result);
```

### upper

Returns an UPPERCASED copy of the string.
WARNING! This function is only compatible with 7-bit ASCII strings.


```solidity
function upper(string memory subject) internal pure returns (string memory result);
```

### escapeHTML

Escapes the string to be used within HTML tags.


```solidity
function escapeHTML(string memory s) internal pure returns (string memory result);
```

### escapeJSON

Escapes the string to be used within double-quotes in a JSON.
If `addDoubleQuotes` is true, the result will be enclosed in double-quotes.


```solidity
function escapeJSON(string memory s, bool addDoubleQuotes) internal pure returns (string memory result);
```

### escapeJSON

Escapes the string to be used within double-quotes in a JSON.


```solidity
function escapeJSON(string memory s) internal pure returns (string memory result);
```

### encodeURIComponent

Encodes `s` so that it can be safely used in a URI,
just like `encodeURIComponent` in JavaScript.
See: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURIComponent
See: https://datatracker.ietf.org/doc/html/rfc2396
See: https://datatracker.ietf.org/doc/html/rfc3986


```solidity
function encodeURIComponent(string memory s) internal pure returns (string memory result);
```

### eq

Returns whether `a` equals `b`.


```solidity
function eq(string memory a, string memory b) internal pure returns (bool result);
```

### eqs

Returns whether `a` equals `b`, where `b` is a null-terminated small string.


```solidity
function eqs(string memory a, bytes32 b) internal pure returns (bool result);
```

### cmp

Returns 0 if `a == b`, -1 if `a < b`, +1 if `a > b`.
If `a` == b[:a.length]`, and `a.length < b.length`, returns -1.


```solidity
function cmp(string memory a, string memory b) internal pure returns (int256);
```

### packOne

Packs a single string with its length into a single word.
Returns `bytes32(0)` if the length is zero or greater than 31.


```solidity
function packOne(string memory a) internal pure returns (bytes32 result);
```

### unpackOne

Unpacks a string packed using [packOne](/src/libraries/LibString.sol/library.LibString.md#packone).
Returns the empty string if `packed` is `bytes32(0)`.
If `packed` is not an output of [packOne](/src/libraries/LibString.sol/library.LibString.md#packone), the output behavior is undefined.


```solidity
function unpackOne(bytes32 packed) internal pure returns (string memory result);
```

### packTwo

Packs two strings with their lengths into a single word.
Returns `bytes32(0)` if combined length is zero or greater than 30.


```solidity
function packTwo(string memory a, string memory b) internal pure returns (bytes32 result);
```

### unpackTwo

Unpacks strings packed using [packTwo](/src/libraries/LibString.sol/library.LibString.md#packtwo).
Returns the empty strings if `packed` is `bytes32(0)`.
If `packed` is not an output of [packTwo](/src/libraries/LibString.sol/library.LibString.md#packtwo), the output behavior is undefined.


```solidity
function unpackTwo(bytes32 packed) internal pure returns (string memory resultA, string memory resultB);
```

### directReturn

Directly returns `a` without copying.


```solidity
function directReturn(string memory a) internal pure;
```

## Errors
### HexLengthInsufficient
The length of the output is too small to contain all the hex digits.


```solidity
error HexLengthInsufficient();
```

### TooBigForSmallString
The length of the string is more than 32 bytes.


```solidity
error TooBigForSmallString();
```

### StringNot7BitASCII
The input string must be a 7-bit ASCII.


```solidity
error StringNot7BitASCII();
```

## Structs
### StringStorage
Goated string storage struct that totally MOGs, no cap, fr.
Uses less gas and bytecode than Solidity's native string storage. It's meta af.
Packs length with the first 31 bytes if <255 bytes, so it’s mad tight.


```solidity
struct StringStorage {
    bytes32 _spacer;
}
```

