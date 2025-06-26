# Task Status: t010 - Refactor featured recipe stories API

**Plan ID**: `widgetbook_compile_recovery`
**Task ID**: `t010`
**Type**: IMPLEMENTATION
**Status**: ✅ **DONE**

---

## 🎯 **Objective**
Refactor `featured_recipe_card_stories.dart` to `buildFeaturedRecipeCardStories()` returning `List<WidgetbookComponent>` and update `widgetbook.dart` call site.

## 📝 **Notes**
- Updated `featured_recipe_card_stories.dart`:
  - Renamed function and removed `BuildContext` param.
  - Wrapped original `WidgetbookComponent` inside a list.
  - Fixed knob `initialOption` parameters → `initialValue`.
- Updated `widgetbook.dart` call site using spread operator to inject new list.
- This completes the GREEN step; associated lint test from t009 should now pass. 