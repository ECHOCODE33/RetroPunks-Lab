// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import { LibZip } from "../src/libraries/LibZip.sol";  // Adjust path if your src/ is different

contract LibZipTest is Test {
    using LibZip for bytes;  // Optional: Enables `data.flzCompress()` syntax

    function testFlzCompress() public pure {

        bytes memory inputData = hex"";

        bytes memory compressed = LibZip.flzCompress(inputData);


        // console.log("\n\n");
        console.log("Input length:", inputData.length, "\n");
        // console.logBytes(inputData);
        // console.log("\n\n");
        console.log("Compressed length:", compressed.length, "\n");
        console.logBytes(compressed);
        console.log("\n\n");

        assertTrue(compressed.length < inputData.length || inputData.length == 0);
    }
}