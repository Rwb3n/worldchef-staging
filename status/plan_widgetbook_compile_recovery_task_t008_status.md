# Task Status: t008 - Replace options knob usages

**Plan ID**: `widgetbook_compile_recovery`
**Task ID**: `t008`
**Type**: IMPLEMENTATION
**Status**: ✅ **DONE**

---

## 🎯 **Objective**
Replace all `context.knobs.options` calls with `context.knobs.list` per Widgetbook 3 migration guide.

## 📝 **Notes**
- Updated `mobile/lib/widgetbook/screens/home_feed_stories.dart`:
  - Replaced two occurrences of `context.knobs.options` with `context.knobs.list`.
  - Converted parameter `initialOption` → `initialValue` to match new API.
- Verified no remaining `knobs.options` references via project-wide grep.
- All lint tests for deprecated knob API should now pass.
- Proceed to **t009** (create failing compile stub for `featured_recipe_card_stories.dart`). 