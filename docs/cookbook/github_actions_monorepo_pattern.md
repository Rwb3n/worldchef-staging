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

## Private Repository Configuration

### Issue: Private Repository Access in GitHub Actions
When using private repositories, GitHub Actions may fail with "Repository not found" errors during checkout steps, especially in security scanning jobs.

**Problem**: Default `GITHUB_TOKEN` has limited permissions for private repositories.

**Solution**: Configure explicit permissions and token usage:

```yaml
# For jobs that need repository access in private repos
zap-security-scan:
  needs: deploy-staging
  runs-on: ubuntu-latest
  name: OWASP ZAP baseline scan
  permissions:
    contents: read  # ← Required for private repo access
    issues: write   # ← For creating security issues
  steps:
    - name: Checkout
      uses: actions/checkout@v4
      with:
        token: ${{ secrets.GITHUB_TOKEN }}  # ← Explicit token required
    
    - name: ZAP Scan
      uses: zaproxy/action-baseline@v0.11.0
      with:
        target: 'https://worldchef-staging.onrender.com'
```

### Key Points:
- **Always add `contents: read`** to job permissions for private repos
- **Explicitly specify `token: ${{ secrets.GITHUB_TOKEN }}`** in checkout steps
- **This applies to all jobs**, not just security scans
- **Public repositories don't need this configuration**

## Security Best Practices

1. **Never commit secrets**: Use GitHub secrets for all sensitive data
2. **Environment isolation**: Use different secrets for dev/staging/production
3. **Minimal permissions**: Grant only necessary permissions to deploy hooks
4. **Private repo access**: Configure proper permissions for private repositories
5. **Audit access**: Regularly review who has access to secrets
6. **Rotate credentials**: Periodically update API keys and deploy hooks

## Performance Optimizations

1. **Dependency caching**: Use `cache: 'yarn'` in setup-node action
2. **Frozen lockfile**: Use `--frozen-lockfile` for reproducible installs
3. **Parallel jobs**: Consider splitting build/test into parallel jobs
4. **Artifact caching**: Cache build outputs between stages
5. **Conditional steps**: Use `if:` conditions to skip unnecessary steps

## OWASP ZAP Security Scanning Integration

### Issue: ZAP Action Artifact Upload Failures
The `zaproxy/action-baseline` GitHub Action has built-in artifact upload functionality that can conflict with GitHub's artifact API validation, causing "400 Bad Request: Artifact name is not valid" errors.

**Problem**: ZAP action attempts to upload artifacts with default names that may not pass GitHub's validation, especially in private repositories or specific GitHub Actions environments.

**Symptoms**:
```
Error: Create Artifact Container failed: The artifact name zap_scan is not valid
Status Code: 400 Bad Request
```

**Solution**: Replace the ZAP action with direct Docker execution for complete control:

```yaml
# ❌ PROBLEMATIC: Using ZAP action (may fail artifact upload)
- name: ZAP Scan
  uses: zaproxy/action-baseline@v0.11.0
  with:
    target: 'https://worldchef-staging.onrender.com'
    fail_action: false

# ✅ RELIABLE: Direct Docker execution
- name: Run ZAP Baseline Scan
  run: |
    mkdir -p zap-reports
    docker run -v ${{ github.workspace }}:/zap/wrk/:rw \
      -t ghcr.io/zaproxy/zaproxy:stable \
      zap-baseline.py \
      -t https://worldchef-staging.onrender.com \
      -J zap-reports/report_json.json \
      -w zap-reports/report_md.md \
      -r zap-reports/report_html.html \
      -x zap-reports/report_xml.xml \
      -I || echo "ZAP scan completed with warnings (expected)"

- name: Upload ZAP reports
  uses: actions/upload-artifact@v4
  if: always()
  with:
    name: zap-security-reports
    path: zap-reports/
```

### Benefits of Direct Docker Approach:
1. **Eliminates Artifact Conflicts**: No dual upload attempts causing API errors
2. **Complete Control**: Full control over report generation and organization
3. **Multiple Report Formats**: JSON, Markdown, HTML, and XML reports
4. **Reliable Upload**: Single, clean artifact upload path
5. **Better Error Handling**: Proper handling of expected warnings with `-I` flag
6. **Maintained Functionality**: Same security validation capabilities

### ZAP Command Line Options:
- `-t <target>`: Target URL to scan
- `-J <file>`: Generate JSON report
- `-w <file>`: Generate Markdown report  
- `-r <file>`: Generate HTML report
- `-x <file>`: Generate XML report
- `-I`: Don't return failure on warnings (recommended for CI)
- `-a`: Include alpha passive scan rules
- `-d`: Show debug messages

### Complete Security Scanning Job:
```yaml
zap-security-scan:
  needs: deploy-staging
  runs-on: ubuntu-latest
  name: OWASP ZAP baseline scan
  permissions:
    contents: read  # Required for private repos
    issues: write   # Optional: for GitHub issue creation
  steps:
    - name: Checkout
      uses: actions/checkout@v4
      with:
        token: ${{ secrets.GITHUB_TOKEN }}
    
    - name: Run ZAP Baseline Scan
      run: |
        mkdir -p zap-reports
        docker run -v ${{ github.workspace }}:/zap/wrk/:rw \
          -t ghcr.io/zaproxy/zaproxy:stable \
          zap-baseline.py \
          -t https://worldchef-staging.onrender.com \
          -J zap-reports/report_json.json \
          -w zap-reports/report_md.md \
          -r zap-reports/report_html.html \
          -x zap-reports/report_xml.xml \
          -I || echo "ZAP scan completed with warnings (expected)"
    
    - name: Upload ZAP reports
      uses: actions/upload-artifact@v4
      if: always()
      with:
        name: zap-security-reports
        path: zap-reports/
```

This pattern provides reliable OWASP ZAP security scanning without GitHub Actions artifact upload issues.

## Summary

This pattern ensures reliable, consistent CI/CD for Yarn monorepo projects with proper secret management, real service integration, and robust security scanning. 