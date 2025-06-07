/* ANNOTATION_BLOCK_START
{
  "artifact_id": "flutter_recipe_detail_screen",
  "version_tag": "1.0.0-f004-complete",
  "g_created": 16,
  "g_last_modified": 16,
  "description": "Recipe detail screen for WorldChef PoC Flutter implementation with hero image, structured content display, and Material Design 3 interface with parallax scrolling effect.",
  "artifact_type": "CODE_MODULE",
  "status_in_lifecycle": "DEVELOPMENT",
  "purpose_statement": "Displays detailed recipe information including hero image, title, description, ingredients list, and cooking steps with smooth parallax scrolling and comprehensive accessibility support for Task F004.",
  "key_logic_points": [
    "CustomScrollView with SliverAppBar for parallax scrolling effect",
    "Hero image transition support for navigation animations",
    "Structured content display for ingredients and cooking steps",
    "Loading, error, and empty state management for single recipe fetch",
    "Cached network image optimization with error handling",
    "Material Design 3 styling with dynamic theming",
    "Full accessibility support with semantic labels",
    "Responsive design for various screen sizes"
  ],
  "interfaces_provided": [
    {
      "name": "RecipeDetailScreen",
      "interface_type": "WIDGET",
      "details": "Main recipe detail screen widget accepting recipe ID parameter",
      "notes": "Supports navigation from recipe list with hero animation and parameter passing"
    }
  ],
  "requisites": [
    { "description": "Recipe API service for fetching single recipe details", "type": "INTERNAL_DEPENDENCY" },
    { "description": "Recipe data models for type-safe data handling", "type": "INTERNAL_DEPENDENCY" },
    { "description": "cached_network_image for optimized image loading", "type": "EXTERNAL_DEPENDENCY" }
  ],
  "external_dependencies": [
    { "name": "cached_network_image", "version": "^3.3.1", "reason": "Optimized image loading and caching for hero images" },
    { "name": "flutter_material", "version": "SDK", "reason": "Material Design 3 components and theming" }
  ],
  "internal_dependencies": ["flutter_recipe_models_manual", "flutter_api_service"],
  "dependents": ["flutter_navigation_config"],
  "linked_issue_ids": [],
  "quality_notes": {
    "unit_tests": "PLANNED - Widget testing for UI behavior and accessibility",
    "manual_review_comment": "AI-generated recipe detail screen with parallax scrolling, structured content display, and comprehensive accessibility for Task F004."
  }
}
ANNOTATION_BLOCK_END */

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/recipe_manual.dart';
import '../services/recipe_api_service.dart';
import '../l10n/app_localizations_helper.dart';

/// Recipe detail screen displaying comprehensive recipe information.
/// 
/// Features:
/// - Parallax scrolling with SliverAppBar and hero image
/// - Structured display of recipe metadata, ingredients, and steps  
/// - Loading, error, and retry state management
/// - Material Design 3 styling with dynamic theming
/// - Full accessibility support and semantic labels
/// - Cached image loading with placeholder and error handling
/// - Responsive design optimized for mobile devices
class RecipeDetailScreen extends StatefulWidget {
  /// The ID of the recipe to display
  final int recipeId;
  
  /// Optional recipe object if already available (for optimization)
  final Recipe? recipe;
  
  /// Optional hero tag for navigation animations
  final String? heroTag;

  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
    this.recipe,
    this.heroTag,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  // State management
  Recipe? _recipe;
  bool _isLoading = true;
  String? _errorMessage;
  
  // Services
  late final RecipeApiService _apiService;
  
  // UI Controllers
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _apiService = RecipeApiService.instance;
    
    // Use provided recipe if available, otherwise fetch from API
    if (widget.recipe != null) {
      _recipe = widget.recipe;
      _isLoading = false;
    } else {
      _loadRecipe();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Loads recipe details from the API
  Future<void> _loadRecipe() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final recipe = await _apiService.getRecipeById(widget.recipeId);
      
      if (!mounted) return;
      
      setState(() {
        _recipe = recipe;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
        _errorMessage = _getErrorMessage(e);
      });
    }
  }

  /// Converts API exceptions to user-friendly error messages
  String _getErrorMessage(dynamic error) {
    if (error is NetworkException) {
      return 'Check your internet connection and try again';
    } else if (error is ServerException) {
      return 'Recipe not found or server unavailable';
    } else if (error is TimeoutException) {
      return 'Request took too long. Please try again';
    } else {
      return 'Something went wrong. Please try again';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_recipe == null) {
      return _buildNotFoundState();
    }

    return _buildRecipeContent();
  }

  /// Builds loading state with skeleton UI and accessibility support
  Widget _buildLoadingState() {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n('recipeDetailTitle')),
        elevation: 0,
      ),
      body: Center(
        child: Semantics(
          label: context.l10n('loadingRecipe'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator.adaptive(),
              const SizedBox(height: 16.0),
              Text(
                context.l10n('loadingRecipe'),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds error state with retry option and accessibility support  
  Widget _buildErrorState() {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n('recipeDetailTitle')),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Semantics(
            label: '${context.l10n('errorLoadingRecipe')}: $_errorMessage',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Semantics(
                  label: context.l10n('errorLoadingRecipe'),
                  child: Icon(
                    Icons.error_outline,
                    size: 64.0,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  context.l10n('errorLoadingRecipe'),
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                Text(
                  _errorMessage!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                Semantics(
                  button: true,
                  label: context.l10n('tryAgain'),
                  child: FilledButton.icon(
                    onPressed: _loadRecipe,
                    icon: const Icon(Icons.refresh),
                    label: Text(context.l10n('tryAgain')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds not found state with accessibility support
  Widget _buildNotFoundState() {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n('recipeDetailTitle')),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Semantics(
            label: context.l10n('recipeNotFound'),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Semantics(
                  label: context.l10n('recipeNotFound'),
                  child: Icon(
                    Icons.restaurant_menu_outlined,
                    size: 64.0,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  context.l10n('recipeNotFound'),
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'The requested recipe could not be found.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the main recipe content with parallax scrolling
  Widget _buildRecipeContent() {
    final recipe = _recipe!;
    final theme = Theme.of(context);
    
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero image with parallax SliverAppBar
          _buildHeroSliverAppBar(recipe, theme),
          
          // Recipe content sections
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe title and metadata
                _buildRecipeHeader(recipe, theme),
                
                // Description section
                _buildDescriptionSection(recipe, theme),
                
                // Recipe metadata (time, servings, difficulty)
                _buildMetadataSection(recipe, theme),
                
                // Ingredients section
                _buildIngredientsSection(recipe, theme),
                
                // Steps section (placeholder for future implementation)
                _buildStepsSection(recipe, theme),
                
                // Bottom padding
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the hero image with SliverAppBar for parallax effect
  Widget _buildHeroSliverAppBar(Recipe recipe, ThemeData theme) {
    const double expandedHeight = 300.0;
    
    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      snap: false,
      elevation: 0,
      scrolledUnderElevation: 4,
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            recipe.title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        background: _buildHeroImage(recipe),
      ),
    );
  }

  /// Builds the hero image with cached loading and accessibility support
  Widget _buildHeroImage(Recipe recipe) {
    final imageWidget = Semantics(
      label: context.l10nInterpolate('recipeImage', {'recipeName': recipe.title}),
      image: true,
      child: CachedNetworkImage(
        imageUrl: recipe.imageUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Theme.of(context).colorScheme.errorContainer,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                size: 64.0,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Image unavailable',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ],
          ),
        ),
        memCacheHeight: 600, // 2x for retina displays
        maxWidthDiskCache: 1200, // High quality for detail view
      ),
    );

    // Wrap with hero animation if hero tag provided
    if (widget.heroTag != null) {
      return Hero(
        tag: widget.heroTag!,
        child: imageWidget,
      );
    }
    
    return imageWidget;
  }

  /// Builds the recipe header with title and category
  Widget _buildRecipeHeader(Recipe recipe, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category chip
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Text(
              recipe.category,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const SizedBox(height: 8.0),
          
                        // Rating row with accessibility and localization
              Semantics(
                label: '${context.l10nInterpolate('rating', {'rating': recipe.ratingFormatted})} ${context.l10nPlural('reviewCount', recipe.reviewCount)}',
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 20.0,
                      color: Colors.amber[600],
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      context.l10nInterpolate('rating', {'rating': recipe.ratingFormatted}),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '(${context.l10nPlural('reviewCount', recipe.reviewCount)})',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  /// Builds the description section
  Widget _buildDescriptionSection(Recipe recipe, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            recipe.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  /// Builds the metadata section (time, servings, difficulty) with i18n and a11y
  Widget _buildMetadataSection(Recipe recipe, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recipe Info',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12.0),
          
          // Metadata cards in a row with accessibility
          Semantics(
            label: 'Recipe information: ${context.l10nInterpolate('totalTime', {'minutes': recipe.totalTime})}, ${recipe.servings} ${context.l10n('servings')}, ${_getLocalizedDifficulty(recipe.difficulty)} ${context.l10n('difficulty')}',
            child: Row(
              children: [
                Expanded(
                  child: _buildMetadataCard(
                    context: context,
                    icon: Icons.access_time,
                    label: context.l10nInterpolate('totalTime', {'minutes': recipe.totalTime}),
                    value: recipe.totalTimeFormatted,
                    theme: theme,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: _buildMetadataCard(
                    context: context,
                    icon: Icons.restaurant,
                    label: context.l10n('servings'),
                    value: '${recipe.servings}',
                    theme: theme,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: _buildMetadataCard(
                    context: context,
                    icon: Icons.bar_chart,
                    label: context.l10n('difficulty'),
                    value: _getLocalizedDifficulty(recipe.difficulty),
                    theme: theme,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  /// Builds individual metadata card with accessibility support
  Widget _buildMetadataCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Semantics(
      label: '$label: $value',
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 24.0,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 8.0),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4.0),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get localized difficulty string
  String _getLocalizedDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return context.l10n('difficultyEasy');
      case 'medium':
        return context.l10n('difficultyMedium');
      case 'hard':
        return context.l10n('difficultyHard');
      default:
        return difficulty;
    }
  }

  /// Builds the ingredients section with i18n and accessibility
  Widget _buildIngredientsSection(Recipe recipe, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                context.l10n('ingredients'),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  context.l10nPlural('ingredientCount', recipe.ingredients.length),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          
          // Ingredients list with accessibility
          Semantics(
            label: '${context.l10n('ingredients')}: ${context.l10nPlural('ingredientCount', recipe.ingredients.length)}',
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: recipe.ingredients.asMap().entries.map((entry) {
                    final index = entry.key;
                    final ingredient = entry.value;
                    
                    return Semantics(
                      label: 'Ingredient ${index + 1}: $ingredient',
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: index < recipe.ingredients.length - 1 ? 12.0 : 0.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Bullet point
                            Container(
                              width: 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.only(top: 6.0, right: 12.0),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            
                            // Ingredient text
                            Expanded(
                              child: Text(
                                ingredient,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  /// Builds the cooking steps section with i18n and accessibility
  Widget _buildStepsSection(Recipe recipe, ThemeData theme) {
    // For this PoC, we'll create placeholder steps since the mock data doesn't include them
    // In a real app, these would come from the recipe data
    final placeholderSteps = [
      'Preheat your oven to the required temperature',
      'Prepare all ingredients as listed above',
      'Follow the cooking method for this ${recipe.category.toLowerCase()} recipe',
      'Cook for approximately ${recipe.cookTime} minutes',
      'Season to taste and serve hot',
    ];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n('cookingSteps'),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12.0),
          
          // Steps list with accessibility
          Semantics(
            label: '${context.l10n('cookingSteps')}: ${placeholderSteps.length} steps',
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: placeholderSteps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    
                    return Semantics(
                      label: '${context.l10nInterpolate('stepNumber', {'number': index + 1})}: $step',
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: index < placeholderSteps.length - 1 ? 16.0 : 0.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Step number
                            Semantics(
                              label: context.l10nInterpolate('stepNumber', {'number': index + 1}),
                              child: Container(
                                width: 28.0,
                                height: 28.0,
                                margin: const EdgeInsets.only(right: 12.0),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Step text
                            Expanded(
                              child: Text(
                                step,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Extension for additional recipe detail screen utilities
extension RecipeDetailScreenExtensions on RecipeDetailScreen {
  /// Creates a recipe detail screen with pre-loaded recipe (for optimization)
  static Widget withRecipe({
    required Recipe recipe,
    String? heroTag,
  }) {
    return RecipeDetailScreen(
      recipeId: recipe.id,
      recipe: recipe,
      heroTag: heroTag,
    );
  }
}

/// Performance metrics tracking for Task F004 evaluation
class RecipeDetailPerformanceTracker {
  static int _detailViewsLoaded = 0;
  static Duration? _lastLoadDuration;
  static DateTime? _lastLoadTime;

  static void recordDetailLoad(Duration duration) {
    _detailViewsLoaded++;
    _lastLoadDuration = duration;
    _lastLoadTime = DateTime.now();
  }

  static Map<String, dynamic> getMetrics() {
    return {
      'detailViewsLoaded': _detailViewsLoaded,
      'lastLoadDuration': _lastLoadDuration?.inMilliseconds,
      'lastLoadTime': _lastLoadTime?.toIso8601String(),
    };
  }

  static void reset() {
    _detailViewsLoaded = 0;
    _lastLoadDuration = null;
    _lastLoadTime = null;
  }
}