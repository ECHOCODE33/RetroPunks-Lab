# MintParams
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/seadrop/lib/SeaDropStructs.sol)

A struct defining mint params for an allow list.
An allow list leaf will be composed of `msg.sender` and
the following params.
Note: Since feeBps is encoded in the leaf, backend should ensure
that feeBps is acceptable before generating a proof.


```solidity
struct MintParams {
uint256 mintPrice;
uint256 maxTotalMintableByWallet;
uint256 startTime;
uint256 endTime;
uint256 dropStageIndex; // non-zero
uint256 maxTokenSupplyForStage;
uint256 feeBps;
bool restrictFeeRecipients;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`mintPrice`|`uint256`|               The mint price per token.|
|`maxTotalMintableByWallet`|`uint256`|Maximum total number of mints a user is allowed.|
|`startTime`|`uint256`|               The start time, ensure this is not zero.|
|`endTime`|`uint256`|                 The end time, ensure this is not zero.|
|`dropStageIndex`|`uint256`|          The drop stage index to emit with the event for analytical purposes. This should be non-zero since the public mint emits with index zero.|
|`maxTokenSupplyForStage`|`uint256`|  The limit of token supply this stage can mint within.|
|`feeBps`|`uint256`|                  Fee out of 10_000 basis points to be collected.|
|`restrictFeeRecipients`|`bool`|   If false, allow any fee recipient; if true, check fee recipient is allowed.|

