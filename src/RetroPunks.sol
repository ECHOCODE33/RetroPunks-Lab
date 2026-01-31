// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { E_Background, NUM_BACKGROUND, NUM_SPECIAL_1S } from "./common/Enums.sol"; // NUM_SPECIAL_1S = 16
import { ISVGRenderer } from "./interfaces/ISVGRenderer.sol";
import { LibPRNG } from "./libraries/LibPRNG.sol";
import { Utils } from "./libraries/Utils.sol";
import { ERC721SeaDropPausableAndQueryable } from "./seadrop/extensions/ERC721SeaDropPausableAndQueryable.sol";

struct TokenMetadata {
    uint16 tokenIdSeed;
    uint8 backgroundIndex;
    string name;
    string bio;
}

/**
 * @title RetroPunks
 * @author ECHO
 */
contract RetroPunks is ERC721SeaDropPausableAndQueryable {
    using LibPRNG for LibPRNG.LazyShuffler;

    uint256 private constant NUM_PRE_RENDERED_SPECIALS = 7;

    ISVGRenderer public renderer;

    bytes32 public immutable COMMITTED_GLOBAL_SEED_HASH;
    bytes32 public immutable COMMITTED_SHUFFLER_SEED_HASH;

    uint16 public ownerMintsRemaining = 25;
    uint256 public globalSeed;
    uint256 public shufflerSeed;

    bool public mintIsClosed = false;
    bool public globalSeedRevealed = false;
    bool public shufflerSeedRevealed = false;
    bool internal revealRendererSet = false;

    string[16] private SPECIAL_NAMES = [
        "Predator Blue",
        "Predator Green",
        "Predator Red",
        "Santa Claus",
        "Shadow Ninja",
        "The Devil",
        "The Portrait",
        "Ancient Mummy",
        "CyberApe",
        "Ancient Skeleton",
        "Pig",
        "Slenderman",
        "The Clown",
        "The Pirate",
        "The Witch",
        "The Wizard"
    ];

    mapping(uint256 => TokenMetadata) public globalTokenMetadata;
    LibPRNG.LazyShuffler private _tokenIdSeedShuffler;
    uint8 public constant defaultBackgroundIndex = uint8(uint256(E_Background.Standard));

    // ----- Events ----- //
    event GlobalSeedRevealed(uint256 seed);
    event ShufflerSeedRevealed(uint256 seed);
    event BackgroundChanged(uint256 indexed tokenId, uint256 indexed backgroundIndex, address indexed owner);
    event NameChanged(uint256 indexed tokenId, string name, address indexed owner);
    event BioChanged(uint256 indexed tokenId, string bio, address indexed owner);
    event MetadataUpdate(uint256 _tokenId);

    // ----- Errors ----- //
    error MintIsClosed();
    error PreRenderedSpecialCannotBeCustomized();
    error NameIsTooLong();
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
    error NotEnoughOwnerMintsRemaining();
    error InvalidBackgroundIndex();
    error MetadataNotRevealedYet();

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
        ISVGRenderer _rendererParam,
        bytes32 _committedGlobalSeedHashParam,
        bytes32 _committedShufflerSeedHashParam,
        uint256 _maxSupplyParam,
        address[] memory allowedSeaDropParam
    ) ERC721SeaDropPausableAndQueryable("RetroPunks", "RPNKS", allowedSeaDropParam) {
        COMMITTED_GLOBAL_SEED_HASH = _committedGlobalSeedHashParam;
        COMMITTED_SHUFFLER_SEED_HASH = _committedShufflerSeedHashParam;
        renderer = _rendererParam;
        _maxSupply = _maxSupplyParam;
    }

    // ----- Admin Functions ----- //
    function setRenderer(ISVGRenderer _renderer, bool _isReveal) external onlyOwner {
        renderer = _renderer;
        if (_isReveal) revealRendererSet = true;
        if (totalSupply() != 0) emit BatchMetadataUpdate(1, _nextTokenId() - 1);
    }

    function closeMint() external onlyOwner {
        mintIsClosed = true;
    }

    function revealGlobalSeed(uint256 _seed, uint256 _nonce) external onlyOwner {
        if (globalSeedRevealed) revert GlobalSeedAlreadyRevealed();
        if (keccak256(abi.encodePacked(_seed, _nonce)) != COMMITTED_GLOBAL_SEED_HASH) revert InvalidGlobalSeedReveal();

        globalSeed = _seed;
        globalSeedRevealed = true;

        emit GlobalSeedRevealed(_seed);
        if (totalSupply() != 0) emit BatchMetadataUpdate(1, _nextTokenId() - 1);
    }

    function revealShufflerSeed(uint256 _seed, uint256 _nonce) external onlyOwner {
        if (shufflerSeedRevealed) revert ShufflerSeedAlreadyRevealed();
        if (keccak256(abi.encodePacked(_seed, _nonce)) != COMMITTED_SHUFFLER_SEED_HASH) revert InvalidShufflerSeedReveal();

        shufflerSeed = _seed;
        shufflerSeedRevealed = true;
        _tokenIdSeedShuffler.initialize(_maxSupply > 1000 ? _maxSupply : _maxSupply * 2);
        emit ShufflerSeedRevealed(_seed);
    }

    function ownerMint(address toAddress, uint256 quantity) external onlyOwner nonReentrant {
        if (ownerMintsRemaining < quantity) revert NotEnoughOwnerMintsRemaining();
        ownerMintsRemaining -= uint16(quantity);
        _checkMaxSupply(quantity);
        _addInternalMintMetadata(quantity);
        _safeMint(toAddress, quantity);
    }

    function setOwnerMintsRemaining(uint16 newRemaining) external onlyOwner {
        ownerMintsRemaining = newRemaining;
    }

    // ----- Token Customization ----- //
    function setTokenBackground(uint256 tokenId, uint256 backgroundIndex) external onlyTokenOwner(tokenId) notPreRenderedSpecial(tokenId) {
        if (!revealRendererSet) revert MetadataNotRevealedYet();
        if (backgroundIndex >= NUM_BACKGROUND) revert InvalidBackgroundIndex();

        globalTokenMetadata[tokenId].backgroundIndex = uint8(backgroundIndex);
        emit MetadataUpdate(tokenId);
        emit BackgroundChanged(tokenId, backgroundIndex, msg.sender);
    }

    function setTokenName(uint256 tokenId, string calldata name) external onlyTokenOwner(tokenId) {
        if (!revealRendererSet) revert MetadataNotRevealedYet();
        bytes memory b = bytes(name);
        if (!(b.length > 0 && b.length <= 32)) revert NameIsTooLong();

        for (uint256 i = 0; i < b.length;) {
            bytes1 c = b[i];
            if (!((c >= 0x30 && c <= 0x39) || (c >= 0x41 && c <= 0x5A) || (c >= 0x61 && c <= 0x7A)
                        || (c == 0x20 || c == 0x21 || c == 0x2D || c == 0x2E || c == 0x5F || c == 0x27))) revert InvalidCharacterInName();
            unchecked {
                ++i;
            }
        }
        globalTokenMetadata[tokenId].name = name;
        emit MetadataUpdate(tokenId);
        emit NameChanged(tokenId, name, msg.sender);
    }

    function setTokenBio(uint256 tokenId, string calldata bio) external onlyTokenOwner(tokenId) {
        if (!revealRendererSet) revert MetadataNotRevealedYet();
        if (bytes(bio).length > 160) revert BioIsTooLong();
        globalTokenMetadata[tokenId].bio = bio;
        emit MetadataUpdate(tokenId);
        emit BioChanged(tokenId, bio, msg.sender);
    }

    // ----- Public & Internal Functions ----- //
    function _getInitialName(uint256 tokenId) internal pure returns (string memory) {
        return string.concat("#", Utils.toString(tokenId));
    }

    function _saveNewSeed(uint256 tokenId, uint256 remaining) internal {
        if (remaining == 0) revert NoRemainingTokens();
        uint256 numShuffled = _tokenIdSeedShuffler.numShuffled();
        uint256 randomness = uint256(keccak256(abi.encodePacked(shufflerSeed, numShuffled)));
        uint256 newTokenIdSeed = _tokenIdSeedShuffler.next(randomness);

        globalTokenMetadata[tokenId] = TokenMetadata({
            tokenIdSeed: uint16(newTokenIdSeed),
            backgroundIndex: defaultBackgroundIndex,
            name: _getInitialName(tokenId),
            bio: "A RetroPunk living on-chain."
        });
    }

    function _addInternalMintMetadata(uint256 quantity) internal {
        if (!shufflerSeedRevealed) revert ShufflerSeedNotRevealedYet();
        uint256 currentMintCount = _totalMinted();
        for (uint256 i = 0; i < quantity; i++) {
            _saveNewSeed(currentMintCount + i + 1, _maxSupply - (currentMintCount + i));
        }
    }

    function _checkMaxSupply(uint256 quantity) internal view {
        if (_totalMinted() + quantity > maxSupply()) revert MintQuantityExceedsMaxSupply(_totalMinted() + quantity, maxSupply());
    }

    function _mint(address to, uint256 quantity) internal override {
        if (mintIsClosed) revert MintIsClosed();
        _checkMaxSupply(quantity);
        _addInternalMintMetadata(quantity);
        super._mint(to, quantity);
        if (_totalMinted() == maxSupply()) mintIsClosed = true;
    }

    function tokenURI(uint256 tokenId) public view override tokenExists(tokenId) returns (string memory) {
        TokenMetadata memory meta = globalTokenMetadata[tokenId];
        return renderDataUri(tokenId, meta.tokenIdSeed, meta.backgroundIndex, meta.name, meta.bio, globalSeed);
    }

    function renderDataUri(
        uint256 _tokenId,
        uint16 _tokenIdSeed,
        uint8 _backgroundIndex,
        string memory _name,
        string memory _bio,
        uint256 _globalSeed
    ) internal view returns (string memory) {
        string memory finalName;
        string memory finalBio;
        string memory attributes;
        string memory svg;

        if (!revealRendererSet) {
            // Pre-reveal: use placeholder values
            (svg,) = renderer.renderSVG(_tokenIdSeed, _backgroundIndex, _globalSeed);
            finalName = "Unrevealed Punk";
            finalBio = "Wait for the reveal...";
            attributes = '"attributes":[{"trait_type":"Status","value":"Unrevealed"}]';
        } else {
            // Post-reveal: use actual renderer output
            (svg, attributes) = renderer.renderSVG(_tokenIdSeed, _backgroundIndex, _globalSeed);

            if (_tokenIdSeed < NUM_SPECIAL_1S) {
                string memory defaultName = string.concat("#", Utils.toString(_tokenId));
                bool isDefaultName = keccak256(bytes(_name)) == keccak256(bytes(defaultName));

                if (isDefaultName) finalName = string.concat("1 of 1: ", SPECIAL_NAMES[_tokenIdSeed]);
                else finalName = _name;
            } else {
                string memory defaultName = string.concat("#", Utils.toString(_tokenId));
                bool isDefaultName = keccak256(bytes(_name)) == keccak256(bytes(defaultName));

                finalName = isDefaultName ? _name : string.concat(defaultName, ": ", _name);
            }

            finalBio = _bio;
        }

        string memory json = string.concat(
            '{"name":"',
            finalName,
            '","description":"',
            finalBio,
            '",',
            attributes,
            ',"image":"data:image/svg+xml;base64,',
            Utils.encodeBase64(bytes(svg)),
            '"}'
        );

        return string.concat("data:application/json;base64,", Utils.encodeBase64(bytes(json)));
    }
}
