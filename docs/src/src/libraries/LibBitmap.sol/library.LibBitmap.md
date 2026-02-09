# LibBitmap
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/libraries/LibBitmap.sol)


## State Variables
### MAGIC_TRANSPARENT

```solidity
uint32 constant MAGIC_TRANSPARENT = 0x5f5d6eFF
```


### _PNG_SIG

```solidity
bytes constant _PNG_SIG = hex"89504E470D0A1A0A"
```


### _IHDR

```solidity
bytes constant _IHDR = hex"0000000D" hex"49484452" hex"00000030" hex"00000030" hex"08" hex"06" hex"00" hex"00" hex"00" hex"5702F987"
```


### _IEND

```solidity
bytes constant _IEND = hex"00000000" hex"49454E44" hex"AE426082"
```


## Functions
### renderPixelToBitMap


```solidity
function renderPixelToBitMap(BitMap memory bitMap, uint256 x, uint256 y, uint32 src) internal pure;
```

### toURLEncodedPNG


```solidity
function toURLEncodedPNG(BitMap memory bmp) internal pure returns (string memory);
```

### _applyChromaKey


```solidity
function _applyChromaKey(BitMap memory bmp) private pure;
```

### toPNG


```solidity
function toPNG(BitMap memory bmp) internal pure returns (bytes memory);
```

### _packScanLines


```solidity
function _packScanLines(BitMap memory bmp) private pure returns (bytes memory raw);
```

### _makeZlibStored


```solidity
function _makeZlibStored(bytes memory raw) private pure returns (bytes memory z);
```

### _makeChunk


```solidity
function _makeChunk(bytes4 t, bytes memory d) private pure returns (bytes memory);
```

### _adler32


```solidity
function _adler32(bytes memory buf) private pure returns (uint32);
```

### _crc32


```solidity
function _crc32(bytes memory data) private pure returns (uint32);
```

### _u32be


```solidity
function _u32be(uint32 v) private pure returns (bytes4);
```

### _u16le


```solidity
function _u16le(uint16 v) private pure returns (bytes2);
```

