# RetroPunks-Lab

**On-chain generative NFT collection** with traits, backgrounds, and special characters. Built with Foundry, ERC721A, and [SeaDrop](https://github.com/ProjectOpenSea/seadrop). Metadata and SVG art are generated fully on-chain.

## Overview

RetroPunks is an NFT collection featuring:

- **Traits** — Male/female avatars with skin, eyes, face, hair, headwear, accessories, etc.
- **Backgrounds** — Solid, gradient (vertical/horizontal/diagonal), and image backgrounds.
- **Specials** — 16 pre-defined 1/1 characters (Predator Blue/Green/Red, Santa Claus, Shadow Ninja, The Devil, The Portrait, etc.).
- **Customization** — Token owners can set name, bio, and background after reveal.

Metadata is generated on-chain using committed seeds revealed post-mint for provably fair randomness.

## Project Structure

```
RetroPunks-Lab/
├── src/
│   ├── RetroPunks.sol          # Main NFT contract (ERC721 + SeaDrop)
│   ├── Assets.sol              # On-chain asset storage (SSTORE2 + LZ77)
│   ├── Traits.sol              # Trait generation and rarities
│   ├── MetaGen.sol             # SVG & JSON metadata generator
│   ├── PreviewMetaGen.sol      # Pre-reveal metadata
│   ├── Rarities.sol            # Rarity definitions
│   ├── common/                 # Enums, structs
│   ├── interfaces/             # IAssets, IMetaGen, ITraits
│   ├── libraries/              # LibPRNG, LibZip, TraitsLoader, TraitsRenderer, etc.
│   └── seadrop/                # SeaDrop integration
├── script/
│   ├── RetroPunks.s.sol        # Main deployment & ops script
│   ├── AddAssetsBatch.s.sol    # Batch upload compressed assets
│   └── VerifyAssets.s.sol      # Verify assets on-chain (view only)
├── lib/                        # Dependencies (ERC721A, OpenZeppelin, SeaDrop, Solady)
└── foundry.toml
```

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)

## Environment

Create a `.env` file in the project root (see `.gitignore`; do not commit secrets). Example variables:

```
PRIVATE_KEY=...
ASSETS=0x...
RETROPUNKS=0x...
META_GEN=0x...
LOCAL_RPC_URL=http://127.0.0.1:8545
SEPOLIA_RPC_URL=...
BASE_SEPOLIA_RPC_URL=...
```

Configured RPC endpoints: `localhost`, `mainnet`, `sepolia`, `base`, `base-sepolia`.

## Quick Start

### Build

```bash
forge build
```

### Deploy

```bash
forge script script/RetroPunks.s.sol:RetroPunksScript \
  --sig "deploy()" \
  --rpc-url $BASE_SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast \
  -vvv
```

### Post-Deploy Flow

1. **Add assets** — Upload trait and background assets to the `Assets` contract:
   ```bash
   forge script script/AddAssetsBatch.s.sol:AddAssetsBatch \
     --rpc-url localhost \
     --private-key $PRIVATE_KEY \
     --broadcast \
     -vvv
   ```

2. **Verify assets** — Ensure all expected assets are stored:
   ```bash
   forge script script/VerifyAssets.s.sol:VerifyAssets \
     --rpc-url localhost \
     -vvv
   ```
   (View-only; set `ASSETS` in `.env`.)

3. **Reveal shuffler seed** — Required before minting:
   ```bash
   forge script script/RetroPunks.s.sol:RetroPunksScript \
     --sig "revealShufflerSeed()" \
     --rpc-url localhost \
     --private-key $PRIVATE_KEY \
     --broadcast
   ```

4. **Mint** — Use `batchOwnerMint()` or SeaDrop-based public mint.

5. **Reveal global seed** — After minting, to fix trait randomness:
   ```bash
   forge script script/RetroPunks.s.sol:RetroPunksScript \
     --sig "revealGlobalSeed()" \
     --rpc-url localhost \
     --private-key $PRIVATE_KEY \
     --broadcast
   ```

6. **Set MetaGen** — Switch to the reveal `MetaGen` so metadata is visible:
   ```bash
   forge script script/RetroPunks.s.sol:RetroPunksScript \
     --sig "setRevealMetaGen()" \
     --rpc-url localhost \
     --private-key $PRIVATE_KEY \
     --broadcast
   ```

## Scripts

All main operations live in `RetroPunks.s.sol`:

| Function               | Description                                  |
|------------------------|----------------------------------------------|
| `deploy()`             | Deploy Assets, Traits, MetaGen, RetroPunks   |
| `addAssetsBatch()`     | FFI wrapper for AddAssetsBatch script        |
| `verifyAssets()`       | FFI wrapper for VerifyAssets script          |
| `revealShufflerSeed()` | Reveal shuffler seed (before mint)           |
| `revealGlobalSeed()`   | Reveal global seed (after mint)              |
| `batchOwnerMint()`     | Owner mint to multiple addresses             |
| `setRevealMetaGen()`   | Point RetroPunks to reveal MetaGen           |
| `customizeToken()`     | Update name, bio, background for a token     |
| `queryTokenURI()`      | Read token metadata URI                      |
| `batchQueryTokenURI()` | Batch query token URIs to file               |
| `closeMint()`          | Permanently close minting                    |

Example:

```bash
forge script script/RetroPunks.s.sol:RetroPunksScript \
  --sig "<functionName>()" \
  --rpc-url localhost \
  --private-key $PRIVATE_KEY \
  --broadcast
```

## Testing

```bash
forge test
```

## Format & Lint

```bash
forge fmt
forge build  # includes lint
```

## Dependencies

- [forge-std](https://github.com/foundry-rs/forge-std)
- [ERC721A](https://github.com/chiru-labs/ERC721A)
- [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)
- [SeaDrop](https://github.com/ProjectOpenSea/seadrop)
- [Solady](https://github.com/Vectorized/solady)

## License

MIT
