// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

interface IRetroPunks {
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

contract TokenURIBatchTest is Script {
    address constant retroPunksAddress = 0x0165878A594ca255338adfa4d48449f69242Eb8F;

    function run() external {
        vm.pauseGasMetering();
        
        for (uint tokenId = 1; tokenId <= 999; tokenId++) {
            bytes memory data = abi.encodeWithSignature("tokenURI(uint256)", tokenId);
            (bool success, bytes memory returnedData) = retroPunksAddress.staticcall(data);

            if (!success) {
                console.log("Token #%s: [REVERTED] (Logic Error/Out of Bounds)", tokenId);
                continue;
            }

            // Decode the bytes into a string to check actual content
            string memory uri = abi.decode(returnedData, (string));

            if (bytes(uri).length > 0) {
                console.log("Token #%s: [OK] (%s bytes)", tokenId, bytes(uri).length);
            } else {
                console.log("Token #%s: [EMPTY STRING]", tokenId);
            }
        }
    }
}

