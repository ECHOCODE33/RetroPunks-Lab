# ERC721AConduitPreapproved
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/seadrop/lib/ERC721AConduitPreapproved.sol)

**Inherits:**
ERC721A

**Title:**
ERC721AConduitPreapproved

ERC721A with the OpenSea conduit preapproved.


## State Variables
### _CONDUIT
The canonical OpenSea conduit.


```solidity
address internal constant _CONDUIT = 0x1E0049783F008A0085193E00003D00cd54003c71
```


## Functions
### constructor

Deploy the token contract.


```solidity
constructor(string memory name, string memory symbol) ERC721A(name, symbol);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`name`|`string`|             The name of the token.|
|`symbol`|`string`|           The symbol of the token.|


### isApprovedForAll

Returns if the `operator` is allowed to manage all of the
assets of `owner`. Always returns true for the conduit.


```solidity
function isApprovedForAll(address owner, address operator) public view virtual override returns (bool);
```

