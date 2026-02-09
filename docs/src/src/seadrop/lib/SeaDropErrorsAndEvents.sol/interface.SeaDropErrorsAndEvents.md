# SeaDropErrorsAndEvents
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/seadrop/lib/SeaDropErrorsAndEvents.sol)


## Events
### SeaDropMint
An event with details of a SeaDrop mint, for analytical purposes.


```solidity
event SeaDropMint(
    address indexed nftContract,
    address indexed minter,
    address indexed feeRecipient,
    address payer,
    uint256 quantityMinted,
    uint256 unitMintPrice,
    uint256 feeBps,
    uint256 dropStageIndex
);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`|   The nft contract.|
|`minter`|`address`|        The mint recipient.|
|`feeRecipient`|`address`|  The fee recipient.|
|`payer`|`address`|         The address who payed for the tx.|
|`quantityMinted`|`uint256`|The number of tokens minted.|
|`unitMintPrice`|`uint256`| The amount paid for each token.|
|`feeBps`|`uint256`|        The fee out of 10_000 basis points collected.|
|`dropStageIndex`|`uint256`|The drop stage index. Items minted through mintPublic() have dropStageIndex of 0.|

### PublicDropUpdated
An event with updated public drop data for an nft contract.


```solidity
event PublicDropUpdated(address indexed nftContract, PublicDrop publicDrop);
```

### TokenGatedDropStageUpdated
An event with updated token gated drop stage data
for an nft contract.


```solidity
event TokenGatedDropStageUpdated(address indexed nftContract, address indexed allowedNftToken, TokenGatedDropStage dropStage);
```

### AllowListUpdated
An event with updated allow list data for an nft contract.


```solidity
event AllowListUpdated(address indexed nftContract, bytes32 indexed previousMerkleRoot, bytes32 indexed newMerkleRoot, string[] publicKeyURI, string allowListURI);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nftContract`|`address`|       The nft contract.|
|`previousMerkleRoot`|`bytes32`|The previous allow list merkle root.|
|`newMerkleRoot`|`bytes32`|     The new allow list merkle root.|
|`publicKeyURI`|`string[]`|      If the allow list is encrypted, the public key URIs that can decrypt the list. Empty if unencrypted.|
|`allowListURI`|`string`|      The URI for the allow list.|

### DropURIUpdated
An event with updated drop URI for an nft contract.


```solidity
event DropURIUpdated(address indexed nftContract, string newDropURI);
```

### CreatorPayoutAddressUpdated
An event with the updated creator payout address for an nft
contract.


```solidity
event CreatorPayoutAddressUpdated(address indexed nftContract, address indexed newPayoutAddress);
```

### AllowedFeeRecipientUpdated
An event with the updated allowed fee recipient for an nft
contract.


```solidity
event AllowedFeeRecipientUpdated(address indexed nftContract, address indexed feeRecipient, bool indexed allowed);
```

### SignedMintValidationParamsUpdated
An event with the updated validation parameters for server-side
signers.


```solidity
event SignedMintValidationParamsUpdated(address indexed nftContract, address indexed signer, SignedMintValidationParams signedMintValidationParams);
```

### PayerUpdated
An event with the updated payer for an nft contract.


```solidity
event PayerUpdated(address indexed nftContract, address indexed payer, bool indexed allowed);
```

## Errors
### NotActive
Revert with an error if the drop stage is not active.


```solidity
error NotActive(uint256 currentTimestamp, uint256 startTimestamp, uint256 endTimestamp);
```

### MintQuantityCannotBeZero
Revert with an error if the mint quantity is zero.


```solidity
error MintQuantityCannotBeZero();
```

### MintQuantityExceedsMaxMintedPerWallet
Revert with an error if the mint quantity exceeds the max allowed
to be minted per wallet.


```solidity
error MintQuantityExceedsMaxMintedPerWallet(uint256 total, uint256 allowed);
```

### MintQuantityExceedsMaxSupply
Revert with an error if the mint quantity exceeds the max token
supply.


```solidity
error MintQuantityExceedsMaxSupply(uint256 total, uint256 maxSupply);
```

### MintQuantityExceedsMaxTokenSupplyForStage
Revert with an error if the mint quantity exceeds the max token
supply for the stage.
Note: The `maxTokenSupplyForStage` for public mint is
always `type(uint).max`.


```solidity
error MintQuantityExceedsMaxTokenSupplyForStage(uint256 total, uint256 maxTokenSupplyForStage);
```

### FeeRecipientCannotBeZeroAddress
Revert if the fee recipient is the zero address.


```solidity
error FeeRecipientCannotBeZeroAddress();
```

### FeeRecipientNotPresent
Revert if the fee recipient is not already included.


```solidity
error FeeRecipientNotPresent();
```

### InvalidFeeBps
Revert if the fee basis points is greater than 10_000.


```solidity
error InvalidFeeBps(uint256 feeBps);
```

### DuplicateFeeRecipient
Revert if the fee recipient is already included.


```solidity
error DuplicateFeeRecipient();
```

### FeeRecipientNotAllowed
Revert if the fee recipient is restricted and not allowed.


```solidity
error FeeRecipientNotAllowed();
```

### CreatorPayoutAddressCannotBeZeroAddress
Revert if the creator payout address is the zero address.


```solidity
error CreatorPayoutAddressCannotBeZeroAddress();
```

### IncorrectPayment
Revert with an error if the received payment is incorrect.


```solidity
error IncorrectPayment(uint256 got, uint256 want);
```

### InvalidProof
Revert with an error if the allow list proof is invalid.


```solidity
error InvalidProof();
```

### SignerCannotBeZeroAddress
Revert if a supplied signer address is the zero address.


```solidity
error SignerCannotBeZeroAddress();
```

### InvalidSignature
Revert with an error if signer's signature is invalid.


```solidity
error InvalidSignature(address recoveredSigner);
```

### SignerNotPresent
Revert with an error if a signer is not included in
the enumeration when removing.


```solidity
error SignerNotPresent();
```

### PayerNotPresent
Revert with an error if a payer is not included in
the enumeration when removing.


```solidity
error PayerNotPresent();
```

### DuplicatePayer
Revert with an error if a payer is already included in mapping
when adding.
Note: only applies when adding a single payer, as duplicates in
enumeration can be removed with updatePayer.


```solidity
error DuplicatePayer();
```

### PayerNotAllowed
Revert with an error if the payer is not allowed. The minter must
pay for their own mint.


```solidity
error PayerNotAllowed();
```

### PayerCannotBeZeroAddress
Revert if a supplied payer address is the zero address.


```solidity
error PayerCannotBeZeroAddress();
```

### OnlyINonFungibleSeaDropToken
Revert with an error if the sender does not
match the INonFungibleSeaDropToken interface.


```solidity
error OnlyINonFungibleSeaDropToken(address sender);
```

### TokenGatedNotTokenOwner
Revert with an error if the sender of a token gated supplied
drop stage redeem is not the owner of the token.


```solidity
error TokenGatedNotTokenOwner(address nftContract, address allowedNftToken, uint256 allowedNftTokenId);
```

### TokenGatedTokenIdAlreadyRedeemed
Revert with an error if the token id has already been used to
redeem a token gated drop stage.


```solidity
error TokenGatedTokenIdAlreadyRedeemed(address nftContract, address allowedNftToken, uint256 allowedNftTokenId);
```

### TokenGatedDropStageNotPresent
Revert with an error if an empty TokenGatedDropStage is provided
for an already-empty TokenGatedDropStage.


```solidity
error TokenGatedDropStageNotPresent();
```

### TokenGatedDropAllowedNftTokenCannotBeZeroAddress
Revert with an error if an allowedNftToken is set to
the zero address.


```solidity
error TokenGatedDropAllowedNftTokenCannotBeZeroAddress();
```

### TokenGatedDropAllowedNftTokenCannotBeDropToken
Revert with an error if an allowedNftToken is set to
the drop token itself.


```solidity
error TokenGatedDropAllowedNftTokenCannotBeDropToken();
```

### InvalidSignedMintPrice
Revert with an error if supplied signed mint price is less than
the minimum specified.


```solidity
error InvalidSignedMintPrice(uint256 got, uint256 minimum);
```

### InvalidSignedMaxTotalMintableByWallet
Revert with an error if supplied signed maxTotalMintableByWallet
is greater than the maximum specified.


```solidity
error InvalidSignedMaxTotalMintableByWallet(uint256 got, uint256 maximum);
```

### InvalidSignedStartTime
Revert with an error if supplied signed start time is less than
the minimum specified.


```solidity
error InvalidSignedStartTime(uint256 got, uint256 minimum);
```

### InvalidSignedEndTime
Revert with an error if supplied signed end time is greater than
the maximum specified.


```solidity
error InvalidSignedEndTime(uint256 got, uint256 maximum);
```

### InvalidSignedMaxTokenSupplyForStage
Revert with an error if supplied signed maxTokenSupplyForStage
is greater than the maximum specified.


```solidity
error InvalidSignedMaxTokenSupplyForStage(uint256 got, uint256 maximum);
```

### InvalidSignedFeeBps
Revert with an error if supplied signed feeBps is greater than
the maximum specified, or less than the minimum.


```solidity
error InvalidSignedFeeBps(uint256 got, uint256 minimumOrMaximum);
```

### SignedMintsMustRestrictFeeRecipients
Revert with an error if signed mint did not specify to restrict
fee recipients.


```solidity
error SignedMintsMustRestrictFeeRecipients();
```

### SignatureAlreadyUsed
Revert with an error if a signature for a signed mint has already
been used.


```solidity
error SignatureAlreadyUsed();
```

