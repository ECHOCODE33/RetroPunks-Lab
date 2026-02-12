// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

/**
 * @title IRetroPunksTypes
 * @notice Interface containing structs, events, and errors for the RetroPunks collection
 */
interface IRetroPunksTypes {
    /**
     * @notice A struct defining token metadata.
     *
     * @param tokenIdSeed       The shuffled seed for the token id.
     * @param backgroundIndex   The index of the background in the background array.
     * @param name              The "name" field in tokenURI JSON metadata
     * @param bio               The "description" field in tokenURI JSON metadata
     */
    struct TokenMetadata {
        uint16 tokenIdSeed;
        uint8 backgroundIndex;
        bytes32 name;
        string bio;
    }

    event MetadataUpdate(uint256 _tokenId);
    event GlobalSeedRevealed(uint256 seed);
    event ShufflerSeedRevealed(uint256 seed);
    event MetaGenRevealed();
    event MintClosed();

    error ArrayLengthMismatch();
    error BioIsTooLong();
    error CallerIsNotTokenOwner();
    error CannotSetBackgroundForPreRenderedSpecialPunks();
    error GlobalSeedAlreadyRevealed();
    error GlobalSeedNotRevealedYet();
    error InvalidBackgroundIndex();
    error InvalidCharacterInName();
    error InvalidGlobalSeedReveal();
    error InvalidShufflerSeedReveal();
    error MetadataNotRevealedYet();
    error MintIsClosed();
    error NoRemainingTokens();
    error NonExistentToken();
    error ShufflerSeedAlreadyRevealed();
    error ShufflerSeedNotRevealedYet();
}
