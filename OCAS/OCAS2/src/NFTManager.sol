// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**

        ███████                            █████████  █████                 ███            
      ███░░░░░███                         ███░░░░░███░░███                 ░░░             
     ███     ░░███ ████████              ███     ░░░  ░███████    ██████   ████  ████████  
    ░███      ░███░░███░░███  ██████████░███          ░███░░███  ░░░░░███ ░░███ ░░███░░███ 
    ░███      ░███ ░███ ░███ ░░░░░░░░░░ ░███          ░███ ░███   ███████  ░███  ░███ ░███ 
    ░░███     ███  ░███ ░███            ░░███     ███ ░███ ░███  ███░░███  ░███  ░███ ░███ 
     ░░░███████░   ████ █████            ░░█████████  ████ █████░░████████ █████ ████ █████
       ░░░░░░░    ░░░░ ░░░░░              ░░░░░░░░░  ░░░░ ░░░░░  ░░░░░░░░ ░░░░░ ░░░░ ░░░░░ 
                                                                                       
                                                                                       
                                                                                       
       █████████   ████  ████              █████████   █████                               
      ███░░░░░███ ░░███ ░░███             ███░░░░░███ ░░███                                
     ░███    ░███  ░███  ░███            ░███    ░░░  ███████    ██████   ████████   █████ 
     ░███████████  ░███  ░███  ██████████░░█████████ ░░░███░    ░░░░░███ ░░███░░███ ███░░  
     ░███░░░░░███  ░███  ░███ ░░░░░░░░░░  ░░░░░░░░███  ░███      ███████  ░███ ░░░ ░░█████ 
     ░███    ░███  ░███  ░███             ███    ░███  ░███ ███ ███░░███  ░███      ░░░░███
     █████   █████ █████ █████           ░░█████████   ░░█████ ░░████████ █████     ██████ 
    ░░░░░   ░░░░░ ░░░░░ ░░░░░             ░░░░░░░░░     ░░░░░   ░░░░░░░░ ░░░░░     ░░░░░░  
                                                                                       
                                                                                   
    by 8-bit and EtoVass
*/


import { ISVGRenderer } from "./ISVGRenderer.sol";
import { Traits } from "./Traits.sol";
import { NUM_Background, E_Background } from "./TraitContextGenerated.sol";


import { Utils } from "./common/Utils.sol";
import { FisherYatesShuffler } from "./FisherYatesShuffler.sol";
import { ERC721SeaDropPausableAndQueryable } from "./seadrop/extensions/ERC721SeaDropPausableAndQueryable.sol";

struct TokenMetadata {
    uint32 tokenIdSeed;
    uint32 backgroundIndex;
}

event BackgroundChanged(uint256 indexed tokenId, uint256 indexed backgroundIndex, address indexed owner);

contract NFTManager is ERC721SeaDropPausableAndQueryable, FisherYatesShuffler {    
    uint public tokenSeed;
    uint public shufflerSeed;

    ISVGRenderer public renderer;

    bool public mintIsClosed = false;

    // tokenId -> TokenMetadata
    mapping(uint => TokenMetadata) public globalTokenMetadata; 

    constructor(ISVGRenderer _rendererParam, uint _tokenSeedParam, uint _maxSupplyParam, address[] memory allowedSeaDropParam) ERC721SeaDropPausableAndQueryable("On-Chain All-Stars", "OCAS", allowedSeaDropParam) {
        tokenSeed = _tokenSeedParam;
        shufflerSeed = uint(keccak256(abi.encodePacked(block.number, block.prevrandao, block.timestamp)));
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

    function getDefaultBackgroundIndex() public pure returns (uint32) {
        return uint32(uint(E_Background.Standard));
    }

    function _saveNewSeed(uint tokenId, uint remaining) internal {
        require(remaining > 0, "No remaining elements");

        uint seed = drawNextElement(shufflerSeed, msg.sender, remaining);
        
        globalTokenMetadata[tokenId] = TokenMetadata({
            tokenIdSeed: uint32(seed),
            backgroundIndex: getDefaultBackgroundIndex()
        });
    }

    function _getTokenSeed(uint256 tokenId) internal view returns (uint) {
        return globalTokenMetadata[tokenId].tokenIdSeed;
    }

    function _getTokenMetadata(uint256 tokenId) internal view returns (TokenMetadata memory) {
        return globalTokenMetadata[tokenId];
    }

    // Token exists
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
    
    function setBackground(uint tokenId, uint backgroundIndex) public onlyTokenOwner(tokenId) {
        require(backgroundIndex < NUM_Background, 
            string.concat("Invalid background index, must be between 0 and ", string(Utils.toString(NUM_Background - 1)))
        );

        globalTokenMetadata[tokenId].backgroundIndex = uint32(backgroundIndex);
       
        emit BatchMetadataUpdate(tokenId, tokenId);
        emit BackgroundChanged(tokenId, backgroundIndex, msg.sender);
    }

    function _addInternalMintMetadata(address to, uint256 quantity) internal {
        uint256 startTokenId = totalSupply();

        for(uint256 tokenId = startTokenId; tokenId < startTokenId + quantity; tokenId++) {
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
            revert("Mint is closed forever");
        }
        
        _checkMaxSupply(quantity);
        _addInternalMintMetadata(to, quantity);
        super._mint(to, quantity);
    }

    uint public ownerMintsRemaining = 11;
    
    function ownerMint(address toAddress, uint256 quantity) public onlyOwner nonReentrant {
        require(ownerMintsRemaining >= quantity, "Not enough owner mints remaining");
        ownerMintsRemaining -= quantity;

        _checkMaxSupply(quantity);
        _safeMint(toAddress, quantity); // _safeMint() instead of _mint() to protect from accidental minting to wrong addresses
        // _mint(toAddress, quantity);
    }

    function tokenURI(uint256 tokenId) public tokenExists(tokenId) view override returns (string memory) {
        TokenMetadata memory tokenMetadata = _getTokenMetadata(tokenId);

        return renderAsDataUri(tokenId, tokenMetadata.tokenIdSeed, tokenMetadata.backgroundIndex, tokenSeed);
    }

    /**
     * @notice Renders an NFT token as a complete data URI containing JSON metadata
     * @dev This function generates the complete metadata for an NFT including SVG image, 
     *      attributes, and optional HTML animation. The result is returned as a base64-encoded
     *      data URI that can be directly used as a token URI.
     * 
     * @param tokenId The unique identifier of the NFT token as seen in the marketplace. Determined by the order of minting.
     * @param tokenIdSeed The deterministic seed used to generate this token's traits, assigned at random at mint time.
     * @param backgroundIndex The index of the background to use (0 to NUM_Background-1)
     * @param seed The global seed used for trait generation consistency
     * 
     * @return A base64-encoded data URI containing the complete JSON metadata with:
     *         - name: Token name with ID
     *         - description: Collection description
     *         - attributes: Trait attributes from the renderer
     *         - image: Base64-encoded SVG image
     *         - animation_url: Base64-encoded HTML animation (if available)
     */
    function renderAsDataUri(uint tokenId, uint tokenIdSeed, uint backgroundIndex, uint seed) internal view returns (string memory) {
        string memory svg;
        string memory attributes;
        string memory html;

        (svg, attributes) = renderer.renderSVG(tokenIdSeed, backgroundIndex, seed);
        html = renderer.renderHTML(bytes(svg));

        string memory json = string.concat(
            '{"name":"#',
            string(Utils.toString(tokenId)),
            '","description":"On-Chain All-Stars",',
            attributes,',',
            '"image":"data:image/svg+xml;base64,',
            Utils.encode(bytes(svg)),
            '"');
        
        if (bytes(html).length > 0) {
            json = string.concat(json, ',"animation_url":"data:text/html;base64,', Utils.encode(bytes(html)), '"}');
        } else {
            json = string.concat(json, '}');
        }

        // // option #1 - as JSON
        // return string.concat('data:application/json;utf8,', json);

        // option #2 - as BASE64 encoded
        return
            string.concat(
                "data:application/json;base64,",
                Utils.encode(bytes(json))
            );    
    }
}
