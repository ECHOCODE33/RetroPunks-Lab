# RetroPunks
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/RetroPunks.sol)

**Inherits:**
[ERC721SeaDropPausableAndQueryable](/src/seadrop/extensions/ERC721SeaDropPausableAndQueryable.sol/contract.ERC721SeaDropPausableAndQueryable.md)

**Title:**
RetroPunks

**Author:**
ECHO


## State Variables
### NUM_PRE_RENDERED_SPECIALS

```solidity
uint16 private constant NUM_PRE_RENDERED_SPECIALS = 7
```


### revealMetaGenSet

```solidity
uint8 internal revealMetaGenSet = 0
```


### metaGen

```solidity
IMetaGen public metaGen
```


### COMMITTED_GLOBAL_SEED_HASH

```solidity
bytes32 public immutable COMMITTED_GLOBAL_SEED_HASH
```


### COMMITTED_SHUFFLER_SEED_HASH

```solidity
bytes32 public immutable COMMITTED_SHUFFLER_SEED_HASH
```


### globalSeed

```solidity
uint256 public globalSeed
```


### shufflerSeed

```solidity
uint256 public shufflerSeed
```


### mintIsClosed

```solidity
uint8 public mintIsClosed = 0
```


### SPECIAL_NAMES

```solidity
bytes32[16] private SPECIAL_NAMES = [
    bytes32("Predator Blue"),
    bytes32("Predator Green"),
    bytes32("Predator Red"),
    bytes32("Santa Claus"),
    bytes32("Shadow Ninja"),
    bytes32("The Devil"),
    bytes32("The Portrait"),
    bytes32("Ancient Mummy"),
    bytes32("CyberApe"),
    bytes32("Ancient Skeleton"),
    bytes32("Pig"),
    bytes32("Slenderman"),
    bytes32("The Clown"),
    bytes32("The Pirate"),
    bytes32("The Witch"),
    bytes32("The Wizard")
]
```


### globalTokenMetadata

```solidity
mapping(uint256 => TokenMetadata) public globalTokenMetadata
```


### _tokenIdSeedShuffler

```solidity
LibPRNG.LazyShuffler private _tokenIdSeedShuffler
```


### DEFAULT_BACKGROUND_INDEX

```solidity
uint8 public constant DEFAULT_BACKGROUND_INDEX = uint8(uint256(E_Background.Default))
```


## Functions
### tokenExists


```solidity
modifier tokenExists(uint256 _tokenId) ;
```

### onlyTokenOwner


```solidity
modifier onlyTokenOwner(uint256 _tokenId) ;
```

### notPreRenderedSpecial


```solidity
modifier notPreRenderedSpecial(uint256 tokenId) ;
```

### _tokenExists


```solidity
function _tokenExists(uint256 _tokenId) internal view;
```

### _onlyTokenOwner


```solidity
function _onlyTokenOwner(uint256 _tokenId) internal view;
```

### _notPreRenderedSpecial


```solidity
function _notPreRenderedSpecial(uint256 tokenId) internal view;
```

### constructor


```solidity
constructor(
    IMetaGen _metaGenParam,
    bytes32 _committedGlobalSeedHashParam,
    bytes32 _committedShufflerSeedHashParam,
    uint256 _maxSupplyParam,
    address[] memory allowedSeaDropParam
) ERC721SeaDropPausableAndQueryable("RetroPunks", "RPNKS", allowedSeaDropParam);
```

### setMetaGen


```solidity
function setMetaGen(IMetaGen _metaGen, bool _isRevealMetaGen) external onlyOwner;
```

### closeMint


```solidity
function closeMint() external onlyOwner;
```

### revealGlobalSeed


```solidity
function revealGlobalSeed(uint256 _seed, uint256 _nonce) external onlyOwner;
```

### revealShufflerSeed


```solidity
function revealShufflerSeed(uint256 _seed, uint256 _nonce) external onlyOwner;
```

### batchOwnerMint


```solidity
function batchOwnerMint(address[] calldata toAddresses, uint256[] calldata amounts) external onlyOwner nonReentrant;
```

### setTokenMetadata


```solidity
function setTokenMetadata(uint256 tokenId, bytes32 name, string calldata bio, uint8 backgroundIndex) external onlyTokenOwner(tokenId);
```

### _saveNewSeed


```solidity
function _saveNewSeed(uint256 tokenId, uint256 remaining) internal;
```

### _addInternalMintMetadata


```solidity
function _addInternalMintMetadata(uint256 quantity) internal;
```

### _checkMaxSupply


```solidity
function _checkMaxSupply(uint256 quantity) internal view;
```

### _mint


```solidity
function _mint(address to, uint256 quantity) internal override;
```

### tokenURI


```solidity
function tokenURI(uint256 tokenId) public view override tokenExists(tokenId) returns (string memory);
```

### renderDataUri


```solidity
function renderDataUri(uint256 _tokenId, uint16 _tokenIdSeed, uint8 _backgroundIndex, string memory _name, string memory _bio, uint256 _globalSeed)
    internal
    view
    returns (string memory);
```

## Events
### MetadataUpdate

```solidity
event MetadataUpdate(uint256 _tokenId);
```

## Errors
### MintIsClosed

```solidity
error MintIsClosed();
```

### PreRenderedSpecialCannotBeCustomized

```solidity
error PreRenderedSpecialCannotBeCustomized();
```

### BioIsTooLong

```solidity
error BioIsTooLong();
```

### InvalidCharacterInName

```solidity
error InvalidCharacterInName();
```

### GlobalSeedAlreadyRevealed

```solidity
error GlobalSeedAlreadyRevealed();
```

### InvalidGlobalSeedReveal

```solidity
error InvalidGlobalSeedReveal();
```

### ShufflerSeedAlreadyRevealed

```solidity
error ShufflerSeedAlreadyRevealed();
```

### InvalidShufflerSeedReveal

```solidity
error InvalidShufflerSeedReveal();
```

### ShufflerSeedNotRevealedYet

```solidity
error ShufflerSeedNotRevealedYet();
```

### NoRemainingTokens

```solidity
error NoRemainingTokens();
```

### NonExistentToken

```solidity
error NonExistentToken();
```

### CallerIsNotTokenOwner

```solidity
error CallerIsNotTokenOwner();
```

### InvalidBackgroundIndex

```solidity
error InvalidBackgroundIndex();
```

### MetadataNotRevealedYet

```solidity
error MetadataNotRevealedYet();
```

### ArrayLengthMismatch

```solidity
error ArrayLengthMismatch();
```

