// @ts-nocheck
import fs from 'fs';
import path from 'path';

describe('Mobile Widgetbook README', () => {
  const readmePath = path.resolve(__dirname, '../../../mobile/lib/widgetbook/README.md');
  const content = fs.readFileSync(readmePath, 'utf8');

  it('should mention "interactive stories" to guide developers', () => {
    expect(content.toLowerCase()).toContain('interactive stories');
  });

  it('should document dual build command yarn widgetbook:build:local', () => {
    expect(content).toMatch(/yarn\s+widgetbook:build:local/);
  });
}); 