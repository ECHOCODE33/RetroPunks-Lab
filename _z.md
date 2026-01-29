Anvil Address: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266

Ethereum Address: 0x6A5ebe005B8Ef3d8ACdA293EFE5CD956a46b2457

Shuffler Hash: 0xd6442301597d77dcdb21fa2d27886320d5b2bc3b61b6ac2beb724dcde2def767

Global Hash: 0x861d6d3262faea3db1f567a2e0f4a592952a28e94dd68aa49dcb7347ae64d814

forge test test/TraitsLoader.t.sol -vv

forge test --match-test test_DeepLoadAndLogTraitGroup -vv

forge test --match-test testFlzCompress -vv

forge test --match-test testFuzz_Simulate -vv

forge create src/RetroPunks.sol:RetroPunks --rpc-url $RPC_URL --simulate

forge test --match-path test/Deploy.t.sol --gas-report







forge script script/Deploy.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast -v

forge script script/AddAssetsBatch.s.sol:AddAssetsBatch --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast -v

forge script script/VerifyAssets.s.sol:VerifyAssets --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast -v

forge script script/RevealShufflerSeed.s.sol:RevealShufflerSeed --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast -v

forge script script/Mint.s.sol:Mint --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast -v

forge script script/ViewTokenURI.s.sol:ViewTokenURI --rpc-url $RPC_URL -v

forge script script/TokenURIBatchTest.s.sol:TokenURIBatchTest --rpc-url $RPC_URL -v

forge script script/RenamePunk.s.sol:RenamePunkScript --rpc-url $RPC_URL --broadcast -vv






## Anvil

forge script script/Deploy.s.sol --rpc-url $RPC_URL --private-key $PK --broadcast -v

forge script script/AddAssetsBatch.s.sol:AddAssetsBatch --rpc-url $RPC_URL --private-key $PK --broadcast -v

forge script script/VerifyAssets.s.sol:VerifyAssets --rpc-url $RPC_URL --private-key $PK --broadcast -v

forge script script/RevealShufflerSeed.s.sol:RevealShufflerSeed --rpc-url $RPC_URL --private-key $PK --broadcast -v

forge script script/Mint.s.sol:Mint --rpc-url $RPC_URL --private-key $PK --broadcast -v

forge script script/ViewTokenURI.s.sol:ViewTokenURI --rpc-url $RPC_URL -v

forge script script/TokenURIBatchTest.s.sol:TokenURIBatchTest --rpc-url $RPC_URL -v

forge script script/DeployAndSetRenderer.s.sol:DeployAndSetRenderer --rpc-url $RPC_URL --private-key $PK -broadcast -vv

forge script script/RenamePunk.s.sol:RenamePunkScript --rpc-url $RPC_URL --broadcast -vv


cast call 0x5FC8d32690cc91D4c39d9d3abcBD16989F875707 "tokenURI(uint256)(string)" 5 --rpc-url $RPC_URL --gas-limit 100000000


## == Anvil Logs ==
  Assets:: 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
  Traits: 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
  PreRevealSVGRenderer: 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
  SVGRenderer: 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9
  RetroPunks: 0x5FC8d32690cc91D4c39d9d3abcBD16989F875707





forge script script/Deploy.s.sol \
 --rpc-url $SEPOLIA_RPC_URL \
 --private-key $PRIVATE_KEY \
 --broadcast \
 --verify \
 --etherscan-api-key $ETHERSCAN_API_KEY \
 -v

forge script script/AddAssetsBatch.s.sol:AddAssetsBatch \
 --rpc-url $SEPOLIA_RPC_URL \
 --private-key $PRIVATE_KEY \
 --broadcast \
 --verify \
 -v

forge script script/VerifyAssets.s.sol:VerifyAssets \
 --rpc-url $SEPOLIA_RPC_URL \
 --private-key $PRIVATE_KEY \
 --broadcast -v

forge script script/RevealShufflerSeed.s.sol:RevealShufflerSeed \
 --rpc-url $SEPOLIA_RPC_URL \
 --private-key $PRIVATE_KEY \
 --broadcast \
 --verify \
 -v


forge script script/Mint.s.sol:Mint \
 --rpc-url $SEPOLIA_RPC_URL \
 --private-key $PRIVATE_KEY \
 --broadcast \
 --verify \
 --etherscan-api-key $ETHERSCAN_API_KEY \
 -v

 forge script script/DeployAndSetRenderer.s.sol:DeployAndSetRenderer \
    --rpc-url $SEPOLIA_RPC_URL \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    -v

forge script script/ViewTokenURI.s.sol:ViewTokenURI \
 --rpc-url $SEPOLIA_RPC_URL \
 -v

forge script script/TokenURIBatchTest.s.sol:TokenURIBatchTest \
 --rpc-url $SEPOLIA_RPC_URL \
 -v



## == Logs ==
  Assets:: 0x1846489d864a104e0AAE6979A77852D05b052AE2
  Traits: 0x6B8B7B5AE320cDfa2cA27b7dd7ddF8bdf5cd4373
  PreRevealSVGRenderer: 0x58BC4bbC9D0ADf6f2308C0588A77Be4Dc9Fbc4a8
  SVGRenderer: 0x6871bbE4A8DcFe8F7F8846910fd6646058e3439C
  RetroPunks: 0x206540a2344349D422A7A872Bb607139321c0b53





forge verify-contract 0x50351EE22258b3E6B5C193F65F60dEf3bfB155b4 \
    src/RetroPunks.sol:RetroPunks \
    --chain-id 11155111 \
    --constructor-args $(cast abi-encode "constructor(address,bytes32,bytes32,uint256,address[])" \
    0x408aeE13780aAFDE334Ecf6cCb0755f54c71b0AA \
    0x86ba95a5960d357e5c15f72276140fdd48db55aa23fe629e151729f9dc8e9858 \
    0x6fa95066f3aaa16a87828ec493070f57934dbbcb37d1e6881fe7aaf8b35d4671 \
    10000 \
    "[0x00005EA00Ac477B1030CE78506496e8C2dE24bf5]") \
    --etherscan-api-key $ETHERSCAN_API_KEY \
    --watch








forge script script/Deploy.s.sol \
 --rpc-url http://localhost:3001/api/rpc \
 --broadcast \
 --sender 0x6A5ebe005B8Ef3d8ACdA293EFE5CD956a46b2457 \
 --unlocked \
 --verify \ 
 --etherscan-api-key $ETHERSCAN_API_KEY \
 -v




forge script script/Deploy.s.sol \
 --rpc-url http://localhost:3001/api/rpc \
 --broadcast \
 --sender 0x6A5ebe005B8Ef3d8ACdA293EFE5CD956a46b2457 \
 --unlocked \
 --verify \
 --verifier-url 'https://api.etherscan.io/v2/api?chainid=8453' \
 --etherscan-api-key $ETHERSCAN_API_KEY \
 --timeout 300 \
 -v



/---------------------------------------------------------|
|-------------------- SEPOLIA TESTING --------------------|
|---------------------------------------------------------|

