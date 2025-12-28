// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;


/** 
    @author EtoVass

    FisherYatesShuffler is an abstract contract that implements a Fisher-Yates shuffle algorithm.
    It is used to draw a random element from a list of elements.
    The elements are stored in a mapping, and the drawNext function is used to draw a random element from the list.
*/    

abstract contract FisherYatesShuffler {
    mapping(uint256 => uint256) private availableElements;

    /**
     * @notice Draws a random element from the list. It assumes that the list is not empty and that number of elements in the list will be decreased by 1 each time after this function is called.
     * @param shufflerSeed The seed to use for the random number generator.
     * @param msgSender The address of the message sender.
     * @param remaining The number of remaining elements in the list.
     * @return result The random element.
     */
    function drawNextElement(uint shufflerSeed, address msgSender, uint remaining) internal virtual returns (uint result) {
        // Optimize: Use abi.encodePacked instead of abi.encode for fewer bytes
        // Optimize: Combine inputs more efficiently
        uint index = uint(keccak256(abi.encodePacked(
            shufflerSeed, 
            msgSender, 
            remaining, 
            block.timestamp, 
            block.prevrandao, 
            block.number
        ))) % remaining;

        // Optimize: Use unchecked for arithmetic that can't overflow
        unchecked {
            uint last = remaining - 1;
            
            // Optimize: Read both storage values in one go where possible
            uint valueAtIndex = availableElements[index];
            uint valueAtLast = availableElements[last];

            // Optimize: Use ternary operators more efficiently
            result = valueAtIndex == 0 ? index : valueAtIndex;
            availableElements[index] = valueAtLast == 0 ? last : valueAtLast;
        }

        return result;
    }
}

