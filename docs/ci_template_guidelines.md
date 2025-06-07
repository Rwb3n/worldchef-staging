# CI Template Guidelines for WorldChef PoC

> **📋 Navigation**: This document is part of the WorldChef PoC documentation suite. See [Stage 1 Onboarding Guide](./stage1_onboarding_guide.md) for complete project overview and navigation.

This document defines the shared CI/CD pipeline requirements and standards for both Flutter and React Native PoC projects to ensure fair comparison.

## Overview

Both Flutter and React Native projects must implement equivalent CI steps to maintain parity in the comparative analysis. The CI pipeline should validate code quality, run tests, and verify build success.

## Required CI Steps

### 1. Code Quality & Linting
- **Flutter**: Run `flutter analyze` 
- **React Native**: Run `eslint` with project configuration
- **Validation Criteria**: Zero linting errors or warnings that would block development

### 2. Code Formatting
- **Flutter**: Run `dart format --set-exit-if-changed .` (or equivalent check)
- **React Native**: Run `prettier --check .` 
- **Validation Criteria**: All code follows consistent formatting standards

### 3. Unit Testing
- **Flutter**: Run `flutter test` (if unit tests exist)
- **React Native**: Run `npm test` or `yarn test` (if unit tests exist)
- **Validation Criteria**: All existing tests pass; no test failures

### 4. Build Verification
- **Flutter**: 
  - Android: `flutter build apk --debug` or `flutter build appbundle --debug`
  - iOS: `flutter build ios --debug --no-codesign`
- **React Native (Expo)**:
  - `expo export` or `eas build --platform android --profile development`
  - `eas build --platform ios --profile development` (if applicable)
- **Validation Criteria**: Build completes successfully without errors

## CI Pipeline Structure

```yaml
# Example GitHub Actions structure (adapt for each platform)
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      # Platform-specific setup steps
      - name: Setup Environment
        # Flutter: Setup Flutter SDK
        # React Native: Setup Node.js
        
      - name: Install Dependencies
        # Flutter: flutter pub get
        # React Native: npm install or yarn install
        
      - name: Lint
        # Platform-specific linting command
        
      - name: Format Check
        # Platform-specific formatting validation
        
      - name: Test
        # Platform-specific test command (if tests exist)
        
      - name: Build
        # Platform-specific build command
```

## Environment Requirements

### Flutter Projects
- Flutter SDK: Latest stable version
- Dart SDK: Included with Flutter
- Android SDK: API level 31+ for Android builds
- Xcode: Latest stable (for iOS builds on macOS runners)

### React Native Projects
- Node.js: Latest LTS version
- npm/yarn: Latest stable
- Expo CLI: Latest stable
- EAS CLI: Latest stable (for EAS builds)

## Secrets Management

Both projects should handle secrets consistently:
- API keys in GitHub repository secrets (not environment variables in code)
- Reference `.env.example` files for required environment variables
- Use platform-specific secret injection methods in CI

## Build Artifacts

- **Flutter**: Store APK/AAB artifacts for Android, archive iOS builds
- **React Native**: Store Expo export bundles or EAS build artifacts
- **Retention**: 7 days for CI artifacts, longer for release builds

## Failure Handling

- Any step failure should fail the entire CI run
- Provide clear error messages for debugging
- Retry transient failures (network issues) up to 2 times

## Performance Considerations

- Cache dependencies where possible (Flutter pub cache, npm/yarn cache)
- Use appropriate runner types (ubuntu-latest for most steps, macos-latest for iOS builds)
- Parallelize independent steps when possible

## Validation Checklist

Before considering CI setup complete:
- [ ] All required steps execute successfully
- [ ] Build artifacts are generated correctly
- [ ] CI runs complete in reasonable time (< 10 minutes for basic builds)
- [ ] Error messages are clear and actionable
- [ ] Secrets are properly configured and not exposed in logs 