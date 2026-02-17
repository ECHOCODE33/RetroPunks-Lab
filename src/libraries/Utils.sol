// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { Base64 } from "./Base64.sol";
import { DynamicBuffer } from "./DynamicBuffer.sol";
import { LibString } from "./LibString.sol";

library Utils {
    // ══════════════════════════════════════════════════════════════════════════
    //                              LibString
    // ══════════════════════════════════════════════════════════════════════════

    function toString(bytes32 _value) internal pure returns (string memory) {
        return LibString.fromSmallString(_value);
    }

    function toString(uint256 _value) internal pure returns (string memory) {
        return LibString.toString(_value);
    }

    function toString(int256 _value) internal pure returns (string memory) {
        return LibString.toString(_value);
    }

    // ══════════════════════════════════════════════════════════════════════════
    //                             Dynamic Buffer
    // ══════════════════════════════════════════════════════════════════════════

    function concat(bytes memory buffer, bytes memory c1) internal pure {
        DynamicBuffer.appendUnchecked(buffer, c1);
    }

    function concat(bytes memory buffer, bytes memory c1, bytes memory c2) internal pure {
        concat(buffer, c1);
        concat(buffer, c2);
    }

    function concat(bytes memory buffer, bytes memory c1, bytes memory c2, bytes memory c3) internal pure {
        concat(buffer, c1, c2);
        concat(buffer, c3);
    }

    function concat(bytes memory buffer, bytes memory c1, bytes memory c2, bytes memory c3, bytes memory c4) internal pure {
        concat(buffer, c1, c2, c3);
        concat(buffer, c4);
    }

    function concat(bytes memory buffer, bytes memory c1, bytes memory c2, bytes memory c3, bytes memory c4, bytes memory c5) internal pure {
        concat(buffer, c1, c2, c3, c4);
        concat(buffer, c5);
    }

    function concat(bytes memory buffer, bytes memory c1, bytes memory c2, bytes memory c3, bytes memory c4, bytes memory c5, bytes memory c6) internal pure {
        concat(buffer, c1, c2, c3, c4, c5);
        concat(buffer, c6);
    }

    function concat(bytes memory buffer, bytes memory c1, bytes memory c2, bytes memory c3, bytes memory c4, bytes memory c5, bytes memory c6, bytes memory c7) internal pure {
        concat(buffer, c1, c2, c3, c4, c5, c6);
        concat(buffer, c7);
    }

    function concat(bytes memory buffer, bytes memory c1, bytes memory c2, bytes memory c3, bytes memory c4, bytes memory c5, bytes memory c6, bytes memory c7, bytes memory c8) internal pure {
        concat(buffer, c1, c2, c3, c4, c5, c6, c7);
        concat(buffer, c8);
    }

    function concatBase64(bytes memory buffer, bytes memory c1) internal pure {
        DynamicBuffer.appendSafeBase64(buffer, c1, false, false);
    }

    function encodeBase64(bytes memory data) internal pure returns (string memory) {
        return Base64.encode(data);
    }

    // ══════════════════════════════════════════════════════════════════════════
    //                               Division
    // ══════════════════════════════════════════════════════════════════════════

    function divisionString(uint8 decimalPlaces, int256 numerator, int256 denominator) internal pure returns (string memory) {
        string memory result;
        (,, result) = _division(decimalPlaces, numerator, denominator);

        bytes memory b = bytes(result);
        uint256 last = b.length - 1;

        // Loop backwards to find the last non-zero character
        while (last > 0 && b[last] == "0") {
            last--;
        }

        // If we stopped at the decimal point, trim that too
        if (b[last] == ".") {
            last--;
        }

        return LibString.slice(result, 0, last + 1);
    }

    function _division(uint8 decimalPlaces, int256 numerator, int256 denominator) internal pure returns (int256 quotient, int256 remainder, string memory result) {
        unchecked {
            int256 factor = int256(10 ** decimalPlaces);
            quotient = numerator / denominator;
            bool rounding = 2 * ((numerator * factor) % denominator) >= denominator;
            remainder = ((numerator * factor) / denominator) % factor;
            if (rounding) {
                remainder += 1;
            }
            if (remainder < 0) {
                remainder = -remainder;
            }
            result = string(abi.encodePacked(toString(quotient), ".", _numToFixedLengthStr(decimalPlaces, remainder)));
        }
    }

    function _numToFixedLengthStr(uint256 decimalPlaces, int256 num) internal pure returns (string memory result) {
        unchecked {
            if (num < 0) {
                num = -num;
            }

            bytes memory byteString;
            for (uint256 i = 0; i < decimalPlaces; i++) {
                uint256 digit = uint256(num % 10); // Always Positive
                byteString = abi.encodePacked(LibString.toString(digit), byteString);
                num = num / 10;
            }
            // Pad with leading zeros if the number was smaller than decimalPlaces
            while (byteString.length < decimalPlaces) {
                byteString = abi.encodePacked("0", byteString);
            }
            result = string(byteString);
        }
    }
}
