// @ts-nocheck
import fs from 'fs';
import path from 'path';

describe('System architecture diagram', () => {
  const diagramPath = path.resolve(__dirname, '../../../docs/architecture/system-overview.md');

  it('should exist and contain a Mermaid diagram header', () => {
    // Expect the file to exist – this will fail (Red) until the diagram is created.
    expect(fs.existsSync(diagramPath)).toBe(true);

    // If the file exists, ensure it contains a Mermaid code fence.
    if (fs.existsSync(diagramPath)) {
      const content = fs.readFileSync(diagramPath, 'utf-8');
      expect(/```\s*mermaid/gi.test(content)).toBe(true);
    }
  });
}); 