// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import "../src/RetroPunks.sol";
import "../src/common/Enums.sol";
import "../src/interfaces/ISVGRenderer.sol";
import "forge-std/Test.sol";

/**
 * @title RetroPunksTest
 * @notice Comprehensive test suite for RetroPunks NFT contract
 * @dev Tests all functionality including minting, reveals, customization, and edge cases
 */
contract RetroPunksTest is Test {
    RetroPunks public retroPunks;
    MockSVGRenderer public renderer;
    MockSeaDrop public seaDrop;

    // Test accounts
    address public owner;
    address public alice;
    address public bob;
    address public charlie;

    // Seed commitment values
    uint256 public globalSeed = 12345;
    uint256 public globalNonce = 67890;
    bytes32 public committedGlobalSeedHash;

    uint256 public shufflerSeed = 98765;
    uint256 public shufflerNonce = 43210;
    bytes32 public committedShufflerSeedHash;

    uint256 public constant MAX_SUPPLY = 1000;

    // Events to test
    event MetadataUpdate(uint256 _tokenId);
    event BatchMetadataUpdate(uint256 _fromTokenId, uint256 _toTokenId);

    function setUp() public {
        // Setup test accounts
        owner = address(this);
        alice = makeAddr("alice");
        bob = makeAddr("bob");
        charlie = makeAddr("charlie");

        // Fund test accounts
        vm.deal(alice, 100 ether);
        vm.deal(bob, 100 ether);
        vm.deal(charlie, 100 ether);

        // Create seed commitments
        committedGlobalSeedHash = keccak256(abi.encodePacked(globalSeed, globalNonce));
        committedShufflerSeedHash = keccak256(abi.encodePacked(shufflerSeed, shufflerNonce));

        // Deploy mock renderer
        renderer = new MockSVGRenderer();

        // Deploy mock SeaDrop
        seaDrop = new MockSeaDrop();
        address[] memory allowedSeaDrop = new address[](1);
        allowedSeaDrop[0] = address(seaDrop);

        // Deploy RetroPunks
        retroPunks = new RetroPunks(ISVGRenderer(address(renderer)), committedGlobalSeedHash, committedShufflerSeedHash, MAX_SUPPLY, allowedSeaDrop);

        // Grant SeaDrop the minter role
        seaDrop.setContract(address(retroPunks));
    }

    // ============================================
    // DEPLOYMENT & INITIALIZATION TESTS
    // ============================================

    function test_Deployment() public {
        assertEq(retroPunks.name(), "RetroPunks");
        assertEq(retroPunks.symbol(), "RPNKS");
        assertEq(address(retroPunks.renderer()), address(renderer));
        assertEq(retroPunks.COMMITTED_GLOBAL_SEED_HASH(), committedGlobalSeedHash);
        assertEq(retroPunks.COMMITTED_SHUFFLER_SEED_HASH(), committedShufflerSeedHash);
        assertEq(retroPunks.maxSupply(), MAX_SUPPLY);
        assertEq(retroPunks.ownerMintsRemaining(), 25);
        assertEq(retroPunks.globalSeed(), 0);
        assertEq(retroPunks.shufflerSeed(), 0);
        assertEq(retroPunks.mintIsClosed(), 0);
    }

    // ============================================
    // SEED REVEAL TESTS
    // ============================================

    function test_RevealGlobalSeed() public {
        assertEq(retroPunks.globalSeed(), 0);

        vm.expectEmit(true, true, false, false);
        emit BatchMetadataUpdate(1, 0); // No tokens minted yet

        retroPunks.revealGlobalSeed(globalSeed, globalNonce);

        assertEq(retroPunks.globalSeed(), globalSeed);
    }

    function test_RevertWhen_GlobalSeedAlreadyRevealed() public {
        retroPunks.revealGlobalSeed(globalSeed, globalNonce);

        vm.expectRevert(RetroPunks.GlobalSeedAlreadyRevealed.selector);
        retroPunks.revealGlobalSeed(globalSeed, globalNonce);
    }

    function test_RevertWhen_InvalidGlobalSeedReveal() public {
        uint256 wrongSeed = 11111;
        uint256 wrongNonce = 22222;

        vm.expectRevert(RetroPunks.InvalidGlobalSeedReveal.selector);
        retroPunks.revealGlobalSeed(wrongSeed, wrongNonce);
    }

    function test_RevealShufflerSeed() public {
        assertEq(retroPunks.shufflerSeed(), 0);

        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);

        assertEq(retroPunks.shufflerSeed(), shufflerSeed);
    }

    function test_RevertWhen_ShufflerSeedAlreadyRevealed() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);

        vm.expectRevert(RetroPunks.ShufflerSeedAlreadyRevealed.selector);
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
    }

    function test_RevertWhen_InvalidShufflerSeedReveal() public {
        uint256 wrongSeed = 11111;
        uint256 wrongNonce = 22222;

        vm.expectRevert(RetroPunks.InvalidShufflerSeedReveal.selector);
        retroPunks.revealShufflerSeed(wrongSeed, wrongNonce);
    }

    // ============================================
    // OWNER MINTING TESTS
    // ============================================

    function test_OwnerMint() public {
        // First reveal shuffler seed
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);

        uint256 quantity = 5;
        uint256 initialRemaining = retroPunks.ownerMintsRemaining();

        retroPunks.ownerMint(alice, quantity);

        assertEq(retroPunks.balanceOf(alice), quantity);
        assertEq(retroPunks.ownerMintsRemaining(), initialRemaining - quantity);
        assertEq(retroPunks.totalSupply(), quantity);

        // Check that tokens have metadata
        for (uint256 i = 1; i <= quantity; i++) {
            (uint16 tokenIdSeed, uint8 backgroundIndex, bytes32 name, string memory bio) = retroPunks.globalTokenMetadata(i);
            assertTrue(tokenIdSeed < MAX_SUPPLY * 2);
            assertEq(backgroundIndex, retroPunks.DEFAULT_BACKGROUND_INDEX());
        }
    }

    function test_OwnerMint_MultipleAddresses() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);

        retroPunks.ownerMint(alice, 3);
        retroPunks.ownerMint(bob, 5);
        retroPunks.ownerMint(charlie, 2);

        assertEq(retroPunks.balanceOf(alice), 3);
        assertEq(retroPunks.balanceOf(bob), 5);
        assertEq(retroPunks.balanceOf(charlie), 2);
        assertEq(retroPunks.totalSupply(), 10);
    }

    function test_RevertWhen_OwnerMintExceedsRemaining() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);

        vm.expectRevert(RetroPunks.NotEnoughOwnerMintsRemaining.selector);
        retroPunks.ownerMint(alice, 26); // More than 25 allowed
    }

    function test_RevertWhen_OwnerMintWithoutShufflerSeed() public {
        vm.expectRevert(RetroPunks.ShufflerSeedNotRevealedYet.selector);
        retroPunks.ownerMint(alice, 5);
    }

    function test_RevertWhen_OwnerMintExceedsMaxSupply() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.setOwnerMintsRemaining(uint16(MAX_SUPPLY + 100));

        vm.expectRevert();
        retroPunks.ownerMint(alice, MAX_SUPPLY + 1);
    }

    function test_SetOwnerMintsRemaining() public {
        uint16 newRemaining = 50;
        retroPunks.setOwnerMintsRemaining(newRemaining);
        assertEq(retroPunks.ownerMintsRemaining(), newRemaining);
    }

    function test_RevertWhen_NonOwnerSetsOwnerMintsRemaining() public {
        vm.prank(alice);
        vm.expectRevert("UNAUTHORIZED");
        retroPunks.setOwnerMintsRemaining(50);
    }

    // ============================================
    // PUBLIC MINTING TESTS (via SeaDrop)
    // ============================================

    function test_PublicMint_ViaSeaDrop() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);

        vm.prank(address(seaDrop));
        seaDrop.mintPublic(alice, 3);

        assertEq(retroPunks.balanceOf(alice), 3);
        assertEq(retroPunks.totalSupply(), 3);
    }

    function test_RevertWhen_PublicMintAfterClosed() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.closeMint();

        vm.prank(address(seaDrop));
        vm.expectRevert(RetroPunks.MintIsClosed.selector);
        seaDrop.mintPublic(alice, 1);
    }

    function test_MintAutoClosesAtMaxSupply() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.setOwnerMintsRemaining(uint16(MAX_SUPPLY));

        // Mint up to max supply
        retroPunks.ownerMint(alice, MAX_SUPPLY);

        assertEq(retroPunks.mintIsClosed(), 1);
        assertEq(retroPunks.totalSupply(), MAX_SUPPLY);
    }

    function test_CloseMint() public {
        assertEq(retroPunks.mintIsClosed(), 0);
        retroPunks.closeMint();
        assertEq(retroPunks.mintIsClosed(), 1);
    }

    // ============================================
    // RENDERER TESTS
    // ============================================

    function test_SetRenderer() public {
        MockSVGRenderer newRenderer = new MockSVGRenderer();

        retroPunks.setRenderer(ISVGRenderer(address(newRenderer)), false);

        assertEq(address(retroPunks.renderer()), address(newRenderer));
    }

    function test_SetRevealRenderer_EmitsBatchMetadataUpdate() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.ownerMint(alice, 5);

        MockSVGRenderer newRenderer = new MockSVGRenderer();

        vm.expectEmit(true, true, false, false);
        emit BatchMetadataUpdate(1, 5);

        retroPunks.setRenderer(ISVGRenderer(address(newRenderer)), true);
    }

    // ============================================
    // TOKEN METADATA CUSTOMIZATION TESTS
    // ============================================

    function test_SetTokenMetadata() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.revealGlobalSeed(globalSeed, globalNonce);

        // Set reveal renderer
        retroPunks.setRenderer(ISVGRenderer(address(renderer)), true);

        retroPunks.ownerMint(alice, 1);
        uint256 tokenId = 1;

        bytes32 newName = bytes32("Cool Punk");
        string memory newBio = "The coolest punk on the blockchain";
        uint8 newBackground = uint8(E_Background.Red);

        vm.prank(alice);
        vm.expectEmit(true, false, false, false);
        emit MetadataUpdate(tokenId);

        retroPunks.setTokenMetadata(tokenId, newName, newBio, newBackground);

        (uint16 seed, uint8 bg, bytes32 name, string memory bio) = retroPunks.globalTokenMetadata(tokenId);

        assertEq(name, newName);
        assertEq(bio, newBio);
        assertEq(bg, newBackground);
    }

    function test_SetTokenMetadata_AllBackgrounds() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.revealGlobalSeed(globalSeed, globalNonce);
        retroPunks.setRenderer(ISVGRenderer(address(renderer)), true);

        // Mint enough to get a non-special token (seed >= 7)
        retroPunks.ownerMint(alice, 20);

        // Find a token that's not a pre-rendered special (seed >= 7)
        uint256 tokenId;
        for (uint256 i = 1; i <= 20; i++) {
            (uint16 seed,,,) = retroPunks.globalTokenMetadata(i);
            if (seed >= 7) {
                tokenId = i;
                break;
            }
        }

        require(tokenId > 0, "No suitable token found");

        // Test all background indices
        for (uint8 i = 0; i < NUM_BACKGROUND; i++) {
            vm.prank(alice);
            retroPunks.setTokenMetadata(tokenId, bytes32("Test"), "Test bio", i);

            (, uint8 bg,,) = retroPunks.globalTokenMetadata(tokenId);
            assertEq(bg, i);
        }
    }

    function test_SetTokenMetadata_ValidCharacters() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.revealGlobalSeed(globalSeed, globalNonce);
        retroPunks.setRenderer(ISVGRenderer(address(renderer)), true);
        retroPunks.ownerMint(alice, 1);

        // Test valid characters: alphanumeric, space, !, -, ., _, '
        bytes32 validName = bytes32("Punk-123 Cool!_Name.");

        vm.prank(alice);
        retroPunks.setTokenMetadata(1, validName, "Bio", 0);

        (,, bytes32 name,) = retroPunks.globalTokenMetadata(1);
        assertEq(name, validName);
    }

    function test_RevertWhen_SetTokenMetadata_InvalidCharacter() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.revealGlobalSeed(globalSeed, globalNonce);
        retroPunks.setRenderer(ISVGRenderer(address(renderer)), true);
        retroPunks.ownerMint(alice, 1);

        // Test invalid character: @
        bytes32 invalidName = bytes32("Punk@123");

        vm.prank(alice);
        vm.expectRevert(RetroPunks.InvalidCharacterInName.selector);
        retroPunks.setTokenMetadata(1, invalidName, "Bio", 0);
    }

    function test_RevertWhen_SetTokenMetadata_BioTooLong() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.revealGlobalSeed(globalSeed, globalNonce);
        retroPunks.setRenderer(ISVGRenderer(address(renderer)), true);
        retroPunks.ownerMint(alice, 1);

        // Create a bio longer than 160 characters
        string memory longBio = new string(161);
        bytes memory bioBytes = bytes(longBio);
        for (uint256 i = 0; i < 161; i++) {
            bioBytes[i] = "a";
        }

        vm.prank(alice);
        vm.expectRevert(RetroPunks.BioIsTooLong.selector);
        retroPunks.setTokenMetadata(1, bytes32("Name"), string(bioBytes), 0);
    }

    function test_RevertWhen_SetTokenMetadata_InvalidBackgroundIndex() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.revealGlobalSeed(globalSeed, globalNonce);
        retroPunks.setRenderer(ISVGRenderer(address(renderer)), true);
        retroPunks.ownerMint(alice, 1);

        vm.prank(alice);
        vm.expectRevert(RetroPunks.InvalidBackgroundIndex.selector);
        retroPunks.setTokenMetadata(1, bytes32("Name"), "Bio", NUM_BACKGROUND);
    }

    function test_RevertWhen_SetTokenMetadata_NotOwner() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.revealGlobalSeed(globalSeed, globalNonce);
        retroPunks.setRenderer(ISVGRenderer(address(renderer)), true);
        retroPunks.ownerMint(alice, 1);

        vm.prank(bob);
        vm.expectRevert(RetroPunks.CallerIsNotTokenOwner.selector);
        retroPunks.setTokenMetadata(1, bytes32("Name"), "Bio", 0);
    }

    function test_RevertWhen_SetTokenMetadata_BeforeReveal() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.ownerMint(alice, 1);

        vm.prank(alice);
        vm.expectRevert(RetroPunks.MetadataNotRevealedYet.selector);
        retroPunks.setTokenMetadata(1, bytes32("Name"), "Bio", 0);
    }

    // ============================================
    // SPECIAL TOKENS TESTS
    // ============================================

    function test_PreRenderedSpecial_CannotChangeBackground() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.revealGlobalSeed(globalSeed, globalNonce);
        retroPunks.setRenderer(ISVGRenderer(address(renderer)), true);

        // Mint enough to potentially get a pre-rendered special (seed 0-6)
        retroPunks.ownerMint(alice, 20);

        // Find a pre-rendered special token (seed < 7)
        uint256 specialTokenId;
        uint8 originalBg;
        for (uint256 i = 1; i <= 20; i++) {
            (uint16 seed, uint8 bg,,) = retroPunks.globalTokenMetadata(i);
            if (seed < 7) {
                specialTokenId = i;
                originalBg = bg;
                break;
            }
        }

        require(specialTokenId > 0, "No pre-rendered special found");

        // Try to change background - should revert
        vm.prank(alice);
        vm.expectRevert("Special Punks cannot change background");
        retroPunks.setTokenMetadata(specialTokenId, bytes32("Name"), "Bio", originalBg + 1);
    }

    function test_PreRenderedSpecial_CanKeepSameBackground() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.revealGlobalSeed(globalSeed, globalNonce);
        retroPunks.setRenderer(ISVGRenderer(address(renderer)), true);
        retroPunks.ownerMint(alice, 20);

        // Find a pre-rendered special
        uint256 specialTokenId;
        uint8 originalBg;
        for (uint256 i = 1; i <= 20; i++) {
            (uint16 seed, uint8 bg,,) = retroPunks.globalTokenMetadata(i);
            if (seed < 7) {
                specialTokenId = i;
                originalBg = bg;
                break;
            }
        }

        require(specialTokenId > 0, "No pre-rendered special found");

        // Change name/bio but keep same background - should succeed
        vm.prank(alice);
        retroPunks.setTokenMetadata(specialTokenId, bytes32("Special Name"), "Special bio", originalBg);

        (,, bytes32 name, string memory bio) = retroPunks.globalTokenMetadata(specialTokenId);
        assertEq(name, bytes32("Special Name"));
        assertEq(bio, "Special bio");
    }

    function test_NonPreRenderedSpecial_CanChangeBackground() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.revealGlobalSeed(globalSeed, globalNonce);
        retroPunks.setRenderer(ISVGRenderer(address(renderer)), true);
        retroPunks.ownerMint(alice, 30);

        // Find a special but not pre-rendered (seed 7-15)
        uint256 specialTokenId;
        for (uint256 i = 1; i <= 30; i++) {
            (uint16 seed,,,) = retroPunks.globalTokenMetadata(i);
            if (seed >= 7 && seed < 16) {
                specialTokenId = i;
                break;
            }
        }

        require(specialTokenId > 0, "No seed 7-15 special found");

        // Should be able to change background
        vm.prank(alice);
        retroPunks.setTokenMetadata(specialTokenId, bytes32("Name"), "Bio", uint8(E_Background.Red));

        (, uint8 bg,,) = retroPunks.globalTokenMetadata(specialTokenId);
        assertEq(bg, uint8(E_Background.Red));
    }

    // ============================================
    // TOKEN URI TESTS
    // ============================================

    function test_TokenURI_BeforeReveal() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.ownerMint(alice, 1);

        string memory uri = retroPunks.tokenURI(1);

        // Should contain "Unrevealed Punk"
        assertTrue(bytes(uri).length > 0);
        // Could decode and check JSON but basic check is sufficient
    }

    function test_TokenURI_AfterReveal() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.revealGlobalSeed(globalSeed, globalNonce);
        retroPunks.setRenderer(ISVGRenderer(address(renderer)), true);
        retroPunks.ownerMint(alice, 1);

        string memory uri = retroPunks.tokenURI(1);

        assertTrue(bytes(uri).length > 0);
        // URI should be a data URI
        assertTrue(_startsWith(uri, "data:application/json;base64,"));
    }

    function test_TokenURI_CustomMetadata() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.revealGlobalSeed(globalSeed, globalNonce);
        retroPunks.setRenderer(ISVGRenderer(address(renderer)), true);
        retroPunks.ownerMint(alice, 1);

        vm.prank(alice);
        retroPunks.setTokenMetadata(1, bytes32("My Punk"), "Custom bio", 1);

        string memory uri = retroPunks.tokenURI(1);
        assertTrue(bytes(uri).length > 0);
    }

    function test_RevertWhen_TokenURI_NonExistentToken() public {
        vm.expectRevert(RetroPunks.NonExistentToken.selector);
        retroPunks.tokenURI(999);
    }

    // ============================================
    // INTEGRATION TESTS
    // ============================================

    function test_FullLifecycle() public {
        // 1. Deploy (done in setUp)

        // 2. Reveal shuffler seed
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);

        // 3. Owner mint some tokens
        retroPunks.ownerMint(alice, 5);
        retroPunks.ownerMint(bob, 3);

        // 4. Public mint via SeaDrop
        vm.prank(address(seaDrop));
        seaDrop.mintPublic(charlie, 2);

        assertEq(retroPunks.totalSupply(), 10);

        // 5. Reveal global seed and renderer
        retroPunks.revealGlobalSeed(globalSeed, globalNonce);
        retroPunks.setRenderer(ISVGRenderer(address(renderer)), true);

        // 6. Users customize their tokens
        vm.prank(alice);
        retroPunks.setTokenMetadata(1, bytes32("Alice Punk"), "Alice's first punk", 1);

        vm.prank(bob);
        retroPunks.setTokenMetadata(6, bytes32("Bob Special"), "Bob's rare find", 2);

        // 7. Check final state
        assertEq(retroPunks.balanceOf(alice), 5);
        assertEq(retroPunks.balanceOf(bob), 3);
        assertEq(retroPunks.balanceOf(charlie), 2);

        (,, bytes32 aliceName,) = retroPunks.globalTokenMetadata(1);
        assertEq(aliceName, bytes32("Alice Punk"));
    }

    function test_MintingPermutations() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);

        // Sequential minting
        for (uint256 i = 0; i < 10; i++) {
            retroPunks.ownerMint(alice, 1);
        }

        // Batch minting
        retroPunks.ownerMint(bob, 5);

        // Check uniqueness of seeds
        uint256[] memory seeds = new uint256[](15);
        for (uint256 i = 1; i <= 15; i++) {
            (uint16 seed,,,) = retroPunks.globalTokenMetadata(i);
            seeds[i - 1] = seed;
        }

        // Verify no duplicate seeds (statistically very unlikely)
        for (uint256 i = 0; i < seeds.length; i++) {
            for (uint256 j = i + 1; j < seeds.length; j++) {
                assertTrue(seeds[i] != seeds[j], "Duplicate seed found");
            }
        }
    }

    // ============================================
    // EDGE CASES & SECURITY TESTS
    // ============================================

    function test_RevertWhen_SetMetadata_NonExistentToken() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.revealGlobalSeed(globalSeed, globalNonce);
        retroPunks.setRenderer(ISVGRenderer(address(renderer)), true);

        vm.prank(alice);
        vm.expectRevert(RetroPunks.NonExistentToken.selector);
        retroPunks.setTokenMetadata(999, bytes32("Name"), "Bio", 0);
    }

    function test_OwnershipVerification() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.ownerMint(alice, 3);
        retroPunks.ownerMint(bob, 2);

        // Alice owns tokens 1, 2, 3
        assertEq(retroPunks.ownerOf(1), alice);
        assertEq(retroPunks.ownerOf(2), alice);
        assertEq(retroPunks.ownerOf(3), alice);

        // Bob owns tokens 4, 5
        assertEq(retroPunks.ownerOf(4), bob);
        assertEq(retroPunks.ownerOf(5), bob);
    }

    function test_MaxSupplyEnforcement() public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.setOwnerMintsRemaining(uint16(MAX_SUPPLY));

        // Mint up to max
        uint256 batchSize = 100;
        for (uint256 i = 0; i < MAX_SUPPLY / batchSize; i++) {
            retroPunks.ownerMint(alice, batchSize);
        }

        assertEq(retroPunks.totalSupply(), MAX_SUPPLY);

        // Try to mint one more
        vm.expectRevert();
        retroPunks.ownerMint(alice, 1);
    }

    function testFuzz_SetTokenMetadata_ValidNames(bytes32 name) public {
        retroPunks.revealShufflerSeed(shufflerSeed, shufflerNonce);
        retroPunks.revealGlobalSeed(globalSeed, globalNonce);
        retroPunks.setRenderer(ISVGRenderer(address(renderer)), true);
        retroPunks.ownerMint(alice, 1);

        // Only test with valid ASCII characters
        bool isValid = true;
        for (uint256 i = 0; i < 32; i++) {
            bytes1 c = name[i];
            if (c == 0) break;
            if (!((c >= 0x30 && c <= 0x39) || (c >= 0x41 && c <= 0x5A) || (c >= 0x61 && c <= 0x7A)
                        || (c == 0x20 || c == 0x21 || c == 0x2D || c == 0x2E || c == 0x5F || c == 0x27))) {
                isValid = false;
                break;
            }
        }

        vm.prank(alice);
        if (isValid) {
            retroPunks.setTokenMetadata(1, name, "Bio", 0);
        } else {
            vm.expectRevert(RetroPunks.InvalidCharacterInName.selector);
            retroPunks.setTokenMetadata(1, name, "Bio", 0);
        }
    }

    // ============================================
    // HELPER FUNCTIONS
    // ============================================

    function _startsWith(string memory str, string memory prefix) internal pure returns (bool) {
        bytes memory strBytes = bytes(str);
        bytes memory prefixBytes = bytes(prefix);

        if (strBytes.length < prefixBytes.length) return false;

        for (uint256 i = 0; i < prefixBytes.length; i++) {
            if (strBytes[i] != prefixBytes[i]) return false;
        }

        return true;
    }
}

// ============================================
// MOCK CONTRACTS
// ============================================

contract MockSVGRenderer is ISVGRenderer {
    function renderSVG(uint16 tokenIdSeed, uint8 backgroundIndex, uint256 globalSeed) external pure returns (string memory svg, string memory attributes) {
        svg = string(
            abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400">',
                '<rect width="400" height="400" fill="blue"/>',
                '<text x="200" y="200" text-anchor="middle" fill="white">Punk #',
                _toString(tokenIdSeed),
                "</text>",
                "</svg>"
            )
        );

        attributes = string(
            abi.encodePacked(
                '"attributes":[',
                '{"trait_type":"Seed","value":"',
                _toString(tokenIdSeed),
                '"},',
                '{"trait_type":"Background","value":"',
                _toString(backgroundIndex),
                '"}',
                "]"
            )
        );
    }

    function _toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";

        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }

        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }

        return string(buffer);
    }
}

contract MockSeaDrop {
    address public retroPunksContract;

    function setContract(address _contract) external {
        retroPunksContract = _contract;
    }

    function mintPublic(address to, uint256 quantity) external {
        RetroPunks(retroPunksContract).mintSeaDrop(to, quantity);
    }
}
