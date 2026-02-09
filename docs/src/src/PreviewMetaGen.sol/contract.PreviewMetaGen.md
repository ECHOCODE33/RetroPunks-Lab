# PreviewMetaGen
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/PreviewMetaGen.sol)

**Inherits:**
[IMetaGen](/src/interfaces/IMetaGen.sol/interface.IMetaGen.md)

**Title:**
PreviewMetaGen (Preview Metadata Generator)

**Author:**
ECHO

Generates preview GIF & JSON attributes for unrevealed tokens in the RetroPunks collection

Uses Assets contract to load pre-rendered GIF asset for gas efficiency


## State Variables
### _ASSETS_CONTRACT

```solidity
IAssets private immutable _ASSETS_CONTRACT
```


### SVG_HEADER

```solidity
bytes private constant SVG_HEADER =
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><style> img {image-rendering: pixelated;} </style><foreignObject width="48" height="48"><img xmlns="http://www.w3.org/1999/xhtml" width="100%" height="100%" src="data:image/gif;base64,'
```


### SVG_FOOTER

```solidity
bytes private constant SVG_FOOTER = '"/></foreignObject></svg>'
```


## Functions
### constructor


```solidity
constructor(IAssets assetsContract) ;
```

### generateMetadata


```solidity
function generateMetadata(uint16 tokenIdSeed, uint8 backgroundIndex, uint256 globalSeed) public view returns (string memory svg, string memory attributes);
```

