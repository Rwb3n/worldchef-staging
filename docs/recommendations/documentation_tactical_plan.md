# Documentation Tactical Plan (Phase 1)

This document outlines a purely tactical, step-by-step plan for implementing Phase 1 of the documentation action plan. This plan assumes operation with AI agents only, without a pre-existing CI/CD pipeline, and focuses on rapid implementation.

## Guiding Principles for Tactical Execution

*   **Automation First:** Prioritize scripts and automated processes to minimize manual intervention.
*   **Local-First Development:** Focus on local tooling and scripts before considering CI/CD integration.
*   **Iterative Refinement:** Build and test each component individually before integrating.
*   **AI-Assisted Development:** Leverage AI agents for scaffolding scripts and verifying outputs.

## Tactical Play-by-Play

### 1. Auto-generate OpenAPI Specification

**Objective:** Ensure `openapi_v1.json` is always up-to-date with the backend API.

*   **What to do:** Create a Node.js script that imports the Fastify app and uses the Swagger/OpenAPI plugin to dump the `openapi_v1.json` file.

    **File:** `scripts/generate-openapi.js`
    ```javascript
    const { build } = require('./backend/src/server'); // Adjust path as needed
    const fs = require('fs');
    const path = require('path');

    async function generateOpenApiSpec() {
      const server = await build();
      await server.ready();

      const openApiSpec = server.swagger();
      const outputPath = path.resolve(__dirname, '../docs/api/openapi_v1.json');

      fs.writeFileSync(outputPath, JSON.stringify(openApiSpec, null, 2));
      console.log(`OpenAPI spec generated at: ${outputPath}`);

      await server.close();
    }

    generateOpenApiSpec().catch(err => {
      console.error('Failed to generate OpenAPI spec:', err);
      process.exit(1);
    });
    ```

*   **How to run:** Add an npm script to `package.json` and execute it after each backend change.

    **`package.json` (add to `scripts` section):**
    ```json
    {
      "scripts": {
        "gen:openapi": "node scripts/generate-openapi.js"
      }
    }
    ```
    **Execution:**
    ```bash
    npm run gen:openapi
    ```

### 2. Auto-build Code Patterns Index

**Objective:** Keep `docs/guides/code-patterns.md` synchronized with `docs/cookbook`.

*   **What to do:** Create a Python script that scans `docs/cookbook` for Markdown files, extracts their first-level headings, and generates a Markdown list in `docs/guides/code-patterns.md`.

    **File:** `scripts/gen-patterns-index.py`
    ```python
    import os
    import re

    def generate_patterns_index(cookbook_path, output_path):
        patterns = []
        for root, _, files in os.walk(cookbook_path):
            for file in files:
                if file.endswith('.md'):
                    filepath = os.path.join(root, file)
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()
                        match = re.search(r'^#\s*(.+)', content, re.MULTILINE)
                        if match:
                            title = match.group(1).strip()
                            relative_path = os.path.relpath(filepath, os.path.dirname(output_path))
                            patterns.append((title, relative_path))
        
        patterns.sort(key=lambda x: x[0]) # Sort alphabetically by title

        with open(output_path, 'w', encoding='utf-8') as f:
            f.write('# WorldChef Code Patterns Index\n\n')
            f.write('> Canonical quick-reference for developers and reviewers. Each line links to a detailed cookbook recipe.\n')
            f.write('> _Auto-generated index. Do not edit manually._\n\n---\n\n')
            
            # Basic categorization (can be enhanced)
            categories = {
                'Flutter': [],
                'Fastify Backend': [],
                'Supabase': [],
                'DevOps / CI-CD / Hosting': [],
                'Testing & Debugging': []
            }

            for title, link in patterns:
                assigned = False
                if 'flutter_' in link or 'widgetbook_' in link:
                    categories['Flutter'].append((title, link))
                    assigned = True
                elif 'fastify_' in link or 'backend_' in link:
                    categories['Fastify Backend'].append((title, link))
                    assigned = True
                elif 'supabase_' in link:
                    categories['Supabase'].append((title, link))
                    assigned = True
                elif 'render_' in link or 'github_actions_' in link or 'stripe_' in link or 'fcm_' in link or 'postgres_' in link:
                    categories['DevOps / CI-CD / Hosting'].append((title, link))
                    assigned = True
                elif 'test_' in link or 'tdd_' in link or 'mock_' in link:
                    categories['Testing & Debugging'].append((title, link))
                    assigned = True
                
                if not assigned:
                    # Fallback for unclassified patterns
                    if 'Uncategorized' not in categories: categories['Uncategorized'] = []
                    categories['Uncategorized'].append((title, link))

            for category, items in categories.items():
                if items:
                    f.write(f'## {category}\n\n')
                    for title, link in items:
                        f.write(f'- [{title}]({link})\n')
                    f.write('\n')

    if __name__ == '__main__':
        script_dir = os.path.dirname(__file__)
        cookbook_dir = os.path.join(script_dir, '..', 'docs', 'cookbook')
        output_file = os.path.join(script_dir, '..', 'docs', 'guides', 'code-patterns.md')
        generate_patterns_index(cookbook_dir, output_file)
    ```

*   **How to run:** Expose it via an npm script.

    **`package.json` (add to `scripts` section):**
    ```json
    {
      "scripts": {
        "gen:patterns": "python scripts/gen-patterns-index.py"
      }
    }
    ```
    **Execution:**
    ```bash
    npm run gen:patterns
    ```

### 3. Centralize All Binary Assets under `docs/assets`

**Objective:** Consolidate all non-text documentation assets and update references.

*   **What to do:** Create a Node.js script to find and move assets, then rewrite Markdown links. This script will need to be run manually when new assets are added.

    **File:** `scripts/move-assets.js`
    ```javascript
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
        const linkRegex = /!\[[^\]]*\]\((?!https?://)([^)]+)\)|\((?!https?://)([^)]+)\)/g;

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
    ```

*   **How to run:** Execute manually whenever new diagrams or PDFs are added to the `docs` folder outside of `docs/assets`.
    ```bash
    node scripts/move-assets.js
    ```

### 4. Batch-convert Legacy TXT Files to Markdown

**Objective:** Convert all `.txt` files in `docs/source` to Markdown format.

*   **What to do:** Use a shell script with `pandoc` to convert `.txt` files to `.md`.

    **File:** `scripts/convert-txt.sh`
    ```bash
    #!/bin/bash

    # Ensure pandoc is installed: https://pandoc.org/installing.html
    if ! command -v pandoc &> /dev/null
    then
        echo "pandoc could not be found. Please install it to run this script."
        exit 1
    fi

    SOURCE_DIR="docs/source"
    OUTPUT_DIR="docs/source-md"

    mkdir -p "$OUTPUT_DIR"

    echo "Converting .txt files from $SOURCE_DIR to Markdown in $OUTPUT_DIR..."

    for f in "$SOURCE_DIR"/*.txt; do
        if [ -f "$f" ]; then
            filename=$(basename -- "$f")
            filename_no_ext="${filename%.*}"
            output_file="$OUTPUT_DIR/${filename_no_ext}.md"
            
            echo "Converting $f to $output_file"
            pandoc "$f" -o "$output_file"
        fi
    done

    echo "Conversion complete. Review files in $OUTPUT_DIR."
    echo "You may now move them to their final destinations and delete the old .txt files."
    ```

*   **How to run:**
    1.  Install Pandoc (if not already installed).
    2.  Make the script executable: `chmod +x scripts/convert-txt.sh`
    3.  Run the script: `bash scripts/convert-txt.sh`
    4.  Manually review the converted files in `docs/source-md`, move them to their final desired locations (e.g., `docs/adr`, `docs/guides`), and then delete the original `.txt` files.

### 5. Tie Them Together Locally with Yarn "Meta-Script"

**Objective:** Create a single command to regenerate all documentation components.

*   **What to do:** Add new scripts to `package.json` that run the previously defined generation scripts in sequence.

    **`package.json` (add to `scripts` section):**
    ```json
    {
      "scripts": {
        "gen:openapi": "node scripts/generate-openapi.js",
        "gen:patterns": "python scripts/gen-patterns-index.py",
        "move:assets": "node scripts/move-assets.js",
        "convert:txt": "bash scripts/convert-txt.sh",
        "lint:links": "npx markdown-link-check \"docs/**/*.md\"",
        "docs:build": "yarn gen:openapi && yarn gen:patterns && yarn move:assets"
      }
    }
    ```
    *Note: `convert:txt` is a one-time batch conversion and is not included in the regular `docs:build` process.* 

*   **How to run:**
    ```bash
    yarn docs:build
    ```

### 6. Add a Git Pre-commit Hook with Husky

**Objective:** Automatically regenerate and stage documentation before each commit to prevent staleness.

*   **What to do:** Use Husky to manage Git hooks.

    1.  **Install Husky:**
        ```bash
        yarn add -D husky
        ```
    2.  **Enable hooks:**
        ```bash
        npx husky install
        ```
    3.  **Create pre-commit hook:**
        ```bash
        npx husky add .husky/pre-commit "yarn docs:build && git add docs/api/openapi_v1.json docs/guides/code-patterns.md docs/assets"
        ```
        This command creates an executable file at `.husky/pre-commit`.

*   **How to run:** This hook will fire automatically on every `git commit` command.

### 7. Iterate Prompt-Engineering for Each Script

**Objective:** Ensure generated scripts are robust and meet requirements.

*   **What to do:** For each script provided above, refine the prompts used to generate them. Specify input/output paths, handle edge cases (e.g., nested folders, missing front-matter for pattern titles), and define desired Markdown style (e.g., link format, heading levels).
*   **Why it matters:** Tight prompts ensure the generated scripts work correctly the first time and require minimal manual tweaking, maximizing AI agent efficiency.

### 8. Verify Outputs and Commit

**Objective:** Confirm the integrity and accuracy of the generated documentation.

*   **What to do:** After running the `docs:build` pipeline (or individual scripts), perform the following verification steps:
    *   **`openapi_v1.json`:** Manually inspect to ensure it covers all expected routes (auth, payments, notifications, status, etc.) and that schemas are correctly represented.
    *   **`code-patterns.md`:** Verify that it lists every cookbook entry, and that links are correct and clickable. Check for proper categorization.
    *   **File Links:** Use `yarn lint:links` to ensure no broken image or file links within the `docs` directory.
    *   **Converted TXT Content:** Confirm that all old `.txt` content has been accurately converted and lives in the new `.md` files.
    *   **Git Diffs:** Use your AI agent to review the `git diff` output before committing to ensure only expected changes are present.

### Quick Reminder of Commands

*   **Generate all docs:**
    ```bash
    yarn docs:build
    ```
*   **Convert TXT → MD (one-off):**
    ```bash
    yarn convert:txt
    ```
*   **Check links:**
    ```bash
    yarn lint:links
    ```

With these Yarn-native scripts and Husky hooks, your Phase 1 pipeline will be smooth, consistent, and fully automated—no npm in sight.
