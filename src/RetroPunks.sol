// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { ISVGRenderer } from "./interfaces/ISVGRenderer.sol";
// NUM_SPECIAL_1S = 16, NUM_BACKGROUND = 19
import { NUM_SPECIAL_1S, NUM_BACKGROUND, E_Background } from "./common/Enums.sol";
import { LibPRNG } from "./libraries/LibPRNG.sol";
import { Utils } from "./libraries/Utils.sol";
import { ERC721SeaDropPausableAndQueryable } from "./seadrop/extensions/ERC721SeaDropPausableAndQueryable.sol";
import { ERC721ContractMetadata } from "./seadrop/ERC721ContractMetadata.sol";
import { ISeaDropTokenContractMetadata } from "./seadrop/interfaces/ISeaDropTokenContractMetadata.sol";

 
struct TokenMetadata {
    uint16 tokenIdSeed;
    uint8 backgroundIndex;
    string name;
    string bio;
}

/**
 * @author ECHO
 */
contract RetroPunks is ERC721SeaDropPausableAndQueryable {
    using LibPRNG for LibPRNG.LazyShuffler;

    ISVGRenderer public renderer;

    bytes32 public immutable COMMITTED_GLOBAL_SEED_HASH;
    bytes32 public immutable COMMITTED_SHUFFLER_SEED_HASH;

    uint16 public ownerMintsRemaining = 1000;
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

    mapping(uint => TokenMetadata) public globalTokenMetadata;

    LibPRNG.LazyShuffler private _tokenIdSeedShuffler; 

    uint8 constant public defaultBackgroundIndex = uint8(uint(E_Background.Standard));


    // ----- Events ----- //

    event GlobalSeedRevealed(uint256 seed);
    event ShufflerSeedRevealed(uint256 seed);
    event BackgroundChanged(uint256 indexed tokenId, uint256 indexed backgroundIndex, address indexed owner);
    event NameChanged(uint256 indexed tokenId, string name, address indexed owner);
    event BioChanged(uint256 indexed tokenId, string bio, address indexed owner);
    
    event MetadataUpdate(uint256 _tokenId);
    event OwnerMintsUpdated(uint256 newAmount);


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
    error MaxSupplyLessThanTotalMinted();
    error Mint_Total_Supply_Before_Setting_Max_Supply();


    // ----- Modifiers ----- //

    modifier tokenExists(uint256 _tokenId) {
        _tokenExists(_tokenId);
        _;
    }
    
    modifier onlyTokenOwner(uint256 _tokenId) {
        _onlyTokenOwner(_tokenId);
        _;
    }

    modifier notSpecial(uint256 tokenId) {
        _notSpecial(tokenId);
        _;
    }

    function _tokenExists(uint256 _tokenId) internal view {
        if (!_exists(_tokenId)) revert NonExistentToken();
    }

    function _onlyTokenOwner(uint256 _tokenId) internal view {
        if (ownerOf(_tokenId) != msg.sender) revert CallerIsNotTokenOwner();
    }

    function _notSpecial(uint256 tokenId) internal view {
        uint16 tokenIdSeed = globalTokenMetadata[tokenId].tokenIdSeed;
        if (tokenIdSeed < NUM_SPECIAL_1S) {
            if (tokenIdSeed < 7) revert PreRenderedSpecialCannotBeCustomized();
        }
    }

    // ----- Constructor ----- //

    constructor(
        ISVGRenderer _rendererParam, 
        bytes32 _committedGlobalSeedHashParam, 
        bytes32 _committedShufflerSeedHashParam, 
        uint _maxSupplyParam, 
        address[] memory allowedSeaDropParam
    ) ERC721SeaDropPausableAndQueryable("RetroPunks", "RPNKS", allowedSeaDropParam) {
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

        _tokenIdSeedShuffler.initialize(_maxSupply); 
        
        emit ShufflerSeedRevealed(_seed);
    }

    function ownerMint(address toAddress, uint256 quantity) external onlyOwner nonReentrant {
        if (ownerMintsRemaining < quantity) revert NotEnoughOwnerMintsRemaining();
        ownerMintsRemaining -= uint16(quantity);
        _checkMaxSupply(quantity);
        
        _addInternalMintMetadata(quantity); 
        
        _safeMint(toAddress, quantity);
    }


    function setMaxSupply(uint256 newMaxSupply) external onlyOwner override(ERC721ContractMetadata, ISeaDropTokenContractMetadata) {
        
        if (_totalMinted() < _maxSupply) revert Mint_Total_Supply_Before_Setting_Max_Supply();
        
        if (newMaxSupply < _totalMinted()) revert MaxSupplyLessThanTotalMinted();
        _maxSupply = newMaxSupply;

        if (shufflerSeedRevealed) {
            _tokenIdSeedShuffler.initialize(newMaxSupply);
        }
        emit MaxSupplyUpdated(newMaxSupply);
    }


    // ----- Token Customization ----- //

    function setTokenBackground(uint tokenId, uint backgroundIndex) external onlyTokenOwner(tokenId) notSpecial(tokenId) {
        if (backgroundIndex >= NUM_BACKGROUND) revert InvalidBackgroundIndex();

        globalTokenMetadata[tokenId].backgroundIndex = uint8(backgroundIndex);
    
        emit MetadataUpdate(tokenId);
        emit BackgroundChanged(tokenId, backgroundIndex, msg.sender);
    }

    function setTokenName(uint tokenId, string calldata name) external onlyTokenOwner(tokenId) notSpecial(tokenId) {
        bytes memory b = bytes(name);
        if(!(b.length > 0 && b.length <= 32)) revert NameIsTooLong();

        for (uint i = 0; i < b.length; ) {
            bytes1 c = b[i];
            if (!(  (c >= 0x30 && c <= 0x39) || (c >= 0x41 && c <= 0x5A) || 
                    (c >= 0x61 && c <= 0x7A) || (c == 0x20 || c == 0x21 || 
                    c == 0x2D || c == 0x2E || c == 0x3F || c == 0x5F || 
                    c == 0x26 || c == 0x27)
                )) revert InvalidCharacterInName();
            unchecked { ++i; }
        }

        globalTokenMetadata[tokenId].name = name;

        emit MetadataUpdate(tokenId);
        emit NameChanged(tokenId, name, msg.sender);
    }

    function setTokenBio(uint tokenId, string calldata bio) external onlyTokenOwner(tokenId) notSpecial(tokenId) {
        if (bytes(bio).length > 160) revert BioIsTooLong();

        globalTokenMetadata[tokenId].bio = bio;

        emit MetadataUpdate(tokenId);
        emit BioChanged(tokenId, bio, msg.sender);
    }


    // ----- Public & Internal Functions ----- //

    function _getInitialName(uint256 tokenId, uint16 tokenIdSeed) internal view returns (string memory) {
        if (tokenIdSeed < NUM_SPECIAL_1S) {
            return string.concat("1 of 1: ", SPECIAL_NAMES[tokenIdSeed]);
        }
        return string.concat("#", Utils.toString(tokenId));
    }

    function _saveNewSeed(uint tokenId, uint remaining) internal {
        if (remaining == 0) revert NoRemainingTokens();

        uint256 numShuffled = _tokenIdSeedShuffler.numShuffled();
        
        uint256 randomness = uint256(keccak256(abi.encodePacked(shufflerSeed, numShuffled)));
        
        uint newTokenIdSeed = _tokenIdSeedShuffler.next(randomness);
        
        globalTokenMetadata[tokenId] = TokenMetadata({
            tokenIdSeed: uint16(newTokenIdSeed),
            backgroundIndex: defaultBackgroundIndex,
            name: _getInitialName(tokenId, uint16(newTokenIdSeed)),
            bio: "A RetroPunk living on-chain."
        });
    }

    function _addInternalMintMetadata(uint256 quantity) internal {
        if (!shufflerSeedRevealed) revert ShufflerSeedNotRevealedYet();
        uint256 currentMintCount = _totalMinted();
        for(uint256 i = 0; i < quantity; i++) {
            _saveNewSeed(currentMintCount + i + 1, _maxSupply - (currentMintCount + i));
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
        if (_totalMinted() == maxSupply()) mintIsClosed = true;
    }

    function tokenURI(uint256 tokenId) public tokenExists(tokenId) view override returns (string memory) {
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
        string memory svg;
        string memory attributes;
        (svg, attributes) = renderer.renderSVG(_tokenIdSeed, _backgroundIndex, _globalSeed);

        string memory displayName = keccak256(bytes(_name)) == keccak256(bytes(string.concat("#", Utils.toString(_tokenId))))
            ? _name
            : string.concat("#", Utils.toString(_tokenId), ": ", _name);

        string memory json = string.concat(
            '{"name":"', displayName,
            '","description":"', _bio, '",',
            attributes, ',',
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