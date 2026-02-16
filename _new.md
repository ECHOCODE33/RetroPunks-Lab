## Script

 forge script script/RetroPunks.s.sol:RetroPunksScript \
  --sig "verifyAssets" \
  --rpc-url $BASE_MAINNET_RPC \
  --private-key =$PRIVATE_KEY \
  --broadcast \
  --verify \
  --ffi \
  -vvv


  --sig "deploy" \
  --sig "addAssetsBatch" \
  --sig "verifyAssets" \
  --sig "revealShufflerSeed" \
  --sig "setupSeaDrop" \
  --sig "batchOwnerMint" \
  --sig "mintAsUser" \

  --sig "revealGlobalSeed" \
  --sig "revealMetaGen" \

  --sig "customizeToken" \

  --sig "batchQueryTokenURI" \
  

## Cast
 cast call $RETROPUNKS "totalSupply()(uint256)" --rpc-url $BASE_MAINNET_RPC

 forge verify-contract \
  0x35a9bF0DbdcF7Dbb714739bFDb685830C8Be76a4 \
  src/RetroPunks.sol:RetroPunks \
  --chain-id 84532 \
  --etherscan-api-key $ETHERSCAN_API_KEY \
  --watch
