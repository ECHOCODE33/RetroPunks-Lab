// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { ISVGRenderer } from "./interfaces/ISVGRenderer.sol";
import { NUM_SPECIAL_1S, NUM_BACKGROUND, E_Special_1s, E_Background } from "./common/Enums.sol";
import { Utils } from "./libraries/Utils.sol";
import { FisherYatesShuffler } from "./interfaces/FisherYatesShuffler.sol";
import { ERC721SeaDropPausableAndQueryable } from "./seadrop/extensions/ERC721SeaDropPausableAndQueryable.sol";

/**
 * @author ECHO
 */

struct TokenMetadata {
    uint16 tokenIdSeed;
    uint8 backgroundIndex;
    string name;
}

contract RetroPunks is ERC721SeaDropPausableAndQueryable, FisherYatesShuffler {

    ISVGRenderer public renderer;

    bool public mintIsClosed = false;

    bytes32 public immutable COMMITTED_GLOBAL_SEED_HASH;
    bytes32 public immutable COMMITTED_SHUFFLER_SEED_HASH;

    bool public globalSeedRevealed = false;
    bool public shufflerSeedRevealed = false;
    
    uint public globalSeed;
    uint public shufflerSeed;

    // tokenId -> TokenMetadata
    mapping(uint => TokenMetadata) public globalTokenMetadata; 

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
    error NoRemainingTokenElements();
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

                bool isPreRendered = (
                    specialIdx == uint(E_Special_1s.Predator_Blue) ||
                    specialIdx == uint(E_Special_1s.Predator_Green) ||
                    specialIdx == uint(E_Special_1s.Predator_Red) ||
                    specialIdx == uint(E_Special_1s.Santa_Claus) ||
                    specialIdx == uint(E_Special_1s.Shadow_Ninja) ||
                    specialIdx == uint(E_Special_1s.The_Devil) ||
                    specialIdx == uint(E_Special_1s.The_Portrait)
                );
                
                if (isPreRendered) {
                    revert PreRenderedSpecialCustomization();
                }
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
        
        emit ShufflerSeedRevealed(_seed);
    }

    uint public ownerMintsRemaining = 10;

    function ownerMint(address toAddress, uint256 quantity) external onlyOwner nonReentrant {
        if (!(ownerMintsRemaining >= quantity)) revert NotEnoughOwnerMintsRemaining();

        ownerMintsRemaining -= quantity;

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

    function _saveNewSeed(uint tokenId, uint remaining) internal {
        if (remaining == 0) revert NoRemainingTokenElements();

        uint newTokenIdSeed = drawNextElement(shufflerSeed, msg.sender, remaining);
        
        globalTokenMetadata[tokenId] = TokenMetadata({
            tokenIdSeed: uint16(newTokenIdSeed),
            backgroundIndex: defaultBackgroundIndex,
            name: string.concat('RetroPunk #', string(Utils.toString(tokenId)))
        });
    }

    function _getTokenMetadata(uint256 tokenId) internal view returns (TokenMetadata memory) {
        return globalTokenMetadata[tokenId];
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

    // override ERC721a mint to add metadata on every mint
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
        TokenMetadata memory tokenMetadata = _getTokenMetadata(tokenId);
        return renderDataUri(tokenId, tokenMetadata.tokenIdSeed, tokenMetadata.backgroundIndex, tokenMetadata.name, globalSeed);
    }

    /**
     * @notice Renders an NFT token as a complete data URI containing JSON metadata
     * @dev This function generates the complete metadata for an NFT including an SVG image & 
     *      attributes. The result is returned as a base64-encoded
     *      data URI that can be directly used as a token URI.
     * 
     * @param _tokenId The unique identifier of the NFT token as seen in the marketplace. Determined by the order of minting.
     * @param _tokenIdSeed The deterministic seed used to generate this token's traits, assigned at random at mint time.
     * @param _backgroundIndex The index of the background to use (0 to NUM_BACKGROUND-1)
     * @param _name The name of the NFT character
     * @param _globalSeed The global seed used for trait generation randomness / consistency
     * 
     * @return A base64-encoded data URI containing the complete JSON metadata with:
     *         - name: Token name with ID
     *         - description: Collection description
     *         - attributes: Trait attributes from the renderer
     *         - image: Base64-encoded SVG image
     *         - animation_url: Base64-encoded HTML animation (if available)
     */
    function renderDataUri(uint256 _tokenId, uint16 _tokenIdSeed, uint8 _backgroundIndex, string memory _name, uint256 _globalSeed) internal view returns (string memory) {
        string memory svg;
        string memory attributes;

        (svg, attributes) = renderer.renderSVG(_tokenIdSeed, _backgroundIndex, _globalSeed);

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