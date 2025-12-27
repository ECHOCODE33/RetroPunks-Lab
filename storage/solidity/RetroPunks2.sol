// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { ISVGRenderer } from "./interfaces/ISVGRenderer.sol";
import { NUM_SPECIAL_1S, NUM_BACKGROUND, E_Special_1s, E_Background } from "./common/Enums.sol";
import { Utils } from "./libraries/Utils.sol";
import { FisherYatesShuffler } from "./interfaces/FisherYatesShuffler.sol";
import { ERC721SeaDropPausableAndQueryable } from "./seadrop/extensions/ERC721SeaDropPausableAndQueryable.sol";

/**
 * @author ECHO
 * @notice Optimized for gas efficiency (Storage packing) and runtime costs.
 */
contract RetroPunks is ERC721SeaDropPausableAndQueryable, FisherYatesShuffler {

    // --- Custom Errors with String Params ---
    // Using these is cheaper than require(cond, "string") regarding bytecode size,
    // and allows you to keep the descriptive strings you requested.
    error ValidationError(string reason);
    error Unauthorized(string reason);
    error MintError(string reason);
    error RevealError(string reason);

    // --- Events ---
    event GlobalSeedRevealed(uint256 seed);
    event ShufflerSeedRevealed(uint256 seed);
    event BackgroundChanged(uint256 indexed tokenId, uint256 indexed backgroundIndex, address indexed owner);
    event NameChanged(uint256 indexed tokenId, string indexed name, address indexed owner);

    // --- Storage Packing (Slot 0) ---
    // All variables below fit into a single 32-byte slot.
    ISVGRenderer public renderer;       // 160 bits
    uint16 public ownerMintsRemaining;  // 16 bits
    bool public mintIsClosed;           // 8 bits
    bool public globalSeedRevealed;     // 8 bits
    bool public shufflerSeedRevealed;   // 8 bits
    // 160 + 16 + 8 + 8 + 8 = 200 bits. (56 bits remaining in slot)

    // --- Seed Storage ---
    uint256 public globalSeed;
    uint256 public shufflerSeed;

    bytes32 public immutable COMMITTED_GLOBAL_SEED_HASH;
    bytes32 public immutable COMMITTED_SHUFFLER_SEED_HASH;

    // --- Optimized Metadata Storage ---
    // Mapping 1: Packs [Background Index (16 bits) | TokenIdSeed (16 bits)] into one uint256.
    mapping(uint256 => uint256) private _packedMetadata; 

    // Mapping 2: Only stores names if they are CUSTOM. Saves massive gas on mint.
    mapping(uint256 => string) private _customNames;

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
        ownerMintsRemaining = 10;
    }

    // --- Admin Functions ---

    function setRenderer(ISVGRenderer _renderer) external onlyOwner {
        renderer = _renderer;
        if (_totalMinted() != 0) {
            emit BatchMetadataUpdate(1, _totalMinted());
        }
    }

    function closeMint() external onlyOwner {
        mintIsClosed = true;
    }

    function revealGlobalSeed(uint256 _seed, uint256 _nonce) external onlyOwner {
        if (globalSeedRevealed) revert RevealError("Global seed already revealed");
        if (keccak256(abi.encodePacked(_seed, _nonce)) != COMMITTED_GLOBAL_SEED_HASH) revert RevealError("Invalid reveal hash");
        
        globalSeed = _seed;
        globalSeedRevealed = true;
        
        emit GlobalSeedRevealed(_seed);
        if (_totalMinted() != 0) {
            emit BatchMetadataUpdate(1, _totalMinted());
        }
    }

    function revealShufflerSeed(uint256 _seed, uint256 _nonce) external onlyOwner {
        if (shufflerSeedRevealed) revert RevealError("Shuffler seed already revealed");
        if (keccak256(abi.encodePacked(_seed, _nonce)) != COMMITTED_SHUFFLER_SEED_HASH) revert RevealError("Result does not match committed hash");
        
        shufflerSeed = _seed;
        shufflerSeedRevealed = true;
        
        emit ShufflerSeedRevealed(_seed);
    }

    function ownerMint(address toAddress, uint256 quantity) external onlyOwner nonReentrant {
        if (ownerMintsRemaining < quantity) revert MintError("Not enough owner mints remaining");
        
        unchecked { 
            ownerMintsRemaining -= uint16(quantity); 
        }

        _checkMaxSupply(quantity);
        _safeMint(toAddress, quantity);
    }

    // --- User Customization ---

    function setTokenBackground(uint256 tokenId, uint256 backgroundIndex) external onlyTokenOwner(tokenId) notSpecial(tokenId) {
        if (backgroundIndex >= NUM_BACKGROUND) {
            revert ValidationError(string.concat("Invalid background index, must be between 0 and ", Utils.toString(NUM_BACKGROUND - 1)));
        }

        // Bitwise logic: Keep the lower 16 bits (seed), replace the upper bits (background)
        uint256 currentPacked = _packedMetadata[tokenId];
        uint256 seedOnly = currentPacked & 0xFFFF; // Mask to keep only the last 16 bits
        
        // Store: [Background << 16] | [Seed]
        _packedMetadata[tokenId] = (backgroundIndex << 16) | seedOnly;
    
        emit BatchMetadataUpdate(tokenId, tokenId);
        emit BackgroundChanged(tokenId, backgroundIndex, msg.sender);
    }

    function setTokenName(uint256 tokenId, string calldata name) external onlyTokenOwner(tokenId) notSpecial(tokenId) {
        bytes memory b = bytes(name);
        uint256 len = b.length;
        
        if (len == 0 || len > 32) revert ValidationError("Name 1-32 chars");

        for (uint256 i = 0; i < len;) {
            bytes1 c = b[i];
            // Valid: 0-9, A-Z, a-z, and specific symbols
            if (
                !((c >= 0x30 && c <= 0x39) || 
                  (c >= 0x41 && c <= 0x5A) || 
                  (c >= 0x61 && c <= 0x7A) || 
                  c == 0x20 || c == 0x21 || c == 0x2D || c == 0x2E || 
                  c == 0x3F || c == 0x5F || c == 0x26 || c == 0x27)
            ) {
                revert ValidationError("Invalid character in name");
            }
            unchecked { ++i; }
        }

        _customNames[tokenId] = name;

        emit BatchMetadataUpdate(tokenId, tokenId);
        emit NameChanged(tokenId, name, msg.sender);
    }

    function resetTokenName(uint256 tokenId) external onlyTokenOwner(tokenId) notSpecial(tokenId) {
        delete _customNames[tokenId]; // Deleting storage refunds gas
        
        // Reconstruct default name for the event
        string memory defaultName = string.concat('RetroPunk #', Utils.toString(tokenId));

        emit BatchMetadataUpdate(tokenId, tokenId);
        emit NameChanged(tokenId, defaultName, msg.sender);
    }

    function getDefaultBackgroundIndex() public pure returns (uint16) {
        return uint16(uint(E_Background.Standard));
    }

    // --- View Functions ---

    function tokenURI(uint256 tokenId) public view override tokenExists(tokenId) returns (string memory) {
        // Unpack metadata
        uint256 packed = _packedMetadata[tokenId];
        uint16 tokenIdSeed = uint16(packed); // Cast takes lowest 16 bits
        uint16 backgroundIndex = uint16(packed >> 16); // Shift down 16 bits

        // Determine name: If custom name exists, use it. Otherwise, generate default.
        string memory name = _customNames[tokenId];
        if (bytes(name).length == 0) {
            name = string.concat('RetroPunk #', Utils.toString(tokenId));
        }

        return renderDataUri(tokenId, tokenIdSeed, backgroundIndex, name, globalSeed);
    }

    // --- Internal Logic ---

    function _mint(address to, uint256 quantity) internal override {
        if (mintIsClosed) revert MintError("Mint is permanently closed");
        
        _checkMaxSupply(quantity);
        _addInternalMintMetadata(quantity);
        super._mint(to, quantity);
        
        if (_totalMinted() == maxSupply()) {
            mintIsClosed = true;
        }
    }

    function _addInternalMintMetadata(uint256 quantity) internal {
        if (!shufflerSeedRevealed) revert MintError("Shuffler seed not revealed yet");
        
        uint256 currentTokenId = _totalMinted();
        uint256 max = maxSupply(); 

        for(uint256 i = 0; i < quantity;) {
            unchecked {
                // tokenId starts at 1, so we add 1 to currentTokenId index
                _saveNewSeed(currentTokenId + i + 1, max - (currentTokenId + i));
                ++i;
            }
        }
    }

    function _saveNewSeed(uint256 tokenId, uint256 remaining) internal {
        if (remaining == 0) revert MintError("No remaining elements");

        uint256 newTokenIdSeed = drawNextElement(shufflerSeed, msg.sender, remaining);
        
        // We do NOT write the Name to storage here. It is generated dynamically.
        // We only write the seed. Default Background is 0, so no shifting needed.
        _packedMetadata[tokenId] = newTokenIdSeed;
    }

    function _checkMaxSupply(uint256 quantity) internal view {
        if (_totalMinted() + quantity > maxSupply()) {
            revert MintQuantityExceedsMaxSupply(_totalMinted() + quantity, maxSupply());
        }    
    }

    // --- Rendering ---

    function renderDataUri(
        uint256 _tokenId, 
        uint16 _tokenIdSeed, 
        uint16 _backgroundIndex, 
        string memory _name, 
        uint256 _globalSeed
    ) internal view returns (string memory) {
        (string memory svg, string memory attributes) = renderer.renderSVG(_tokenIdSeed, _backgroundIndex, _globalSeed);
        string memory html = renderer.renderHTML(bytes(svg));

        // Display Name Logic: Check if current name matches default pattern to decide formatting
        string memory defaultNamePrefix = string.concat("RetroPunk #", Utils.toString(_tokenId));
        string memory displayName;
        
        if (keccak256(bytes(_name)) == keccak256(bytes(defaultNamePrefix))) {
            displayName = _name;
        } else {
            displayName = string.concat(defaultNamePrefix, ": ", _name);
        }

        string memory json = string.concat(
            '{"name":"', displayName,
            '","description":"RetroPunks NFT collection",',
            attributes,',',
            '"image":"data:image/svg+xml;base64,',
            Utils.encodeBase64(bytes(svg)),
            '"'
        );

        if (bytes(html).length > 0) {
            json = string.concat(json, ',"animation_url":"data:text/html;base64,', Utils.encodeBase64(bytes(html)), '"}');
        } else {
            json = string.concat(json, '}');
        }
        
        return string.concat(
            "data:application/json;base64,",
            Utils.encodeBase64(bytes(json))
        );
    }

    // --- Modifiers ---

    modifier tokenExists(uint256 _tokenId) {
        if (!_exists(_tokenId)) revert ValidationError("URI query for nonexistent token");
        _;
    }

    modifier onlyTokenOwner(uint256 _tokenId) {
        if (ownerOf(_tokenId) != msg.sender) revert Unauthorized("The caller is not the owner of the token");
        _;
    }

    modifier notSpecial(uint256 tokenId) {
        // Unpack just the seed (lower 16 bits)
        uint16 tokenIdSeed = uint16(_packedMetadata[tokenId]);
        
        if (tokenIdSeed < NUM_SPECIAL_1S) {
            // Check if this is a pre-rendered special
            if (
                tokenIdSeed == uint16(E_Special_1s.Predator_Blue) ||
                tokenIdSeed == uint16(E_Special_1s.Predator_Green) ||
                tokenIdSeed == uint16(E_Special_1s.Predator_Red) ||
                tokenIdSeed == uint16(E_Special_1s.Santa_Claus) ||
                tokenIdSeed == uint16(E_Special_1s.Shadow_Ninja) ||
                tokenIdSeed == uint16(E_Special_1s.The_Devil) ||
                tokenIdSeed == uint16(E_Special_1s.The_Portrait)
            ) {
                revert ValidationError("Pre-rendered specials cannot be customized");
            }
        }
        _;
    }
}