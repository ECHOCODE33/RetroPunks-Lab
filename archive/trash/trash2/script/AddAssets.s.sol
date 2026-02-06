// script/AddAssets.s.sol
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import { Assets } from "../src/Assets.sol";
import { LibZip } from "../src/libraries/LibZip.sol";

contract AddAssets is Script {

    Assets assets;

    bytes special =          LibZip.flzCompress(hex"");
    bytes background =       LibZip.flzCompress(hex"");

    bytes maleSkin =         LibZip.flzCompress(hex"");
    bytes maleEyes =         LibZip.flzCompress(hex"");
    bytes maleFace =         LibZip.flzCompress(hex"");
    bytes maleChain =        LibZip.flzCompress(hex"");
    bytes maleEarring =      LibZip.flzCompress(hex"");
    bytes maleFacialHair =   LibZip.flzCompress(hex"");
    bytes maleMask =         LibZip.flzCompress(hex"");
    bytes maleScarf =        LibZip.flzCompress(hex"");
    bytes maleHair =         LibZip.flzCompress(hex"");
    bytes maleHatHair =      LibZip.flzCompress(hex"");
    bytes maleHeadwear =     LibZip.flzCompress(hex"");
    bytes maleEyeWear =      LibZip.flzCompress(hex"");

    bytes femaleSkin =       LibZip.flzCompress(hex"");
    bytes femaleEyes =       LibZip.flzCompress(hex"");
    bytes femaleFace =       LibZip.flzCompress(hex"");
    bytes femaleChain =      LibZip.flzCompress(hex"");
    bytes femaleEarring =    LibZip.flzCompress(hex"");
    bytes femaleMask =       LibZip.flzCompress(hex"");
    bytes femaleScarf =      LibZip.flzCompress(hex"");
    bytes femaleHair =       LibZip.flzCompress(hex"");
    bytes femaleHatHair =    LibZip.flzCompress(hex"");
    bytes femaleHeadwear =   LibZip.flzCompress(hex"");
    bytes femaleEyeWear =    LibZip.flzCompress(hex"");

    bytes mouth =            LibZip.flzCompress(hex"");
    bytes fillerTraits =     LibZip.flzCompress(hex"");
    

    function run() external {
        vm.startBroadcast();

        address assetsAddr = vm.envAddress("ASSETS_ADDRESS");
        assets = Assets(assetsAddr);


        addMaleAssets();
        addFemaleAssets();
        addOtherAssets();

        console.log("Compressed and added assets successfully!");

        vm.stopBroadcast();
    }

    function addMaleAssets() public {
        assets.addAsset(2, maleSkin);
        assets.addAsset(3, maleEyes);
        assets.addAsset(4, maleFace);
        assets.addAsset(5, maleChain);
        assets.addAsset(6, maleEarring);
        assets.addAsset(7, maleFacialHair);
        assets.addAsset(8, maleMask);
        assets.addAsset(9, maleScarf);
        assets.addAsset(10, maleHair);
        assets.addAsset(11, maleHatHair);
        assets.addAsset(12, maleHeadwear);
        assets.addAsset(13, maleEyeWear);
    }

    function addFemaleAssets() public {
        assets.addAsset(14, femaleSkin);
        assets.addAsset(15, femaleEyes);
        assets.addAsset(16, femaleFace);
        assets.addAsset(17, femaleChain);
        assets.addAsset(18, femaleEarring);
        assets.addAsset(19, femaleMask);
        assets.addAsset(20, femaleScarf);
        assets.addAsset(21, femaleHair);
        assets.addAsset(22, femaleHatHair);
        assets.addAsset(23, femaleHeadwear);
        assets.addAsset(24, femaleEyeWear);
    }

    function addOtherAssets() public {
        assets.addAsset(0, special);
        assets.addAsset(1, background);
        assets.addAsset(25, mouth);
        assets.addAsset(26, fillerTraits);
    }
}
