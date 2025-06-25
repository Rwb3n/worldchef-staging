// @ts-nocheck
import fs from 'fs';
import path from 'path';

describe('Backend API architecture diagram', () => {
  const diagramPath = path.resolve(__dirname, '../../../docs/architecture/backend-api.md');

  it('should exist and contain a Mermaid diagram header', () => {
    expect(fs.existsSync(diagramPath)).toBe(true);

    if (fs.existsSync(diagramPath)) {
      const content = fs.readFileSync(diagramPath, 'utf-8');
      expect(/```\s*mermaid/gi.test(content)).toBe(true);
    }
  });
}); 