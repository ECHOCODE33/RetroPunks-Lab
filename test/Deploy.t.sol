// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

import {Assets} from "../src/Assets.sol";
import {Probs} from "../src/Probs.sol";
import {Traits} from "../src/Traits.sol";
import {SVGRenderer} from "../src/SVGRenderer.sol";
import {RetroPunks} from "../src/RetroPunks.sol";

contract RetroPunksTest is Test {
    Assets assets;
    Probs probs;
    Traits traits;
    SVGRenderer renderer;
    RetroPunks retroPunks;

    // Use setUp() to initialize the state before every test function
    function setUp() public {
        // In Tests, you don't use vm.startBroadcast() 
        // because we are testing locally, not on a real network.

        assets = new Assets();
        // probs = new Probs();

        traits = new Traits(/* probs */);

        renderer = new SVGRenderer(assets, traits);

        bytes32 committedGlobalSeedHash = keccak256(
            abi.encodePacked(uint256(9836428957), uint256(2829003893))
        );
        bytes32 committedShufflerSeedHash = keccak256(
            abi.encodePacked(uint256(7393514293), uint256(3904021486))
        );

        uint maxSupply = 350;
        address[] memory allowedSeaDrop = new address[](1);
        allowedSeaDrop[0] = 0x00005EA00Ac477B1030CE78506496e8C2dE24bf5;

        retroPunks = new RetroPunks(
            renderer,
            committedGlobalSeedHash,
            committedShufflerSeedHash,
            maxSupply,
            allowedSeaDrop
        );
    }

    /// @dev Verifies that all addresses were set correctly during deployment
    function test_DeploymentSuccess() public view {
        assertTrue(address(assets) != address(0), "Assets not deployed");
        assertTrue(address(probs) != address(0), "Probs not deployed");
        assertTrue(address(traits) != address(0), "Traits not deployed");
        assertTrue(address(renderer) != address(0), "Renderer not deployed");
        assertTrue(address(retroPunks) != address(0), "RetroPunks not deployed");
        
        // Confirm Max Supply was set correctly
        assertEq(retroPunks.maxSupply(), 350);
    }

    /// @dev Test a basic interaction (e.g., checking if renderer is linked)
    function test_RendererLink() public view {
        assertEq(address(retroPunks.renderer()), address(renderer));
    }
}