// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "../src/SVGRenderer.sol";
import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

contract SVGRendererTest is Script {
    // -----------------------------------------------------------
    // CHANGE THESE TO YOUR REAL DEPLOYED ADDRESSES
    // -----------------------------------------------------------
    address constant ASSETS_ADDRESS = 0x82e01223d51Eb87e16A03E24687EDF0F294da6f1; // Replace with real Assets
    address constant TRAITS_ADDRESS = 0x5081a39b8A5f0E35a8D959395a630b68B74Dd30f; // Replace with real Traits
    address constant RENDERER_ADDRESS = 0x2E2Ed0Cfd3AD2f1d34481277b3204d807Ca2F8c2; // Replace with real Renderer (if deployed)

    // -----------------------------------------------------------
    // PARAMS TO TEST
    // -----------------------------------------------------------
    uint16 constant TOKEN_ID_SEED = 501;
    uint8 constant BG_INDEX = 2;
    uint256 constant GLOBAL_SEED = 123724794567;

    function run() external {
        // Use a fork if testing against a live network locally
        // vm.createSelectFork("https://your-rpc-url.com");

        SVGRenderer renderer;

        if (RENDERER_ADDRESS == address(0)) {
            // If not deployed yet, the script will deploy a local instance for testing
            vm.startBroadcast();
            renderer = new SVGRenderer(IAssets(ASSETS_ADDRESS), ITraits(TRAITS_ADDRESS));
            vm.stopBroadcast();
        } else {
            renderer = SVGRenderer(RENDERER_ADDRESS);
        }

        console.log("Starting Render Test...");

        // Execute Render
        (string memory svg, string memory attributes) = renderer.renderSVG(TOKEN_ID_SEED, BG_INDEX, GLOBAL_SEED);

        // Output to terminal
        console.log("--- SVG CONTENT ---");
        console.log(svg);

        console.log("--- METADATA ATTRIBUTES ---");
        console.log(attributes);

        // Optional: Save to a file so you can open it in a browser
        string memory path = "./test_output.svg";
        vm.writeFile(path, svg);
        console.log("SVG saved to:", path);
    }
}
