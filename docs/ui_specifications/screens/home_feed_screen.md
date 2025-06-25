# Home Feed Screen Specification (MVP v0.2)

**Status**: ✅ **REFINED** – Updated to match visual design  
**Updated**: 2025-06-25  
**Plan Task**: t005-B (Home Feed Screen Layout Refinement)  
**Design System**: References `docs/ui_specifications/design_system/design_tokens.md`

---

## 1. Purpose
The home feed is the primary discovery interface, featuring category-based navigation, country-specific recipe collections, and diet-based filtering to help users quickly find relevant recipes.

## 2. Layout Structure

### Visual Layout (Based on Screenshot)
```
+------------------------------------------------+
| Blue Background                                |
+                                                +
| Category Navigation Row (Horizontal Scroll)   |
| [ circles:] [      ] [        ] [        ]    |
| [Breakfast] [Dinner] [Desserts] [Create +]    |
| [         ] [      ] [        ] [        ]   |
+------------------------------------------------+
| "Taste by Country" Section                    |
| View all >                                     |
| [ rounded]  [ squares ]   [          ] [          ] |
| [image   ]  [ image   ]   [ image    ] [  image  ]|
| [(flag emoji/icon: 🇲🇽) Mexico] [🇯🇲 Jamaica ] [🇫🇷 France ] [ 🇳🇬 Nigeria] |  
+------------------------------------------------+
| "Taste by Diet" Section                       |
| View all >                                     |
+------------------------------------------------+
| Protein muffins                  🇺🇸 America    |
|                                               |
| [                            ]                |
| [Large Recipe Card with Image]                |
| [Chef Muscle ♡ <- (creator)   ]               |
|                                               |
| [chip category 1(dumbell icon)][2][3]   [ n/5 star rating] [ratings]      |
|                                               |
+------------------------------------------------+
| Blue background                                |
|Bottom Navigation                               |
| [feed] [Explore] [ + ] [Plans] [You]           |
+------------------------------------------------+
```

## 3. Detailed Component Specifications

### 3.1 Status Bar Area
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Background Color | Blue gradient/solid | `WorldChefColors.brandBlue` |
| Text Color | White | System default on primary |
| Height | System default (~44dp) | System managed |

### 3.2 Category Navigation Row
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Background | Transparent | - |
| Padding | Horizontal 16dp | `WorldChefLayout.mobileContainerPadding` |
| Scroll Direction | Horizontal | - |
| Item Spacing | 8dp between circles | `WorldChefSpacing.sm` |

#### Category Circle Buttons
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Size | 60dp × 60dp | Custom (larger than standard touch target) |
| Shape | Perfect circle | `borderRadius: 30dp` |
| Background Images | Food category photos | - |
| Text Overlay | Category name | `WorldChefTextStyles.labelSmall` |
| Text Color | White with shadow/overlay | Ensure contrast ≥4.5 |
| Touch Target | 60dp (meets minimum) | `WorldChefDimensions.minimumTouchTarget` |

#### "Create New Recipe" Button
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Background | Dotted border circle | `WorldChefColors.brandBlue` (border) |
| Icon | Plus symbol | `WorldChefDimensions.iconMedium` (24dp) |
| Size | 60dp × 60dp | Match category circles |
| Border Style | Dashed/dotted | 2dp width |

### 3.3 "Taste by Country" Section
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Section Title | "Taste by Country" | `WorldChefTextStyles.headlineSmall` |
| Title Color | Black | `WorldChefNeutrals.primaryText` |
| "View all" Link | Right-aligned | `WorldChefColors.brandBlue` |
| Container Padding | 16dp horizontal | `WorldChefLayout.mobileContainerPadding` |
| Vertical Spacing | 24dp from categories | `WorldChefLayout.headlineToGrid` |

#### Country Recipe Thumbnails
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Layout | 4 columns, equal width | - |
| Overall Structure | Image + Flag/Name row | Two-part vertical layout |
| Aspect Ratio | 1:1 (square) | `WorldChefMedia.squareRatio` |
| Spacing | 8dp between items | `WorldChefLayout.tightGridGutter` |
| Border Radius | 8dp | `WorldChefDimensions.radiusMedium` |

#### Country Thumbnail Components
| Component | Position | Styling | Design Token Reference |
|-----------|----------|---------|------------------------|
| Food Image | Top portion | Covers ~75% of thumbnail | Background image |
| Flag Icon/Emoji | Bottom left | 16dp emoji/icon | System emoji or `WorldChefDimensions.iconSmall` |
| Country Name | Bottom, after flag | Following flag with 4dp spacing | `WorldChefTextStyles.labelSmall` |
| Background | Bottom portion | Semi-transparent overlay | For text contrast |
| Text Color | Country name | White with shadow | Ensure contrast ≥4.5 |

#### Country Layout Examples
| Country | Flag | Display Format |
|---------|------|----------------|
| Mexico | 🇲🇽 | "🇲🇽 Mexico" |
| Jamaica | 🇯🇲 | "🇯🇲 Jamaica" |
| France | 🇫🇷 | "🇫🇷 France" |
| Nigeria | 🇳🇬 | "🇳🇬 Nigeria" |

### 3.4 "Taste by Diet" Section
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Section Title | "Taste by Diet" | `WorldChefTextStyles.headlineSmall` |
| Title Color | Black | `WorldChefNeutrals.primaryText` |
| "View all" Link | Right-aligned | `WorldChefColors.brandBlue` |
| Container Padding | 16dp horizontal | `WorldChefLayout.mobileContainerPadding` |
| Vertical Spacing | 32dp from country section | `WorldChefLayout.gridToGrid` |

#### Featured Recipe Card (Protein Muffins)
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Layout | Single large card | Full width minus container padding |
| Aspect Ratio | 4:3 | `WorldChefMedia.horizontalRatio` |
| Border Radius | 12dp | `WorldChefDimensions.radiusLarge` |
| Image | High-quality food photo | Cover entire card area |
| Gradient Overlay | Bottom-to-top dark gradient | For text contrast |

#### Recipe Card Text Overlays
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Recipe Title | "Protein muffins" | `WorldChefTextStyles.headlineMedium` |
| Title Color | White | Ensure contrast ≥4.5 |
| Country Info | "🇺🇸 America" | `WorldChefTextStyles.bodySmall` |
| Country Color | White with reduced opacity | 80% opacity |
| Creator Info | "Chef Muscle" | `WorldChefTextStyles.bodyMedium` |
| Creator Color | White | Ensure contrast ≥4.5 |
| Favorite Icon | Heart outline | `WorldChefDimensions.iconMedium` |

#### Card Content Positioning
| Element | Position | Padding |
|---------|----------|---------|
| Recipe Title | Top left | 16dp from edges |
| Country Info | Top right | 16dp from edges |
| Main Image | Center | Full card width |
| Creator Info | Bottom left | 16dp from edges |
| Favorite Icon | Bottom right (creator row) | 8dp from creator text |

#### Category Chips & Rating Row
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Position | Below creator info | 8dp spacing from creator |
| Layout | Chips on left, rating on right | Space-between layout |

#### Category Chips (Left Side)
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Chip Style | Rounded rectangles | `WorldChefDimensions.radiusSmall` |
| Chip Background | Semi-transparent white | 20% opacity |
| Chip Text | Category name | `WorldChefTextStyles.labelSmall` |
| Chip Icon | Category icon (e.g., dumbbell) | `WorldChefDimensions.iconSmall` (16dp) |
| Chip Spacing | 8dp between chips | `WorldChefSpacing.sm` |
| Chip Padding | 4dp vertical, 8dp horizontal | Custom |

#### Star Rating & Count (Right Side)
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Star Rating | 5-star display (filled/outlined) | n/5 format |
| Star Size | 16dp per star | `WorldChefDimensions.iconSmall` |
| Star Color | Yellow/Gold for filled | `WorldChefColors.accentOrange` |
| Star Spacing | 2dp between stars | Tight spacing |
| Rating Text | "n/5" format | `WorldChefTextStyles.labelSmall` |
| Ratings Count | "(ratings)" or review count | `WorldChefTextStyles.labelSmall` |
| Text Color | White with shadow | Ensure contrast ≥4.5 |
| Rating Spacing | 4dp between rating and count | `WorldChefSpacing.xs` |

### 3.5 Bottom Navigation
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Height | 56dp | `WorldChefDimensions.bottomNavHeight` |
| Background | Blue gradient/solid | `WorldChefColors.brandBlue` |
| Active Item | "feed" (highlighted) | Highlighted on blue background |
| Inactive Items | White | On blue background |
| Icon Size | 24dp | `WorldChefDimensions.iconMedium` |
| Labels | Below icons | `WorldChefTextStyles.labelSmall` |

#### Bottom Navigation Items
| Position | Label | Icon | Function |
|----------|-------|------|----------|
| 1 | "feed" | Home/Grid icon | Main feed (current screen) |
| 2 | "Explore" | Search/Compass icon | Discovery and search |
| 3 | "+" | Plus icon | Quick create action |
| 4 | "Plans" | Calendar/List icon | Meal planning |
| 5 | "You" | Profile/Person icon | User profile |

## 4. Interactions

### 4.1 Category Navigation
1. **Tap category circle** → Filter feed to show only that category
2. **Tap "Create +"** → Navigate to recipe creation flow
3. **Horizontal scroll** → Reveal additional categories (if any)

### 4.2 Country Section
1. **Tap country thumbnail** → Navigate to country-specific recipe list
2. **Tap "View all"** → Navigate to full country browse page

### 4.3 Diet Section
1. **Tap recipe card** → Navigate to Recipe Detail screen
2. **Tap favorite icon** → Toggle favorite status (optimistic update)
3. **Tap category chip** → Filter recipes by that category
4. **Tap star rating** → Navigate to Recipe Detail screen (reviews section)
5. **Tap "View all"** → Navigate to diet-based recipe list

### 4.4 Bottom Navigation
1. **Tap any nav item** → Navigate to corresponding screen
2. **Tap "+" FAB** → Quick action menu or recipe creation

## 5. Responsive Behavior

### 5.1 Screen Size Adaptations
| Screen Width | Category Circles | Country Grid | Adjustments |
|--------------|------------------|--------------|-------------|
| 320-375dp | 4 visible + scroll | 4 columns | Tight spacing |
| 375-414dp | 4-5 visible | 4 columns | Standard spacing |
| 414dp+ | 5+ visible | 4 columns | Comfortable spacing |

### 5.2 Content Loading
| State | Visual Behavior | Duration |
|-------|----------------|----------|
| Initial Load | Skeleton cards shimmer | Until data loads |
| Category Switch | Crossfade transition | 200ms |
| Pull-to-Refresh | Standard iOS/Android pattern | System default |

## 6. States & Error Handling

### 6.1 Loading States
| Component | Loading Visual | Animation |
|-----------|----------------|-----------|
| Category Circles | Shimmer circles | `WorldChefAnimations.shimmer` |
| Country Thumbnails | Shimmer squares | `WorldChefAnimations.shimmer` |
| Recipe Cards | Shimmer rectangles | `WorldChefAnimations.shimmer` |

### 6.2 Empty States
| Section | Empty State | Action |
|---------|-------------|--------|
| Country Recipes | "No recipes for this country yet" | "Explore other countries" button |
| Diet Recipes | "No recipes match this diet" | "View all recipes" button |
| General Error | "Oops! We couldn't load your recipes." | "Try again" button |

### 6.3 Offline Behavior
| Scenario | Behavior | Visual Indicator |
|----------|----------|------------------|
| Cached Content | Show cached recipes | Subtle offline banner |
| No Cache | Show offline message | Full-screen offline state |
| Action Attempt | Show "Cannot perform action" toast | Retry when online |

## 7. Accessibility

### 7.1 Screen Reader Support
| Element | Semantic Label | Role |
|---------|----------------|------|
| Category Circles | "Browse [category] recipes" | Button |
| Country Thumbnails | "View [country] recipes" | Button |
| Recipe Cards | "[Recipe name] by [creator]" | Button |
| Favorite Button | "Add to favorites" / "Remove from favorites" | Toggle Button |
| Star Rating | "Rated [n] out of 5 stars" | Rating |
| Ratings Count | "[number] ratings" | Text |
| Category Chips | "[Category name] category" | Chip/Button |
| Navigation Items | "[Page name] tab" | Tab |

### 7.2 Color Contrast
- All text overlays must meet WCAG AA (4.5:1 contrast ratio)
- Favorite icon must have sufficient contrast on all backgrounds
- Navigation icons must meet contrast requirements

### 7.3 Touch Targets
- All interactive elements meet 44dp minimum touch target
- Category circles (60dp) exceed minimum requirements
- Adequate spacing between touch targets to prevent mis-taps

## 8. Performance Requirements

### 8.1 Rendering Targets
| Metric | Target | Measurement Point |
|--------|--------|-------------------|
| Initial Render | ≤ 300ms | Time to first meaningful paint |
| Image Loading | ≤ 500ms | Category circles and recipe cards |
| Scroll Performance | 60fps | Maintained during scroll |
| Transition Performance | 60fps | Category switches and navigation |

### 8.2 Memory Management
- Lazy load off-screen recipe cards
- Cache category images for instant switching
- Optimize image sizes for screen density

## 9. Implementation Notes

### 9.1 Flutter Widget Structure
```dart
Scaffold(
  body: CustomScrollView(
    slivers: [
      SliverAppBar(), // If using app bar
      SliverToBoxAdapter(child: CategoryNavigationRow()),
      SliverToBoxAdapter(child: CountrySection()),
      SliverToBoxAdapter(child: DietSection()),
      // Additional sections as needed
    ],
  ),
  bottomNavigationBar: WorldChefBottomNavigation(),
)
```

### 9.2 State Management
- Use `AsyncNotifierProvider` for recipe data
- Use `NotifierProvider` for category selection
- Implement optimistic updates for favorites
- Cache strategy for offline support

---

**Status**: ✅ **SPECIFICATION COMPLETE**  
**Next Step**: Implementation using Flutter with design tokens  
**Dependencies**: Design system implementation (Task t002) 