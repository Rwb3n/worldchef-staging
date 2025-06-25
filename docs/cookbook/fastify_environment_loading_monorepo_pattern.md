# Fastify Environment Variable Loading in Monorepo Pattern

> **Pattern Type**: Backend Configuration  
> **Complexity**: Intermediate  
> **Use Case**: Loading environment variables from `.env` files in Fastify backend within Yarn workspace monorepo  
> **Validation**: TDD-driven with Jest integration tests

## Problem Statement

In a Yarn workspace monorepo structure, Fastify backend servers need to load environment variables from `.env.local` or `.env` files located at the project root, not the backend subdirectory. Standard dotenv configuration fails because it looks for environment files relative to the current working directory, causing "missing environment variables" errors during server startup.

## Solution Architecture

```
worldchef/                    # Project root - contains .env.local
├── .env.local               # Environment variables here
├── .env                     # Fallback environment variables
├── backend/                 # Fastify backend workspace
│   ├── src/
│   │   └── server.ts        # Dotenv configuration here
│   └── package.json         # Backend dependencies
└── package.json             # Workspace configuration
```

## Implementation

### 1. Install Dependencies

```bash
# In backend workspace
cd backend
yarn add dotenv
yarn add -D @types/jest  # For testing

# In workspace root (if needed globally)
yarn add -D -W @types/jest
```

### 2. Configure Dotenv in Server Entry Point

```typescript
// backend/src/server.ts
import dotenv from 'dotenv';
import path from 'path';

// Load environment variables from project root
dotenv.config({ path: path.resolve(__dirname, '../../.env.local') });

// Fallback to .env if .env.local doesn't exist
import fs from 'fs';
const envLocalPath = path.resolve(__dirname, '../../.env.local');
const envPath = path.resolve(__dirname, '../../.env');
if (!fs.existsSync(envLocalPath) && fs.existsSync(envPath)) {
  dotenv.config({ path: envPath });
}

import Fastify, { FastifyInstance, FastifyServerOptions } from 'fastify';
// ... rest of server code
```

### 3. Update TypeScript Configuration for Tests

```json
// backend/tsconfig.json
{
  "compilerOptions": {
    "target": "es2018",
    "module": "commonjs",
    "esModuleInterop": true,
    "strict": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "./dist",
    // Remove "rootDir": "./src" to allow test files outside src/
    "typeRoots": ["./node_modules/@types", "./src/types"],
    "types": ["node", "jest"]
  },
  "include": ["src/**/*", "__tests__/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

### 4. Configure Jest for Environment Testing

```javascript
// backend/jest.config.js
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  testMatch: ['**/__tests__/**/*.test.ts'],
  setupFiles: ['<rootDir>/__tests__/setup.js'],
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node'],
  transform: {
    '^.+\\.(ts|tsx)$': ['ts-jest', {
      tsconfig: {
        module: 'commonjs',
        target: 'es2018',
        esModuleInterop: true,
        skipLibCheck: true,
        types: ['jest', 'node'],
        typeRoots: ['../node_modules/@types', './node_modules/@types']
      }
    }]
  },
  collectCoverageFrom: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.d.ts',
  ]
};
```

## TDD Validation Pattern

### Test Creation (Red State)

```typescript
// backend/__tests__/integration/env_loading.test.ts
import dotenv from 'dotenv';
import path from 'path';
import fs from 'fs';

describe('Environment Variable Loading (Dotenv Compatibility)', () => {
  const envPath = path.resolve(__dirname, '../../.test.env');
  const testVar = 'TEST_ENV_VAR';
  const expectedValue = 'env_loading_test_value';

  beforeAll(() => {
    // Ensure test environment file exists
    if (!fs.existsSync(envPath)) {
      throw new Error('.test.env file missing for env loading test');
    }
    
    // Load test environment to simulate server behavior
    dotenv.config({ path: envPath });
  });

  it('should load TEST_ENV_VAR from .test.env into process.env', () => {
    expect(process.env[testVar]).toBe(expectedValue);
  });
});
```

```bash
# .test.env (temporary test file)
TEST_ENV_VAR=env_loading_test_value
```

### Implementation (Green State)

The dotenv configuration in `server.ts` (shown above) should make the test pass.

### Refactoring (Clean State)

Remove temporary test artifacts after validation:
```bash
rm backend/__tests__/integration/env_loading.test.ts
rm backend/.test.env
```

## Validation Commands

```bash
# Test environment loading
cd backend
yarn test __tests__/integration/env_loading.test.ts

# Test server startup
yarn start
# Should show: "Server listening at http://0.0.0.0:10000"
```

## Common Issues & Solutions

### Issue 1: "Cannot find name 'describe'" in tests
**Cause**: Jest types not properly configured in TypeScript  
**Solution**: 
- Install `@types/jest` at workspace root: `yarn add -D -W @types/jest`
- Update `jest.config.js` with proper `typeRoots` configuration
- Remove `rootDir` restriction from `tsconfig.json`

### Issue 2: Environment variables not loaded
**Cause**: Incorrect path resolution in monorepo structure  
**Solution**: Use `path.resolve(__dirname, '../../.env.local')` to resolve from backend to root

### Issue 3: Server fails in production
**Cause**: Production environments don't use `.env` files  
**Solution**: Ensure production deployment sets environment variables directly (e.g., Render secrets)

## Integration Points

- **Supabase Plugin**: Requires `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY`
- **Auth Plugin**: May require JWT secrets and configuration
- **External APIs**: API keys and endpoints
- **Database**: Connection strings and pool configuration

## Performance Considerations

- **Startup Time**: Dotenv loading adds ~1-5ms to server startup
- **Memory**: Environment variables are loaded once into `process.env`
- **Security**: Never commit `.env.local` to version control

## Checklist

- [ ] `dotenv` dependency installed in backend workspace
- [ ] Path resolution configured for project root environment files
- [ ] TypeScript configuration updated to support test files
- [ ] Jest configuration includes proper type roots
- [ ] Server starts successfully with environment variables loaded
- [ ] Environment variables validated in production deployment
- [ ] `.env.local` and `.env` files added to `.gitignore`

## Related Patterns

- [Fastify Comprehensive Testing Pattern](./fastify_comprehensive_testing_pattern.md)
- [Test Environment Real vs Mock Pattern](./test_environment_real_vs_mock_pattern.md)
- [Render Monorepo Backend Deployment Pattern](./render_monorepo_backend_deployment_pattern.md) 