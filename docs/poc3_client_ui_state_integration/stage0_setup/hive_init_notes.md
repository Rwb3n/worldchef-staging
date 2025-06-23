# Hive Initialization Notes (Stage 0)

Use this document to record design decisions and implementation details for Hive setup.

## Requirements Checklist
- [x] Decide on Hive boxes and their keys (selected: `ui_prefs` for theme & onboarding flags)
- [x] Determine encryption needs — None for non-sensitive UI prefs (documented below)
- [x] Add `Hive.initFlutter()` call and box openings in `main()` before `runApp`
- [ ] Register adapters if necessary (e.g., for complex objects)
- [ ] Persist sample value and verify retrieval (include code snippet)

## Code Snippet Template
```dart
WidgetsFlutterBinding.ensureInitialized();
await Hive.initFlutter();
await Hive.openBox('ui_prefs'); // persistent UI prefs
```

## Encryption Decision
UI preference data (themeMode, onboardingComplete flag) is non-sensitive; encryption is unnecessary and would add unneeded overhead. If future requirements introduce PII, switch to `HiveAesCipher` with 256-bit key stored in secure storage.

## Migration & Versioning Strategy
Describe how to handle future schema changes, e.g., using box.clear() or data migrations.

---
*Template generated: 2025-06-13*