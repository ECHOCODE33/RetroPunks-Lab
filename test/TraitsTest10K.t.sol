// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import { Traits } from "../src/Traits.sol";
import { Probs } from "../src/Probs.sol";
import { TraitsContext } from "../src/common/Structs.sol";
import { 
    E_Sex, E_Male_Skin, E_Male_Eyes, E_Male_Face, E_Male_Chain, 
    E_Male_Earring, E_Male_Scarf, E_Male_Facial_Hair, E_Male_Mask, 
    E_Male_Hair, E_Male_Hat_Hair, E_Male_Headwear, E_Male_Eye_Wear,
    E_Female_Skin, E_Female_Eyes, E_Female_Face, E_Female_Chain, 
    E_Female_Earring, E_Female_Scarf, E_Female_Mask, E_Female_Hair, 
    E_Female_Hat_Hair, E_Female_Headwear, E_Female_Eye_Wear, E_Mouth 
} from "../src/common/Enums.sol";

contract CumulativeStats {
    mapping(string => mapping(uint256 => uint256)) public counts;
    mapping(string => uint256) public maxIndex;
    uint256 public successfulRuns;
    uint256 public maleTotal;
    uint256 public femaleTotal;

    function record(string memory group, uint256 index) public {
        counts[group][index]++;
        if (index > maxIndex[group]) maxIndex[group] = index;
    }

    function incrementSuccess(bool isMale) public {
        successfulRuns++;
        if (isMale) maleTotal++; else femaleTotal++;
    }
}

contract TraitsSimulationTest is Test {
    Traits public traitsContract;
    CumulativeStats public stats;

    function setUp() public {
        traitsContract = new Traits(new Probs());
        stats = new CumulativeStats();
    }

    function test_Simulate10K() public {
        uint256 RUNS = 1000;

        for (uint256 i = 1; i <= RUNS; i++) {
            uint16 tokenIdSeed = uint16(i);
            uint256 globalSeed = 987654321;

            try traitsContract.generateTraitsContext(tokenIdSeed, 0, globalSeed)
                returns (TraitsContext memory ctx)
            {
                bool isMale = (ctx.sex == E_Sex.Male);
                stats.incrementSuccess(isMale);

                stats.record("sex", uint(ctx.sex));
                stats.record("length", ctx.traitsToRenderLength);
                stats.record("mouth", uint(ctx.mouth));

                if (isMale) {
                    stats.record("m_skin", uint(ctx.maleSkin));
                    stats.record("m_eyes", uint(ctx.maleEyes));
                    stats.record("m_face", uint(ctx.maleFace));
                    stats.record("m_chain", uint(ctx.maleChain));
                    stats.record("m_earring", uint(ctx.maleEarring));
                    stats.record("m_scarf", uint(ctx.maleScarf));
                    stats.record("m_facialHair", uint(ctx.maleFacialHair));
                    stats.record("m_mask", uint(ctx.maleMask));
                    stats.record("m_hair", uint(ctx.maleHair));
                    stats.record("m_hatHair", uint(ctx.maleHatHair));
                    stats.record("m_headwear", uint(ctx.maleHeadwear));
                    stats.record("m_eyeWear", uint(ctx.maleEyeWear));
                } else {
                    stats.record("f_skin", uint(ctx.femaleSkin));
                    stats.record("f_eyes", uint(ctx.femaleEyes));
                    stats.record("f_face", uint(ctx.femaleFace));
                    stats.record("f_chain", uint(ctx.femaleChain));
                    stats.record("f_earring", uint(ctx.femaleEarring));
                    stats.record("f_scarf", uint(ctx.femaleScarf));
                    stats.record("f_mask", uint(ctx.femaleMask));
                    stats.record("f_hair", uint(ctx.femaleHair));
                    stats.record("f_hatHair", uint(ctx.femaleHatHair));
                    stats.record("f_headwear", uint(ctx.femaleHeadwear));
                    stats.record("f_eyeWear", uint(ctx.femaleEyeWear));
                }
            } catch {}
        }

        _printReport();
    }

    function _printReport() internal view {
        uint256 total = stats.successfulRuns();
        uint256 mTotal = stats.maleTotal();
        uint256 fTotal = stats.femaleTotal();

        console.log("----------------------------------------------------------------");
        console.log("FINAL RARITY REPORT: 10,000 RUNS");
        console.log("----------------------------------------------------------------");
        console.log("Successful Gen: ", total);
        console.log("Total Males:    ", mTotal);
        console.log("Total Females:  ", fTotal);

        _logGroup("sex", "SEX", total);
        _logGroup("length", "RENDER LENGTHS", total);
        
        console.log("");
        console.log(">>> MALE GROUP RARITIES");
        _logGroup("m_skin", "Skin", mTotal);
        _logGroup("m_eyes", "Eyes", mTotal);
        _logGroup("m_face", "Face", mTotal);
        _logGroup("m_chain", "Chain", mTotal);
        _logGroup("m_earring", "Earring", mTotal);
        _logGroup("m_scarf", "Scarf", mTotal);
        _logGroup("m_facialHair", "Facial Hair", mTotal);
        _logGroup("m_mask", "Mask", mTotal);
        _logGroup("m_hair", "Hair", mTotal);
        _logGroup("m_hatHair", "Hat Hair", mTotal);
        _logGroup("m_headwear", "Headwear", mTotal);
        _logGroup("m_eyeWear", "Eye Wear", mTotal);

        console.log("");
        console.log(">>> FEMALE GROUP RARITIES");
        _logGroup("f_skin", "Skin", fTotal);
        _logGroup("f_eyes", "Eyes", fTotal);
        _logGroup("f_face", "Face", fTotal);
        _logGroup("f_chain", "Chain", fTotal);
        _logGroup("f_earring", "Earring", fTotal);
        _logGroup("f_scarf", "Scarf", fTotal);
        _logGroup("f_mask", "Mask", fTotal);
        _logGroup("f_hair", "Hair", fTotal);
        _logGroup("f_hatHair", "Hat Hair", fTotal);
        _logGroup("f_headwear", "Headwear", fTotal);
        _logGroup("f_eyeWear", "Eye Wear", fTotal);

        console.log("");
        console.log(">>> SHARED");
        _logGroup("mouth", "Mouth", total);
        console.log("----------------------------------------------------------------");
    }

    function _logGroup(string memory key, string memory label, uint256 divisor) internal view {
        if (divisor == 0) return;
        uint256 max = stats.maxIndex(key);
        console.log("");
        console.log("-- ", label);
        for (uint i = 0; i <= max; i++) {
            uint256 count = stats.counts(key, i);
            uint256 p = (count * 1000) / divisor;
            string memory dStr = (p % 100) < 10 ? string.concat("0", vm.toString(p % 100)) : vm.toString(p % 100);

            string memory name = _getName(key, i);
            // Format: "  <Name> [<Idx>]: <count> (<pct>%)"
            console.log(string.concat("  ", name, " [", vm.toString(i), "]: ", vm.toString(count), " (", vm.toString(p/100), ".", dStr, "%)"));
        }
    }

    // Returns a readable name for a (group, index).
    // - sex returns "Male"/"Female"
    // - length returns "Len X"
    // - mouth returns "Mouth X"
    // - all others return "Option X" by default (you can change to real names)
    function _getName(string memory key, uint i) internal pure returns (string memory) {
        bytes32 k = keccak256(abi.encodePacked(key));

        if (k == keccak256(abi.encodePacked("sex"))) {
            if (i == uint(E_Sex.Male)) return "Male";
            if (i == uint(E_Sex.Female)) return "Female";
            return string.concat("Sex_", vm.toString(i));
        }

        if (k == keccak256(abi.encodePacked("length"))) {
            return string.concat("Len ", vm.toString(i));
        }

        if (k == keccak256(abi.encodePacked("mouth"))) {
            return string.concat("Mouth ", vm.toString(i));
        }

        //
        // Default per-group naming — replace these with your actual names for better output.
        // Example: if you know m_skin index 0 is "Light" and 1 is "Dark", replace Option names below.
        //
        if (k == keccak256(abi.encodePacked("m_skin")) ||
            k == keccak256(abi.encodePacked("f_skin"))) {
            return string.concat("Skin Option ", vm.toString(i));
        }

        if (k == keccak256(abi.encodePacked("m_eyes")) ||
            k == keccak256(abi.encodePacked("f_eyes"))) {
            return string.concat("Eyes Option ", vm.toString(i));
        }

        if (k == keccak256(abi.encodePacked("m_face")) ||
            k == keccak256(abi.encodePacked("f_face"))) {
            return string.concat("Face Option ", vm.toString(i));
        }

        if (k == keccak256(abi.encodePacked("m_chain")) ||
            k == keccak256(abi.encodePacked("f_chain"))) {
            return string.concat("Chain Option ", vm.toString(i));
        }

        if (k == keccak256(abi.encodePacked("m_earring")) ||
            k == keccak256(abi.encodePacked("f_earring"))) {
            return string.concat("Earring Option ", vm.toString(i));
        }

        if (k == keccak256(abi.encodePacked("m_scarf")) ||
            k == keccak256(abi.encodePacked("f_scarf"))) {
            return string.concat("Scarf Option ", vm.toString(i));
        }

        if (k == keccak256(abi.encodePacked("m_facialHair"))) {
            return string.concat("FacialHair Option ", vm.toString(i));
        }

        if (k == keccak256(abi.encodePacked("m_mask")) ||
            k == keccak256(abi.encodePacked("f_mask"))) {
            return string.concat("Mask Option ", vm.toString(i));
        }

        if (k == keccak256(abi.encodePacked("m_hair")) ||
            k == keccak256(abi.encodePacked("f_hair"))) {
            return string.concat("Hair Option ", vm.toString(i));
        }

        if (k == keccak256(abi.encodePacked("m_hatHair")) ||
            k == keccak256(abi.encodePacked("f_hatHair"))) {
            return string.concat("HatHair Option ", vm.toString(i));
        }

        if (k == keccak256(abi.encodePacked("m_headwear")) ||
            k == keccak256(abi.encodePacked("f_headwear"))) {
            return string.concat("Headwear Option ", vm.toString(i));
        }

        if (k == keccak256(abi.encodePacked("m_eyeWear")) ||
            k == keccak256(abi.encodePacked("f_eyeWear"))) {
            return string.concat("EyeWear Option ", vm.toString(i));
        }

        // Fallback generic name
        return string.concat("Option ", vm.toString(i));
    }
}
