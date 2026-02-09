# SignedMintValidationParams
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/seadrop/lib/SeaDropStructs.sol)

A struct defining minimum and maximum parameters to validate for
signed mints, to minimize negative effects of a compromised signer.


```solidity
struct SignedMintValidationParams {
uint80 minMintPrice; // 80/256 bits
uint24 maxMaxTotalMintableByWallet; // 104/256 bits
uint40 minStartTime; // 144/256 bits
uint40 maxEndTime; // 184/256 bits
uint40 maxMaxTokenSupplyForStage; // 224/256 bits
uint16 minFeeBps; // 240/256 bits
uint16 maxFeeBps; // 256/256 bits
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`minMintPrice`|`uint80`|               The minimum mint price allowed.|
|`maxMaxTotalMintableByWallet`|`uint24`|The maximum total number of mints allowed by a wallet.|
|`minStartTime`|`uint40`|               The minimum start time allowed.|
|`maxEndTime`|`uint40`|                 The maximum end time allowed.|
|`maxMaxTokenSupplyForStage`|`uint40`|  The maximum token supply allowed.|
|`minFeeBps`|`uint16`|                  The minimum fee allowed.|
|`maxFeeBps`|`uint16`|                  The maximum fee allowed.|

