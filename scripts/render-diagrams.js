#!/usr/bin/env node
/*
 * render-diagrams.js – extracts Mermaid diagrams from docs/architecture/*.md
 * and renders them to SVG using mermaid-cli (mmdc).
 *
 * Usage: yarn render:diagrams
 */
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const ARCH_DIR = path.resolve(__dirname, '../docs/architecture');
const OUTPUT_DIR = ARCH_DIR; // store SVG next to markdown

/**
 * Extract first mermaid code block from markdown file.
 */
function extractMermaid(content) {
  const match = content.match(/```mermaid([\s\S]*?)```/i);
  return match ? match[1].trim() : null;
}

function render(filePath) {
  const mdContent = fs.readFileSync(filePath, 'utf-8');
  const mermaid = extractMermaid(mdContent);
  if (!mermaid) {
    console.warn(`No mermaid block found in ${path.basename(filePath)}`);
    return;
  }
  const tmpMmd = path.join(process.cwd(), 'tmp_diagram.mmd');
  fs.writeFileSync(tmpMmd, mermaid, 'utf-8');
  const svgName = path.basename(filePath, '.md') + '.svg';
  const svgPath = path.join(OUTPUT_DIR, svgName);
  try {
    execSync(`npx -y @mermaid-js/mermaid-cli -i ${tmpMmd} -o ${svgPath} --quiet`, {
      stdio: 'inherit'
    });
    console.log(`Rendered ${svgPath}`);
  } catch (err) {
    console.error(`Error rendering ${filePath}:`, err.message);
  } finally {
    fs.unlinkSync(tmpMmd);
  }
}

function main() {
  if (!fs.existsSync(ARCH_DIR)) {
    console.error('docs/architecture directory not found');
    process.exit(1);
  }
  const files = fs.readdirSync(ARCH_DIR).filter((f) => f.endsWith('.md'));
  files.forEach((file) => render(path.join(ARCH_DIR, file)));
}

main(); 