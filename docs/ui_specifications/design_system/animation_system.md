# WorldChef Animation System Specification

**Version**: 1.0  
**Status**: ✅ **ACTIVE**  
**Last Updated**: 2025-06-26  
**Compliance**: Material Design 3  
**Target Framework**: Flutter 3.x

---

## Overview

The WorldChef Animation System provides a comprehensive framework for consistent, performant, and accessible animations throughout the mobile application. This system follows Material Design 3 motion principles while optimizing for the WorldChef brand experience and Flutter implementation patterns.

**Core Principles**:
- **Purposeful Motion**: Every animation serves a functional or emotional purpose
- **Material3 Compliance**: Strict adherence to Google's motion guidelines
- **Performance First**: 60fps target on all supported devices
- **Accessibility Aware**: Full support for reduced motion preferences
- **Consistent Language**: Unified animation vocabulary across all components

---

## Animation Categories

### 1. Micro-Interactions (100ms)
**Purpose**: Immediate feedback for user interactions  
**Duration**: 100ms  
**Curve**: `Curves.easeOut` / `cubic-bezier(0.2, 0.0, 0.0, 1.0)`

**Use Cases**:
- Button press/release feedback
- Hover state transitions
- Focus ring animations
- Toggle state changes
- Loading spinner rotations

**Implementation Pattern**:
```dart
class MicroInteractionAnimator {
  static const Duration duration = Duration(milliseconds: 100);
  static const Curve curve = Curves.easeOut;
  
  static AnimationController createController(TickerProvider vsync) {
    return AnimationController(duration: duration, vsync: vsync);
  }
  
  static Animation<double> createScaleAnimation(AnimationController controller) {
    return Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }
}
```

### 2. Component Transitions (200ms)
**Purpose**: State changes within components  
**Duration**: 200ms  
**Curve**: `Curves.easeOut` / `cubic-bezier(0.2, 0.0, 0.0, 1.0)`

**Use Cases**:
- Bottom navigation item selection
- Card expansion/collapse
- Modal sheet presentation
- Tab switching animations
- Form field validation states

**Implementation Pattern**:
```dart
class ComponentTransitionAnimator {
  static const Duration duration = Duration(milliseconds: 200);
  static const Curve curve = Curves.easeOut;
  
  static Widget buildAnimatedContainer({
    required Widget child,
    required bool isSelected,
    required Color selectedColor,
    required Color defaultColor,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      decoration: BoxDecoration(
        color: isSelected ? selectedColor : defaultColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
```

### 3. Screen Transitions (300ms)
**Purpose**: Navigation between screens and major UI changes  
**Duration**: 300ms  
**Curve**: `Curves.easeOut` / `cubic-bezier(0.2, 0.0, 0.0, 1.0)`

**Use Cases**:
- Page navigation (Home → Recipe Detail)
- Modal presentation/dismissal
- Deep link navigation
- Tab view transitions
- Search overlay appearance

**Implementation Pattern**:
```dart
class ScreenTransitionAnimator {
  static const Duration duration = Duration(milliseconds: 300);
  static const Curve curve = Curves.easeOut;
  
  static PageRouteBuilder createSlideTransition({
    required Widget page,
    SlideDirection direction = SlideDirection.leftToRight,
  }) {
    return PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offset = _getSlideOffset(direction);
        return SlideTransition(
          position: Tween<Offset>(begin: offset, end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );
      },
    );
  }
}
```

### 4. Complex Choreography (500ms)
**Purpose**: Coordinated multi-element animations  
**Duration**: 500ms  
**Curve**: Mixed curves for staggered effects

**Use Cases**:
- Recipe card grid loading
- Search results appearance
- Onboarding sequences
- Error state recovery
- Batch operations feedback

**Implementation Pattern**:
```dart
class ChoreographyAnimator {
  static const Duration totalDuration = Duration(milliseconds: 500);
  static const Duration staggerDelay = Duration(milliseconds: 50);
  
  static List<Animation<double>> createStaggeredAnimations({
    required AnimationController controller,
    required int itemCount,
  }) {
    return List.generate(itemCount, (index) {
      final start = (index * staggerDelay.inMilliseconds) / 
                   totalDuration.inMilliseconds;
      final end = start + 0.6; // 60% of total duration per item
      
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(start, end.clamp(0.0, 1.0), curve: Curves.easeOut),
        ),
      );
    });
  }
}
```

---

## Material3 Curve Standards

### Standard Curves
```dart
class WorldChefCurves {
  // Material3 standard curves
  static const Curve standard = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Curve decelerate = Cubic(0.0, 0.0, 0.2, 1.0);
  static const Curve accelerate = Cubic(0.4, 0.0, 1.0, 1.0);
  static const Curve emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
  
  // Flutter equivalents
  static const Curve standardFlutter = Curves.easeOut;
  static const Curve decelerateFlutter = Curves.easeIn;
  static const Curve accelerateFlutter = Curves.easeInOut;
  static const Curve emphasizedFlutter = Curves.easeOut;
}
```

### Curve Usage Guidelines

| Animation Type | Curve | Usage |
|----------------|-------|-------|
| **Elements Entering** | `decelerate` | Modals appearing, cards sliding in |
| **Elements Leaving** | `accelerate` | Modals dismissing, cards sliding out |
| **State Changes** | `standard` | Button presses, color transitions |
| **Important Actions** | `emphasized` | Success states, critical feedback |
| **Continuous Motion** | `linear` | Loading spinners, progress bars |

---

## Component-Specific Animations

### Interactive Components

#### WCPrimaryButton
```dart
class WCPrimaryButton extends StatefulWidget {
  // ... properties
  
  @override
  State<WCPrimaryButton> createState() => _WCPrimaryButtonState();
}

class _WCPrimaryButtonState extends State<WCPrimaryButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  
  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: MicroInteractionAnimator.duration,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95)
      .animate(CurvedAnimation(
        parent: _pressController, 
        curve: MicroInteractionAnimator.curve,
      ));
      
    _colorAnimation = ColorTween(
      begin: WorldChefColors.secondaryGreen,
      end: WorldChefColors.secondaryGreenActive,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: MicroInteractionAnimator.curve,
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) => _pressController.reverse(),
      onTapCancel: () => _pressController.reverse(),
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                borderRadius: BorderRadius.circular(8),
              ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
  
  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }
}
```

#### WCBottomNavigation
```dart
class WCBottomNavItem extends StatelessWidget {
  const WCBottomNavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: ComponentTransitionAnimator.duration,
        curve: ComponentTransitionAnimator.curve,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected 
            ? WorldChefColors.brandBlue.withOpacity(0.1)
            : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: ComponentTransitionAnimator.duration,
              curve: ComponentTransitionAnimator.curve,
              child: Icon(
                icon,
                color: isSelected 
                  ? WorldChefColors.brandBlue 
                  : WorldChefNeutrals.secondaryText,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: ComponentTransitionAnimator.duration,
              curve: ComponentTransitionAnimator.curve,
              style: WorldChefTextStyles.labelSmall.copyWith(
                color: isSelected 
                  ? WorldChefColors.brandBlue 
                  : WorldChefNeutrals.secondaryText,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### WCFeaturedRecipeCard
```dart
class WCFeaturedRecipeCard extends StatefulWidget {
  // ... properties
  
  @override
  State<WCFeaturedRecipeCard> createState() => _WCFeaturedRecipeCardState();
}

class _WCFeaturedRecipeCardState extends State<WCFeaturedRecipeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;
  
  bool _isHovered = false;
  
  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: ComponentTransitionAnimator.duration,
      vsync: this,
    );
    
    _elevationAnimation = Tween<double>(begin: 2.0, end: 8.0)
      .animate(CurvedAnimation(
        parent: _hoverController,
        curve: ComponentTransitionAnimator.curve,
      ));
      
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02)
      .animate(CurvedAnimation(
        parent: _hoverController,
        curve: ComponentTransitionAnimator.curve,
      ));
  }
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              elevation: _elevationAnimation.value,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
  
  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }
}
```

---

## Screen Transition Patterns

### Navigation Transitions

#### Slide Transitions
```dart
enum SlideDirection { leftToRight, rightToLeft, topToBottom, bottomToTop }

class WorldChefPageTransitions {
  static PageRouteBuilder slideTransition({
    required Widget page,
    SlideDirection direction = SlideDirection.leftToRight,
    Duration duration = ScreenTransitionAnimator.duration,
  }) {
    return PageRouteBuilder(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offset = _getSlideOffset(direction);
        
        final slideAnimation = Tween<Offset>(
          begin: offset,
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: WorldChefCurves.standard,
        ));
        
        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
        ));
        
        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }
  
  static Offset _getSlideOffset(SlideDirection direction) {
    switch (direction) {
      case SlideDirection.leftToRight:
        return const Offset(-1.0, 0.0);
      case SlideDirection.rightToLeft:
        return const Offset(1.0, 0.0);
      case SlideDirection.topToBottom:
        return const Offset(0.0, -1.0);
      case SlideDirection.bottomToTop:
        return const Offset(0.0, 1.0);
    }
  }
}
```

#### Modal Transitions
```dart
class WorldChefModalTransitions {
  static PageRouteBuilder bottomSheetTransition({
    required Widget page,
    bool isDismissible = true,
  }) {
    return PageRouteBuilder(
      opaque: false,
      barrierDismissible: isDismissible,
      barrierColor: Colors.black54,
      transitionDuration: ScreenTransitionAnimator.duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: WorldChefCurves.decelerate,
        ));
        
        final backgroundAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
        ));
        
        return Stack(
          children: [
            FadeTransition(
              opacity: backgroundAnimation,
              child: Container(color: Colors.black54),
            ),
            SlideTransition(
              position: slideAnimation,
              child: child,
            ),
          ],
        );
      },
    );
  }
}
```

---

## Performance Optimization

### Animation Controller Management
```dart
class AnimationControllerManager {
  static final Map<String, AnimationController> _controllers = {};
  
  static AnimationController getOrCreate({
    required String key,
    required Duration duration,
    required TickerProvider vsync,
  }) {
    if (_controllers.containsKey(key)) {
      return _controllers[key]!;
    }
    
    final controller = AnimationController(duration: duration, vsync: vsync);
    _controllers[key] = controller;
    return controller;
  }
  
  static void dispose(String key) {
    _controllers[key]?.dispose();
    _controllers.remove(key);
  }
  
  static void disposeAll() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }
}
```

### Performance Monitoring
```dart
class AnimationPerformanceMonitor {
  static bool _isEnabled = false;
  static final List<Duration> _frameTimes = [];
  
  static void enable() => _isEnabled = true;
  static void disable() => _isEnabled = false;
  
  static void recordFrame(Duration frameTime) {
    if (!_isEnabled) return;
    
    _frameTimes.add(frameTime);
    
    // Keep only last 60 frames (1 second at 60fps)
    if (_frameTimes.length > 60) {
      _frameTimes.removeAt(0);
    }
    
    // Check for performance issues
    final averageFrameTime = _frameTimes.reduce((a, b) => a + b) / 
                            _frameTimes.length;
    
    if (averageFrameTime.inMicroseconds > 16667) { // > 16.67ms = < 60fps
      debugPrint('Animation performance warning: ${averageFrameTime.inMilliseconds}ms average frame time');
    }
  }
  
  static double get averageFPS {
    if (_frameTimes.isEmpty) return 0.0;
    final averageFrameTime = _frameTimes.reduce((a, b) => a + b) / 
                            _frameTimes.length;
    return 1000000 / averageFrameTime.inMicroseconds; // Convert to FPS
  }
}
```

---

## Accessibility Integration

### Reduced Motion Support
```dart
class AccessibleAnimationWrapper extends StatelessWidget {
  const AccessibleAnimationWrapper({
    Key? key,
    required this.child,
    required this.fallback,
    this.duration,
  }) : super(key: key);

  final Widget child;
  final Widget fallback;
  final Duration? duration;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final shouldReduceMotion = mediaQuery.disableAnimations;
    
    if (shouldReduceMotion) {
      return fallback;
    }
    
    return child;
  }
}

// Usage example
class AccessibleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AccessibleAnimationWrapper(
      child: AnimatedButton(/* full animation */),
      fallback: StaticButton(/* no animation */),
    );
  }
}
```

### Focus Management
```dart
class FocusAwareAnimationController {
  static void animateWithFocus({
    required AnimationController controller,
    required FocusNode focusNode,
    required VoidCallback onComplete,
  }) {
    controller.forward().then((_) {
      // Ensure focus is maintained after animation
      if (focusNode.canRequestFocus) {
        focusNode.requestFocus();
      }
      onComplete();
    });
  }
}
```

---

## Testing Patterns

### Animation Testing Utilities
```dart
class AnimationTestUtils {
  static Future<void> pumpAndSettle(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await tester.pumpAndSettle(timeout);
  }
  
  static Future<void> testAnimationDuration(
    WidgetTester tester,
    Duration expectedDuration,
  ) async {
    final stopwatch = Stopwatch()..start();
    await tester.pumpAndSettle();
    stopwatch.stop();
    
    expect(
      stopwatch.elapsed,
      isInRange(
        expectedDuration - const Duration(milliseconds: 50),
        expectedDuration + const Duration(milliseconds: 50),
      ),
    );
  }
  
  static void expectAnimationValue<T>(
    Animation<T> animation,
    T expectedValue, {
    String? reason,
  }) {
    expect(animation.value, expectedValue, reason: reason);
  }
}
```

### Performance Testing
```dart
void main() {
  group('Animation Performance Tests', () {
    testWidgets('button animation maintains 60fps', (tester) async {
      AnimationPerformanceMonitor.enable();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WCPrimaryButton(
              onPressed: () {},
              child: const Text('Test'),
            ),
          ),
        ),
      );
      
      // Simulate button press
      await tester.tap(find.byType(WCPrimaryButton));
      await tester.pumpAndSettle();
      
      expect(AnimationPerformanceMonitor.averageFPS, greaterThan(55.0));
      
      AnimationPerformanceMonitor.disable();
    });
  });
}
```

---

## Implementation Checklist

### Component Animation Requirements
- [ ] **WCPrimaryButton**: Press animation with scale and color change
- [ ] **WCSecondaryButton**: Press animation with border and background change
- [ ] **WCIconButton**: Press animation with scale and color change
- [ ] **WCChipButton**: Press animation with background color change
- [ ] **WCBottomNavItem**: Selection animation with scale and color change
- [ ] **WCBackButton**: Press animation with scale change
- [ ] **WCMenuButton**: Press animation with rotation and color change
- [ ] **WCCategoryChip**: Selection animation with background and border change
- [ ] **WCIngredientListItem**: Selection animation with background change

### Screen Transition Requirements
- [ ] **Home → Recipe Detail**: Slide left-to-right transition
- [ ] **Recipe Detail → Creator Profile**: Slide left-to-right transition
- [ ] **Modal Presentation**: Bottom sheet slide-up transition
- [ ] **Tab Switching**: Fade transition with slide offset
- [ ] **Search Overlay**: Fade in with scale animation

### Performance Requirements
- [ ] **60fps Target**: All animations maintain smooth frame rate
- [ ] **Memory Management**: No animation controller leaks
- [ ] **Battery Optimization**: Minimal power consumption
- [ ] **Reduced Motion**: Graceful degradation for accessibility

### Testing Requirements
- [ ] **Unit Tests**: Animation controller behavior
- [ ] **Widget Tests**: Animation integration with components
- [ ] **Performance Tests**: Frame rate validation
- [ ] **Accessibility Tests**: Reduced motion compliance

---

**Status**: ✅ **SPECIFICATION COMPLETE**  
**Next Phase**: Component Implementation  
**Target Completion**: 2025-07-01 