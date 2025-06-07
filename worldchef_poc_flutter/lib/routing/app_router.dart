/* ANNOTATION_BLOCK_START
{
  "artifact_id": "flutter_navigation_config",
  "version_tag": "1.0.0-f005-complete",
  "g_created": 17,
  "g_last_modified": 17,
  "description": "GoRouter navigation configuration for WorldChef PoC Flutter implementation with route definitions for recipe list and detail screens, parameter handling, and hero animations.",
  "artifact_type": "CODE_MODULE",
  "status_in_lifecycle": "DEVELOPMENT",
  "purpose_statement": "Provides comprehensive routing configuration using GoRouter for navigation between recipe list and detail screens with type-safe parameter passing and hero animation support for Task F005.",
  "key_logic_points": [
    "GoRouter configuration with named routes for maintainability",
    "Type-safe parameter passing for recipe IDs",
    "Hero animation support with consistent hero tag generation",
    "Proper error handling for invalid routes and parameters",
    "Back navigation support with automatic AppBar integration",
    "Route transition animations for smooth user experience",
    "Initial route configuration pointing to recipe list",
    "Deep linking support for recipe detail pages"
  ],
  "interfaces_provided": [
    {
      "name": "AppRouter",
      "interface_type": "NAVIGATION_CONFIGURATION",
      "details": "Main router configuration with route definitions and navigation helpers",
      "notes": "Singleton router instance providing centralized navigation management"
    },
    {
      "name": "AppRoute",
      "interface_type": "ENUM",
      "details": "Named route constants for type-safe navigation",
      "notes": "Prevents hardcoded route strings and enables IDE autocompletion"
    }
  ],
  "requisites": [
    { "description": "go_router package for Flutter navigation", "type": "EXTERNAL_DEPENDENCY" },
    { "description": "Recipe list and detail screens for route targets", "type": "INTERNAL_DEPENDENCY" },
    { "description": "Recipe data models for parameter validation", "type": "INTERNAL_DEPENDENCY" }
  ],
  "external_dependencies": [
    { "name": "go_router", "version": "^13.2.0", "reason": "Modern Flutter navigation with declarative routing and deep linking support" },
    { "name": "flutter_material", "version": "SDK", "reason": "Material Design components and navigation patterns" }
  ],
  "internal_dependencies": ["flutter_recipe_list_screen", "flutter_recipe_detail_screen", "flutter_recipe_models_manual"],
  "dependents": ["flutter_main_app", "flutter_recipe_list_screen"],
  "linked_issue_ids": [],
  "quality_notes": {
    "unit_tests": "PLANNED - Route navigation testing with MockGoRouter",
    "manual_review_comment": "AI-generated GoRouter configuration with comprehensive navigation flow, parameter handling, and hero animations for Task F005."
  }
}
ANNOTATION_BLOCK_END */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/recipe_list_screen.dart';
import '../screens/recipe_detail_screen.dart';
import '../models/recipe_manual.dart';

/// Named route constants for type-safe navigation
enum AppRoute {
  home('/'),
  recipeList('/recipes'),
  recipeDetail('/recipes/:id');

  const AppRoute(this.path);
  final String path;
}

/// Main application router configuration using GoRouter
/// 
/// Provides navigation between recipe list and detail screens with:
/// - Type-safe parameter passing for recipe IDs
/// - Hero animation support with consistent hero tag generation
/// - Proper error handling for invalid routes and parameters
/// - Back navigation support with automatic AppBar integration
/// - Smooth route transition animations
/// - Deep linking support for recipe detail pages
class AppRouter {
  static AppRouter? _instance;
  late final GoRouter _router;

  AppRouter._internal() {
    _router = _createRouter();
  }

  factory AppRouter() {
    _instance ??= AppRouter._internal();
    return _instance!;
  }

  /// Get the configured GoRouter instance
  GoRouter get router => _router;

  /// Creates the main router configuration
  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: AppRoute.recipeList.path,
      debugLogDiagnostics: true, // Enable for development, disable for production
      
      // Error handling for invalid routes
      errorBuilder: (context, state) => _buildErrorPage(context, state),
      
      routes: [
        // Recipe List Route (Home/Main screen)
        GoRoute(
          path: AppRoute.recipeList.path,
          name: 'recipeList',
          builder: (context, state) => const RecipeListScreen(),
          pageBuilder: (context, state) => _buildPage(
            context,
            state,
            const RecipeListScreen(),
            transitionType: PageTransitionType.fade,
          ),
        ),

        // Recipe Detail Route with parameter
        GoRoute(
          path: AppRoute.recipeDetail.path,
          name: 'recipeDetail',
          builder: (context, state) {
            final recipeIdStr = state.pathParameters['id'];
            final recipeId = int.tryParse(recipeIdStr ?? '');
            
            if (recipeId == null) {
              // Invalid recipe ID - redirect to recipe list
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go(AppRoute.recipeList.path);
              });
              return const RecipeListScreen();
            }
            
            // Extract optional recipe object from extra data for optimization
            final recipe = state.extra as Recipe?;
            
            return RecipeDetailScreen(
              recipeId: recipeId,
              recipe: recipe,
              heroTag: generateHeroTag(recipeId),
            );
          },
          pageBuilder: (context, state) {
            final recipeIdStr = state.pathParameters['id'];
            final recipeId = int.tryParse(recipeIdStr ?? '');
            
            if (recipeId == null) {
              // Invalid recipe ID - redirect with fade transition
              return _buildPage(
                context,
                state,
                const RecipeListScreen(),
                transitionType: PageTransitionType.fade,
              );
            }
            
            final recipe = state.extra as Recipe?;
            
            return _buildPage(
              context,
              state,
              RecipeDetailScreen(
                recipeId: recipeId,
                recipe: recipe,
                heroTag: generateHeroTag(recipeId),
              ),
              transitionType: PageTransitionType.slideFromRight,
            );
          },
        ),

        // Redirect root path to recipe list
        GoRoute(
          path: AppRoute.home.path,
          redirect: (context, state) => AppRoute.recipeList.path,
        ),
      ],
    );
  }

  /// Builds a custom page with specified transition animations
  CustomTransitionPage _buildPage(
    BuildContext context,
    GoRouterState state,
    Widget child, {
    PageTransitionType transitionType = PageTransitionType.slideFromRight,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transitionType) {
          case PageTransitionType.fade:
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          case PageTransitionType.slideFromRight:
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
          case PageTransitionType.slideFromBottom:
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: child,
            );
        }
      },
    );
  }

  /// Builds error page for invalid routes
  Widget _buildErrorPage(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.0,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Page Not Found',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              Text(
                'The page you\'re looking for doesn\'t exist.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              FilledButton.icon(
                onPressed: () => context.go(AppRoute.recipeList.path),
                icon: const Icon(Icons.home),
                label: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Generates consistent hero tag for recipe animations
  static String generateHeroTag(int recipeId) {
    return 'recipe_hero_$recipeId';
  }
}

/// Page transition types for route animations
enum PageTransitionType {
  fade,
  slideFromRight,
  slideFromBottom,
}

/// Navigation helper extension for easy route navigation
extension AppNavigation on BuildContext {
  /// Navigate to recipe list screen
  void goToRecipeList() {
    go(AppRoute.recipeList.path);
  }

  /// Navigate to recipe detail screen with recipe ID
  void goToRecipeDetail(int recipeId, {Recipe? recipe}) {
    final path = AppRoute.recipeDetail.path.replaceAll(':id', recipeId.toString());
    go(path, extra: recipe);
  }

  /// Push recipe detail screen (for stack navigation)
  Future<T?> pushRecipeDetail<T extends Object?>(int recipeId, {Recipe? recipe}) {
    final path = AppRoute.recipeDetail.path.replaceAll(':id', recipeId.toString());
    return push<T>(path, extra: recipe);
  }

  /// Navigate back or to recipe list if no back stack
  void goBackOrHome() {
    if (canPop()) {
      pop();
    } else {
      goToRecipeList();
    }
  }
}

/// Navigation helper functions for external use
class NavigationHelper {
  /// Navigate to recipe detail from recipe card
  static void navigateToRecipe(
    BuildContext context, 
    Recipe recipe, {
    bool useReplacement = false,
  }) {
    if (useReplacement) {
      context.goToRecipeDetail(recipe.id, recipe: recipe);
    } else {
      context.pushRecipeDetail(recipe.id, recipe: recipe);
    }
  }

  /// Generate hero tag for recipe animations
  static String getHeroTag(int recipeId) {
    return AppRouter.generateHeroTag(recipeId);
  }

  /// Check if current route is recipe detail
  static bool isRecipeDetailRoute(BuildContext context) {
    final state = GoRouterState.of(context);
    final path = state.matchedLocation;
    return path.startsWith('/recipes/') && path != '/recipes';
  }

  /// Check if current route is recipe list
  static bool isRecipeListRoute(BuildContext context) {
    final state = GoRouterState.of(context);
    final path = state.matchedLocation;
    return path == '/recipes' || path == '/';
  }

  /// Get current recipe ID from route (if on detail page)
  static int? getCurrentRecipeId(BuildContext context) {
    final state = GoRouterState.of(context);
    final recipeIdStr = state.pathParameters['id'];
    return int.tryParse(recipeIdStr ?? '');
  }
}

/// Router configuration for MaterialApp.router
class AppRouterConfig {
  static GoRouter get router => AppRouter().router;
  
  /// Initialize router for application startup
  static void initialize() {
    AppRouter(); // Ensure router is initialized
  }
}

// Example usage:
/*
// In main.dart:
return MaterialApp.router(
  routerConfig: RouterConfig.router,
  // ... other app configuration
);

// In RecipeCard onTap:
NavigationHelper.navigateToRecipe(context, recipe);

// In RecipeDetailScreen for back navigation:
context.goBackOrHome();

// Check current route:
if (NavigationHelper.isRecipeDetailRoute(context)) {
  // Handle detail-specific logic
}

// Get hero tag:
final heroTag = NavigationHelper.getHeroTag(recipe.id);
*/ 