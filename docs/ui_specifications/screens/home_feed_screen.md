# Home Feed Screen Specification (MVP v0.2)

**Status**: ✅ **NORMALIZED**  
**Updated**: 2025-06-26  
**Plan Task**: t005-B (Home Feed Screen Layout Refinement)  
**Design System**: References `docs/ui_specifications/design_system/*.md`

---

## 1. Purpose
The home feed is the primary discovery interface, featuring category-based navigation, country-specific recipe collections, and diet-based filtering to help users quickly find relevant recipes.

## 2. Layout Structure

### Visual Layout
```
+------------------------------------------------+
| WCAppBarHeader (implicitly, blue background)   |
+------------------------------------------------+
| WCCategoryCircleRow (Horizontal Scroll)        |
| [ WCCircularImage ] [ WCCircularImage ] ...    |
+------------------------------------------------+
| WCCountrySection                               |
| (WCSectionHeader + WCCountryThumbnailGrid)     |
| [ WCThumbnailImage ] [ WCThumbnailImage ] ...  |
+------------------------------------------------+
| WCDietSection                                  |
| (WCSectionHeader + WCFeaturedRecipeCard)       |
| [       WCFeaturedRecipeCard        ]          |
+------------------------------------------------+
| WCBottomNavigation                             |
+------------------------------------------------+
```

## 3. Detailed Component Specifications

### 3.1 Status Bar & Header Area
| Component | Property | Value | Design Token Reference |
|-----------|----------|-------|------------------------|
| `(Implicit)` | Background Color | Blue gradient/solid | `WorldChefColors.brandBlue` |
| `(Implicit)` | Text Color | White | `ColorScheme.onPrimary` |
| `(Implicit)` | Height | System default | System managed |

### 3.2 `WCCategoryCircleRow` (Organism)
*A horizontally scrolling row of category circles.*
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Background | Transparent | - |
| Padding | Horizontal 16dp | `WorldChefSpacing.lg` |
| Item Spacing | 8dp between circles | `WorldChefSpacing.sm` |

#### `WCCircularImage` (Atom)
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Size | 60dp × 60dp | `WorldChefDimensions.categoryCircleSize` |
| Text Overlay | Category name | `WCLabelSmall` |
| Text Color | White with shadow | `ColorScheme.onPrimary` |

#### "Create New" Button
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Background | Dotted border circle | `WorldChefColors.brandBlue` (border) |
| Icon | Plus symbol | `WCIconMedium` |
| Size | 60dp × 60dp | `WorldChefDimensions.categoryCircleSize` |

### 3.3 `WCCountrySection` (Organism)
*A section containing a header and a grid of country thumbnails.*

#### `WCSectionHeader` (Molecule)
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Section Title | "Taste by Country" | `WCHeadlineSmall` |
| Title Color | Black | `WorldChefNeutrals.primaryText` |
| "View all" Link | Right-aligned | `WorldChefColors.brandBlue` |
| Container Padding | 16dp horizontal | `WorldChefSpacing.lg` |

#### `WCCountryThumbnailGrid` (Organism)
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Layout | 4 columns, equal width | - |
| Spacing | 8dp between items | `WorldChefSpacing.sm` |

#### `WCThumbnailImage` (Atom)
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Aspect Ratio | 1:1 (square) | `WorldChefMedia.squareRatio` |
| Border Radius | 8dp | `WorldChefDimensions.radiusMedium` |
| Label | Flag emoji + Country Name | `WCFlagCountryLabel` (Molecule) |

### 3.4 `WCDietSection` (Organism)
*A section containing a header and a featured recipe card.*

#### `WCSectionHeader` (Molecule)
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Section Title | "Taste by Diet" | `WCHeadlineSmall` |

#### `WCFeaturedRecipeCard` (Organism)
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Layout | Single large card | Full width minus container padding |
| Aspect Ratio | 4:3 | `WorldChefMedia.horizontalRatio` |
| Border Radius | 12dp | `WorldChefDimensions.radiusLarge` |
| Recipe Title | "Protein muffins" | `WCHeadlineMedium` |
| Creator Info | "Chef Muscle" + Favorite Icon | `WCCreatorInfoRow` (Molecule) |
| Category Chips | Icon + Text | `WCCategoryChip` (Molecule) |
| Star Rating | Stars + Count | `WCStarRatingDisplay` (Molecule) |

### 3.5 `WCBottomNavigation` (Organism)
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Height | 56dp | `WorldChefDimensions.bottomNavHeight` |
| Background | Blue gradient/solid | `WorldChefColors.brandBlue` |
| Active Item | "feed" (highlighted) | `WCBottomNavItem` (Molecule) |
| Icon Size | 24dp | `WCIconMedium` |
| Label Style | Below icons | `WCLabelSmall` |

## 4. Interactions

### 4.1 `WCCategoryCircleRow` Interactions
1. **Tap `WCCircularImage`** → Filter feed to show only that category.
2. **Tap "Create +" button** → Navigate to recipe creation flow.
3. **Horizontal scroll** → Reveal additional categories.

### 4.2 `WCCountrySection` Interactions
1. **Tap `WCThumbnailImage`** → Navigate to country-specific recipe list.
2. **Tap "View all" in `WCSectionHeader`** → Navigate to full country browse page.

### 4.3 `WCDietSection` Interactions
1. **Tap `WCFeaturedRecipeCard`** → Navigate to Recipe Detail screen.
2. **Tap favorite icon in `WCCreatorInfoRow`** → Toggle favorite status (optimistic update).
3. **Tap `WCCategoryChip`** → Filter recipes by that category.

### 4.4 `WCBottomNavigation` Interactions
1. **Tap any `WCBottomNavItem`** → Navigate to corresponding screen.

## 5. Responsive Behavior

### 5.1 Screen Size Adaptations
| Screen Width | `WCCategoryCircleRow` | `WCCountryThumbnailGrid` | Adjustments |
|--------------|-----------------------|--------------------------|-------------|
| 320-375dp    | 4 visible + scroll    | 4 columns                | `WorldChefSpacing.sm` |
| 375dp+       | 5+ visible            | 4 columns                | `WorldChefSpacing.md` |

### 5.2 Content Loading
| State | Visual Behavior | Duration |
|-------|-----------------|----------|
| Initial Load | Skeleton loaders shimmer | Until data arrives |
| Category Switch | Crossfade transition | `WorldChefAnimations.short` (200ms) |
| Pull-to-Refresh | Standard iOS/Android pattern | System default |

## 6. States & Error Handling

### 6.1 Loading State
| Component | Loading Visual | Animation |
|-----------|----------------|-----------|
| `WCCategoryCircleRow` | Shimmering circles | `WorldChefAnimations.shimmer` |
| `WCCountryThumbnailGrid` | Shimmering squares | `WorldChefAnimations.shimmer` |
| `WCFeaturedRecipeCard` | Shimmering rectangle | `WorldChefAnimations.shimmer` |

### 6.2 Error State
| Scenario | Error Visual | Recovery Action |
|----------|--------------|-----------------|
| API Fails | Full-screen error message | "Retry" button |
| Network Offline | Global offline banner | Auto-retry when connection returns |

### 6.3 Empty State
| Scenario | Empty State Visual | Call to Action |
|----------|--------------------|----------------|
| No Recipes in Feed | Illustration + "Nothing to see here!" | "Explore other categories" button |
| No Search Results | Illustration + "No recipes match your search" | "Clear Search" button |

## 7. Accessibility

### 7.1 Screen Reader Support
| Element | Semantic Label | Role |
|---------|----------------|------|
| `WCCircularImage` | "Browse [category] recipes" | Button |
| `WCThumbnailImage` | "View [country] recipes" | Button |
| `WCFeaturedRecipeCard` | "[Recipe name] by [creator]" | Button |
| Favorite Button | "Add to favorites" / "Remove from favorites" | Toggle Button |
| Star Rating | "Rated [n] out of 5 stars" | Rating |
| Ratings Count | "[number] ratings" | Text |
| `WCCategoryChip` | "[Category name] category" | Chip/Button |
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