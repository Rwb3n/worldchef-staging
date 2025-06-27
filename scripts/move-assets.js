const fs = require('fs');
const path = require('path');
const glob = require('glob');

const docsDir = path.resolve(__dirname, '../docs');
const assetsDir = path.resolve(docsDir, 'assets');

const assetExtensions = ['png', 'jpg', 'jpeg', 'gif', 'svg', 'pdf'];

if (!fs.existsSync(assetsDir)) {
  fs.mkdirSync(assetsDir);
}

async function moveAssetsAndRewriteLinks() {
  console.log('Starting asset centralization...');
  const markdownFiles = glob.sync(`${docsDir}/**/*.md`, { ignore: `${assetsDir}/**/*.md` });
  let movedCount = 0;
  let rewrittenCount = 0;

  for (const mdFile of markdownFiles) {
    let content = fs.readFileSync(mdFile, 'utf8');
    let originalContent = content;

    // Regex to find Markdown image/link syntax: ![alt](path) or [text](path)
    const linkRegex = /!\[[^\]]*\]\((?!https?:\/\/)([^)]+)\)|\((?!https?:\/\/)([^)]+)\)/g;

    content = content.replace(linkRegex, (match, imgPath, linkPath) => {
      const currentAssetPath = imgPath || linkPath; // Use imgPath for ![alt](path), linkPath for (path)
      if (!currentAssetPath) return match; // No path found

      const absoluteCurrentAssetPath = path.resolve(path.dirname(mdFile), currentAssetPath);
      const assetFileName = path.basename(absoluteCurrentAssetPath);
      const newAssetPath = path.join(assetsDir, assetFileName);
      const relativeNewAssetPath = path.relative(path.dirname(mdFile), newAssetPath).replace(/\\/g, '/');

      const ext = path.extname(assetFileName).toLowerCase().substring(1);

      if (assetExtensions.includes(ext) && fs.existsSync(absoluteCurrentAssetPath) && !absoluteCurrentAssetPath.startsWith(assetsDir)) {
        // Move the asset
        fs.renameSync(absoluteCurrentAssetPath, newAssetPath);
        movedCount++;
        rewrittenCount++;
        console.log(`Moved: ${currentAssetPath} to ${newAssetPath}`);
        // Rewrite the link
        return match.includes('!') ? `![](${relativeNewAssetPath})` : `(${relativeNewAssetPath})`;
      }
      return match; // No change
    });

    if (content !== originalContent) {
      fs.writeFileSync(mdFile, content, 'utf8');
      console.log(`Rewrote links in: ${mdFile}`);
    }
  }
  console.log(`\nAsset centralization complete. Moved ${movedCount} assets, rewrote ${rewrittenCount} links.`);
}

moveAssetsAndRewriteLinks().catch(console.error);
