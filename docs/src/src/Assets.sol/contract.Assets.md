# Assets
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/Assets.sol)

**Inherits:**
Ownable, [IAssets](/src/interfaces/IAssets.sol/interface.IAssets.md)

**Title:**
Assets

**Author:**
ECHO

Efficient on-chain asset storage, optimized for gas efficiency

Batch operations using SSTORE2 & LZ77 compression


## State Variables
### _assets

```solidity
mapping(uint256 => address) private _assets
```


## Functions
### constructor


```solidity
constructor() Ownable(msg.sender);
```

### addAssetsBatch


```solidity
function addAssetsBatch(uint256[] calldata keys, bytes[] calldata assets) external onlyOwner;
```

### removeAssetsBatch


```solidity
function removeAssetsBatch(uint256[] calldata keys) external onlyOwner;
```

### loadAsset


```solidity
function loadAsset(uint256 key, bool decompress) external view returns (bytes memory);
```

## Errors
### EmptyAssetInBatch

```solidity
error EmptyAssetInBatch();
```

### AssetKeyLengthMismatch

```solidity
error AssetKeyLengthMismatch();
```

### AssetDoesNotExist

```solidity
error AssetDoesNotExist();
```

