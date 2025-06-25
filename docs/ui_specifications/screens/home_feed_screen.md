# Home Feed Screen Specification

**Status**: 🔴 **Specification Required**  
**Created**: 2025-06-24  
**Plan Task**: t005 (IMPLEMENTATION)  
**Test Task**: t004 (TEST_CREATION - must create failing tests first)  
**Mobile Plan Reference**: tasks t001-t003

---

## Overview

The Home Feed screen is the primary discovery interface for WorldChef, displaying a paginated list of recipes with filtering capabilities. This specification defines every aspect of the screen's layout, interactions, states, and behavior.

## ⚠️ Current Status: SPECIFICATION REQUIRED

**This document is a placeholder that defines the required structure.**

**Before implementation, the following must be completed:**
1. **Task t004**: Create failing validation tests for Home Feed screen
2. **Design System**: Complete design tokens specification (tasks t001-t003)
3. **Component Library**: Define RecipeCard component specifications (tasks t007-t009)
4. **Stakeholder Input**: Resolve layout and interaction requirements

## Screen Requirements (From MVP Feature Set)

### Functional Requirements
- Display paginated list of public recipes
- Support filtering by cuisine and dietary tags
- Implement pull-to-refresh functionality
- Support infinite scroll/pagination
- Display recipe cards with essential information
- Navigate to recipe detail on card tap
- Support search functionality
- Handle offline states gracefully

### Performance Requirements (From aiconfig.json)
- Maintain ≥58 FPS during scrolling
- Time to Interactive (TTI) ≤1.5 seconds
- Smooth pull-to-refresh with <50ms response time
- Efficient image loading and caching

## Specification Structure (To Be Implemented)

### 1. Layout Specification

#### Screen Anatomy
```
┌─────────────────────────────────────┐
│ App Bar                             │ ← 56dp height
├─────────────────────────────────────┤
│ Search Bar (Optional)               │ ← 48dp height, 16dp margins
├─────────────────────────────────────┤
│ Filter Chips (Horizontal Scroll)    │ ← 40dp height, 8dp spacing
├─────────────────────────────────────┤
│ Recipe List (Vertical Scroll)       │
│ ┌─────────────────────────────────┐ │
│ │ Recipe Card                     │ │ ← Card specifications TBD
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ Recipe Card                     │ │
│ └─────────────────────────────────┘ │
│ ...                                 │
│ ┌─────────────────────────────────┐ │
│ │ Loading Indicator / End Message │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

#### Responsive Behavior
- **Portrait**: Single column layout with full-width cards
- **Landscape**: TBD - requires stakeholder input
- **Tablet**: TBD - requires stakeholder input

### 2. Component Specifications

#### App Bar
- **Height**: 56dp (Material Design 3 standard)
- **Background**: Surface color with elevation
- **Title**: "WorldChef" (centered or left-aligned - TBD)
- **Actions**: Search icon, profile icon
- **Elevation**: 0dp when scrolled to top, 4dp when scrolled

#### Search Bar (Expandable)
- **Default State**: Search icon in app bar
- **Expanded State**: Full-width search input
- **Height**: 48dp when expanded
- **Margins**: 16dp horizontal
- **Placeholder**: "Search recipes..." (requires i18n)

#### Filter Chips
- **Container**: Horizontal scrollable list
- **Chip Height**: 32dp
- **Chip Spacing**: 8dp between chips
- **Margins**: 16dp horizontal, 8dp vertical
- **Types**: Cuisine filters, dietary filters, "Clear All"

#### Recipe List
- **Implementation**: ListView.builder for performance
- **Item Spacing**: 16dp between cards
- **Margins**: 16dp horizontal
- **Pagination**: Load 20 items per page
- **Infinite Scroll**: Load next page when 3 items from bottom

### 3. Recipe Card Specification

**⚠️ DEPENDENCY**: Requires completion of component library specification (tasks t007-t009)

#### Required Information Display
- Recipe image (aspect ratio TBD)
- Recipe title
- Creator name/avatar
- Cooking time
- Difficulty level
- Rating/likes count
- Dietary tags (if applicable)

#### Interaction States
- **Default**: Standard elevation and colors
- **Pressed**: Reduced elevation, overlay color
- **Loading**: Skeleton animation or shimmer effect

### 4. State Specifications

#### Loading States
1. **Initial Load**: Skeleton cards or loading spinner (TBD)
2. **Pull-to-Refresh**: Standard Material Design refresh indicator
3. **Pagination Load**: Bottom loading indicator
4. **Image Loading**: Progressive image loading with placeholders

#### Error States
1. **Network Error**: Error message with retry button
2. **Empty Results**: Empty state illustration with message
3. **Search No Results**: Search-specific empty state

#### Offline States
1. **Cached Content**: Display cached recipes with offline indicator
2. **No Cache**: Offline message with explanation

### 5. Interaction Specifications

#### Navigation Patterns
- **Recipe Card Tap**: Navigate to Recipe Detail screen
- **Search Icon Tap**: Expand search bar or navigate to Search screen (TBD)
- **Filter Chip Tap**: Apply/remove filter, update list
- **Pull-to-Refresh**: Refresh recipe list from server

#### Animation Specifications
- **Screen Transition**: Standard Material Design navigation transition
- **Filter Application**: Smooth list update with fade transition
- **Card Interactions**: Material Design ripple effect
- **Loading States**: Skeleton shimmer or spinner rotation

### 6. Accessibility Requirements

#### Screen Reader Support
- App bar title announced as heading
- Recipe cards announced with all essential information
- Filter chips announced with current selection state
- Loading states announced appropriately

#### Focus Management
- Logical tab order through interactive elements
- Focus indicators on all interactive elements
- Focus restored appropriately after navigation

#### Color Contrast
- All text meets WCAG AA contrast requirements
- Interactive elements have sufficient contrast
- Focus indicators are clearly visible

### 7. Internationalization Requirements

#### Text Externalization
- All user-visible strings externalized to ARB files
- Support for pluralization (e.g., "1 recipe" vs "2 recipes")
- Support for string interpolation (e.g., "Cooking time: {time}")

#### RTL Layout Support
- Layout mirrors correctly for RTL languages
- Text alignment adjusts appropriately
- Icon positioning adjusts for RTL

## Implementation Dependencies

### Required Components (From Component Library)
- RecipeCard (with all variants and states)
- SearchBar (expandable)
- FilterChip (selectable)
- LoadingIndicator (various types)
- ErrorState (with retry functionality)
- EmptyState (with illustration)

### Required Providers (From State Management)
- RecipeListProvider (AsyncNotifier with pagination)
- FilterProvider (for cuisine/dietary filters)
- SearchProvider (for search functionality)
- OfflineProvider (for connectivity status)

## Related Files

- **Tests**: `docs/ui_specifications/validation/screen_validation_tests.md`
- **Components**: `docs/ui_specifications/design_system/component_specifications.md`
- **User Flow**: `docs/ui_specifications/user_flows/discovery_flow.md`
- **Mobile Plan**: `plans/plan_cycle4_mobile_mvp.txt` (tasks t001-t003)
- **API Mapping**: `docs/cycle4/mvp_feat_set.md`

---

**⚠️ BLOCKING DEPENDENCIES**: 
1. Design system completion (tasks t001-t003)
2. Component library specification (tasks t007-t009)
3. Failing validation tests creation (task t004)
4. Stakeholder input on layout decisions and image specifications 