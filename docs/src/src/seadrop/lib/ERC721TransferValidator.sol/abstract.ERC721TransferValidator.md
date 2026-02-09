# ERC721TransferValidator
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/seadrop/lib/ERC721TransferValidator.sol)

**Inherits:**
[ICreatorToken](/src/seadrop/interfaces/ICreatorToken.sol/interface.ICreatorToken.md)

**Title:**
ERC721TransferValidator

Functionality to use a transfer validator.


## State Variables
### _transferValidator
Store the transfer validator. The null address means no transfer validator is set.


```solidity
address internal _transferValidator
```


## Functions
### getTransferValidator

Returns the currently active transfer validator.
The null address means no transfer validator is set.


```solidity
function getTransferValidator() external view returns (address);
```

### _setTransferValidator

Set the transfer validator.
The external method that uses this must include access control.


```solidity
function _setTransferValidator(address newValidator) internal;
```

## Errors
### SameTransferValidator
Revert with an error if the transfer validator is being set to the same address.


```solidity
error SameTransferValidator();
```

