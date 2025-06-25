// @ts-nocheck
import fs from 'fs';
import path from 'path';

describe('Code Patterns Guide', () => {
  const guidePath = path.resolve(__dirname, '../../../docs/guides/code-patterns.md');

  it('should exist and have correct heading', () => {
    expect(fs.existsSync(guidePath)).toBe(true);

    if (fs.existsSync(guidePath)) {
      const content = fs.readFileSync(guidePath, 'utf-8');
      expect(/^#\s*WorldChef Code Patterns/m.test(content)).toBe(true);
    }
  });
}); 