#!/usr/bin/env node
/*
 * migrate_replace_lora_to_nunito.js
 * -------------------------------------------------------------
 * Automated migration script that replaces all occurrences of
 * `GoogleFonts.lora(` with `GoogleFonts.nunito(` across the
 * mobile Flutter codebase.  Intended for one-time execution as
 * part of plan_mobile_font_unification Task t002 (IMPLEMENTATION).
 *
 * Usage:
 *   node scripts/migrate_replace_lora_to_nunito.js [--dry-run]
 *
 * When --dry-run is supplied, the script logs the files that would
 * be updated without persisting any changes.
 */

const fs = require('fs');
const path = require('path');

const DRY_RUN = process.argv.includes('--dry-run');
const ROOT_DIR = path.resolve(__dirname, '..');
const TARGET_DIRS = [
  path.join(ROOT_DIR, 'mobile', 'lib'),
  path.join(ROOT_DIR, 'mobile', 'test'), // tests may also reference fonts
];

/**
 * Recursively walk a directory and return absolute file paths.
 */
function walk(dir) {
  const results = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      results.push(...walk(fullPath));
    } else if (entry.isFile()) {
      results.push(fullPath);
    }
  }
  return results;
}

function processFile(filePath) {
  if (!filePath.endsWith('.dart')) return false;
  const content = fs.readFileSync(filePath, 'utf8');
  const pattern = /GoogleFonts\.lora\s*\(/g;
  if (!pattern.test(content)) return false;

  const updated = content.replace(pattern, 'GoogleFonts.nunito(');

  if (DRY_RUN) {
    console.log(`[DRY] Would update ${path.relative(ROOT_DIR, filePath)}`);
    return true;
  }

  fs.writeFileSync(filePath, updated, 'utf8');
  console.log(`[FIX] Updated ${path.relative(ROOT_DIR, filePath)}`);
  return true;
}

function main() {
  console.log(`Starting font migration${DRY_RUN ? ' (dry run)' : ''}...`);
  let changed = 0;
  for (const dir of TARGET_DIRS) {
    if (!fs.existsSync(dir)) continue;
    for (const file of walk(dir)) {
      if (processFile(file)) changed += 1;
    }
  }
  console.log(`Migration complete. ${changed} file(s) updated.`);
  if (changed === 0) {
    console.log('No occurrences of GoogleFonts.lora(' +
                ' were found. Migration may have already been applied.');
  }
}

if (require.main === module) {
  main();
} 