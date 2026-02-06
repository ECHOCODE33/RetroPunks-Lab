// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {Assets} from "../src/Assets.sol";
import {Traits} from "../src/Traits.sol";
import {SVGRenderer} from "../src/SVGRenderer.sol";
import {RetroPunks, TokenMetadata} from "../src/RetroPunks.sol";
import {MaleProbabilities} from "../src/MaleProbabilities.sol";
import {FemaleProbabilities} from "../src/FemaleProbabilities.sol";
import {LibZip} from "../src/libraries/LibZip.sol";

contract RetroPunksTest is Test {
    Assets public assets;
    Traits public traits;
    SVGRenderer public renderer;
    RetroPunks public retroPunks;
    MaleProbabilities public maleProbs;
    FemaleProbabilities public femaleProbs;

    address public owner = address(1);
    address public user1 = address(2);
    address public user2 = address(3);

    bytes32 public globalSeedHash;
    bytes32 public shufflerSeedHash;

    function setUp() public {
        vm.startPrank(owner);

        // Deploy contracts
        assets = new Assets();
        maleProbs = new MaleProbabilities();
        femaleProbs = new FemaleProbabilities();
        traits = new Traits(maleProbs, femaleProbs);
        renderer = new SVGRenderer(assets, traits);

        // Create seed hashes
        globalSeedHash = keccak256(abi.encodePacked(uint256(12345), uint256(67890)));
        shufflerSeedHash = keccak256(abi.encodePacked(uint256(11111), uint256(22222)));

        address[] memory allowedSeaDrop = new address[](0);
        retroPunks = new RetroPunks(
            renderer,
            globalSeedHash,
            shufflerSeedHash,
            100, // Small supply for testing
            allowedSeaDrop
        );

        vm.stopPrank();
    }

    // ========================================================================
    // ASSET LOADING TESTS
    // ========================================================================

    function testLoadSampleAsset() public {
        vm.startPrank(owner);

        // Sample asset from your Python output (Male Earring)
        bytes memory sampleAsset = hex"0c4d616c652045617272696e670a00000000000000ffb7530fff353935ff96da3effcc6699fffff2b3ff00a6d9ff5612deffddccffff01081000081c0b1f00001045617272696e6720416d657468797374020102050201020502000201020002011000081c0b1f00000f45617272696e6720446961";

        // Compress and add
        bytes memory compressed = LibZip.flzCompress(sampleAsset);
        assets.addAsset(6, compressed); // Male Earring = index 6

        // Load and decompress
        bytes memory loaded = assets.loadAssetDecompressed(6);

        // Verify it matches original
        assertEq(loaded.length, sampleAsset.length);
        assertEq(keccak256(loaded), keccak256(sampleAsset));

        console.log("Asset loaded and decompressed successfully");

        vm.stopPrank();
    }

    function testAddAssetsBatch() public {
        vm.startPrank(owner);

        // Create batch of assets
        uint[] memory keys = new uint[](3);
        bytes[] memory assetData = new bytes[](3);

        keys[0] = 2;
        keys[1] = 3;
        keys[2] = 4;

        // Use dummy data for testing
        assetData[0] = LibZip.flzCompress(hex"0474657374");
        assetData[1] = LibZip.flzCompress(hex"0574657374");
        assetData[2] = LibZip.flzCompress(hex"0674657374");

        assets.addAssetsBatch(keys, assetData);

        console.log("Batch asset upload successful");

        vm.stopPrank();
    }

    // ========================================================================
    // MINTING TESTS
    // ========================================================================

    function testRevealShufflerSeed() public {
        vm.startPrank(owner);

        // Reveal shuffler seed
        retroPunks.revealShufflerSeed(11111, 22222);

        assertTrue(retroPunks.shufflerSeedRevealed());
        assertEq(retroPunks.shufflerSeed(), 11111);

        console.log("Shuffler seed revealed");

        vm.stopPrank();
    }

    function testOwnerMint() public {
        vm.startPrank(owner);

        // Reveal shuffler seed first
        retroPunks.revealShufflerSeed(11111, 22222);

        // Mint to user1
        retroPunks.ownerMint(user1, 5);

        assertEq(retroPunks.balanceOf(user1), 5);
        assertEq(retroPunks.totalSupply(), 5);

        console.log("Owner mint successful");

        vm.stopPrank();
    }

    function testCannotMintWithoutShufflerSeed() public {
        vm.startPrank(owner);

        // Try to mint without revealing seed
        vm.expectRevert("Shuffler seed not revealed yet");
        retroPunks.ownerMint(user1, 1);

        console.log("Correctly blocks mint without shuffler seed");

        vm.stopPrank();
    }

    function testRevealGlobalSeed() public {
        vm.startPrank(owner);

        // Setup: mint some tokens
        retroPunks.revealShufflerSeed(11111, 22222);
        retroPunks.ownerMint(user1, 3);

        // Reveal global seed
        retroPunks.revealGlobalSeed(12345, 67890);

        assertTrue(retroPunks.globalSeedRevealed());
        assertEq(retroPunks.globalSeed(), 12345);

        console.log("Global seed revealed");

        vm.stopPrank();
    }

    // ========================================================================
    // TOKEN METADATA TESTS
    // ========================================================================

    function testGetTokenMetadata() public {
        vm.startPrank(owner);

        retroPunks.revealShufflerSeed(11111, 22222);
        retroPunks.ownerMint(user1, 1);

        TokenMetadata memory metadata = retroPunks.getTokenMetadata(1);

        assertTrue(metadata.tokenIdSeed > 0);
        assertEq(metadata.backgroundIndex, retroPunks.getDefaultBackgroundIndex());
        assertEq(metadata.name, "RetroPunk #1");

        console.log("Token metadata retrieved");
        console.log("  Token ID Seed:", metadata.tokenIdSeed);
        console.log("  Background:", metadata.backgroundIndex);
        console.log("  Name:", metadata.name);

        vm.stopPrank();
    }

    // ========================================================================
    // CUSTOMIZATION TESTS
    // ========================================================================

    function testSetBackground() public {
        vm.startPrank(owner);

        retroPunks.revealShufflerSeed(11111, 22222);
        retroPunks.ownerMint(user1, 1);

        vm.stopPrank();

        // User1 changes background
        vm.startPrank(user1);

        retroPunks.setBackground(1, 5);

        TokenMetadata memory metadata = retroPunks.getTokenMetadata(1);
        assertEq(metadata.backgroundIndex, 5);

        console.log("Background changed successfully");

        vm.stopPrank();
    }

    function testSetName() public {
        vm.startPrank(owner);

        retroPunks.revealShufflerSeed(11111, 22222);
        retroPunks.ownerMint(user1, 1);

        vm.stopPrank();

        // User1 changes name
        vm.startPrank(user1);

        retroPunks.setName(1, "Cool Punk");

        TokenMetadata memory metadata = retroPunks.getTokenMetadata(1);
        assertEq(metadata.name, "Cool Punk");

        console.log("Name changed successfully");

        vm.stopPrank();
    }

    function testResetName() public {
        vm.startPrank(owner);

        retroPunks.revealShufflerSeed(11111, 22222);
        retroPunks.ownerMint(user1, 1);

        vm.stopPrank();

        vm.startPrank(user1);

        // Change name
        retroPunks.setName(1, "Cool Punk");

        // Reset name
        retroPunks.resetName(1);

        TokenMetadata memory metadata = retroPunks.getTokenMetadata(1);
        assertEq(metadata.name, "RetroPunk #1");

        console.log("Name reset successfully");

        vm.stopPrank();
    }

    function testOnlyOwnerCanCustomize() public {
        vm.startPrank(owner);

        retroPunks.revealShufflerSeed(11111, 22222);
        retroPunks.ownerMint(user1, 1);

        vm.stopPrank();

        // User2 tries to change user1's token
        vm.startPrank(user2);

        vm.expectRevert("Not token owner");
        retroPunks.setBackground(1, 5);

        console.log("Correctly blocks non-owner from customizing");

        vm.stopPrank();
    }

    // ========================================================================
    // RENDERING TESTS
    // ========================================================================

    function testCannotRenderWithoutGlobalSeed() public {
        vm.startPrank(owner);

        retroPunks.revealShufflerSeed(11111, 22222);
        retroPunks.ownerMint(user1, 1);

        vm.stopPrank();

        // Try to get tokenURI without global seed
        vm.expectRevert("Global seed not revealed yet");
        retroPunks.tokenURI(1);

        console.log("Correctly blocks rendering without global seed");
    }

    // ========================================================================
    // GAS BENCHMARKS
    // ========================================================================

    function testGasBenchmarks() public {
        vm.startPrank(owner);

        retroPunks.revealShufflerSeed(11111, 22222);

        // Benchmark minting
        uint gasStart = gasleft();
        retroPunks.ownerMint(user1, 1);
        uint gasUsed = gasStart - gasleft();
        console.log("Gas used for mint:", gasUsed);

        vm.stopPrank();

        // Benchmark background change
        vm.startPrank(user1);
        gasStart = gasleft();
        retroPunks.setBackground(1, 5);
        gasUsed = gasStart - gasleft();
        console.log("Gas used for setBackground:", gasUsed);

        // Benchmark name change
        gasStart = gasleft();
        retroPunks.setName(1, "Test Name");
        gasUsed = gasStart - gasleft();
        console.log("Gas used for setName:", gasUsed);

        vm.stopPrank();
    }
}