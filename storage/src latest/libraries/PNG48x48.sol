// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Utils } from './Utils.sol';

struct BitMap {
    uint32[48][48] pixels;  // 0xRRGGBBAA 
}

library PNG48x48 {
    uint32 constant MAGIC_TRANSPARENT = 0x5f5d6eFF;
    
    function renderPixelToBitMap(BitMap memory bitMap, uint x, uint y, uint32 src) internal pure {
        uint32 srcA = src & 0xFF;
        if (srcA == 0) return;
        
        uint32 srcR = (src >> 24) & 0xFF;
        uint32 srcG = (src >> 16) & 0xFF;
        uint32 srcB = (src >> 8) & 0xFF;
        
        uint32 dst = bitMap.pixels[x][y];
        uint32 dstA = dst & 0xFF;
        
        if (dstA == 0) {
            bitMap.pixels[x][y] = src;
            return;
        }
        
        if (srcA == 255) {
            bitMap.pixels[x][y] = src;
            return;
        }
        
        uint32 dstR = (dst >> 24) & 0xFF;
        uint32 dstG = (dst >> 16) & 0xFF;
        uint32 dstB = (dst >> 8) & 0xFF;
        
        uint32 blended;
        assembly {
            let invA := sub(255, srcA)
            let outA := add(srcA, div(add(mul(dstA, invA), 127), 255))
            if iszero(outA) { outA := 1 }
            
            let outR := div(add(mul(srcR, srcA), div(mul(mul(dstR, dstA), invA), 255)), outA)
            let outG := div(add(mul(srcG, srcA), div(mul(mul(dstG, dstA), invA), 255)), outA)
            let outB := div(add(mul(srcB, srcA), div(mul(mul(dstB, dstA), invA), 255)), outA)
            
            blended := or(or(or(shl(24, outR), shl(16, outG)), shl(8, outB)), outA)
        }
        
        bitMap.pixels[x][y] = blended;
    }

    function toURLEncodedPNG(BitMap memory bmp) internal pure returns (string memory) {
        _applyChromaKey(bmp);
        bytes memory png = toPNG(bmp);
        return string.concat("data:image/png;base64,", Utils.encodeBase64(png));
    }

    function _applyChromaKey(BitMap memory bmp) private pure {
        unchecked {
            for (uint256 x = 0; x < 48; ++x) {
                for (uint256 y = 0; y < 48; ++y) {
                    if (bmp.pixels[x][y] == MAGIC_TRANSPARENT) {
                        bmp.pixels[x][y] = 0x00000000;
                    }
                }
            }
        }
    }

    bytes constant _PNG_SIG = hex"89504E470D0A1A0A";
    bytes constant _IHDR =
        hex"0000000D" hex"49484452"
        hex"00000030" hex"00000030"
        hex"08" hex"06" hex"00" hex"00" hex"00"
        hex"5702F987";

    bytes constant _IEND =
        hex"00000000" hex"49454E44" hex"AE426082";

    function toPNG(BitMap memory bmp) internal pure returns (bytes memory) {
        bytes memory raw = _packScanLines(bmp);
        bytes memory zLib = _makeZlibStored(raw);
        bytes memory idat = _makeChunk("IDAT", zLib);

        return bytes.concat(_PNG_SIG, _IHDR, idat, _IEND);
    }

    function _packScanLines(BitMap memory bmp) private pure returns (bytes memory raw) {
        raw = new bytes(48 * (1 + 48 * 4));
        uint256 k;
        
        unchecked {
            for (uint256 y; y < 48; ++y) {
                raw[k++] = 0x00;
                
                for (uint256 x; x < 48; ++x) {
                    uint32 p = bmp.pixels[x][y];
                    
                    raw[k++] = bytes1(uint8(p >> 24)); // R
                    raw[k++] = bytes1(uint8(p >> 16)); // G
                    raw[k++] = bytes1(uint8(p >> 8));  // B
                    raw[k++] = bytes1(uint8(p));       // A
                }
            }
        }
    }

    function _makeZlibStored(bytes memory raw) private pure returns (bytes memory z) {
        uint256 len = raw.length;
        
        bytes memory hdr = abi.encodePacked(
            bytes2(0x7801),
            bytes1(0x01),
            _u16le(uint16(len)),
            _u16le(~uint16(len))
        );
        
        uint32 adler = _adler32(raw);
        z = bytes.concat(hdr, raw, _u32be(adler));
    }

    function _makeChunk(bytes4 t, bytes memory d) private pure returns (bytes memory) {
        uint32 crc = _crc32(bytes.concat(t, d));
        return bytes.concat(_u32be(uint32(d.length)), t, d, _u32be(crc));
    }

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

    function _u32be(uint32 v) private pure returns (bytes4) {
        return bytes4(abi.encodePacked(
            bytes1(uint8(v >> 24)),
            bytes1(uint8(v >> 16)),
            bytes1(uint8(v >> 8)),
            bytes1(uint8(v))
        ));
    }

    function _u16le(uint16 v) private pure returns (bytes2) {
        return bytes2(abi.encodePacked(
            bytes1(uint8(v)),
            bytes1(uint8(v >> 8))
        ));
    }
}