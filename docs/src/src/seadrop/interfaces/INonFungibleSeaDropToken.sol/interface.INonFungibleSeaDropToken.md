# INonFungibleSeaDropToken
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/seadrop/interfaces/INonFungibleSeaDropToken.sol)

**Inherits:**
[ISeaDropTokenContractMetadata](/src/seadrop/interfaces/ISeaDropTokenContractMetadata.sol/interface.ISeaDropTokenContractMetadata.md)


## Functions
### updateAllowedSeaDrop

Update the allowed SeaDrop contracts.
Only the owner can use this function.


```solidity
function updateAllowedSeaDrop(address[] calldata allowedSeaDrop) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`allowedSeaDrop`|`address[]`|The allowed SeaDrop addresses.|


### mintSeaDrop

Mint tokens, restricted to the SeaDrop contract.

NOTE: If a token registers itself with multiple SeaDrop
contracts, the implementation of this function should guard
against reentrancy. If the implementing token uses
_safeMint(), or a feeRecipient with a malicious receive() hook
is specified, the token or fee recipients may be able to execute
another mint in the same transaction via a separate SeaDrop
contract.
This is dangerous if an implementing token does not correctly
update the minterNumMinted and currentTotalSupply values before
transferring minted tokens, as SeaDrop references these values
to enforce token limits on a per-wallet and per-stage basis.


```solidity
function mintSeaDrop(address minter, uint256 quantity) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`minter`|`address`|  The address to mint to.|
|`quantity`|`uint256`|The number of tokens to mint.|


### getMintStats

Returns a set of mint stats for the address.
This assists SeaDrop in enforcing maxSupply,
maxTotalMintableByWallet, and maxTokenSupplyForStage checks.

NOTE: Implementing contracts should always update these numbers
before transferring any tokens with _safeMint() to mitigate
consequences of malicious onERC721Received() hooks.


```solidity
function getMintStats(address minter) external view returns (uint256 minterNumMinted, uint256 currentTotalSupply, uint256 maxSupply);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`minter`|`address`|The minter address.|


### updatePublicDrop

Update the public drop data for this nft contract on SeaDrop.
Only the owner can use this function.


```solidity
function updatePublicDrop(address seaDropImpl, PublicDrop calldata publicDrop) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`seaDropImpl`|`address`|The allowed SeaDrop contract.|
|`publicDrop`|`PublicDrop`| The public drop data.|


### updateAllowList

Update the allow list data for this nft contract on SeaDrop.
Only the owner can use this function.


```solidity
function updateAllowList(address seaDropImpl, AllowListData calldata allowListData) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`seaDropImpl`|`address`|  The allowed SeaDrop contract.|
|`allowListData`|`AllowListData`|The allow list data.|


### updateTokenGatedDrop

Update the token gated drop stage data for this nft contract
on SeaDrop.
Only the owner can use this function.
Note: If two INonFungibleSeaDropToken tokens are doing
simultaneous token gated drop promotions for each other,
they can be minted by the same actor until
`maxTokenSupplyForStage` is reached. Please ensure the
`allowedNftToken` is not running an active drop during the
`dropStage` time period.


```solidity
function updateTokenGatedDrop(address seaDropImpl, address allowedNftToken, TokenGatedDropStage calldata dropStage) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`seaDropImpl`|`address`|    The allowed SeaDrop contract.|
|`allowedNftToken`|`address`|The allowed nft token.|
|`dropStage`|`TokenGatedDropStage`|      The token gated drop stage data.|


### updateDropURI

Update the drop URI for this nft contract on SeaDrop.
Only the owner can use this function.


```solidity
function updateDropURI(address seaDropImpl, string calldata dropURI) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`seaDropImpl`|`address`|The allowed SeaDrop contract.|
|`dropURI`|`string`|    The new drop URI.|


### updateCreatorPayoutAddress

Update the creator payout address for this nft contract on
SeaDrop.
Only the owner can set the creator payout address.


```solidity
function updateCreatorPayoutAddress(address seaDropImpl, address payoutAddress) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`seaDropImpl`|`address`|  The allowed SeaDrop contract.|
|`payoutAddress`|`address`|The new payout address.|


### updateAllowedFeeRecipient

Update the allowed fee recipient for this nft contract
on SeaDrop.


```solidity
function updateAllowedFeeRecipient(address seaDropImpl, address feeRecipient, bool allowed) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`seaDropImpl`|`address`| The allowed SeaDrop contract.|
|`feeRecipient`|`address`|The new fee recipient.|
|`allowed`|`bool`||


### updateSignedMintValidationParams

Update the server-side signers for this nft contract
on SeaDrop.
Only the owner can use this function.


```solidity
function updateSignedMintValidationParams(address seaDropImpl, address signer, SignedMintValidationParams memory signedMintValidationParams) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`seaDropImpl`|`address`|               The allowed SeaDrop contract.|
|`signer`|`address`|                    The signer to update.|
|`signedMintValidationParams`|`SignedMintValidationParams`|Minimum and maximum parameters to enforce for signed mints.|


### updatePayer

Update the allowed payers for this nft contract on SeaDrop.
Only the owner can use this function.


```solidity
function updatePayer(address seaDropImpl, address payer, bool allowed) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`seaDropImpl`|`address`|The allowed SeaDrop contract.|
|`payer`|`address`|      The payer to update.|
|`allowed`|`bool`|    Whether the payer is allowed.|


## Events
### AllowedSeaDropUpdated
Emit an event when allowed SeaDrop contracts are updated.


```solidity
event AllowedSeaDropUpdated(address[] allowedSeaDrop);
```

## Errors
### OnlyAllowedSeaDrop
Revert with an error if a contract is not an allowed
SeaDrop address.


```solidity
error OnlyAllowedSeaDrop();
```

