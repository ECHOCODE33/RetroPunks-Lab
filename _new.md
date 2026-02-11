## Script 

 forge script script/RetroPunks.s.sol:RetroPunksScript \
  --sig "batchQueryTokenURI(uint256, uint256)" 1 5 \
  --rpc-url $BASE_MAINNET_RPC \
  --private-key $PRIVATE_KEY \
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
  --sig "setRevealMetaGen" \
  --sig "setDefaultBackgroundIndex(uint8) 2 " \

  --sig "customizeToken" \

  --sig "batchQueryTokenURI(uint256, uint256)" 1 5 \
  

## Cast
 cast call $RETROPUNKS "totalSupply()(uint256)" --rpc-url $BASE_MAINNET_RPC
