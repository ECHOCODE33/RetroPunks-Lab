# PublicDrop
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/seadrop/lib/SeaDropStructs.sol)

A struct defining public drop data.
Designed to fit efficiently in one storage slot.


```solidity
struct PublicDrop {
uint80 mintPrice; // 80/256 bits
uint48 startTime; // 128/256 bits
uint48 endTime; // 176/256 bits
uint16 maxTotalMintableByWallet; // 224/256 bits
uint16 feeBps; // 240/256 bits
bool restrictFeeRecipients; // 248/256 bits
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`mintPrice`|`uint80`|               The mint price per token. (Up to 1.2m of native token, e.g. ETH, MATIC)|
|`startTime`|`uint48`|               The start time, ensure this is not zero.|
|`endTime`|`uint48`||
|`maxTotalMintableByWallet`|`uint16`|Maximum total number of mints a user is allowed. (The limit for this field is 2^16 - 1)|
|`feeBps`|`uint16`|                  Fee out of 10_000 basis points to be collected.|
|`restrictFeeRecipients`|`bool`|   If false, allow any fee recipient; if true, check fee recipient is allowed.|

