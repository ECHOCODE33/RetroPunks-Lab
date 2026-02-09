# ERC721SeaDropStructsErrorsAndEvents
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/seadrop/lib/ERC721SeaDropStructsErrorsAndEvents.sol)


## Events
### SeaDropTokenDeployed
An event to signify that a SeaDrop token contract was deployed.


```solidity
event SeaDropTokenDeployed();
```

## Errors
### MintQuantityExceedsMaxSupply
Revert with an error if mint exceeds the max supply.


```solidity
error MintQuantityExceedsMaxSupply(uint256 total, uint256 maxSupply);
```

### TokenGatedMismatch
Revert with an error if the number of token gated
allowedNftTokens doesn't match the length of supplied
drop stages.


```solidity
error TokenGatedMismatch();
```

### SignersMismatch
Revert with an error if the number of signers doesn't match
the length of supplied signedMintValidationParams


```solidity
error SignersMismatch();
```

## Structs
### MultiConfigureStruct
A struct to configure multiple contract options at a time.


```solidity
struct MultiConfigureStruct {
    uint256 maxSupply;
    string baseURI;
    string contractURI;
    address seaDropImpl;
    PublicDrop publicDrop;
    string dropURI;
    AllowListData allowListData;
    address creatorPayoutAddress;
    bytes32 provenanceHash;

    address[] allowedFeeRecipients;
    address[] disallowedFeeRecipients;

    address[] allowedPayers;
    address[] disallowedPayers;

    // Token-gated
    address[] tokenGatedAllowedNftTokens;
    TokenGatedDropStage[] tokenGatedDropStages;
    address[] disallowedTokenGatedAllowedNftTokens;

    // Server-signed
    address[] signers;
    SignedMintValidationParams[] signedMintValidationParams;
    address[] disallowedSigners;
}
```

