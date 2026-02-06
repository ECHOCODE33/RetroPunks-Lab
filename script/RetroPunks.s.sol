// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { Assets } from "../src/Assets.sol";
import { IMetaGen } from "../src/interfaces/IMetaGen.sol";
// import { Rarities } from "../src/Rarities.sol";
import { PreviewMetaGen } from "../src/PreviewMetaGen.sol";
import { RetroPunks } from "../src/RetroPunks.sol";
import { MetaGen } from "../src/MetaGen.sol";
import { Traits } from "../src/Traits.sol";

contract HelperContract is Script {
    function _toAddressArray(address a1) internal pure returns (address[] memory arr) {
        arr = new address[](1);
        arr[0] = a1;
    }

    function _toAddressArray(address a1, address a2) internal pure returns (address[] memory arr) {
        arr = new address[](2);
        arr[0] = a1;
        arr[1] = a2;
    }

    function _toAddressArray(address a1, address a2, address a3) internal pure returns (address[] memory arr) {
        arr = new address[](3);
        arr[0] = a1;
        arr[1] = a2;
        arr[2] = a3;
    }

    function _toAddressArray(address a1, address a2, address a3, address a4) internal pure returns (address[] memory arr) {
        arr = new address[](4);
        arr[0] = a1;
        arr[1] = a2;
        arr[2] = a3;
        arr[3] = a4;
    }

    function _toAddressArray(address a1, address a2, address a3, address a4, address a5) internal pure returns (address[] memory arr) {
        arr = new address[](5);
        arr[0] = a1;
        arr[1] = a2;
        arr[2] = a3;
        arr[3] = a4;
        arr[4] = a5;
    }

    function _toAddressArray(address a1, address a2, address a3, address a4, address a5, address a6) internal pure returns (address[] memory arr) {
        arr = new address[](6);
        arr[0] = a1;
        arr[1] = a2;
        arr[2] = a3;
        arr[3] = a4;
        arr[4] = a5;
        arr[5] = a6;
    }

    function _toAddressArray(address a1, address a2, address a3, address a4, address a5, address a6, address a7) internal pure returns (address[] memory arr) {
        arr = new address[](7);
        arr[0] = a1;
        arr[1] = a2;
        arr[2] = a3;
        arr[3] = a4;
        arr[4] = a5;
        arr[5] = a6;
        arr[6] = a7;
    }

    function _toAddressArray(address a1, address a2, address a3, address a4, address a5, address a6, address a7, address a8) internal pure returns (address[] memory arr) {
        arr = new address[](8);
        arr[0] = a1;
        arr[1] = a2;
        arr[2] = a3;
        arr[3] = a4;
        arr[4] = a5;
        arr[5] = a6;
        arr[6] = a7;
        arr[7] = a8;
    }

    function _toAddressArray(address a1, address a2, address a3, address a4, address a5, address a6, address a7, address a8, address a9)
        internal
        pure
        returns (address[] memory arr)
    {
        arr = new address[](9);
        arr[0] = a1;
        arr[1] = a2;
        arr[2] = a3;
        arr[3] = a4;
        arr[4] = a5;
        arr[5] = a6;
        arr[6] = a7;
        arr[7] = a8;
        arr[8] = a9;
    }

    function _toAddressArray(address a1, address a2, address a3, address a4, address a5, address a6, address a7, address a8, address a9, address a10)
        internal
        pure
        returns (address[] memory arr)
    {
        arr = new address[](10);
        arr[0] = a1;
        arr[1] = a2;
        arr[2] = a3;
        arr[3] = a4;
        arr[4] = a5;
        arr[5] = a6;
        arr[6] = a7;
        arr[7] = a8;
        arr[8] = a9;
        arr[9] = a10;
    }

    function _toUintArray(uint256 u1) internal pure returns (uint256[] memory arr) {
        arr = new uint256[](1);
        arr[0] = u1;
    }

    function _toUintArray(uint256 u1, uint256 u2) internal pure returns (uint256[] memory arr) {
        arr = new uint256[](2);
        arr[0] = u1;
        arr[1] = u2;
    }

    function _toUintArray(uint256 u1, uint256 u2, uint256 u3) internal pure returns (uint256[] memory arr) {
        arr = new uint256[](3);
        arr[0] = u1;
        arr[1] = u2;
        arr[2] = u3;
    }

    function _toUintArray(uint256 u1, uint256 u2, uint256 u3, uint256 u4) internal pure returns (uint256[] memory arr) {
        arr = new uint256[](4);
        arr[0] = u1;
        arr[1] = u2;
        arr[2] = u3;
        arr[3] = u4;
    }

    function _toUintArray(uint256 u1, uint256 u2, uint256 u3, uint256 u4, uint256 u5) internal pure returns (uint256[] memory arr) {
        arr = new uint256[](5);
        arr[0] = u1;
        arr[1] = u2;
        arr[2] = u3;
        arr[3] = u4;
        arr[4] = u5;
    }

    function _toUintArray(uint256 u1, uint256 u2, uint256 u3, uint256 u4, uint256 u5, uint256 u6) internal pure returns (uint256[] memory arr) {
        arr = new uint256[](6);
        arr[0] = u1;
        arr[1] = u2;
        arr[2] = u3;
        arr[3] = u4;
        arr[4] = u5;
        arr[5] = u6;
    }

    function _toUintArray(uint256 u1, uint256 u2, uint256 u3, uint256 u4, uint256 u5, uint256 u6, uint256 u7) internal pure returns (uint256[] memory arr) {
        arr = new uint256[](7);
        arr[0] = u1;
        arr[1] = u2;
        arr[2] = u3;
        arr[3] = u4;
        arr[4] = u5;
        arr[5] = u6;
        arr[6] = u7;
    }

    function _toUintArray(uint256 u1, uint256 u2, uint256 u3, uint256 u4, uint256 u5, uint256 u6, uint256 u7, uint256 u8) internal pure returns (uint256[] memory arr) {
        arr = new uint256[](8);
        arr[0] = u1;
        arr[1] = u2;
        arr[2] = u3;
        arr[3] = u4;
        arr[4] = u5;
        arr[5] = u6;
        arr[6] = u7;
        arr[7] = u8;
    }

    function _toUintArray(uint256 u1, uint256 u2, uint256 u3, uint256 u4, uint256 u5, uint256 u6, uint256 u7, uint256 u8, uint256 u9)
        internal
        pure
        returns (uint256[] memory arr)
    {
        arr = new uint256[](9);
        arr[0] = u1;
        arr[1] = u2;
        arr[2] = u3;
        arr[3] = u4;
        arr[4] = u5;
        arr[5] = u6;
        arr[6] = u7;
        arr[7] = u8;
        arr[8] = u9;
    }

    function _toUintArray(uint256 u1, uint256 u2, uint256 u3, uint256 u4, uint256 u5, uint256 u6, uint256 u7, uint256 u8, uint256 u9, uint256 u10)
        internal
        pure
        returns (uint256[] memory arr)
    {
        arr = new uint256[](10);
        arr[0] = u1;
        arr[1] = u2;
        arr[2] = u3;
        arr[3] = u4;
        arr[4] = u5;
        arr[5] = u6;
        arr[6] = u7;
        arr[7] = u8;
        arr[8] = u9;
        arr[9] = u10;
    }
}

contract RetroPunksScript is HelperContract {
    address public OWNER = vm.envAddress("OWNER");
    uint256 internal PRIVATE_KEY = vm.envUint("PRIVATE_KEY");
    address public ASSETS = vm.envAddress("ASSETS");
    address public TRAITS = vm.envAddress("TRAITS");
    address public PRE_REVEAL_SVG_RENDERER = vm.envAddress("PRE_REVEAL_SVG_RENDERER");
    address public SVG_RENDERER = vm.envAddress("SVG_RENDERER");
    address public RETROPUNKS = vm.envAddress("RETROPUNKS");

    RetroPunks public retroPunksContract = RetroPunks(RETROPUNKS);
    IMetaGen public rendererContract;

    uint256 public MAX_SUPPLY = 10000;
    uint256 public GLOBAL_SEED = 6397004135;
    uint256 public GLOBAL_NONCE = 5291012319;
    bytes32 public GLOBAL_SEED_HASH = keccak256(abi.encodePacked(GLOBAL_SEED, GLOBAL_NONCE));
    uint256 public SHUFFLER_SEED = 2401460252;
    uint256 public SHUFFLER_NONCE = 8904927786;
    bytes32 public SHUFFLER_SEED_HASH = keccak256(abi.encodePacked(SHUFFLER_SEED, SHUFFLER_NONCE));

    /**
     * @notice Main deployment function
     * @dev Run with: forge script script/RetroPunks.s.sol:RetroPunksScript --sig "deploy()" --rpc-url <RPC_URL> --broadcast
     */
    function deploy() external {
        vm.startBroadcast();

        address[] memory allowedSeaDrop = new address[](1);
        allowedSeaDrop[0] = 0x00005EA00Ac477B1030CE78506496e8C2dE24bf5;

        Assets assets = new Assets();
        Traits traits = new Traits();
        PreviewMetaGen preRevealRenderer = new PreviewMetaGen(Assets(address(assets)));
        MetaGen renderer = new MetaGen(Assets(address(assets)), Traits(address(traits)));
        RetroPunks retroPunks = new RetroPunks(PreviewMetaGen(address(preRevealRenderer)), GLOBAL_SEED_HASH, SHUFFLER_SEED_HASH, MAX_SUPPLY, allowedSeaDrop);

        console.log("Assets::", address(assets));
        console.log("Traits:", address(traits));
        console.log("PreviewMetaGen:", address(preRevealRenderer));
        console.log("MetaGen:", address(renderer));
        console.log("RetroPunks:", address(retroPunks));

        vm.stopBroadcast();
    }

    /**
     * @notice Reveal the global seed (affects all token traits)
     * @dev Run after minting starts but before full reveal
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
     * @notice Reveal the shuffler seed (required before any minting)
     * @dev Run this FIRST before allowing any mints
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
     * @notice Set the reveal rendererContract (makes metadata visible)
     * @dev Call this when you want to reveal all token metadata
     */
    function setRevealRenderer() external {
        console.log("=== Setting Reveal Renderer ===");
        console.log("RetroPunks:", RETROPUNKS);
        console.log("New Renderer:", SVG_RENDERER);

        vm.startBroadcast(PRIVATE_KEY);

        retroPunksContract.setRenderer(IMetaGen(SVG_RENDERER), true);

        vm.stopBroadcast();

        console.log("Reveal contract MetaGen set successfully!");
    }

    /**
     * @notice Batch owner mint to multiple addresses
     * @dev Useful for team allocation, airdrops, etc.
     */
    function batchOwnerMint() external {
        address[] memory recipients = _toAddressArray(OWNER);
        uint256[] memory quantities = _toUintArray(11);

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
     * @notice Close minting permanently
     * @dev This is irreversible - use with caution
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
     * @notice Query token information
     * @dev Read token data without modifying state
     */
    function queryToken(uint256 _tokenId) external {
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
     * @notice Query token URI
     */
    function queryTokenURI(uint256 _tokenId) external {
        string memory uri = retroPunksContract.tokenURI(_tokenId);
        console.log("\n", uri, "\n");
    }

    /**
     * @notice Query contract state
     */
    function queryContractState() external {
        console.log("=== Contract State ===");
        console.log("Contract:", RETROPUNKS);
        console.log("Name:", retroPunksContract.name());
        console.log("Symbol:", retroPunksContract.symbol());
        console.log("Max Supply:", retroPunksContract.maxSupply());
        console.log("Total Supply:", retroPunksContract.totalSupply());
        console.log("Global Seed:", retroPunksContract.globalSeed());
        console.log("Shuffler Seed:", retroPunksContract.shufflerSeed());
        console.log("Renderer:", address(retroPunksContract.renderer()));
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
     * @notice Complete deployment workflow
     * @dev Runs through the entire setup process
     */
    function fullDeploymentWorkflow() external {
        console.log("=== FULL DEPLOYMENT WORKFLOW ===");

        // Step 1: Deploy
        console.log("\n1. Deploying contract...");
        this.deploy();

        // Step 2: Reveal shuffler seed (required for minting)
        console.log("\n2. Revealing shuffler seed...");
        this.revealShufflerSeed();

        // Step 3: Owner mints (if desired)
        console.log("\n3. Performing owner mints...");
        // this.ownerMint(); // Uncomment and configure as needed

        // Step 4: Reveal global seed (for traits)
        console.log("\n4. Revealing global seed...");
        this.revealGlobalSeed();

        // Step 5: Set reveal rendererContract
        console.log("\n5. Setting reveal rendererContract...");
        // this.setRevealRenderer(); // Uncomment when ready

        console.log("\n=== DEPLOYMENT COMPLETE ===");
        console.log("Contract is ready for public minting!");
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
                "Renderer: ",
                vm.toString(address(retroPunksContract.renderer())),
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
