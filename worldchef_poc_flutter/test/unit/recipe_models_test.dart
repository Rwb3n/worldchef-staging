/* ANNOTATION_BLOCK_START
{
  "artifact_id": "flutter_recipe_models_unit_test",
  "version_tag": "1.0.0",
  "g_created": 13,
  "g_last_modified": 13,
  "description": "Unit tests for Recipe data models focusing on JSON serialization/deserialization, data validation, and UI helper methods without external dependencies.",
  "artifact_type": "TEST_CODE",
  "status_in_lifecycle": "DEVELOPMENT",
  "purpose_statement": "Provides comprehensive unit test coverage for Recipe model classes, JSON parsing, error handling, and UI helper functionality with isolated testing approach.",
  "key_logic_points": [
    "Tests JSON serialization and deserialization with various data scenarios",
    "Validates data model immutability and copyWith functionality",
    "Tests UI helper methods (formatting, calculations, enum conversions)",
    "Verifies error handling for malformed JSON and invalid data",
    "Tests equality operators and object behavior",
    "Validates API response wrapper classes functionality"
  ],
  "interfaces_provided": [
    {
      "name": "RecipeModelsTest",
      "interface_type": "UNIT_TEST",
      "details": "Isolated unit tests for Recipe model classes without external dependencies",
      "notes": "Does not require mock server - tests pure model logic and JSON handling"
    }
  ],
  "requisites": [
    { "description": "Recipe model implementations", "type": "INTERNAL_DEPENDENCY" }
  ],
  "external_dependencies": [
    { "name": "flutter_test", "version": "SDK", "reason": "Flutter testing framework for unit tests" }
  ],
  "internal_dependencies": ["flutter_recipe_models_manual"],
  "dependents": [],
  "linked_issue_ids": [],
  "quality_notes": {
    "unit_tests": "This IS the unit test suite for Recipe models",
    "manual_review_comment": "Comprehensive unit test coverage for all Recipe model functionality with isolated testing approach."
  }
}
ANNOTATION_BLOCK_END */

import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/recipe_manual.dart';

void main() {
  // Sample test data - moved to top level for access across all test groups
  final sampleRecipeJson = {
    'id': 1,
    'schema_version': 1,
    'title': 'Test Recipe',
    'description': 'A test recipe for unit testing',
    'cookTime': 25,
    'prepTime': 15,
    'servings': 4,
    'difficulty': 'Medium',
    'category': 'Test',
    'ingredients': ['ingredient1', 'ingredient2', 'ingredient3'],
    'imageUrl': 'https://example.com/test.jpg',
    'rating': 4.5,
    'reviewCount': 100,
    'createdAt': '2024-01-15T10:30:00Z',
  };

  group('Recipe Model Unit Tests', () {

    group('Recipe JSON Serialization', () {
      test('should create Recipe from valid JSON', () {
        final recipe = Recipe.fromJson(sampleRecipeJson);

        expect(recipe.id, equals(1));
        expect(recipe.schemaVersion, equals(1));
        expect(recipe.title, equals('Test Recipe'));
        expect(recipe.description, equals('A test recipe for unit testing'));
        expect(recipe.cookTime, equals(25));
        expect(recipe.prepTime, equals(15));
        expect(recipe.servings, equals(4));
        expect(recipe.difficulty, equals('Medium'));
        expect(recipe.category, equals('Test'));
        expect(recipe.ingredients, equals(['ingredient1', 'ingredient2', 'ingredient3']));
        expect(recipe.imageUrl, equals('https://example.com/test.jpg'));
        expect(recipe.rating, equals(4.5));
        expect(recipe.reviewCount, equals(100));
        expect(recipe.createdAt, equals(DateTime.parse('2024-01-15T10:30:00Z')));
      });

      test('should convert Recipe to JSON correctly', () {
        final recipe = Recipe.fromJson(sampleRecipeJson);
        final json = recipe.toJson();

        expect(json['id'], equals(1));
        expect(json['schema_version'], equals(1));
        expect(json['title'], equals('Test Recipe'));
        expect(json['description'], equals('A test recipe for unit testing'));
        expect(json['cookTime'], equals(25));
        expect(json['prepTime'], equals(15));
        expect(json['servings'], equals(4));
        expect(json['difficulty'], equals('Medium'));
        expect(json['category'], equals('Test'));
        expect(json['ingredients'], equals(['ingredient1', 'ingredient2', 'ingredient3']));
        expect(json['imageUrl'], equals('https://example.com/test.jpg'));
        expect(json['rating'], equals(4.5));
        expect(json['reviewCount'], equals(100));
        expect(json['createdAt'], equals('2024-01-15T10:30:00.000Z'));
      });

      test('should handle round-trip serialization correctly', () {
        final originalRecipe = Recipe.fromJson(sampleRecipeJson);
        final json = originalRecipe.toJson();
        final deserializedRecipe = Recipe.fromJson(json);

        expect(deserializedRecipe, equals(originalRecipe));
        expect(deserializedRecipe.hashCode, equals(originalRecipe.hashCode));
      });

      test('should throw FormatException for invalid JSON', () {
        expect(
          () => Recipe.fromJson({'invalid': 'data'}),
          throwsA(isA<FormatException>()),
        );

        expect(
          () => Recipe.fromJson({'id': 'not_an_int'}),
          throwsA(isA<FormatException>()),
        );

        expect(
          () => Recipe.fromJson({'id': 1, 'rating': 'not_a_number'}),
          throwsA(isA<FormatException>()),
        );
      });

      test('should handle edge cases in JSON parsing', () {
        // Test with minimum valid data
        final minimalJson = Map<String, dynamic>.from(sampleRecipeJson);
        minimalJson['rating'] = 0.0;
        minimalJson['reviewCount'] = 0;
        minimalJson['cookTime'] = 0;
        minimalJson['prepTime'] = 0;

        expect(() => Recipe.fromJson(minimalJson), returnsNormally);

        // Test with maximum values
        final maxJson = Map<String, dynamic>.from(sampleRecipeJson);
        maxJson['rating'] = 5.0;
        maxJson['reviewCount'] = 999999;
        maxJson['cookTime'] = 300;
        maxJson['prepTime'] = 120;

        expect(() => Recipe.fromJson(maxJson), returnsNormally);
      });
    });

    group('Recipe Data Validation', () {
      late Recipe testRecipe;

      setUp(() {
        testRecipe = Recipe.fromJson(sampleRecipeJson);
      });

      test('should validate recipe properties are immutable', () {
        // All properties should be final and cannot be changed after construction
        expect(testRecipe.id, equals(1));
        
        // Test that we need copyWith to modify
        final modifiedRecipe = testRecipe.copyWith(title: 'Modified Title');
        expect(modifiedRecipe.title, equals('Modified Title'));
        expect(testRecipe.title, equals('Test Recipe')); // Original unchanged
      });

      test('should validate required fields are not null', () {
        expect(testRecipe.id, isNotNull);
        expect(testRecipe.title, isNotNull);
        expect(testRecipe.description, isNotNull);
        expect(testRecipe.ingredients, isNotNull);
        expect(testRecipe.createdAt, isNotNull);
      });

      test('should validate data types', () {
        expect(testRecipe.id, isA<int>());
        expect(testRecipe.schemaVersion, isA<int>());
        expect(testRecipe.title, isA<String>());
        expect(testRecipe.description, isA<String>());
        expect(testRecipe.cookTime, isA<int>());
        expect(testRecipe.prepTime, isA<int>());
        expect(testRecipe.servings, isA<int>());
        expect(testRecipe.difficulty, isA<String>());
        expect(testRecipe.category, isA<String>());
        expect(testRecipe.ingredients, isA<List<String>>());
        expect(testRecipe.imageUrl, isA<String>());
        expect(testRecipe.rating, isA<double>());
        expect(testRecipe.reviewCount, isA<int>());
        expect(testRecipe.createdAt, isA<DateTime>());
      });
    });

    group('Recipe UI Helper Methods', () {
      late Recipe testRecipe;

      setUp(() {
        testRecipe = Recipe.fromJson(sampleRecipeJson);
      });

      test('should calculate total time correctly', () {
        expect(testRecipe.totalTime, equals(40)); // 25 + 15
        
        final quickRecipe = testRecipe.copyWith(cookTime: 10, prepTime: 5);
        expect(quickRecipe.totalTime, equals(15));
      });

      test('should format total time correctly', () {
        expect(testRecipe.totalTimeFormatted, equals('40m'));
        
        final longRecipe = testRecipe.copyWith(cookTime: 90, prepTime: 30);
        expect(longRecipe.totalTimeFormatted, equals('2h'));
        
        final mixedRecipe = testRecipe.copyWith(cookTime: 75, prepTime: 30);
        expect(mixedRecipe.totalTimeFormatted, equals('1h 45m'));
      });

      test('should format rating correctly', () {
        expect(testRecipe.ratingFormatted, equals('4.5'));
        
        final perfectRecipe = testRecipe.copyWith(rating: 5.0);
        expect(perfectRecipe.ratingFormatted, equals('5.0'));
        
        final lowRecipe = testRecipe.copyWith(rating: 2.3);
        expect(lowRecipe.ratingFormatted, equals('2.3'));
      });

      test('should format review count correctly', () {
        expect(testRecipe.reviewCountFormatted, equals('100'));
        
        final popularRecipe = testRecipe.copyWith(reviewCount: 1250);
        expect(popularRecipe.reviewCountFormatted, equals('1.3k'));
        
        final veryPopularRecipe = testRecipe.copyWith(reviewCount: 2500);
        expect(veryPopularRecipe.reviewCountFormatted, equals('2.5k'));
        
        final newRecipe = testRecipe.copyWith(reviewCount: 5);
        expect(newRecipe.reviewCountFormatted, equals('5'));
      });

      test('should identify quick recipes correctly', () {
        expect(testRecipe.isQuickRecipe, isFalse); // 40 minutes total
        
        final quickRecipe = testRecipe.copyWith(cookTime: 15, prepTime: 10);
        expect(quickRecipe.isQuickRecipe, isTrue); // 25 minutes total
        
        final exactRecipe = testRecipe.copyWith(cookTime: 20, prepTime: 10);
        expect(exactRecipe.isQuickRecipe, isTrue); // Exactly 30 minutes
      });

      test('should convert difficulty to enum correctly', () {
        expect(testRecipe.difficultyLevel, equals(RecipeDifficulty.medium));
        
        final easyRecipe = testRecipe.copyWith(difficulty: 'Easy');
        expect(easyRecipe.difficultyLevel, equals(RecipeDifficulty.easy));
        
        final hardRecipe = testRecipe.copyWith(difficulty: 'Hard');
        expect(hardRecipe.difficultyLevel, equals(RecipeDifficulty.hard));
        
        final unknownRecipe = testRecipe.copyWith(difficulty: 'Unknown');
        expect(unknownRecipe.difficultyLevel, equals(RecipeDifficulty.medium)); // Default
      });
    });

    group('Recipe Equality and Hash Code', () {
      test('should implement equality correctly', () {
        final recipe1 = Recipe.fromJson(sampleRecipeJson);
        final recipe2 = Recipe.fromJson(sampleRecipeJson);
        final modifiedJson = Map<String, dynamic>.from(sampleRecipeJson);
        modifiedJson['id'] = 2; // Change ID instead of title since equality is based on ID
        final recipe3 = Recipe.fromJson(modifiedJson);

        expect(recipe1, equals(recipe2));
        expect(recipe1, isNot(equals(recipe3)));
        expect(recipe1.hashCode, equals(recipe2.hashCode));
      });

      test('should implement toString correctly', () {
        final recipe = Recipe.fromJson(sampleRecipeJson);
        final toString = recipe.toString();
        
        expect(toString, contains('Recipe{'));
        expect(toString, contains('id: 1'));
        expect(toString, contains('title: Test Recipe'));
        expect(toString, contains('rating: 4.5'));
        expect(toString, contains('40m')); // Total time formatted
      });
    });

    group('Recipe CopyWith Method', () {
      late Recipe originalRecipe;

      setUp(() {
        originalRecipe = Recipe.fromJson(sampleRecipeJson);
      });

      test('should create copy with modified fields', () {
        final modifiedRecipe = originalRecipe.copyWith(
          title: 'Modified Title',
          rating: 3.5,
          cookTime: 30,
        );

        expect(modifiedRecipe.title, equals('Modified Title'));
        expect(modifiedRecipe.rating, equals(3.5));
        expect(modifiedRecipe.cookTime, equals(30));
        
        // Other fields should remain the same
        expect(modifiedRecipe.id, equals(originalRecipe.id));
        expect(modifiedRecipe.description, equals(originalRecipe.description));
        expect(modifiedRecipe.prepTime, equals(originalRecipe.prepTime));
      });

      test('should return identical copy when no changes', () {
        final copiedRecipe = originalRecipe.copyWith();
        
        expect(copiedRecipe, equals(originalRecipe));
        expect(copiedRecipe.hashCode, equals(originalRecipe.hashCode));
      });
    });
  });

  group('RecipeDifficulty Enum Tests', () {
    test('should have correct display names', () {
      expect(RecipeDifficulty.easy.displayName, equals('Easy'));
      expect(RecipeDifficulty.medium.displayName, equals('Medium'));
      expect(RecipeDifficulty.hard.displayName, equals('Hard'));
    });

    test('should have all expected values', () {
      expect(RecipeDifficulty.values, hasLength(3));
      expect(RecipeDifficulty.values, contains(RecipeDifficulty.easy));
      expect(RecipeDifficulty.values, contains(RecipeDifficulty.medium));
      expect(RecipeDifficulty.values, contains(RecipeDifficulty.hard));
    });
  });

  group('API Response Models Tests', () {
    final sampleRecipeListJson = {
      'recipes': [
        sampleRecipeJson,
        {...sampleRecipeJson, 'id': 2, 'title': 'Second Recipe'},
      ]
    };

    group('RecipeListResponse', () {
      test('should parse recipe list JSON correctly', () {
        final response = RecipeListResponse.fromJson(sampleRecipeListJson);
        
        expect(response.recipes, hasLength(2));
        expect(response.count, equals(2));
        expect(response.isNotEmpty, isTrue);
        expect(response.isEmpty, isFalse);
        
        expect(response.recipes[0].id, equals(1));
        expect(response.recipes[1].id, equals(2));
        expect(response.recipes[1].title, equals('Second Recipe'));
      });

      test('should convert to JSON correctly', () {
        final response = RecipeListResponse.fromJson(sampleRecipeListJson);
        final json = response.toJson();
        
        expect(json['recipes'], isA<List>());
        expect(json['recipes'], hasLength(2));
        expect(json['recipes'][0]['id'], equals(1));
        expect(json['recipes'][1]['id'], equals(2));
      });

      test('should handle empty recipe list', () {
        final emptyResponse = RecipeListResponse.fromJson({'recipes': []});
        
        expect(emptyResponse.count, equals(0));
        expect(emptyResponse.isEmpty, isTrue);
        expect(emptyResponse.isNotEmpty, isFalse);
      });

      test('should throw FormatException for invalid JSON', () {
        expect(
          () => RecipeListResponse.fromJson({'invalid': 'data'}),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('RecipeDetailResponse', () {
      test('should parse single recipe JSON correctly', () {
        final response = RecipeDetailResponse.fromJson(sampleRecipeJson);
        
        expect(response.recipe.id, equals(1));
        expect(response.recipe.title, equals('Test Recipe'));
      });

      test('should convert to JSON correctly', () {
        final response = RecipeDetailResponse.fromJson(sampleRecipeJson);
        final json = response.toJson();
        
        expect(json['id'], equals(1));
        expect(json['title'], equals('Test Recipe'));
      });

      test('should throw FormatException for invalid JSON', () {
        expect(
          () => RecipeDetailResponse.fromJson({'invalid': 'data'}),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
} 