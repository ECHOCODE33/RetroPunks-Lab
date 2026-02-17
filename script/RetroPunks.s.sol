// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { Assets } from "../src/Assets.sol";
import { Renderer } from "../src/Renderer.sol";
import { RetroPunks } from "../src/RetroPunks.sol";
import { Traits } from "../src/Traits.sol";
import { IRenderer } from "../src/interfaces/IRenderer.sol";
import { ITraits } from "../src/interfaces/ITraits.sol";
import { ISeaDrop } from "../src/seadrop/interfaces/ISeaDrop.sol";
import { PublicDrop } from "../src/seadrop/lib/SeaDropStructs.sol";
import { AddAssetsBatch } from "./AddAssetsBatch.s.sol";
import { VerifyAssets } from "./VerifyAssets.s.sol";
import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

contract HelperContract is Script {
    function _toAddressArray(address a1, address a2, address a3, address a4, address a5, address a6, address a7, address a8, address a9, address a10) internal pure returns (address[] memory arr) {
        // Count non-zero addresses from the end
        uint256 count = 10;
        if (a10 == address(0)) {
            count = 9;
            if (a9 == address(0)) {
                count = 8;
                if (a8 == address(0)) {
                    count = 7;
                    if (a7 == address(0)) {
                        count = 6;
                        if (a6 == address(0)) {
                            count = 5;
                            if (a5 == address(0)) {
                                count = 4;
                                if (a4 == address(0)) {
                                    count = 3;
                                    if (a3 == address(0)) {
                                        count = 2;
                                        if (a2 == address(0)) {
                                            count = 1;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        arr = new address[](count);
        if (count >= 1) {
            arr[0] = a1;
        }
        if (count >= 2) {
            arr[1] = a2;
        }
        if (count >= 3) {
            arr[2] = a3;
        }
        if (count >= 4) {
            arr[3] = a4;
        }
        if (count >= 5) {
            arr[4] = a5;
        }
        if (count >= 6) {
            arr[5] = a6;
        }
        if (count >= 7) {
            arr[6] = a7;
        }
        if (count >= 8) {
            arr[7] = a8;
        }
        if (count >= 9) {
            arr[8] = a9;
        }
        if (count >= 10) {
            arr[9] = a10;
        }
    }

    function _toAddressArray(address a1) internal pure returns (address[] memory) {
        return _toAddressArray(a1, address(0), address(0), address(0), address(0), address(0), address(0), address(0), address(0), address(0));
    }

    function _toUintArray(uint256 u1, uint256 u2, uint256 u3, uint256 u4, uint256 u5, uint256 u6, uint256 u7, uint256 u8, uint256 u9, uint256 u10) internal pure returns (uint256[] memory arr) {
        // Count non-zero values from the end (NOTE: 0 is treated as "not set")
        uint256 count = 10;
        if (u10 == 0) {
            count = 9;
            if (u9 == 0) {
                count = 8;
                if (u8 == 0) {
                    count = 7;
                    if (u7 == 0) {
                        count = 6;
                        if (u6 == 0) {
                            count = 5;
                            if (u5 == 0) {
                                count = 4;
                                if (u4 == 0) {
                                    count = 3;
                                    if (u3 == 0) {
                                        count = 2;
                                        if (u2 == 0) {
                                            count = 1;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        arr = new uint256[](count);
        if (count >= 1) {
            arr[0] = u1;
        }
        if (count >= 2) {
            arr[1] = u2;
        }
        if (count >= 3) {
            arr[2] = u3;
        }
        if (count >= 4) {
            arr[3] = u4;
        }
        if (count >= 5) {
            arr[4] = u5;
        }
        if (count >= 6) {
            arr[5] = u6;
        }
        if (count >= 7) {
            arr[6] = u7;
        }
        if (count >= 8) {
            arr[7] = u8;
        }
        if (count >= 9) {
            arr[8] = u9;
        }
        if (count >= 10) {
            arr[9] = u10;
        }
    }

    function _toUintArray(uint256 u1) internal pure returns (uint256[] memory) {
        return _toUintArray(u1, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    }

    function _toUintArrayExplicit(uint256 count, uint256[] memory values) internal pure returns (uint256[] memory arr) {
        arr = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            arr[i] = values[i];
        }
    }

    function _escapeJSON(string memory str) internal pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory escaped = new bytes(strBytes.length * 2); // Allocate extra space for escapes
        uint256 escapeIndex = 0;

        for (uint256 i = 0; i < strBytes.length; i++) {
            bytes1 char = strBytes[i];

            if (char == '"') {
                escaped[escapeIndex++] = "\\";
                escaped[escapeIndex++] = '"';
            } else if (char == "\\") {
                escaped[escapeIndex++] = "\\";
                escaped[escapeIndex++] = "\\";
            } else if (char == "\n") {
                escaped[escapeIndex++] = "\\";
                escaped[escapeIndex++] = "n";
            } else if (char == "\r") {
                escaped[escapeIndex++] = "\\";
                escaped[escapeIndex++] = "r";
            } else if (char == "\t") {
                escaped[escapeIndex++] = "\\";
                escaped[escapeIndex++] = "t";
            } else {
                escaped[escapeIndex++] = char;
            }
        }

        // Trim to actual length
        bytes memory result = new bytes(escapeIndex);
        for (uint256 i = 0; i < escapeIndex; i++) {
            result[i] = escaped[i];
        }

        return string(result);
    }
}

contract RetroPunksScript is HelperContract {
    address public OWNER = vm.envAddress("OWNER");
    uint256 internal PRIVATE_KEY = vm.envUint("PRIVATE_KEY");

    address public ASSETS = vm.envAddress("ASSETS");
    address public TRAITS = vm.envAddress("TRAITS");
    address public META_GEN = vm.envAddress("META_GEN");
    address public RETROPUNKS = vm.envAddress("RETROPUNKS");

    address public SEADROP = address(0x00005EA00Ac477B1030CE78506496e8C2dE24bf5);

    RetroPunks public retroPunksContract = RetroPunks(RETROPUNKS);
    IRenderer public rendererContract;

    uint256 public MAX_SUPPLY = 10000;
    uint256 public GLOBAL_SEED = 3801428711;
    uint256 public GLOBAL_NONCE = 6637905404;
    bytes32 public GLOBAL_SEED_HASH = keccak256(abi.encodePacked(GLOBAL_SEED, GLOBAL_NONCE));
    uint256 public SHUFFLER_SEED = 7409379534;
    uint256 public SHUFFLER_NONCE = 3929615063;
    bytes32 public SHUFFLER_SEED_HASH = keccak256(abi.encodePacked(SHUFFLER_SEED, SHUFFLER_NONCE));

    /*
     *     ======================== CALL ORDER (run in sequence) ========================
     *     1. deploy()
     *     2. addAssetsBatch()
     *     3. verifyAssets()
     *     4. revealShufflerSeed()     <- required before any minting (owner or SeaDrop)
     *     5. setupSeaDrop()           <- configures public drop so mintAsUser() works
     *     6. batchOwnerMint()         <- optional: owner mints
     *     7. mintAsUser()             <- optional: any address mints via SeaDrop
     *     8. revealGlobalSeed()       <- when ready (affects traits)
     *     9. setRevealMetaGen()       <- when ready (metadata reveal)
     *     10. closeMint()             <- when done (irreversible)
     *     =============================================================================
    */

    function deploy() public {
        vm.startBroadcast();

        address[] memory allowedSeaDrop = new address[](1);
        allowedSeaDrop[0] = 0x00005EA00Ac477B1030CE78506496e8C2dE24bf5;

        Assets assets = new Assets();
        Traits traits = new Traits();
        Renderer renderer = new Renderer(Assets(address(assets)), ITraits(address(traits)));
        RetroPunks retroPunks = new RetroPunks(IRenderer(address(renderer)), GLOBAL_SEED_HASH, SHUFFLER_SEED_HASH, MAX_SUPPLY, allowedSeaDrop);

        console.log("Assets::", address(assets));
        console.log("Traits:", address(traits));
        console.log("Renderer:", address(renderer));
        console.log("RetroPunks:", address(retroPunks));

        vm.stopBroadcast();
    }

    function deployContract() public {
        vm.startBroadcast();

        address[] memory allowedSeaDrop = new address[](1);
        allowedSeaDrop[0] = 0x00005EA00Ac477B1030CE78506496e8C2dE24bf5;

        RetroPunks retroPunks = new RetroPunks(IRenderer(0x36733D835Bcd02d59FF29532D0975aBa3Ae232f1), GLOBAL_SEED_HASH, SHUFFLER_SEED_HASH, MAX_SUPPLY, allowedSeaDrop);

        console.log("RetroPunks:", address(retroPunks));

        vm.stopBroadcast();
    }

    function addAssetsBatch() public {
        AddAssetsBatch assetsBatchScript = new AddAssetsBatch();
        assetsBatchScript.setUp();
        assetsBatchScript.run();
    }

    function verifyAssets() public {
        VerifyAssets verifyAssetsScript = new VerifyAssets();
        verifyAssetsScript.setUp();
        verifyAssetsScript.run();
    }

    function revealShufflerSeed() public {
        console.log("=== Revealing Shuffler Seed ===", "\n");
        console.log("RetroPunks:", RETROPUNKS, "\n");
        console.log("Shuffler Seed:", SHUFFLER_SEED, "\n");
        console.log("Shuffler Nonce:", SHUFFLER_NONCE, "\n");

        vm.startBroadcast(PRIVATE_KEY);

        retroPunksContract.revealShufflerSeed(SHUFFLER_SEED, SHUFFLER_NONCE);

        vm.stopBroadcast();

        console.log("Shuffler seed revealed successfully!");
        console.log("New shuffler seed value:", retroPunksContract.shufflerSeed());
    }

    function setupSeaDrop() public {
        uint256 mintPriceWei = vm.envOr("PUBLIC_MINT_PRICE", uint256(0));
        uint256 maxPerWallet = vm.envOr("PUBLIC_MAX_PER_WALLET", uint256(10));

        // Public drop: start now, end at max uint48 so drop stays open until you change it
        PublicDrop memory publicDrop = PublicDrop({ mintPrice: uint80(mintPriceWei), startTime: uint48(block.timestamp), endTime: type(uint48).max, maxTotalMintableByWallet: uint16(maxPerWallet), feeBps: 0, restrictFeeRecipients: false });

        console.log("=== SeaDrop setup ===", "\n");
        console.log("RetroPunks:", RETROPUNKS);
        console.log("SeaDrop:", SEADROP);
        console.log("Mint price (wei):", publicDrop.mintPrice);
        console.log("Max per wallet:", publicDrop.maxTotalMintableByWallet);
        console.log("Creator payout:", OWNER);

        vm.startBroadcast(PRIVATE_KEY);

        retroPunksContract.updatePublicDrop(SEADROP, publicDrop);
        retroPunksContract.updateCreatorPayoutAddress(SEADROP, OWNER);

        vm.stopBroadcast();

        console.log("\n", "SeaDrop configured. You can now call mintAsUser().");
    }

    function batchOwnerMint() public {
        address[] memory recipients = _toAddressArray(OWNER);
        uint256[] memory quantities = _toUintArray(5);

        console.log("=== Batch Owner Minting ===", "\n");
        console.log("RetroPunks:", RETROPUNKS);
        console.log("Number of recipients:", recipients.length);

        uint256 totalAmount = 0;
        for (uint256 i = 0; i < quantities.length; i++) {
            totalAmount += quantities[i];
        }

        console.log("Total amount:", totalAmount);

        vm.startBroadcast(PRIVATE_KEY);

        retroPunksContract.batchOwnerMint(recipients, quantities);

        vm.stopBroadcast();

        console.log("\n", "Batch minting complete!");
        console.log("Total supply:", retroPunksContract.totalSupply());
    }

    function mintAsUser() public {
        uint256 minterKey = PRIVATE_KEY;
        uint256 quantity = uint256(5);

        ISeaDrop seaDrop = ISeaDrop(SEADROP);
        PublicDrop memory publicDrop = seaDrop.getPublicDrop(RETROPUNKS);

        require(block.timestamp >= publicDrop.startTime, "Public drop not started");
        require(block.timestamp <= publicDrop.endTime, "Public drop ended");

        address feeRecipient = seaDrop.getCreatorPayoutAddress(RETROPUNKS);
        uint256 value = uint256(publicDrop.mintPrice) * quantity;

        address minter = vm.addr(minterKey);
        console.log("=== SeaDrop Public Mint (as user) ===", "\n");
        console.log("RetroPunks:", RETROPUNKS);
        console.log("SeaDrop:", SEADROP);
        console.log("Minter:", minter);
        console.log("Quantity:", quantity);
        console.log("Value (wei):", value);

        vm.startBroadcast(minterKey);

        seaDrop.mintPublic{ value: value }(RETROPUNKS, feeRecipient, address(0), quantity);

        vm.stopBroadcast();

        console.log("\n", "Mint complete! Total supply:", retroPunksContract.totalSupply());
    }

    function revealGlobalSeed() public {
        console.log("=== Revealing Global Seed ===", "\n");
        console.log("RetroPunks:", RETROPUNKS);
        console.log("Global Seed:", GLOBAL_SEED);
        console.log("Global Nonce:", GLOBAL_NONCE);

        vm.startBroadcast(PRIVATE_KEY);

        retroPunksContract.revealGlobalSeed(GLOBAL_SEED, GLOBAL_NONCE);

        vm.stopBroadcast();

        console.log("\n", "Global seed revealed successfully!");
        console.log("New global seed value:", retroPunksContract.globalSeed());
    }

    function revealMetaGen() public {
        console.log("=== Setting Reveal MetaGen ===", "\n");
        console.log("RetroPunks:", RETROPUNKS);
        console.log("New MetaGen:", META_GEN);

        vm.startBroadcast(PRIVATE_KEY);

        retroPunksContract.revealMetaGen();

        vm.stopBroadcast();

        console.log("\n", "Reveal contract MetaGen set successfully!");
        console.log("New Renderer:", address(retroPunksContract.renderer()));
    }

    function closeMint() public {
        console.log("=== Closing Mint ===", "\n");
        console.log("RetroPunks:", RETROPUNKS);
        console.log("Current total supply:", retroPunksContract.totalSupply());
        console.log("WARNING: This action is irreversible!");

        vm.startBroadcast(PRIVATE_KEY);

        retroPunksContract.closeMint();

        vm.stopBroadcast();

        console.log("\n", "Minting closed successfully!");
        console.log("Mint status:", retroPunksContract.mintIsClosed());
    }

    function customizeToken() public {
        address tokenOwner = vm.addr(PRIVATE_KEY);

        uint256 tokenId = 5;
        string memory name = "Mozart";
        string memory bio = "Legendary pianist & composer.";
        uint8 backgroundIndex = 25;

        console.log("=== Customizing Token ===", "\n");
        console.log("Token ID:", tokenId);
        console.log("Owner:", tokenOwner);
        console.log("Name:", name);
        console.log("Bio:", bio);
        console.log("Background:", backgroundIndex);

        require(retroPunksContract.ownerOf(tokenId) == tokenOwner, "Not token owner");

        vm.startBroadcast(PRIVATE_KEY);

        retroPunksContract.setTokenMetadata(tokenId, bytes32(bytes(name)), bio, backgroundIndex);

        vm.stopBroadcast();

        (, uint8 bg, bytes32 storedName, string memory storedBio) = retroPunksContract.globalTokenMetadata(tokenId);

        console.log("\n", "Token customized successfully!");

        console.log("Background:", bg);
        console.logBytes32(storedName);
        console.log("Bio:", storedBio);
    }

    function queryTokenURI() public {
        string memory uri = retroPunksContract.tokenURI(1);
        console.log("\n", uri, "\n");
    }

    function batchQueryTokenURI() public {
        string memory fileName = "export/tokenUriBatch.txt";

        vm.writeFile(fileName, "");

        uint256 totalSupply = retroPunksContract.totalSupply();
        uint256 startTokenID = 1;

        for (uint256 i = startTokenID; i <= totalSupply; i++) {
            string memory line = string.concat("Token ", vm.toString(i), ":\n", retroPunksContract.tokenURI(i), "\n");

            vm.writeLine(fileName, line);
        }

        console.log(string.concat("Token URIs written to file: ", fileName));
    }

    function batchQueryTokenURIJSON() public {
        string memory fileName = "./export/tokenURIBatch.json";

        string memory jsonArray = "[";

        uint256 totalSupply = retroPunksContract.totalSupply();
        uint256 startTokenID = 1;

        for (uint256 i = startTokenID; i <= totalSupply; i++) {
            string memory uri = retroPunksContract.tokenURI(i);
            bytes memory uriBytes = bytes(uri);
            string memory jsonContent = uri;

            // Check if it's a data URI (data:application/json;base64,...)
            if (uriBytes.length > 29) {
                // Extract first 29 characters to check prefix
                bytes memory prefixBytes = new bytes(29);
                for (uint256 j = 0; j < 29; j++) {
                    prefixBytes[j] = uriBytes[j];
                }

                if (keccak256(prefixBytes) == keccak256("data:application/json;base64,")) {
                    // Extract base64 part (everything after character 29)
                    bytes memory base64Bytes = new bytes(uriBytes.length - 29);
                    for (uint256 j = 29; j < uriBytes.length; j++) {
                        base64Bytes[j - 29] = uriBytes[j];
                    }
                    string memory base64Part = string(base64Bytes);

                    // Decode base64 using FFI
                    string[] memory inputs = new string[](3);
                    inputs[0] = "bash";
                    inputs[1] = "-c";
                    inputs[2] = string.concat("echo -n '", base64Part, "' | base64 -d");

                    bytes memory result = vm.ffi(inputs);
                    jsonContent = string(result);
                }
            }

            // Add comma separator (except for first element)
            if (i > startTokenID) {
                jsonArray = string.concat(jsonArray, ",");
            }

            jsonArray = string.concat(jsonArray, jsonContent);
        }

        jsonArray = string.concat(jsonArray, "]");

        // Write to file
        vm.writeFile(fileName, jsonArray);

        console.log(string.concat("Token URIs written to JSON file: ", fileName));
    }

    function batchQueryTokenMetadataJSON() public {
        string memory fileName = "./export/tokenMetadataBatch.json";

        string memory jsonArray = "[";

        uint256 totalSupply = retroPunksContract.totalSupply();
        uint256 startTokenID = 1;

        for (uint256 i = startTokenID; i <= totalSupply; i++) {
            // Get token metadata
            (uint16 seed, uint8 bg, bytes32 nameBytes, string memory bio) = retroPunksContract.globalTokenMetadata(i);

            // Convert bytes32 name to string (remove null bytes)
            bytes memory nameBytesMem = new bytes(32);
            for (uint256 j = 0; j < 32; j++) {
                nameBytesMem[j] = nameBytes[j];
            }
            uint256 nameLength = 0;
            for (uint256 j = 0; j < 32; j++) {
                if (nameBytesMem[j] != 0) {
                    nameLength = j + 1;
                }
            }
            bytes memory nameActual = new bytes(nameLength);
            for (uint256 j = 0; j < nameLength; j++) {
                nameActual[j] = nameBytesMem[j];
            }
            string memory name = string(nameActual);

            // Escape special characters in bio for JSON
            string memory escapedBio = _escapeJSON(bio);

            // Build JSON object
            string memory jsonObject = string.concat("{", '"tokenId":', vm.toString(i), ",", '"tokenIDSeed":', vm.toString(seed), ",", '"background":', vm.toString(bg), ",", '"name":"', name, '",', '"bio":"', escapedBio, '"', "}");

            // Add comma separator (except for first element)
            if (i > startTokenID) {
                jsonArray = string.concat(jsonArray, ",");
            }

            jsonArray = string.concat(jsonArray, jsonObject);
        }

        jsonArray = string.concat(jsonArray, "]");

        // Write to file
        vm.writeFile(fileName, jsonArray);

        console.log(string.concat("Token metadata written to JSON file: ", fileName));
    }

    function queryContractDetails() public {
        string memory name = retroPunksContract.name();
        string memory symbol = retroPunksContract.symbol();
        uint256 maxSupply = retroPunksContract.maxSupply();
        uint256 totalSupply = retroPunksContract.totalSupply();
        uint256 globalSeed = retroPunksContract.globalSeed();
        uint256 shufflerSeed = retroPunksContract.shufflerSeed();
        address rendererAddr = address(retroPunksContract.renderer());
        uint256 _mintIsClosed = retroPunksContract.mintIsClosed();
        bool mintIsClosed = _mintIsClosed == 1 ? true : false;

        console.log("=== Contract State ===", "\n");
        console.log("Contract:", RETROPUNKS);
        console.log("Name:", name);
        console.log("Symbol:", symbol);
        console.log("Minted Supply:", totalSupply, "/", maxSupply);
        console.log("Global Seed:", globalSeed);
        console.log("Shuffler Seed:", shufflerSeed);
        console.log("Renderer:", rendererAddr);
        console.log("Mint Is Closed:", mintIsClosed);
    }
}
