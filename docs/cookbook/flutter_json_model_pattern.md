# Flutter JSON Model Pattern

## Overview

This cookbook entry documents the validated JSON model pattern from WorldChef PoC #1, providing type-safe data models with automatic serialization/deserialization.

**Validation**: 100% serialization success rate, efficient JSON parsing with minimal overhead.

## Core Implementation

### Model with JSON Annotations

```dart
import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

@JsonSerializable(explicitToJson: true)
class Recipe {
  final int id;
  
  @JsonKey(name: 'schema_version')
  final int schemaVersion;
  
  final String title;
  final String description;
  final int cookTime;
  final int prepTime;
  final int servings;
  final String difficulty;
  final String category;
  final List<String> ingredients;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;

  const Recipe({
    required this.id,
    required this.schemaVersion,
    required this.title,
    required this.description,
    required this.cookTime,
    required this.prepTime,
    required this.servings,
    required this.difficulty,
    required this.category,
    required this.ingredients,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.createdAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeToJson(this);

  // Copy semantics for immutable updates
  Recipe copyWith({
    int? id,
    String? title,
    // ... other fields
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      // ... other fields
    );
  }
}
```

### UI Helper Methods

Add computed properties for display logic:

```dart
class Recipe {
  // ... existing fields ...

  /// Total time (prep + cook)
  int get totalTime => prepTime + cookTime;

  /// Formatted time string
  String get totalTimeFormatted {
    if (totalTime < 60) return '${totalTime}m';
    final hours = totalTime ~/ 60;
    final minutes = totalTime % 60;
    return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
  }

  /// Formatted rating
  String get ratingFormatted => rating.toStringAsFixed(1);

  /// Quick recipe indicator
  bool get isQuickRecipe => totalTime <= 30;
}
```

## Code Generation Setup

### Dependencies

```yaml
# pubspec.yaml
dependencies:
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.7
  json_serializable: ^6.7.1
```

### Generate Code

```bash
# Generate serialization code
dart run build_runner build

# Watch for changes
dart run build_runner watch
```

## Usage Examples

### API Integration

```dart
// Parse API response
final response = await http.get(Uri.parse('$baseUrl/recipes'));
final jsonData = jsonDecode(response.body);

final recipes = (jsonData['recipes'] as List)
    .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
    .toList();
```

### Local Storage

```dart
// Save to preferences
final recipe = Recipe(/* ... */);
final jsonString = jsonEncode(recipe.toJson());
await prefs.setString('cached_recipe', jsonString);

// Load from preferences  
final jsonString = prefs.getString('cached_recipe');
final recipe = Recipe.fromJson(jsonDecode(jsonString!));
```

### State Management Integration

```dart
// Riverpod provider
final recipeProvider = StateNotifierProvider<RecipeNotifier, List<Recipe>>((ref) {
  return RecipeNotifier();
});

class RecipeNotifier extends StateNotifier<List<Recipe>> {
  RecipeNotifier() : super([]);

  void updateRecipe(Recipe updatedRecipe) {
    state = state.map((recipe) {
      return recipe.id == updatedRecipe.id ? updatedRecipe : recipe;
    }).toList();
  }
}
```

## Advanced Patterns

### Nested Models

```dart
@JsonSerializable(explicitToJson: true)
class RecipeNutrition {
  final int calories;
  final double protein;
  
  const RecipeNutrition({required this.calories, required this.protein});
  
  factory RecipeNutrition.fromJson(Map<String, dynamic> json) => 
      _$RecipeNutritionFromJson(json);
  Map<String, dynamic> toJson() => _$RecipeNutritionToJson(this);
}

// Add to Recipe model
class Recipe {
  // ... existing fields ...
  final RecipeNutrition? nutrition;
}
```

### Custom Serialization

```dart
@JsonSerializable(explicitToJson: true)
class Recipe {
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  
  static DateTime _dateTimeFromJson(String json) => DateTime.parse(json);
  static String _dateTimeToJson(DateTime dateTime) => dateTime.toIso8601String();
}
```

## Testing Strategy

```dart
void main() {
  group('Recipe Model Tests', () {
    test('should serialize correctly', () {
      final recipe = Recipe(/* test data */);
      final json = recipe.toJson();
      
      expect(json['id'], equals(1));
      expect(json['title'], equals('Test Recipe'));
    });

    test('should deserialize correctly', () {
      final json = {
        'id': 1,
        'schema_version': 1,
        'title': 'Test Recipe',
        // ... other fields
      };

      final recipe = Recipe.fromJson(json);
      expect(recipe.id, equals(1));
      expect(recipe.totalTime, equals(45));
    });
  });
}
```

## Key Implementation Notes

### Critical Success Factors

1. **Immutability**: All fields final, use copyWith for updates
2. **Type Safety**: Strong typing prevents runtime errors  
3. **Code Generation**: Reduces boilerplate and errors
4. **UI Helpers**: Computed properties for display logic
5. **Validation**: Handle malformed API responses

### AI Development Considerations

- Use exact JSON structure from API/mock data
- Include all fields that might be added later
- Provide UI helpers to reduce logic in components
- Add validation for data integrity
- Use enums for categorical data

## Production Checklist

- [ ] Generate JSON code (`dart run build_runner build`)
- [ ] Verify fields match API contract
- [ ] Test with real API data
- [ ] Add error handling for malformed JSON
- [ ] Implement comprehensive unit tests
- [ ] Validate performance with large datasets
- [ ] Test copyWith functionality

## References

- **Source**: `worldchef_poc_flutter/lib/models/recipe.dart`
- **Mock Data**: `worldchef_poc_mock_server/data/recipes.json`
- **Validation**: PoC #1 Flutter implementation 