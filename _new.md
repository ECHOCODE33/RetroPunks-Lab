## Anvil (Local)

### Script 

 forge script script/RetroPunks.s.sol:RetroPunksScript \
  --sig "deploy()" \
  --rpc-url $BASE_SEPOLIA_RPC \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --ffi \
  -vvv

  
 cast call $RETROPUNKS "totalSupply()(uint256)" 5 --rpc-url $BASE_SEPOLIA_RPC


### Deploy

forge script script/Deploy.s.sol:Deploy \
 --rpc-url localhost \
 --private-key $ANVIL_PRIVATE_KEY \
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
 --private-key $ANVIL_PRIVATE_KEY \
 --broadcast \
 -vvv

### Reveal Shuffler Seed

forge script script/RevealShufflerSeed.s.sol:RevealShufflerSeed \
 --rpc-url localhost \
 --private-key $ANVIL_PRIVATE_KEY \
 --broadcast \
 -vvv

### Mint

forge script script/Mint.s.sol:Mint \
 --rpc-url localhost \
 --private-key $ANVIL_PRIVATE_KEY \
 --broadcast \
 -vvv

### Deploy and Set Renderer

forge script script/DeployAndSetRenderer.s.sol:DeployAndSetRenderer \
 --rpc-url localhost \
 --private-key $ANVIL_PRIVATE_KEY \
 --broadcast \
 -vvv

### View Token URI (read-only)

forge script script/ViewTokenURI.s.sol:ViewTokenURI \
 --rpc-url localhost \
 -vvv

### Batch View Token URI (read-only)

forge script script/TokenUriBatch.s.sol:TokenUriBatch --rpc-url localhost -vvv

## Stuck Fix

cast send 0x6a5ebe005b8ef3d8acda293efe5cd956a46b2457 \ --value 0 \  
 --rpc-url $SEPOLIA_RPC_URL \
 --private-key $PRIVATE_KEY \
 --gas-price 5000000000 \
 --legacy

## Sepolia

### Deploy

forge script script/Deploy.s.sol \
 --rpc-url $SEPOLIA_RPC_URL \
 --private-key $PRIVATE_KEY \
 --broadcast \
 --verify \
 --slow \
 -vvv

### Add Assets Batch

forge script script/AddAssetsBatch.s.sol:AddAssetsBatch \
 --rpc-url "$SEPOLIA_RPC_URL" \
    --private-key "$PRIVATE_KEY" \
 --broadcast \
 --verify \
 --slow \
 --priority-gas-price 2000000000 \
 --with-gas-price 8000000000 \
 -vvv

### Verify Assets

forge script script/VerifyAssets.s.sol:VerifyAssets \
 --rpc-url "$SEPOLIA_RPC_URL" \
    --private-key "$PRIVATE_KEY" \
 --broadcast \
 --verify \
 --slow \
 -vvv

### Reveal Global Seed

forge script script/RevealGlobalSeed.s.sol:RevealGlobalSeed \
 --rpc-url "$SEPOLIA_RPC_URL" \
    --private-key "$PRIVATE_KEY" \
 --broadcast \
 --verify \
 --slow \
 --priority-gas-price 1000000000 \
 --with-gas-price 5000000000 \
 -vvv

### Reveal Shuffler Seed

forge script script/RevealShufflerSeed.s.sol:RevealShufflerSeed \
 --rpc-url "$SEPOLIA_RPC_URL" \
    --private-key "$PRIVATE_KEY" \
 --broadcast \
 --verify \
 --slow \
 --priority-gas-price 1000000000 \
 --with-gas-price 5000000000 \
 -vvv

### Mint

forge script script/Mint.s.sol:Mint \
 --rpc-url "$SEPOLIA_RPC_URL" \
    --private-key "$PRIVATE_KEY" \
 --broadcast \
 --verify \
 --slow \
 --priority-gas-price 1000000000 \
 --with-gas-price 5000000000 \
 -vvv

### Deploy and Set Renderer

forge script script/DeployAndSetRenderer.s.sol:DeployAndSetRenderer \
 --rpc-url "$SEPOLIA_RPC_URL" \
    --private-key "$PRIVATE_KEY" \
 --broadcast \
 --verify \
 --slow \
 --priority-gas-price 1000000000 \
 --with-gas-price 5000000000 \
 -vvv

### View Token URI (read-only)

forge script script/ViewTokenURI.s.sol:ViewTokenURI \
 --rpc-url sepolia \
 -vvv

### Batch View Token URI (read-only)

forge script script/TokenUriBatch.s.sol:TokenUriBatch --rpc-url "$SEPOLIA_RPC_URL" -vvv > \_output.txt
