# DynamicBuffer
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/libraries/DynamicBuffer.sol)

**Title:**
DynamicBuffer

**Author:**
David Huber (@cxkoda) and Simon Fremaux (@dievardump). See also
https://raw.githubusercontent.com/dievardump/solidity-dynamic-buffer

This library is used to allocate a big amount of container memory
memory.

First, allocate memory.
Then use `buffer.appendUnchecked(theBytes)` or `appendSafe()` if
bounds checking is required.


## Functions
### allocate

Allocates container space for the DynamicBuffer

Allocates `capacity_ + 0x60` bytes of space
The buffer array starts at the first container data position,
(i.e. `buffer = container + 0x20`)


```solidity
function allocate(uint256 capacity_) internal pure returns (bytes memory buffer);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`capacity_`|`uint256`|The intended max amount of bytes in the buffer|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`buffer`|`bytes`|The memory location of the buffer|


### resetBuffer

Resets the buffer

Resets the buffer and allow the space to be used again without the need to allocating it a lot.
Potential gas improvement for certain usecases


```solidity
function resetBuffer(bytes memory buffer) internal pure;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`buffer`|`bytes`|the buffer to append the data to|


### appendUnchecked

Appends data to buffer, and update buffer length

Does not perform out-of-bound checks (container capacity)
for efficiency.


```solidity
function appendUnchecked(bytes memory buffer, bytes memory data) internal pure;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`buffer`|`bytes`|the buffer to append the data to|
|`data`|`bytes`|the data to append|


### appendUnchecked

Appends data to buffer, and update buffer length

Does not perform out-of-bound checks (container capacity)
for efficiency.


```solidity
function appendUnchecked(bytes memory buffer, bytes memory data, uint256 start, uint256 end) internal pure;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`buffer`|`bytes`|the buffer to append the data to|
|`data`|`bytes`|the data to append|
|`start`|`uint256`|the start index of the data to append|
|`end`|`uint256`|the end index of the data to append|


### appendSafe

Appends data to buffer, and update buffer length

Performs out-of-bound checks and calls `appendUnchecked`.


```solidity
function appendSafe(bytes memory buffer, bytes memory data) internal pure;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`buffer`|`bytes`|the buffer to append the data to|
|`data`|`bytes`|the data to append|


### appendSafeBase64

Appends data encoded as Base64 to buffer.

Encodes `data` using the base64 encoding described in RFC 4648.
See: https://datatracker.ietf.org/doc/html/rfc4648
Author: Modified from Solady (https://github.com/vectorized/solady/blob/main/src/utils/Base64.sol)
Author: Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/Base64.sol)
Author: Modified from (https://github.com/Brechtpd/base64/blob/main/base64.sol) by Brecht Devos.


```solidity
function appendSafeBase64(bytes memory buffer, bytes memory data, bool fileSafe, bool noPadding) internal pure;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`buffer`|`bytes`||
|`data`|`bytes`||
|`fileSafe`|`bool`| Whether to replace '+' with '-' and '/' with '_'.|
|`noPadding`|`bool`|Whether to strip away the padding.|


### capacity

Returns the capacity of a given buffer.


```solidity
function capacity(bytes memory buffer) internal pure returns (uint256);
```

### checkOverflow

Reverts if the buffer will overflow after appending a given
number of bytes.


```solidity
function checkOverflow(bytes memory buffer, uint256 addedLength) internal pure;
```

