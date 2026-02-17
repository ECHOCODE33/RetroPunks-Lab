// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

/**
 * @title IRetroPunksTypes
 * @notice Interface containing structs, events, and errors for the RetroPunks contract
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

    /**
     * @notice A token's metadata is updated by its owner
     */
    event MetadataUpdate(uint256 _tokenId);

    /**
     * @notice The global seed is revealed
     */
    event GlobalSeedRevealed();

    /**
     * @notice The shuffler seed is revealed
     */
    event ShufflerSeedRevealed();

    /**
     * @notice The metadata generator is revealed, making full metadata visible
     */
    event MetaGenRevealed();

    /**
     * @notice Minting is permanently closed
     */
    event MintClosed();

    /**
     * @notice Two arrays that should have matching lengths don't match
     */
    error ArrayLengthMismatch();

    /**
     * @notice Bio exceeds the maximum allowed length of 160 characters
     */
    error BioIsTooLong();

    /**
     * @notice Caller does not own the token
     */
    error CallerIsNotTokenOwner();

    /**
     * @notice Cannot change the background of a pre-rendered special punk (tokenIDSeeds 0-6)
     */
    error CannotSetBackgroundForPreRenderedSpecialPunks();

    /**
     * @notice Cannot reveal the global seed after it's already been revealed
     */
    error GlobalSeedAlreadyRevealed();

    /**
     * @notice Cannot reveal metadata before the global seed is revealed
     */
    error GlobalSeedNotRevealedYet();

    /**
     * @notice Invalid background index is provided
     */
    error InvalidBackgroundIndex();

    /**
     * @notice Set token name contains characters that are not allowed
     */
    error InvalidCharacterInName();

    /**
     * @notice Revealed global seed doesn't match the committed hash
     */
    error InvalidGlobalSeedReveal();

    /**
     * @notice Revealed shuffler seed doesn't match the committed hash
     */
    error InvalidShufflerSeedReveal();

    /**
     * @notice Cannot set metadata before it has been revealed
     */
    error MetadataNotRevealedYet();

    /**
     * @notice Cannot mint after minting has been permanently closed
     */
    error MintIsClosed();

    /**
     * @notice There are no remaining tokens available to assign
     */
    error NoRemainingTokens();

    /**
     * @notice The token does not exist
     */
    error NonExistentToken();

    /**
     * @notice Cannot reveal the shuffler seed after it's already been revealed
     */
    error ShufflerSeedAlreadyRevealed();

    /**
     * @notice Cannot mint before the shuffler seed is revealed
     */
    error ShufflerSeedNotRevealedYet();
}
