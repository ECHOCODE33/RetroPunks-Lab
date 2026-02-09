# TokenGatedMintParams
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/seadrop/lib/SeaDropStructs.sol)

A struct defining token gated mint params.


```solidity
struct TokenGatedMintParams {
address allowedNftToken;
uint256[] allowedNftTokenIds;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`allowedNftToken`|`address`|   The allowed nft token contract address.|
|`allowedNftTokenIds`|`uint256[]`|The token ids to redeem.|

