// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

interface IRetroPunks {
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

contract TokenURIBatchTest is Script {
    address constant retroPunksAddress = 0x5FC8d32690cc91D4c39d9d3abcBD16989F875707;

    function run() external {
        vm.pauseGasMetering();

        for (uint256 tokenId = 1; tokenId <= 10; tokenId++) {
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

