// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { ISVGRenderer } from "./interfaces/ISVGRenderer.sol";
import { NUM_SPECIAL_1S, NUM_BACKGROUND, E_Background } from "./common/Enums.sol";
import { LibPRNG } from "./libraries/LibPRNG.sol";
import { Utils } from "./libraries/Utils.sol";
import { ERC721SeaDropPausableAndQueryable } from "./seadrop/extensions/ERC721SeaDropPausableAndQueryable.sol";

/**
 * @author ECHO
 */
 
struct TokenMetadata {
    uint16 tokenIdSeed;
    uint8 backgroundIndex;
    string name;
}

contract RetroPunks is ERC721SeaDropPausableAndQueryable {

    ISVGRenderer public renderer;

    bytes32 public immutable COMMITTED_GLOBAL_SEED_HASH;
    bytes32 public immutable COMMITTED_SHUFFLER_SEED_HASH;

    uint16 public ownerMintsRemaining = 10;
    uint public globalSeed;
    uint public shufflerSeed;

    bool public mintIsClosed = false;
    bool public globalSeedRevealed = false;
    bool public shufflerSeedRevealed = false;

    string[7] private SPECIAL_NAMES = [
        "Predator Blue",
        "Predator Green",
        "Predator Red",
        "Santa Claus",
        "Shadow Ninja",
        "The Devil",
        "The Portrait"
    ];

    // tokenId -> TokenMetadata
    mapping(uint => TokenMetadata) public globalTokenMetadata;


    // LazyShuffler for token ID seed selection
    LibPRNG.LazyShuffler private _tokenIdSeedShuffler; 

    uint8 constant public defaultBackgroundIndex = uint8(uint(E_Background.Standard));


    // ----- Events ----- //

    event GlobalSeedRevealed(uint256 seed);
    event ShufflerSeedRevealed(uint256 seed);
    event BackgroundChanged(uint256 indexed tokenId, uint256 indexed backgroundIndex, address indexed owner);
    event NameChanged(uint256 indexed tokenId, string indexed name, address indexed owner);


    // ----- Errors ----- //

    error MintIsClosed();
    error PreRenderedSpecialCustomization();
    error NameIsTooLong();
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


    // ----- Modifiers ----- //

    modifier tokenExists(uint _tokenId) {
        if (!_exists(_tokenId)) revert NonExistentToken();
        _;
    }

    modifier onlyTokenOwner(uint _tokenId) {
        if (ownerOf(_tokenId) != msg.sender) revert CallerIsNotTokenOwner();
        _;
    }

    modifier notSpecial(uint256 tokenId) {
        uint16 tokenIdSeed = globalTokenMetadata[tokenId].tokenIdSeed;
        
            if (tokenIdSeed < NUM_SPECIAL_1S) {
                uint specialIdx = tokenIdSeed;

                bool isPreRendered = (specialIdx < 7);
                
                if (isPreRendered) revert PreRenderedSpecialCustomization();
            }
            _;
    }

    constructor(ISVGRenderer _rendererParam, bytes32 _committedGlobalSeedHashParam, bytes32 _committedShufflerSeedHashParam, uint _maxSupplyParam, address[] memory allowedSeaDropParam) ERC721SeaDropPausableAndQueryable("RetroPunks", "RPNKS", allowedSeaDropParam) {
        COMMITTED_GLOBAL_SEED_HASH = _committedGlobalSeedHashParam;
        COMMITTED_SHUFFLER_SEED_HASH = _committedShufflerSeedHashParam;
        renderer = _rendererParam;
        _maxSupply = _maxSupplyParam;
    }


    // ----- Admin Functions ----- //

    function setRenderer(ISVGRenderer _renderer) external onlyOwner {
        renderer = _renderer;

        // Emit an event with the update.
        if (totalSupply() != 0) {
            emit BatchMetadataUpdate(1, _nextTokenId() - 1);
        }
    }

    function closeMint() external onlyOwner {
        mintIsClosed = true;
    }

    // Reveal globalSeed (after mint closes)
    function revealGlobalSeed(uint256 _seed, uint256 _nonce) external onlyOwner {
        if (globalSeedRevealed) revert GlobalSeedAlreadyRevealed();

        if (keccak256(abi.encodePacked(_seed, _nonce)) != COMMITTED_GLOBAL_SEED_HASH) revert InvalidGlobalSeedReveal();
        
        globalSeed = _seed;
        globalSeedRevealed = true;
        
        emit GlobalSeedRevealed(_seed);
        if (totalSupply() != 0) {
            emit BatchMetadataUpdate(1, _nextTokenId() - 1);  // Refresh metadata if needed
        }
    }

    // Reveal shufflerSeed (before mint starts)
    function revealShufflerSeed(uint256 _seed, uint256 _nonce) external onlyOwner {
        if (shufflerSeedRevealed) revert ShufflerSeedAlreadyRevealed();

        if (keccak256(abi.encodePacked(_seed, _nonce)) != COMMITTED_SHUFFLER_SEED_HASH) revert InvalidShufflerSeedReveal();
        
        shufflerSeed = _seed;
        shufflerSeedRevealed = true;
        
        // Initialize the LazyShuffler with max supply
        LibPRNG.initialize(_tokenIdSeedShuffler, _maxSupply);
        
        emit ShufflerSeedRevealed(_seed);
    }

    function ownerMint(address toAddress, uint256 quantity) external onlyOwner nonReentrant {
        if (!(ownerMintsRemaining >= quantity)) revert NotEnoughOwnerMintsRemaining();

        ownerMintsRemaining -= uint16(quantity);

        _checkMaxSupply(quantity);
        _safeMint(toAddress, quantity);
    }


    // ----- Token Custumization ----- //

    function setTokenBackground(uint tokenId, uint backgroundIndex) external onlyTokenOwner(tokenId) notSpecial(tokenId) {
        if (backgroundIndex >= NUM_BACKGROUND) revert InvalidBackgroundIndex();

        globalTokenMetadata[tokenId].backgroundIndex = uint8(backgroundIndex);
    
        emit BatchMetadataUpdate(tokenId, tokenId);
        emit BackgroundChanged(tokenId, backgroundIndex, msg.sender);
    }

    function setTokenName(uint tokenId, string memory name) external onlyTokenOwner(tokenId) notSpecial(tokenId) {
        bytes memory b = bytes(name);

        if(!(b.length > 0 && b.length <= 32)) {
            revert NameIsTooLong();
        }

        for (uint i = 0; i < b.length; ) {
            bytes1 c = b[i];

            if (!(  (c >= 0x30 && c <= 0x39) || // 0-9
                    (c >= 0x41 && c <= 0x5A) || // A-Z
                    (c >= 0x61 && c <= 0x7A) || // a-z
                    (c == 0x20 || c == 0x21 || c == 0x2D || c == 0x2E) || 
                    (c == 0x3F || c == 0x5F || c == 0x26 || c == 0x27)
                )
            ) {
                revert InvalidCharacterInName();
            }

            unchecked { ++i; }
        }

        globalTokenMetadata[tokenId].name = name;

        emit BatchMetadataUpdate(tokenId, tokenId);
        emit NameChanged(tokenId, name, msg.sender);
    }

    function resetTokenName(uint256 tokenId) external onlyTokenOwner(tokenId) notSpecial(tokenId) {
        string memory defaultName = string.concat('RetroPunk #', Utils.toString(tokenId));
        globalTokenMetadata[tokenId].name = defaultName;

        emit BatchMetadataUpdate(tokenId, tokenId);
        emit NameChanged(tokenId, defaultName, msg.sender);
    }


    // ----- Public & Internal Functions ----- //

    function _getInitialName(uint256 tokenId, uint16 tokenIdSeed) internal view returns (string memory) {

        if (tokenIdSeed < NUM_SPECIAL_1S) {
            return string.concat(
                "RetroPunk #", 
                Utils.toString(tokenId), 
                ": ", 
                SPECIAL_NAMES[tokenIdSeed]
            );
        }
        
        return string.concat("RetroPunk #", Utils.toString(tokenId));
    }

    function _saveNewSeed(uint tokenId, uint remaining) internal {
        if (remaining == 0) revert NoRemainingTokens();

        // Use LazyShuffler to get the next shuffled element
        // Generate deterministic randomness from shufflerSeed and number of elements already shuffled
        uint256 numShuffled = LibPRNG.numShuffled(_tokenIdSeedShuffler);
        uint256 randomness = uint256(keccak256(abi.encodePacked(shufflerSeed, numShuffled, tokenId)));
        
        uint newTokenIdSeed = LibPRNG.next(_tokenIdSeedShuffler, randomness);
        
        // UPDATED: Use helper to set name based on Special status
        globalTokenMetadata[tokenId] = TokenMetadata({
            tokenIdSeed: uint16(newTokenIdSeed),
            backgroundIndex: defaultBackgroundIndex,
            name: _getInitialName(tokenId, uint16(newTokenIdSeed))
        });
    }

    function _addInternalMintMetadata(uint256 quantity) internal {
        if (!shufflerSeedRevealed) revert ShufflerSeedNotRevealedYet();
        
        uint256 currentTokenId = totalSupply();

        for(uint256 tokenId = currentTokenId; tokenId < currentTokenId + quantity; tokenId++) {
            _saveNewSeed(tokenId + 1, _maxSupply - tokenId); // plus 1 because tokenIds start at 1
        }
    }

    function _checkMaxSupply(uint256 quantity) internal view {
        // Extra safety check to ensure the max supply is not exceeded.
        if (_totalMinted() + quantity > maxSupply()) {
            revert MintQuantityExceedsMaxSupply(
                _totalMinted() + quantity,
                maxSupply()
            );
        }    
    }

    function _mint(address to, uint256 quantity) internal override {
        if (mintIsClosed) {
            revert MintIsClosed();
        }
        
        _checkMaxSupply(quantity);
        _addInternalMintMetadata(quantity);
        super._mint(to, quantity);
        
        // Automatically close mint when max supply reached
        if (_totalMinted() == maxSupply()) {
            mintIsClosed = true;
        }
    }

    function tokenURI(uint256 tokenId) public tokenExists(tokenId) view override returns (string memory) {
        TokenMetadata memory tokenMetadata = globalTokenMetadata[tokenId];
        return renderDataUri(tokenId, tokenMetadata.tokenIdSeed, tokenMetadata.backgroundIndex, tokenMetadata.name, globalSeed);
    }

    function renderDataUri(uint256 _tokenId, uint16 _tokenIdSeed, uint8 _backgroundIndex, string memory _name, uint256 _globalSeed) internal view returns (string memory) {
        string memory svg;
        string memory attributes;

        (svg, attributes) = renderer.renderSVG(_tokenIdSeed, _backgroundIndex, _globalSeed);

        // NOTE: This logic below automatically handles the prefix.
        // If _name is "The Devil" (and default is "RetroPunk #1"), 
        // it returns: "RetroPunk #1: The Devil".
        string memory displayName = keccak256(bytes(_name)) == keccak256(bytes(string.concat("RetroPunk #", Utils.toString(_tokenId))))
            ? _name
            : string.concat("RetroPunk #", Utils.toString(_tokenId), ": ", _name);

        string memory json = string.concat(
            '{"name":"', displayName,
            '","description":"RetroPunks NFT collection",',
            attributes,',',
            '"image":"data:image/svg+xml;base64,',
            Utils.encodeBase64(bytes(svg)),
            '"');
        
        json = string.concat(json, '}');

        return string.concat(
            "data:application/json;base64,",
            Utils.encodeBase64(bytes(json))
        );
    }
}