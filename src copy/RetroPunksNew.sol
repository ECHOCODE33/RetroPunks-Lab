// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { ISVGRenderer } from "./interfaces/ISVGRenderer.sol";
import { NUM_SPECIAL_1S, NUM_BACKGROUND, E_Background } from "./common/Enums.sol";
import { LibPRNG } from "./libraries/LibPRNG.sol";
import { Utils } from "./libraries/Utils.sol";
import { ERC721SeaDropPausable } from "./seadrop/extensions/ERC721SeaDropPausable.sol";

/**
 * @author ECHO
 * @notice Optimized for gas efficiency and readability.
 */

// NEW: Renamed struct and removed the 'string name' property. 
// This allows the struct to fit perfectly into 1 storage slot (32 bytes), 
// saving ~20k gas per mint by avoiding SSTORE operations for strings.
struct TokenData {
    uint16 tokenIdSeed;
    uint8 backgroundIndex;
}

contract RetroPunks is ERC721SeaDropPausable {
    // NEW: Added 'using' statement to allow calling library functions directly on the struct (cleaner syntax).
    using LibPRNG for LibPRNG.LazyShuffler;

    ISVGRenderer public renderer;

    bytes32 public immutable COMMITTED_GLOBAL_SEED_HASH;
    bytes32 public immutable COMMITTED_SHUFFLER_SEED_HASH;

    uint16 public ownerMintsRemaining = 10;
    uint256 public globalSeed;
    uint256 public shufflerSeed;

    bool public mintIsClosed = false;
    bool public globalSeedRevealed = false;
    bool public shufflerSeedRevealed = false;

    // NEW: Replaced the public 'globalTokenMetadata' mapping with a private one using the packed struct.
    // This saves storage space. We expose a getter function with the old name later for compatibility.
    mapping(uint256 => TokenData) private _tokenData;

    // NEW: Added a separate mapping just for custom names.
    // Since 99% of tokens use the default name, we shouldn't pay gas to store names for everyone.
    mapping(uint256 => string) private _customNames;

    // NEW: Removed 'string[7] SPECIAL_NAMES'. Storing fixed data in a state array costs gas to deploy and read.
    // Replaced with a 'pure' function `_getSpecialName` below.

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

    modifier tokenExists(uint256 _tokenId) {
        if (!_exists(_tokenId)) revert NonExistentToken();
        _;
    }

    modifier onlyTokenOwner(uint256 _tokenId) {
        if (ownerOf(_tokenId) != msg.sender) revert CallerIsNotTokenOwner();
        _;
    }

    modifier notSpecial(uint256 tokenId) {
        // NEW: Updated to read from the new private `_tokenData` mapping.
        uint16 tokenIdSeed = _tokenData[tokenId].tokenIdSeed;
        
        if (tokenIdSeed < NUM_SPECIAL_1S) {
            // Special IDs 0-6 are pre-rendered and cannot be customized
            if (tokenIdSeed < 7) revert PreRenderedSpecialCustomization();
        }
        _;
    }

    constructor(
        ISVGRenderer _rendererParam, 
        bytes32 _committedGlobalSeedHashParam, 
        bytes32 _committedShufflerSeedHashParam, 
        uint256 _maxSupplyParam, 
        address[] memory allowedSeaDropParam
    ) ERC721SeaDropPausable("RetroPunks", "RPNKS", allowedSeaDropParam) {
        COMMITTED_GLOBAL_SEED_HASH = _committedGlobalSeedHashParam;
        COMMITTED_SHUFFLER_SEED_HASH = _committedShufflerSeedHashParam;
        renderer = _rendererParam;
        _maxSupply = _maxSupplyParam;
    }

    // ----- Admin Functions ----- //

    function setRenderer(ISVGRenderer _renderer) external onlyOwner {
        renderer = _renderer;
        if (totalSupply() != 0) {
            emit BatchMetadataUpdate(1, _nextTokenId() - 1);
        }
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
        if (totalSupply() != 0) {
            emit BatchMetadataUpdate(1, _nextTokenId() - 1);
        }
    }

    function revealShufflerSeed(uint256 _seed, uint256 _nonce) external onlyOwner {
        if (shufflerSeedRevealed) revert ShufflerSeedAlreadyRevealed();
        if (keccak256(abi.encodePacked(_seed, _nonce)) != COMMITTED_SHUFFLER_SEED_HASH) revert InvalidShufflerSeedReveal();
        
        shufflerSeed = _seed;
        shufflerSeedRevealed = true;
        
        // NEW: Updated syntax using the library directly on the variable.
        _tokenIdSeedShuffler.initialize(_maxSupply);
        
        emit ShufflerSeedRevealed(_seed);
    }

    function ownerMint(address toAddress, uint256 quantity) external onlyOwner nonReentrant {
        if (ownerMintsRemaining < quantity) revert NotEnoughOwnerMintsRemaining();

        // NEW: Added unchecked block. Since we check `ownerMintsRemaining < quantity` just above,
        // this subtraction cannot underflow. This saves gas on checks.
        unchecked {
            ownerMintsRemaining -= uint16(quantity);
        }

        _checkMaxSupply(quantity);
        _safeMint(toAddress, quantity);
    }

    // ----- Token Customization ----- //

    function setTokenBackground(uint256 tokenId, uint256 backgroundIndex) external onlyTokenOwner(tokenId) notSpecial(tokenId) {
        if (backgroundIndex >= NUM_BACKGROUND) revert InvalidBackgroundIndex();

        // NEW: Updated to write to `_tokenData`.
        _tokenData[tokenId].backgroundIndex = uint8(backgroundIndex);
    
        emit BatchMetadataUpdate(tokenId, tokenId);
        emit BackgroundChanged(tokenId, backgroundIndex, msg.sender);
    }

    function setTokenName(uint256 tokenId, string memory name) external onlyTokenOwner(tokenId) notSpecial(tokenId) {
        bytes memory b = bytes(name);
        
        // NEW: Cache length to stack variable to save gas in loop comparisons.
        uint256 length = b.length;

        if(length == 0 || length > 32) {
            revert NameIsTooLong();
        }

        for (uint256 i = 0; i < length;) {
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

            // NEW: Added unchecked increment. 'i' cannot overflow in this loop context.
            unchecked { ++i; }
        }

        // NEW: Added logic to delete storage if user sets name to default.
        // If the user resets the name manually, we delete the entry in _customNames to refund gas
        // and keep storage clean.
        string memory defaultName = string.concat("RetroPunk #", Utils.toString(tokenId));
        if (keccak256(b) == keccak256(bytes(defaultName))) {
            delete _customNames[tokenId];
        } else {
            _customNames[tokenId] = name;
        }

        emit BatchMetadataUpdate(tokenId, tokenId);
        emit NameChanged(tokenId, name, msg.sender);
    }

    function resetTokenName(uint256 tokenId) external onlyTokenOwner(tokenId) notSpecial(tokenId) {
        // NEW: Simply delete the entry from the custom mapping.
        delete _customNames[tokenId];

        string memory defaultName = string.concat("RetroPunk #", Utils.toString(tokenId));
        
        emit BatchMetadataUpdate(tokenId, tokenId);
        emit NameChanged(tokenId, defaultName, msg.sender);
    }

    // ----- Public Views (Read Compatibility) ----- //

    /**
     * @notice Maintains API compatibility with original struct mapping.
     */
    // NEW: This used to be a mapping. It is now a view function.
    // External tools reading 'globalTokenMetadata(id)' will still work exactly the same,
    // but internally we construct the result on-the-fly to save storage gas.
    function globalTokenMetadata(uint256 tokenId) external view returns (uint16 tokenIdSeed, uint8 backgroundIndex, string memory name) {
        TokenData storage data = _tokenData[tokenId];
        tokenIdSeed = data.tokenIdSeed;
        backgroundIndex = data.backgroundIndex;
        // NEW: Generate the name dynamically instead of reading from storage.
        name = _getTokenName(tokenId, tokenIdSeed);
    }

    function tokenURI(uint256 tokenId) public tokenExists(tokenId) view override returns (string memory) {
        TokenData memory data = _tokenData[tokenId];
        // NEW: Generate name dynamically.
        string memory name = _getTokenName(tokenId, data.tokenIdSeed);
        return _renderDataUri(data.tokenIdSeed, data.backgroundIndex, name, globalSeed);
    }

    // ----- Internal Functions ----- //

    /**
     * @dev Replaces the storage array SPECIAL_NAMES.
     */
    // NEW: Helper function to retrieve special names. 
    // This uses bytecode (cheap) instead of SLOAD (expensive).
    function _getSpecialName(uint256 index) internal pure returns (string memory) {
        if (index == 0) return "Predator Blue";
        if (index == 1) return "Predator Green";
        if (index == 2) return "Predator Red";
        if (index == 3) return "Santa Claus";
        if (index == 4) return "Shadow Ninja";
        if (index == 5) return "The Devil";
        if (index == 6) return "The Portrait";
        return "";
    }

    /**
     * @dev Central logic for resolving the token name.
     */
    // NEW: Centralized function to determine the name.
    // It checks if it's special, if it has a custom name, or defaults to "RetroPunk #ID".
    function _getTokenName(uint256 tokenId, uint16 tokenIdSeed) internal view returns (string memory) {
        string memory defaultPrefix = string.concat("RetroPunk #", Utils.toString(tokenId));

        // 1. Handle Specials (Hardcoded)
        if (tokenIdSeed < 7) {
            return string.concat(defaultPrefix, ": ", _getSpecialName(tokenIdSeed));
        }

        // 2. Handle Custom Names (Read from storage)
        string memory customName = _customNames[tokenId];
        if (bytes(customName).length > 0) {
            return string.concat(defaultPrefix, ": ", customName);
        }

        // 3. Default
        return defaultPrefix;
    }

    function _saveNewSeed(uint256 tokenId) internal {
        // Deterministic randomness for shuffling
        uint256 numShuffled = _tokenIdSeedShuffler.numShuffled();
        uint256 randomness = uint256(keccak256(abi.encodePacked(shufflerSeed, numShuffled, tokenId)));
        
        uint256 newTokenIdSeed = _tokenIdSeedShuffler.next(randomness);
        
        // NEW: Only writing the packed struct (Seed + Background).
        // We are NOT generating or storing the string name here anymore.
        // This is the primary gas saver of the contract.
        _tokenData[tokenId] = TokenData({
            tokenIdSeed: uint16(newTokenIdSeed),
            backgroundIndex: defaultBackgroundIndex
        });
    }

    function _addInternalMintMetadata(uint256 quantity) internal {
        if (!shufflerSeedRevealed) revert ShufflerSeedNotRevealedYet();
        
        uint256 startId = _totalMinted() + 1;
        uint256 endId = startId + quantity;

        // NEW: Added 'unchecked' loop increment to save gas on minting loops.
        for (uint256 id = startId; id < endId;) {
            _saveNewSeed(id);
            unchecked { ++id; }
        }
    }

    function _checkMaxSupply(uint256 quantity) internal view {
        if (_totalMinted() + quantity > maxSupply()) {
            revert MintQuantityExceedsMaxSupply(_totalMinted() + quantity, maxSupply());
        }    
    }

    function _mint(address to, uint256 quantity) internal override {
        if (mintIsClosed) revert MintIsClosed();
        
        _checkMaxSupply(quantity);
        _addInternalMintMetadata(quantity);
        super._mint(to, quantity);
        
        if (_totalMinted() == maxSupply()) {
            mintIsClosed = true;
        }
    }

    function _renderDataUri(uint16 _tokenIdSeed, uint8 _backgroundIndex, string memory _name, uint256 _globalSeed) internal view returns (string memory) {
        (string memory svg, string memory attributes) = renderer.renderSVG(_tokenIdSeed, _backgroundIndex, _globalSeed);

        // NEW: Removed name concatenation logic that was here.
        // The name is now fully resolved and passed in as `_name` via `_getTokenName` before calling this.
        
        string memory json = string.concat(
            '{"name":"', _name,
            '","description":"RetroPunks NFT collection",',
            attributes,',',
            '"image":"data:image/svg+xml;base64,',
            Utils.encodeBase64(bytes(svg)),
            '"}'
        );

        return string.concat(
            "data:application/json;base64,",
            Utils.encodeBase64(bytes(json))
        );
    }
}