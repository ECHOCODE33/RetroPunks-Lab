# ICreatorToken
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/seadrop/interfaces/ICreatorToken.sol)


## Functions
### getTransferValidator


```solidity
function getTransferValidator() external view returns (address validator);
```

### getTransferValidationFunction


```solidity
function getTransferValidationFunction() external view returns (bytes4 functionSignature, bool isViewFunction);
```

### setTransferValidator


```solidity
function setTransferValidator(address validator) external;
```

## Events
### TransferValidatorUpdated

```solidity
event TransferValidatorUpdated(address oldValidator, address newValidator);
```

