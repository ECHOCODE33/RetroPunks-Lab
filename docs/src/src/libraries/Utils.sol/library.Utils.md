# Utils
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/libraries/Utils.sol)


## Functions
### toString


```solidity
function toString(bytes32 _bytes32) internal pure returns (string memory);
```

### toString


```solidity
function toString(uint256 value) internal pure returns (string memory str);
```

### toString


```solidity
function toString(int256 value) internal pure returns (string memory str);
```

### toByteArray


```solidity
function toByteArray(bytes32 _bytes32) internal pure returns (bytes memory);
```

### concat


```solidity
function concat(bytes memory buffer, bytes memory c1) internal pure;
```

### concatBase64


```solidity
function concatBase64(bytes memory buffer, bytes memory c1) internal pure;
```

### encodeBase64


```solidity
function encodeBase64(bytes memory data) internal pure returns (string memory result);
```

### _encodeBase64


```solidity
function _encodeBase64(bytes memory data, bool fileSafe, bool noPadding) internal pure returns (string memory result);
```

### divisionString


```solidity
function divisionString(uint8 decimalPlaces, int256 numerator, int256 denominator) internal pure returns (string memory);
```

### _division


```solidity
function _division(uint8 decimalPlaces, int256 numerator, int256 denominator) internal pure returns (int256 quotient, int256 remainder, string memory result);
```

### _numToFixedLengthStr


```solidity
function _numToFixedLengthStr(uint256 decimalPlaces, int256 num) internal pure returns (string memory result);
```

