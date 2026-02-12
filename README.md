# RetroPunks-Lab

**On-chain generative NFT collection** with traits, backgrounds, and special characters. Built with Foundry, ERC721A, and [SeaDrop](https://github.com/ProjectOpenSea/seadrop). Metadata and SVG art are generated fully on-chain.

## Overview

RetroPunks is an NFT collection featuring:

- **Traits** — Male/female avatars with skin, eyes, face, hair, headwear, accessories, etc.
- **Backgrounds** — Solid, gradient (vertical/horizontal/diagonal), and image backgrounds.
- **Specials** — 16 pre-defined 1/1 characters (Predator Blue/Green/Red, Santa Claus, Shadow Ninja, The Devil, The Portrait, etc.).
- **Customization** — Token owners can set name, bio, and background after reveal.

Metadata is generated on-chain using committed seeds revealed post-mint for provably fair randomness.

## Project Tree Structure

```
RetroPunks-Lab/
├── README.md
├── foundry.lock
├── foundry.toml
├── lib
│   ├── ERC721A
│   ├── forge-std
│   ├── openzeppelin-contracts
│   ├── seadrop
│   └── solady
├── python
│   ├── _BackgroundAssetUltimate.py
│   ├── _GradientPaletteUltimate2.py
│   ├── _SpecialAsset.py
│   ├── _TraitsAsset.py
│   ├── gif.py
│   └── suggest-background.py
├── script
│   ├── AddAssetsBatch.s.sol
│   ├── RetroPunks.s.sol
│   └── VerifyAssets.s.sol
├── src
│   ├── Assets.sol
│   ├── MetaGen.sol
│   ├── PreviewMetaGen.sol
│   ├── Rarities.sol
│   ├── RetroPunks.sol
│   ├── Traits.sol
│   ├── global
│   │   ├── Enums.sol
│   │   └── Structs.sol
│   ├── interfaces
│   │   ├── IAssets.sol
│   │   ├── IMetaGen.sol
│   │   ├── IRetroPunksTypes.sol
│   │   └── ITraits.sol
│   ├── libraries
│   │   ├── DynamicBuffer.sol
│   │   ├── LibBitmap.sol
│   │   ├── LibBytes.sol
│   │   ├── LibPRNG.sol
│   │   ├── LibString.sol
│   │   ├── LibTraits.sol
│   │   ├── LibZip.sol
│   │   ├── SSTORE2.sol
│   │   ├── TraitsLoader.sol
│   │   ├── TraitsRenderer.sol
│   │   └── Utils.sol
│   └── seadrop
│       ├── ERC721ContractMetadata.sol
│       ├── ERC721SeaDrop.sol
│       ├── extensions
│       │   ├── ERC721SeaDropPausable.sol
│       │   └── ERC721SeaDropPausableAndQueryable.sol
│       └── interfaces
│           ├── ICreatorToken.sol
│           ├── INonFungibleSeaDropToken.sol
│           ├── ISeaDrop.sol
│           ├── ISeaDropTokenContractMetadata.sol
│           └── ITransferValidator.sol
└── test

33 directories, 105 files
``