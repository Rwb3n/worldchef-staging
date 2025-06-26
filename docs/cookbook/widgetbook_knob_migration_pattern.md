# Widgetbook 3 Knob Migration Pattern

**Status**: ✅ Validated in WorldChef Cycle 4 (June 2025)

## Problem
Widgetbook ≤ 2 used `context.knobs.options` for list-like selections. Widgetbook 3 replaces this with `context.knobs.list` and changes the default parameter name from `initialOption` → `initialOption` (unchanged!) while deprecating the old API. Projects upgrading were met with compile errors.

Additional breaking changes:
1. Story functions returning a single `WidgetbookComponent` can be grouped into `List<WidgetbookComponent>` helper builders ⇒ improves code-gen support.
2. Backward-compat custom buttons must wrap new API contracts.

## Solution
1. **Search & Replace** all `context.knobs.options(` → `context.knobs.list(`.
2. Keep `initialOption:` parameter (do **not** invent `initialValue:`). IDE autocompletion can mislead.
3. Provide migration lint test:
```dart
// mobile/test/lint/knob_api_migration_test.dart
expect(offenders, isEmpty,
  reason: 'Deprecated knobs.options API found');
```
4. Group big story collections into builders returning `List<WidgetbookComponent>` and use Dart spread operator in `widgetbook.dart`:
```dart
...buildFeaturedRecipeCardStories(),
```
5. When replacing a common component (e.g. Back button), implement the new widget and add a deprecated typedef alias to avoid ripple compile failures during migration:
```dart
typedef WCBackButton = WorldChefBackButton; // temporary shim
```
6. Re-run `yarn widgetbook:build:local` to validate.

## Why This Pattern Works
• Minimises diff footprint by keeping parameter name consistent (initialOption).  
• Typedef shim allows incremental file updates.  
• Lint tests prevent regressions on future merges.

## References
* PR: _plan_widgetbook_compile_recovery_ tasks t007-t014  
* Widgetbook Docs: https://docs.widgetbook.io/knobs/list 