# TraitsRenderer
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/libraries/TraitsRenderer.sol)


## Functions
### renderGridToSvg


```solidity
function renderGridToSvg(IAssets assetsContract, bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal view;
```

### _renderBackground


```solidity
function _renderBackground(IAssets assetsContract, bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) private view;
```

### _renderTraitGroup


```solidity
function _renderTraitGroup(BitMap memory bitMap, CachedTraitGroups memory cachedTraitGroups, uint8 traitGroupIndex, uint8 traitIndex) internal pure;
```

### _renderPixelGradientStops


```solidity
function _renderPixelGradientStops(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, uint256 traitGroupIndex, TraitInfo memory trait) private pure;
```

### _renderSmoothGradientStops


```solidity
function _renderSmoothGradientStops(bytes memory buffer, CachedTraitGroups memory cachedTraitGroups, uint256 traitGroupIndex, TraitInfo memory trait) private pure;
```

### _decodePaletteIndex


```solidity
function _decodePaletteIndex(bytes memory data, uint256 offset, uint8 byteSize) internal pure returns (uint16);
```

### _writeColorStop


```solidity
function _writeColorStop(bytes memory buffer, uint32 packedRgba) internal pure;
```

### _writeHexColor


```solidity
function _writeHexColor(bytes memory buffer, uint32 rgba) private pure;
```

