# Pattern: Flutter Analyzer Dependency Resolution for Widgetbook and Dev Tools

**ID**: `WCF-PTN-034`  
**Status**: ✅ **VALIDATED**  
**Version**: 1.0  
**Created**: 2025-06-25  
**Last Updated**: 2025-06-25  
**Global Event**: 135  

---

## 1. **Context**

You are developing a Flutter application with Widgetbook for design system documentation. The CI/CD pipeline fails at the `flutter analyze` step with `depend_on_referenced_packages` errors, even though the packages are listed in `pubspec.yaml`.

## 2. **Problem**

Flutter analyzer reports errors like:
```
info • The imported package 'widgetbook' isn't a dependency of the importing package • 
lib/widgetbook/components/button_stories.dart:2:8 • depend_on_referenced_packages
```

This occurs when packages are placed in `dev_dependencies` but imported in files under `lib/`, which requires them to be in `dependencies`.

## 3. **Root Cause Analysis**

The Flutter/Dart analyzer enforces a strict separation:
- **`dependencies`**: Packages that can be imported by files in `lib/` (production code)
- **`dev_dependencies`**: Packages only available during development (tests, build tools, etc.)

**Common Misconception**: Widgetbook is often placed in `dev_dependencies` because it's seen as a "development tool", but when story files are in `lib/widgetbook/`, they become part of the production code structure.

## 4. **Solution: Dependency Classification Strategy**

### 4.1. **Decision Matrix**

| Package Type | Location of Import | Correct Section |
|-------------|-------------------|-----------------|
| Widgetbook stories | `lib/widgetbook/**/*.dart` | `dependencies` |
| Test utilities | `test/**/*.dart` | `dev_dependencies` |
| Build tools (build_runner) | CLI/scripts only | `dev_dependencies` |
| Linting tools (flutter_lints) | Analysis only | `dev_dependencies` |

### 4.2. **Implementation Steps**

1. **Identify Misplaced Dependencies**
   ```bash
   # Run analyzer to identify the errors
   flutter analyze --no-congratulate
   ```

2. **Move Packages to Correct Section**
   ```yaml
   # pubspec.yaml - BEFORE (incorrect)
   dependencies:
     flutter:
       sdk: flutter
     riverpod: ^2.4.0
   
   dev_dependencies:
     flutter_test:
       sdk: flutter
     flutter_lints: ^3.0.0
     widgetbook: ^3.8.0              # ❌ Wrong section
     widgetbook_annotation: ^3.1.0   # ❌ Wrong section
     build_runner: ^2.4.6
   ```

   ```yaml
   # pubspec.yaml - AFTER (correct)
   dependencies:
     flutter:
       sdk: flutter
     riverpod: ^2.4.0
     widgetbook: ^3.8.0              # ✅ Moved to dependencies
     widgetbook_annotation: ^3.1.0   # ✅ Moved to dependencies
   
   dev_dependencies:
     flutter_test:
       sdk: flutter
     flutter_lints: ^3.0.0
     build_runner: ^2.4.6            # ✅ Stays in dev_dependencies
   ```

3. **Update Dependencies**
   ```bash
   flutter pub get
   ```

4. **Apply Automatic Linter Fixes**
   ```bash
   # Apply auto-fixable linting issues
   dart fix --apply
   ```

5. **Verify Resolution**
   ```bash
   flutter analyze --no-congratulate
   ```

## 5. **TDD Approach for Dependency Issues**

### 5.1. **Red Phase - Confirm Failure**
```bash
# Verify the analyzer fails with dependency errors
flutter analyze --no-congratulate
# Expected: Multiple depend_on_referenced_packages errors
```

### 5.2. **Green Phase - Fix Dependencies**
```bash
# Move packages to correct section in pubspec.yaml
# Run: flutter pub get
# Verify: Dependency errors eliminated
```

### 5.3. **Refactor Phase - Clean Up**
```bash
# Apply automatic linter fixes
dart fix --apply
# Verify: All auto-fixable issues resolved
```

## 6. **Common Patterns and Edge Cases**

### 6.1. **Widgetbook Specific**
- **Story files in `lib/widgetbook/`**: Require `widgetbook` in `dependencies`
- **Annotation usage**: Require `widgetbook_annotation` in `dependencies`
- **Build generation**: `build_runner` stays in `dev_dependencies`

### 6.2. **Test-Related Packages**
```yaml
dependencies:
  # Production packages only
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mockito: ^5.4.0           # ✅ Test-only
  build_runner: ^2.4.6      # ✅ Build-only
```

### 6.3. **Linting and Analysis**
```yaml
dev_dependencies:
  flutter_lints: ^3.0.0     # ✅ Analysis-only
  riverpod_lint: ^2.0.0     # ✅ Analysis-only
```

## 7. **CI/CD Integration**

### 7.1. **GitHub Actions Workflow**
```yaml
- name: Analyze code
  run: flutter analyze --fatal-infos
  working-directory: mobile
```

The `--fatal-infos` flag treats info-level warnings as errors, enforcing strict compliance.

### 7.2. **Pre-commit Hooks**
```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: flutter-analyze
        name: Flutter Analyze
        entry: flutter analyze --fatal-infos
        language: system
        files: \.dart$
```

## 8. **Troubleshooting Guide**

### 8.1. **Issue**: Analyzer still fails after moving dependencies
**Solution**: Clear pub cache and reinstall
```bash
flutter pub cache clean
flutter pub get
```

### 8.2. **Issue**: Auto-fixes don't resolve all warnings
**Solution**: Some deprecation warnings require manual fixes
```bash
# Example: withOpacity → withValues
color.withOpacity(0.5)     # ❌ Deprecated
color.withValues(alpha: 0.5)  # ✅ New API
```

### 8.3. **Issue**: Package bloat in production
**Solution**: Consider conditional imports or separate build targets
```dart
// Conditional import pattern
import 'widgetbook_stories.dart' if (dart.library.js) 'widgetbook_web.dart';
```

+### 8.4. **Issue**: CI build fails with compilation errors despite analyzer passing
+**Symptoms**: Local `flutter analyze` and `flutter build web` succeed, but CI fails with compilation errors like:
+```
+Error: The getter 'globalPosition' isn't defined for the class 'DragEndDetails'
+Target dart2js failed: ProcessException: Process exited abnormally with exit code 1
+```
+
+**Root Cause**: Version mismatch between local and CI environments due to loose version constraints.
+
+**Solution**: Tighten version constraints to ensure consistent dependency resolution
+```yaml
+# BEFORE (problematic)
+dependencies:
+  widgetbook: ^3.8.0  # ❌ Too loose - allows incompatible versions
+
+# AFTER (fixed)
+dependencies:
+  widgetbook: ^3.14.0  # ✅ Forces compatible minimum version
+```
+
+**Diagnosis Steps**:
+1. Check local version: `flutter pub deps | grep package_name`
+2. Compare with CI error logs to identify version differences
+3. Update constraint to match working local version
+4. Test with fresh `flutter pub get` to verify resolution
+
## 9. **Validation Results**

### 9.1. **WorldChef Project Metrics**
- **Before Fix**: 122 analyzer issues (including 10+ `depend_on_referenced_packages` errors)
- **After Fix**: 17 info-level deprecation warnings only
- **CI Impact**: ✅ `flutter analyze` step now passes
- **Build Time**: No significant impact on build performance

### 9.2. **Version Compatibility Fix (2025-06-25)**
- **Issue**: CI `flutter build web` failing with `accessibility_tools globalPosition` error
- **Root Cause**: `widgetbook: ^3.8.0` allowed CI to resolve to incompatible version
- **Solution**: Updated to `widgetbook: ^3.14.0` ensuring compatible `accessibility_tools 2.6.0+`
- **Result**: ✅ CI build now succeeds, local/CI version consistency achieved

### 9.3. **Automated Fixes Applied**
```bash
# dart fix --apply results
lib\main.dart
  unused_element_parameter • 1 fix

lib\widgetbook\components\button_stories.dart
  use_super_parameters • 7 fixes

lib\widgetbook\components\input_stories.dart
  prefer_const_constructors • 1 fix
  use_super_parameters • 6 fixes

# Total: 68 fixes made in 10 files
```

## 10. **Best Practices**

### 10.1. **Dependency Hygiene**
- ✅ Review `pubspec.yaml` during code reviews
- ✅ Use `flutter pub deps` to understand dependency tree
- ✅ Regularly audit with `flutter pub outdated`

### 10.2. **Version Management**
- ✅ Pin to specific minimum versions that work (avoid overly loose constraints)
- ✅ Test with fresh `flutter pub get` to verify CI-like dependency resolution
- ✅ Monitor for transitive dependency conflicts in CI logs
- ✅ Update version constraints when upgrading Flutter SDK

### 10.3. **CI/CD Standards**
- ✅ Enforce `flutter analyze --fatal-infos` in CI
- ✅ Include `dart fix --dry-run` in pre-commit checks
- ✅ Monitor analyzer performance in CI metrics

### 10.4. **Development Workflow**
- ✅ Run `flutter analyze` before committing
- ✅ Apply `dart fix --apply` for automatic improvements
- ✅ Address deprecation warnings proactively

---

**Status**: ✅ **VALIDATED** in WorldChef project (2025-06-25)  
**Impact**: Resolved CI/CD pipeline failures and improved code quality standards  
**Next Steps**: Monitor for new analyzer rules and dependency patterns