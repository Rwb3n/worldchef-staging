# WorldChef Screen Transitions Specification

**Version**: 1.0  
**Status**: ✅ **ACTIVE**  
**Last Updated**: 2025-06-26  
**Framework**: Flutter 3.x  
**Animation System**: Material Design 3

---

## Overview

This specification defines all screen-to-screen transitions in the WorldChef mobile application, ensuring consistent navigation experiences that align with Material Design 3 principles and enhance user flow comprehension.

**Core Objectives**:
- **Spatial Awareness**: Help users understand their location in the app hierarchy
- **Continuity**: Maintain visual connection between related screens
- **Performance**: Smooth 60fps transitions on all supported devices
- **Accessibility**: Support for reduced motion preferences
- **Brand Consistency**: Align with WorldChef design language

---

## Navigation Hierarchy

### Primary Navigation Flow
```
Home Feed
├── Recipe Detail
│   ├── Creator Profile
│   ├── Recipe Instructions (Full Screen)
│   └── Share Modal
├── Search Results
│   └── Recipe Detail (same as above)
├── Favorites
│   └── Recipe Detail (same as above)
└── Profile
    ├── Settings
    ├── Created Recipes
    └── Saved Collections
```

### Modal Overlays
```
Global Modals
├── Search Overlay
├── Filters Bottom Sheet
├── Share Options Bottom Sheet
├── Recipe Actions Menu
├── Settings Panels
└── Confirmation Dialogs
```

---

## Transition Categories

### 1. Hierarchical Navigation (300ms)
**Purpose**: Moving deeper into or back from app hierarchy  
**Animation**: Slide with fade  
**Curve**: `Curves.easeOut`

#### Forward Navigation (Drill Down)
- **Direction**: Left-to-right slide
- **Secondary Animation**: Subtle fade-in
- **Use Cases**: Home → Recipe Detail, Recipe Detail → Creator Profile

```dart
class HierarchicalTransition {
  static PageRouteBuilder forward({
    required Widget page,
    String? heroTag,
  }) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Primary slide animation
        final slideAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0), // Start from right
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
        ));
        
        // Secondary fade animation
        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.1, 0.6, curve: Curves.easeIn),
        ));
        
        // Exit animation for previous screen
        final exitAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.3, 0.0), // Slide left slightly
        ).animate(CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeOut,
        ));
        
        return Stack(
          children: [
            // Previous screen sliding out
            SlideTransition(
              position: exitAnimation,
              child: FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.8).animate(secondaryAnimation),
                child: Container(), // Previous screen content
              ),
            ),
            // New screen sliding in
            SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}
```

#### Backward Navigation (Pop)
- **Direction**: Right-to-left slide
- **Secondary Animation**: Previous screen fade-in
- **Trigger**: Back button, back gesture, pop action

```dart
class BackwardTransition {
  static void pop(BuildContext context) {
    Navigator.of(context).pop();
    // The reverse animation is automatically handled by PageRouteBuilder
  }
}
```

### 2. Lateral Navigation (200ms)
**Purpose**: Moving between screens at the same hierarchy level  
**Animation**: Fade with subtle slide  
**Curve**: `Curves.easeInOut`

#### Tab Switching
- **Animation**: Cross-fade with 20px horizontal offset
- **Use Cases**: Bottom navigation tab changes

```dart
class LateralTransition {
  static Widget buildTabTransition({
    required Widget child,
    required Animation<double> animation,
    TabDirection direction = TabDirection.leftToRight,
  }) {
    final slideOffset = direction == TabDirection.leftToRight 
      ? const Offset(0.05, 0.0)  // 5% of screen width
      : const Offset(-0.05, 0.0);
    
    final slideAnimation = Tween<Offset>(
      begin: slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
    ));
    
    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
    ));
    
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: child,
      ),
    );
  }
}
```

### 3. Modal Presentations (250ms)
**Purpose**: Temporary overlays and contextual actions  
**Animation**: Scale and fade from trigger point  
**Curve**: `Curves.easeOut`

#### Bottom Sheet Presentation
```dart
class BottomSheetTransition {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 250),
        vsync: Navigator.of(context),
      ),
      builder: (context) => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

#### Full Screen Modal
```dart
class FullScreenModalTransition {
  static PageRouteBuilder create({
    required Widget page,
    ModalPresentationStyle style = ModalPresentationStyle.slideUp,
  }) {
    return PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (style) {
          case ModalPresentationStyle.slideUp:
            return _buildSlideUpTransition(animation, child);
          case ModalPresentationStyle.scaleFromCenter:
            return _buildScaleTransition(animation, child);
          case ModalPresentationStyle.fadeIn:
            return _buildFadeTransition(animation, child);
        }
      },
    );
  }
  
  static Widget _buildSlideUpTransition(Animation<double> animation, Widget child) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));
    
    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    ));
    
    return Stack(
      children: [
        FadeTransition(
          opacity: fadeAnimation,
          child: Container(color: Colors.black54),
        ),
        SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      ],
    );
  }
}
```

---

## Specific Screen Transitions

### Home Feed → Recipe Detail
**Animation**: Hierarchical forward transition with hero animation  
**Duration**: 300ms  
**Special Features**: Recipe image hero transition

```dart
class HomeToRecipeTransition {
  static void navigate({
    required BuildContext context,
    required Recipe recipe,
    required String heroTag,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return RecipeDetailScreen(
            recipe: recipe,
            heroTag: heroTag,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Hero animation is automatically handled by Flutter
          // Add additional slide transition
          final slideAnimation = Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ));
          
          return SlideTransition(
            position: slideAnimation,
            child: child,
          );
        },
      ),
    );
  }
}
```

### Recipe Detail → Creator Profile
**Animation**: Hierarchical forward transition  
**Duration**: 300ms  
**Special Features**: Creator avatar hero transition

```dart
class RecipeToCreatorTransition {
  static void navigate({
    required BuildContext context,
    required Creator creator,
    required String avatarHeroTag,
  }) {
    Navigator.of(context).push(
      HierarchicalTransition.forward(
        page: CreatorProfileScreen(
          creator: creator,
          avatarHeroTag: avatarHeroTag,
        ),
        heroTag: avatarHeroTag,
      ),
    );
  }
}
```

### Search Overlay Presentation
**Animation**: Fade in with scale from search button  
**Duration**: 200ms  
**Special Features**: Keyboard animation coordination

```dart
class SearchOverlayTransition {
  static Future<String?> show({
    required BuildContext context,
    required Offset triggerPoint,
  }) {
    return Navigator.of(context).push<String>(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black26,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) {
          return SearchOverlayScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Scale animation from trigger point
          final scaleAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
          ));
          
          // Fade animation for background
          final backgroundFade = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
          ));
          
          return Stack(
            children: [
              FadeTransition(
                opacity: backgroundFade,
                child: Container(color: Colors.black26),
              ),
              Center(
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: child,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

### Filter Bottom Sheet
**Animation**: Slide up from bottom with backdrop fade  
**Duration**: 250ms  
**Special Features**: Drag-to-dismiss support

```dart
class FilterBottomSheetTransition {
  static Future<FilterOptions?> show({
    required BuildContext context,
    required FilterOptions currentFilters,
  }) {
    return showModalBottomSheet<FilterOptions>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: FilterBottomSheetContent(
                currentFilters: currentFilters,
                scrollController: scrollController,
              ),
            );
          },
        );
      },
    );
  }
}
```

---

## Deep Link Navigation

### External Link Handling
**Animation**: Fade in with subtle scale  
**Duration**: 200ms  
**Special Features**: Loading state management

```dart
class DeepLinkTransition {
  static Future<void> navigateToRecipe({
    required BuildContext context,
    required String recipeId,
  }) async {
    // Show loading state
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    try {
      // Fetch recipe data
      final recipe = await RecipeService.getRecipe(recipeId);
      
      // Dismiss loading
      Navigator.of(context).pop();
      
      // Navigate with custom transition
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (context, animation, secondaryAnimation) {
            return RecipeDetailScreen(recipe: recipe);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeIn,
            ));
            
            final scaleAnimation = Tween<double>(
              begin: 0.95,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ));
            
            return FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            );
          },
        ),
      );
    } catch (error) {
      // Handle error
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load recipe: $error')),
      );
    }
  }
}
```

---

## Accessibility Considerations

### Reduced Motion Support
```dart
class AccessibleScreenTransition {
  static PageRouteBuilder create({
    required Widget page,
    required BuildContext context,
    TransitionType type = TransitionType.hierarchical,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final shouldReduceMotion = mediaQuery.disableAnimations;
    
    if (shouldReduceMotion) {
      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 100),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Simple fade transition for reduced motion
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    }
    
    // Full animation for normal motion preference
    switch (type) {
      case TransitionType.hierarchical:
        return HierarchicalTransition.forward(page: page);
      case TransitionType.lateral:
        return LateralTransition.create(page: page);
      case TransitionType.modal:
        return FullScreenModalTransition.create(page: page);
    }
  }
}
```

### Focus Management
```dart
class FocusAwareTransition {
  static void navigateWithFocus({
    required BuildContext context,
    required Widget page,
    required FocusNode targetFocus,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Listen for animation completion
          animation.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              // Request focus after transition completes
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (targetFocus.canRequestFocus) {
                  targetFocus.requestFocus();
                }
              });
            }
          });
          
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            )),
            child: child,
          );
        },
      ),
    );
  }
}
```

---

## Performance Optimization

### Transition Caching
```dart
class TransitionCache {
  static final Map<String, PageRouteBuilder> _cachedTransitions = {};
  
  static PageRouteBuilder getOrCreate({
    required String key,
    required Widget Function() pageBuilder,
    required TransitionType type,
  }) {
    if (_cachedTransitions.containsKey(key)) {
      return _cachedTransitions[key]!;
    }
    
    final transition = _createTransition(pageBuilder(), type);
    _cachedTransitions[key] = transition;
    return transition;
  }
  
  static void clearCache() {
    _cachedTransitions.clear();
  }
  
  static PageRouteBuilder _createTransition(Widget page, TransitionType type) {
    // Implementation based on type
    switch (type) {
      case TransitionType.hierarchical:
        return HierarchicalTransition.forward(page: page);
      case TransitionType.lateral:
        return LateralTransition.create(page: page);
      case TransitionType.modal:
        return FullScreenModalTransition.create(page: page);
    }
  }
}
```

### Memory Management
```dart
class TransitionMemoryManager {
  static void optimizeForLowMemory() {
    // Reduce animation quality for low-memory devices
    TransitionSettings.reducedQuality = true;
    TransitionCache.clearCache();
  }
  
  static void restoreFullQuality() {
    TransitionSettings.reducedQuality = false;
  }
}

class TransitionSettings {
  static bool reducedQuality = false;
  
  static Duration get transitionDuration {
    return reducedQuality 
      ? const Duration(milliseconds: 150)
      : const Duration(milliseconds: 300);
  }
  
  static Curve get transitionCurve {
    return reducedQuality 
      ? Curves.linear
      : Curves.easeOut;
  }
}
```

---

## Testing Patterns

### Transition Testing
```dart
class TransitionTestUtils {
  static Future<void> testTransition({
    required WidgetTester tester,
    required Widget fromScreen,
    required Widget toScreen,
    required VoidCallback triggerTransition,
    Duration expectedDuration = const Duration(milliseconds: 300),
  }) async {
    // Setup initial screen
    await tester.pumpWidget(
      MaterialApp(home: fromScreen),
    );
    
    // Trigger transition
    triggerTransition();
    await tester.pump();
    
    // Verify transition is in progress
    expect(find.byWidget(fromScreen), findsOneWidget);
    expect(find.byWidget(toScreen), findsOneWidget);
    
    // Wait for transition to complete
    await tester.pumpAndSettle();
    
    // Verify final state
    expect(find.byWidget(fromScreen), findsNothing);
    expect(find.byWidget(toScreen), findsOneWidget);
  }
  
  static Future<void> testAccessibleTransition({
    required WidgetTester tester,
    required Widget screen,
    required bool reducedMotion,
  }) async {
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(disableAnimations: reducedMotion),
        child: MaterialApp(home: screen),
      ),
    );
    
    // Test that transitions respect reduced motion preference
    // Implementation depends on specific transition being tested
  }
}
```

---

## Implementation Roadmap

### Phase 1: Core Transitions (Week 1)
- [ ] Hierarchical navigation (Home → Recipe Detail)
- [ ] Back navigation with proper reverse animation
- [ ] Basic modal presentation (bottom sheets)
- [ ] Tab switching animations

### Phase 2: Advanced Transitions (Week 2)
- [ ] Hero animations for recipe images and avatars
- [ ] Search overlay with scale animation
- [ ] Filter bottom sheet with drag support
- [ ] Deep link navigation handling

### Phase 3: Accessibility & Polish (Week 3)
- [ ] Reduced motion support implementation
- [ ] Focus management during transitions
- [ ] Performance optimization and caching
- [ ] Comprehensive testing suite

### Phase 4: Validation & Documentation (Week 4)
- [ ] User testing and feedback integration
- [ ] Performance benchmarking
- [ ] Documentation completion
- [ ] Cookbook pattern creation

---

**Status**: ✅ **SPECIFICATION COMPLETE**  
**Next Phase**: Flutter Implementation  
**Target Completion**: 2025-07-01 