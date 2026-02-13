// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { E_TraitsGroup } from "../global/Enums.sol";
import { CachedTraitGroups, TraitGroup, TraitInfo } from "../global/Structs.sol";
import { IAssets } from "../interfaces/IAssets.sol";

library TraitsLoader {
    function initCachedTraitGroups(uint256 _traitGroupsLength) public pure returns (CachedTraitGroups memory) {
        return CachedTraitGroups({ traitGroups: new TraitGroup[](_traitGroupsLength), traitGroupsLoaded: new bool[](_traitGroupsLength) });
    }

    function loadAndCacheTraitGroup(IAssets _assetsContract, CachedTraitGroups memory _cachedTraitGroups, uint256 _traitGroupIndex)
        public
        view
        returns (TraitGroup memory)
    {
        if (_cachedTraitGroups.traitGroupsLoaded[_traitGroupIndex]) {
            return _cachedTraitGroups.traitGroups[_traitGroupIndex];
        }

        TraitGroup memory traitGroup;
        traitGroup.traitGroupIndex = _traitGroupIndex;

        bytes memory traitGroupData = _assetsContract.loadAsset(_traitGroupIndex, true);
        // uint256 dataLength = traitGroupData.length;

        uint256 index = 0;

        // Decode Name
        traitGroup.traitGroupName = _decodeTraitGroupName(traitGroupData, index);
        unchecked {
            index += 1 + traitGroup.traitGroupName.length;
        }

        // Decode Palette
        (traitGroup.paletteRgba, index) = _decodeTraitGroupPalette(traitGroupData, index);

        // Decode Data
        traitGroup.paletteIndexByteSize = uint8(traitGroupData[index]);
        unchecked {
            index++;
        }

        uint8 traitCount = uint8(traitGroupData[index]);
        unchecked {
            index++;
        }

        traitGroup.traits = new TraitInfo[](traitCount);
        uint8 pSize = traitGroup.paletteIndexByteSize;

        unchecked {
            for (uint256 i = 0; i < traitCount; i++) {
                TraitInfo memory t;

                // [PixelCount:2][x1:1][y1:1][x2:1][y2:1][layerType:1][nameLen:1] = 8 bytes
                uint16 traitPixelCount = uint16(uint8(traitGroupData[index])) << 8 | uint16(uint8(traitGroupData[index + 1]));

                t.x1 = uint8(traitGroupData[index + 2]);
                t.y1 = uint8(traitGroupData[index + 3]);
                t.x2 = uint8(traitGroupData[index + 4]);
                t.y2 = uint8(traitGroupData[index + 5]);
                t.layerType = uint8(traitGroupData[index + 6]);
                uint8 traitNameLength = uint8(traitGroupData[index + 7]);

                index += 8;

                t.traitName = new bytes(traitNameLength);
                _memoryCopy(t.traitName, 0, traitGroupData, index, traitNameLength);
                index += traitNameLength;

                uint256 startOfData = index;

                if (traitPixelCount > 0) {
                    if (traitGroup.traitGroupIndex == uint8(E_TraitsGroup.Background_Group)) {
                        index += (traitPixelCount * pSize);
                    } else {
                        uint256 pixelsTracked = 0;
                        while (pixelsTracked < traitPixelCount) {
                            uint8 runLength = uint8(traitGroupData[index++]);

                            index += pSize;
                            pixelsTracked += runLength;
                        }
                    }
                }

                uint256 dataLen = index - startOfData;
                t.traitData = new bytes(dataLen);

                if (dataLen > 0) {
                    _memoryCopy(t.traitData, 0, traitGroupData, startOfData, dataLen);
                }

                traitGroup.traits[i] = t;
            }
        }

        _cachedTraitGroups.traitGroups[_traitGroupIndex] = traitGroup;
        _cachedTraitGroups.traitGroupsLoaded[_traitGroupIndex] = true;
        return traitGroup;
    }

    function _decodeTraitGroupName(bytes memory traitGroupData, uint256 startIndex) internal pure returns (bytes memory) {
        uint8 nameLength = uint8(traitGroupData[startIndex]);
        bytes memory name = new bytes(nameLength);
        unchecked {
            _memoryCopy(name, 0, traitGroupData, startIndex + 1, nameLength);
        }
        return name;
    }

    function _decodeTraitGroupPalette(bytes memory traitGroupData, uint256 startIndex) internal pure returns (uint32[] memory paletteRgba, uint256 nextIndex) {
        uint16 paletteSize = uint16(uint8(traitGroupData[startIndex])) << 8 | uint16(uint8(traitGroupData[startIndex + 1]));

        if (paletteSize == 0) {
            return (new uint32[](0), startIndex + 2);
        }

        paletteRgba = new uint32[](paletteSize);
        uint256 cursor = startIndex + 2;

        unchecked {
            for (uint256 i = 0; i < paletteSize; i++) {
                uint32 color = uint32(uint8(traitGroupData[cursor])) << 24 | uint32(uint8(traitGroupData[cursor + 1])) << 16
                    | uint32(uint8(traitGroupData[cursor + 2])) << 8 | uint32(uint8(traitGroupData[cursor + 3]));
                paletteRgba[i] = color;
                cursor += 4;
            }
        }

        nextIndex = cursor;
    }

    function _memoryCopy(bytes memory dest, uint256 destOffset, bytes memory src, uint256 srcOffset, uint256 len) internal pure {
        if (len == 0) {
            return;
        }
        assembly {
            let destPtr := add(add(dest, 32), destOffset)
            let srcPtr := add(add(src, 32), srcOffset)

            // Copy in 32-byte chunks
            for { let i := 0 } lt(i, len) { i := add(i, 32) } {
                mstore(add(destPtr, i), mload(add(srcPtr, i)))
            }
        }
    }
}
