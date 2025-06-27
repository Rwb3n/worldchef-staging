import os
import re

def generate_patterns_index(cookbook_path, output_path):
    patterns = []
    for root, _, files in os.walk(cookbook_path):
        for file in files:
            if file.endswith('.md'):
                filepath = os.path.join(root, file)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()
                except UnicodeDecodeError:
                    print(f"Warning: Could not decode file {filepath} as UTF-8. Skipping.")
                    continue
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
