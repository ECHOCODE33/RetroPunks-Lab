// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "../src/RetroPunks.sol";
import "../src/interfaces/ISVGRenderer.sol";
import { IERC721Receiver } from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import { Test } from "forge-std/Test.sol";

// --- Mock Renderer ---
contract MockRenderer is ISVGRenderer {
    function renderSVG(uint16, uint8, uint256) external pure override returns (string memory, string memory) {
        return ("<svg>mock</svg>", '"attributes": []');
    }
}

// --- Main Test Contract ---
contract RetroPunksTest is Test, IERC721Receiver {
    RetroPunks public retroPunks;
    MockRenderer public renderer;

    address public owner;
    address public user1;
    address[] public allowedSeaDrops;

    // Test constants
    uint256 public constant GLOBAL_SEED = 12345;
    uint256 public constant GLOBAL_NONCE = 67890;
    bytes32 public constant GLOBAL_SEED_HASH = keccak256(abi.encodePacked(GLOBAL_SEED, GLOBAL_NONCE));

    uint256 public constant SHUFFLER_SEED = 54321;
    uint256 public constant SHUFFLER_NONCE = 98765;
    bytes32 public constant SHUFFLER_SEED_HASH = keccak256(abi.encodePacked(SHUFFLER_SEED, SHUFFLER_NONCE));

    uint256 public constant MAX_SUPPLY = 100;

    // Events to check
    event GlobalSeedRevealed(uint256 seed);
    event ShufflerSeedRevealed(uint256 seed);
    event NameChanged(uint256 indexed tokenId, string name, address indexed owner);
    event BioChanged(uint256 indexed tokenId, string bio, address indexed owner);
    event MetadataUpdate(uint256 _tokenId);

    function onERC721Received(address, address, uint256, bytes calldata) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);

        renderer = new MockRenderer();

        retroPunks = new RetroPunks(ISVGRenderer(address(renderer)), GLOBAL_SEED_HASH, SHUFFLER_SEED_HASH, MAX_SUPPLY, allowedSeaDrops);
    }

    // ==========================================
    //           ADMIN FUNCTION TESTS
    // ==========================================

    function testSetRenderer() public {
        MockRenderer newRenderer = new MockRenderer();
        retroPunks.setRenderer(ISVGRenderer(address(newRenderer)), true);
        assertEq(address(retroPunks.renderer()), address(newRenderer));
    }

    function testSetRendererRevertsIfNotOwner() public {
        vm.prank(user1);
        vm.expectRevert(abi.encodeWithSignature("OnlyOwner()"));
        retroPunks.setRenderer(ISVGRenderer(address(renderer)), true);
    }

    function testRevealShufflerSeed() public {
        vm.expectEmit(true, true, true, true);
        emit ShufflerSeedRevealed(SHUFFLER_SEED);

        retroPunks.revealShufflerSeed(SHUFFLER_SEED, SHUFFLER_NONCE);

        assertTrue(retroPunks.shufflerSeedRevealed());
        assertEq(retroPunks.shufflerSeed(), SHUFFLER_SEED);
    }

    function testRevealShufflerSeedInvalid() public {
        vm.expectRevert(RetroPunks.InvalidShufflerSeedReveal.selector);
        retroPunks.revealShufflerSeed(SHUFFLER_SEED, 0);
    }

    function testRevealGlobalSeed() public {
        vm.expectEmit(true, true, true, true);
        emit GlobalSeedRevealed(GLOBAL_SEED);

        retroPunks.revealGlobalSeed(GLOBAL_SEED, GLOBAL_NONCE);

        assertTrue(retroPunks.globalSeedRevealed());
        assertEq(retroPunks.globalSeed(), GLOBAL_SEED);
    }

    function testCloseMint() public {
        retroPunks.closeMint();
        assertTrue(retroPunks.mintIsClosed());

        retroPunks.revealShufflerSeed(SHUFFLER_SEED, SHUFFLER_NONCE);
        vm.expectRevert(RetroPunks.MintIsClosed.selector);
        retroPunks.ownerMint(address(this), 1);
    }

    // ==========================================
    //            MINTING TESTS
    // ==========================================

    function testOwnerMint() public {
        retroPunks.revealShufflerSeed(SHUFFLER_SEED, SHUFFLER_NONCE);
        retroPunks.ownerMint(address(this), 5);

        assertEq(retroPunks.balanceOf(address(this)), 5);
        assertEq(retroPunks.ownerMintsRemaining(), 5);
        assertEq(retroPunks.totalSupply(), 5);
    }

    function testOwnerMintFailsWithoutShufflerReveal() public {
        vm.expectRevert(RetroPunks.ShufflerSeedNotRevealedYet.selector);
        retroPunks.ownerMint(address(this), 1);
    }

    function testOwnerMintExceedsAllowance() public {
        retroPunks.revealShufflerSeed(SHUFFLER_SEED, SHUFFLER_NONCE);
        vm.expectRevert(RetroPunks.NotEnoughOwnerMintsRemaining.selector);
        retroPunks.ownerMint(address(this), 11);
    }

    // ==========================================
    //        TOKEN CUSTOMIZATION TESTS
    // ==========================================

    function testSetTokenName() public {
        retroPunks.revealShufflerSeed(SHUFFLER_SEED, SHUFFLER_NONCE);
        retroPunks.ownerMint(address(this), 1);
        uint256 tokenId = 1;

        (uint16 seed,,,) = retroPunks.globalTokenMetadata(tokenId);
        if (seed < 7) return;

        string memory newName = "CyberPunk 2077";

        vm.expectEmit(true, false, false, true);
        emit NameChanged(tokenId, newName, address(this));

        retroPunks.setTokenName(tokenId, newName);

        (,, string memory storedName,) = retroPunks.globalTokenMetadata(tokenId);
        assertEq(storedName, newName);
    }

    function testSetTokenBio() public {
        retroPunks.revealShufflerSeed(SHUFFLER_SEED, SHUFFLER_NONCE);
        retroPunks.ownerMint(address(this), 1);
        uint256 tokenId = 1;

        (uint16 seed,,,) = retroPunks.globalTokenMetadata(tokenId);
        if (seed < 7) return;

        string memory newBio = "Living on the blockchain";

        vm.expectEmit(true, false, false, true);
        emit BioChanged(tokenId, newBio, address(this));

        retroPunks.setTokenBio(tokenId, newBio);

        (,,, string memory storedBio) = retroPunks.globalTokenMetadata(tokenId);
        assertEq(storedBio, newBio);
    }

    function testSetTokenNameValidation() public {
        retroPunks.revealShufflerSeed(SHUFFLER_SEED, SHUFFLER_NONCE);
        retroPunks.ownerMint(address(this), 1);
        uint256 tokenId = 1;

        (uint16 seed,,,) = retroPunks.globalTokenMetadata(tokenId);
        if (seed < 7) return;

        string memory longName = "This name is definitely way too long for the limit";
        vm.expectRevert(RetroPunks.NameIsTooLong.selector);
        retroPunks.setTokenName(tokenId, longName);

        string memory invalidName = "Punk@Home";
        vm.expectRevert(RetroPunks.InvalidCharacterInName.selector);
        retroPunks.setTokenName(tokenId, invalidName);
    }

    function testSetTokenBackground() public {
        retroPunks.revealShufflerSeed(SHUFFLER_SEED, SHUFFLER_NONCE);
        retroPunks.ownerMint(address(this), 1);
        uint256 tokenId = 1;

        (uint16 seed,,,) = retroPunks.globalTokenMetadata(tokenId);
        if (seed < 7) return;

        uint8 newBgIndex = 1;

        vm.expectEmit(true, false, false, false);
        emit MetadataUpdate(tokenId);

        retroPunks.setTokenBackground(tokenId, newBgIndex);

        (, uint8 bgIndex,,) = retroPunks.globalTokenMetadata(tokenId);
        assertEq(bgIndex, newBgIndex);
    }

    function testOnlyOwnerCanCustomize() public {
        retroPunks.revealShufflerSeed(SHUFFLER_SEED, SHUFFLER_NONCE);
        retroPunks.ownerMint(address(this), 1);
        uint256 tokenId = 1;

        (uint16 seed,,,) = retroPunks.globalTokenMetadata(tokenId);
        if (seed < 7) return;

        vm.prank(user1);
        vm.expectRevert(RetroPunks.CallerIsNotTokenOwner.selector);
        retroPunks.setTokenName(tokenId, "Hacked Name");
    }

    // ==========================================
    //          READ & METADATA TESTS
    // ==========================================

    function testTokenURI() public {
        retroPunks.revealShufflerSeed(SHUFFLER_SEED, SHUFFLER_NONCE);
        retroPunks.ownerMint(address(this), 1);

        string memory uri = retroPunks.tokenURI(1);
        assertTrue(bytes(uri).length > 0);
    }

    function testGlobalTokenMetadataStorage() public {
        retroPunks.revealShufflerSeed(SHUFFLER_SEED, SHUFFLER_NONCE);
        retroPunks.ownerMint(address(this), 1);

        (uint16 tokenIdSeed, uint8 backgroundIndex, string memory name, string memory bio) = retroPunks.globalTokenMetadata(1);

        assertTrue(tokenIdSeed < MAX_SUPPLY);
        assertEq(backgroundIndex, retroPunks.defaultBackgroundIndex());
        assertTrue(bytes(name).length > 0);
        assertEq(bio, "A RetroPunk living on-chain.");
    }
}
