# MetaGen
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/MetaGen.sol)

**Inherits:**
[IMetaGen](/src/interfaces/IMetaGen.sol/interface.IMetaGen.md)

**Title:**
MetaGen (Metadata Generator)

**Author:**
ECHO

Generates rendered SVG & JSON attributes for the RetroPunks collection, optimized for gas efficiency

Uses TraitsLoader & TraitsRenderer libraries to efficiently generate base64 encoded SVG


## State Variables
### _ASSETS_CONTRACT

```solidity
IAssets private immutable _ASSETS_CONTRACT
```


### _TRAITS_CONTRACT

```solidity
ITraits private immutable _TRAITS_CONTRACT
```


### SVG_HEADER

```solidity
bytes private constant SVG_HEADER =
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><style>img{image-rendering:pixelated;shape-rendering:crispEdges;image-rendering:-moz-crisp-edges;}</style><g id="GeneratedImage"><foreignObject width="48" height="48"><img xmlns="http://www.w3.org/1999/xhtml" src="data:image/png;base64,'
```


### SVG_FOOTER

```solidity
bytes private constant SVG_FOOTER = '" width="100%" height="100%"/></foreignObject></g></svg>'
```


## Functions
### constructor


```solidity
constructor(IAssets assetsContract, ITraits traitsContract) ;
```

### generateMetadata


```solidity
function generateMetadata(uint16 tokenIdSeed, uint8 backgroundIndex, uint256 globalSeed) public view returns (string memory svg, string memory attributes);
```

### _prepareCache


```solidity
function _prepareCache(CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal view;
```

### _renderPreRenderedSpecial


```solidity
function _renderPreRenderedSpecial(bytes memory buffer, TraitsContext memory traits, CachedTraitGroups memory cachedTraitGroups)
    internal
    view
    returns (string memory svg, string memory attributes);
```

### _getTraitsAsJson


```solidity
function _getTraitsAsJson(CachedTraitGroups memory cachedTraitGroups, TraitsContext memory traits) internal pure returns (string memory);
```

### _stringTrait


```solidity
function _stringTrait(string memory traitName, string memory traitValue) internal pure returns (bytes memory);
```

