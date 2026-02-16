// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { NUM_BACKGROUND, NUM_PRE_RENDERED_SPECIALS, NUM_SPECIAL_1S } from "./global/Enums.sol";
import { IMetaGen } from "./interfaces/IMetaGen.sol";
import { IRetroPunksTypes } from "./interfaces/IRetroPunksTypes.sol";
import { LibPRNG } from "./libraries/LibPRNG.sol";
import { Utils } from "./libraries/Utils.sol";
import { ERC721SeaDropPausableAndQueryable } from "./seadrop/extensions/ERC721SeaDropPausableAndQueryable.sol";

/**
 * @title RetroPunks
 * @author ECHO (echomatrix.eth)
 *
 * @notice The main contract for the RetroPunks collection - an on-chain NFT collection with
 *         customizable metadata, fair randomness via committed seeds, and special 1-of-1 tokens
 *
 * @dev This contract extends ERC721A via SeaDrop for gas-efficient batch minting and integrates
 *      with an external metadata generator for fully on-chain SVG rendering
 *
 * ██████╗  ███████╗ ████████╗ ██████╗   ██████╗  ██████╗  ██╗   ██╗ ███╗   ██╗ ██╗  ██╗ ███████╗
 * ██╔══██╗ ██╔════╝ ╚══██╔══╝ ██╔══██╗ ██╔═══██╗ ██╔══██╗ ██║   ██║ ████╗  ██║ ██║ ██╔╝ ██╔════╝
 * ██████╔╝ █████╗      ██║    ██████╔╝ ██║   ██║ ██████╔╝ ██║   ██║ ██╔██╗ ██║ █████╔╝  ███████╗
 * ██╔══██╗ ██╔══╝      ██║    ██╔══██╗ ██║   ██║ ██╔═══╝  ██║   ██║ ██║╚██╗██║ ██╔═██╗  ╚════██║
 * ██║  ██║ ███████╗    ██║    ██║  ██║ ╚██████╔╝ ██║      ╚██████╔╝ ██║ ╚████║ ██║  ██╗ ███████║
 * ╚═╝  ╚═╝ ╚══════╝    ╚═╝    ╚═╝  ╚═╝  ╚═════╝  ╚═╝       ╚═════╝  ╚═╝  ╚═══╝ ╚═╝  ╚═╝ ╚══════╝
 *
 */
contract RetroPunks is IRetroPunksTypes, ERC721SeaDropPausableAndQueryable {
    using LibPRNG for LibPRNG.LazyShuffler;

    /// @notice The metadata generator contract responsible for creating on-chain SVG and attributes
    IMetaGen public metaGen;

    /// @notice Mapping from token ID to its customizable TokenMetadata struct
    mapping(uint256 => TokenMetadata) public globalTokenMetadata;

    /// @notice Names of the 16 special 1-of-1 tokens (tokenIDSeeds 0-15)
    bytes32[16] internal SPECIAL_NAMES = [
        bytes32("Predator Blue"),
        bytes32("Predator Green"),
        bytes32("Predator Red"),
        bytes32("Santa Claus"),
        bytes32("Shadow Ninja"),
        bytes32("The Devil"),
        bytes32("The Portrait"),
        bytes32("Ancient Mummy"),
        bytes32("CyberApe"),
        bytes32("Ancient Skeleton"),
        bytes32("Pig"),
        bytes32("Slenderman"),
        bytes32("The Clown"),
        bytes32("The Pirate"),
        bytes32("The Witch"),
        bytes32("The Wizard")
    ];

    /// @notice Keccak256 hash of the committed global seed
    bytes32 public immutable COMMITTED_GLOBAL_SEED_HASH;

    /// @notice Keccak256 hash of the committed shuffler seed
    bytes32 public immutable COMMITTED_SHUFFLER_SEED_HASH;

    /// @notice The revealed global seed used for generating token metadata randomness
    uint256 public globalSeed;

    /// @notice The revealed shuffler seed used for random token ID assignment
    uint256 public shufflerSeed;

    /// @notice Flag indicating whether minting is permanently closed (1 = closed, 0 = open)
    uint8 public mintIsClosed = 0;

    /// @notice Flag indicating whether metadata has been revealed (1 = revealed, 0 = hidden)
    uint8 internal metaGenRevealed = 0;

    /// @notice Lazy shuffler for assigning random tokenIdSeeds to minted tokens
    LibPRNG.LazyShuffler internal _tokenIdSeedShuffler;

    /**
     * @notice Ensures the specified token exists
     *
     * @param _tokenId The token ID to check
     */
    modifier tokenExists(uint256 _tokenId) {
        if (!_exists(_tokenId)) {
            revert NonExistentToken();
        }
        _;
    }

    /**
     * @notice Ensures the caller is the owner of the specified token
     *
     * @param _tokenId The token ID to check ownership for
     */
    modifier onlyTokenOwner(uint256 _tokenId) {
        if (ownerOf(_tokenId) != msg.sender) {
            revert CallerIsNotTokenOwner();
        }
        _;
    }

    /**
     * @notice Constructor for the RetroPunks contract
     *
     * @dev Initializes the ERC721A contract via SeaDrop with collection name and symbol
     *
     * @param _metaGen The IMetaGen (metadata generator) contract address
     * @param _globalHash The keccak256 hash of the committed global seed
     * @param _shufflerHash The keccak256 hash of the committed shuffler seed
     * @param _maxSupplyParam The maximum supply of the collection
     * @param _allowedSeaDrop Array of allowed SeaDrop contract addresses for minting
     */
    constructor(IMetaGen _metaGen, bytes32 _globalHash, bytes32 _shufflerHash, uint256 _maxSupplyParam, address[] memory _allowedSeaDrop)
        ERC721SeaDropPausableAndQueryable("RetroPunks", "RPNKS", _allowedSeaDrop)
    {
        COMMITTED_GLOBAL_SEED_HASH = _globalHash;
        COMMITTED_SHUFFLER_SEED_HASH = _shufflerHash;
        metaGen = _metaGen;
        _maxSupply = _maxSupplyParam;
    }

    /**
     * @notice Admin function for setting IMetaGen 
     *         (Metadata Generator) contract
     *
     * @param _metaGen The new IMetaGen contract address
     */
    function setMetaGen(IMetaGen _metaGen) external onlyOwner {
        metaGen = _metaGen;
        emit BatchMetadataUpdate(1, _nextTokenId() - 1);
    }

    /**
     * @notice Reveals the metadata generator, showing full token metadata to holders
     *
     * @dev Can only be called by owner after global seed is revealed
     *      Emits BatchMetadataUpdate for all existing tokens to refresh metadata
     *
     * @custom:throws GlobalSeedNotRevealedYet if global seed hasn't been revealed yet
     */
    function revealMetaGen() external onlyOwner {
        if (globalSeed == 0) {
            revert GlobalSeedNotRevealedYet();
        } else {
            metaGenRevealed = 1;
            // Emit batch update event if any tokens exist to trigger metadata refresh
            if (totalSupply() != 0) {
                emit BatchMetadataUpdate(1, _nextTokenId() - 1);
            }
            emit MetaGenRevealed();
        }
    }

    /**
     * @notice Reveals the global seed used for metadata generation randomness
     *
     * @dev Implements commit-reveal scheme to ensure fairness - the revealed seed must match
     *      the committed hash. Can only be called once.
     *
     * @param _seed The seed used in the original commitment
     * @param _nonce The nonce used in the original commitment
     *
     * @custom:throws GlobalSeedAlreadyRevealed if seed has already been revealed
     * @custom:throws InvalidGlobalSeedReveal if the hash doesn't match the committed hash
     */
    function revealGlobalSeed(uint256 _seed, uint256 _nonce) external onlyOwner {
        if (globalSeed != 0) {
            revert GlobalSeedAlreadyRevealed();
        }

        // Verify the revealed seed matches the committed hash
        if (keccak256(abi.encodePacked(_seed, _nonce)) != COMMITTED_GLOBAL_SEED_HASH) {
            revert InvalidGlobalSeedReveal();
        }

        globalSeed = _seed;

        emit GlobalSeedRevealed();

        // Emit batch update event if any tokens exist to trigger metadata refresh
        if (totalSupply() != 0) {
            emit BatchMetadataUpdate(1, _nextTokenId() - 1);
        }
    }

    /**
     * @notice Reveals the shuffler seed used for random token assignment
     *
     * @dev Implements commit-reveal scheme to ensure fairness.
     *      Initializes the lazy shuffler with maxSupply for better randomness.
     *
     * @param _seed The seed used in the original commitment
     * @param _nonce The nonce used in the original commitment
     *
     * @custom:throws ShufflerSeedAlreadyRevealed if seed has already been revealed
     * @custom:throws InvalidShufflerSeedReveal if the hash doesn't match the committed hash
     */
    function revealShufflerSeed(uint256 _seed, uint256 _nonce) external onlyOwner {
        if (shufflerSeed != 0) {
            revert ShufflerSeedAlreadyRevealed();
        }

        // Verify the revealed seed matches the committed hash
        if (keccak256(abi.encodePacked(_seed, _nonce)) != COMMITTED_SHUFFLER_SEED_HASH) {
            revert InvalidShufflerSeedReveal();
        }

        shufflerSeed = _seed;

        emit ShufflerSeedRevealed();

        // Initialize shuffler with larger pool for smaller collections to ensure better randomness
        _tokenIdSeedShuffler.initialize(_maxSupply);
    }

    /**
     * @notice Permanently closes minting for the collection
     *
     * @dev Once called, no more tokens can be minted. This is irreversible.
     */
    function closeMint() external onlyOwner {
        mintIsClosed = 1;
        emit MintClosed();
    }

    /**
     * @notice Batch mints tokens to multiple addresses (owner only)
     *
     * @dev Allows the owner to mint specific quantities to different addresses in one transaction
     *
     * @param _toAddresses Array of recipient addresses
     * @param _amounts Array of amounts to mint to each address
     *
     * @custom:throws ArrayLengthMismatch if arrays don't have matching lengths
     * @custom:throws MintQuantityExceedsMaxSupply if total amount exceeds remaining supply
     */
    function batchOwnerMint(address[] calldata _toAddresses, uint256[] calldata _amounts) external onlyOwner nonReentrant {
        if (_toAddresses.length != _amounts.length) {
            revert ArrayLengthMismatch();
        }

        uint256 totalRequested = 0;

        // Calculate total minting amount to check supply limits efficiently
        for (uint256 i = 0; i < _amounts.length;) {
            totalRequested += _amounts[i];
            unchecked {
                ++i;
            }
        }

        _checkMaxSupply(totalRequested);

        // Mint to each address sequentially
        for (uint256 i = 0; i < _toAddresses.length;) {
            _addInternalMintMetadata(_amounts[i]);
            _safeMint(_toAddresses[i], _amounts[i]);
            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Allows token owners to customize their token's metadata
     * @dev Validates character set for name (alphanumeric + space, !, ', -, ., #, _)
     *      Pre-rendered special punks (tokenIDSeeds 0-6) cannot change background
     *
     * @param _tokenId The token ID to update
     * @param _name Custom name (max 32 bytes, stored as bytes32)
     * @param _bio Custom biography (max 160 characters)
     * @param _backgroundIndex Index of the background (0 to NUM_BACKGROUND-1)
     *
     * @custom:throws MetadataNotRevealedYet if metadata hasn't been revealed
     * @custom:throws InvalidBackgroundIndex if background index is out of range
     * @custom:throws BioIsTooLong if bio exceeds 160 characters
     * @custom:throws CannotSetBackgroundForPreRenderedSpecialPunks if trying to change special punk background
     * @custom:throws InvalidCharacterInName if name contains invalid characters
     */
    function setTokenMetadata(uint256 _tokenId, bytes32 _name, string calldata _bio, uint8 _backgroundIndex) external onlyTokenOwner(_tokenId) {
        if (metaGenRevealed == 0) {
            revert MetadataNotRevealedYet();
        }
        if (_backgroundIndex >= NUM_BACKGROUND) {
            revert InvalidBackgroundIndex();
        }
        if (bytes(_bio).length > 160) {
            revert BioIsTooLong();
        }

        // Special pre-rendered punks (0-6) have fixed backgrounds
        if (globalTokenMetadata[_tokenId].tokenIdSeed < NUM_PRE_RENDERED_SPECIALS) {
            if (_backgroundIndex != globalTokenMetadata[_tokenId].backgroundIndex) {
                revert CannotSetBackgroundForPreRenderedSpecialPunks();
            }
        }

        // Validate name characters using inline assembly for gas efficiency
        // Allowed: alphanumeric (a-z, A-Z, 0-9) + special chars (space, !, ', -, ., #, _)
        assembly {
            let _nameBytes := _name
            let invalidSelector := 0xa23ef83b // InvalidCharacterInName()

            // Loop through each byte of the name
            for { let i := 0 } lt(i, 32) { i := add(i, 1) } {
                let c := byte(i, _nameBytes)
                if iszero(c) { break } // Stop at null terminator

                // Check if character is alphanumeric
                let isAlphanumeric :=
                    or(
                        and(gt(c, 0x2f), lt(c, 0x3a)), // 0-9 (ASCII 48-57)
                        or(
                            and(gt(c, 0x40), lt(c, 0x5b)), // A-Z (ASCII 65-90)
                            and(gt(c, 0x60), lt(c, 0x7b)) // a-z (ASCII 97-122)
                        )
                    )

                if isAlphanumeric { continue }

                // Check allowed special characters
                switch c
                case 0x20 { } // space
                case 0x21 { } // !
                case 0x27 { } // '
                case 0x2d { } // -
                case 0x2e { } // .
                case 0x23 { } // #
                case 0x5f { } // _
                default {
                    // Invalid character found, revert
                    mstore(0x00, invalidSelector)
                    revert(0x00, 0x04)
                }
            }
        }

        // Update the token metadata in storage
        TokenMetadata storage meta = globalTokenMetadata[_tokenId];
        meta.name = _name;
        meta.bio = _bio;
        meta.backgroundIndex = _backgroundIndex;

        emit MetadataUpdate(_tokenId);
    }

    /**
     * @notice Internal mint function override from ERC721A
     *
     * @dev Adds additional checks: ensures mint is not closed, checks max supply,
     *      adds metadata, then calls parent mint. Auto-closes mint when max supply is reached.
     *
     * @param _to Address receiving the tokens
     * @param _quantity Number of tokens to mint
     *
     * @custom:throws MintIsClosed if minting has been permanently closed
     */
    function _mint(address _to, uint256 _quantity) internal override {
        if (mintIsClosed == 1) {
            revert MintIsClosed();
        }
        _checkMaxSupply(_quantity);
        _addInternalMintMetadata(_quantity);
        super._mint(_to, _quantity);

        // Automatically close minting when max supply is reached
        if (_totalMinted() == maxSupply()) {
            mintIsClosed = 1;
        }
    }

    /**
     * @notice Internal function to add metadata for a batch of minted tokens
     *
     * @dev Calls _saveNewSeed for each token in the quantity being minted
     *
     * @param _quantity Number of tokens being minted
     *
     * @custom:throws ShufflerSeedNotRevealedYet if shuffler seed hasn't been revealed
     */
    function _addInternalMintMetadata(uint256 _quantity) internal {
        if (shufflerSeed == 0) {
            revert ShufflerSeedNotRevealedYet();
        }

        uint256 currentMintCount = _totalMinted();

        // Assign random seeds to each token being minted
        for (uint256 i = 0; i < _quantity;) {
            _saveNewSeed(currentMintCount + i + 1, _maxSupply - (currentMintCount + i));
            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Internal function to save a new random seed for a token being minted
     *
     * @dev Uses the lazy shuffler to assign a unique, random tokenIdSeed. Generates a default
     *      name (e.g., "#42"), background index (1), and bio. Uses assembly for gas optimization.
     *
     * @param _tokenId The token ID being assigned
     * @param _remaining The number of remaining unminted tokens
     *
     * @custom:throws NoRemainingTokens if there are no remaining tokens to assign
     */
    function _saveNewSeed(uint256 _tokenId, uint256 _remaining) internal {
        if (_remaining == 0) {
            revert NoRemainingTokens();
        }

        uint256 numShuffled = _tokenIdSeedShuffler.numShuffled();
        uint256 randomness;

        // Generate randomness by hashing shufflerSeed with the number of already shuffled tokens
        assembly {
            let sSeed := sload(shufflerSeed.slot)
            mstore(0x00, sSeed)
            mstore(0x20, numShuffled)
            randomness := keccak256(0x00, 0x40)
        }

        // Get the next random tokenIdSeed from the shuffler
        uint256 newTokenIdSeed = _tokenIdSeedShuffler.next(randomness);

        assembly {
            /*
             * OPTIMIZED NAME GENERATION
             * Generates default name in format "#123" by converting tokenId to ASCII
             */
            let nameBytes := 0
            let tempId := _tokenId
            let charPos := 31 // Start from rightmost position in bytes32

            // Convert ID to ASCII digits backwards (123 -> "321" in bytes)
            for { } gt(tempId, 0) { } {
                let digit := add(mod(tempId, 10), 48) // Convert digit to ASCII (0-9 = 48-57)
                nameBytes := or(nameBytes, shl(mul(sub(31, charPos), 8), digit))
                tempId := div(tempId, 10)
                charPos := sub(charPos, 1)
            }

            // Add the "#" prefix (ASCII 0x23) before the number
            nameBytes := or(nameBytes, shl(mul(sub(31, charPos), 8), 0x23))

            // Shift left so the string starts from the first byte (proper bytes32 format)
            nameBytes := shl(mul(charPos, 8), nameBytes)

            /*
             * STORAGE PACKING
             * Pack tokenIdSeed (uint16) and backgroundIndex (uint8) into a single storage slot
             */
            mstore(0x00, _tokenId)
            mstore(0x20, globalTokenMetadata.slot)
            let slot := keccak256(0x00, 0x40) // Calculate storage slot for this token ID

            // Pack struct fields (Solidity packs right-to-left):
            // Bits 0-15: tokenIdSeed (uint16)
            // Bits 16-23: backgroundIndex (uint8)
            let seedPart := and(newTokenIdSeed, 0xFFFF) // Mask to 16 bits
            let bgPart := shl(16, 1) // Background index 1, shifted to bits 16-23
            let packed := or(seedPart, bgPart)

            sstore(slot, packed) // Slot 0: tokenIdSeed & backgroundIndex
            sstore(add(slot, 1), nameBytes) // Slot 1: name (bytes32)
        }

        globalTokenMetadata[_tokenId].bio = "A RetroPunk living on-chain.";
    }

    /**
     * @notice Internal function to check if minting quantity exceeds max supply
     *
     * @dev Reverts if minting would exceed the collection's maximum supply
     *
     * @param _quantity Number of tokens to check
     *
     * @custom:throws MintQuantityExceedsMaxSupply if quantity exceeds remaining supply
     */
    function _checkMaxSupply(uint256 _quantity) internal view {
        uint256 minted = _totalMinted();
        uint256 max = maxSupply();
        if (minted + _quantity > max) {
            revert MintQuantityExceedsMaxSupply(minted + _quantity, max);
        }
    }

    /**
     * @notice Returns the token URI for a given token ID
     *
     * @dev Generates a data URI containing the token's metadata and SVG image
     *
     * @param tokenId The token ID to get the URI for
     *
     * @return A base64-encoded data URI with JSON metadata
     *
     * @custom:throws NonExistentToken if token doesn't exist
     */
    function tokenURI(uint256 tokenId) public view override tokenExists(tokenId) returns (string memory) {
        TokenMetadata memory meta = globalTokenMetadata[tokenId];
        return _generateDataURI(tokenId, meta.tokenIdSeed, meta.backgroundIndex, Utils.toString(meta.name), meta.bio, globalSeed);
    }

    /**
     * @notice Generates a complete data URI for a token using the MetaGen
     *         (metadata generator) contract
     *
     * @dev Creates JSON metadata with SVG image based on reveal status:
     *      - Before reveal: Shows "#???" and "Wait for the reveal..."
     *      - After reveal: Shows actual metadata with name & bio
     *
     *      Special tokens (tokenIDSeeds 0-15) have a name property of
     *      "1 of 1: [Special Name]" unless customized
     *
     * @param _tokenId The token ID
     * @param _tokenIdSeed The randomly shuffled token seed
     * @param _backgroundIndex The background index for the token
     * @param _name The custom or default name
     * @param _bio The custom or default bio
     * @param _globalSeed The global randomness seed
     *
     * @return A base64-encoded data URI containing JSON metadata with embedded SVG
     */
    function _generateDataURI(uint256 _tokenId, uint16 _tokenIdSeed, uint8 _backgroundIndex, string memory _name, string memory _bio, uint256 _globalSeed)
        internal
        view
        returns (string memory)
    {
        string memory finalName;
        string memory finalBio;
        string memory attributes;
        string memory svg;

        if (metaGenRevealed == 0) {
            // Pre-reveal state: generate placeholder metadata
            (svg, attributes) = metaGen.generateMetadata(_tokenIdSeed, _backgroundIndex, _globalSeed, 0);
            finalName = "#???";
            finalBio = "Wait for the reveal...";
        } else {
            // Post-reveal state: generate full metadata
            (svg, attributes) = metaGen.generateMetadata(_tokenIdSeed, _backgroundIndex, _globalSeed, 1);

            // Construct the default name format: "#123"
            string memory defaultName = string.concat("#", Utils.toString(_tokenId));
            bool isDefaultName = keccak256(bytes(_name)) == keccak256(bytes(defaultName));

            // Handle special 1-of-1 tokens (indices 0-15)
            if (_tokenIdSeed < NUM_SPECIAL_1S) {
                finalName = isDefaultName ? string.concat("1 of 1: ", Utils.toString(SPECIAL_NAMES[_tokenIdSeed])) : _name;
            } else {
                // Regular tokens: if custom name, show "#123: Custom Name", else just "#123"
                finalName = isDefaultName ? _name : string.concat(defaultName, ": ", _name);
            }

            finalBio = _bio;
        }

        // Construct the JSON metadata with base64-encoded SVG
        string memory json = string.concat(
            '{"name":"', finalName, '","description":"', finalBio, '",', attributes, ',"image":"data:image/svg+xml;base64,', Utils.encodeBase64(bytes(svg)), '"}'
        );

        // Return as a base64-encoded data URI
        return string.concat("data:application/json;base64,", Utils.encodeBase64(bytes(json)));
    }
}
