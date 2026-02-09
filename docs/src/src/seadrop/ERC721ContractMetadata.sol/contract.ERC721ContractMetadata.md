# ERC721ContractMetadata
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/seadrop/ERC721ContractMetadata.sol)

**Inherits:**
[ERC721AConduitPreapproved](/src/seadrop/lib/ERC721AConduitPreapproved.sol/abstract.ERC721AConduitPreapproved.md), [ERC721TransferValidator](/src/seadrop/lib/ERC721TransferValidator.sol/abstract.ERC721TransferValidator.md), TwoStepOwnable, [ISeaDropTokenContractMetadata](/src/seadrop/interfaces/ISeaDropTokenContractMetadata.sol/interface.ISeaDropTokenContractMetadata.md)

**Title:**
ERC721ContractMetadata

**Authors:**
James Wenzel (emo.eth), Ryan Ghods (ralxz.eth), Stephan Min (stephanm.eth)

ERC721ContractMetadata is a token contract that extends ERC721A
with additional metadata and ownership capabilities.


## State Variables
### _maxSupply
Track the max supply.


```solidity
uint256 _maxSupply
```


### _tokenBaseURI
Track the base URI for token metadata.


```solidity
string _tokenBaseURI
```


### _contractURI
Track the contract URI for contract metadata.


```solidity
string _contractURI
```


### _provenanceHash
Track the provenance hash for guaranteeing metadata order
for random reveals.


```solidity
bytes32 _provenanceHash
```


### _royaltyInfo
Track the royalty info: address to receive royalties, and
royalty basis points.


```solidity
RoyaltyInfo _royaltyInfo
```


## Functions
### _onlyOwnerOrSelf

Reverts if the sender is not the owner or the contract itself.
This function is inlined instead of being a modifier
to save contract space from being inlined N times.


```solidity
function _onlyOwnerOrSelf() internal view;
```

### constructor

Deploy the token contract with its name and symbol.


```solidity
constructor(string memory name, string memory symbol) ERC721AConduitPreapproved(name, symbol);
```

### setBaseURI

Sets the base URI for the token metadata and emits an event.


```solidity
function setBaseURI(string calldata newBaseURI) external override;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newBaseURI`|`string`|The new base URI to set.|


### setContractURI

Sets the contract URI for contract metadata.


```solidity
function setContractURI(string calldata newContractURI) external override;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newContractURI`|`string`|The new contract URI.|


### emitBatchMetadataUpdate

Emit an event notifying metadata updates for
a range of token ids, according to EIP-4906.


```solidity
function emitBatchMetadataUpdate(uint256 fromTokenId, uint256 toTokenId) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`fromTokenId`|`uint256`|The start token id.|
|`toTokenId`|`uint256`|  The end token id.|


### setMaxSupply

Sets the max token supply and emits an event.


```solidity
function setMaxSupply(uint256 newMaxSupply) external virtual;
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
function baseURI() external view override returns (string memory);
```

### _baseURI

Returns the base URI for the contract, which ERC721A uses
to return tokenURI.


```solidity
function _baseURI() internal view virtual override returns (string memory);
```

### contractURI

Returns the contract URI for contract metadata.


```solidity
function contractURI() external view override returns (string memory);
```

### maxSupply

Returns the max token supply.


```solidity
function maxSupply() public view returns (uint256);
```

### provenanceHash

Returns the provenance hash.
The provenance hash is used for random reveals, which
is a hash of the ordered metadata to show it is unmodified
after mint has started.


```solidity
function provenanceHash() external view override returns (bytes32);
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

### royaltyInfo

Called with the sale price to determine how much royalty
is owed and to whom.


```solidity
function royaltyInfo(
    uint256,
    /* _tokenId */
    uint256 _salePrice
)
    external
    view
    returns (address receiver, uint256 royaltyAmount);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`||
|`_salePrice`|`uint256`|   The sale price of the NFT asset specified by _tokenId.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`receiver`|`address`|     Address of who should be sent the royalty payment.|
|`royaltyAmount`|`uint256`|The royalty payment amount for _salePrice.|


### getTransferValidationFunction

Returns the transfer validation function used.


```solidity
function getTransferValidationFunction() external pure returns (bytes4 functionSignature, bool isViewFunction);
```

### setTransferValidator

Set the transfer validator. Only callable by the token owner.


```solidity
function setTransferValidator(address newValidator) external onlyOwner;
```

### _beforeTokenTransfers

Hook that is called before any token transfer.
This includes minting and burning.


```solidity
function _beforeTokenTransfers(
    address from,
    address to,
    uint256 startTokenId,
    uint256 /* quantity */
)
    internal
    virtual
    override;
```

### supportsInterface

Returns whether the interface is supported.


```solidity
function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721A) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`interfaceId`|`bytes4`|The interface id to check against.|


### _cast

Internal pure function to cast a `bool` value to a `uint256` value.


```solidity
function _cast(bool b) internal pure returns (uint256 u);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`b`|`bool`|The `bool` value to cast.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`u`|`uint256`|The `uint256` value.|


