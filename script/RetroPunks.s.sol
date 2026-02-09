// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { Assets } from "../src/Assets.sol";
import { IMetaGen } from "../src/interfaces/IMetaGen.sol";
// import { Rarities } from "../src/Rarities.sol";
import { MetaGen } from "../src/MetaGen.sol";
import { PreviewMetaGen } from "../src/PreviewMetaGen.sol";
import { RetroPunks } from "../src/RetroPunks.sol";
import { Traits } from "../src/Traits.sol";
import { ISeaDrop } from "../src/seadrop/interfaces/ISeaDrop.sol";
import { PublicDrop } from "../src/seadrop/lib/SeaDropStructs.sol";

/**
 * @title HelperContract
 * @notice Consolidated helper functions for deployment scripts
 * @dev Optimized: Single variadic-style helper using assembly instead of 20+ overloaded functions
 */
contract HelperContract is Script {
    /// @dev Creates address array from 1-10 addresses. Pass address(0) for unused slots.
    /// @notice Gas optimized: single function replaces 10 overloads
    function _toAddressArray(
        address a1,
        address a2,
        address a3,
        address a4,
        address a5,
        address a6,
        address a7,
        address a8,
        address a9,
        address a10
    ) internal pure returns (address[] memory arr) {
        // Count non-zero addresses from the end
        uint256 count = 10;
        if (a10 == address(0)) { count = 9;
            if (a9 == address(0)) { count = 8;
                if (a8 == address(0)) { count = 7;
                    if (a7 == address(0)) { count = 6;
                        if (a6 == address(0)) { count = 5;
                            if (a5 == address(0)) { count = 4;
                                if (a4 == address(0)) { count = 3;
                                    if (a3 == address(0)) { count = 2;
                                        if (a2 == address(0)) { count = 1; }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        arr = new address[](count);
        if (count >= 1) arr[0] = a1;
        if (count >= 2) arr[1] = a2;
        if (count >= 3) arr[2] = a3;
        if (count >= 4) arr[3] = a4;
        if (count >= 5) arr[4] = a5;
        if (count >= 6) arr[5] = a6;
        if (count >= 7) arr[6] = a7;
        if (count >= 8) arr[7] = a8;
        if (count >= 9) arr[8] = a9;
        if (count >= 10) arr[9] = a10;
    }

    /// @dev Convenience wrapper for single address
    function _toAddressArray(address a1) internal pure returns (address[] memory) {
        return _toAddressArray(a1, address(0), address(0), address(0), address(0), address(0), address(0), address(0), address(0), address(0));
    }

    /// @dev Creates uint256 array from 1-10 values. Pass 0 for unused slots (but be careful if 0 is a valid value).
    /// @notice For cases where 0 is valid, use the explicit count version
    function _toUintArray(
        uint256 u1,
        uint256 u2,
        uint256 u3,
        uint256 u4,
        uint256 u5,
        uint256 u6,
        uint256 u7,
        uint256 u8,
        uint256 u9,
        uint256 u10
    ) internal pure returns (uint256[] memory arr) {
        // Count non-zero values from the end (NOTE: 0 is treated as "not set")
        uint256 count = 10;
        if (u10 == 0) { count = 9;
            if (u9 == 0) { count = 8;
                if (u8 == 0) { count = 7;
                    if (u7 == 0) { count = 6;
                        if (u6 == 0) { count = 5;
                            if (u5 == 0) { count = 4;
                                if (u4 == 0) { count = 3;
                                    if (u3 == 0) { count = 2;
                                        if (u2 == 0) { count = 1; }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        arr = new uint256[](count);
        if (count >= 1) arr[0] = u1;
        if (count >= 2) arr[1] = u2;
        if (count >= 3) arr[2] = u3;
        if (count >= 4) arr[3] = u4;
        if (count >= 5) arr[4] = u5;
        if (count >= 6) arr[5] = u6;
        if (count >= 7) arr[6] = u7;
        if (count >= 8) arr[7] = u8;
        if (count >= 9) arr[8] = u9;
        if (count >= 10) arr[9] = u10;
    }

    /// @dev Convenience wrapper for single uint
    function _toUintArray(uint256 u1) internal pure returns (uint256[] memory) {
        return _toUintArray(u1, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    }

    /// @dev Creates uint array with explicit count (use when 0 is a valid value)
    function _toUintArrayExplicit(uint256 count, uint256[] memory values) internal pure returns (uint256[] memory arr) {
        arr = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            arr[i] = values[i];
        }
    }
}

contract RetroPunksScript is HelperContract {
    address public OWNER = vm.envAddress("OWNER");
    uint256 internal PRIVATE_KEY = vm.envUint("PRIVATE_KEY");

    address public ASSETS = vm.envAddress("ASSETS");
    address public TRAITS = vm.envAddress("TRAITS");
    address public PREVIEW_META_GEN = vm.envAddress("PREVIEW_META_GEN");
    address public META_GEN = vm.envAddress("META_GEN");
    address public RETROPUNKS = vm.envAddress("RETROPUNKS");

    address public SEADROP = address(0x00005EA00Ac477B1030CE78506496e8C2dE24bf5);

    RetroPunks public retroPunksContract = RetroPunks(RETROPUNKS);
    IMetaGen public metaGenContract;

    uint256 public MAX_SUPPLY = 30;
    uint256 public GLOBAL_SEED = 6397004135;
    uint256 public GLOBAL_NONCE = 5291012319;
    bytes32 public GLOBAL_SEED_HASH = keccak256(abi.encodePacked(GLOBAL_SEED, GLOBAL_NONCE));
    uint256 public SHUFFLER_SEED = 2401460252;
    uint256 public SHUFFLER_NONCE = 8904927786;
    bytes32 public SHUFFLER_SEED_HASH = keccak256(abi.encodePacked(SHUFFLER_SEED, SHUFFLER_NONCE));

    // ======================== CALL ORDER (run in sequence) ========================
    // 1. deploy()
    // 2. addAssetsBatch()
    // 3. verifyAssets()
    // 4. revealShufflerSeed()     <- required before any minting (owner or SeaDrop)
    // 5. setupSeaDrop()           <- configures public drop so mintAsUser() works
    // 6. batchOwnerMint()         <- optional: owner mints
    // 7. mintAsUser()             <- optional: any address mints via SeaDrop
    // 8. revealGlobalSeed()       <- when ready (affects traits)
    // 9. setRevealMetaGen()       <- when ready (metadata reveal)
    // 10. closeMint()             <- when done (irreversible)
    // =============================================================================

    /**
     * 1. Deploy RetroPunks and dependencies.
     * @dev Run with: forge script script/RetroPunks.s.sol:RetroPunksScript --sig "deploy()" --rpc-url <RPC_URL> --broadcast
     */
    function deploy() external {
        vm.startBroadcast();

        address[] memory allowedSeaDrop = new address[](1);
        allowedSeaDrop[0] = 0x00005EA00Ac477B1030CE78506496e8C2dE24bf5;

        Assets assets = new Assets();
        Traits traits = new Traits();
        PreviewMetaGen previewMetaGen = new PreviewMetaGen(Assets(address(assets)));
        MetaGen metaGen = new MetaGen(Assets(address(assets)), Traits(address(traits)));
        RetroPunks retroPunks = new RetroPunks(PreviewMetaGen(address(previewMetaGen)), GLOBAL_SEED_HASH, SHUFFLER_SEED_HASH, MAX_SUPPLY, allowedSeaDrop);

        console.log("Assets::", address(assets));
        console.log("Traits:", address(traits));
        console.log("PreviewMetaGen:", address(previewMetaGen));
        console.log("MetaGen:", address(metaGen));
        console.log("RetroPunks:", address(retroPunks));

        vm.stopBroadcast();
    }

    /**
     * 2. Add assets batch (required before any minting).
     */
    function addAssetsBatch() external {
        string[] memory inputs = new string[](9);

        inputs[0] = "forge";
        inputs[1] = "script";
        inputs[2] = "script/AddAssetsBatch.s.sol:AddAssetsBatch";
        inputs[3] = "--rpc-url";
        inputs[4] = vm.envString("BASE_SEPOLIA_RPC");
        inputs[5] = "--private-key";
        inputs[6] = vm.envString("PRIVATE_KEY");
        inputs[7] = "--broadcast";
        inputs[8] = "-vvv";

        bytes memory res = vm.ffi(inputs);
        console.log(string(res));
    }

    /**
     * 3. Verify assets (required before any minting).
     */
    function verifyAssets() external {
        string[] memory inputs = new string[](9);

        inputs[0] = "forge";
        inputs[1] = "script";
        inputs[2] = "script/VerifyAssets.s.sol:VerifyAssets";
        inputs[3] = "--rpc-url";
        inputs[4] = vm.envString("BASE_SEPOLIA_RPC");
        inputs[5] = "--private-key";
        inputs[6] = vm.envString("PRIVATE_KEY");
        inputs[7] = "--broadcast";
        inputs[8] = "-vvv";

        bytes memory res = vm.ffi(inputs);
        console.log(string(res));
    }

    /**
     * 4. Reveal the shuffler seed (required before any minting — owner or SeaDrop).
     */
    function revealShufflerSeed() external {
        console.log("=== Revealing Shuffler Seed ===");
        console.log("RetroPunks:", RETROPUNKS);
        console.log("Shuffler Seed:", SHUFFLER_SEED);
        console.log("Shuffler Nonce:", SHUFFLER_NONCE);

        vm.startBroadcast(PRIVATE_KEY);

        retroPunksContract.revealShufflerSeed(SHUFFLER_SEED, SHUFFLER_NONCE);

        vm.stopBroadcast();

        console.log("Shuffler seed revealed successfully!");
        console.log("New shuffler seed value:", retroPunksContract.shufflerSeed());
    }

    /**
     * 5. Configure SeaDrop so public/user minting works.
     * @dev Call this after revealShufflerSeed(). Sets public drop window, mint price, creator payout, and optionally allowed fee recipient.
     *      Optional env: PUBLIC_MINT_PRICE (wei, default 0), PUBLIC_MAX_PER_WALLET (default 10).
     */
    function setupSeaDrop() external {
        uint256 mintPriceWei = vm.envOr("PUBLIC_MINT_PRICE", uint256(0));
        uint256 maxPerWallet = vm.envOr("PUBLIC_MAX_PER_WALLET", uint256(10));

        // Public drop: start now, end at max uint48 so drop stays open until you change it
        PublicDrop memory publicDrop = PublicDrop({
            mintPrice: uint80(mintPriceWei),
            startTime: uint48(block.timestamp),
            endTime: type(uint48).max,
            maxTotalMintableByWallet: uint16(maxPerWallet),
            feeBps: 0,
            restrictFeeRecipients: false
        });

        console.log("=== SeaDrop setup ===");
        console.log("RetroPunks:", RETROPUNKS);
        console.log("SeaDrop:", SEADROP);
        console.log("Mint price (wei):", publicDrop.mintPrice);
        console.log("Max per wallet:", publicDrop.maxTotalMintableByWallet);
        console.log("Creator payout:", OWNER);

        vm.startBroadcast(PRIVATE_KEY);

        retroPunksContract.updatePublicDrop(SEADROP, publicDrop);
        retroPunksContract.updateCreatorPayoutAddress(SEADROP, OWNER);

        vm.stopBroadcast();

        console.log("SeaDrop configured. You can now call mintAsUser().");
    }

    /**
     * 6. Batch owner mint to multiple addresses (optional).
     */
    function batchOwnerMint() external {
        address[] memory recipients = _toAddressArray(0x1006842663a46B628A823798De55FBb94b7AD4fb);
        uint256[] memory quantities = _toUintArray(5);

        console.log("=== Batch Owner Minting ===");
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

        console.log("Batch minting complete!");
        console.log("Total supply:", retroPunksContract.totalSupply());
    }

    /**
     * 7. Mint as a normal user via SeaDrop (optional). Requires setupSeaDrop() first.
     * @dev Set MINT_PRIVATE_KEY in env to mint as that account; otherwise PRIVATE_KEY. Set MINT_QUANTITY (default 1).
     */
    function mintAsUser() external {
        uint256 minterKey = PRIVATE_KEY;
        uint256 quantity = uint256(10);

        ISeaDrop seaDrop = ISeaDrop(SEADROP);
        PublicDrop memory publicDrop = seaDrop.getPublicDrop(RETROPUNKS);

        require(block.timestamp >= publicDrop.startTime, "Public drop not started");
        require(block.timestamp <= publicDrop.endTime, "Public drop ended");

        address feeRecipient = seaDrop.getCreatorPayoutAddress(RETROPUNKS);
        uint256 value = uint256(publicDrop.mintPrice) * quantity;

        address minter = vm.addr(minterKey);
        console.log("=== SeaDrop Public Mint (as user) ===");
        console.log("RetroPunks:", RETROPUNKS);
        console.log("SeaDrop:", SEADROP);
        console.log("Minter:", minter);
        console.log("Quantity:", quantity);
        console.log("Value (wei):", value);

        vm.startBroadcast(minterKey);

        seaDrop.mintPublic{ value: value }(RETROPUNKS, feeRecipient, address(0), quantity);

        vm.stopBroadcast();

        console.log("Mint complete! Total supply:", retroPunksContract.totalSupply());
    }

    /**
     * 8. Reveal the global seed (affects all token traits). Optional, run when ready.
     */
    function revealGlobalSeed() external {
        console.log("=== Revealing Global Seed ===");
        console.log("RetroPunks:", RETROPUNKS);
        console.log("Global Seed:", GLOBAL_SEED);
        console.log("Global Nonce:", GLOBAL_NONCE);

        vm.startBroadcast(PRIVATE_KEY);

        retroPunksContract.revealGlobalSeed(GLOBAL_SEED, GLOBAL_NONCE);

        vm.stopBroadcast();

        console.log("Global seed revealed successfully!");
        console.log("New global seed value:", retroPunksContract.globalSeed());
    }

    /**
     * 9. Set the reveal MetaGen (makes metadata visible). Optional, call when you want to reveal.
     */
    function setRevealMetaGen() external {
        console.log("=== Setting Reveal MetaGen ===");
        console.log("RetroPunks:", RETROPUNKS);
        console.log("New MetaGen:", META_GEN);

        vm.startBroadcast(PRIVATE_KEY);

        retroPunksContract.setMetaGen(IMetaGen(META_GEN), true);

        vm.stopBroadcast();

        console.log("Reveal contract MetaGen set successfully!");
        console.log("New MetaGen:", address(retroPunksContract.metaGen()));
    }

    /**
     * 10. Close minting permanently (irreversible). Optional, when done.
     */
    function closeMint() external {
        console.log("=== Closing Mint ===");
        console.log("RetroPunks:", RETROPUNKS);
        console.log("Current total supply:", retroPunksContract.totalSupply());
        console.log("WARNING: This action is irreversible!");

        vm.startBroadcast(PRIVATE_KEY);

        retroPunksContract.closeMint();

        vm.stopBroadcast();

        console.log("Minting closed successfully!");
        console.log("Mint status:", retroPunksContract.mintIsClosed());
    }

    /**
     * @notice Customize a token's metadata
     * @dev Token owner can call this after reveal
     */
    function customizeToken() external {
        address tokenOwner = vm.addr(PRIVATE_KEY);

        uint256 tokenId = 3;
        string memory name = "Bach";
        string memory bio = "Legendary musician & composer of the Baroque era.";
        uint8 backgroundIndex = 8;

        console.log("=== Customizing Token ===");
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

        console.log("Token customized successfully!");

        console.log("Background:", bg);
        console.logBytes32(storedName);
        console.log("Bio:", storedBio);
    }

    /**
     * @notice Query token URI
     */
    function queryTokenURI(uint256 _tokenId) external {
        string memory uri = retroPunksContract.tokenURI(_tokenId);
        console.log("\n", uri, "\n");
    }

    /**
     * @notice Batch query token URI
     * @dev Query token URIs in a batch and write them to a txt file instead of logging in console
     */
    function batchQueryTokenURI(uint256 _startTokenId, uint256 _endTokenId) external {
        string memory fileName = "tokenUriBatch.txt";

        vm.writeFile(fileName, "");

        for (uint256 i = _startTokenId; i <= _endTokenId; i++) {
            string memory line = string.concat("Token ", vm.toString(i), ":\n", retroPunksContract.tokenURI(i), "\n");

            vm.writeLine(fileName, line);
        }

        console.log(string.concat("Token URIs written to file: ", fileName));
    }

    // =============================== EXTRA / QUERY FUNCTIONS =============================== //

    /**
     * @notice Query token information
     * @dev Read token data without modifying state
     */
    function queryTokenDetails(uint256 _tokenId) external {
        console.log("=== Token Information ===");
        console.log("Token ID:", _tokenId);

        try retroPunksContract.ownerOf(_tokenId) returns (address owner) {
            console.log("Owner:", owner);

            // Get metadata
            (, uint8 bg, bytes32 name, string memory bio) = retroPunksContract.globalTokenMetadata(_tokenId);

            console.log("Background Index:", bg);
            console.logBytes32(name);
            console.log("Bio:", bio);

            string memory uri = retroPunksContract.tokenURI(_tokenId);
            console.log("Token URI length:", bytes(uri).length);
        } catch {
            console.log("Token does not exist");
        }
    }

    /**
     * @notice Query contract state
     */
    function queryContractDetails() external {
        console.log("=== Contract State ===");
        console.log("Contract:", RETROPUNKS);
        console.log("Name:", retroPunksContract.name());
        console.log("Symbol:", retroPunksContract.symbol());
        console.log("Max Supply:", retroPunksContract.maxSupply());
        console.log("Total Supply:", retroPunksContract.totalSupply());
        console.log("Global Seed:", retroPunksContract.globalSeed());
        console.log("Shuffler Seed:", retroPunksContract.shufflerSeed());
        console.log("MetaGen:", address(retroPunksContract.metaGen()));
        console.log("Mint Is Closed:", retroPunksContract.mintIsClosed());
    }

    /**
     * @notice Query all tokens owned by an address
     */
    function queryOwnerTokens() external {
        console.log("=== Owner Tokens ===");
        console.log("Owner:", OWNER);
        console.log("Balance:", retroPunksContract.balanceOf(OWNER));

        try retroPunksContract.tokensOfOwner(OWNER) returns (uint256[] memory tokenIds) {
            console.log("Token IDs owned:");
            for (uint256 i = 0; i < tokenIds.length; i++) {
                console.log("  -", tokenIds[i]);
            }
        } catch {
            console.log("Cannot query all tokens (may need to use tokensOfOwnerIn)");
        }
    }

    /**
     * @notice Verify special tokens distribution
     * @dev Check how many special tokens (seeds 0-15) have been minted
     */
    function analyzeSpecialTokens() external {
        uint256 totalSupply = retroPunksContract.totalSupply();

        console.log("=== Special Tokens Analysis ===");
        console.log("Total Supply:", totalSupply);

        uint256 preRenderedCount = 0; // Seeds 0-6
        uint256 specialCount = 0; // Seeds 7-15
        uint256 regularCount = 0; // Seeds 16+

        for (uint256 i = 1; i <= totalSupply; i++) {
            (uint16 seed,,,) = retroPunksContract.globalTokenMetadata(i);

            if (seed < 7) {
                preRenderedCount++;
                console.log(string.concat("Token ", vm.toString(i), " - Pre-rendered Special (Seed: ", vm.toString(seed), ")"));
            } else if (seed < 16) {
                specialCount++;
                console.log(string.concat("Token ", vm.toString(i), " - Special (Seed: ", vm.toString(seed), ")"));
            } else {
                regularCount++;
            }
        }

        console.log("=== Summary ===");
        console.log("Pre-rendered Specials (0-6):", preRenderedCount);
        console.log("Specials (7-15):", specialCount);
        console.log("Regular tokens:", regularCount);
    }

    /**
     * @notice Complete deployment workflow (runs steps 1–5 in order)
     * @dev Does not run addAssetsBatch/verifyAssets (run those separately). Includes SeaDrop setup.
     */
    function fullDeploymentWorkflow() external {
        console.log("=== FULL DEPLOYMENT WORKFLOW ===");

        console.log("\n1. Deploying contract...");
        this.deploy();

        console.log("\n2. Revealing shuffler seed (required for minting)...");
        this.revealShufflerSeed();

        console.log("\n3. Configuring SeaDrop (public drop)...");
        this.setupSeaDrop();

        console.log("\n4. (Optional) Run batchOwnerMint() or mintAsUser() to mint.");
        console.log("\n5. (Optional) revealGlobalSeed() then setRevealMetaGen() when ready.");

        console.log("\n=== SETUP COMPLETE ===");
        console.log("Contract is ready. Run addAssetsBatch(), verifyAssets(), then mint.");
    }

    function _verifyDeployment() internal view {
        console.log("\n=== Deployment Verification ===");

        require(address(retroPunksContract) != address(0), "Deployment failed");
        require(retroPunksContract.maxSupply() == MAX_SUPPLY, "Max supply mismatch");
        require(retroPunksContract.COMMITTED_GLOBAL_SEED_HASH() == GLOBAL_SEED_HASH, "Global seed hash mismatch");
        require(retroPunksContract.COMMITTED_SHUFFLER_SEED_HASH() == SHUFFLER_SEED_HASH, "Shuffler seed hash mismatch");

        console.log("All deployment checks passed!");
    }

    function _saveDeploymentInfo() internal {
        string memory deploymentInfo = string(
            abi.encodePacked(
                "RetroPunks Deployment\n",
                "=====================\n",
                "Contract Address: ",
                vm.toString(address(retroPunksContract)),
                "\n",
                "MetaGen: ",
                vm.toString(address(retroPunksContract.metaGen())),
                "\n",
                "Max Supply: ",
                vm.toString(retroPunksContract.maxSupply()),
                "\n",
                "\n",
                "IMPORTANT - SAVE THESE SEEDS SECURELY:\n",
                "Global Seed: ",
                vm.toString(retroPunksContract.globalSeed()),
                "\n",
                "Shuffler Seed: ",
                vm.toString(retroPunksContract.shufflerSeed()),
                "\n"
            )
        );

        console.log("\n", deploymentInfo);

        // Optionally write to file
        // vm.writeFile("deployment.txt", deploymentInfo);
    }
}
