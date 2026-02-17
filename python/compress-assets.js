#!/usr/bin/env node
/**
 * Asset Compression Script using Solady's LibZip (FastLZ)
 * 
 * Reads hex asset files from the output directory and generates
 * compressed versions using Solady's FastLZ compression.
 * 
 * Usage: node compress_assets.js
 */

const fs = require('fs');
const path = require('path');

// Import Solady's LibZip from archive
const soladyPath = path.join(__dirname, '..', 'archive', 'solady.js');
const { LibZip } = require(soladyPath);

// Configuration
const OUTPUT_DIR = path.join(__dirname, '..', 'output');
const COMPRESSED_SUFFIX = '_compressed';

/**
 * Parse an asset file line into group name and hex data
 * Format: "GroupName: 0xHEXDATA"
 */
function parseLine(line) {
    const match = line.match(/^(.+?):\s*(0x[0-9a-fA-F]+)$/);
    if (!match) return null;
    return {
        groupName: match[1].trim(),
        hexData: match[2]
    };
}

/**
 * Calculate compression ratio
 */
function compressionRatio(original, compressed) {
    const origBytes = (original.length - 2) / 2;  // Remove 0x prefix
    const compBytes = (compressed.length - 2) / 2;
    return ((1 - compBytes / origBytes) * 100).toFixed(2);
}

/**
 * Process a single asset file
 */
function processFile(filename) {
    const inputPath = path.join(OUTPUT_DIR, filename);
    const content = fs.readFileSync(inputPath, 'utf8');
    const lines = content.trim().split('\n');
    
    const results = [];
    let totalOriginal = 0;
    let totalCompressed = 0;
    
    console.log(`\nProcessing: ${filename}`);
    console.log('-'.repeat(60));
    
    for (const line of lines) {
        if (!line.trim()) continue;
        
        const parsed = parseLine(line);
        if (!parsed) {
            console.log(`  Skipping invalid line: ${line.substring(0, 50)}...`);
            continue;
        }
        
        const { groupName, hexData } = parsed;
        
        try {
            // Compress using Solady's FastLZ
            const compressed = LibZip.flzCompress(hexData);
            
            const origBytes = (hexData.length - 2) / 2;
            const compBytes = (compressed.length - 2) / 2;
            const ratio = compressionRatio(hexData, compressed);
            
            totalOriginal += origBytes;
            totalCompressed += compBytes;
            
            console.log(`  ${groupName}:`);
            console.log(`    Original:   ${origBytes.toLocaleString()} bytes`);
            console.log(`    Compressed: ${compBytes.toLocaleString()} bytes (${ratio}% reduction)`);
            
            results.push({
                groupName,
                original: hexData,
                compressed
            });
        } catch (err) {
            console.error(`  Error compressing ${groupName}: ${err.message}`);
        }
    }
    
    return { results, totalOriginal, totalCompressed };
}

/**
 * Write compressed output file
 */
function writeCompressedFile(filename, results) {
    const baseName = path.basename(filename, '.txt');
    const outputFilename = `${baseName}${COMPRESSED_SUFFIX}.txt`;
    const outputPath = path.join(OUTPUT_DIR, outputFilename);
    
    const content = results
        .map(r => `${r.groupName}: ${r.compressed}`)
        .join('\n') + '\n';
    
    fs.writeFileSync(outputPath, content);
    console.log(`\n  Written to: ${outputFilename}`);
}

/**
 * Main entry point
 */
function main() {
    console.log('='.repeat(70));
    console.log('Solady LibZip Asset Compressor');
    console.log('FastLZ compression for gas-optimized on-chain storage');
    console.log('='.repeat(70));
    
    // Get all .txt files in output directory (excluding already compressed)
    const files = fs.readdirSync(OUTPUT_DIR)
        .filter(f => f.endsWith('.txt') && !f.includes(COMPRESSED_SUFFIX));
    
    if (files.length === 0) {
        console.log('\nNo asset files found in output directory.');
        return;
    }
    
    console.log(`\nFound ${files.length} asset file(s) to compress:`);
    files.forEach(f => console.log(`  - ${f}`));
    
    let grandTotalOriginal = 0;
    let grandTotalCompressed = 0;
    
    for (const filename of files) {
        const { results, totalOriginal, totalCompressed } = processFile(filename);
        
        if (results.length > 0) {
            writeCompressedFile(filename, results);
            grandTotalOriginal += totalOriginal;
            grandTotalCompressed += totalCompressed;
        }
    }
    
    // Summary
    console.log('\n' + '='.repeat(70));
    console.log('COMPRESSION SUMMARY');
    console.log('='.repeat(70));
    console.log(`Total Original:   ${grandTotalOriginal.toLocaleString()} bytes`);
    console.log(`Total Compressed: ${grandTotalCompressed.toLocaleString()} bytes`);
    console.log(`Overall Savings:  ${(grandTotalOriginal - grandTotalCompressed).toLocaleString()} bytes`);
    console.log(`Compression:      ${((1 - grandTotalCompressed / grandTotalOriginal) * 100).toFixed(2)}%`);
    console.log('='.repeat(70));
    console.log('\n✓ Done! Compressed files saved with "_compressed" suffix.');
}

main();
