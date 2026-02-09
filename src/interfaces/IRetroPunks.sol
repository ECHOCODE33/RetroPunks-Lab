// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

/**
 * @title IRetroPunks
 * @notice Interface containing structs, events, and errors for the RetroPunks collection
 */
interface IRetroPunks {
    struct TokenMetadata {
        uint16 tokenIdSeed;
        uint8 backgroundIndex;
        bytes32 name;
        string bio;
    }

    event MetadataUpdate(uint256 _tokenId);

    error MintIsClosed();
    error PreRenderedSpecialCannotBeCustomized();
    error BioIsTooLong();
    error InvalidCharacterInName();
    error GlobalSeedAlreadyRevealed();
    error InvalidGlobalSeedReveal();
    error ShufflerSeedAlreadyRevealed();
    error InvalidShufflerSeedReveal();
    error ShufflerSeedNotRevealedYet();
    error NoRemainingTokens();
    error NonExistentToken();
    error CallerIsNotTokenOwner();
    error InvalidBackgroundIndex();
    error MetadataNotRevealedYet();
    error ArrayLengthMismatch();
}
