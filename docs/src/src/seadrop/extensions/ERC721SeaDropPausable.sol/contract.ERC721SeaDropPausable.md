# ERC721SeaDropPausable
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/seadrop/extensions/ERC721SeaDropPausable.sol)

**Inherits:**
[ERC721SeaDrop](/src/seadrop/ERC721SeaDrop.sol/contract.ERC721SeaDrop.md)

**Title:**
ERC721SeaDropPausable

A token contract that extends ERC721SeaDrop to be able to
pause token transfers. By default on deployment transfers are paused,
and the owner of the token contract can pause or unpause.


## State Variables
### transfersPaused
Boolean if transfers are paused.


```solidity
bool public transfersPaused = true
```


## Functions
### constructor

Deploy the token contract with its name, symbol,
and allowed SeaDrop addresses.


```solidity
constructor(string memory name, string memory symbol, address[] memory allowedSeaDrop) ERC721SeaDrop(name, symbol, allowedSeaDrop);
```

### updateTransfersPaused


```solidity
function updateTransfersPaused(bool paused) external onlyOwner;
```

### setApprovalForAll


```solidity
function setApprovalForAll(address operator, bool approved) public virtual override;
```

### approve


```solidity
function approve(address to, uint256 tokenId) public payable virtual override;
```

### _beforeTokenTransfers


```solidity
function _beforeTokenTransfers(address from, address to, uint256 startTokenId, uint256 quantity) internal virtual override;
```

## Events
### TransfersPausedChanged
Emit an event when transfers are paused or unpaused.


```solidity
event TransfersPausedChanged(bool paused);
```

## Errors
### TransfersPaused
Revert when transfers are paused.


```solidity
error TransfersPaused();
```

