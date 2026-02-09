# Traits
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/Traits.sol)

**Inherits:**
[ITraits](/src/interfaces/ITraits.sol/interface.ITraits.md), [Rarities](/src/Rarities.sol/contract.Rarities.md)

**Title:**
Traits

**Author:**
ECHO

Generates traits for the RetroPunks collection, optimized for gas efficiency

Inherits rarity values from Rarities contract and selects / generates traits using a PRNG for gas efficiency


## State Variables
### MIN_DATE

```solidity
uint32 private constant MIN_DATE = 4102444800
```


### RANGE_SIZE

```solidity
uint32 private constant RANGE_SIZE = 31496399
```


### MALE_FILLER

```solidity
uint256 private constant MALE_FILLER = (uint256(1) << uint256(E_Male_Skin.Robot)) | (uint256(1) << uint256(E_Male_Skin.Pumpkin))
```


### FEMALE_FILLER

```solidity
uint256 private constant FEMALE_FILLER = (uint256(1) << uint256(E_Female_Skin.Robot))
```


## Functions
### generateTraitsContext


```solidity
function generateTraitsContext(uint16 _tokenIdSeed, uint8 _backgroundIndex, uint256 _globalSeed) external pure returns (TraitsContext memory);
```

### _addOptionalTrait


```solidity
function _addOptionalTrait(TraitsContext memory _traits, E_TraitsGroup _group, uint8 _index) internal pure;
```

### _addMaleHeadwear


```solidity
function _addMaleHeadwear(TraitsContext memory traits) internal pure;
```

### _addFemaleHeadwear


```solidity
function _addFemaleHeadwear(TraitsContext memory traits) internal pure;
```

### _addTraitToRender


```solidity
function _addTraitToRender(TraitsContext memory _traits, E_TraitsGroup _traitGroup, uint8 _traitIndex) internal pure;
```

### _addFillerTrait


```solidity
function _addFillerTrait(TraitsContext memory _traits, E_TraitsGroup _traitGroup, uint8 _traitIndex) internal pure;
```

