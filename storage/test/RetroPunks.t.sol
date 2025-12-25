// test/RetroPunks.t.sol
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import {Assets} from "../src/Assets.sol";
import {FemaleProbabilities} from "../src/FemaleProbabilities.sol";
import {MaleProbabilities} from "../src/MaleProbabilities.sol";
import {Traits} from "../src/Traits.sol";
import {SVGRenderer} from "../src/SVGRenderer.sol";
import {RetroPunks} from "../src/RetroPunks.sol";

contract RetroPunksTest is Test {
    RetroPunks public retroPunks;
    Assets public assets;
    FemaleProbabilities public femaleProbs;
    MaleProbabilities public maleProbs;
    Traits public traits;
    SVGRenderer public renderer;

    function setUp() public {
        // Deploy Assets
        assets = new Assets();

        // Deploy Probabilities
        femaleProbs = new FemaleProbabilities();
        maleProbs = new MaleProbabilities();

        // Deploy Traits
        traits = new Traits(maleProbs, femaleProbs);

        // Deploy SVGRenderer
        renderer = new SVGRenderer(assets, traits);

        // Deploy RetroPunks with dummies
        bytes32 committedGlobalSeedHash = keccak256(abi.encodePacked(uint256(12345), uint256(67890))); // Example
        bytes32 committedShufflerSeedHash = keccak256(abi.encodePacked(uint256(54321), uint256(98765))); // Example
        uint maxSupply = 100; // Small for testing
        address[] memory allowedSeaDrop = new address[](1);
        allowedSeaDrop[0] = address(0); // Dummy

        retroPunks = new RetroPunks(renderer, committedGlobalSeedHash, committedShufflerSeedHash, maxSupply, allowedSeaDrop);
    }

    function testRevealAndMint() public {
        // Reveal shuffler (use values matching example hash)
        retroPunks.revealShufflerSeed(54321, 98765);

        // Mint
        retroPunks.ownerMint(address(this), 1);

        // Reveal global
        retroPunks.revealGlobalSeed(12345, 67890);

        // Test tokenURI
        string memory uri = retroPunks.tokenURI(1);
        assertGt(bytes(uri).length, 0);
    }

    // Add more tests: e.g., testBackgroundChange, testNameChange
    function testBackgroundChange() public {
        retroPunks.revealShufflerSeed(54321, 98765);
        retroPunks.ownerMint(address(this), 1);
        retroPunks.revealGlobalSeed(12345, 67890);

        retroPunks.setBackground(1, 0); // Change to background 0
        // Assert via events or getTokenMetadata
    }
}