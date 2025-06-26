# Task Status: t012 - MaterialState color fixes

**Plan ID**: `widgetbook_compile_recovery`
**Task ID**: `t012`
**Type**: IMPLEMENTATION
**Status**: ✅ **DONE**

---

## 🎯 **Objective**
Update `wc_button.dart` to use `MaterialStateProperty` for color-related parameters to comply with Flutter 3.20 API changes.

## 📝 **Actions Taken**
1. Converted constant `Color` arguments to `MaterialStateProperty.all<Color>(…)` where required:
   • `foregroundColor` in Filled, Outlined, FilledTonal variants.
   • `backgroundColor` in FilledTonal variant.
2. Existing helper `_materialStateColor` already returns `MaterialStateProperty`; left intact.
3. Ensured no direct `Color` assignments remain that violate new API requirements.

Next step per plan: **t013** – run `yarn widgetbook:build:local` for full compile validation. 