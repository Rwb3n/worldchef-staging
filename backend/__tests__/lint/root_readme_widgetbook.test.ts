// @ts-nocheck
import fs from 'fs';
import path from 'path';

describe('Root README Widgetbook Documentation', () => {
  const readmePath = path.resolve(__dirname, '../../../README.md');

  it('should mention the new Widgetbook workflows', () => {
    expect(fs.existsSync(readmePath)).toBe(true);

    const content = fs.readFileSync(readmePath, 'utf-8');

    // Expect README to mention the local dev command
    expect(content).toMatch(/yarn\s+widgetbook:dev/);

    // Expect README to mention interactive stories or knobs
    expect(content).toMatch(/interactive\s+stories?/i);
  });
}); 