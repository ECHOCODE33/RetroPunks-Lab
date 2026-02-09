# AllowListData
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/seadrop/lib/SeaDropStructs.sol)

A struct defining allow list data (for minting an allow list).


```solidity
struct AllowListData {
bytes32 merkleRoot;
string[] publicKeyURIs;
string allowListURI;
}
```

**Properties**

|Name|Type|Description|
|----|----|-----------|
|`merkleRoot`|`bytes32`|   The merkle root for the allow list.|
|`publicKeyURIs`|`string[]`|If the allowListURI is encrypted, a list of URIs pointing to the public keys. Empty if unencrypted.|
|`allowListURI`|`string`| The URI for the allow list.|

