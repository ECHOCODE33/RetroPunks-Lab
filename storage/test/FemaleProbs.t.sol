// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/FemaleProbs.sol";
import { RandomCtx, Random } from "../src/libraries/Random.sol";
import { TraitsContext } from "../src/common/Structs.sol";
import { E_Female_Skin, E_Female_Eyes, E_Female_Face } from "../src/common/Enums.sol";

contract FemaleProbsTest is Test {
    FemaleProbs public femaleProbs;
    uint256 constant ITERATIONS = 10000;

    function setUp() public {
        femaleProbs = new FemaleProbs();
    }

    // --- TESTS ---

    function test_Report_Skin() public view {
        uint256[] memory results = new uint256[](133); 

        TraitsContext memory traits; 

        traits.femaleSkin = E_Female_Skin.Human_10;
        
        for (uint256 i = 0; i < ITERATIONS; i++) {
            results[uint(femaleProbs.selectFemaleHatHair(traits, _mockCtx(i)))]++;
        }

        _printRarityReport("Hair", results);
    }

    // --- LOGGING ENGINE (Fixed) ---

    function _printRarityReport(string memory label, uint256[] memory results) internal pure {
        console.log("---------------------------------------");
        console.log(label);
        console.log("---------------------------------------");
        
        for (uint256 i = 0; i < results.length; i++) {
            if (results[i] > 0) {
                // Formatting decimals for percentage (e.g., 7.50%)
                uint256 integerPart = results[i] / 100;
                uint256 fractionalPart = results[i] % 100;

                // We use vm.toString to bypass console.log limitations
                string memory output = string(abi.encodePacked(
                    "Trait ", vm.toString(i), 
                    ": ", vm.toString(results[i]), 
                    " chosen (", vm.toString(integerPart), ".", vm.toString(fractionalPart), "%)"
                ));
                console.log(output);
            }
        }
        console.log("---------------------------------------\n");
    }

    function _mockCtx(uint256 salt) internal pure returns (RandomCtx memory) {
        return RandomCtx({
            seed: uint256(keccak256(abi.encodePacked("1243r234t243tj", salt))),
            counter: salt
        });
    }
}