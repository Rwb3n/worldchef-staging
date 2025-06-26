# worldchef_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Widgetbook - Design System

WorldChef uses [Widgetbook](https://widgetbook.io/) to catalogue and test all atoms, molecules, organisms, and screens.

```bash
# Build and serve Widgetbook locally (hot-reload)
yarn widgetbook:dev  # http://localhost:8080

# One-shot local build (no base-href)
yarn widgetbook:build:local

# Production build (base-href "/worldchef-staging/")
yarn widgetbook:build:prod
```

The stories live under `mobile/lib/widgetbook/`. Follow the **Widgetbook 3 Knob Migration Pattern** in `docs/cookbook/widgetbook_knob_migration_pattern.md` for adding new interactive knobs.
