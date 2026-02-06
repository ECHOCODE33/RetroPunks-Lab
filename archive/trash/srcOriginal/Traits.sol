// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import { IFemaleProbabilities } from './interfaces/IFemaleProbabilities.sol';
import { IMaleProbabilities } from './interfaces/IMaleProbabilities.sol';
import { Random, RandomCtx } from "./libraries/Random.sol";
import { TraitsContext, TraitToRender, FillerTrait } from "./common/Structs.sol";
import { NUM_SPECIAL_1S, E_Sex, E_Special_1s, E_Background, E_Male_Skin, E_Male_Eyes, E_Male_Face, E_Male_Chain, E_Male_Earring, E_Male_Scarf, E_Male_Facial_Hair, E_Male_Mask, E_Male_Hair, E_Male_Hat_Hair, E_Male_Headwear, E_Male_Eye_Wear, E_Female_Skin, E_Female_Eyes, E_Female_Face, E_Female_Chain, E_Female_Earring, E_Female_Scarf, E_Female_Mask, E_Female_Hair, E_Female_Hat_Hair, E_Female_Headwear, E_Female_Eye_Wear, E_Mouth, E_Filler_Traits, E_TraitsGroup } from "./common/Enums.sol";
import { TraitsUtils } from "./libraries/TraitsUtils.sol";
import { ITraits } from './interfaces/ITraits.sol';

contract Traits is ITraits {

    IMaleProbabilities public immutable MALE_PROBS_CONTRACT;
    IFemaleProbabilities public immutable FEMALE_PROBS_CONTRACT;

    constructor(IMaleProbabilities _maleProbsContract, IFemaleProbabilities _femaleProbsContract) {
        MALE_PROBS_CONTRACT = _maleProbsContract;
        FEMALE_PROBS_CONTRACT = _femaleProbsContract;
    }

    function generateAllTraits(uint16 _tokenIdSeed, uint16 _backgroundIndex, uint256 _globalSeed) external view returns (TraitsContext memory) {
        RandomCtx memory rndCtx = Random.initCtx(_tokenIdSeed, _globalSeed);

        uint16 specialId = 0;

        if (_tokenIdSeed < NUM_SPECIAL_1S) {
            specialId = _tokenIdSeed + 1;
        }
        
        TraitsContext memory traits;

        traits.traitsToRender = new TraitToRender[](15);

        traits.tokenIdSeed = _tokenIdSeed;
        traits.globalSeed = _globalSeed;

        traits.specialId = specialId;

        uint32 minDate = 4102444800; //    Jan 1,    2100, 12:00 AM
        uint32 maxDate = 4133941199; // December 31, 2100, 11:59 PM
        traits.birthday = uint32(Random.randRange(rndCtx, minDate, maxDate));

        traits.sex = Random.randBool(rndCtx, 6600) ? E_Sex.Male : E_Sex.Female; // 2/3 chance Male

        if (traits.specialId > 0) {
            if (traits.specialId - 1 == uint(E_Special_1s.Pig) ||
                traits.specialId - 1 == uint(E_Special_1s.Slenderman) ||
                traits.specialId - 1 == uint(E_Special_1s.The_Witch) ||
                traits.specialId - 1 == uint(E_Special_1s.The_Wizard)
            ){
                addSpecial(traits, specialId - 1);
            }
        }
  
        else if (traits.sex == E_Sex.Male) {
            traits.maleSkinType = MALE_PROBS_CONTRACT.selectMaleSkinType(rndCtx);
            addMaleSkinType(traits);

            traits.maleEyes = MALE_PROBS_CONTRACT.selectMaleEyes(traits, rndCtx);
            traits.maleFace = MALE_PROBS_CONTRACT.selectMaleFace(traits, rndCtx);
            traits.maleChain = MALE_PROBS_CONTRACT.selectMaleChain(rndCtx);
            traits.maleEarring = MALE_PROBS_CONTRACT.selectMaleEarring(rndCtx);
            traits.maleFacialHair = MALE_PROBS_CONTRACT.selectMaleFacialHair(traits, rndCtx);
            traits.maleMask = MALE_PROBS_CONTRACT.selectMaleMask(rndCtx);
            traits.maleScarf = MALE_PROBS_CONTRACT.selectMaleScarf(rndCtx);
            traits.maleHair = MALE_PROBS_CONTRACT.selectMaleHair(traits, rndCtx);
            traits.maleHatHair = MALE_PROBS_CONTRACT.selectMaleHatHair(traits, rndCtx);
            traits.maleHeadwear = MALE_PROBS_CONTRACT.selectMaleHeadwear(rndCtx);
            traits.maleEyeWear = MALE_PROBS_CONTRACT.selectMaleEyeWear(rndCtx);

            addMaleEyes(traits);
            addMaleFace(traits);
            addMaleChain(traits);
            addMaleEarring(traits);

            // 80% Facial Hair, 10% Mask, 10% nothing
            if (TraitsUtils.maleHasFacialHair(traits)) {
                addMaleFacialHair(traits);
            } else {
                addMaleMask(traits); 
            }

            addMaleScarf(traits);
            
            // 60% chance
            if (TraitsUtils.maleHasHeadwear(traits)) {
                // 0.6 x 0.5 = 30% chance
                addMaleHatHair(traits);
            } else {
                // 0.4 x 0.9 = 36% chance
                // 0.4 x 0.1 = 4% chance of nothing
                addMaleHair(traits);
            }

            addMaleHeadwear(traits);
        
            addMaleEyeWear(traits);
        }

        else {
            traits.femaleSkinType = FEMALE_PROBS_CONTRACT.selectFemaleSkinType(rndCtx);
            addFemaleSkinType(traits);

            traits.femaleEyes = FEMALE_PROBS_CONTRACT.selectFemaleEyes(traits, rndCtx);
            traits.femaleFace = FEMALE_PROBS_CONTRACT.selectFemaleFace(traits, rndCtx);
            traits.femaleChain = FEMALE_PROBS_CONTRACT.selectFemaleChain(rndCtx);
            traits.femaleEarring = FEMALE_PROBS_CONTRACT.selectFemaleEarring(rndCtx);
            traits.femaleMask = FEMALE_PROBS_CONTRACT.selectFemaleMask(rndCtx);
            traits.femaleScarf = FEMALE_PROBS_CONTRACT.selectFemaleScarf(rndCtx);
            traits.femaleHair = FEMALE_PROBS_CONTRACT.selectFemaleHair(traits, rndCtx);
            traits.femaleHatHair = FEMALE_PROBS_CONTRACT.selectFemaleHatHair(traits, rndCtx);
            traits.femaleHeadwear = FEMALE_PROBS_CONTRACT.selectFemaleHeadwear(rndCtx);
            traits.femaleEyeWear = FEMALE_PROBS_CONTRACT.selectFemaleEyeWear(rndCtx);

            addFemaleEyes(traits);
            addFemaleFace(traits);
            addFemaleChain(traits);
            addFemaleEarring(traits);
            addFemaleMask(traits);
            addFemaleScarf(traits);

            // Hat Hair or Hat
            if (TraitsUtils.femaleHasHeadwear(traits)) {
                addFemaleHatHair(traits);
            } else {
                addFemaleHair(traits);
            }
            
            addFemaleHeadwear(traits);
        
            addFemaleEyeWear(traits);
        }

        traits.mouth = MALE_PROBS_CONTRACT.selectMouth(traits, rndCtx);

        if (!TraitsUtils.femaleHasMask(traits)) {
            addMouth(traits);
        }

        traits.background = E_Background(_backgroundIndex);
        addBackground(traits);

        return traits;
    }

    function addSpecial(TraitsContext memory traits, uint specialIdx) internal pure {
        E_Special_1s special = E_Special_1s(specialIdx);
        addTraitToRender(traits, E_TraitsGroup.Special_1s_Group, uint8(special));
    }

    function addMaleSkinType(TraitsContext memory traits) internal pure {
        addTraitToRender(traits, E_TraitsGroup.Male_Skin_Group, uint8(traits.maleSkinType));
    } 
    
    function addMaleEyes(TraitsContext memory traits) internal pure {
        if (traits.maleEyes == E_Male_Eyes.None) return;
        addTraitToRender(traits, E_TraitsGroup.Male_Eyes_Group, uint8(traits.maleEyes));
    }

    function addMaleFace(TraitsContext memory traits) internal pure {
        if (traits.maleFace == E_Male_Face.None) return;
        addTraitToRender(traits, E_TraitsGroup.Male_Face_Group, uint8(traits.maleFace));
    }

    function addMaleChain(TraitsContext memory traits) internal pure {
        if (traits.maleChain == E_Male_Chain.None) return;
        addTraitToRender(traits, E_TraitsGroup.Male_Chain_Group, uint8(traits.maleChain));
    }

    function addMaleScarf(TraitsContext memory traits) internal pure {
        if (traits.maleScarf == E_Male_Scarf.None) return;
        addTraitToRender(traits, E_TraitsGroup.Male_Scarf_Group, uint8(traits.maleScarf));
    }

    function addMaleEarring(TraitsContext memory traits) internal pure {
        if (traits.maleEarring == E_Male_Earring.None) return;
        addTraitToRender(traits, E_TraitsGroup.Male_Earring_Group, uint8(traits.maleEarring));
    }

    function addMaleFacialHair(TraitsContext memory traits) internal pure {
        if (traits.maleFacialHair == E_Male_Facial_Hair.None) return;
        addTraitToRender(traits, E_TraitsGroup.Male_Facial_Hair_Group, uint8(traits.maleFacialHair));
    }

    function addMaleMask(TraitsContext memory traits) internal pure {
        if (traits.maleMask == E_Male_Mask.None) return;
        addTraitToRender(traits, E_TraitsGroup.Male_Mask_Group, uint8(traits.maleMask));
    }

    function addMaleHair(TraitsContext memory traits) internal pure {
        if (traits.maleHair == E_Male_Hair.None) return;
        addTraitToRender(traits, E_TraitsGroup.Male_Hair_Group, uint8(traits.maleHair));
    }

    function addMaleHatHair(TraitsContext memory traits) internal pure {
        if (traits.maleHatHair == E_Male_Hat_Hair.None) return;
        addTraitToRender(traits, E_TraitsGroup.Male_Hat_Hair_Group, uint8(traits.maleHatHair));
    }

    function addMaleHeadwear(TraitsContext memory traits) internal pure {
        if (traits.maleHeadwear == E_Male_Headwear.None) return;

        addTraitToRender(traits, E_TraitsGroup.Male_Headwear_Group, uint8(traits.maleHeadwear));
        
        if (traits.maleSkinType == E_Male_Skin.Robot) {
            addFillerTrait(traits, E_TraitsGroup.Filler_Traits_Group, uint8(E_Filler_Traits.Male_Robot_Headwear_Cover));
        }

        if (traits.maleSkinType == E_Male_Skin.Pumpkin) {
            addFillerTrait(traits, E_TraitsGroup.Filler_Traits_Group, uint8(E_Filler_Traits.Male_Pumpkin_Headwear_Cover));
        }
    }

    function addMaleEyeWear(TraitsContext memory traits) internal pure {
        if(traits.maleEyeWear == E_Male_Eye_Wear.None) return;
        addTraitToRender(traits, E_TraitsGroup.Male_Eye_Wear_Group, uint8(traits.maleEyeWear));
    }

    function addFemaleSkinType(TraitsContext memory traits) internal pure {
        addTraitToRender(traits, E_TraitsGroup.Female_Skin_Group, uint8(traits.femaleSkinType));
    }

    function addFemaleEyes(TraitsContext memory traits) internal pure {
        if (traits.femaleEyes == E_Female_Eyes.None) return;
        addTraitToRender(traits, E_TraitsGroup.Female_Eyes_Group, uint8(traits.femaleEyes));
    }

    function addFemaleFace(TraitsContext memory traits) internal pure {
        if (traits.femaleFace == E_Female_Face.None) return;
        addTraitToRender(traits, E_TraitsGroup.Female_Face_Group, uint8(traits.femaleFace));
    }

    function addFemaleChain(TraitsContext memory traits) internal pure {
        if (traits.femaleChain == E_Female_Chain.None) return;
        addTraitToRender(traits, E_TraitsGroup.Female_Chain_Group, uint8(traits.femaleChain));
    }

    function addFemaleScarf(TraitsContext memory traits) internal pure {
        if (traits.femaleScarf == E_Female_Scarf.None) return;
        addTraitToRender(traits, E_TraitsGroup.Female_Scarf_Group, uint8(traits.femaleScarf));
    }

    function addFemaleEarring(TraitsContext memory traits) internal pure {
        if (traits.femaleEarring == E_Female_Earring.None) return;
        addTraitToRender(traits, E_TraitsGroup.Female_Earring_Group, uint8(traits.femaleEarring));
    }

    function addFemaleMask(TraitsContext memory traits) internal pure {
        if (traits.femaleMask == E_Female_Mask.None) return;
        addTraitToRender(traits, E_TraitsGroup.Female_Mask_Group, uint8(traits.femaleMask));
    }

    function addFemaleHair(TraitsContext memory traits) internal pure {
        if (traits.femaleHair == E_Female_Hair.None) return;
        addTraitToRender(traits, E_TraitsGroup.Female_Hair_Group, uint8(traits.femaleHair));
    }

    function addFemaleHatHair(TraitsContext memory traits) internal pure {
        if (traits.femaleHatHair == E_Female_Hat_Hair.None) return;
        addTraitToRender(traits, E_TraitsGroup.Female_Hat_Hair_Group, uint8(traits.femaleHatHair));
    }

    function addFemaleHeadwear(TraitsContext memory traits) internal pure {
        if (traits.femaleHeadwear == E_Female_Headwear.None) return;
        addTraitToRender(traits, E_TraitsGroup.Female_Headwear_Group, uint8(traits.femaleHeadwear));

        if (traits.femaleSkinType == E_Female_Skin.Robot) {
            addFillerTrait(traits, E_TraitsGroup.Filler_Traits_Group, uint8(E_Filler_Traits.Female_Robot_Headwear_Cover));
        }
    }

    function addFemaleEyeWear(TraitsContext memory traits) internal pure {
        if (traits.femaleEyeWear == E_Female_Eye_Wear.None) return;
        addTraitToRender(traits, E_TraitsGroup.Female_Eye_Wear_Group, uint8(traits.femaleEyeWear));
    }

    function addMouth(TraitsContext memory traits) internal pure {
        if (traits.mouth == E_Mouth.None) return;
        addTraitToRender(traits, E_TraitsGroup.Mouth_Group, uint8(traits.mouth));
    }

    function addBackground(TraitsContext memory traits) internal pure {
        addTraitToRender(traits, E_TraitsGroup.Background_Group, uint8(traits.background));
    }

    function addTraitToRender(TraitsContext memory _ctx, E_TraitsGroup _traitGroup, uint8 _traitIndex) internal pure {
        TraitToRender memory traitToRender;
        traitToRender.traitGroup = _traitGroup;
        traitToRender.traitIndex = _traitIndex;
        traitToRender.hasFiller = false;
        _ctx.traitsToRender[_ctx.traitsToRenderLength] = traitToRender;
        _ctx.traitsToRenderLength++;
    }

    function addFillerTrait(TraitsContext memory _traits, E_TraitsGroup _traitGroup, uint8 _traitIndex) internal pure {
        FillerTrait memory filler;
        filler.traitGroup = _traitGroup;
        filler.traitIndex = _traitIndex; 
        
        _traits.traitsToRender[_traits.traitsToRenderLength - 1].hasFiller = true;
        _traits.traitsToRender[_traits.traitsToRenderLength - 1].filler = filler;
    }
}
