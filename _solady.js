const { LibZip } = require('solady/js/solady.js');

/**
 * Processes a Base64 string: converts to hex, and optionally compresses it.
 * @param {string} b64String - The base64 input
 * @param {boolean} enableCompression - If false, returns raw hex. If true, compresses.
 * @param {string} mode - 'flz' (FastLZ) or 'cd' (Calldata). Only used if compression is ON.
 */
function processBase64(b64String, enableCompression = true, mode = 'flz') {
   try {
      // 1. Convert Base64 to Hex (This always happens first)
      const buffer = Buffer.from(b64String, 'base64');
      const rawHex = '0x' + buffer.toString('hex');
      const originalSizeBytes = buffer.length;

      let finalHex;
      let statusLabel;

      // 2. Handle Compression Switch
      if (enableCompression) {
         finalHex = mode === 'cd'
            ? LibZip.cdCompress(rawHex)
            : LibZip.flzCompress(rawHex);

         statusLabel = mode === 'cd' ? 'Compressed (Calldata)' : 'Compressed (FastLZ)';
      } else {
         // Just return the raw hex representation of the Base64
         finalHex = rawHex;
         statusLabel = 'Uncompressed (Raw Hex)';
      }

      // 3. Calculate Stats
      const finalSizeBytes = (finalHex.length - 2) / 2;

      // Calculate savings only if we actually compressed
      const ratio = enableCompression
         ? ((1 - finalSizeBytes / originalSizeBytes) * 100).toFixed(2)
         : "0.00";

      return {
         originalSize: `${originalSizeBytes} bytes`,
         outputSize: `${finalSizeBytes} bytes`,
         savings: `${ratio}%`,
         status: statusLabel,
         outputData: finalHex
      };
   } catch (error) {
      return { error: "Processing error: " + error.message };
   }
}

// --- EXAMPLE USAGE ---

const myBase64 = "iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAQAAAD9CzEMAAABEUlEQVR4nO2WvwrCMBDGf5Uugq516qLg1EHoU/RlXX0Ep4KDs4uTPoBrJJLSE2IbKSVX6AeFcNc0992fL4UZM2ZMH0nvG2bQbhaMjKTTa+AM7H64s/4vxGRg4AgshakEnjL6ABajM0i7nAdg5aK2kdZA7nx2HQIdNcg97mnVAE/e74QhLgML20HFZwVXWjQ2pQwM3Fz+XwMPiDQHpmWA0B8fCrVzsKWd5NLjV6NFqddqc2q+1fTuXFVAXfSo6c3NQaOcMvd5QAfF16IHsHbrzOW9Ejec1abCaJ0Di43rIpv3k4i6YTONLloJk4z6ay7U1uDyQ4sy8USfgySkBrXQoMDdyv4q8j8i1tdF+4EHjM7gDVgIMmEoiyLIAAAAAElFTkSuQmCC";

// TOGGLE THIS: true for compression, false for raw hex
const USE_COMPRESSION = false;

console.log("--- Processing Report ---");
const results = processBase64(myBase64, USE_COMPRESSION, 'flz');

if (results.error) {
   console.error(results.error);
} else {
   console.table({
      "Original": results.originalSize,
      "Output": results.outputSize,
      "Savings": results.savings
   });
   console.log("\nOutput Hex:\n");
   console.log(results.outputData);
}