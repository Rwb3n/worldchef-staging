# Recipe Detail Screen Specification (MVP v0.2)

**Status**: 🟡 **DRAFT**  
**Updated**: 2025-06-27  
**Plan Task**: mobile_refinement_pixel_backend.t005  
**Design System**: References `docs/ui_specifications/design_system/design_tokens.md`

---

## 1. Purpose
Allows users to view a single recipe in detail, evaluate its nutritional facts, adjust serving sizes, and begin cooking instructions.

## 2. Layout Structure

### Visual Layout
```
+------------------------------------------------+
| Header (Hero Image 4:3)                        |
|  • Back Icon  • Favorite Icon                  |
+------------------------------------------------+
| ScrollView                                     |
|  ├─ Title & Creator Row                        |
|  ├─ Info Row (⏱ Time • 🍽 Servings)            |
|  ├─ Nutrition Facts (4 stats & pie graphs)     |
|  ├─ Ingredients List (image + qty)             |
|  └─ Directions (step list)                     |
+------------------------------------------------+
| Bottom Navigation                              |
+------------------------------------------------+
```

## 3. Detailed Component Specifications

### 3.1 Header Hero Image
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Height | 276dp (iPhone 12) | `WorldChefMedia.horizontalRatio` |
| Border Radius | 0 | - |
| Overlay Icons | Back (24dp) & Favorite (24dp) | `WCIconMedium` |
| Icons Position | 16dp from edges | `WorldChefSpacing.md` |

### 3.2 Title & Creator Row
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Recipe Title | `WCHeadlineMedium` |  |
| Creator Avatar | 40dp circle | `WorldChefDimensions.avatarSmall` |
| Creator Name | `WCLabelMedium` |  |
| Spacing | 8dp between avatar & text | `WorldChefSpacing.sm` |

### 3.3 Info Row
| Item | Icon | Text Style | Spacing |
|------|------|------------|---------|
| Time | Alarm 24dp | `WCLabelMedium` | 26dp between items |
| Servings | Dish 24dp | `WCLabelMedium` | - |

### 3.4 Nutrition Facts Section
| Component | Value |
|-----------|-------|
| Section Title | `WCHeadlineSmall` |
| Card Height | 114dp | - |
| Stat Count | Protein, Carbs, Calories, Fat |
| Pie Graph Size | 44dp | - |
| Percentage Text | `WCLabelSmall` |

### 3.5 Ingredients List
| Property | Value |
|----------|-------|
| Card Height | 63dp per row |
| Image Size | 63dp | `WorldChefDimensions.thumbnailMedium` |
| Border Radius | 8dp | `WorldChefDimensions.radiusMedium` |
| Quantity Column Width | 120dp | - |
| Horizontal Gap | 59dp | Derived from Figma measure |

### 3.6 Directions (Steps)
_To be populated in Task t006 once steps API is integrated._

## 4. Interactions
1. **Tap Favorite Icon** → Toggle recipe favorite state (optimistic update).
2. **Scroll** → Collapses header into small AppBar with title.
3. **Tap Ingredient Row** → No action (informational).
4. **Tap Back** → Navigate back to previous screen.

## 5. Responsive Behavior
| Screen Size | Hero Height | Column Behaviour |
|-------------|-------------|------------------|
| ≤375dp | 240dp | Ingredients list wraps text | 
| 376–430dp | 276dp | Fixed |

## 6. States & Error Handling
| Scenario | Visual |
|----------|--------|
| Loading | Skeleton for hero & list |
| Error | Full-screen message with Retry |
| Offline | Global offline banner (shared component) |

## 7. Accessibility Highlights
- All icons have semantic labels ("Back", "Toggle favorite").
- Ingredient images include descriptive semantics via Recipe API altText field.
- Nutrition percentages announced as "20 percent of daily protein" etc.

---
*(Spec drafted automatically from Figma CSS export `figma_detail_screen.css`; pixel units converted to dp assuming @1x asset export.)* 