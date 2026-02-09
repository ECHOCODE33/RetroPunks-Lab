// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { NUM_BACKGROUND, NUM_PRE_RENDERED_SPECIALS, NUM_SPECIAL_1S, SPECIAL_NAMES } from "./common/Enums.sol";
import { IMetaGen } from "./interfaces/IMetaGen.sol";
import { IRetroPunks } from "./interfaces/IRetroPunks.sol";
import { LibPRNG } from "./libraries/LibPRNG.sol";
import { Utils } from "./libraries/Utils.sol";
import { ERC721SeaDropPausableAndQueryable } from "./seadrop/extensions/ERC721SeaDropPausableAndQueryable.sol";

/**
 * @title RetroPunks
 * @author ECHO (echomatrix.eth)
 * @notice The main contract for the RetroPunks collection
 * @dev Uses ERC721SeaDropPausableAndQueryable for pausable and queryable functionality.
 *      Uses IMetaGen for metadata generation.
 *      Uses LibPRNG for random number generation.
 *      Uses Utils for utility functions.
 */
contract RetroPunks is IRetroPunks, ERC721SeaDropPausableAndQueryable {
    using LibPRNG for LibPRNG.LazyShuffler;

    IMetaGen public metaGen;

    mapping(uint256 => TokenMetadata) public globalTokenMetadata;

    bytes32 public immutable COMMITTED_GLOBAL_SEED_HASH;
    bytes32 public immutable COMMITTED_SHUFFLER_SEED_HASH;
    uint256 public globalSeed;
    uint256 public shufflerSeed;

    uint8 public mintIsClosed = 0;

    uint8 internal revealMetaGenSet = 0;

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
     * @param _metaGenParam The IMetaGen (metadata generator) contract address.
     * @param _committedGlobalSeedHashParam The committed global seed hash.
     * @param _committedShufflerSeedHashParam The committed shuffler seed hash.
     * @param _maxSupplyParam The maximum supply of the collection.
     * @param allowedSeaDropParam The allowed SeaDrop contract addresses.
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

    function _saveNewSeed(uint256 tokenId, uint256 remaining) internal {
        if (remaining == 0) revert NoRemainingTokens();

        uint256 numShuffled = _tokenIdSeedShuffler.numShuffled();
        uint256 randomness = uint256(keccak256(abi.encodePacked(shufflerSeed, numShuffled)));
        uint256 newTokenIdSeed = _tokenIdSeedShuffler.next(randomness);

        globalTokenMetadata[tokenId] = TokenMetadata({
            tokenIdSeed: uint16(newTokenIdSeed), backgroundIndex: 0, name: bytes32(abi.encodePacked("#", Utils.toString(tokenId))), bio: "A RetroPunk living on-chain."
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
