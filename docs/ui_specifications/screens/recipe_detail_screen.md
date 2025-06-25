# Recipe Detail Screen Specification (MVP v0.2)

**Status**: ✅ **REFINED** – Updated to match visual design  
**Updated**: 2025-06-25  
**Plan Task**: t005-C (Recipe Detail Screen Layout Refinement)  
**Design System**: References `docs/ui_specifications/design_system/design_tokens.md`

---

## 1. Purpose
Display comprehensive recipe information including hero image, creator details, cooking time, nutrition facts, and ingredients list. Provides primary cooking action and social interaction features.

## 2. Layout Structure

### Visual Layout (Based on Screenshot)
```
+------------------------------------------------+
| Status Bar: "Dish" + Time + System Icons      |
+------------------------------------------------+
| Header: (← < return)  (ChefSannikay < creator)              |
+------------------------------------------------+
| Hero Image (Jollof rice with sides)           |
| [Large food photography]                       |
| [Creator circle image] [Start cooking →]      |
+------------------------------------------------+
| Creator Name: ChefSannikay                     |
| Recipe Title: Jollof rice                      |
+------------------------------------------------+
| Metadata Row:                                  |
| ⏱ 15 minutes    ✕    👥 5 portions            |
+------------------------------------------------+
| Nutrition facts              Full nutrition > |
| Calories                                       |
| [Protein 17%] [Carbs 35%] [225%] [60%]        |
+------------------------------------------------+
| Ingredients                                    |
| 🧅 Large yellow onions        2 pieces    >   |
| 🛢 Vegetable oil               60 ml       >   |
| 🍅 Diced tomato             395 g (2 cans) >   |
+------------------------------------------------+
| Blue background                                |
|Bottom Navigation                               |
| [feed] [Explore] [ + ] [Plans] [You]           |
+------------------------------------------------+
```

## 3. Detailed Component Specifications

### 3.1 Header Navigation
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Background | White/System | System default |
| Height | 56dp | `WorldChefDimensions.appBarHeight` |
| Back Button | iOS-style chevron left | `WorldChefDimensions.iconMedium` |
| Creator Name | "ChefSannikay" | `WorldChefTextStyles.headlineSmall` |
| Menu Button | Three dots (vertical) | `WorldChefDimensions.iconMedium` |
| Text Color | Black | `WorldChefNeutrals.primaryText` |

### 3.2 Hero Image Section
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Aspect Ratio | 4:3 or 16:9 | `WorldChefMedia.horizontalRatio` |
| Image Quality | High-resolution food photo | - |
| Image Content | Featured dish with sides | - |
| Overlay Elements | Creator circle + Start button | Positioned bottom section |

#### Creator Circle & Start Button Overlay
| Component | Position | Styling | Design Token Reference |
|-----------|----------|---------|------------------------|
| Creator Image | Bottom left | 48dp circle with border | Custom size |
| Creator Border | White border | 2dp border width | White on image |
| Start Button | Bottom right | Rounded rectangle | `WorldChefDimensions.radiusMedium` |
| Button Background | Teal/Green | `WorldChefColors.secondaryGreen` |
| Button Text | "Start cooking" | `WorldChefTextStyles.labelLarge` |
| Button Icon | Right arrow | `WorldChefDimensions.iconSmall` |
| Button Text Color | White | Ensure contrast |

### 3.3 Recipe Header Section
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Container Padding | 16dp horizontal | `WorldChefLayout.mobileContainerPadding` |
| Vertical Spacing | 16dp | `WorldChefSpacing.md` |

#### Recipe Title & Creator
| Component | Styling | Design Token Reference |
|-----------|---------|------------------------|
| Creator Name | "ChefSannikay" | `WorldChefTextStyles.bodyMedium` |
| Creator Color | Black | `WorldChefNeutrals.primaryText` |
| Recipe Title | "Jollof rice" | `WorldChefTextStyles.headlineLarge` |
| Title Color | Black | `WorldChefNeutrals.primaryText` |
| Title Spacing | 4dp below creator | `WorldChefSpacing.xs` |

### 3.4 Metadata Row
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Layout | Three-column layout | Evenly distributed |
| Vertical Spacing | 16dp from title | `WorldChefSpacing.md` |
| Icon Size | 16dp | `WorldChefDimensions.iconSmall` |
| Text Style | Metadata labels | `WorldChefTextStyles.bodySmall` |
| Text Color | Gray | `WorldChefNeutrals.secondaryText` |

#### Metadata Items
| Item | Icon | Text | Format |
|------|------|------|--------|
| Cooking Time | ⏱ Clock | "15 minutes" | "[n] minutes" |
| Close/Cancel | ✕ X mark | - | Action button |
| Servings | 👥 People | "5 portions" | "[n] portions" |

### 3.5 Nutrition Section
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Section Title | "Nutrition facts" | `WorldChefTextStyles.headlineSmall` |
| Title Color | Black | `WorldChefNeutrals.primaryText` |
| "Full nutrition" Link | Right-aligned | `WorldChefColors.brandBlue` |
| Container Padding | 16dp horizontal | `WorldChefLayout.mobileContainerPadding` |
| Vertical Spacing | 24dp from metadata | `WorldChefLayout.headlineToGrid` |

#### Nutrition Indicators
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Calories Text | "Calories" subtitle | `WorldChefTextStyles.bodyMedium` |
| Progress Circles | 4 circular indicators | Custom component |
| Circle Size | 48dp diameter | Custom size |
| Progress Colors | Different colors per macro | Semantic colors |
| Percentage Text | Inside circles | `WorldChefTextStyles.labelMedium` |
| Circle Spacing | 12dp between circles | `WorldChefSpacing.sm` + 4dp |

#### Nutrition Circle Details
| Circle | Label | Percentage | Color Reference |
|--------|-------|------------|-----------------|
| 1 | Protein | 17% | `WorldChefColors.brandBlue` |
| 2 | Carbs | 35% | `WorldChefColors.accentOrange` |
| 3 | Unknown | 225% | `WorldChefSemanticColors.warning` |
| 4 | Unknown | 60% | `WorldChefColors.secondaryGreen` |

### 3.6 Ingredients Section
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Section Title | "Ingredients" | `WorldChefTextStyles.headlineSmall` |
| Title Color | Black | `WorldChefNeutrals.primaryText` |
| List Style | Vertical list | Full-width items |
| Item Spacing | No spacing | Continuous list |

#### Ingredient List Items
| Component | Position | Styling | Design Token Reference |
|-----------|----------|---------|------------------------|
| Ingredient Icon | Left | 24dp emoji/icon | Food category icon |
| Ingredient Name | Center-left | Primary text | `WorldChefTextStyles.bodyLarge` |
| Quantity | Right | Secondary text | `WorldChefTextStyles.bodyMedium` |
| Chevron | Far right | Navigation arrow | `WorldChefDimensions.iconSmall` |
| Item Height | 56dp minimum | Touch target | `WorldChefDimensions.comfortableTouchTarget` + 8dp |
| Item Padding | 16dp horizontal | `WorldChefLayout.mobileContainerPadding` |
| Divider | Bottom border | Light gray | `WorldChefNeutrals.dividers` |

#### Ingredient Examples
| Icon | Name | Quantity | Format |
|------|------|----------|--------|
| 🧅 | Large yellow onions | 2 pieces | "[quantity] [unit]" |
| 🛢 | Vegetable oil | 60 ml | "[quantity] [unit]" |
| 🍅 | Diced tomato | 395 g (2 cans) | "[quantity] ([additional info])" |

### 3.7 Bottom Navigation
| Property | Value | Design Token Reference |
|----------|--------|------------------------|
| Height | 56dp | `WorldChefDimensions.bottomNavHeight` |
| Background | Blue gradient/solid | `WorldChefColors.brandBlue` |
| Active Item | Context-dependent | `WorldChefColors.brandBlue` or highlighted |
| Inactive Items | White | On blue background |
| Icon Size | 24dp | `WorldChefDimensions.iconMedium` |
| Labels | Below icons | `WorldChefTextStyles.labelSmall` |

#### Bottom Navigation Items
| Position | Label | Icon | Function |
|----------|-------|------|----------|
| 1 | "feed" | Home/Grid icon | Main feed |
| 2 | "Explore" | Search/Compass icon | Discovery and search |
| 3 | "+" | Plus icon | Quick create action |
| 4 | "Plans" | Calendar/List icon | Meal planning |
| 5 | "You" | Profile/Person icon | User profile |

## 4. Interactions

### 4.1 Header Actions
1. **Tap back arrow** → Navigate back to previous screen
2. **Tap three dots menu** → Open recipe options menu
3. **Tap creator name** → Navigate to creator profile (optional)

### 4.2 Hero Section Actions
1. **Tap creator circle** → Navigate to creator profile
2. **Tap "Start cooking"** → Navigate to cooking mode/timer
3. **Long press hero image** → Image zoom/fullscreen (optional)

### 4.3 Metadata Actions
1. **Tap time icon** → Show cooking timeline (optional)
2. **Tap X button** → Close/back action (alternative nav)
3. **Tap portions** → Adjust serving size (optional)

### 4.4 Nutrition Section
1. **Tap "Full nutrition"** → Navigate to detailed nutrition screen
2. **Tap nutrition circles** → Show detailed macro information

### 4.5 Ingredients Section
1. **Tap ingredient item** → Navigate to ingredient detail
2. **Tap chevron** → Same as ingredient item tap
3. **Long press ingredient** → Add to shopping list (optional)

### 4.6 Bottom Navigation
1. **Tap "feed"** → Navigate to Home Feed screen
2. **Tap "Explore"** → Navigate to Search/Discovery screen
3. **Tap "+"** → Quick action menu or recipe creation
4. **Tap "Plans"** → Navigate to Meal Planning screen
5. **Tap "You"** → Navigate to User Profile screen

## 5. Responsive Behavior

### 5.1 Screen Size Adaptations
| Screen Width | Hero Image | Nutrition Circles | Adjustments |
|--------------|------------|-------------------|-------------|
| 320-375dp | Maintain aspect | 4 circles stacked closer | Compact spacing |
| 375-414dp | Standard aspect | 4 circles standard spacing | Normal layout |
| 414dp+ | Standard aspect | 4 circles with breathing room | Comfortable spacing |

### 5.2 Content Loading
| State | Visual Behavior | Duration |
|-------|----------------|----------|
| Initial Load | Hero image fade-in | Progressive loading |
| Ingredient Load | Skeleton list items | Until data loaded |
| Nutrition Load | Empty circles fill | Animated progress |

## 6. States & Error Handling

### 6.1 Loading States
| Component | Loading Visual | Animation |
|-----------|----------------|-----------|
| Hero Image | Blur-to-sharp transition | Progressive enhancement |
| Creator Info | Skeleton text blocks | `WorldChefAnimations.shimmer` |
| Nutrition Circles | Empty circles | Fill animation on load |
| Ingredients List | Skeleton list items | `WorldChefAnimations.shimmer` |

### 6.2 Error States
| Scenario | Error Visual | Recovery Action |
|----------|--------------|-----------------|
| Recipe Not Found | "Recipe not available" message | "Go back" button |
| Image Load Failed | Placeholder image | Retry on tap |
| Ingredients Failed | "Unable to load ingredients" | "Retry" button |
| Network Error | Offline banner | Auto-retry when online |

### 6.3 Offline Behavior
| Content | Offline Behavior | Visual Indicator |
|---------|------------------|------------------|
| Cached Recipe | Full offline access | Subtle offline indicator |
| Uncached Recipe | Limited data display | "Limited offline access" banner |
| Start Cooking | Local timer mode | "Offline cooking mode" notice |

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