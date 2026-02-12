// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { TraitsContext } from "../global/Structs.sol";

interface ITraits {
    function generateTraitsContext(uint16 _tokenIdSeed, uint8 _backgroundIndex, uint256 _seed) external view returns (TraitsContext memory);
}
