# ISeaDropTokenContractMetadata
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/seadrop/interfaces/ISeaDropTokenContractMetadata.sol)

**Inherits:**
IERC2981


## Functions
### setBaseURI

Sets the base URI for the token metadata and emits an event.


```solidity
function setBaseURI(string calldata tokenURI) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`tokenURI`|`string`|The new base URI to set.|


### setContractURI

Sets the contract URI for contract metadata.


```solidity
function setContractURI(string calldata newContractURI) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newContractURI`|`string`|The new contract URI.|


### setMaxSupply

Sets the max supply and emits an event.


```solidity
function setMaxSupply(uint256 newMaxSupply) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newMaxSupply`|`uint256`|The new max supply to set.|


### setProvenanceHash

Sets the provenance hash and emits an event.
The provenance hash is used for random reveals, which
is a hash of the ordered metadata to show it has not been
modified after mint started.
This function will revert after the first item has been minted.


```solidity
function setProvenanceHash(bytes32 newProvenanceHash) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newProvenanceHash`|`bytes32`|The new provenance hash to set.|


### setRoyaltyInfo

Sets the address and basis points for royalties.


```solidity
function setRoyaltyInfo(RoyaltyInfo calldata newInfo) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newInfo`|`RoyaltyInfo`|The struct to configure royalties.|


### baseURI

Returns the base URI for token metadata.


```solidity
function baseURI() external view returns (string memory);
```

### contractURI

Returns the contract URI.


```solidity
function contractURI() external view returns (string memory);
```

### maxSupply

Returns the max token supply.


```solidity
function maxSupply() external view returns (uint256);
```

### provenanceHash

Returns the provenance hash.
The provenance hash is used for random reveals, which
is a hash of the ordered metadata to show it is unmodified
after mint has started.


```solidity
function provenanceHash() external view returns (bytes32);
```

### royaltyAddress

Returns the address that receives royalties.


```solidity
function royaltyAddress() external view returns (address);
```

### royaltyBasisPoints

Returns the royalty basis points out of 10_000.


```solidity
function royaltyBasisPoints() external view returns (uint256);
```

## Events
### BatchMetadataUpdate
Emit an event for token metadata reveals/updates,
according to EIP-4906.


```solidity
event BatchMetadataUpdate(uint256 _fromTokenId, uint256 _toTokenId);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_fromTokenId`|`uint256`|The start token id.|
|`_toTokenId`|`uint256`|  The end token id.|

### ContractURIUpdated
Emit an event when the URI for the collection-level metadata
is updated.


```solidity
event ContractURIUpdated(string newContractURI);
```

### MaxSupplyUpdated
Emit an event when the max token supply is updated.


```solidity
event MaxSupplyUpdated(uint256 newMaxSupply);
```

### ProvenanceHashUpdated
Emit an event with the previous and new provenance hash after
being updated.


```solidity
event ProvenanceHashUpdated(bytes32 previousHash, bytes32 newHash);
```

### RoyaltyInfoUpdated
Emit an event when the royalties info is updated.


```solidity
event RoyaltyInfoUpdated(address receiver, uint256 bps);
```

## Errors
### CannotExceedMaxSupplyOfUint64
Throw if the max supply exceeds uint64, a limit
due to the storage of bit-packed variables in ERC721A.


```solidity
error CannotExceedMaxSupplyOfUint64(uint256 newMaxSupply);
```

### NewMaxSupplyCannotBeLessThenTotalMinted
Throw if the max supply exceeds the total minted.


```solidity
error NewMaxSupplyCannotBeLessThenTotalMinted(uint256 got, uint256 totalMinted);
```

### ProvenanceHashCannotBeSetAfterMintStarted
Revert with an error when attempting to set the provenance
hash after the mint has started.


```solidity
error ProvenanceHashCannotBeSetAfterMintStarted();
```

### InvalidRoyaltyBasisPoints
Revert if the royalty basis points is greater than 10_000.


```solidity
error InvalidRoyaltyBasisPoints(uint256 basisPoints);
```

### RoyaltyAddressCannotBeZeroAddress
Revert if the royalty address is being set to the zero address.


```solidity
error RoyaltyAddressCannotBeZeroAddress();
```

## Structs
### RoyaltyInfo
A struct defining royalty info for the contract.


```solidity
struct RoyaltyInfo {
    address royaltyAddress;
    uint96 royaltyBps;
}
```

