/* ANNOTATION_BLOCK_START
{
  "artifact_id": "flutter_recipe_models_manual",
  "version_tag": "1.0.0-manual",
  "g_created": 13,
  "g_last_modified": 13,
  "description": "Temporary manual implementation of Recipe JSON serialization for integration testing while build_runner code generation is resolved due to console encoding issues.",
  "artifact_type": "CODE_MODULE",
  "status_in_lifecycle": "DEVELOPMENT",
  "purpose_statement": "Provides manual JSON serialization as a temporary workaround to enable Task F002 integration testing while build_runner console issues are resolved.",
  "key_logic_points": [
    "Manual fromJson/toJson implementation matching expected generated code",
    "Identical API to the json_serializable version for seamless replacement",
    "Comprehensive error handling for JSON parsing edge cases",
    "All UI helper methods and features from the main Recipe model",
    "Drop-in replacement for generated Recipe class"
  ],
  "interfaces_provided": [
    {
      "name": "Recipe (Manual)",
      "interface_type": "DATA_MODEL",
      "details": "Manual implementation of Recipe class with identical API to generated version",
      "notes": "Temporary solution for console encoding workaround - will be replaced by generated code"
    }
  ],
  "requisites": [],
  "external_dependencies": [],
  "internal_dependencies": [],
  "dependents": ["flutter_api_service"],
  "linked_issue_ids": [],
  "quality_notes": {
    "unit_tests": "PENDING - Will use same tests as generated version",
    "manual_review_comment": "Temporary manual implementation to bypass build_runner console issues. Functionally identical to generated code."
  }
}
ANNOTATION_BLOCK_END */

/// Manual implementation of Recipe models for integration testing
/// This is a temporary workaround while build_runner code generation is resolved

/// Represents a recipe with all metadata and content information.
/// Manual implementation matching the json_serializable generated code.
class Recipe {
  /// Unique identifier for the recipe
  final int id;
  
  /// Schema version for API compatibility
  final int schemaVersion;
  
  /// Recipe title/name
  final String title;
  
  /// Detailed description of the recipe
  final String description;
  
  /// Cooking time in minutes
  final int cookTime;
  
  /// Preparation time in minutes  
  final int prepTime;
  
  /// Number of servings this recipe produces
  final int servings;
  
  /// Difficulty level (Easy, Medium, Hard)
  final String difficulty;
  
  /// Recipe category (Italian, Asian, Desserts, etc.)
  final String category;
  
  /// List of ingredients required
  final List<String> ingredients;
  
  /// URL to the recipe image
  final String imageUrl;
  
  /// Average rating (0.0 to 5.0)
  final double rating;
  
  /// Number of user reviews
  final int reviewCount;
  
  /// When the recipe was created (ISO 8601 format)
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

  /// Creates a Recipe from JSON map (manual implementation)
  factory Recipe.fromJson(Map<String, dynamic> json) {
    try {
      return Recipe(
        id: json['id'] as int,
        schemaVersion: json['schema_version'] as int,
        title: json['title'] as String,
        description: json['description'] as String,
        cookTime: json['cookTime'] as int,
        prepTime: json['prepTime'] as int,
        servings: json['servings'] as int,
        difficulty: json['difficulty'] as String,
        category: json['category'] as String,
        ingredients: (json['ingredients'] as List<dynamic>).cast<String>(),
        imageUrl: json['imageUrl'] as String,
        rating: (json['rating'] as num).toDouble(),
        reviewCount: json['reviewCount'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
    } catch (e) {
      throw FormatException('Failed to parse Recipe from JSON: $e');
    }
  }

  /// Converts Recipe to JSON map (manual implementation)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'schema_version': schemaVersion,
      'title': title,
      'description': description,
      'cookTime': cookTime,
      'prepTime': prepTime,
      'servings': servings,
      'difficulty': difficulty,
      'category': category,
      'ingredients': ingredients,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Creates a copy of this recipe with modified fields
  Recipe copyWith({
    int? id,
    int? schemaVersion,
    String? title,
    String? description,
    int? cookTime,
    int? prepTime,
    int? servings,
    String? difficulty,
    String? category,
    List<String>? ingredients,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      title: title ?? this.title,
      description: description ?? this.description,
      cookTime: cookTime ?? this.cookTime,
      prepTime: prepTime ?? this.prepTime,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      ingredients: ingredients ?? this.ingredients,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // UI Helper Methods (identical to main implementation)

  /// Total time for the recipe (prep + cook time)
  int get totalTime => prepTime + cookTime;

  /// Formatted total time string for UI display
  String get totalTimeFormatted {
    if (totalTime < 60) {
      return '${totalTime}m';
    } else {
      final hours = totalTime ~/ 60;
      final minutes = totalTime % 60;
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
  }

  /// Formatted rating for UI display (e.g., "4.7")
  String get ratingFormatted => rating.toStringAsFixed(1);

  /// Formatted review count for UI display (e.g., "1.2k", "1245")
  String get reviewCountFormatted {
    if (reviewCount >= 1000) {
      final k = reviewCount / 1000;
      return '${k.toStringAsFixed(1)}k';
    }
    return reviewCount.toString();
  }

  /// Whether this is a quick recipe (total time <= 30 minutes)
  bool get isQuickRecipe => totalTime <= 30;

  /// Difficulty level for UI styling
  RecipeDifficulty get difficultyLevel {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return RecipeDifficulty.easy;
      case 'medium':
        return RecipeDifficulty.medium;
      case 'hard':
        return RecipeDifficulty.hard;
      default:
        return RecipeDifficulty.medium;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Recipe &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          schemaVersion == other.schemaVersion;

  @override
  int get hashCode => id.hashCode ^ schemaVersion.hashCode;

  @override
  String toString() {
    return 'Recipe{id: $id, title: $title, rating: $rating, totalTime: ${totalTimeFormatted}}';
  }
}

/// Enum for recipe difficulty levels with UI-friendly properties
enum RecipeDifficulty {
  easy('Easy'),
  medium('Medium'), 
  hard('Hard');

  const RecipeDifficulty(this.displayName);
  
  final String displayName;
}

// API Response Models (Manual Implementation)

/// Wrapper for recipe list API responses
class RecipeListResponse {
  final List<Recipe> recipes;

  const RecipeListResponse({required this.recipes});

  factory RecipeListResponse.fromJson(Map<String, dynamic> json) {
    try {
      return RecipeListResponse(
        recipes: (json['recipes'] as List<dynamic>)
            .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      throw FormatException('Failed to parse RecipeListResponse from JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'recipes': recipes.map((recipe) => recipe.toJson()).toList(),
    };
  }

  /// Total number of recipes in this response
  int get count => recipes.length;

  /// Whether the response contains any recipes
  bool get isEmpty => recipes.isEmpty;
  bool get isNotEmpty => recipes.isNotEmpty;
}

/// Wrapper for single recipe API responses  
class RecipeDetailResponse {
  final Recipe recipe;

  const RecipeDetailResponse({required this.recipe});

  factory RecipeDetailResponse.fromJson(Map<String, dynamic> json) {
    try {
      return RecipeDetailResponse(
        recipe: Recipe.fromJson(json),
      );
    } catch (e) {
      throw FormatException('Failed to parse RecipeDetailResponse from JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return recipe.toJson();
  }
} 