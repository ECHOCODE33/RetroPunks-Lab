// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

import { Rarities } from "./Rarities.sol";
import { E_Background, E_Female_Skin, E_Filler_Traits, E_Male_Skin, E_Sex, E_TraitsGroup, NUM_SPECIAL_1S } from "./common/Enums.sol";
import { FemaleTraits, MaleTraits, TraitToRender, TraitsContext } from "./common/Structs.sol";
import { ITraits } from "./interfaces/ITraits.sol";
import { LibPRNG } from "./libraries/LibPRNG.sol";
import { LibTraits } from "./libraries/LibTraits.sol";

/**
 * @title Traits
 * @author ECHO
 * @notice Generates traits for the RetroPunks collection, optimized for gas efficiency
 * @dev Inherits rarity values from Rarities contract and selects / generates traits using a PRNG for gas efficiency
 */
contract Traits is ITraits, Rarities {
    // uint32 private constant MIN_DATE = 4102444800;
    // uint32 private constant RANGE_SIZE = 31496399;

    uint256 private constant MALE_FILLER = (uint256(1) << uint256(E_Male_Skin.Robot)) | (uint256(1) << uint256(E_Male_Skin.Pumpkin));
    uint256 private constant FEMALE_FILLER = (uint256(1) << uint256(E_Female_Skin.Robot));

    function generateTraitsContext(uint16 _tokenIdSeed, uint8 _backgroundIndex, uint256 _globalSeed) external pure returns (TraitsContext memory) {
        LibPRNG.PRNG memory prng;
        LibPRNG.seed(prng, uint256(keccak256(abi.encodePacked(_tokenIdSeed, _globalSeed))));

        TraitsContext memory traits;
        traits.tokenIdSeed = _tokenIdSeed;
        traits.birthday = uint32(4102444800 + LibPRNG.uniform(prng, 31496399 + 1));

        if (_tokenIdSeed < NUM_SPECIAL_1S) {
            traits.specialId = _tokenIdSeed + 1;

            if (_tokenIdSeed < 7) return traits;

            traits.traitsToRender = new TraitToRender[](2);
            traits.background = E_Background(_backgroundIndex);
            _addTraitToRender(traits, E_TraitsGroup.Background_Group, uint8(traits.background));
            _addTraitToRender(traits, E_TraitsGroup.Special_1s_Group, uint8(_tokenIdSeed));

            return traits;
        }

        traits.traitsToRender = new TraitToRender[](15);

        traits.background = E_Background(_backgroundIndex);
        _addTraitToRender(traits, E_TraitsGroup.Background_Group, uint8(traits.background));

        traits.sex = LibPRNG.uniform(prng, 10000) < 7500 ? E_Sex.Male : E_Sex.Female;

        if (traits.sex == E_Sex.Male) {
            MaleTraits memory m = selectAllMaleTraits(traits, prng);

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

            _addTraitToRender(traits, E_TraitsGroup.Male_Skin_Group, uint8(m.skin));
            _addOptionalTrait(traits, E_TraitsGroup.Male_Eyes_Group, uint8(m.eyes));
            _addOptionalTrait(traits, E_TraitsGroup.Male_Face_Group, uint8(m.face));
            _addOptionalTrait(traits, E_TraitsGroup.Male_Chain_Group, uint8(m.chain));
            _addOptionalTrait(traits, E_TraitsGroup.Male_Earring_Group, uint8(m.earring));

            if (LibTraits.maleHasFacialHair(traits)) _addOptionalTrait(traits, E_TraitsGroup.Male_Facial_Hair_Group, uint8(m.facialHair));
            else _addOptionalTrait(traits, E_TraitsGroup.Male_Mask_Group, uint8(m.mask));

            _addOptionalTrait(traits, E_TraitsGroup.Male_Scarf_Group, uint8(m.scarf));

            // Add eye patch early (before hair/headwear) if applicable
            if (LibTraits.maleEyeWearIsEyePatch(traits)) _addOptionalTrait(traits, E_TraitsGroup.Male_Eye_Wear_Group, uint8(m.eyeWear));

            if (LibTraits.maleHasHeadwear(traits)) _addOptionalTrait(traits, E_TraitsGroup.Male_Hat_Hair_Group, uint8(m.hatHair));
            else _addOptionalTrait(traits, E_TraitsGroup.Male_Hair_Group, uint8(m.hair));

            // Add headwear only if NOT Cloak/Hoodie
            if (LibTraits.maleHasHeadwear(traits) && !LibTraits.maleHeadwearIsCloakOrHoodie(traits)) _addMaleHeadwear(traits);

            // Add regular eye wear (excluding eye patches)
            if (!LibTraits.maleEyeWearIsEyePatch(traits)) _addOptionalTrait(traits, E_TraitsGroup.Male_Eye_Wear_Group, uint8(m.eyeWear));

            // Add Cloak/Hoodie headwear after eye wear
            if (LibTraits.maleHasHeadwear(traits) && LibTraits.maleHeadwearIsCloakOrHoodie(traits)) _addMaleHeadwear(traits);

            if (!LibTraits.maleHasMask(traits)) _addOptionalTrait(traits, E_TraitsGroup.Mouth_Group, uint8(m.mouth));
        } else {
            FemaleTraits memory f = selectAllFemaleTraits(traits, prng);

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

            _addTraitToRender(traits, E_TraitsGroup.Female_Skin_Group, uint8(f.skin));
            _addOptionalTrait(traits, E_TraitsGroup.Female_Eyes_Group, uint8(f.eyes));
            _addOptionalTrait(traits, E_TraitsGroup.Female_Face_Group, uint8(f.face));
            _addOptionalTrait(traits, E_TraitsGroup.Female_Chain_Group, uint8(f.chain));
            _addOptionalTrait(traits, E_TraitsGroup.Female_Earring_Group, uint8(f.earring));
            _addOptionalTrait(traits, E_TraitsGroup.Female_Mask_Group, uint8(f.mask));
            _addOptionalTrait(traits, E_TraitsGroup.Female_Scarf_Group, uint8(f.scarf));

            // Add eye patch early (before hair/headwear) if applicable
            if (LibTraits.femaleEyeWearIsEyePatch(traits)) _addOptionalTrait(traits, E_TraitsGroup.Female_Eye_Wear_Group, uint8(f.eyeWear));

            if (LibTraits.femaleHasHeadwear(traits)) _addOptionalTrait(traits, E_TraitsGroup.Female_Hat_Hair_Group, uint8(f.hatHair));
            else _addOptionalTrait(traits, E_TraitsGroup.Female_Hair_Group, uint8(f.hair));

            // Add headwear only if NOT Cloak/Hoodie
            if (LibTraits.femaleHasHeadwear(traits) && !LibTraits.femaleHeadwearIsCloakOrHoodie(traits)) _addFemaleHeadwear(traits);

            // Add regular eye wear (excluding eye patches)
            if (!LibTraits.femaleEyeWearIsEyePatch(traits)) _addOptionalTrait(traits, E_TraitsGroup.Female_Eye_Wear_Group, uint8(f.eyeWear));

            // Add Cloak/Hoodie headwear after eye wear
            if (LibTraits.femaleHasHeadwear(traits) && LibTraits.femaleHeadwearIsCloakOrHoodie(traits)) _addFemaleHeadwear(traits);

            if (!LibTraits.femaleHasMask(traits)) _addOptionalTrait(traits, E_TraitsGroup.Mouth_Group, uint8(f.mouth));
        }

        return traits;
    }

    function _addOptionalTrait(TraitsContext memory _traits, E_TraitsGroup _group, uint8 _index) internal pure {
        if (_index == 0) return; // index 0 is always 'None'
        _addTraitToRender(_traits, _group, _index);
    }

    function _addMaleHeadwear(TraitsContext memory traits) internal pure {
        uint8 headwear = uint8(traits.maleHeadwear);
        if (headwear == 0) return;

        _addTraitToRender(traits, E_TraitsGroup.Male_Headwear_Group, headwear);

        if ((MALE_FILLER >> uint8(traits.maleSkin)) & 1 == 1) {
            uint8 filler = traits.maleSkin == E_Male_Skin.Robot ? uint8(E_Filler_Traits.Male_Robot_Headwear_Cover) : uint8(E_Filler_Traits.Male_Pumpkin_Headwear_Cover);

            _addFillerTrait(traits, E_TraitsGroup.Filler_Traits_Group, filler);
        }
    }

    function _addFemaleHeadwear(TraitsContext memory traits) internal pure {
        uint8 headwear = uint8(traits.femaleHeadwear);
        if (headwear == 0) return;

        _addTraitToRender(traits, E_TraitsGroup.Female_Headwear_Group, headwear);

        if ((FEMALE_FILLER >> uint8(traits.femaleSkin)) & 1 == 1) {
            _addFillerTrait(traits, E_TraitsGroup.Filler_Traits_Group, uint8(E_Filler_Traits.Female_Robot_Headwear_Cover));
        }
    }

    function _addTraitToRender(TraitsContext memory _traits, E_TraitsGroup _traitGroup, uint8 _traitIndex) internal pure {
        uint256 len = _traits.traitsToRenderLength;
        TraitToRender memory t = _traits.traitsToRender[len];
        t.traitGroup = _traitGroup;
        t.traitIndex = _traitIndex;
        t.hasFiller = false;
        unchecked {
            _traits.traitsToRenderLength++;
        }
    }

    function _addFillerTrait(TraitsContext memory _traits, E_TraitsGroup _traitGroup, uint8 _traitIndex) internal pure {
        uint256 lastIdx;
        unchecked {
            lastIdx = _traits.traitsToRenderLength - 1;
        }
        TraitToRender memory t = _traits.traitsToRender[lastIdx];
        t.hasFiller = true;
        t.filler.traitGroup = _traitGroup;
        t.filler.traitIndex = _traitIndex;
    }
}
