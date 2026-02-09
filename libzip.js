/**
 * Compresses Background asset hex for AddAssetsBatch.s.sol
 *
 * Workflow:
 * 1. Run: python3 Python/_BackgroundAssetUltimate.py
 * 2. Run: node libzip.js
 * 3. Copy the compressed hex output into AddAssetsBatch.s.sol (key 0, Background)
 *
 * If output/background_ultimate_asset.txt exists, its hex is used automatically.
 * Otherwise, edit ASSET_HEX_FALLBACK below.
 */

const fs = require('fs');
const path = require('path');
const { LibZip } = require('solady');

const PYTHON_OUTPUT = path.join(__dirname, 'output', 'background_ultimate_asset.txt');

// Fallback if Python output not found
const ASSET_HEX_FALLBACK = "0x";

function loadAssetHex() {
    if (fs.existsSync(PYTHON_OUTPUT)) {
        const content = fs.readFileSync(PYTHON_OUTPUT, 'utf8');
        const match = content.match(/Background:\s*(0x[a-fA-F0-9]+)/);
        if (match) {
            console.log('Using hex from output/background_ultimate_asset.txt');
            return match[1];
        }
    }
    return ASSET_HEX_FALLBACK;
}

function main() {
    const ASSET_HEX = loadAssetHex();

    if (!ASSET_HEX || ASSET_HEX === "0x") {
        console.error('❌ Error: No hex found.');
        console.error('   Run: python3 Python/_BackgroundAssetUltimate.py');
        console.error('   Or set ASSET_HEX_FALLBACK in this script.');
        return;
    }

    try {
        const compressed = LibZip.flzCompress(ASSET_HEX);
        const originalBytes = ASSET_HEX.replace(/^0x/i, '').length / 2;
        const compressedBytes = compressed.replace(/^0x/i, '').length / 2;
        const saved = originalBytes - compressedBytes;
        const percentage = ((saved / originalBytes) * 100).toFixed(2);

        console.log("\n");
        console.log('━'.repeat(40));
        console.log(`Original:   ${originalBytes.toLocaleString()} bytes`);
        console.log(`Compressed: ${compressedBytes.toLocaleString()} bytes`);
        console.log(`Saved:      ${saved.toLocaleString()} bytes`);
        console.log(`Efficiency: ${percentage}%`);
        console.log('━'.repeat(40));

        console.log('\n\n✅ Compressed Hex Output (paste into AddAssetsBatch key 0):\n\n');
        console.log(compressed);
        console.log("\n");

    } catch (error) {
        console.error('❌ Compression failed:', error.message);
    }
}

main();
