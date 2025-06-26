# Recipe Detail Screen Specification (MVP v0.2)

**Status**: ✅ **NORMALIZED**  
**Updated**: 2025-06-26  
**Plan Task**: t005-C (Recipe Detail Screen Layout Refinement)  
**Design System**: References `docs/ui_specifications/design_system/*.md`

---

## 1. Purpose
The recipe detail screen displays comprehensive recipe information, including a hero image, creator details, cooking time, nutrition facts, and an ingredients list. It provides the primary "Start Cooking" action and social interaction features.

## 2. Layout Structure

### Visual Layout
```
+------------------------------------------------+
| WCAppBarHeader                                 |
| (← Back) (Creator Name) (Menu ...)             |
+------------------------------------------------+
| WCHeroSection                                  |
| [Large food photography]                       |
| [WCCircularImage] [WCPrimaryButton]            |
+------------------------------------------------+
| WCRecipeHeaderInfo                             |
| (Creator Name + Recipe Title)                  |
+------------------------------------------------+
| WCMetadataRow                                  |
| (Time, Servings)                               |
+------------------------------------------------+
| WCNutritionSection                             |
| (WCSectionHeader + Progress Circles)           |
+------------------------------------------------+
| WCIngredientsSection                           |
| (WCSectionHeader + List of WCIngredientListItem)|
+------------------------------------------------+
| WCBottomNavigation                             |
+------------------------------------------------+
```

## 3. Detailed Component Specifications

### 3.1 `WCAppBarHeader` (Organism)
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Background | White/System | `WorldChefNeutrals.background` |
| Height | 56dp | `WorldChefDimensions.appBarHeight` |
| Back Button | iOS-style chevron left | `WCBackButton` (Molecule) |
| Creator Name | "ChefSannikay" | `WCHeadlineSmall` |
| Menu Button | Three dots (vertical) | `WCMenuButton` (Molecule) |
| Text Color | Black | `WorldChefNeutrals.primaryText` |

### 3.2 `WCHeroSection` (Organism)
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Aspect Ratio | 4:3 | `WorldChefMedia.horizontalRatio` |
| Creator Image | 48dp circle with border | `WCCircularImage` (Atom) |
| Start Button | Rounded rectangle | `WCPrimaryButton` (Atom) |

### 3.3 `WCRecipeHeaderInfo` (Molecule)
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Creator Name | "ChefSannikay" | `WCBodyMedium` |
| Recipe Title | "Jollof rice" | `WCHeadlineLarge` |
| Vertical Spacing | 4dp between items | `WorldChefSpacing.xs` |
| Container Padding | 16dp horizontal | `WorldChefSpacing.lg` |

### 3.4 `WCMetadataRow` (Organism)
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Layout | Three-column layout | Evenly distributed |
| Vertical Spacing | 16dp from title | `WorldChefSpacing.md` |
| Item Style | Icon + Text | `WCMetadataItem` (Molecule) |

### 3.5 `WCNutritionSection` (Organism)
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Section Header | "Nutrition facts" + "Full nutrition >" link | `WCSectionHeader` (Molecule) |
| Progress Indicators| 4 circular indicators | `WCCircularProgress` (Atom) |
| Circle Size | 48dp diameter | Custom size |
| Circle Spacing | 12dp between circles | `WorldChefSpacing.md` |

### 3.6 `WCIngredientsSection` (Organism)
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Section Header | "Ingredients" | `WCSectionHeader` (Molecule) |
| List Style | Vertical list | Continuous list items |
| List Item | Icon + Name + Quantity + Chevron | `WCIngredientListItem` (Molecule) |

### 3.7 `WCBottomNavigation` (Organism)
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Height | 56dp | `WorldChefDimensions.bottomNavHeight` |
| Background | Blue gradient/solid | `WorldChefColors.brandBlue` |
| Items | 5 Nav Items | `WCBottomNavItem` (Molecule) |

## 4. Interactions

### 4.1 Header Actions
1. **Tap `WCBackButton`** → Navigate back to the previous screen.
2. **Tap `WCMenuButton`** → Open recipe options menu.

### 4.2 Hero Section Actions
1. **Tap `WCCircularImage` (creator)** → Navigate to the creator's profile.
2. **Tap `WCPrimaryButton` ("Start cooking")** → Navigate to the cooking mode/timer screen.

### 4.3 Nutrition/Ingredients Actions
1. **Tap "Full nutrition" in `WCSectionHeader`** → Navigate to the detailed nutrition screen.
2. **Tap `WCIngredientListItem`** → Navigate to the ingredient detail screen.

## 5. Responsive Behavior

### 5.1 Screen Size Adaptations
| Screen Width | Hero Image | `WCNutritionSection` | Adjustments |
|--------------|------------|----------------------|-------------|
| 320-375dp    | Maintain aspect | 4 circles stacked closer | Compact spacing |
| 375dp+       | Standard aspect | 4 circles with more space | Normal layout |

### 5.2 Content Loading
| State | Visual Behavior | Duration |
|-------|-----------------|----------|
| Initial Load | Hero image fade-in, skeletons | Progressive loading |
| Content Refresh | Crossfade | `WorldChefAnimations.short` |

## 6. States & Error Handling

### 6.1 Loading State
| Component | Loading Visual | Animation |
|-----------|----------------|-----------|
| `WCHeroSection` | Blur-to-sharp image transition | Progressive enhancement |
| `WCRecipeHeaderInfo` | Skeleton text blocks | `WorldChefAnimations.shimmer` |
| `WCNutritionSection` | Empty circles filling up | `WorldChefAnimations.pulse` |
| `WCIngredientsSection`| Skeleton list items | `WorldChefAnimations.shimmer` |

### 6.2 Error State
| Scenario | Error Visual | Recovery Action |
|----------|--------------|-----------------|
| Recipe Not Found | "Recipe not available" message | "Go back" button |
| Image Load Failed | Placeholder image with icon | Retry on tap |
| Ingredients Failed | "Unable to load ingredients" | "Retry" button |
| Network Error | Global offline banner | Auto-retry when online |

### 6.3 Empty State
*Not applicable for this screen, as it always requires a recipe context to be displayed.*

### 6.4 Offline Behavior
| Content | Offline Behavior | Visual Indicator |
|---------|------------------|------------------|
| Recipe Data | Display cached version if available | "You are offline" banner at the top |
| Actions | Disable actions requiring a connection | Disabled button states |

## 7. Accessibility

### 7.1 Screen Reader Support
| Element | Semantic Label | Role |
|---------|----------------|------|
| Back Button | "Go back" | Button |
| Creator Image | "[Creator name] profile" | Button |
| Start Cooking | "Start cooking this recipe" | Button |
| Nutrition Circles | "[Macro] [percentage] of daily value" | Progressbar |
| Ingredient Items | "[Quantity] [ingredient name]" | Listitem |
| Navigation Items | "[Function] tab" | Tab |

### 7.2 Color Contrast
- All text meets WCAG AA contrast requirements
- Nutrition circle text maintains readability
- Bottom navigation icons have sufficient contrast
- Action buttons meet contrast standards

### 7.3 Touch Targets
- All interactive elements meet 44dp minimum
- Ingredient list items (56dp) exceed requirements
- Navigation items properly spaced to prevent mis-taps
- Start cooking button provides comfortable target area

## 8. Performance Requirements

### 8.1 Rendering Targets
| Metric | Target | Measurement Point |
|--------|--------|-------------------|
| Initial Render | ≤ 500ms | Hero image placeholder |
| Hero Image Load | ≤ 800ms | Full resolution display |
| Ingredients Load | ≤ 300ms | List population |
| Nutrition Animation | ≤ 400ms | Circle fill animations |

### 8.2 Memory Management
- Progressive image loading (placeholder → full res)
- Cache ingredient icons for reuse
- Optimize nutrition circle rendering
- Efficient list virtualization for long ingredient lists

## 9. Implementation Notes

### 9.1 Flutter Widget Structure
```dart
Scaffold(
  appBar: AppBar(
    title: Text(creatorName),
    actions: [PopupMenuButton()],
  ),
  body: CustomScrollView(
    slivers: [
      SliverToBoxAdapter(child: HeroImageSection()),
      SliverToBoxAdapter(child: RecipeHeaderSection()),
      SliverToBoxAdapter(child: MetadataRow()),
      SliverToBoxAdapter(child: NutritionSection()),
      SliverList(delegate: IngredientsListDelegate()),
    ],
  ),
  bottomNavigationBar: WorldChefBottomNavigation(),
)
```

### 9.2 State Management
- Use `AsyncNotifierProvider` for recipe data
- Use `NotifierProvider` for UI state (expanded sections)
- Implement progressive loading for images
- Cache strategy for offline recipe access

### 9.3 Custom Components Needed
- `NutritionCircleIndicator` - Circular progress with percentage
- `IngredientListItem` - Icon + text + quantity + chevron
- `CreatorImageOverlay` - Circular image with border
- `StartCookingButton` - Rounded button with icon

---

**Status**: ✅ **SPECIFICATION COMPLETE**  
**Next Step**: Implementation using Flutter with design tokens  
**Dependencies**: Design system implementation (Task t002) 