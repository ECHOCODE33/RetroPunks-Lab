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
 * @notice The main contract for the RetroPunks collection
 *
 * ██████╗  ███████╗ ████████╗ ██████╗   ██████╗  ██████╗  ██╗   ██╗ ███╗   ██╗ ██╗  ██╗ ███████╗
 * ██╔══██╗ ██╔════╝ ╚══██╔══╝ ██╔══██╗ ██╔═══██╗ ██╔══██╗ ██║   ██║ ████╗  ██║ ██║ ██╔╝ ██╔════╝
 * ██████╔╝ █████╗      ██║    ██████╔╝ ██║   ██║ ██████╔╝ ██║   ██║ ██╔██╗ ██║ █████╔╝  ███████╗
 * ██╔══██╗ ██╔══╝      ██║    ██╔══██╗ ██║   ██║ ██╔═══╝  ██║   ██║ ██║╚██╗██║ ██╔═██╗  ╚════██║
 * ██║  ██║ ███████╗    ██║    ██║  ██║ ╚██████╔╝ ██║      ╚██████╔╝ ██║ ╚████║ ██║  ██╗ ███████║
 * ╚═╝  ╚═╝ ╚══════╝    ╚═╝    ╚═╝  ╚═╝  ╚═════╝  ╚═╝       ╚═════╝  ╚═╝  ╚═══╝ ╚═╝  ╚═╝ ╚══════╝
 */
contract RetroPunks is IRetroPunksTypes, ERC721SeaDropPausableAndQueryable {
    using LibPRNG for LibPRNG.LazyShuffler;

    IMetaGen public metaGen;

    mapping(uint256 => TokenMetadata) public globalTokenMetadata;

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

    bytes32 public immutable COMMITTED_GLOBAL_SEED_HASH;
    bytes32 public immutable COMMITTED_SHUFFLER_SEED_HASH;
    uint256 public globalSeed;
    uint256 public shufflerSeed;

    uint8 public mintIsClosed = 0;

    uint8 internal metaGenRevealed = 0;

    LibPRNG.LazyShuffler internal _tokenIdSeedShuffler;

    modifier tokenExists(uint256 _tokenId) {
        if (!_exists(_tokenId)) revert NonExistentToken();
        _;
    }

    modifier onlyTokenOwner(uint256 _tokenId) {
        if (ownerOf(_tokenId) != msg.sender) revert CallerIsNotTokenOwner();
        _;
    }

    /**
     * @notice Constructor for the RetroPunks contract.
     * @param _metaGenParam                     The IMetaGen (metadata generator) contract address.
     * @param _committedGlobalSeedHashParam     The committed global seed hash.
     * @param _committedShufflerSeedHashParam   The committed shuffler seed hash.
     * @param _maxSupplyParam                   The maximum supply of the collection.
     * @param allowedSeaDropParam               The allowed SeaDrop contract addresses.
     */
    constructor(
        IMetaGen _metaGenParam,
        bytes32 _committedGlobalSeedHashParam,
        bytes32 _committedShufflerSeedHashParam,
        uint256 _maxSupplyParam,
        address[] memory allowedSeaDropParam
    ) ERC721SeaDropPausableAndQueryable("RetroPunks", "RPNKS", allowedSeaDropParam) {
        COMMITTED_GLOBAL_SEED_HASH = _committedGlobalSeedHashParam;
        COMMITTED_SHUFFLER_SEED_HASH = _committedShufflerSeedHashParam;
        metaGen = _metaGenParam;
        _maxSupply = _maxSupplyParam;
    }

    function revealMetaGen() external onlyOwner {
        if (globalSeed == 0) {
            revert GlobalSeedNotRevealedYet();
        } else {
            metaGenRevealed = 1;
            if (totalSupply() != 0) emit BatchMetadataUpdate(1, _nextTokenId() - 1);
            emit MetaGenRevealed();
        }
    }

    function revealGlobalSeed(uint256 _seed, uint256 _nonce) external onlyOwner {
        if (globalSeed != 0) revert GlobalSeedAlreadyRevealed();

        if (keccak256(abi.encodePacked(_seed, _nonce)) != COMMITTED_GLOBAL_SEED_HASH) revert InvalidGlobalSeedReveal();

        globalSeed = _seed;

        emit GlobalSeedRevealed(_seed);

        if (totalSupply() != 0) emit BatchMetadataUpdate(1, _nextTokenId() - 1);
    }

    function revealShufflerSeed(uint256 _seed, uint256 _nonce) external onlyOwner {
        if (shufflerSeed != 0) revert ShufflerSeedAlreadyRevealed();

        if (keccak256(abi.encodePacked(_seed, _nonce)) != COMMITTED_SHUFFLER_SEED_HASH) revert InvalidShufflerSeedReveal();

        shufflerSeed = _seed;

        emit ShufflerSeedRevealed(_seed);

        _tokenIdSeedShuffler.initialize(_maxSupply > 1000 ? _maxSupply : _maxSupply * 2);
    }

    function closeMint() external onlyOwner {
        mintIsClosed = 1;
        emit MintClosed();
    }

    function batchOwnerMint(address[] calldata _toAddresses, uint256[] calldata _amounts) external onlyOwner nonReentrant {
        if (_toAddresses.length != _amounts.length) revert ArrayLengthMismatch();

        uint256 totalRequested = 0;

        // Calculate total once to check supply and limits efficiently
        for (uint256 i = 0; i < _amounts.length;) {
            totalRequested += _amounts[i];
            unchecked {
                ++i;
            }
        }

        _checkMaxSupply(totalRequested);

        // Mint to each address
        for (uint256 i = 0; i < _toAddresses.length;) {
            _addInternalMintMetadata(_amounts[i]);
            _safeMint(_toAddresses[i], _amounts[i]);
            unchecked {
                ++i;
            }
        }
    }

    function setTokenMetadata(uint256 _tokenId, bytes32 _name, string calldata _bio, uint8 _backgroundIndex) external onlyTokenOwner(_tokenId) {
        if (metaGenRevealed == 0) revert MetadataNotRevealedYet();
        if (_backgroundIndex >= NUM_BACKGROUND) revert InvalidBackgroundIndex();
        if (bytes(_bio).length > 160) revert BioIsTooLong();

        if (globalTokenMetadata[_tokenId].tokenIdSeed < NUM_PRE_RENDERED_SPECIALS) {
            if (_backgroundIndex != globalTokenMetadata[_tokenId].backgroundIndex) {
                revert CannotSetBackgroundForPreRenderedSpecialPunks();
            }
        }

        assembly {
            let _nameBytes := _name
            let invalidSelector := 0xa23ef83b // InvalidCharacterInName()

            for { let i := 0 } lt(i, 32) { i := add(i, 1) } {
                let c := byte(i, _nameBytes)
                if iszero(c) { break }

                let isAlphanumeric :=
                    or(
                        and(gt(c, 0x2f), lt(c, 0x3a)), // 0-9
                        or(
                            and(gt(c, 0x40), lt(c, 0x5b)), // A-Z
                            and(gt(c, 0x60), lt(c, 0x7b)) // a-z
                        )
                    )

                if isAlphanumeric { continue }

                switch c
                case 0x20 { }
                case 0x21 { }
                case 0x27 { }
                case 0x2d { }
                case 0x2e { }
                case 0x23 { }
                case 0x5f { }
                default {
                    mstore(0x00, invalidSelector)
                    revert(0x00, 0x04)
                }
            }
        }

        TokenMetadata storage meta = globalTokenMetadata[_tokenId];
        meta.name = _name;
        meta.bio = _bio;
        meta.backgroundIndex = _backgroundIndex;

        emit MetadataUpdate(_tokenId);
    }

    function _saveNewSeed(uint256 _tokenId, uint256 _remaining) internal {
        if (_remaining == 0) revert NoRemainingTokens();

        uint256 numShuffled = _tokenIdSeedShuffler.numShuffled();
        uint256 randomness;

        // 1. Generate Randomness (Kept your logic)
        assembly {
            let sSeed := sload(shufflerSeed.slot)
            mstore(0x00, sSeed)
            mstore(0x20, numShuffled)
            randomness := keccak256(0x00, 0x40)
        }

        uint256 newTokenIdSeed = _tokenIdSeedShuffler.next(randomness);

        assembly {
            /**
             * 2. OPTIMIZED NAME GENERATION ("#123")
             */
            let nameBytes := 0
            let tempId := _tokenId
            let charPos := 31

            // Convert ID to ASCII digits backwards
            for { } gt(tempId, 0) { } {
                let digit := add(mod(tempId, 10), 48)
                nameBytes := or(nameBytes, shl(mul(sub(31, charPos), 8), digit))
                tempId := div(tempId, 10)
                charPos := sub(charPos, 1)
            }

            // Add the "#" prefix (ASCII 0x23)
            nameBytes := or(nameBytes, shl(mul(sub(31, charPos), 8), 0x23))
            // Shift to the left so it's a valid "string" or "bytes32" starting from the first byte
            nameBytes := shl(mul(charPos, 8), nameBytes)

            /**
             * 3. STORAGE PACKING
             */
            mstore(0x00, _tokenId)
            mstore(0x20, globalTokenMetadata.slot)
            let slot := keccak256(0x00, 0x40)

            /* FIX: Solidity packs from right-to-left.
               If your struct is: { uint16 seed; uint8 backgroundIndex; }
               - Seed goes in bits 0-15
               - backgroundIndex goes in bits 16-23
            */
            let seedPart := and(newTokenIdSeed, 0xFFFF) // Bits 0-15
            let bgPart := shl(16, 1) // Bits 16-23 (default background index is 1)
            let packed := or(seedPart, bgPart)

            sstore(slot, packed) // Slot 0: Seed & BG Index
            sstore(add(slot, 1), nameBytes) // Slot 1: Name

            /**
             * 4. BIO STORAGE
             */
            // "A RetroPunk living on-chain." (27 chars)
            // We must ensure the string is left-aligned in the 32-byte word.
            let bioData := "A RetroPunk living on-chain."
            let bioLen := 27
            // Solidity short string format: [data][length * 2]
            sstore(add(slot, 2), or(bioData, mul(bioLen, 2)))
        }
    }

    function _addInternalMintMetadata(uint256 _quantity) internal {
        if (shufflerSeed == 0) revert ShufflerSeedNotRevealedYet();

        uint256 currentMintCount = _totalMinted();

        for (uint256 i = 0; i < _quantity;) {
            _saveNewSeed(currentMintCount + i + 1, _maxSupply - (currentMintCount + i));
            unchecked {
                ++i;
            }
        }
    }

    function _checkMaxSupply(uint256 _quantity) internal view {
        uint256 minted = _totalMinted();
        uint256 max = maxSupply();
        if (minted + _quantity > max) {
            revert MintQuantityExceedsMaxSupply(minted + _quantity, max);
        }
    }

    function _mint(address _to, uint256 _quantity) internal override {
        if (mintIsClosed == 1) revert MintIsClosed();
        _checkMaxSupply(_quantity);
        _addInternalMintMetadata(_quantity);
        super._mint(_to, _quantity);
        if (_totalMinted() == maxSupply()) mintIsClosed = 1;
    }

    function tokenURI(uint256 tokenId) public view override tokenExists(tokenId) returns (string memory) {
        TokenMetadata memory meta = globalTokenMetadata[tokenId];
        return generateDataURI(tokenId, meta.tokenIdSeed, meta.backgroundIndex, Utils.toString(meta.name), meta.bio, globalSeed);
    }

    function generateDataURI(uint256 _tokenId, uint16 _tokenIdSeed, uint8 _backgroundIndex, string memory _name, string memory _bio, uint256 _globalSeed)
        internal
        view
        returns (string memory)
    {
        string memory finalName;
        string memory finalBio;
        string memory attributes;
        string memory svg;

        if (metaGenRevealed == 0) {
            (svg, attributes) = metaGen.generateMetadata(_tokenIdSeed, _backgroundIndex, _globalSeed, 0);
            finalName = "#???";
            finalBio = "Wait for the reveal...";
        } else {
            (svg, attributes) = metaGen.generateMetadata(_tokenIdSeed, _backgroundIndex, _globalSeed, 1);

            string memory defaultName = string.concat("#", Utils.toString(_tokenId));
            bool isDefaultName = keccak256(bytes(_name)) == keccak256(bytes(defaultName));

            if (_tokenIdSeed < NUM_SPECIAL_1S) finalName = (isDefaultName ? string.concat("1 of 1: ", Utils.toString(SPECIAL_NAMES[_tokenIdSeed])) : _name);
            else finalName = isDefaultName ? _name : string.concat(defaultName, ": ", _name);

            finalBio = _bio;
        }

        string memory json = string.concat(
            '{"name":"', finalName, '","description":"', finalBio, '",', attributes, ',"image":"data:image/svg+xml;base64,', Utils.encodeBase64(bytes(svg)), '"}'
        );

        return string.concat("data:application/json;base64,", Utils.encodeBase64(bytes(json)));
    }
}
