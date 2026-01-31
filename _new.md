## Sepolia

  ### Deploy
  forge script script/Deploy.s.sol \
    --rpc-url sepolia \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    --legacy \
    --with-gas-price 10000000
    -vvv

  ### Add Assets Batch
  forge script script/AddAssetsBatch.s.sol:AddAssetsBatch \
    --rpc-url sepolia \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    -vvv

  ### Verify Assets
  forge script script/VerifyAssets.s.sol:VerifyAssets \
    --rpc-url sepolia \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    -vvv

  ### Reveal Global Seed
  forge script script/RevealGlobalSeed.s.sol:RevealGlobalSeed \
    --rpc-url sepolia \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    -vvv

  ### Reveal Shuffler Seed
  forge script script/RevealShufflerSeed.s.sol:RevealShufflerSeed \
    --rpc-url sepolia \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    -vvv

  ### Mint
  forge script script/Mint.s.sol:Mint \
    --rpc-url sepolia \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    -vvv

  ### Deploy and Set Renderer
  forge script script/DeployAndSetRenderer.s.sol:DeployAndSetRenderer \
    --rpc-url sepolia \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    -vvv

  ### View Token URI (read-only)
  forge script script/ViewTokenURI.s.sol:ViewTokenURI \
    --rpc-url sepolia \
    -vvv

  ### Batch View Token URI (read-only)
  forge script script/TokenURIBatchTest.s.sol:TokenURIBatchTest --rpc-url sepolia -vvv


## Anvil (Local)

  ### Deploy
  forge script script/Deploy.s.sol \
    --rpc-url localhost \
    --private-key $PRIVATE_KEY \
    --broadcast \
    -vvv

  ### Add Assets Batch
  forge script script/AddAssetsBatch.s.sol:AddAssetsBatch \
    --rpc-url localhost \
    --private-key $PRIVATE_KEY \
    --broadcast \
    -vvv

  ### Verify Assets
  forge script script/VerifyAssets.s.sol:VerifyAssets \
    --rpc-url localhost \
    --private-key $PRIVATE_KEY \
    --broadcast \
    -vvv

  ### Reveal Global Seed
  forge script script/RevealGlobalSeed.s.sol:RevealGlobalSeed \
    --rpc-url localhost \
    --private-key $PRIVATE_KEY \
    --broadcast \
    -vvv

  ### Reveal Shuffler Seed
  forge script script/RevealShufflerSeed.s.sol:RevealShufflerSeed \
    --rpc-url localhost \
    --private-key $PRIVATE_KEY \
    --broadcast \
    -vvv

  ### Mint
  forge script script/Mint.s.sol:Mint \
    --rpc-url localhost \
    --private-key $PRIVATE_KEY \
    --broadcast \
    -vvv

  ### Deploy and Set Renderer
  forge script script/DeployAndSetRenderer.s.sol:DeployAndSetRenderer \
    --rpc-url localhost \
    --private-key $PRIVATE_KEY \
    --broadcast \
    -vvv

  ### View Token URI (read-only)
  forge script script/ViewTokenURI.s.sol:ViewTokenURI \
    --rpc-url localhost \
    -vvv

  ### Batch View Token URI (read-only)
  forge script script/TokenUriBatch.s.sol:TokenUriBatch --rpc-url localhost -vvv

## Batch Gas (1 gwei)
  1: 37196074, 0.037196074 ETH
  5: 35713343, 0.035713343 ETH
  10: 36087191, 0.036087191 ETH
  15: 36384660, 0.03638466 ETH
  20: 35289028, 0.035289028 ETH
