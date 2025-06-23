# Cookbook: Flutter Form Validation

**Pattern:** `Form` widget with Riverpod for State Management
**Validated in:** PoC #3 (Implicitly)

This is the canonical pattern for handling user input, like in Recipe Creation.

### 1. State Management (Riverpod)

Create a Notifier to hold the form state and handle submission.

```dart
// lib/providers/recipe_form_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeFormData {
  // fields for your recipe form...
  String title = '';
  bool isLoading = false;
  String? errorMessage;
}

class RecipeFormNotifier extends StateNotifier<RecipeFormData> {
  RecipeFormNotifier() : super(RecipeFormData());

  void updateTitle(String newTitle) {
    state = state..title = newTitle;
    // No need to call notifyListeners, StateNotifier handles it
  }

  Future<bool> submitForm() async {
    state = state..isLoading = true;
    // ...
    try {
      // await apiService.createRecipe(state);
      state = state..isLoading = false..errorMessage = null;
      return true;
    } catch (e) {
      state = state..isLoading = false..errorMessage = e.toString();
      return false;
    }
  }
}

final recipeFormProvider = StateNotifierProvider<RecipeFormNotifier, RecipeFormData>((ref) {
  return RecipeFormNotifier();
});
```
### 2. UI: The Form Widget
Use a Form widget with TextFormField and a GlobalKey to manage validation.
```dart
// lib/screens/create_recipe_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRecipeScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(recipeFormProvider);
    final formNotifier = ref.read(recipeFormProvider.notifier);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Recipe Title'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
            onChanged: (value) => formNotifier.updateTitle(value),
          ),
          // ... other form fields

          ElevatedButton(
            onPressed: formState.isLoading ? null : () {
              if (_formKey.currentState!.validate()) {
                formNotifier.submitForm();
              }
            },
            child: formState.isLoading
                ? CircularProgressIndicator()
                : Text('Create Recipe'),
          ),
        ],
      ),
    );
  }
}
``` 