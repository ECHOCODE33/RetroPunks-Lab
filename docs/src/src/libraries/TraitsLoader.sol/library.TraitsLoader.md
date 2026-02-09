# TraitsLoader
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/libraries/TraitsLoader.sol)


## Functions
### initCachedTraitGroups


```solidity
function initCachedTraitGroups(uint256 _traitGroupsLength) public pure returns (CachedTraitGroups memory);
```

### loadAndCacheTraitGroup


```solidity
function loadAndCacheTraitGroup(IAssets _assetsContract, CachedTraitGroups memory _cachedTraitGroups, uint256 _traitGroupIndex) public view returns (TraitGroup memory);
```

### _decodeTraitGroupName


```solidity
function _decodeTraitGroupName(bytes memory traitGroupData, uint256 startIndex) internal pure returns (bytes memory);
```

### _decodeTraitGroupPalette


```solidity
function _decodeTraitGroupPalette(bytes memory traitGroupData, uint256 startIndex) internal pure returns (uint32[] memory paletteRgba, uint256 nextIndex);
```

### _memoryCopy


```solidity
function _memoryCopy(bytes memory dest, uint256 destOffset, bytes memory src, uint256 srcOffset, uint256 len) internal pure;
```

