# IAssets
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/interfaces/IAssets.sol)


## Functions
### addAssetsBatch


```solidity
function addAssetsBatch(uint256[] calldata keys, bytes[] calldata assets) external;
```

### removeAssetsBatch


```solidity
function removeAssetsBatch(uint256[] calldata keys) external;
```

### loadAsset


```solidity
function loadAsset(uint256 key, bool decompress) external view returns (bytes memory);
```

