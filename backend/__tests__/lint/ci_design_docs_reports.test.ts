// @ts-nocheck
import fs from 'fs';
import path from 'path';

describe('Investigative Reports Presence', () => {
  const requiredFiles = [
    path.resolve(__dirname, '../../../docs/reports/ci_cd_docs_investigation.md'),
    path.resolve(__dirname, '../../../docs/reports/design_docs_investigation.md'),
  ];

  it('should have generated investigative report markdown files', () => {
    requiredFiles.forEach((file) => {
      const exists = fs.existsSync(file);
      expect(exists).toBe(true);
    });
  });
}); 