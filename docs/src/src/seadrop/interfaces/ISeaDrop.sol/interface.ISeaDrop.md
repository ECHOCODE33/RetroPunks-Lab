# ISeaDrop
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/seadrop/interfaces/ISeaDrop.sol)

**Inherits:**
[SeaDropErrorsAndEvents](/src/seadrop/lib/SeaDropErrorsAndEvents.sol/interface.SeaDropErrorsAndEvents.md)


## Functions
### mintPublic

Mint a public drop.


```solidity
function mintPublic(address nftContract, address feeRecipient, address minterIfNotPayer, uint256 quantity) external payable;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`|     The nft contract to mint.|
|`feeRecipient`|`address`|    The fee recipient.|
|`minterIfNotPayer`|`address`|The mint recipient if different than the payer.|
|`quantity`|`uint256`|        The number of tokens to mint.|


### mintAllowList

Mint from an allow list.


```solidity
function mintAllowList(address nftContract, address feeRecipient, address minterIfNotPayer, uint256 quantity, MintParams calldata mintParams, bytes32[] calldata proof)
    external
    payable;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`|     The nft contract to mint.|
|`feeRecipient`|`address`|    The fee recipient.|
|`minterIfNotPayer`|`address`|The mint recipient if different than the payer.|
|`quantity`|`uint256`|        The number of tokens to mint.|
|`mintParams`|`MintParams`|      The mint parameters.|
|`proof`|`bytes32[]`|           The proof for the leaf of the allow list.|


### mintSigned

Mint with a server-side signature.
Note that a signature can only be used once.


```solidity
function mintSigned(
    address nftContract,
    address feeRecipient,
    address minterIfNotPayer,
    uint256 quantity,
    MintParams calldata mintParams,
    uint256 salt,
    bytes calldata signature
) external payable;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`|     The nft contract to mint.|
|`feeRecipient`|`address`|    The fee recipient.|
|`minterIfNotPayer`|`address`|The mint recipient if different than the payer.|
|`quantity`|`uint256`|        The number of tokens to mint.|
|`mintParams`|`MintParams`|      The mint parameters.|
|`salt`|`uint256`|            The sale for the signed mint.|
|`signature`|`bytes`|       The server-side signature, must be an allowed signer.|


### mintAllowedTokenHolder

Mint as an allowed token holder.
This will mark the token id as redeemed and will revert if the
same token id is attempted to be redeemed twice.


```solidity
function mintAllowedTokenHolder(address nftContract, address feeRecipient, address minterIfNotPayer, TokenGatedMintParams calldata mintParams) external payable;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`|     The nft contract to mint.|
|`feeRecipient`|`address`|    The fee recipient.|
|`minterIfNotPayer`|`address`|The mint recipient if different than the payer.|
|`mintParams`|`TokenGatedMintParams`|      The token gated mint params.|


### updateDropURI

Emits an event to notify update of the drop URI.
This method assume msg.sender is an nft contract and its
ERC165 interface id matches INonFungibleSeaDropToken.
Note: Be sure only authorized users can call this from
token contracts that implement INonFungibleSeaDropToken.


```solidity
function updateDropURI(string calldata dropURI) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`dropURI`|`string`|The new drop URI.|


### updatePublicDrop

Updates the public drop data for the nft contract
and emits an event.
This method assume msg.sender is an nft contract and its
ERC165 interface id matches INonFungibleSeaDropToken.
Note: Be sure only authorized users can call this from
token contracts that implement INonFungibleSeaDropToken.


```solidity
function updatePublicDrop(PublicDrop calldata publicDrop) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`publicDrop`|`PublicDrop`|The public drop data.|


### updateAllowList

Updates the allow list merkle root for the nft contract
and emits an event.
This method assume msg.sender is an nft contract and its
ERC165 interface id matches INonFungibleSeaDropToken.
Note: Be sure only authorized users can call this from
token contracts that implement INonFungibleSeaDropToken.


```solidity
function updateAllowList(AllowListData calldata allowListData) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`allowListData`|`AllowListData`|The allow list data.|


### updateTokenGatedDrop

Updates the token gated drop stage for the nft contract
and emits an event.
This method assume msg.sender is an nft contract and its
ERC165 interface id matches INonFungibleSeaDropToken.
Note: Be sure only authorized users can call this from
token contracts that implement INonFungibleSeaDropToken.
Note: If two INonFungibleSeaDropToken tokens are doing
simultaneous token gated drop promotions for each other,
they can be minted by the same actor until
`maxTokenSupplyForStage` is reached. Please ensure the
`allowedNftToken` is not running an active drop during
the `dropStage` time period.


```solidity
function updateTokenGatedDrop(address allowedNftToken, TokenGatedDropStage calldata dropStage) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`allowedNftToken`|`address`|The token gated nft token.|
|`dropStage`|`TokenGatedDropStage`|      The token gated drop stage data.|


### updateCreatorPayoutAddress

Updates the creator payout address and emits an event.
This method assume msg.sender is an nft contract and its
ERC165 interface id matches INonFungibleSeaDropToken.
Note: Be sure only authorized users can call this from
token contracts that implement INonFungibleSeaDropToken.


```solidity
function updateCreatorPayoutAddress(address payoutAddress) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`payoutAddress`|`address`|The creator payout address.|


### updateAllowedFeeRecipient

Updates the allowed fee recipient and emits an event.
This method assume msg.sender is an nft contract and its
ERC165 interface id matches INonFungibleSeaDropToken.
Note: Be sure only authorized users can call this from
token contracts that implement INonFungibleSeaDropToken.


```solidity
function updateAllowedFeeRecipient(address feeRecipient, bool allowed) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`feeRecipient`|`address`|The fee recipient.|
|`allowed`|`bool`|     If the fee recipient is allowed.|


### updateSignedMintValidationParams

Updates the allowed server-side signers and emits an event.
This method assume msg.sender is an nft contract and its
ERC165 interface id matches INonFungibleSeaDropToken.
Note: Be sure only authorized users can call this from
token contracts that implement INonFungibleSeaDropToken.


```solidity
function updateSignedMintValidationParams(address signer, SignedMintValidationParams calldata signedMintValidationParams) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`signer`|`address`|                    The signer to update.|
|`signedMintValidationParams`|`SignedMintValidationParams`|Minimum and maximum parameters to enforce for signed mints.|


### updatePayer

Updates the allowed payer and emits an event.
This method assume msg.sender is an nft contract and its
ERC165 interface id matches INonFungibleSeaDropToken.
Note: Be sure only authorized users can call this from
token contracts that implement INonFungibleSeaDropToken.


```solidity
function updatePayer(address payer, bool allowed) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`payer`|`address`|  The payer to add or remove.|
|`allowed`|`bool`|Whether to add or remove the payer.|


### getPublicDrop

Returns the public drop data for the nft contract.


```solidity
function getPublicDrop(address nftContract) external view returns (PublicDrop memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`|The nft contract.|


### getCreatorPayoutAddress

Returns the creator payout address for the nft contract.


```solidity
function getCreatorPayoutAddress(address nftContract) external view returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`|The nft contract.|


### getAllowListMerkleRoot

Returns the allow list merkle root for the nft contract.


```solidity
function getAllowListMerkleRoot(address nftContract) external view returns (bytes32);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`|The nft contract.|


### getFeeRecipientIsAllowed

Returns if the specified fee recipient is allowed
for the nft contract.


```solidity
function getFeeRecipientIsAllowed(address nftContract, address feeRecipient) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`| The nft contract.|
|`feeRecipient`|`address`|The fee recipient.|


### getAllowedFeeRecipients

Returns an enumeration of allowed fee recipients for an
nft contract when fee recipients are enforced


```solidity
function getAllowedFeeRecipients(address nftContract) external view returns (address[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`|The nft contract.|


### getSigners

Returns the server-side signers for the nft contract.


```solidity
function getSigners(address nftContract) external view returns (address[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`|The nft contract.|


### getSignedMintValidationParams

Returns the struct of SignedMintValidationParams for a signer.


```solidity
function getSignedMintValidationParams(address nftContract, address signer) external view returns (SignedMintValidationParams memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`|The nft contract.|
|`signer`|`address`|     The signer.|


### getPayers

Returns the payers for the nft contract.


```solidity
function getPayers(address nftContract) external view returns (address[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`|The nft contract.|


### getPayerIsAllowed

Returns if the specified payer is allowed
for the nft contract.


```solidity
function getPayerIsAllowed(address nftContract, address payer) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`|The nft contract.|
|`payer`|`address`|      The payer.|


### getTokenGatedAllowedTokens

Returns the allowed token gated drop tokens for the nft contract.


```solidity
function getTokenGatedAllowedTokens(address nftContract) external view returns (address[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`|The nft contract.|


### getTokenGatedDrop

Returns the token gated drop data for the nft contract
and token gated nft.


```solidity
function getTokenGatedDrop(address nftContract, address allowedNftToken) external view returns (TokenGatedDropStage memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`|    The nft contract.|
|`allowedNftToken`|`address`|The token gated nft token.|


### getAllowedNftTokenIdIsRedeemed

Returns whether the token id for a token gated drop has been
redeemed.


```solidity
function getAllowedNftTokenIdIsRedeemed(address nftContract, address allowedNftToken, uint256 allowedNftTokenId) external view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`|      The nft contract.|
|`allowedNftToken`|`address`|  The token gated nft token.|
|`allowedNftTokenId`|`uint256`|The token gated nft token id to check.|


