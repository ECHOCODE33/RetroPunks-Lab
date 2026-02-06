// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import { LibZip } from "../src/libraries/LibZip.sol"; 

contract LibZipTest2 is Test {
    using LibZip for bytes; 

    function testFlzDecompress() public pure {

        bytes memory expectedData = hex"";

        bytes memory compressedData = hex"";
        
        bytes memory decompressed = compressedData.flzDecompress();

        console.log("Compressed length:", compressedData.length, "\n");

        console.log("Decompressed length:", decompressed.length, "\n");

        assertEq(decompressed, expectedData, "Decompressed data must match original input");
    }
}

