<!-- 
This is a template for creating a new screen specification.
- Replace bracketed placeholders like `[Screen Name]` with your content.
- Fill in the tables and lists with details specific to your screen.
- Use the ASCII art section to provide a low-fi visual guide.
- Reference design tokens from `docs/ui_specifications/design_system/design_tokens.md` wherever possible.
-->

# [Screen Name] Screen Specification (MVP v[Version])

**Status**: 🟡 **DRAFT**  
**Updated**: [YYYY-MM-DD]  
**Plan Task**: [plan_id.task_id]  
**Design System**: References `docs/ui_specifications/design_system/design_tokens.md`

---

## 1. Purpose
<!-- Briefly describe the screen's primary purpose and its role in the user journey. -->
[A brief, one-sentence description of the screen's purpose.]

## 2. Layout Structure

### Visual Layout
<!-- Use ASCII art to create a simple block diagram of the screen's layout. -->
```
+------------------------------------------------+
| Header / App Bar                               |
+------------------------------------------------+
|                                                |
| Main Content Area 1                            |
|                                                |
+------------------------------------------------+
|                                                |
| Main Content Area 2                            |
|                                                |
+------------------------------------------------+
|                                                |
| ...                                            |
|                                                |
+------------------------------------------------+
| Bottom Navigation (if applicable)              |
+------------------------------------------------+
```

## 3. Detailed Component Specifications

<!-- 
Break down the screen into its major components/sections. 
For each component, create a subsection (e.g., ### 3.1 Header Bar).
Use tables to detail the properties and their corresponding design tokens.
-->

### 3.1 [Component/Section 1 Name]
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Background Color | [e.g., White] | `[e.g., WorldChefColors.background]` |
| Height | [e.g., 56dp] | `[e.g., WorldChefDimensions.appBarHeight]` |
| Padding | [e.g., 16dp horizontal] | `[e.g., WorldChefLayout.mobileContainerPadding]` |
| ...      | ...   | ...                    |


#### 3.1.1 [Sub-component 1 Name]
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| Text | [e.g., "Screen Title"] | `[e.g., WorldChefTextStyles.headlineSmall]` |
| Icon | [e.g., Back Arrow] | `[e.g., WorldChefDimensions.iconMedium]` |
| ...      | ...   | ...                    |

### 3.2 [Component/Section 2 Name]
| Property | Value | Design Token Reference |
|----------|-------|------------------------|
| ...      | ...   | ...                    |


## 4. Interactions
<!-- 
Describe all user interactions for each component section.
Clearly state the trigger (e.g., Tap) and the expected outcome (e.g., Navigate to...).
-->

### 4.1 [Component/Section 1 Name] Interactions
1. **Tap [UI Element]** → [Describe the resulting action, e.g., Navigate to the Profile screen].
2. **Swipe [Direction]** → [Describe the resulting action].

### 4.2 [Component/Section 2 Name] Interactions
1. **Tap [UI Element]** → [Describe the resulting action].

## 5. Responsive Behavior

### 5.1 Screen Size Adaptations
<!-- Describe how the layout adjusts to different screen sizes. -->
| Screen Width | Column Count | Adjustments |
|--------------|--------------|-------------|
| 320-375dp    | [e.g., 2]    | [e.g., Tighter spacing, smaller margins] |
| 375dp+       | [e.g., 3]    | [e.g., Standard spacing] |

### 5.2 Content Loading
<!-- Describe how content loads, e.g., crossfade, fade-in. -->
| State | Visual Behavior | Duration |
|-------|-----------------|----------|
| Initial Load | [e.g., Skeleton loaders shimmer] | [e.g., Until data arrives] |
| Content Refresh | [e.g., Crossfade] | `[e.g., WorldChefAnimations.short]` |

## 6. States & Error Handling

### 6.1 Loading State
<!-- Detail what the user sees while the screen is loading data. -->
| Component | Loading Visual | Animation |
|-----------|----------------|-----------|
| [Component 1] | [e.g., Shimmering rectangle] | `[e.g., WorldChefAnimations.shimmer]` |
| [Component 2] | [e.g., Skeleton text lines] | `[e.g., WorldChefAnimations.shimmer]` |

### 6.2 Error State
<!-- Describe how different error scenarios are presented to the user. -->
| Scenario | Error Visual | Recovery Action |
|----------|--------------|-----------------|
| [e.g., API Fails] | [e.g., "Something went wrong" message] | [e.g., "Retry" button] |
| [e.g., Network Offline] | [e.g., Global offline banner] | [e.g., Auto-retry when connection returns] |

### 6.3 Empty State
<!-- Describe what the user sees when there is no data to display. -->
| Scenario | Empty State Visual | Call to Action |
|----------|--------------------|----------------|
| [e.g., No items found] | [e.g., Illustration + "No recipes here!"] | [e.g., "Create a Recipe" button] |

### 6.4 Offline Behavior
<!-- Describe how the screen behaves without a network connection. -->
| Content | Offline Behavior | Visual Indicator |
|---------|------------------|------------------|
| [e.g., Recipe Data] | [e.g., Display cached version] | [e.g., "You are offline" banner at top] | 