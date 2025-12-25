// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { ISVGRenderer } from "./interfaces/ISVGRenderer.sol";
import { NUM_BACKGROUND, NUM_SPECIAL_1S, E_Background } from "./common/Enums.sol";
import { Utils } from "./libraries/Utils.sol";
import { FisherYatesShuffler } from "./interfaces/FisherYatesShuffler.sol";
import { ERC721SeaDropPausableAndQueryable } from "./seadrop/extensions/ERC721SeaDropPausableAndQueryable.sol";

/// @author ECHO

struct TokenMetadata {
    uint16 tokenIdSeed;
    uint16 backgroundIndex;
    string name;
}

event GlobalSeedRevealed(uint256 seed);
event ShufflerSeedRevealed(uint256 seed);
event BackgroundChanged(uint256 indexed tokenId, uint256 indexed backgroundIndex, address indexed owner);
event NameChanged(uint256 indexed tokenId, string indexed name, address indexed owner);

contract RetroPunks is ERC721SeaDropPausableAndQueryable, FisherYatesShuffler {
    uint public globalSeed;
    uint public shufflerSeed;

    ISVGRenderer public renderer;

    bool public mintIsClosed = false;

    // tokenId -> TokenMetadata
    mapping(uint => TokenMetadata) public globalTokenMetadata; 

    bytes32 public committedGlobalSeedHash;
    bytes32 public committedShufflerSeedHash;
    bool public globalSeedRevealed = false;
    bool public shufflerSeedRevealed = false;

    constructor(
        ISVGRenderer _rendererParam,
        bytes32 _committedGlobalSeedHashParam,
        bytes32 _committedShufflerSeedHashParam,
        uint _maxSupplyParam,
        address[] memory allowedSeaDropParam
    ) ERC721SeaDropPausableAndQueryable("RetroPunks", "RPNKS", allowedSeaDropParam) {
        committedGlobalSeedHash = _committedGlobalSeedHashParam;
        committedShufflerSeedHash = _committedShufflerSeedHashParam;
        renderer = _rendererParam;
        _maxSupply = _maxSupplyParam;
    }

    function setRenderer(ISVGRenderer _renderer) public onlyOwner {
        renderer = _renderer;

        // Emit an event with the update.
        if (totalSupply() != 0) {
            emit BatchMetadataUpdate(1, _nextTokenId() - 1);
        }
    }

    function setBackground(uint tokenId, uint backgroundIndex) public onlyTokenOwner(tokenId) notSpecial(tokenId) {
        require(
            backgroundIndex < NUM_BACKGROUND, 
            string.concat("Invalid background index, must be between 0 and ", Utils.toString(NUM_BACKGROUND - 1))
        );

        globalTokenMetadata[tokenId].backgroundIndex = uint16(backgroundIndex);
    
        emit BatchMetadataUpdate(tokenId, tokenId);
        emit BackgroundChanged(tokenId, backgroundIndex, msg.sender);
    }

    function setName(uint tokenId, string memory name) public onlyTokenOwner(tokenId) notSpecial(tokenId) {
        bytes memory b = bytes(name);
        require(b.length > 0 && b.length <= 32, "Name 1-32 chars");

        for (uint i = 0; i < b.length; ) {
            bytes1 c = b[i];
            require(
                (c >= 0x30 && c <= 0x39) || // 0-9
                (c >= 0x41 && c <= 0x5A) || // A-Z
                (c >= 0x61 && c <= 0x7A) || // a-z
                c == 0x20 || c == 0x21 || c == 0x2D || c == 0x2E || 
                c == 0x3F || c == 0x5F || c == 0x26 || c == 0x27,
                "Invalid character in name"
            );
            unchecked { ++i; }
        }

        globalTokenMetadata[tokenId].name = name;

        emit BatchMetadataUpdate(tokenId, tokenId);
        emit NameChanged(tokenId, name, msg.sender);
    }

    function resetName(uint256 tokenId) public onlyTokenOwner(tokenId) notSpecial(tokenId) {
        string memory defaultName = string.concat('RetroPunk #', Utils.toString(tokenId));
        globalTokenMetadata[tokenId].name = defaultName;

        emit BatchMetadataUpdate(tokenId, tokenId);
        emit NameChanged(tokenId, defaultName, msg.sender);
    }

    function getDefaultBackgroundIndex() public pure returns (uint16) {
        return uint16(uint(E_Background.Sky_Blue));
    }

    // Reveal globalSeed (call after mint closes)
    function revealGlobalSeed(uint256 _seed, uint256 _nonce) external onlyOwner {
        require(!globalSeedRevealed, "Global seed already revealed");
        require(keccak256(abi.encodePacked(_seed, _nonce)) == committedGlobalSeedHash, "Invalid reveal");
        
        globalSeed = _seed;
        globalSeedRevealed = true;
        
        emit GlobalSeedRevealed(_seed);
        if (totalSupply() != 0) {
            emit BatchMetadataUpdate(1, _nextTokenId() - 1);  // Refresh metadata if needed
        }
    }

    // Reveal shufflerSeed (call before mint starts)
    function revealShufflerSeed(uint256 _seed, uint256 _nonce) external onlyOwner {
        require(!shufflerSeedRevealed, "Shuffler seed already revealed");
        require(keccak256(abi.encodePacked(_seed, _nonce)) == committedShufflerSeedHash, "Invalid reveal");
        
        shufflerSeed = _seed;
        shufflerSeedRevealed = true;
        
        emit ShufflerSeedRevealed(_seed);
    }

    function _saveNewSeed(uint tokenId, uint remaining) internal {
        require(shufflerSeedRevealed, "Shuffler seed not revealed yet");  // Require shuffler seed reveal
        
        require(remaining > 0, "No remaining elements");

        uint seed = drawNextElement(shufflerSeed, msg.sender, remaining);
        
        globalTokenMetadata[tokenId] = TokenMetadata({
            tokenIdSeed: uint16(seed),
            backgroundIndex: getDefaultBackgroundIndex(),
            name: string.concat('RetroPunk #', string(Utils.toString(tokenId)))
        });
    }
    
    function getTokenMetadata(uint256 tokenId) public view returns (TokenMetadata memory) {
        require(_exists(tokenId), "Token does not exist");
        return globalTokenMetadata[tokenId];
    }

    function _getTokenMetadata(uint256 tokenId) internal view returns (TokenMetadata memory) {
        return globalTokenMetadata[tokenId];
    }

    modifier tokenExists(uint _tokenId) {
        require(_exists(_tokenId), "URI query for nonexistent token");
        _;
    }

    modifier onlyTokenOwner(uint _tokenId) {
        require(
            ownerOf(_tokenId) == msg.sender,
            "The caller is not the owner of the token"
        );
        _;
    }

    modifier notSpecial(uint256 tokenId) {
        if (globalTokenMetadata[tokenId].tokenIdSeed < NUM_SPECIAL_1S) {
            revert("Special 1 of 1s cannot be customized");
        }
        _;
    }

    function _addInternalMintMetadata(uint256 quantity) internal {
        require(shufflerSeedRevealed, "Shuffler seed not revealed yet");  // Block minting until revealed
        
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

    function closeMint() public onlyOwner {
        mintIsClosed = true;
    }

    // override ERC721a mint to add metadata on every mint
    function _mint(address to, uint256 quantity) internal override {
        if (mintIsClosed) {
            revert("Mint is permanently closed");
        }
        
        _checkMaxSupply(quantity);
        _addInternalMintMetadata(quantity);
        super._mint(to, quantity);
    }

    uint public ownerMintsRemaining = 10;
    
    function ownerMint(address toAddress, uint256 quantity) public onlyOwner nonReentrant {
        require(ownerMintsRemaining >= quantity, "Not enough owner mints remaining");
        ownerMintsRemaining -= quantity;

        _checkMaxSupply(quantity);
        _safeMint(toAddress, quantity);
    }

    function tokenURI(uint256 tokenId) public tokenExists(tokenId) view override returns (string memory) {
        require(globalSeedRevealed, "Global seed not revealed yet");
        TokenMetadata memory tokenMetadata = _getTokenMetadata(tokenId);

        return renderDataUri(tokenId, tokenMetadata.tokenIdSeed, tokenMetadata.backgroundIndex, tokenMetadata.name, globalSeed);
    }

    /**
     * @notice Renders an NFT token as a complete data URI containing JSON metadata
     * @dev This function generates the complete metadata for an NFT including SVG image, 
     *      attributes, and optional HTML animation. The result is returned as a base64-encoded
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
    function renderDataUri(uint256 _tokenId, uint16 _tokenIdSeed, uint16 _backgroundIndex, string memory _name, uint256 _globalSeed) internal view returns (string memory) {
        string memory svg;
        string memory attributes;
        string memory html;

        (svg, attributes) = renderer.renderSVG(_tokenIdSeed, _backgroundIndex, _globalSeed);
        html = renderer.renderHTML(bytes(svg));

        string memory displayName = keccak256(bytes(_name)) == keccak256(bytes(string.concat("RetroPunk #", Utils.toString(_tokenId)))) 
            ? _name 
            : string.concat("RetroPunk #", Utils.toString(_tokenId), ": ", _name);

        string memory json = string.concat(
            '{"name":"', displayName,
            '","description":"RetroPunks",',
            attributes,',',
            '"image":"data:image/svg+xml;base64,',
            Utils.encodeBase64(bytes(svg)),
            '"');
    
        json = string.concat(json, '}');

        if (bytes(html).length > 0) {
            json = string.concat(json, ',"animation_url":"data:text/html;base64,', Utils.encodeBase64(bytes(html)), '"}');
        } else {
            json = string.concat(json, '}');
        }
        return
            string.concat(
                "data:application/json;base64,",
                Utils.encodeBase64(bytes(json))
            );
    }
}