# Cookbook: Widgetbook-Driven Development (WDD)

**Status**: ✅ **Active**  
**Maintainer**: AI_OS  
**Last Updated**: 2025-06-26

---

## 1. Principle

To ensure our UI remains consistent, well-documented, and easy to test, all UI component development in the WorldChef mobile app **must** be driven by its Widgetbook story.

**You cannot merge a new component without a corresponding story.** This is enforced automatically by a CI test.

## 2. The Workflow

The process is simple: build the component and its interactive documentation (the story) at the same time.

### Step 1: Create the Component File

Create your new component widget in the appropriate directory under `mobile/lib/src/ui/`.

**Example:**
```
mobile/lib/src/ui/atoms/wc_new_button.dart
```

### Step 2: Create the Story File

Immediately create a corresponding story file in `mobile/lib/widgetbook/components/`.

**Example:**
```
mobile/lib/widgetbook/components/new_button_stories.dart
```

### Step 3: Write the Story First (The "Test")

Before perfecting your component's logic, write its Widgetbook story. This story should act as your "test case." Use `context.knobs` to add interactive controls for every `prop` your component will have.

This forces you to think about the component's API and all of its states (`isLoading`, `hasError`, `isSelected`, etc.) from the very beginning.

```dart
// new_button_stories.dart
import 'package:widgetbook/widgetbook.dart';
import 'package:worldchef_mobile/src/ui/atoms/wc_new_button.dart';

WidgetbookComponent buildNewButtonStories() {
  return WidgetbookComponent(
    name: 'WCNewButton',
    useCases: [
      WidgetbookUseCase(
        name: 'Default',
        builder: (context) {
          final text = context.knobs.text(label: 'Label', initialValue: 'Click Me');
          final isEnabled = context.knobs.boolean(label: 'Enabled', initialValue: true);

          return WCNewButton(
            label: text,
            onPressed: isEnabled ? () {} : null,
          );
        },
      ),
    ],
  );
}
```

### Step 4: Implement the Component

Now, with the story acting as a live preview, implement your component's logic in its `.dart` file until it behaves correctly in the Widgetbook preview.

### Step 5: Integrate the Story

Add your new story to `mobile/lib/widgetbook/widgetbook.dart` so it appears in the catalog.

## 3. Automated Enforcement

A test located at `backend/__tests__/lint/widgetbook_coverage.test.ts` runs on every pull request.

- **What it does**: It gets a list of all `.dart` files in `mobile/lib/src/ui/` and a list of all `_stories.dart` files in `mobile/lib/widgetbook/components/`.
- **How it works**: It checks that for every component, a story file with a matching name exists.
- **What happens on failure**: If you create `wc_another_thing.dart` but forget to create `another_thing_stories.dart`, the test will fail, and your PR will be blocked.

This guarantees that our visual documentation never goes stale. 