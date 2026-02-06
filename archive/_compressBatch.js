const fs = require('fs');
const path = require('path');
const { LibZip } = require('solady');

// ============================================================================
// CONFIGURATION - Manually change these paths
// ============================================================================
const INPUT_FILE_PATH = '/Users/mani/Downloads/TestSpace/output/original.txt';
const OUTPUT_FILE_PATH = '/Users/mani/Downloads/TestSpace/output/compressed.txt';

// ============================================================================
// LOGIC
// ============================================================================

function processCompression() {
    try {
        // 1. Read the input file
        if (!fs.existsSync(INPUT_FILE_PATH)) {
            console.error(`Error: Input file not found at ${INPUT_FILE_PATH}`);
            return;
        }
        const rawData = fs.readFileSync(INPUT_FILE_PATH, 'utf8');

        // 2. Parse segments using regex 
        // Matches "Trait Name: 0x..." and captures Name and Hex separately
        const traitRegex = /^([^:\n]+):\s*(0x[0-9a-fA-F]+)/gm;
        let match;
        const compressedResults = [];

        console.log('--- Starting Batch Compression ---');

        while ((match = traitRegex.exec(rawData)) !== null) {
            const traitName = match[1].trim();
            const originalHex = match[2];

            // 3. Compress using Solady LibZip
            const compressedHex = LibZip.flzCompress(originalHex);

            // Calculate stats for logging
            const originalSize = (originalHex.length - 2) / 2;
            const compressedSize = (compressedHex.length - 2) / 2;
            const savings = ((1 - compressedSize / originalSize) * 100).toFixed(2);

            console.log(`Compressed [${traitName}]: ${originalSize} bytes -> ${compressedSize} bytes (${savings}% reduction)`);

            // 4. Format for output
            compressedResults.push(`${traitName}: ${compressedHex}`);
        }

        // 5. Write to output file
        const outputContent = compressedResults.join('\n\n');
        fs.writeFileSync(OUTPUT_FILE_PATH, outputContent, 'utf8');

        console.log('--- Success ---');
        console.log(`Compressed data written to: ${OUTPUT_FILE_PATH}`);

    } catch (error) {
        console.error('An error occurred during processing:', error);
    }
}

processCompression();

