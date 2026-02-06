// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { Utils } from "./Utils.sol";
import { LibString} from "./LibString.sol";

/**
 * @author EtoVass
 */

library Division {
    using Utils for int256;

    function division(uint8 decimalPlaces, int256 numerator, int256 denominator) pure internal returns(int256 quotient, int256 remainder, string memory result) { unchecked {
        int256 factor = int256(10**decimalPlaces); // 40
        quotient  = numerator / denominator; //4.1666
        bool rounding = 2 * ((numerator * factor) % denominator) >= denominator;
        remainder = (numerator * factor / denominator) % factor;
        if (rounding) {
            remainder += 1;
        }
        if (remainder < 0) remainder = -remainder;
        result = string(abi.encodePacked(quotient.toString(), '.', numToFixedLengthStr(decimalPlaces, remainder)));
    }}

    function divisionStr(uint8 decimalPlaces, int256 numerator, int256 denominator) pure internal returns(string memory) {
        string memory result;
        (,,result) = division(decimalPlaces, numerator, denominator);
        return result;
    }

    function divisionStrWellFormatted(uint8 decimalPlaces, int256 numerator, int256 denominator) pure internal returns(string memory) {
        string memory result;
        (,,result) = division(decimalPlaces, numerator, denominator);


        // 0.xxxxxx   ==> decimalPlaces + 2 - 1 is the last character   
        for (uint i = decimalPlaces + 1; i >= 0; i--) {
            if (bytes(result)[i] != '0') {
                return LibString.slice(result, 0, i + 1);
            }
        }

        return result;
    }

    function numToFixedLengthStr(uint256 decimalPlaces, int256 num) pure internal returns(string memory result) { unchecked {
        bytes memory byteString;
        for (uint256 i = 0; i < decimalPlaces; i++) {
            int256 remainder = num % 10;
            byteString = abi.encodePacked(remainder.toString(), byteString);
            num = num/10;
        }
        result = string(byteString);
    }}
}