// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "forge-std/console.sol";

// Contract Imports
import { Traits } from "../src/Traits.sol";
import { MaleProbs } from "../src/MaleProbs.sol";     // Ensure path is correct
import { FemaleProbs } from "../src/FemaleProbs.sol"; // Ensure path is correct

// Struct & Enum Imports
import { TraitsContext, TraitToRender } from "../src/common/Structs.sol";
import { 
    E_Sex, E_Background, E_Male_Skin, E_Male_Eyes, E_Male_Face, 
    E_Male_Chain, E_Male_Earring, E_Male_Scarf, E_Male_Facial_Hair, 
    E_Male_Mask, E_Male_Hair, E_Male_Hat_Hair, E_Male_Headwear, 
    E_Male_Eye_Wear, E_Female_Skin, E_Female_Eyes, E_Female_Face, 
    E_Female_Chain, E_Female_Earring, E_Female_Scarf, E_Female_Mask, 
    E_Female_Hair, E_Female_Hat_Hair, E_Female_Headwear, E_Female_Eye_Wear, 
    E_Mouth 
} from "../src/common/Enums.sol";

contract TraitsProductionTest is Test {
    Traits public traitsContract;
    MaleProbs public maleProbs;
    FemaleProbs public femaleProbs;

    function setUp() public {
        // 1. Deploy the actual probability contracts
        maleProbs = new MaleProbs();
        femaleProbs = new FemaleProbs();

        // 2. Deploy Traits with the actual contract addresses
        traitsContract = new Traits(maleProbs, femaleProbs);
    }

    function testGenerateActualTraits() public view {
        // --- INPUT PARAMETERS ---
        uint16 tokenIdSeed = 444; 
        uint8 backgroundIndex = 0;
        uint256 globalSeed = 987654321;

        // --- EXECUTION ---
        TraitsContext memory ctx = traitsContract.generateAllTraits(tokenIdSeed, backgroundIndex, globalSeed);

        // --- ORGANIZED OUTPUT (Matching TraitsContext Struct Order) ---
        console.log("==================================================");
        console.log("TRAITS CONTEXT: TERMINAL REPORT");
        console.log("==================================================");
        console.log("");

        // 1. traitsToRender (Array)
        console.log("traitsToRender:");
        for (uint8 i = 0; i < ctx.traitsToRenderLength; i++) {
            TraitToRender memory t = ctx.traitsToRender[i];
            console.log("  [%s] Group: %s | Index: %s", i, uint(t.traitGroup), t.traitIndex);
            if (t.hasFiller) {
                console.log("      (Filler) Group: %s | Index: %s", uint(t.filler.traitGroup), t.filler.traitIndex);
            }
        }

        
        // 2. traitsToRenderLength
        console.log("");
        console.log("traitsToRenderLength: ", ctx.traitsToRenderLength);

        // 3. tokenIdSeed
        console.log("");
        console.log("tokenIdSeed:          ", ctx.tokenIdSeed);

        // 4. specialId
        console.log("");
        console.log("specialId:            ", ctx.specialId);

        // 5. birthday
        console.log("");
        console.log("birthday:             ", ctx.birthday);

        // 6. sex
        string memory sexStr = ctx.sex == E_Sex.Male ? "Male" : "Female";
        console.log("");
        console.log("sex:                  ", sexStr);

        // 7. background
        console.log("");
        console.log("background:           ", uint(ctx.background));

        // 8. Male Traits List
        console.log("");
        console.log("--- Male Traits ---");
        console.log("maleSkin:             ", uint(ctx.maleSkin));
        console.log("maleEyes:             ", uint(ctx.maleEyes));
        console.log("maleFace:             ", uint(ctx.maleFace));
        console.log("maleChain:            ", uint(ctx.maleChain));
        console.log("maleEarring:          ", uint(ctx.maleEarring));
        console.log("maleScarf:            ", uint(ctx.maleScarf));
        console.log("maleFacialHair:       ", uint(ctx.maleFacialHair));
        console.log("maleMask:             ", uint(ctx.maleMask));
        console.log("maleHair:             ", uint(ctx.maleHair));
        console.log("maleHatHair:          ", uint(ctx.maleHatHair));
        console.log("maleHeadwear:         ", uint(ctx.maleHeadwear));
        console.log("maleEyeWear:          ", uint(ctx.maleEyeWear));

        // 9. Female Traits List
        console.log("");
        console.log("--- Female Traits ---");
        console.log("femaleSkin:           ", uint(ctx.femaleSkin));
        console.log("femaleEyes:           ", uint(ctx.femaleEyes));
        console.log("femaleFace:           ", uint(ctx.femaleFace));
        console.log("femaleChain:          ", uint(ctx.femaleChain));
        console.log("femaleEarring:        ", uint(ctx.femaleEarring));
        console.log("femaleScarf:          ", uint(ctx.femaleScarf));
        console.log("femaleMask:           ", uint(ctx.femaleMask));
        console.log("femaleHair:           ", uint(ctx.femaleHair));
        console.log("femaleHatHair:        ", uint(ctx.femaleHatHair));
        console.log("femaleHeadwear:       ", uint(ctx.femaleHeadwear));
        console.log("femaleEyeWear:        ", uint(ctx.femaleEyeWear));

        // 10. Mouth
        console.log("");
        console.log("--- Shared Traits ---");
        console.log("mouth:                ", uint(ctx.mouth));
        console.log("");
        console.log("==================================================");
    }
}