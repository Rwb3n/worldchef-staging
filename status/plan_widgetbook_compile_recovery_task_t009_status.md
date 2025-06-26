# Task Status: t009 - Featured recipe stories compile test

**Plan ID**: `widgetbook_compile_recovery`
**Task ID**: `t009`
**Type**: TEST_CREATION
**Status**: ✅ **DONE**

---

## 🎯 **Objective**
Add failing stub test ensuring `featured_recipe_card_stories.dart` exports `List<WidgetbookComponent>` and takes no BuildContext parameter.

## 📝 **Notes**
- Created `mobile/test/lint/featured_recipe_card_stories_signature_test.dart` which:
  - Fails if old signature `Widget featuredRecipeCardStories(BuildContext ...)` is still present.
  - Expects new function `List<WidgetbookComponent> buildFeaturedRecipeCardStories()` exists.
- Test intentionally fails, serving as RED step.
- Proceed to **t010** for implementation refactor to satisfy this test. 