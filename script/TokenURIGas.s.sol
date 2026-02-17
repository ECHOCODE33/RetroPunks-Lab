// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";

/**
 * @notice Minimal ERC-721 interface — just the bits we need.
 */
interface IERC721Metadata {
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

/**
 * @title  TokenURIGas
 * @notice Calls `tokenURI` on any contract deployed on Ethereum Mainnet,
 *         measures the gas consumed, and prints the result to the console.
 *
 * Usage
 * ─────
 * # With a live RPC (replace placeholders):
 * forge script script/TokenURIGas.s.sol \
 *     --rpc-url <MAINNET_RPC_URL> \
 *     --sig "run(address,uint256)" \
 *     <NFT_CONTRACT_ADDRESS> \
 *     <TOKEN_ID>
 *
 * # Example (Bored Ape #1):
 * forge script script/TokenURIGas.s.sol \
 *     --rpc-url https://eth-mainnet.g.alchemy.com/v2/<KEY> \
 *     --sig "run(address,uint256)" \
 *     0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D \
 *     1
 *
 * Environment variable alternative — set CONTRACT and TOKEN_ID instead:
 *   CONTRACT=0xBC4CA0... TOKEN_ID=1 forge script script/TokenURIGas.s.sol \
 *       --rpc-url $MAINNET_RPC_URL
 */
contract TokenURIGas is Script {
    // -----------------------------------------------------------------------
    // Entry point used when CONTRACT / TOKEN_ID env vars are set
    // -----------------------------------------------------------------------
    function run() external {
        address nft = vm.envAddress("CONTRACT");
        uint256 tokenId = vm.envUint("TOKEN_ID");
        _measure(nft, tokenId);
    }

    // -----------------------------------------------------------------------
    // Entry point used with --sig "run(address,uint256)" <addr> <id>
    // -----------------------------------------------------------------------
    function run(address nft, uint256 tokenId) external {
        _measure(nft, tokenId);
    }

    // -----------------------------------------------------------------------
    // Core measurement logic
    // -----------------------------------------------------------------------
    function _measure(address nft, uint256 tokenId) internal view {
        console.log("===========================================");
        console.log("  tokenURI Gas Measurement");
        console.log("===========================================");
        console.log("Contract  :", nft);
        console.log("Token ID  :", tokenId);
        console.log("-------------------------------------------");

        // --- low-level staticcall so we can capture gas precisely ----------
        bytes memory callData = abi.encodeWithSelector(IERC721Metadata.tokenURI.selector, tokenId);

        uint256 gasBefore = gasleft();

        (bool success, bytes memory returnData) = nft.staticcall(callData);

        uint256 gasUsed = gasBefore - gasleft();

        // --- report --------------------------------------------------------
        if (!success) {
            // Attempt to surface a revert reason
            if (returnData.length > 0) {
                // Bubble up the revert string if present
                assembly { revert(add(returnData, 32), mload(returnData)) }
            }
            revert("tokenURI call reverted with no reason");
        }

        string memory uri = abi.decode(returnData, (string));

        console.log("-------------------------------------------");
        console.log("Gas used  :", gasUsed);
        console.log("===========================================");
    }
}
