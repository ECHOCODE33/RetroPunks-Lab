// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { Utils } from './Utils.sol';

struct BitMap {
    uint32[24][24] pixels;          // 0xRRGGBBAA
}

library PNG24x24 {
    function alphaBlend(uint32 srcR, uint32 srcG, uint32 srcB, uint32 srcA, uint32 dstR, uint32 dstG, uint32 dstB, uint32 dstA) private pure returns (uint32) {
        unchecked { // saves ~300-400k render gas per token
            uint32 invA = 255 - srcA;
            uint32 outA = srcA + (dstA * invA + 127) / 255;
            uint32 outR = (srcR * srcA + dstR * dstA * invA / 255 + 127) / outA;
            uint32 outG = (srcG * srcA + dstG * dstA * invA / 255 + 127) / outA;
            uint32 outB = (srcB * srcA + dstB * dstA * invA / 255 + 127) / outA;
            return (outR << 24) | (outG << 16) | (outB << 8) | outA;
        }
    }

    function renderPixelToBitMap(BitMap memory bitMap, uint x, uint y, uint32 src) internal pure {
        // ── unpack the incoming pixel ──────────────────────────────────
        uint32 srcA =  src  & 0xff;              // 0-255
        if (srcA == 0) return;                   // fully transparent → nothing to do

        uint32 srcR = (src >> 24) & 0xff;
        uint32 srcG = (src >> 16) & 0xff;
        uint32 srcB = (src >>  8) & 0xff;

        // ── fetch the destination pixel ────────────────────────────────
        uint32 dst    = bitMap.pixels[x][y];
        uint32 dstA   =  dst        & 0xff;
        uint32 dstR   = (dst >> 24) & 0xff;
        uint32 dstG   = (dst >> 16) & 0xff;
        uint32 dstB   = (dst >>  8) & 0xff;

        // Fast path: nothing underneath → just drop the source in
        if (dstA == 0) {
            bitMap.pixels[x][y] = src;
            return;
        }

        // ── alpha-blend: standard Porter-Duff "SRC-OVER" ───────────────
        bitMap.pixels[x][y] = alphaBlend(srcR, srcG, srcB, srcA, dstR, dstG, dstB, dstA);
    }

    function toURLEncodedPNG(BitMap memory bmp) internal pure returns (string memory urlEncodedPNG) {
        bytes memory png = toPNG(bmp);
        urlEncodedPNG = string.concat("data:image/png;base64,", Utils.encode(png));
    }

    bytes constant _PNG_SIG = hex"89504E470D0A1A0A";
    bytes constant _IHDR =
        hex"0000000D" hex"49484452"                 // len, “IHDR”
        hex"00000018" hex"00000018"                 // 24×24
        hex"08" hex"06" hex"00" hex"00" hex"00"     // 8-bit RGBA, deflate, no filter, no interlace
        hex"E0773DF8";                              // CRC-32
    bytes constant _IEND =
        hex"00000000" hex"49454E44" hex"AE426082";  // len 0, “IEND”, CRC

    /* ---------- public ------------------------------------------------------ */

    function toPNG(BitMap memory bmp) internal pure returns (bytes memory) {
        bytes memory raw  = _packScanLines(bmp);      // 2 328 B
        bytes memory zLib = _makeZlibStored(raw);     // 2 339 B
        bytes memory idat = _makeChunk("IDAT", zLib); // IDAT chunk

        return bytes.concat(_PNG_SIG, _IHDR, idat, _IEND);
    }

    /* ---------- scan-line builder ------------------------------------------ */

    function _packScanLines(BitMap memory bmp) private pure returns (bytes memory raw) {
        raw = new bytes(24 * (1 + 24 * 4));           // 2 328
        uint256 k;
        unchecked {
            for (uint256 y; y < 24; ++y) {
                raw[k++] = 0x00;                      // filter byte = 0
                for (uint256 x; x < 24; ++x) {
                    uint32 p = bmp.pixels[x][y];
                    raw[k++] = bytes1(uint8(p >> 24));
                    raw[k++] = bytes1(uint8(p >> 16));
                    raw[k++] = bytes1(uint8(p >>  8));
                    raw[k++] = bytes1(uint8(p      ));
                }
            }
        }
    }

    /* ---------- zlib “stored” stream --------------------------------------- */

    function _makeZlibStored(bytes memory raw) private pure returns (bytes memory z) {
        uint256 len = raw.length;                     // 2 328
        bytes memory hdr = abi.encodePacked(
            bytes2(0x7801),                           // zlib header
            bytes1(0x01),                             // final block, stored
            _u16le(uint16(len)),                      // LEN  (little-endian)
            _u16le(~uint16(len))                      // NLEN
        );
        uint32 adler = _adler32(raw);
        z = bytes.concat(hdr, raw, _u32be(adler));    // big-endian Adler-32
    }

    /* ---------- PNG chunk builder ------------------------------------------ */

    function _makeChunk(bytes4 t, bytes memory d) private pure returns (bytes memory) {
        uint32 crc = _crc32(bytes.concat(t, d));
        return bytes.concat(_u32be(uint32(d.length)), t, d, _u32be(crc));
    }

    /* ---------- checksums --------------------------------------------------- */

    function _adler32(bytes memory buf) private pure returns (uint32) {
        uint256 a = 1; uint256 b = 0;
        unchecked {
            for (uint256 i; i < buf.length; ++i) {
                a += uint8(buf[i]); if (a >= 65521) a -= 65521;
                b += a;             if (b >= 65521) b -= 65521;
            }
        }
        return uint32((b << 16) | a);
    }

    function _crc32(bytes memory data) private pure returns (uint32) {
        uint32 crc = 0xFFFFFFFF;
        unchecked {
            for (uint256 i; i < data.length; ++i) {
                crc ^= uint8(data[i]);
                for (uint8 k = 0; k < 8; ++k)
                    crc = (crc >> 1) ^ ((crc & 1) == 1 ? 0xEDB88320 : 0);
            }
        }
        return ~crc;
    }

    /* ---------- endian helpers --------------------------------------------- */

    function _u32be(uint32 v) private pure returns (bytes4) {
        return bytes4(
            abi.encodePacked(
                bytes1(uint8(v >> 24)),
                bytes1(uint8(v >> 16)),
                bytes1(uint8(v >> 8 )),
                bytes1(uint8(v      ))
            )
        );
    }

    function _u16le(uint16 v) private pure returns (bytes2) {
        return bytes2(
            abi.encodePacked(
                bytes1(uint8(v      )),
                bytes1(uint8(v >> 8))
            )
        );
    }
}