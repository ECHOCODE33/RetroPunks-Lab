// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { DynamicBuffer } from "./DynamicBuffer.sol";
import { LibString } from "./LibString.sol";

/**
 * @title Utils
 * @notice Utility functions for string manipulation and encoding
 * @dev Optimized for gas efficiency with assembly implementations
 */
library Utils {
    function toString(bytes32 _bytes32) internal pure returns (string memory) {
        return string(toByteArray(_bytes32));
    }

    function toString(uint256 value) internal pure returns (string memory str) {
        /// @solidity memory-safe-assembly
        assembly {
            // The maximum value of a uint contains 78 digits (1 byte per digit), but
            // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
            // We will need 1 word for the trailing zeros padding, 1 word for the length,
            // and 3 words for a maximum of 78 digits.
            str := add(mload(0x40), 0x80)
            // Update the free memory pointer to allocate.
            mstore(0x40, add(str, 0x20))
            // Zeroize the slot after the string.
            mstore(str, 0)

            // Cache the end of the memory to calculate the length later.
            let end := str

            let w := not(0) // Tsk.
            // We write the string from rightmost digit to leftmost digit.
            // The following is essentially a do-while loop that also handles the zero case.
            for { let temp := value } 1 { } {
                str := add(str, w) // `sub(str, 1)`.
                // Write the character to the pointer.
                // The ASCII index of the '0' character is 48.
                mstore8(str, add(48, mod(temp, 10)))
                // Keep dividing `temp` until zero.
                temp := div(temp, 10)
                if iszero(temp) { break }
            }

            let length := sub(end, str)
            // Move the pointer 32 bytes leftwards to make room for the length.
            str := sub(str, 0x20)
            // Store the length.
            mstore(str, length)
        }
    }

    function toString(int256 value) internal pure returns (string memory str) {
        if (value >= 0) return toString(uint256(value));
        unchecked {
            str = toString(uint256(-value));
        }
        /// @solidity memory-safe-assembly
        assembly {
            // We still have some spare memory space on the left,
            // as we have allocated 3 words (96 bytes) for up to 78 digits.
            let length := mload(str) // Load the string length.
            mstore(str, 0x2d) // Store the '-' character.
            str := sub(str, 1) // Move back the string pointer by a byte.
            mstore(str, add(length, 1)) // Update the string length.
        }
    }

    /// @dev Optimized bytes32 to byte array - single loop with assembly
    function toByteArray(bytes32 _bytes32) internal pure returns (bytes memory result) {
        assembly {
            // Find length (first null byte or 32)
            let len := 0
            for { } lt(len, 32) { len := add(len, 1) } {
                if iszero(byte(len, _bytes32)) { break }
            }

            // Allocate result
            result := mload(0x40)
            mstore(result, len)

            // Copy bytes in one operation if len > 0
            if len {
                mstore(add(result, 32), _bytes32)
            }

            // Update free memory pointer (round up to 32-byte boundary)
            mstore(0x40, add(result, and(add(add(len, 32), 31), not(31))))
        }
    }

    function concat(bytes memory buffer, bytes memory c1) internal pure {
        DynamicBuffer.appendSafe(buffer, c1);
    }

    function concatBase64(bytes memory buffer, bytes memory c1) internal pure {
        DynamicBuffer.appendSafeBase64(buffer, c1, false, false);
    }

    function encodeBase64(bytes memory data) internal pure returns (string memory result) {
        result = _encodeBase64(data, false, false);
    }

    function _encodeBase64(bytes memory data, bool fileSafe, bool noPadding) internal pure returns (string memory result) {
        /// @solidity memory-safe-assembly
        assembly {
            let dataLength := mload(data)

            if dataLength {
                // Multiply by 4/3 rounded up.
                // The `shl(2, ...)` is equivalent to multiplying by 4.
                let encodedLength := shl(2, div(add(dataLength, 2), 3))

                // Set `result` to point to the start of the free memory.
                result := mload(0x40)

                // Store the table into the scratch space.
                // Offsetted by -1 byte so that the `mload` will load the character.
                // We will rewrite the free memory pointer at `0x40` later with
                // the allocated size.
                // The magic constant 0x0670 will turn "-_" into "+/".
                mstore(0x1f, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdef")
                mstore(0x3f, xor("ghijklmnopqrstuvwxyz0123456789-_", mul(iszero(fileSafe), 0x0670)))

                // Skip the first slot, which stores the length.
                let ptr := add(result, 0x20)
                let end := add(ptr, encodedLength)

                // Run over the input, 3 bytes at a time.
                for { } 1 { } {
                    data := add(data, 3) // Advance 3 bytes.
                    let input := mload(data)

                    // Write 4 bytes. Optimized for fewer stack operations.
                    mstore8(0, mload(and(shr(18, input), 0x3F)))
                    mstore8(1, mload(and(shr(12, input), 0x3F)))
                    mstore8(2, mload(and(shr(6, input), 0x3F)))
                    mstore8(3, mload(and(input, 0x3F)))
                    mstore(ptr, mload(0x00))

                    ptr := add(ptr, 4) // Advance 4 bytes.
                    if iszero(lt(ptr, end)) { break }
                }
                mstore(0x40, add(end, 0x20)) // Allocate the memory.
                // Equivalent to `o = [0, 2, 1][dataLength % 3]`.
                let o := div(2, mod(dataLength, 3))
                // Offset `ptr` and pad with '='. We can simply write over the end.
                mstore(sub(ptr, o), shl(240, 0x3d3d))
                // Set `o` to zero if there is padding.
                o := mul(iszero(iszero(noPadding)), o)
                mstore(sub(ptr, o), 0) // Zeroize the slot after the string.
                mstore(result, sub(encodedLength, o)) // Store the length.
            }
        }
    }

    function divisionString(uint8 decimalPlaces, int256 numerator, int256 denominator) internal pure returns (string memory) {
        string memory result;
        (,, result) = _division(decimalPlaces, numerator, denominator);

        bytes memory b = bytes(result);
        uint256 last = b.length - 1;

        // Loop backwards to find the last non-zero character
        while (last > 0 && b[last] == "0") last--;

        // If we stopped at the decimal point, trim that too
        if (b[last] == ".") last--;

        return LibString.slice(result, 0, last + 1);
    }

    function _division(uint8 decimalPlaces, int256 numerator, int256 denominator) internal pure returns (int256 quotient, int256 remainder, string memory result) {
        unchecked {
            int256 factor = int256(10 ** decimalPlaces);
            quotient = numerator / denominator;
            bool rounding = 2 * ((numerator * factor) % denominator) >= denominator;
            remainder = ((numerator * factor) / denominator) % factor;
            if (rounding) remainder += 1;
            if (remainder < 0) remainder = -remainder;
            result = string(abi.encodePacked(toString(quotient), ".", _numToFixedLengthStr(decimalPlaces, remainder)));
        }
    }

    /// @dev Optimized fixed length string formatting using assembly
    function _numToFixedLengthStr(uint256 decimalPlaces, int256 num) internal pure returns (string memory result) {
        assembly {
            // Handle negative numbers
            if slt(num, 0) { num := sub(0, num) }

            // Allocate memory for result
            result := mload(0x40)
            mstore(result, decimalPlaces)

            // Write digits from right to left
            let ptr := add(result, add(32, decimalPlaces))
            for { let i := 0 } lt(i, decimalPlaces) { i := add(i, 1) } {
                ptr := sub(ptr, 1)
                mstore8(ptr, add(48, mod(num, 10))) // '0' = 48
                num := div(num, 10)
            }

            // Update free memory pointer
            mstore(0x40, add(result, add(64, decimalPlaces)))
        }
    }
}
