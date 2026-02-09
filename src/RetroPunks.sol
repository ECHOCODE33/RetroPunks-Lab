// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { E_Background, NUM_BACKGROUND, NUM_SPECIAL_1S } from "./common/Enums.sol"; // NUM_SPECIAL_1S = 16
import { IMetaGen } from "./interfaces/IMetaGen.sol";
import { LibPRNG } from "./libraries/LibPRNG.sol";
import { Utils } from "./libraries/Utils.sol";
import { ERC721SeaDropPausableAndQueryable } from "./seadrop/extensions/ERC721SeaDropPausableAndQueryable.sol";

struct TokenMetadata {
    uint16 tokenIdSeed;
    uint8 backgroundIndex;
    bytes32 name;
    string bio;
}

/**
 * @title RetroPunks
 * @author ECHO
 * @notice The main contract for the RetroPunks collection
 * @dev Inherits ERC721SeaDropPausableAndQueryable
 */
contract RetroPunks is ERC721SeaDropPausableAndQueryable {
    using LibPRNG for LibPRNG.LazyShuffler;

    uint16 private constant NUM_PRE_RENDERED_SPECIALS = 7;
    uint8 internal revealMetaGenSet = 0;

    IMetaGen public metaGen;

    bytes32 public immutable COMMITTED_GLOBAL_SEED_HASH;
    bytes32 public immutable COMMITTED_SHUFFLER_SEED_HASH;

    uint256 public globalSeed;
    uint256 public shufflerSeed;

    uint8 public mintIsClosed = 0;

    bytes32[16] private SPECIAL_NAMES = [
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

    mapping(uint256 => TokenMetadata) public globalTokenMetadata;
    LibPRNG.LazyShuffler private _tokenIdSeedShuffler;
    uint8 public constant DEFAULT_BACKGROUND_INDEX = uint8(uint256(E_Background.Standard));

    // ----- Events ----- //
    event MetadataUpdate(uint256 _tokenId);

    // ----- Errors ----- //
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

    // ----- Modifiers ----- //
    modifier tokenExists(uint256 _tokenId) {
        _tokenExists(_tokenId);
        _;
    }

    modifier onlyTokenOwner(uint256 _tokenId) {
        _onlyTokenOwner(_tokenId);
        _;
    }

    modifier notPreRenderedSpecial(uint256 tokenId) {
        _notPreRenderedSpecial(tokenId);
        _;
    }

    function _tokenExists(uint256 _tokenId) internal view {
        if (!_exists(_tokenId)) revert NonExistentToken();
    }

    function _onlyTokenOwner(uint256 _tokenId) internal view {
        if (ownerOf(_tokenId) != msg.sender) revert CallerIsNotTokenOwner();
    }

    function _notPreRenderedSpecial(uint256 tokenId) internal view {
        // NEW: Only restrict the first 7 (Seeds 0-6).
        // Seeds 7-15 are allowed to change backgrounds.
        if (globalTokenMetadata[tokenId].tokenIdSeed < NUM_PRE_RENDERED_SPECIALS) revert PreRenderedSpecialCannotBeCustomized();
    }

    // ----- Constructor ----- //
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

    // ----- Admin Functions ----- //
    function setMetaGen(IMetaGen _metaGen, bool _isRevealMetaGen) external onlyOwner {
        metaGen = _metaGen;
        if (_isRevealMetaGen) revealMetaGenSet = 1;
        if (totalSupply() != 0) emit BatchMetadataUpdate(1, _nextTokenId() - 1);
    }

    function closeMint() external onlyOwner {
        mintIsClosed = 1;
    }

    function revealGlobalSeed(uint256 _seed, uint256 _nonce) external onlyOwner {
        if (globalSeed != 0) revert GlobalSeedAlreadyRevealed();

        if (keccak256(abi.encodePacked(_seed, _nonce)) != COMMITTED_GLOBAL_SEED_HASH) revert InvalidGlobalSeedReveal();

        globalSeed = _seed;

        if (totalSupply() != 0) emit BatchMetadataUpdate(1, _nextTokenId() - 1);
    }

    function revealShufflerSeed(uint256 _seed, uint256 _nonce) external onlyOwner {
        if (shufflerSeed != 0) revert ShufflerSeedAlreadyRevealed();

        if (keccak256(abi.encodePacked(_seed, _nonce)) != COMMITTED_SHUFFLER_SEED_HASH) revert InvalidShufflerSeedReveal();

        shufflerSeed = _seed;

        _tokenIdSeedShuffler.initialize(_maxSupply > 1000 ? _maxSupply : _maxSupply * 2);
    }

    function batchOwnerMint(address[] calldata toAddresses, uint256[] calldata amounts) external onlyOwner nonReentrant {
        if (toAddresses.length != amounts.length) revert ArrayLengthMismatch();

        uint256 totalRequested = 0;

        // Calculate total once to check supply and limits efficiently
        for (uint256 i = 0; i < amounts.length; i++) {
            totalRequested += amounts[i];
        }

        _checkMaxSupply(totalRequested);

        // Mint to each address
        for (uint256 i = 0; i < toAddresses.length; i++) {
            _addInternalMintMetadata(amounts[i]);
            _safeMint(toAddresses[i], amounts[i]);
        }
    }

    // ----- Token Customization ----- //
    function setTokenMetadata(uint256 tokenId, bytes32 name, string calldata bio, uint8 backgroundIndex) external onlyTokenOwner(tokenId) {
        if (revealMetaGenSet == 0) revert MetadataNotRevealedYet();
        if (backgroundIndex >= NUM_BACKGROUND) revert InvalidBackgroundIndex();
        if (bytes(bio).length > 160) revert BioIsTooLong();

        if (globalTokenMetadata[tokenId].tokenIdSeed < NUM_PRE_RENDERED_SPECIALS) {
            if (backgroundIndex != globalTokenMetadata[tokenId].backgroundIndex) {
                revert("Special Punks cannot change background");
            }
        }

        for (uint256 i = 0; i < 32; i++) {
            bytes1 c = name[i];
            if (c == 0) break; // End of string
            if (!((c >= 0x30 && c <= 0x39) || (c >= 0x41 && c <= 0x5A) || (c >= 0x61 && c <= 0x7A)
                        || (c == 0x20 || c == 0x21 || c == 0x2D || c == 0x2E || c == 0x5F || c == 0x27))) {
                revert InvalidCharacterInName();
            }
        }

        TokenMetadata storage meta = globalTokenMetadata[tokenId];
        meta.name = name;
        meta.bio = bio;
        meta.backgroundIndex = backgroundIndex;

        emit MetadataUpdate(tokenId);
    }

    // ----- Public & Internal Functions ----- //

    function _saveNewSeed(uint256 tokenId, uint256 remaining) internal {
        if (remaining == 0) revert NoRemainingTokens();

        uint256 numShuffled = _tokenIdSeedShuffler.numShuffled();
        uint256 randomness = uint256(keccak256(abi.encodePacked(shufflerSeed, numShuffled)));
        uint256 newTokenIdSeed = _tokenIdSeedShuffler.next(randomness);

        globalTokenMetadata[tokenId] = TokenMetadata({
            tokenIdSeed: uint16(newTokenIdSeed),
            backgroundIndex: DEFAULT_BACKGROUND_INDEX,
            name: bytes32(abi.encodePacked("#", Utils.toString(tokenId))),
            bio: "A RetroPunk living on-chain."
        });
    }

    function _addInternalMintMetadata(uint256 quantity) internal {
        if (shufflerSeed == 0) revert ShufflerSeedNotRevealedYet();

        uint256 currentMintCount = _totalMinted();

        for (uint256 i = 0; i < quantity; i++) {
            _saveNewSeed(currentMintCount + i + 1, _maxSupply - (currentMintCount + i));
        }
    }

    function _checkMaxSupply(uint256 quantity) internal view {
        if (_totalMinted() + quantity > maxSupply()) {
            revert MintQuantityExceedsMaxSupply(_totalMinted() + quantity, maxSupply());
        }
    }

    function _mint(address to, uint256 quantity) internal override {
        if (mintIsClosed == 1) revert MintIsClosed();
        _checkMaxSupply(quantity);
        _addInternalMintMetadata(quantity);
        super._mint(to, quantity);
        if (_totalMinted() == maxSupply()) mintIsClosed = 1;
    }

    function tokenURI(uint256 tokenId) public view override tokenExists(tokenId) returns (string memory) {
        TokenMetadata memory meta = globalTokenMetadata[tokenId];
        return renderDataUri(tokenId, meta.tokenIdSeed, meta.backgroundIndex, Utils.toString(meta.name), meta.bio, globalSeed);
    }

    function renderDataUri(uint256 _tokenId, uint16 _tokenIdSeed, uint8 _backgroundIndex, string memory _name, string memory _bio, uint256 _globalSeed)
        internal
        view
        returns (string memory)
    {
        string memory finalName;
        string memory finalBio;
        string memory attributes;
        string memory svg;

        if (revealMetaGenSet == 0) {
            // Pre-reveal: use placeholder values
            (svg,) = metaGen.generateMetadata(_tokenIdSeed, _backgroundIndex, _globalSeed);
            finalName = "Unrevealed Punk";
            finalBio = "Wait for the reveal...";
            attributes = '"attributes":[{"trait_type":"Status","value":"Unrevealed"}]';
        } else {
            // Post-reveal: use actual metaGen output
            (svg, attributes) = metaGen.generateMetadata(_tokenIdSeed, _backgroundIndex, _globalSeed);

            if (_tokenIdSeed < NUM_SPECIAL_1S) {
                string memory defaultName = string.concat("#", Utils.toString(_tokenId));
                bool isDefaultName = keccak256(bytes(_name)) == keccak256(bytes(defaultName));

                if (isDefaultName) {
                    finalName = string.concat("1 of 1: ", Utils.toString(SPECIAL_NAMES[_tokenIdSeed]));
                } else {
                    finalName = _name;
                }
            } else {
                string memory defaultName = string.concat("#", Utils.toString(_tokenId));
                bool isDefaultName = keccak256(bytes(_name)) == keccak256(bytes(defaultName));

                finalName = isDefaultName ? _name : string.concat(defaultName, ": ", _name);
            }

            finalBio = _bio;
        }

        string memory json = string.concat(
            '{"name":"', finalName, '","description":"', finalBio, '",', attributes, ',"image":"data:image/svg+xml;base64,', Utils.encodeBase64(bytes(svg)), '"}'
        );

        return string.concat("data:application/json;base64,", Utils.encodeBase64(bytes(json)));
    }
}
