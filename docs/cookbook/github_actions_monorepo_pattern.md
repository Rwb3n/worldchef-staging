# Cookbook: GitHub Actions CI/CD for Yarn Monorepo

**Pattern:** GitHub Actions Workflows for Yarn Workspace Monorepo Deployment
**Source:** CI/CD Pipeline Resolution (Cycle 4, Week 1)
**Validated in:** Cycle 4 - Task t002

This pattern provides a robust GitHub Actions setup for monorepo projects using Yarn workspaces, with proper package manager consistency and secret management.

## Problem Statement

Monorepo projects with Yarn workspaces require careful CI/CD configuration to ensure consistent package manager usage, proper workspace references, and secure credential management. Common issues include npm/yarn conflicts, incorrect workspace naming, and missing dependencies.

## Core Principles

1. **Package Manager Consistency**: Use the same package manager (Yarn) throughout the entire pipeline
2. **Workspace Naming**: Use package names from `package.json`, not directory names
3. **Credential Security**: Manage secrets properly for different environments
4. **Build Optimization**: Cache dependencies and optimize build steps
5. **Test Integration**: Include real service integration in CI/CD

## Implementation Pattern

### Project Structure
```
worldchef/
├── package.json              # Root package with workspaces config
├── yarn.lock                 # Single lockfile for entire monorepo
├── backend/
│   └── package.json          # Workspace: "worldchef-backend"
├── shared/
│   └── package.json          # Workspace: "@worldchef/shared"
└── .github/workflows/
    ├── dev-deploy.yml
    └── staging-deploy.yml
```

### Root Package Configuration
```json
{
  "name": "worldchef-monorepo",
  "private": true,
  "version": "1.0.0",
  "packageManager": "yarn@1.22.22",
  "workspaces": [
    "backend",
    "shared"
  ],
  "scripts": {
    "dev": "yarn workspace worldchef-backend run dev",
    "start": "yarn workspace worldchef-backend run start",
    "build": "yarn workspace worldchef-backend run build",
    "start:prod": "yarn workspace worldchef-backend run start:prod",
    "test": "yarn workspaces run test",
    "test:ci": "yarn workspaces run test --coverage",
    "test:workspace": "yarn workspaces run test",
    "test:deno": "deno task test",
    "test:all": "yarn test && yarn test:deno"
  }
}
```

### Staging Deployment Workflow
```yaml
# .github/workflows/staging-deploy.yml
name: Staging Deploy

on:
  push:
    tags:
      - 'v*'
  workflow_dispatch:

jobs:
  deploy-staging:
    runs-on: ubuntu-latest
    environment:
      name: staging-deploy
      url: https://worldchef-staging.onrender.com
    steps:
      - uses: actions/checkout@v4

      - name: Set up Node
        uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: 'yarn'

      - name: Enable Corepack & install dependencies
        run: |
          corepack enable  # Ensure Yarn is available
          yarn --version
          yarn install --frozen-lockfile

      - name: Build TypeScript
        run: |
          yarn workspace worldchef-backend run build

      - name: Run unit tests (with coverage gate)
        run: |
          yarn test:ci --coverage
        env:
          JEST_JUNIT_OUTPUT_DIR: ./reports
          SUPABASE_URL: https://myqhpmeprpaukgagktbn.supabase.co
          SUPABASE_SERVICE_ROLE_KEY: ${{ secrets.SUPABASE_SERVICE_ROLE_KEY }}

      - name: Upload coverage artefacts
        if: success()
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage/

      - name: Deploy to Render via Deploy Hook
        env:
          RENDER_STAGING_DEPLOY_HOOK_URL: ${{ secrets.RENDER_STAGING_DEPLOY_HOOK_URL }}
        run: |
          curl -X POST "$RENDER_STAGING_DEPLOY_HOOK_URL"

      - name: Verify health & fail on unhealthy service
        env:
          HEALTH_URL: https://worldchef-staging.onrender.com/health
          MAX_ATTEMPTS: 20
          SLEEP_SECONDS: 30
        run: |
          set -e
          i=1
          echo "Starting health probe for $HEALTH_URL (max ${MAX_ATTEMPTS}×${SLEEP_SECONDS}s ≈ $((MAX_ATTEMPTS * SLEEP_SECONDS / 60)) min)"
          while [ "$i" -le "$MAX_ATTEMPTS" ]; do
            printf "[%s] Attempt %d/%d … " "$(date -u +'%H:%M:%S')" "$i" "$MAX_ATTEMPTS"
            if curl -sf "$HEALTH_URL" > /dev/null ; then
              echo "healthy ✔️"
              exit 0
            fi
            echo "unhealthy – sleeping ${SLEEP_SECONDS}s"
            sleep "$SLEEP_SECONDS"
            i=$((i+1))
          done
          echo "Health check FAILED after $MAX_ATTEMPTS attempts ❌"
          exit 1
```

### Development Deployment Workflow
```yaml
# .github/workflows/dev-deploy.yml
name: Dev Deploy

on:
  push:
    branches:
      - develop
  workflow_dispatch:

jobs:
  deploy-dev:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout source
        uses: actions/checkout@v4

      - name: Set up Node
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'yarn'

      - name: Enable Corepack & install dependencies
        run: |
          corepack enable
          yarn install --frozen-lockfile

      - name: Build TypeScript
        run: |
          yarn workspace worldchef-backend run build

      - name: Run unit tests
        run: |
          yarn test:ci
        env:
          SUPABASE_URL: https://myqhpmeprpaukgagktbn.supabase.co
          SUPABASE_SERVICE_ROLE_KEY: ${{ secrets.SUPABASE_SERVICE_ROLE_KEY }}

      - name: Deploy to Render via Deploy Hook
        env:
          RENDER_DEV_DEPLOY_HOOK_URL: ${{ secrets.RENDER_DEV_DEPLOY_HOOK_URL }}
        run: |
          curl -X POST "$RENDER_DEV_DEPLOY_HOOK_URL"
```

## Key Configuration Details

### Package Manager Setup
```yaml
# Always use corepack to ensure Yarn availability
- name: Enable Corepack & install dependencies
  run: |
    corepack enable  # Ensures Yarn is available in CI
    yarn --version   # Verify Yarn installation
    yarn install --frozen-lockfile  # Use lockfile for reproducible builds
```

### Workspace Commands
```yaml
# Use package names, not directory names
- name: Build TypeScript
  run: |
    yarn workspace worldchef-backend run build  # ✅ Package name
    # NOT: yarn workspace backend run build     # ❌ Directory name
```

### Environment Variables for Testing
```yaml
# Include real service credentials for integration tests
- name: Run unit tests (with coverage gate)
  run: |
    yarn test:ci --coverage
  env:
    JEST_JUNIT_OUTPUT_DIR: ./reports
    SUPABASE_URL: https://myqhpmeprpaukgagktbn.supabase.co
    SUPABASE_SERVICE_ROLE_KEY: ${{ secrets.SUPABASE_SERVICE_ROLE_KEY }}
```

### Deploy Hook Pattern
```yaml
# Use GitHub secrets for deploy hooks
- name: Deploy to Render via Deploy Hook
  env:
    RENDER_STAGING_DEPLOY_HOOK_URL: ${{ secrets.RENDER_STAGING_DEPLOY_HOOK_URL }}
  run: |
    curl -X POST "$RENDER_STAGING_DEPLOY_HOOK_URL"
```

## Secret Management

### GitHub Repository Secrets
Configure these secrets in **Settings > Secrets and variables > Actions**:

```bash
# Supabase Integration
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIs...

# Render Deployment
RENDER_DEV_DEPLOY_HOOK_URL=https://api.render.com/deploy/srv-xyz?key=abc123
RENDER_STAGING_DEPLOY_HOOK_URL=https://api.render.com/deploy/srv-xyz?key=def456

# Optional: Environment-specific secrets
STRIPE_TEST_SECRET_KEY=sk_test_...
FCM_SERVER_KEY=...
```

### Environment-Specific Configuration
```yaml
# Use GitHub Environments for staged deployments
environment:
  name: staging-deploy
  url: https://worldchef-staging.onrender.com
```

## Common Issues & Solutions

### Issue 1: Package Manager Conflicts
```bash
# ❌ Problem: Mixing npm and yarn
npm ci  # In workflow
yarn install  # In local development

# ✅ Solution: Consistent Yarn usage
corepack enable
yarn install --frozen-lockfile
```

### Issue 2: Workspace Naming Confusion
```bash
# ❌ Problem: Using directory names
yarn workspace backend run build

# ✅ Solution: Use package.json names
yarn workspace worldchef-backend run build
```

### Issue 3: Missing Dependencies
```json
// ❌ Problem: Missing dev dependencies in backend/package.json
{
  "devDependencies": {
    "jest": "^29.0.0"
    // Missing: typescript, @types/node
  }
}

// ✅ Solution: Complete dev dependencies
{
  "devDependencies": {
    "jest": "^29.0.0",
    "typescript": "^5.0.0",
    "@types/node": "^18.0.0"
  }
}
```

### Issue 4: Test Environment Configuration
```yaml
# ❌ Problem: Using mock services in CI
env:
  SUPABASE_URL: mock://supabase

# ✅ Solution: Real service integration
env:
  SUPABASE_URL: https://myqhpmeprpaukgagktbn.supabase.co
  SUPABASE_SERVICE_ROLE_KEY: ${{ secrets.SUPABASE_SERVICE_ROLE_KEY }}
```

## Health Check Pattern
```yaml
# Robust health checking after deployment
- name: Verify health & fail on unhealthy service
  env:
    HEALTH_URL: https://worldchef-staging.onrender.com/health
    MAX_ATTEMPTS: 20
    SLEEP_SECONDS: 30
  run: |
    set -e
    i=1
    echo "Starting health probe for $HEALTH_URL"
    while [ "$i" -le "$MAX_ATTEMPTS" ]; do
      printf "[%s] Attempt %d/%d … " "$(date -u +'%H:%M:%S')" "$i" "$MAX_ATTEMPTS"
      if curl -sf "$HEALTH_URL" > /dev/null ; then
        echo "healthy ✔️"
        exit 0
      fi
      echo "unhealthy – sleeping ${SLEEP_SECONDS}s"
      sleep "$SLEEP_SECONDS"
      i=$((i+1))
    done
    echo "Health check FAILED after $MAX_ATTEMPTS attempts ❌"
    exit 1
```

## Security Best Practices

1. **Never commit secrets**: Use GitHub secrets for all sensitive data
2. **Environment isolation**: Use different secrets for dev/staging/production
3. **Minimal permissions**: Grant only necessary permissions to deploy hooks
4. **Audit access**: Regularly review who has access to secrets
5. **Rotate credentials**: Periodically update API keys and deploy hooks

## Performance Optimizations

1. **Dependency caching**: Use `cache: 'yarn'` in setup-node action
2. **Frozen lockfile**: Use `--frozen-lockfile` for reproducible installs
3. **Parallel jobs**: Consider splitting build/test into parallel jobs
4. **Artifact caching**: Cache build outputs between stages
5. **Conditional steps**: Use `if:` conditions to skip unnecessary steps

This pattern ensures reliable, consistent CI/CD for Yarn monorepo projects with proper secret management and real service integration. 