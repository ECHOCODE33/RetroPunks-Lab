// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { E_Background_Type, E_TraitsGroup } from "../global/Enums.sol";
import { CachedTraitGroups, TraitGroup, TraitInfo } from "../global/Structs.sol";
import { IAssets } from "../interfaces/IAssets.sol";

library TraitsLoader {
    function initCachedTraitGroups(uint256 _traitGroupsLength) public pure returns (CachedTraitGroups memory) {
        return CachedTraitGroups({ traitGroups: new TraitGroup[](_traitGroupsLength), traitGroupsLoaded: new bool[](_traitGroupsLength) });
    }

    function loadAndCacheTraitGroup(IAssets _assetsContract, CachedTraitGroups memory _cachedTraitGroups, uint256 _traitGroupIndex) public view returns (TraitGroup memory) {
        if (_cachedTraitGroups.traitGroupsLoaded[_traitGroupIndex]) {
            return _cachedTraitGroups.traitGroups[_traitGroupIndex];
        }

        TraitGroup memory traitGroup;
        traitGroup.traitGroupIndex = _traitGroupIndex;

        bytes memory traitGroupData = _assetsContract.loadAsset(_traitGroupIndex, true);

        uint256 index = 0;

        // Decode Name
        traitGroup.traitGroupName = _decodeTraitGroupName(traitGroupData, index);
        unchecked {
            index += 1 + traitGroup.traitGroupName.length;
        }

        // Decode Palette
        // NEW: Palette entries are now 3 bytes (RGB). Alpha is reconstructed as 0xFF in the decoder.
        (traitGroup.paletteRgba, index) = _decodeTraitGroupPalette(traitGroupData, index);

        // Decode settings
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

                // Trait header: [x1:1][y1:1][x2:1][y2:1][layerType:1][nameLen:1]
                // NEW: Bounding box is now in 24x24 logical coordinate space.
                // NEW: layerType: 0 = normal 24x24 logical, 0xFF = full-res 48x48 exception.
                // For the Background group, layerType encodes the background type enum instead.
                t.x1 = uint8(traitGroupData[index]);
                t.y1 = uint8(traitGroupData[index + 1]);
                t.x2 = uint8(traitGroupData[index + 2]);
                t.y2 = uint8(traitGroupData[index + 3]);
                t.layerType = uint8(traitGroupData[index + 4]);
                uint8 traitNameLength = uint8(traitGroupData[index + 5]);

                index += 6;

                // Read trait name
                t.traitName = new bytes(traitNameLength);
                _memoryCopy(t.traitName, 0, traitGroupData, index, traitNameLength);
                index += traitNameLength;

                // Parse 2D RLE structure to determine its byte length, then copy it.
                uint256 startOfData = index;

                if (traitGroup.traitGroupIndex == uint8(E_TraitsGroup.Background_Group)) {
                    uint8 layerType = t.layerType;
                    if (layerType == uint8(E_Background_Type.Solid)) {
                        index += pSize;
                    } else if (layerType == uint8(E_Background_Type.S_Vertical) || layerType == uint8(E_Background_Type.P_Vertical) || layerType == uint8(E_Background_Type.S_Horizontal) || layerType == uint8(E_Background_Type.P_Horizontal) || layerType == uint8(E_Background_Type.S_Down) || layerType == uint8(E_Background_Type.P_Down) || layerType == uint8(E_Background_Type.S_Up) || layerType == uint8(E_Background_Type.P_Up) || layerType == uint8(E_Background_Type.Radial)) {
                        index += pSize * 2;
                    } else if (layerType == uint8(E_Background_Type.Background_Image)) {
                        index = _parse2DRLELength(traitGroupData, index, pSize);
                    }
                } else {
                    index = _parse2DRLELength(traitGroupData, index, pSize);
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

    function _parse2DRLELength(bytes memory data, uint256 startIndex, uint8 pSize) internal pure returns (uint256) {
        uint256 index = startIndex;

        uint8 numRows = uint8(data[index++]);

        for (uint256 r = 0; r < numRows;) {
            index++; // rowY
            uint8 numRuns = uint8(data[index++]);
            index += numRuns * (2 + pSize);
            unchecked {
                ++r;
            }
        }

        return index;
    }

    function _decodeTraitGroupName(bytes memory traitGroupData, uint256 startIndex) internal pure returns (bytes memory) {
        uint8 nameLength = uint8(traitGroupData[startIndex]);
        bytes memory name = new bytes(nameLength);
        unchecked {
            _memoryCopy(name, 0, traitGroupData, startIndex + 1, nameLength);
        }
        return name;
    }

    /**
     * @notice Decode the palette from the blob.
     * NEW: Palette entries are now 3 bytes (RGB) instead of 4 bytes (RGBA).
     * NEW: Alpha is always fully opaque so we reconstruct each entry as 0xRRGGBBFF
     *      by OR-ing 0xFF into the low byte. Saves 1 byte per color in the blob.
     */
    function _decodeTraitGroupPalette(bytes memory traitGroupData, uint256 startIndex) internal pure returns (uint32[] memory paletteRgba, uint256 nextIndex) {
        uint16 paletteSize = uint16(uint8(traitGroupData[startIndex])) << 8 | uint16(uint8(traitGroupData[startIndex + 1]));

        if (paletteSize == 0) {
            return (new uint32[](0), startIndex + 2);
        }

        paletteRgba = new uint32[](paletteSize);
        uint256 cursor = startIndex + 2;

        unchecked {
            for (uint256 i = 0; i < paletteSize; i++) {
                // NEW: Read only R, G, B (3 bytes). Reconstruct as 0xRRGGBBFF.
                // NEW: Alpha is never stored in the blob — always reconstructed as 0xFF.
                uint32 color = uint32(uint8(traitGroupData[cursor])) << 24 | uint32(uint8(traitGroupData[cursor + 1])) << 16 | uint32(uint8(traitGroupData[cursor + 2])) << 8 | 0xFF; // NEW: alpha always 0xFF
                paletteRgba[i] = color;
                cursor += 3; // NEW: 3 bytes per entry (was 4)
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
            for { let i := 0 } lt(i, len) { i := add(i, 32) } {
                mstore(add(destPtr, i), mload(add(srcPtr, i)))
            }
        }
    }
}
