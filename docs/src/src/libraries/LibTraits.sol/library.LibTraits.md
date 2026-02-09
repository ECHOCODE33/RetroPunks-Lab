# LibTraits
[Git Source](https://github.com/ECHOCODE33/RetroPunks-Lab/blob/53dba76e70625b47f9afcf8f21d96497afb9c7a7/src/libraries/LibTraits.sol)

**Author:**
ECHO


## State Variables
### FACIAL_HAIR_IS_BLACK

```solidity
uint256 private constant FACIAL_HAIR_IS_BLACK =
    ((uint256(1) << uint256(E_Male_Facial_Hair.Anchor_Beard_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Beard_Black))
        | (uint256(1) << uint256(E_Male_Facial_Hair.Big_Beard_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Chin_Goatee_Black))
        | (uint256(1) << uint256(E_Male_Facial_Hair.Chinstrap_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Circle_Beard_Black))
        | (uint256(1) << uint256(E_Male_Facial_Hair.Dutch_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Fu_Manchu_Black))
        | (uint256(1) << uint256(E_Male_Facial_Hair.Full_Goatee_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Goatee_Black))
        | (uint256(1) << uint256(E_Male_Facial_Hair.Handlebar_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Horseshoe_Black))
        | (uint256(1) << uint256(E_Male_Facial_Hair.Long_Beard_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Luxurious_Beard_Black))
        | (uint256(1) << uint256(E_Male_Facial_Hair.Luxurious_Full_Goatee_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Mustache_Black))
        | (uint256(1) << uint256(E_Male_Facial_Hair.Muttonchops_Black)) | (uint256(1) << uint256(E_Male_Facial_Hair.Pyramid_Mustache_Black))
        | (uint256(1) << uint256(E_Male_Facial_Hair.Walrus_Black)))
```


### MALE_EYEWEAR_IS_EYE_PATCH

```solidity
uint256 private constant MALE_EYEWEAR_IS_EYE_PATCH =
    ((uint256(1) << uint256(E_Male_Eye_Wear.Bionic_Eye_Patch_Blue)) | (uint256(1) << uint256(E_Male_Eye_Wear.Bionic_Eye_Patch_Green))
        | (uint256(1) << uint256(E_Male_Eye_Wear.Bionic_Eye_Patch_Orange)) | (uint256(1) << uint256(E_Male_Eye_Wear.Bionic_Eye_Patch_Pink))
        | (uint256(1) << uint256(E_Male_Eye_Wear.Bionic_Eye_Patch_Purple)) | (uint256(1) << uint256(E_Male_Eye_Wear.Bionic_Eye_Patch_Red))
        | (uint256(1) << uint256(E_Male_Eye_Wear.Bionic_Eye_Patch_Turquoise)) | (uint256(1) << uint256(E_Male_Eye_Wear.Bionic_Eye_Patch_Yellow))
        | (uint256(1) << uint256(E_Male_Eye_Wear.Eye_Patch)) | (uint256(1) << uint256(E_Male_Eye_Wear.Pirate_Eye_Patch))
        | (uint256(1) << uint256(E_Male_Eye_Wear.Eye_Mask)))
```


### MALE_HEADWEAR_IS_CLOAK_OR_HOODIE

```solidity
uint256 private constant MALE_HEADWEAR_IS_CLOAK_OR_HOODIE =
    ((uint256(1) << uint256(E_Male_Headwear.Cloak_Black)) | (uint256(1) << uint256(E_Male_Headwear.Cloak_Blue)) | (uint256(1) << uint256(E_Male_Headwear.Cloak_Green))
        | (uint256(1) << uint256(E_Male_Headwear.Cloak_Purple)) | (uint256(1) << uint256(E_Male_Headwear.Cloak_Red)) | (uint256(1) << uint256(E_Male_Headwear.Cloak_White))
        | (uint256(1) << uint256(E_Male_Headwear.Cloak)) | (uint256(1) << uint256(E_Male_Headwear.Hoodie_Blue)) | (uint256(1) << uint256(E_Male_Headwear.Hoodie_Green))
        | (uint256(1) << uint256(E_Male_Headwear.Hoodie_Purple)) | (uint256(1) << uint256(E_Male_Headwear.Hoodie_Red)) | (uint256(1) << uint256(E_Male_Headwear.Hoodie))
        | (uint256(1) << uint256(E_Male_Headwear.Sherpa_Hat_Blue)) | (uint256(1) << uint256(E_Male_Headwear.Sherpa_Hat_Brown))
        | (uint256(1) << uint256(E_Male_Headwear.Sherpa_Hat_Red)))
```


### FEMALE_EYEWEAR_IS_EYE_PATCH

```solidity
uint256 private constant FEMALE_EYEWEAR_IS_EYE_PATCH =
    ((uint256(1) << uint256(E_Female_Eye_Wear.Bionic_Eye_Patch_Blue)) | (uint256(1) << uint256(E_Female_Eye_Wear.Bionic_Eye_Patch_Green))
        | (uint256(1) << uint256(E_Female_Eye_Wear.Bionic_Eye_Patch_Orange)) | (uint256(1) << uint256(E_Female_Eye_Wear.Bionic_Eye_Patch_Pink))
        | (uint256(1) << uint256(E_Female_Eye_Wear.Bionic_Eye_Patch_Purple)) | (uint256(1) << uint256(E_Female_Eye_Wear.Bionic_Eye_Patch_Red))
        | (uint256(1) << uint256(E_Female_Eye_Wear.Bionic_Eye_Patch_Turquoise)) | (uint256(1) << uint256(E_Female_Eye_Wear.Bionic_Eye_Patch_Yellow))
        | (uint256(1) << uint256(E_Female_Eye_Wear.Eye_Patch)) | (uint256(1) << uint256(E_Female_Eye_Wear.Pirate_Eye_Patch))
        | (uint256(1) << uint256(E_Female_Eye_Wear.Eye_Mask)))
```


### FEMALE_HEADWEAR_IS_CLOAK_OR_HOODIE

```solidity
uint256 private constant FEMALE_HEADWEAR_IS_CLOAK_OR_HOODIE =
    ((uint256(1) << uint256(E_Female_Headwear.Cloak_Black)) | (uint256(1) << uint256(E_Female_Headwear.Cloak_Blue))
        | (uint256(1) << uint256(E_Female_Headwear.Cloak_Green)) | (uint256(1) << uint256(E_Female_Headwear.Cloak_Purple))
        | (uint256(1) << uint256(E_Female_Headwear.Cloak_Red)) | (uint256(1) << uint256(E_Female_Headwear.Cloak_White)) | (uint256(1) << uint256(E_Female_Headwear.Cloak))
        | (uint256(1) << uint256(E_Female_Headwear.Hoodie_Blue)) | (uint256(1) << uint256(E_Female_Headwear.Hoodie_Green))
        | (uint256(1) << uint256(E_Female_Headwear.Hoodie_Purple)) | (uint256(1) << uint256(E_Female_Headwear.Hoodie_Red))
        | (uint256(1) << uint256(E_Female_Headwear.Hoodie)) | (uint256(1) << uint256(E_Female_Headwear.Sherpa_Hat_Blue))
        | (uint256(1) << uint256(E_Female_Headwear.Sherpa_Hat_Brown)) | (uint256(1) << uint256(E_Female_Headwear.Sherpa_Hat_Red)))
```


## Functions
### maleHasBlackFacialHair


```solidity
function maleHasBlackFacialHair(TraitsContext memory traits) internal pure returns (bool);
```

### maleEyeWearIsEyePatch


```solidity
function maleEyeWearIsEyePatch(TraitsContext memory traits) internal pure returns (bool);
```

### maleHeadwearIsCloakOrHoodie


```solidity
function maleHeadwearIsCloakOrHoodie(TraitsContext memory traits) internal pure returns (bool);
```

### femaleEyeWearIsEyePatch


```solidity
function femaleEyeWearIsEyePatch(TraitsContext memory traits) internal pure returns (bool);
```

### femaleHeadwearIsCloakOrHoodie


```solidity
function femaleHeadwearIsCloakOrHoodie(TraitsContext memory traits) internal pure returns (bool);
```

### isMale


```solidity
function isMale(TraitsContext memory traits) internal pure returns (bool);
```

### isFemale


```solidity
function isFemale(TraitsContext memory traits) internal pure returns (bool);
```

### maleIsHuman


```solidity
function maleIsHuman(TraitsContext memory traits) internal pure returns (bool);
```

### maleIsAlien


```solidity
function maleIsAlien(TraitsContext memory traits) internal pure returns (bool);
```

### maleIsApe


```solidity
function maleIsApe(TraitsContext memory traits) internal pure returns (bool);
```

### maleIsDemon


```solidity
function maleIsDemon(TraitsContext memory traits) internal pure returns (bool);
```

### maleIsGhost


```solidity
function maleIsGhost(TraitsContext memory traits) internal pure returns (bool);
```

### maleIsGlitch


```solidity
function maleIsGlitch(TraitsContext memory traits) internal pure returns (bool);
```

### maleIsGoblin


```solidity
function maleIsGoblin(TraitsContext memory traits) internal pure returns (bool);
```

### maleIsInvisible


```solidity
function maleIsInvisible(TraitsContext memory traits) internal pure returns (bool);
```

### maleIsMummy


```solidity
function maleIsMummy(TraitsContext memory traits) internal pure returns (bool);
```

### maleIsPumpkin


```solidity
function maleIsPumpkin(TraitsContext memory traits) internal pure returns (bool);
```

### maleIsRobot


```solidity
function maleIsRobot(TraitsContext memory traits) internal pure returns (bool);
```

### maleIsSkeleton


```solidity
function maleIsSkeleton(TraitsContext memory traits) internal pure returns (bool);
```

### maleIsSnowman


```solidity
function maleIsSnowman(TraitsContext memory traits) internal pure returns (bool);
```

### maleIsVampire


```solidity
function maleIsVampire(TraitsContext memory traits) internal pure returns (bool);
```

### maleIsYeti


```solidity
function maleIsYeti(TraitsContext memory traits) internal pure returns (bool);
```

### maleIsZombieApe


```solidity
function maleIsZombieApe(TraitsContext memory traits) internal pure returns (bool);
```

### maleIsZombie


```solidity
function maleIsZombie(TraitsContext memory traits) internal pure returns (bool);
```

### femaleIsHuman


```solidity
function femaleIsHuman(TraitsContext memory traits) internal pure returns (bool);
```

### femaleIsAlien


```solidity
function femaleIsAlien(TraitsContext memory traits) internal pure returns (bool);
```

### femaleIsApe


```solidity
function femaleIsApe(TraitsContext memory traits) internal pure returns (bool);
```

### femaleIsDemon


```solidity
function femaleIsDemon(TraitsContext memory traits) internal pure returns (bool);
```

### femaleIsGhost


```solidity
function femaleIsGhost(TraitsContext memory traits) internal pure returns (bool);
```

### femaleIsGlitch


```solidity
function femaleIsGlitch(TraitsContext memory traits) internal pure returns (bool);
```

### femaleIsGoblin


```solidity
function femaleIsGoblin(TraitsContext memory traits) internal pure returns (bool);
```

### femaleIsInvisible


```solidity
function femaleIsInvisible(TraitsContext memory traits) internal pure returns (bool);
```

### femaleIsMummy


```solidity
function femaleIsMummy(TraitsContext memory traits) internal pure returns (bool);
```

### femaleIsRobot


```solidity
function femaleIsRobot(TraitsContext memory traits) internal pure returns (bool);
```

### femaleIsSkeleton


```solidity
function femaleIsSkeleton(TraitsContext memory traits) internal pure returns (bool);
```

### femaleIsVampire


```solidity
function femaleIsVampire(TraitsContext memory traits) internal pure returns (bool);
```

### femaleIsZombieApe


```solidity
function femaleIsZombieApe(TraitsContext memory traits) internal pure returns (bool);
```

### femaleIsZombie


```solidity
function femaleIsZombie(TraitsContext memory traits) internal pure returns (bool);
```

### maleHasHeadwear


```solidity
function maleHasHeadwear(TraitsContext memory traits) internal pure returns (bool);
```

### femaleHasHeadwear


```solidity
function femaleHasHeadwear(TraitsContext memory traits) internal pure returns (bool);
```

### maleHasMask


```solidity
function maleHasMask(TraitsContext memory traits) internal pure returns (bool);
```

### femaleHasMask


```solidity
function femaleHasMask(TraitsContext memory traits) internal pure returns (bool);
```

### maleHasFacialHair


```solidity
function maleHasFacialHair(TraitsContext memory traits) internal pure returns (bool);
```

