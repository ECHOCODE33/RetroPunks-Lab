# ERC721SeaDropPausableAndQueryable
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/seadrop/extensions/ERC721SeaDropPausableAndQueryable.sol)

**Inherits:**
[ERC721SeaDropPausable](/src/seadrop/extensions/ERC721SeaDropPausable.sol/contract.ERC721SeaDropPausable.md)

**Title:**
ERC721SeaDropPausableAndQueryable

A token contract that extends ERC721SeaDropPausable to be able to
pause token transfers and query the ownership of tokens.
Extends ERC721SeaDropPausable to be able to pause token transfers.
Get implementation from ERC721AQueryable to be able to query the ownership of tokens and be compatible with ERC721A


## Functions
### constructor


```solidity
constructor(string memory name, string memory symbol, address[] memory allowedSeaDrop) ERC721SeaDropPausable(name, symbol, allowedSeaDrop);
```

### explicitOwnershipOf

Returns the `TokenOwnership` struct at `tokenId` without reverting.
If the `tokenId` is out of bounds:
- `addr = address(0)`
- `startTimestamp = 0`
- `burned = false`
- `extraData = 0`
If the `tokenId` is burned:
- `addr = <Address of owner before token was burned>`
- `startTimestamp = <Timestamp when token was burned>`
- `burned = true`
- `extraData = <Extra data when token was burned>`
Otherwise:
- `addr = <Address of owner>`
- `startTimestamp = <Timestamp of start of ownership>`
- `burned = false`
- `extraData = <Extra data at start of ownership>`


```solidity
function explicitOwnershipOf(uint256 tokenId) public view virtual returns (TokenOwnership memory ownership);
```

### explicitOwnershipsOf

Returns an array of `TokenOwnership` structs at `tokenIds` in order.
See {ERC721AQueryable-explicitOwnershipOf}


```solidity
function explicitOwnershipsOf(uint256[] calldata tokenIds) external view virtual returns (TokenOwnership[] memory);
```

### tokensOfOwnerIn

Returns an array of token IDs owned by `owner`,
in the range [`start`, `stop`)
(i.e. `start <= tokenId < stop`).
This function allows for tokens to be queried if the collection
grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
Requirements:
- `start < stop`


```solidity
function tokensOfOwnerIn(address owner, uint256 start, uint256 stop) external view virtual returns (uint256[] memory);
```

### tokensOfOwner

Returns an array of token IDs owned by `owner`.
This function scans the ownership mapping and is O(`totalSupply`) in complexity.
It is meant to be called off-chain.
See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
multiple smaller scans if the collection is large enough to cause
an out-of-gas error (10K collections should be fine).


```solidity
function tokensOfOwner(address owner) external view virtual returns (uint256[] memory);
```

### _tokensOfOwnerIn

Helper function for returning an array of token IDs owned by `owner`.
Note that this function is optimized for smaller bytecode size over runtime gas,
since it is meant to be called off-chain.


```solidity
function _tokensOfOwnerIn(address owner, uint256 start, uint256 stop) private view returns (uint256[] memory tokenIds);
```

## Errors
### InvalidQueryRange
Invalid query range (`start` >= `stop`).


```solidity
error InvalidQueryRange();
```

