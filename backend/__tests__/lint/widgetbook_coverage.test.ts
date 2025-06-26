import * as fs from 'fs';
import * as path from 'path';
import { describe, it, expect } from '@jest/globals';

// Helper function to recursively get all files in a directory
const getFiles = (dir: string): string[] => {
  const dirents = fs.readdirSync(dir, { withFileTypes: true });
  const files = dirents.map((dirent) => {
    const res = path.resolve(dir, dirent.name);
    return dirent.isDirectory() ? getFiles(res) : res;
  });
  return Array.prototype.concat(...files);
};

// Helper to convert a component file path to a simplified name
const getComponentName = (filePath: string): string => {
  return path
    .basename(filePath, '.dart') // remove .dart
    .replace('wc_', '') // remove prefix
    .replace('_', ''); // remove underscores
};

const getComponentNameFromFile = (filePath: string): string => {
  const content = fs.readFileSync(filePath, 'utf8');
  const match = content.match(/class\s+(WC\w+)\s+extends/);
  return match ? match[1] : '';
};

describe('Linting: Widgetbook Coverage', () => {
  it('should have a corresponding story for every UI component', () => {
    const projectRoot = path.resolve(__dirname, '../../../');
    const uiDir = path.resolve(projectRoot, 'mobile/lib/src/ui');
    const widgetbookDir = path.resolve(
      projectRoot,
      'mobile/lib/widgetbook'
    );

    const componentFiles = getFiles(uiDir).filter((file) => file.endsWith('.dart'));
    const storyFiles = getFiles(widgetbookDir).filter((file) =>
      file.endsWith('_stories.dart')
    );
    
    // Get a list of all component class names from the UI files
    const componentNames = componentFiles
      .map(getComponentNameFromFile)
      .filter(Boolean);

    // Get a list of all WidgetbookComponent names from the story files
    let allStoryContent = '';
    storyFiles.forEach(file => {
      allStoryContent += fs.readFileSync(file, 'utf8');
    });
    
    const documentedComponents = [...allStoryContent.matchAll(/name:\s*'(\w+)'/g)].map(match => match[1]);

    const missingStories = componentNames.filter(
      (componentName) => !documentedComponents.includes(componentName)
    );

    expect(missingStories).toEqual([]);
  });
}); 