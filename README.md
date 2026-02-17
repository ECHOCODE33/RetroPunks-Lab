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
├── README.md
├── _new.md - Markdown file containing a series of commands for deploying and running the RetroPunks contract
├── export
│   ├── RetroPunksFlattened.sol
│   ├── tokenMetadataBatch.json
│   ├── tokenURIBatch.json
│   └── tokenUriBatch.txt
├── foundry.lock
├── foundry.toml
├── output.log
├── lib
│   ├── ERC721A - https://github.com/chiru-labs/ERC721A
│   ├── forge-std - https://github.com/foundry-rs/forge-std
│   ├── openzeppelin-contracts - https://github.com/OpenZeppelin/openzeppelin-contracts
│   ├── seadrop - https://github.com/ProjectOpenSea/seadrop
│   └── solady - https://github.com/Vectorized/solady
├── python
│   ├── _BackgroundAssetUltimate.py - Python asset-generating script for generating hexadecimal string asset for background trait group using data in arrays & objects
│   ├── _GradientPaletteUltimate2.py
│   ├── _SpecialAsset.py - Python asset-generating script for generating hexadecimal string asset for special 1s trait group, using PNG images in a directory
│   ├── _TraitsAsset.py - Python asset-generating script for generating hexadecimal string asset for all other trait groups except background & special 1s (those have their own script), using PNG images in a directory
│   ├── gif.py
│   └── suggest-background.py
├── script
│   ├── AddAssetsBatch.s.sol - Script used to add hexadecimal string assets to the Assets contract
│   ├── RetroPunks.s.sol - Script containing a variety of functions to deploy & broadcast RetroPunks contract's functions.
│   └── VerifyAssets.s.sol - Script used to verify existence of hexadecimal string assets in Assets contract
├── src
│   ├── Assets.sol - Assets storage contract (stores LZ77 compressed hexadecimal string assets containing RLE data for PNG artwork trait layers)
│   ├── MetaGen.sol - Metadata Generator contract (generates tokenURI's final JSON attributes and image properties)
│   ├── Rarities.sol - Rarities contract (stores constant hexadecimal strings containing decimal rarity weights for traits, uses LibPRNG to randomly select traits)
│   ├── RetroPunks.sol - RetroPunks contract (The main contract which has tokenURI() function and uses all other contracts)
│   ├── Traits.sol - Traits contract (randomly selects traits using the Rarities contract, which it inherits, and generates context used in the final SVG rendering process)
│   ├── global
│   │   ├── Enums.sol - Global scope enums for traits, trait groups, background types, etc. Used throughout the modular RetroPunks contract
│   │   └── Structs.sol - Global scope structs for trait information and context, filled with processed hex data from Assets contract & used throughout the modular RetroPunks contract
│   ├── interfaces
│   │   ├── IAssets.sol
│   │   ├── IMetaGen.sol
│   │   ├── IRetroPunksTypes.sol - Interface containing structs, errors, and events for RetroPunks contract.
│   │   └── ITraits.sol
│   ├── libraries
│   │   ├── DynamicBuffer.sol
│   │   ├── LibBytes.sol
│   │   ├── LibPRNG.sol
│   │   ├── LibString.sol
│   │   ├── LibTraits.sol - Traits conditional checker library
│   │   ├── LibZip.sol
│   │   ├── PNGBuilder.sol - PNGBuilder library (uses bitmapping to build PNG images)
│   │   ├── SSTORE2.sol
│   │   ├── TraitsLoader.sol - TraitsLoader library (processes decompressed hexadecimal assets from Assets contract, uses it to populate global structs with data)
│   │   ├── TraitsRenderer.sol - TraitsRenderer library (uses PNGBuilder library to render images)
│   │   └── Utils.sol - Utils library (utility functions used throughout the contracts)
│   └── seadrop
│       ├── ERC721ContractMetadata.sol
│       ├── ERC721SeaDrop.sol
│       ├── extensions
│       │   ├── ERC721SeaDropPausable.sol
│       │   └── ERC721SeaDropPausableAndQueryable.sol - Extends ERC721SeaDropPausable with convenience query functions
│       └── interfaces
│           ├── ICreatorToken.sol
│           ├── INonFungibleSeaDropToken.sol
│           ├── ISeaDrop.sol
│           ├── ISeaDropTokenContractMetadata.sol
│           └── ITransferValidator.sol
└── test
```