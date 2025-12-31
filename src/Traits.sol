// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { ITraits } from './interfaces/ITraits.sol';
import { IProbs } from './interfaces/IProbs.sol';
import { NUM_SPECIAL_1S, E_Sex, E_Background, E_Male_Skin, E_Male_Eyes, E_Male_Face, E_Male_Chain, E_Male_Earring, E_Male_Scarf, E_Male_Facial_Hair, E_Male_Mask, E_Male_Hair, E_Male_Hat_Hair, E_Male_Headwear, E_Male_Eye_Wear, E_Female_Skin, E_Female_Eyes, E_Female_Face, E_Female_Chain, E_Female_Earring, E_Female_Scarf, E_Female_Mask, E_Female_Hair, E_Female_Hat_Hair, E_Female_Headwear, E_Female_Eye_Wear, E_Mouth, E_Filler_Traits, E_TraitsGroup } from "./common/Enums.sol";
import { TraitsContext, TraitToRender, FillerTrait, MaleTraits, FemaleTraits } from "./common/Structs.sol";
import { LibPRNG } from "./libraries/LibPRNG.sol";
import { LibTraits } from "./libraries/LibTraits.sol";

/**
 * @author ECHO
 */

contract Traits is ITraits {

    IProbs public immutable PROBS_CONTRACT;

    uint32 private constant MIN_DATE = 4102444800;
    uint32 private constant RANGE_SIZE = 31496399; // (4133941199 - 4102444800) / max date - min date

    error TraitsArrayOverflow(uint8 currentLength, uint8 maxLength);
    error InvalidTraitIndex(uint8 traitGroupIndex, uint8 traitIndex);

    constructor(IProbs _probsContract) {
        PROBS_CONTRACT = _probsContract;
    }

    function generateTraitsContext(uint16 _tokenIdSeed, uint8 _backgroundIndex, uint256 _globalSeed) external view returns (TraitsContext memory) {
        LibPRNG.PRNG memory prng;
        LibPRNG.seed(prng, uint256(keccak256(abi.encodePacked(_tokenIdSeed, _globalSeed))));
        TraitsContext memory traits;
        traits.traitsToRender = new TraitToRender[](15);
        traits.tokenIdSeed = _tokenIdSeed;

        if (_tokenIdSeed < NUM_SPECIAL_1S) {
            traits.specialId = _tokenIdSeed + 1;
        }

        traits.birthday = uint32(MIN_DATE + LibPRNG.uniform(prng, RANGE_SIZE + 1));

        if (traits.specialId > 0) {
            
            uint16 specialIdx = traits.specialId - 1;
            
            if (specialIdx < 7) {
                return traits; 
            } 
            
            traits.background = E_Background(_backgroundIndex);
            _addBackground(traits);
            _addSpecial(traits, specialIdx);

            return traits;
        }

        traits.sex = LibPRNG.uniform(prng, 10000) < 7500 ? E_Sex.Male : E_Sex.Female;
        
        if (traits.sex == E_Sex.Male) {

            traits.background = E_Background(_backgroundIndex);
            _addBackground(traits);

            MaleTraits memory m = PROBS_CONTRACT.selectAllMaleTraits(traits, prng);
            
            traits.maleSkin = m.skin;
            traits.maleEyes = m.eyes;
            traits.maleFace = m.face;
            traits.maleChain = m.chain;
            traits.maleEarring = m.earring;
            traits.maleFacialHair = m.facialHair;
            traits.maleMask = m.mask;
            traits.maleScarf = m.scarf;
            traits.maleHair = m.hair;
            traits.maleHatHair = m.hatHair;
            traits.maleHeadwear = m.headwear;
            traits.maleEyeWear = m.eyeWear;
            traits.mouth = m.mouth;

            _addMaleSkin(traits);
            _addMaleEyes(traits);
            _addMaleFace(traits);
            _addMaleChain(traits);
            _addMaleEarring(traits);

            // 80% Facial Hair, 10% Mask, 10% nothing
            if (LibTraits.maleHasFacialHair(traits)) {
                _addMaleFacialHair(traits);
            } else {
                _addMaleMask(traits); 
            }

            _addMaleScarf(traits);
            
            // 60% chance of headwear
            if (LibTraits.maleHasHeadwear(traits)) {
                // 30% chance of hat hair
                _addMaleHatHair(traits);
            } else {
                // 36% chance of regular hair
                // 4% chance of nothing (bald)
                _addMaleHair(traits);
            }

            _addMaleHeadwear(traits);
            _addMaleEyeWear(traits);

            if (!LibTraits.maleHasMask(traits)) {
                _addMouth(traits);
            }
        }

        else {
            
            traits.background = E_Background(_backgroundIndex);
            _addBackground(traits);

            FemaleTraits memory f = PROBS_CONTRACT.selectAllFemaleTraits(traits, prng);
            
            traits.femaleSkin = f.skin;
            traits.femaleEyes = f.eyes;
            traits.femaleFace = f.face;
            traits.femaleChain = f.chain;
            traits.femaleEarring = f.earring;
            traits.femaleMask = f.mask;
            traits.femaleScarf = f.scarf;
            traits.femaleHair = f.hair;
            traits.femaleHatHair = f.hatHair;
            traits.femaleHeadwear = f.headwear;
            traits.femaleEyeWear = f.eyeWear;
            traits.mouth = f.mouth;

            _addFemaleSkin(traits);
            _addFemaleEyes(traits);
            _addFemaleFace(traits);
            _addFemaleChain(traits);
            _addFemaleEarring(traits);
            _addFemaleMask(traits);
            _addFemaleScarf(traits);

            // Hat hair or regular hair
            if (LibTraits.femaleHasHeadwear(traits)) {
                _addFemaleHatHair(traits);
            } else {
                _addFemaleHair(traits);
            }
            
            _addFemaleHeadwear(traits);
            _addFemaleEyeWear(traits);

            if (!LibTraits.femaleHasMask(traits)) {
                _addMouth(traits);
            }
        }

        return traits;
    }

    function _addSpecial(TraitsContext memory traits, uint specialIdx) internal pure {
        _addTraitToRender(traits, E_TraitsGroup.Special_1s_Group, uint8(specialIdx));
    }

    function _addMaleSkin(TraitsContext memory traits) internal pure {
        _addTraitToRender(traits, E_TraitsGroup.Male_Skin_Group, uint8(traits.maleSkin));
    } 
    
    function _addMaleEyes(TraitsContext memory traits) internal pure {
        if (traits.maleEyes == E_Male_Eyes.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Eyes_Group, uint8(traits.maleEyes));
    }

    function _addMaleFace(TraitsContext memory traits) internal pure {
        if (traits.maleFace == E_Male_Face.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Face_Group, uint8(traits.maleFace));
    }

    function _addMaleChain(TraitsContext memory traits) internal pure {
        if (traits.maleChain == E_Male_Chain.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Chain_Group, uint8(traits.maleChain));
    }

    function _addMaleScarf(TraitsContext memory traits) internal pure {
        if (traits.maleScarf == E_Male_Scarf.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Scarf_Group, uint8(traits.maleScarf));
    }

    function _addMaleEarring(TraitsContext memory traits) internal pure {
        if (traits.maleEarring == E_Male_Earring.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Earring_Group, uint8(traits.maleEarring));
    }

    function _addMaleFacialHair(TraitsContext memory traits) internal pure {
        if (traits.maleFacialHair == E_Male_Facial_Hair.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Facial_Hair_Group, uint8(traits.maleFacialHair));
    }

    function _addMaleMask(TraitsContext memory traits) internal pure {
        if (traits.maleMask == E_Male_Mask.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Mask_Group, uint8(traits.maleMask));
    }

    function _addMaleHair(TraitsContext memory traits) internal pure {
        if (traits.maleHair == E_Male_Hair.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Hair_Group, uint8(traits.maleHair));
    }

    function _addMaleHatHair(TraitsContext memory traits) internal pure {
        if (traits.maleHatHair == E_Male_Hat_Hair.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Hat_Hair_Group, uint8(traits.maleHatHair));
    }

    function _addMaleHeadwear(TraitsContext memory traits) internal pure {
        if (traits.maleHeadwear == E_Male_Headwear.None) return;

        _addTraitToRender(traits, E_TraitsGroup.Male_Headwear_Group, uint8(traits.maleHeadwear));
        
        // Add filler traits for certain skin types to cover headwear properly
        if (traits.maleSkin == E_Male_Skin.Robot) {
            _addFillerTrait(traits, E_TraitsGroup.Filler_Traits_Group, uint8(E_Filler_Traits.Male_Robot_Headwear_Cover));
        }

        if (traits.maleSkin == E_Male_Skin.Pumpkin) {
            _addFillerTrait(traits, E_TraitsGroup.Filler_Traits_Group, uint8(E_Filler_Traits.Male_Pumpkin_Headwear_Cover));
        }
    }

    function _addMaleEyeWear(TraitsContext memory traits) internal pure {
        if (traits.maleEyeWear == E_Male_Eye_Wear.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Male_Eye_Wear_Group, uint8(traits.maleEyeWear));
    }

    function _addFemaleSkin(TraitsContext memory traits) internal pure {
        _addTraitToRender(traits, E_TraitsGroup.Female_Skin_Group, uint8(traits.femaleSkin));
    }

    function _addFemaleEyes(TraitsContext memory traits) internal pure {
        if (traits.femaleEyes == E_Female_Eyes.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Eyes_Group, uint8(traits.femaleEyes));
    }

    function _addFemaleFace(TraitsContext memory traits) internal pure {
        if (traits.femaleFace == E_Female_Face.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Face_Group, uint8(traits.femaleFace));
    }

    function _addFemaleChain(TraitsContext memory traits) internal pure {
        if (traits.femaleChain == E_Female_Chain.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Chain_Group, uint8(traits.femaleChain));
    }

    function _addFemaleScarf(TraitsContext memory traits) internal pure {
        if (traits.femaleScarf == E_Female_Scarf.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Scarf_Group, uint8(traits.femaleScarf));
    }

    function _addFemaleEarring(TraitsContext memory traits) internal pure {
        if (traits.femaleEarring == E_Female_Earring.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Earring_Group, uint8(traits.femaleEarring));
    }

    function _addFemaleMask(TraitsContext memory traits) internal pure {
        if (traits.femaleMask == E_Female_Mask.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Mask_Group, uint8(traits.femaleMask));
    }

    function _addFemaleHair(TraitsContext memory traits) internal pure {
        if (traits.femaleHair == E_Female_Hair.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Hair_Group, uint8(traits.femaleHair));
    }

    function _addFemaleHatHair(TraitsContext memory traits) internal pure {
        if (traits.femaleHatHair == E_Female_Hat_Hair.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Hat_Hair_Group, uint8(traits.femaleHatHair));
    }

    function _addFemaleHeadwear(TraitsContext memory traits) internal pure {
        if (traits.femaleHeadwear == E_Female_Headwear.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Headwear_Group, uint8(traits.femaleHeadwear));

        // Add filler trait for robot skin
        if (traits.femaleSkin == E_Female_Skin.Robot) {
            _addFillerTrait(traits, E_TraitsGroup.Filler_Traits_Group, uint8(E_Filler_Traits.Female_Robot_Headwear_Cover));
        }
    }

    function _addFemaleEyeWear(TraitsContext memory traits) internal pure {
        if (traits.femaleEyeWear == E_Female_Eye_Wear.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Female_Eye_Wear_Group, uint8(traits.femaleEyeWear));
    }

    function _addMouth(TraitsContext memory traits) internal pure {
        if (traits.mouth == E_Mouth.None) return;
        _addTraitToRender(traits, E_TraitsGroup.Mouth_Group, uint8(traits.mouth));
    }

    function _addBackground(TraitsContext memory traits) internal pure {
        _addTraitToRender(traits, E_TraitsGroup.Background_Group, uint8(traits.background));
    }

    function _addTraitToRender(TraitsContext memory _traits, E_TraitsGroup _traitGroup, uint8 _traitIndex) internal pure {  
        TraitToRender memory traitToRender;
        traitToRender.traitGroup = _traitGroup;
        traitToRender.traitIndex = _traitIndex;
        traitToRender.hasFiller = false;
        
        _traits.traitsToRender[_traits.traitsToRenderLength] = traitToRender;
        _traits.traitsToRenderLength++;
    }

    function _addFillerTrait(TraitsContext memory _traits, E_TraitsGroup _traitGroup, uint8 _traitIndex) internal pure {
        FillerTrait memory filler;
        filler.traitGroup = _traitGroup;
        filler.traitIndex = _traitIndex;
        
        uint idx = _traits.traitsToRenderLength - 1;
        _traits.traitsToRender[idx].hasFiller = true;
        _traits.traitsToRender[idx].filler = filler;
    }
}