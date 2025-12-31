// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { Utils } from "./Utils.sol";
import { LibString } from "./LibString.sol";

/**
 * @author EtoVass
 */

library Division {
    using Utils for int256;

    function divisionStr(uint8 decimalPlaces, int256 numerator, int256 denominator) pure internal returns(string memory) {
        string memory result;
        (, , result) = _division(decimalPlaces, numerator, denominator);

        bytes memory b = bytes(result);
        uint last = b.length - 1;

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

    function _division(uint8 decimalPlaces, int256 numerator, int256 denominator) pure internal returns(int256 quotient, int256 remainder, string memory result) {
        unchecked {
            int256 factor = int256(10 ** decimalPlaces);
            quotient = numerator / denominator;
            bool rounding = 2 * ((numerator * factor) % denominator) >=
                denominator;
            remainder = ((numerator * factor) / denominator) % factor;
            if (rounding) {
                remainder += 1;
            }
            if (remainder < 0) remainder = -remainder;
            result = string(
                abi.encodePacked(
                    quotient.toString(),
                    ".",
                    _numToFixedLengthStr(decimalPlaces, remainder)
                )
            );
        }
    }

    function _numToFixedLengthStr(uint decimalPlaces, int256 num) pure internal returns(string memory result) {
        unchecked {
            if (num < 0) num = -num;

            bytes memory byteString;
            for (uint i = 0; i < decimalPlaces; i++) {
                uint digit = uint(num % 10);  // Always Positive
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