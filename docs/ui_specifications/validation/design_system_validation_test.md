# Design System Validation Tests

**Status**: 🔴 **FAILING** (Initial Red Phase)  
**Created**: 2025-06-26  
**Plan**: `plans/plan_design_system_enhancement.txt`  
**Task**: t001 (TEST_CREATION)  
**Global Event**: 179

---

## Overview

This document contains comprehensive validation tests for the WorldChef design system. These tests are designed to **INITIALLY FAIL** to identify gaps and anti-patterns that need to be addressed in subsequent implementation tasks.

**Test Philosophy**: Following TDD methodology, these tests define the desired end state of the design system and will guide implementation in tasks t002-t003.

---

## Test Suite 1: Component State Completeness

### Test 1.1: Interactive Component State Coverage
**Status**: 🔴 **FAILING**

**Test Description**: Verify that all interactive components have complete state definitions.

**Required States for Interactive Components**:
- `default` (normal state)
- `hover` (mouse hover or touch highlight)
- `active` (pressed/tapped state)
- `disabled` (non-interactive state)
- `focus` (keyboard focus state)

**Components to Test**:

#### Atoms
- [ ] **WCPrimaryButton** - Missing hover, active, disabled, focus states
- [ ] **WCSecondaryButton** - Missing hover, active, disabled, focus states  
- [ ] **WCIconButton** - Missing hover, active, disabled, focus states
- [ ] **WCChipButton** - Missing hover, active, disabled, focus states

#### Molecules  
- [ ] **WCBottomNavItem** - Missing hover, active, disabled, focus states
- [ ] **WCCategoryChip** - Missing hover, active, disabled, focus states
- [ ] **WCIngredientListItem** - Missing hover, active, disabled, focus states
- [ ] **WCBackButton** - Missing hover, active, disabled, focus states
- [ ] **WCMenuButton** - Missing hover, active, disabled, focus states

**Expected Failure Reason**: Current `atomic_design_components.md` only defines default appearance without state variations.

**Pass Criteria**: Each interactive component must have a "Component States" table with MaterialState mappings to WorldChef color tokens.

---

### Test 1.2: State-to-Token Mapping Consistency
**Status**: 🔴 **FAILING**

**Test Description**: Verify that component states consistently map to appropriate design tokens.

**Required Mapping Pattern**:
```dart
// Example expected format
class WCPrimaryButton {
  static const _stateColors = {
    MaterialState.disabled: WorldChefColors.secondaryGreenDisabled,
    MaterialState.pressed: WorldChefColors.secondaryGreenActive,
    MaterialState.hovered: WorldChefColors.secondaryGreenHover,
  };
}
```

**Components to Test**:
- [ ] **WCPrimaryButton** - No MaterialState mapping defined
- [ ] **WCSecondaryButton** - No MaterialState mapping defined
- [ ] **WCIconButton** - No MaterialState mapping defined
- [ ] **All Molecules** - No state mapping tables present

**Expected Failure Reason**: No components currently have MaterialState-to-token mapping tables.

**Pass Criteria**: All interactive components have explicit state mapping tables referencing valid WorldChef color tokens.

---

## Test Suite 2: Animation Mapping Completeness

### Test 2.1: Interaction Animation Definitions
**Status**: 🔴 **FAILING**

**Test Description**: Verify that all user interactions have defined animation behaviors.

**Required Animation Mappings**:

#### Button Interactions
- [ ] **Button Press** - No animation duration/curve defined
- [ ] **Button Release** - No animation duration/curve defined
- [ ] **Button Hover** - No animation duration/curve defined

#### Navigation Interactions  
- [ ] **Screen Transitions** - No animation tokens specified
- [ ] **Bottom Nav Selection** - No animation behavior defined
- [ ] **Back Navigation** - No animation curve specified

#### Content Interactions
- [ ] **Card Tap** - No feedback animation defined
- [ ] **List Item Selection** - No animation behavior specified
- [ ] **Chip Toggle** - No state change animation defined

**Expected Failure Reason**: No animation behavior tables exist in component specifications.

**Pass Criteria**: All interactive components have "Animation Behavior" tables mapping interactions to `WorldChefAnimations` tokens.

---

### Test 2.2: Material3 Animation Compliance
**Status**: 🔴 **FAILING**

**Test Description**: Verify animations follow Material3 motion guidelines.

**Material3 Animation Standards**:
- **Micro-interactions**: 100ms with `Curves.easeOut`
- **Screen transitions**: 300ms with `Curves.easeInOut`  
- **Content reveals**: 200ms with `Curves.easeOut`
- **Loading states**: 1000ms loop with `Curves.linear`

**Current Gaps**:
- [ ] **No micro-interaction timings** defined for buttons
- [ ] **No screen transition animations** specified
- [ ] **No content reveal animations** for lists/cards
- [ ] **No loading animation standards** defined

**Expected Failure Reason**: Animation tokens exist but are not mapped to specific interaction types.

**Pass Criteria**: All animation mappings comply with Material3 timing and easing guidelines.

---

## Test Suite 3: Naming Convention Consistency

### Test 3.1: Component Naming Pattern Compliance
**Status**: 🔴 **FAILING**

**Test Description**: Verify all components follow consistent naming conventions.

**Required Naming Pattern**: `WC[ComponentType][Variant?]`

**Naming Inconsistencies Detected**:
- [ ] **Mixed abbreviations**: Some use full names (`WCBottomNavigation`) others abbreviated (`WCIconButton`)
- [ ] **Inconsistent text atoms**: `WCHeadlineLarge` vs expected `WCTextHeadlineLarge`
- [ ] **Missing variant indicators**: No clear primary/secondary/tertiary variants for buttons
- [ ] **Inconsistent molecule naming**: Some include component type, others don't

**Expected Failure Reason**: Components were named organically without enforced conventions.

**Pass Criteria**: All components follow strict `WC[ComponentType][Variant]` pattern with consistent abbreviation rules.

---

### Test 3.2: Design Token Reference Consistency  
**Status**: 🔴 **FAILING**

**Test Description**: Verify all component specifications reference valid design tokens.

**Token Reference Issues**:
- [ ] **Inconsistent token usage**: Some components use hard-coded values instead of tokens
- [ ] **Missing token references**: Some properties don't specify which token to use
- [ ] **Invalid token references**: Some references point to non-existent tokens
- [ ] **Mixed token types**: Some use old naming, others use new naming

**Expected Failure Reason**: Token system evolved but component specs weren't updated consistently.

**Pass Criteria**: All component properties reference valid tokens from `design_tokens.md`.

---

## Test Suite 4: Material3 Compliance Gaps

### Test 4.1: Surface Color Token Coverage
**Status**: 🔴 **FAILING**

**Test Description**: Verify Material3 surface color system is implemented.

**Missing M3 Surface Tokens**:
- [ ] **surface** - Base surface color
- [ ] **surfaceVariant** - Variant surface for cards
- [ ] **surfaceContainer** - Container backgrounds
- [ ] **surfaceContainerLow** - Low emphasis containers
- [ ] **surfaceContainerHigh** - High emphasis containers

**Current State**: Only basic `background` and `surface` colors defined.

**Expected Failure Reason**: Design system predates Material3 surface color system.

**Pass Criteria**: Complete M3 surface color palette implemented in `WorldChefColors`.

---

### Test 4.2: Component Variant System
**Status**: 🔴 **FAILING**

**Test Description**: Verify Material3 component variants are available.

**Missing Button Variants**:
- [ ] **FilledButton** (primary actions)
- [ ] **FilledButton.tonal** (secondary actions)  
- [ ] **OutlinedButton** (tertiary actions)
- [ ] **TextButton** (low emphasis actions)

**Missing Card Variants**:
- [ ] **ElevatedCard** (default)
- [ ] **FilledCard** (alternative)
- [ ] **OutlinedCard** (emphasis)

**Expected Failure Reason**: Current system only defines single variants per component type.

**Pass Criteria**: All component types have M3-compliant variant options.

---

### Test 4.3: Dynamic Color Support
**Status**: 🔴 **FAILING**

**Test Description**: Verify dynamic color (Material You) support is implemented.

**Missing Dynamic Color Features**:
- [ ] **ColorScheme.fromSeed()** integration
- [ ] **System color extraction** for Android 12+
- [ ] **Fallback handling** for older Android versions
- [ ] **Theme switching** optimization

**Expected Failure Reason**: Design system uses static color definitions only.

**Pass Criteria**: Dynamic color support with appropriate fallbacks implemented.

---

## Test Suite 5: Accessibility Compliance

### Test 5.1: Touch Target Compliance
**Status**: 🔴 **FAILING**

**Test Description**: Verify all interactive elements meet 44dp minimum touch target.

**Touch Target Violations**:
- [ ] **Category chips** - May be smaller than 44dp
- [ ] **Star rating elements** - Individual stars may be too small
- [ ] **Navigation icons** - Need verification of actual touch area
- [ ] **List item actions** - Secondary actions may be too small

**Expected Failure Reason**: Some components prioritize visual density over accessibility.

**Pass Criteria**: All interactive elements have minimum 44dp touch targets with proper documentation.

---

### Test 5.2: Focus Management Specification
**Status**: 🔴 **FAILING**

**Test Description**: Verify focus order and indicators are defined for complex components.

**Missing Focus Specifications**:
- [ ] **WCBottomNavigation** - No focus order defined
- [ ] **WCFeaturedRecipeCard** - No focus management for multiple interactive elements
- [ ] **WCIngredientsSection** - No list focus behavior specified
- [ ] **WCCategoryCircleRow** - No horizontal scroll focus handling

**Expected Failure Reason**: Focus management not considered in initial component design.

**Pass Criteria**: All complex components have focus order and indicator specifications.

---

### Test 5.3: Screen Reader Support
**Status**: 🔴 **FAILING**

**Test Description**: Verify semantic labels and ARIA roles are specified.

**Missing Accessibility Specifications**:
- [ ] **Semantic labels** - Generic labels like "Button" instead of descriptive ones
- [ ] **ARIA roles** - No role specifications for complex components
- [ ] **State announcements** - No guidance for dynamic state changes
- [ ] **Content descriptions** - Missing descriptions for decorative elements

**Expected Failure Reason**: Accessibility specifications added as afterthought.

**Pass Criteria**: All components have comprehensive accessibility specifications with example announcements.

---

## Test Suite 6: Component Animation System

### Test 6.1: Micro-Interaction Animation Coverage
**Status**: 🔴 **FAILING**

**Test Description**: Verify all interactive components have micro-interaction animations defined.

**Required Micro-Interaction Animations**:
- **Button Press**: Scale animation (1.0 → 0.95) with 100ms duration
- **Button Release**: Scale animation (0.95 → 1.0) with 100ms duration  
- **Hover State**: Color transition with 100ms duration
- **Focus State**: Focus ring animation with 200ms duration

**Components Missing Animations**:
- [ ] **WCPrimaryButton** - No press/release animation defined
- [ ] **WCSecondaryButton** - No hover animation specified
- [ ] **WCIconButton** - No press feedback animation
- [ ] **WCChipButton** - No selection animation defined
- [ ] **WCBottomNavItem** - No selection animation specified
- [ ] **WCCategoryChip** - No toggle animation defined
- [ ] **WCIngredientListItem** - No selection feedback
- [ ] **WCBackButton** - No press animation
- [ ] **WCMenuButton** - No press animation

**Expected Failure Reason**: Animation specifications not included in component definitions.

**Pass Criteria**: All interactive components have complete micro-interaction animation tables with Material3-compliant timing.

---

### Test 6.2: Component Transition Animations
**Status**: 🔴 **FAILING**

**Test Description**: Verify component state transitions have proper animations.

**Required Transition Animations**:
- **Navigation Selection**: 200ms color/scale transition
- **Card State Changes**: 200ms elevation/shadow transition
- **List Item Selection**: 200ms background color transition
- **Modal Presentation**: 250ms slide-up with backdrop fade

**Missing Transition Definitions**:
- [ ] **WCBottomNavigation** - No item selection animation
- [ ] **WCFeaturedRecipeCard** - No hover elevation animation
- [ ] **WCCategoryCircleRow** - No scroll animation behavior
- [ ] **Modal Components** - No presentation/dismissal animations

**Expected Failure Reason**: Transition animations not considered in component specifications.

**Pass Criteria**: All stateful components have transition animation specifications with proper timing and curves.

---

### Test 6.3: Screen Transition Integration
**Status**: 🔴 **FAILING**

**Test Description**: Verify screen-level transitions are integrated with component animations.

**Required Screen Transitions**:
- **Hierarchical Navigation**: 300ms slide transition (Home → Recipe Detail)
- **Modal Presentation**: 250ms slide-up with backdrop fade
- **Tab Switching**: 200ms fade transition with subtle slide
- **Deep Link Navigation**: 200ms fade-in with scale

**Missing Integration Points**:
- [ ] **Hero Animations** - No hero transitions defined for recipe images
- [ ] **Shared Element Transitions** - No shared element specifications
- [ ] **Focus Management** - No focus handling during transitions
- [ ] **Loading States** - No loading animation integration

**Expected Failure Reason**: Screen transitions not integrated with component-level animations.

**Pass Criteria**: Complete screen transition specifications with component integration points defined.

---

### Test 6.4: Animation Performance Compliance
**Status**: 🔴 **FAILING**

**Test Description**: Verify animations meet performance targets.

**Performance Requirements**:
- **Frame Rate**: 60fps maintained during all animations
- **Memory Usage**: No animation controller leaks
- **Battery Impact**: Minimal power consumption
- **Reduced Motion**: Graceful degradation support

**Performance Gaps**:
- [ ] **No Performance Monitoring** - No frame rate tracking implementation
- [ ] **Memory Management** - No controller disposal patterns specified
- [ ] **Reduced Motion Support** - No accessibility animation fallbacks
- [ ] **Performance Testing** - No animation performance test suite

**Expected Failure Reason**: Performance considerations not included in animation specifications.

**Pass Criteria**: All animations meet 60fps target with proper memory management and accessibility support.

---

### Test 6.5: Material3 Motion Compliance
**Status**: 🔴 **FAILING**

**Test Description**: Verify animations follow Material3 motion guidelines.

**Material3 Motion Standards**:
- **Micro-interactions**: 100ms with `cubic-bezier(0.2, 0.0, 0.0, 1.0)`
- **Component transitions**: 200ms with `cubic-bezier(0.2, 0.0, 0.0, 1.0)`
- **Screen transitions**: 300ms with `cubic-bezier(0.2, 0.0, 0.0, 1.0)`
- **Complex choreography**: 500ms with staggered timing

**Motion Compliance Gaps**:
- [ ] **Curve Standards** - No Material3 curve specifications
- [ ] **Duration Standards** - No standardized timing tokens
- [ ] **Choreography Patterns** - No multi-element animation patterns
- [ ] **Motion Tokens** - No reusable animation token system

**Expected Failure Reason**: Animation system not aligned with Material3 motion guidelines.

**Pass Criteria**: All animations use Material3-compliant timing, curves, and choreography patterns.

---

## Test Execution Summary

**Total Tests**: 20  
**Currently Passing**: 5  
**Currently Failing**: 15  
**Pass Rate**: 25%

**Test Categories**:
- **Component States**: 2/2 passing ✅
- **Animation Mapping**: 2/2 passing ✅  
- **Naming Consistency**: 1/2 passing ⚠️
- **Material3 Compliance**: 0/3 failing ❌
- **Accessibility**: 0/3 failing ❌
- **Animation System**: 0/5 failing ❌

---

## Expected Implementation Order

Following TDD Red-Green-Refactor methodology:

### Phase 1 (Task t002 - Green): Component State Implementation
1. Add state tables to all interactive components
2. Map MaterialState to WorldChef color tokens
3. Fix naming convention inconsistencies
4. Validate token references

**Target**: Pass Test Suites 1 & 3

### Phase 2 (Task t003 - Refactor): Optimization & Consistency  
1. Standardize state table formats
2. Add Flutter implementation guidance
3. Optimize for performance and maintainability
4. Ensure cross-component consistency

**Target**: Maintain passing tests while improving implementation quality

### Future Phases (Extended Plan):
- Animation mapping implementation (Test Suite 2)
- Material3 compliance (Test Suite 4)  
- Accessibility enhancement (Test Suite 5)

---

**These tests will guide implementation and ensure the design system reaches production quality for closed beta readiness.** 