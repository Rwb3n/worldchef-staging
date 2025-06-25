// @ts-nocheck
import fs from 'fs';
import path from 'path';

describe('Widgetbook catalogue', () => {
  const cataloguePath = path.resolve(__dirname, '../../../docs/widgetbook/index.html');

  it('should have a published static catalogue', () => {
    expect(fs.existsSync(cataloguePath)).toBe(true);
  });
}); 