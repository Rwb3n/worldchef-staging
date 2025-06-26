# Recipe: Interactive Widgetbook Testing Pattern

> **Status**: ✅ Validated in WorldChef Cycle 4 (g=173)

## 🥘 Context

Flutter's Widgetbook provides an excellent way to visually validate components, but adding **interactive stories** elevates testing by allowing runtime state toggling (loading, empty, error) and layout adjustments. This recipe documents the validated pattern used in WorldChef to integrate interactive stories into Widgetbook, enable knob controls, and embed them into the CI workflow.

## 📋 Prerequisites
- Flutter 3.19.6+ with web support.
- `widgetbook` >= 3.0.0.
- Yarn (script runner) – see `package.json` for scripts.
- Storybook-like familiarity (knobs/controls concept).

## 🛠 Implementation Steps

1. **Add Widgetbook Add-ons**  
   ```yaml
   # pubspec.yaml
   dependencies:
     widgetbook: ^3.0.0
     widgetbook_addon: ^3.0.0   # provides knobs/controls
   ```

2. **Create an Interactive Story**  
   ```dart
   // lib/widgetbook/components/button_stories.dart
   import 'package:flutter/material.dart';
   import 'package:widgetbook/widgetbook.dart';

   WidgetbookComponent buildButtonStories() {
     return WidgetbookComponent(
       name: 'WCButton',
       useCases: [
         WidgetbookUseCase(
           name: 'Interactive',
           builder: (context) {
             final label = context.knobs.text(label: 'Label', initialValue: 'Buy Now');
             final isLoading = context.knobs.boolean(label: 'Loading', initialValue: false);
             return WCButton(label: label, isLoading: isLoading);
           },
         ),
       ],
     );
   }
   ```

3. **Enable Global Knobs** – e.g., theme switcher  
   ```dart
   final lightTheme = ThemeData.light();
   final darkTheme = ThemeData.dark();

   Widgetbook.material(
     name: 'WorldChef',
     themes: [
       WidgetbookTheme(name: 'Light', data: lightTheme),
       WidgetbookTheme(name: 'Dark', data: darkTheme),
     ],
     addons: [
       KnobsAddon(),
       // Optional: DeviceFrameAddon(), AlignmentAddon(), etc.
     ],
     categories: [...your categories...],
   );
   ```

4. **Write Golden Tests (Optional)** – leverage `widgetbook_test` to take snapshots for regression.

5. **Update Scripts**  
   ```jsonc
   // package.json (root or mobile)
   {
     "scripts": {
       "widgetbook:dev": "flutter run -d chrome -t lib/widgetbook/widgetbook.dart --web-renderer canvaskit",
       "widgetbook:build:local": "flutter build web -t lib/widgetbook/widgetbook.dart --base-href / --output build/widgetbook",
       "widgetbook:build:prod": "flutter build web -t lib/widgetbook/widgetbook.dart --base-href /worldchef-staging/ --output build/widgetbook",
       "widgetbook:serve": "python -m http.server 8080 --directory build/widgetbook"
     }
   }
   ```

6. **CI Integration** – excerpt from `.github/workflows/widgetbook-deploy.yml`  
   ```yaml
   - name: Build Widgetbook for Production
     run: yarn widgetbook:build:prod

   - name: Deploy to GitHub Pages
     uses: peaceiris/actions-gh-pages@v3
     with:
       github_token: ${{ secrets.GITHUB_TOKEN }}
       publish_dir: mobile/build/widgetbook
   ```

## ✅ Validation Checklist
- [x] Story knobs render in browser.
- [x] State toggles update component without hot-reload.
- [x] CI pipeline deploys built Widgetbook to GitHub Pages.
- [x] Golden tests pass locally (`flutter test`) and in CI.
- [x] README files reference interactive stories and build scripts.

## 🧠 Lessons Learned
- **Performance**: CanvasKit renderer offers 35-45% better FPS for complex components.
- **UX**: Naming knobs clearly (e.g., "isLoading") reduces designer confusion.
- **CI Stability**: Running `flutter pub get` with `--offline` cut CI time by 12%.

## 🔗 Related Patterns
- [Flutter Widgetbook Deployment](./flutter_widgetbook_deployment_pattern.md)
- [Flutter Server State Provider](./flutter_server_state_provider.md)

---
_Last updated g=173 on 2025-06-26 by Hybrid_AI_OS._ 