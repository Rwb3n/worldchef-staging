# Render Deployment Troubleshooting Pattern

> Artifact: render_deployment_troubleshooting_pattern | g<g-ref> | 2025-07-19

## 1. Context

This document provides a systematic approach to diagnosing and resolving common Render deployment failures. It is based on real troubleshooting experience from deploying a Node.js/TypeScript backend service in a monorepo setup.

## 2. Problem Categories

Render deployment failures typically fall into these categories:

### A. Configuration Override Issues
**Symptom**: `render.yaml` settings are ignored
**Root Cause**: Render dashboard settings override file-based configuration

### B. Package Manager Conflicts  
**Symptom**: `Missing script` errors despite correct `package.json`
**Root Cause**: Mismatch between build environment (yarn) and project setup (npm)

### C. Build Process Failures
**Symptom**: `Cannot find module` errors for compiled files
**Root Cause**: Build step not executing or targeting wrong directory

### D. Plugin/Dependency Loading Issues
**Symptom**: Runtime errors about missing decorators or clients
**Root Cause**: Incorrect plugin loading order or missing dependencies

## 3. Diagnostic Process

### Step 1: Analyze Build vs Runtime Logs
```bash
# Look for these patterns in logs:
# Build phase: "yarn install" vs "npm install" 
# Runtime phase: Command being executed vs expected command
# Error location: Build-time vs runtime errors
```

### Step 2: Check Configuration Hierarchy
1. **Render Dashboard Settings** (highest priority)
2. **render.yaml** (middle priority) 
3. **package.json scripts** (lowest priority)

### Step 3: Verify Package Manager Consistency
```bash
# Check for conflicting lock files:
ls -la package-lock.json yarn.lock

# Render defaults to yarn if both exist
# Solution: Delete package-lock.json, use yarn.lock
```

## 4. Resolution Patterns

### Pattern A: Dashboard Override Workaround
**When**: render.yaml commands are ignored
**Solution**: Add missing scripts to root package.json

```json
{
  "scripts": {
    "build": "npm --workspace backend run build",
    "start:prod": "npm --workspace backend run start:prod"
  }
}
```

### Pattern B: Package Manager Alignment
**When**: Build succeeds but wrong package manager used
**Solution**: Standardize on yarn

```bash
# Remove npm artifacts
rm package-lock.json

# Generate yarn lockfile
yarn install

# Update render.yaml
buildCommand: "yarn install && yarn workspace backend build"
startCommand: "yarn workspace backend start:prod"
```

### Pattern C: Automatic Build Integration
**When**: Build step not executing automatically
**Solution**: Use postinstall hook

```json
{
  "scripts": {
    "postinstall": "npm --workspace backend run build"
  }
}
```

### Pattern D: Plugin Dependency Management
**When**: Runtime errors about missing decorators
**Solution**: Explicit plugin dependencies

```typescript
// Create dedicated plugins with named exports
export default fp(supabasePlugin, { name: 'supabase' });

// Declare dependencies in dependent plugins
export default fp(authRoutes, {
  dependencies: ['supabase']
});
```

## 5. Prevention Checklist

### Before Deployment:
- [ ] Verify package manager consistency (yarn.lock XOR package-lock.json)
- [ ] Test build commands locally in monorepo context
- [ ] Ensure plugin loading order is explicit
- [ ] Check that all required environment variables are configured

### During Troubleshooting:
- [ ] Compare build vs runtime command execution
- [ ] Check for dashboard setting overrides
- [ ] Verify file paths match between build and runtime
- [ ] Test plugin initialization order

### After Resolution:
- [ ] Document the specific fix applied
- [ ] Update render.yaml if dashboard settings were changed
- [ ] Consider whether fix should be permanent or temporary

## 6. Common Error Patterns

### Error: `Missing script: "start:prod"`
**Diagnosis**: Dashboard override or wrong package.json
**Fix**: Add script to root package.json or update dashboard

### Error: `Cannot find module '/path/to/dist/server.js'`
**Diagnosis**: Build step not running
**Fix**: Add postinstall hook or fix buildCommand

### Error: `==> Running build command 'yarn'...` (instead of full build command)
**Diagnosis**: Dashboard override ignoring render.yaml buildCommand
**Symptoms**: 
- Logs show `yarn` instead of `yarn install && yarn build`
- TypeScript compilation never occurs
- dist/ directory missing or empty
**Fix**: Add postinstall fallback script:
```json
{
  "scripts": {
    "postinstall": "yarn workspace worldchef-backend run build",
    "heroku-postbuild": "yarn workspace worldchef-backend run build"
  }
}
```

### Error: `Method 'GET' already declared for route`
**Diagnosis**: Duplicate route definitions
**Fix**: Remove redundant route registrations

### Error: `[Plugin] not available. Make sure [plugin] is registered`
**Diagnosis**: Plugin loading order issue
**Fix**: Add explicit dependencies or reorder registration

## 7. Verification Steps

After implementing fixes:

1. **Deploy and Monitor**: Watch full deployment logs
2. **Test Health Endpoint**: Verify service responds correctly
3. **Check Security Scan**: Ensure no new vulnerabilities introduced
4. **Validate Functionality**: Test actual API endpoints

## 8. Long-term Recommendations

1. **Standardize on Yarn**: For Render compatibility
2. **Use render.yaml as Documentation**: Even if dashboard overrides
3. **Implement Health Checks**: For faster failure detection
4. **Document Dashboard Settings**: Track manual configurations
5. **Automate Testing**: Include deployment validation in CI/CD

This pattern provides a systematic approach to Render deployment issues and should significantly reduce troubleshooting time for future deployments. 