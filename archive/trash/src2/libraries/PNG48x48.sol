// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Utils } from './Utils.sol';

struct BitMap {
    uint32[48][48] pixels; // 0xAARRGGBB format
}

/**
 * @title PNG48x48
 * @notice Optimized 48x48 PNG encoder with alpha blending
 * @dev Generates valid PNG files from bitmap data
 */
library PNG48x48 {
    /**
     * @notice Magic transparent color - used as a chroma key
     * @dev After all rendering is complete, any pixel matching this exact color
     *      will be converted to fully transparent (0x00000000)
     *      Color: RGB(95, 93, 110) with Alpha=255 = 0x5f5d6eFF in ARGB format
     */
    uint32 constant MAGIC_TRANSPARENT = 0x5f5d6eFF;
    
    /**
     * @notice Render a pixel to the bitmap with alpha blending
     * @param bitMap Target bitmap
     * @param x X coordinate (0-47)
     * @param y Y coordinate (0-47)
     * @param src Source pixel in 0xAARRGGBB format
     */
    function renderPixelToBitMap(BitMap memory bitMap, uint x, uint y, uint32 src) internal pure {
        // Unpack source pixel
        uint32 srcA = src & 0xFF;
        if (srcA == 0) return; // Fully transparent, skip
        
        uint32 srcR = (src >> 24) & 0xFF;
        uint32 srcG = (src >> 16) & 0xFF;
        uint32 srcB = (src >> 8) & 0xFF;
        
        // Fetch destination pixel
        uint32 dst = bitMap.pixels[x][y];
        uint32 dstA = dst & 0xFF;
        
        // Fast path: empty destination
        if (dstA == 0) {
            bitMap.pixels[x][y] = src;
            return;
        }
        
        // Fast path: fully opaque source
        if (srcA == 255) {
            bitMap.pixels[x][y] = src;
            return;
        }
        
        // Full alpha blending required
        uint32 dstR = (dst >> 24) & 0xFF;
        uint32 dstG = (dst >> 16) & 0xFF;
        uint32 dstB = (dst >> 8) & 0xFF;
        
        // Porter-Duff "SRC-OVER" formula with assembly optimization
        uint32 blended;
        assembly {
            // Calculate output alpha
            let invA := sub(255, srcA)
            let outA := add(srcA, div(add(mul(dstA, invA), 127), 255))
            
            // Prevent division by zero
            if iszero(outA) {
                outA := 1
            }
            
            // Calculate blended RGB components
            let outR := div(add(mul(srcR, srcA), div(mul(mul(dstR, dstA), invA), 255)), outA)
            let outG := div(add(mul(srcG, srcA), div(mul(mul(dstG, dstA), invA), 255)), outA)
            let outB := div(add(mul(srcB, srcA), div(mul(mul(dstB, dstA), invA), 255)), outA)
            
            // Pack result as 0xAARRGGBB
            blended := or(or(or(shl(24, outR), shl(16, outG)), shl(8, outB)), outA)
        }
        
        bitMap.pixels[x][y] = blended;
    }

    /**
     * @notice Convert bitmap to URL-encoded PNG data URI
     * @param bmp Source bitmap
     * @return Complete data URI string
     */
    function toURLEncodedPNG(BitMap memory bmp) internal pure returns (string memory) {
        // Apply chroma key: replace all magic transparent colors with actual transparency
        _applyChromaKey(bmp);
        
        bytes memory png = toPNG(bmp);
        return string.concat("data:image/png;base64,", Utils.encodeBase64(png));
    }

    /**
     * @notice Apply chroma key to bitmap
     * @dev Replaces all pixels matching MAGIC_TRANSPARENT with 0x00000000 (fully transparent)
     * @param bmp Bitmap to process (modified in place)
     */
    function _applyChromaKey(BitMap memory bmp) private pure {
        unchecked {
            for (uint256 x = 0; x < 48; ++x) {
                for (uint256 y = 0; y < 48; ++y) {
                    if (bmp.pixels[x][y] == MAGIC_TRANSPARENT) {
                        bmp.pixels[x][y] = 0x00000000; // Convert to transparent
                    }
                }
            }
        }
    }

    // PNG format constants
    bytes constant _PNG_SIG = hex"89504E470D0A1A0A";
    bytes constant _IHDR =
        hex"0000000D" hex"49484452"                 // Length, "IHDR"
        hex"00000030" hex"00000030"                 // 48×48 dimensions
        hex"08" hex"06" hex"00" hex"00" hex"00"     // 8-bit RGBA, deflate
        hex"5702F987";                              // CRC-32

    bytes constant _IEND =
        hex"00000000" hex"49454E44" hex"AE426082";  // Length 0, "IEND", CRC

    /**
     * @notice Convert bitmap to complete PNG file
     * @param bmp Source bitmap
     * @return PNG file bytes
     */
    function toPNG(BitMap memory bmp) internal pure returns (bytes memory) {
        bytes memory raw = _packScanLines(bmp);
        bytes memory zLib = _makeZlibStored(raw);
        bytes memory idat = _makeChunk("IDAT", zLib);

        return bytes.concat(_PNG_SIG, _IHDR, idat, _IEND);
    }

    /**
     * @dev Pack bitmap into raw PNG scan lines
     * @param bmp Source bitmap
     * @return raw Raw pixel data (48 rows × 193 bytes per row)
     */
    function _packScanLines(BitMap memory bmp) private pure returns (bytes memory raw) {
        raw = new bytes(48 * (1 + 48 * 4)); // 9,264 bytes
        uint256 k;
        
        unchecked {
            for (uint256 y; y < 48; ++y) {
                raw[k++] = 0x00; // Filter byte (no filter)
                
                for (uint256 x; x < 48; ++x) {
                    uint32 p = bmp.pixels[x][y];
                    
                    // PNG format: RGBA (note: not ARGB)
                    raw[k++] = bytes1(uint8(p >> 24)); // R
                    raw[k++] = bytes1(uint8(p >> 16)); // G
                    raw[k++] = bytes1(uint8(p >> 8));  // B
                    raw[k++] = bytes1(uint8(p));       // A
                }
            }
        }
    }

    /**
     * @dev Create zlib "stored" stream (no compression)
     * @param raw Raw data to wrap
     * @return z Zlib stream with header and checksum
     */
    function _makeZlibStored(bytes memory raw) private pure returns (bytes memory z) {
        uint256 len = raw.length;
        
        bytes memory hdr = abi.encodePacked(
            bytes2(0x7801),           // Zlib header
            bytes1(0x01),             // Final block, stored
            _u16le(uint16(len)),      // LEN
            _u16le(~uint16(len))      // NLEN
        );
        
        uint32 adler = _adler32(raw);
        z = bytes.concat(hdr, raw, _u32be(adler));
    }

    /**
     * @dev Create PNG chunk with CRC
     * @param t Chunk type (4 bytes)
     * @param d Chunk data
     * @return Complete chunk
     */
    function _makeChunk(bytes4 t, bytes memory d) private pure returns (bytes memory) {
        uint32 crc = _crc32(bytes.concat(t, d));
        return bytes.concat(_u32be(uint32(d.length)), t, d, _u32be(crc));
    }

    /**
     * @dev Calculate Adler-32 checksum
     * @param buf Input bytes
     * @return Checksum value
     */
    function _adler32(bytes memory buf) private pure returns (uint32) {
        uint256 a = 1;
        uint256 b = 0;
        
        unchecked {
            for (uint256 i; i < buf.length; ++i) {
                a += uint8(buf[i]);
                if (a >= 65521) a -= 65521;
                b += a;
                if (b >= 65521) b -= 65521;
            }
        }
        
        return uint32((b << 16) | a);
    }

    /**
     * @dev Calculate CRC-32 checksum
     * @param data Input bytes
     * @return Checksum value
     */
    function _crc32(bytes memory data) private pure returns (uint32) {
        uint32 crc = 0xFFFFFFFF;
        
        unchecked {
            for (uint256 i; i < data.length; ++i) {
                crc ^= uint8(data[i]);
                for (uint8 k = 0; k < 8; ++k) {
                    crc = (crc >> 1) ^ ((crc & 1) == 1 ? 0xEDB88320 : 0);
                }
            }
        }
        
        return ~crc;
    }

    /**
     * @dev Pack uint32 as big-endian bytes4
     */
    function _u32be(uint32 v) private pure returns (bytes4) {
        return bytes4(
            abi.encodePacked(
                bytes1(uint8(v >> 24)),
                bytes1(uint8(v >> 16)),
                bytes1(uint8(v >> 8)),
                bytes1(uint8(v))
            )
        );
    }

    /**
     * @dev Pack uint16 as little-endian bytes2
     */
    function _u16le(uint16 v) private pure returns (bytes2) {
        return bytes2(
            abi.encodePacked(
                bytes1(uint8(v)),
                bytes1(uint8(v >> 8))
            )
        );
    }
}