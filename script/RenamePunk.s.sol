// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Script, console2 } from "forge-std/Script.sol";

interface IRetroPunks {
    // UPDATED: Changed from setName to setTokenName
    function setTokenName(uint256 tokenId, string calldata newName) external;
    function ownerOf(uint256 tokenId) external view returns (address);
}

contract RenamePunkScript is Script {
    address constant CONTRACT_ADDRESS = 0x5FC8d32690cc91D4c39d9d3abcBD16989F875707;
    uint256 constant TOKEN_ID = 4;

    function run() external {
        string memory newName = "Super Punk";

        uint256 deployerPrivateKey = vm.envUint("PK");

        vm.startBroadcast(deployerPrivateKey);

        IRetroPunks punkContract = IRetroPunks(CONTRACT_ADDRESS);

        console2.log("Attempting to rename Token ID:", TOKEN_ID);
        console2.log("Current Owner:", punkContract.ownerOf(TOKEN_ID));

        // UPDATED: Calling the specific function you requested
        punkContract.setTokenName(TOKEN_ID, newName);

        vm.stopBroadcast();

        console2.log("Success! Token Name changed to:", newName);
    }
}
