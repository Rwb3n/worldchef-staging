/* ANNOTATION_BLOCK_START
{
  "artifact_id": "worldchef_poc_ai_prompt_templates",
  "version_tag": "1.0.0-setup",
  "g_created": 8,
  "g_last_modified": 8,
  "description": "Reusable AI prompt templates for common WorldChef PoC development tasks, optimized for consistent code generation across Flutter and React Native implementations.",
  "artifact_type": "DOCUMENTATION",
  "status_in_lifecycle": "PRODUCTION",
  "purpose_statement": "Provides standardized, reusable prompt templates to ensure consistent AI code generation quality and reduce prompt iteration time across both PoC implementations.",
  "key_logic_points": [
    "Platform-specific prompt templates for Flutter and React Native",
    "Component-type specific prompts (lists, cards, screens, navigation)",
    "State management and API integration prompt patterns",
    "Performance optimization and accessibility prompt templates",
    "Testing and debugging prompt strategies",
    "Code review and refactoring prompt templates"
  ],
  "interfaces_provided": [
    {
      "name": "Prompt Template Library",
      "interface_type": "DOCUMENTATION",
      "details": "Categorized collection of reusable prompt templates for common development tasks",
      "notes": "Templates include placeholders for customization and expected output formats"
    }
  ],
  "requisites": [
    { "description": "AI tooling guide understanding", "type": "DOCUMENTATION_DEPENDENCY" },
    { "description": "Platform-specific development knowledge", "type": "DOMAIN_KNOWLEDGE" }
  ],
  "external_dependencies": [],
  "internal_dependencies": ["worldchef_poc_ai_tooling_guide"],
  "dependents": ["worldchef_poc_flutter", "worldchef_poc_rn"],
  "linked_issue_ids": [],
  "quality_notes": {
    "unit_tests": "N/A - Documentation",
    "manual_review_comment": "Comprehensive prompt template library created with platform-specific templates, component patterns, and optimization strategies for consistent AI code generation."
  }
}
ANNOTATION_BLOCK_END */

# WorldChef PoC - AI Prompt Templates

> **📋 Navigation**: This document is part of the WorldChef PoC documentation suite. See [Stage 1 Onboarding Guide](./stage1_onboarding_guide.md) for complete project overview and navigation.

Reusable AI prompt templates for consistent code generation across Flutter and React Native implementations.

## Overview

This document provides tested, standardized prompt templates to ensure consistent AI code generation quality while reducing iteration time. Templates are organized by platform and component type.

## Template Usage Guidelines

### Template Structure
```markdown
[CONTEXT_SECTION]
[PLATFORM_REQUIREMENTS]
[SPECIFIC_TASK]
[CONSTRAINTS_AND_PREFERENCES]
[OUTPUT_FORMAT_SPECIFICATION]
[QUALITY_CRITERIA]
```

### Placeholder Convention
- `{COMPONENT_NAME}`: Specific component being implemented
- `{REQUIREMENTS}`: Detailed functional requirements
- `{STYLING_NOTES}`: Visual design specifications
- `{DATA_SOURCE}`: API endpoint or data structure details
- `{NAVIGATION_CONTEXT}`: Routing and navigation requirements

## Flutter Prompt Templates

### 1. Flutter Recipe List Component

```markdown
You are an expert Flutter developer building a high-performance recipe list for the WorldChef mobile app PoC. This component will be compared against a React Native implementation for performance and development experience.

Create a Flutter widget called `{COMPONENT_NAME}` that displays a scrollable list of recipes with the following requirements:

**Requirements:**
{REQUIREMENTS}
- Displays recipe cards with image, title, rating, and cooking time
- Implements efficient scrolling with ListView.builder or similar
- Uses cached_network_image for image loading with placeholder/error states
- Includes pull-to-refresh functionality
- Handles loading and error states appropriately
- Implements search/filter functionality if specified

**Technical Specifications:**
- Use Material Design 3 components and theming
- Implement proper state management (Provider/Riverpod/Bloc as appropriate)
- Follow Flutter performance best practices (const constructors, efficient builds)
- Include proper error handling and user feedback
- Implement accessibility features (semantics, contrast, navigation)
- Use http package for API calls to mock server

**Data Integration:**
- Fetch data from: `{DATA_SOURCE}` (default: http://localhost:3000/recipes)
- Handle JSON response parsing with proper error handling
- Implement caching strategy for offline/poor network scenarios

**Output Requirements:**
Provide complete, runnable code including:
1. Main widget class with all necessary imports
2. Model classes for recipe data
3. Service class for API integration
4. Error handling and loading states
5. Accessibility implementations
6. Performance optimizations
7. Brief documentation comments

Ensure the code follows Flutter best practices and can be integrated into an existing Material App structure.
```

### 2. Flutter Recipe Detail Screen

```markdown
You are an expert Flutter developer creating a recipe detail screen for the WorldChef PoC that showcases Flutter's UI capabilities and performance.

Create a `{COMPONENT_NAME}` screen that displays comprehensive recipe information with the following specifications:

**Requirements:**
{REQUIREMENTS}
- Full-screen recipe image with parallax scroll effect
- Recipe title, rating, cooking time, and difficulty level
- Expandable/collapsible ingredients list
- Step-by-step cooking instructions
- Save/favorite functionality with local storage
- Share recipe functionality
- Navigation back to recipe list

**UI/UX Specifications:**
{STYLING_NOTES}
- Implement CustomScrollView with SliverAppBar for parallax effect
- Use Material Design 3 components and typography
- Smooth animations and transitions
- Responsive layout for different screen sizes
- Loading states and error handling

**Technical Requirements:**
- Route parameter handling for recipe ID
- Integration with SharedPreferences for favorites
- Share functionality using share_plus package
- Cached image loading with progressive loading
- Proper memory management for large images

**Performance Considerations:**
- Optimize image loading and caching
- Efficient widget rebuilds
- Smooth scrolling performance
- Memory usage optimization

Provide complete implementation with navigation setup, state management, and all necessary dependencies.
```

### 3. Flutter Navigation Setup

```markdown
You are an expert Flutter developer setting up navigation for the WorldChef PoC app using Go Router or Navigator 2.0.

Create a complete navigation structure with the following routes:
{NAVIGATION_CONTEXT}

**Route Structure:**
- `/` - Home/Recipe List Screen
- `/recipe/:id` - Recipe Detail Screen
- `/search` - Recipe Search Screen
- `/favorites` - Saved Recipes Screen
- `/settings` - App Settings Screen

**Requirements:**
- Type-safe route definitions
- Deep linking support
- Navigation animations and transitions
- Back button handling
- Route guards if needed
- Navigation state persistence

**Implementation Details:**
- Use GoRouter for modern navigation patterns
- Implement custom page transitions
- Handle route parameters and query parameters
- Include navigation drawer or bottom navigation
- Error route handling (404 equivalent)

Provide complete router configuration, route definitions, and navigation helper methods.
```

### 4. Flutter State Management Setup

```markdown
You are an expert Flutter developer implementing state management for the WorldChef PoC using {STATE_MANAGEMENT_SOLUTION}.

Create a complete state management solution that handles:
{REQUIREMENTS}

**State Structure:**
- Recipe list state (loading, data, error)
- Recipe detail state
- User preferences (favorites, settings)
- Search and filter state
- Network connectivity state

**Technical Requirements:**
- Implement {STATE_MANAGEMENT_SOLUTION} (Provider/Riverpod/Bloc)
- Handle async operations and side effects
- Implement proper error handling and recovery
- Cache management for offline capabilities
- State persistence where appropriate

**Performance Considerations:**
- Minimize unnecessary widget rebuilds
- Efficient state updates and notifications
- Memory management for large datasets
- Optimistic updates for better UX

Provide complete state management setup with models, providers/blocs, and usage examples.
```

## React Native Prompt Templates

### 1. React Native Recipe List Component

```markdown
You are an expert React Native developer building a high-performance recipe list for the WorldChef mobile app PoC using Expo. This component will be compared against a Flutter implementation.

Create a React Native component called `{COMPONENT_NAME}` with the following requirements:

**Requirements:**
{REQUIREMENTS}
- Displays recipe cards using @shopify/flash-list for optimal performance
- Recipe cards show image, title, rating, and cooking time
- Implements pull-to-refresh and infinite scroll if needed
- Uses optimized image loading with caching
- Includes search/filter functionality
- Handles loading and error states with user feedback

**Technical Specifications:**
- Use TypeScript for type safety
- Implement Zustand for state management
- Follow React Native performance best practices
- Use React Navigation for navigation
- Implement proper accessibility features
- Use Axios for API calls to mock server

**Data Integration:**
- Fetch data from: `{DATA_SOURCE}` (default: http://localhost:3000/recipes)
- Implement proper error handling and retry logic
- Use React Query or SWR for caching and synchronization
- Handle offline scenarios gracefully

**Styling:**
- Use StyleSheet for performance
- Implement responsive design principles
- Follow platform-specific design guidelines
- Use consistent spacing and typography

**Output Requirements:**
Provide complete, runnable code including:
1. Main component with TypeScript types
2. Custom hooks for data fetching
3. Recipe item component
4. Loading and error components
5. Accessibility implementations
6. Performance optimizations
7. Integration examples

Ensure code follows React Native best practices and integrates with Expo managed workflow.
```

### 2. React Native Recipe Detail Screen

```markdown
You are an expert React Native developer creating a recipe detail screen for the WorldChef PoC that demonstrates React Native's capabilities.

Create a `{COMPONENT_NAME}` screen component with the following specifications:

**Requirements:**
{REQUIREMENTS}
- Full-screen image with parallax scroll using Animated API
- Recipe information display with smooth animations
- Collapsible sections for ingredients and instructions
- Save/favorite functionality with AsyncStorage
- Share functionality using Expo Sharing
- Smooth navigation transitions

**UI/UX Specifications:**
{STYLING_NOTES}
- Implement Animated.ScrollView for parallax effects
- Use React Native's Animated API for smooth transitions
- Platform-specific styling (iOS/Android differences)
- Responsive layout for different screen sizes
- Loading skeletons and error boundaries

**Technical Requirements:**
- Route parameters from React Navigation
- AsyncStorage integration for favorites
- Expo Sharing for share functionality
- Optimized image loading with progressive enhancement
- Memory optimization for images and animations

**Performance Considerations:**
- Native driver animations where possible
- Optimized re-renders with React.memo
- Efficient scroll performance
- Image caching and memory management

Provide complete implementation with navigation setup, TypeScript types, and performance optimizations.
```

### 3. React Native Navigation Setup

```markdown
You are an expert React Native developer setting up navigation for the WorldChef PoC app using React Navigation v6.

Create a complete navigation structure with the following routes:
{NAVIGATION_CONTEXT}

**Navigation Structure:**
- Stack Navigator for main app flow
- Tab Navigator for bottom navigation
- Drawer Navigator if specified
- Modal stacks for overlays

**Screen Structure:**
- RecipeListScreen (Home)
- RecipeDetailScreen
- SearchScreen
- FavoritesScreen
- SettingsScreen

**Requirements:**
- TypeScript navigation types
- Deep linking configuration
- Custom transitions and animations
- Navigation state persistence
- Header customization
- Navigation guards and conditional rendering

**Platform Integration:**
- Expo Router integration if using Expo Router
- React Navigation v6 best practices
- Performance optimizations
- Accessibility support

Provide complete navigation setup with TypeScript types, route definitions, and integration examples.
```

### 4. React Native State Management Setup

```markdown
You are an expert React Native developer implementing state management for the WorldChef PoC using Zustand.

Create a complete Zustand store structure that manages:
{REQUIREMENTS}

**Store Structure:**
- Recipe store (list, detail, search)
- User preferences store (favorites, settings)
- App state store (loading, error, network)
- Cache store for offline functionality

**Technical Requirements:**
- TypeScript store definitions
- Async action handling
- Middleware for persistence (AsyncStorage)
- Devtools integration for debugging
- Error handling and recovery
- Optimistic updates

**Integration Requirements:**
- React Query integration for server state
- AsyncStorage persistence
- Network state management
- Background app state handling

**Performance Considerations:**
- Selector optimization to prevent unnecessary re-renders
- Store slice separation for better performance
- Memory management for large datasets
- Subscription cleanup

Provide complete store setup with TypeScript types, actions, selectors, and usage examples.
```

## API Integration Templates

### 1. Mock Server Integration

```markdown
You are an expert mobile developer creating API integration for the WorldChef PoC that connects to a local mock server.

Create a complete API service for {PLATFORM} that handles:

**Endpoints:**
- GET /recipes - Fetch all recipes with pagination
- GET /recipes/:id - Fetch single recipe details
- Potential filtering and search parameters

**Requirements:**
- Base URL configuration: http://localhost:3000 (adjustable for different environments)
- Request/response interceptors for logging and error handling
- Retry logic for failed requests
- Timeout configuration
- Response caching strategy
- Network error handling
- Loading state management

**Platform-Specific Implementation:**
For Flutter:
- Use http package or dio for HTTP requests
- Implement proper JSON serialization/deserialization
- Error handling with custom exceptions

For React Native:
- Use Axios with TypeScript
- Implement request/response interceptors
- Error handling with proper error types

**Error Handling:**
- Network connectivity errors
- Server errors (5xx)
- Client errors (4xx)
- Timeout errors
- Parsing errors

**Caching Strategy:**
- Implement appropriate caching for recipe data
- Cache invalidation strategies
- Offline data access

Provide complete API service implementation with error handling, caching, and usage examples.
```

### 2. Offline Support Implementation

```markdown
You are an expert mobile developer implementing offline support for the WorldChef PoC.

Create an offline-first data layer for {PLATFORM} with:

**Requirements:**
- Local data persistence
- Sync strategy when network returns
- Conflict resolution
- Cache management
- Offline state indicators

**For Flutter:**
- Use sqflite or hive for local storage
- Implement repository pattern
- Connectivity monitoring
- Data synchronization logic

**For React Native:**
- Use AsyncStorage or SQLite
- Implement offline store with Zustand
- Network state monitoring with NetInfo
- Background sync capabilities

**Features to Implement:**
- Cache recipe list and details
- Offline favorites management
- Search within cached data
- Sync queue for pending actions
- Cache size management and cleanup

Provide complete offline implementation with sync logic and user feedback systems.
```

## Testing Templates

### 1. Unit Testing Template

```markdown
You are an expert mobile developer creating comprehensive unit tests for the WorldChef PoC {PLATFORM} implementation.

Create unit tests for {COMPONENT_NAME} with the following coverage:

**Test Categories:**
- Component rendering tests
- State management tests
- API service tests
- Utility function tests
- Error handling tests

**For Flutter:**
- Use flutter_test framework
- Widget testing with testWidgets
- Mock dependencies with mockito
- Test state management logic
- Golden tests for UI consistency

**For React Native:**
- Use Jest and React Native Testing Library
- Component testing with render and screen
- Mock Axios requests
- Test custom hooks
- Snapshot testing for UI components

**Test Scenarios:**
- Happy path functionality
- Error states and edge cases
- Loading states
- Empty states
- Network failures
- User interactions

**Coverage Requirements:**
- Aim for >80% code coverage
- Test all public methods/functions
- Mock external dependencies
- Test async operations
- Verify accessibility features

Provide complete test suite with setup, mocks, and comprehensive test cases.
```

### 2. Integration Testing Template

```markdown
You are an expert mobile developer creating integration tests for the WorldChef PoC {PLATFORM} implementation.

Create integration tests that verify:

**Test Scenarios:**
- End-to-end user flows
- API integration with mock server
- Navigation between screens
- State persistence
- Offline/online transitions

**For Flutter:**
- Use flutter_driver or integration_test
- Test complete user journeys
- Mock network responses
- Test device-specific features

**For React Native:**
- Use Detox or Appium
- E2E testing with real device scenarios
- Mock server integration
- Performance testing

**Test Flows:**
1. App launch and recipe list loading
2. Recipe search and filtering
3. Recipe detail navigation
4. Favorite recipe functionality
5. Offline usage scenarios
6. Error recovery flows

**Setup Requirements:**
- Mock server configuration
- Test data setup
- Device/emulator configuration
- Test environment variables

Provide complete integration test setup with test scenarios and mock configurations.
```

## Performance Optimization Templates

### 1. Performance Analysis Template

```markdown
You are an expert mobile developer analyzing and optimizing performance for the WorldChef PoC {PLATFORM} implementation.

Analyze the {COMPONENT_NAME} component and provide optimization recommendations:

**Performance Areas:**
- Rendering performance
- Memory usage
- Network efficiency
- Storage optimization
- Animation smoothness

**For Flutter:**
- Widget rebuild analysis
- Memory profiling with DevTools
- Rendering performance measurement
- Image loading optimization
- List rendering efficiency

**For React Native:**
- Re-render optimization with React DevTools
- Memory leak detection
- FlatList/FlashList performance
- Image caching and optimization
- JavaScript thread performance

**Optimization Strategies:**
1. Identify performance bottlenecks
2. Implement specific optimizations
3. Measure improvements
4. Document changes and rationale

**Metrics to Track:**
- Frame rate (60 FPS target)
- Memory usage patterns
- App startup time
- Network request efficiency
- User interaction responsiveness

Provide detailed performance analysis with specific optimization implementations and measurement strategies.
```

### 2. Code Review Template

```markdown
You are an expert mobile developer conducting a code review for the WorldChef PoC {PLATFORM} implementation.

Review the {COMPONENT_NAME} implementation for:

**Code Quality Areas:**
- Architecture and design patterns
- Performance considerations
- Security best practices
- Accessibility compliance
- Maintainability and readability

**Platform-Specific Considerations:**

For Flutter:
- Widget composition and reusability
- State management implementation
- Package dependencies and versions
- Platform channel usage
- Build configuration

For React Native:
- Component composition and hooks usage
- TypeScript type safety
- Expo/React Native best practices
- Native module integration
- Metro bundle optimization

**Review Checklist:**
- [ ] Code follows platform conventions
- [ ] Proper error handling implemented
- [ ] Performance optimizations applied
- [ ] Accessibility features included
- [ ] Tests provide adequate coverage
- [ ] Documentation is comprehensive
- [ ] Security considerations addressed

**Feedback Format:**
1. Overall assessment and score (1-10)
2. Specific improvement recommendations
3. Critical issues requiring immediate attention
4. Suggestions for enhancement
5. Praise for well-implemented features

Provide detailed code review with specific, actionable feedback and improvement suggestions.
```

## Debugging and Troubleshooting Templates

### 1. Debug Issue Template

```markdown
You are an expert mobile developer helping debug a specific issue in the WorldChef PoC {PLATFORM} implementation.

**Issue Description:**
{ISSUE_DESCRIPTION}

**Current Behavior:**
{CURRENT_BEHAVIOR}

**Expected Behavior:**
{EXPECTED_BEHAVIOR}

**Environment:**
- Platform: {PLATFORM}
- Device/Emulator: {DEVICE_INFO}
- Network Conditions: {NETWORK_CONDITIONS}

**Debugging Approach:**
1. Identify potential root causes
2. Suggest debugging steps and tools
3. Provide code solutions
4. Include prevention strategies

**For Flutter:**
- Use Flutter Inspector and DevTools
- Debug console output analysis
- Widget tree inspection
- Performance profiling

**For React Native:**
- Use React DevTools and Flipper
- Metro bundler debugging
- Native debugging tools (Xcode/Android Studio)
- Network request inspection

**Solution Requirements:**
- Root cause identification
- Step-by-step debugging process
- Code fixes with explanation
- Testing verification steps
- Prevention recommendations

Provide comprehensive debugging guidance with specific tools and solutions.
```

## Template Customization Guide

### Variables Reference
- `{COMPONENT_NAME}`: Replace with specific component name
- `{REQUIREMENTS}`: Replace with detailed functional requirements
- `{STYLING_NOTES}`: Replace with visual design specifications
- `{DATA_SOURCE}`: Replace with API endpoint details
- `{NAVIGATION_CONTEXT}`: Replace with navigation structure
- `{PLATFORM}`: Replace with "Flutter" or "React Native"
- `{STATE_MANAGEMENT_SOLUTION}`: Replace with chosen state management approach

### Template Usage Tips

1. **Always customize placeholders** before using templates
2. **Add specific context** about the WorldChef PoC comparison
3. **Include performance requirements** for fair comparison
4. **Specify exact dependencies** and versions when relevant
5. **Request complete, runnable code** with all necessary imports
6. **Ask for explanation** of architectural decisions
7. **Include accessibility requirements** in all UI templates
8. **Request error handling** and edge case coverage

### Quality Assurance

When using these templates:
- ✅ Verify all placeholders are replaced
- ✅ Include specific PoC context and constraints
- ✅ Request complete, testable implementations
- ✅ Ask for performance and accessibility considerations
- ✅ Include integration requirements with existing code
- ✅ Request proper documentation and comments

---

## Summary

These prompt templates provide a standardized approach to AI-assisted development for the WorldChef PoC, ensuring:

1. **Consistency**: Standardized output format and quality
2. **Efficiency**: Reduced prompt iteration time
3. **Quality**: Built-in best practices and requirements
4. **Comparison**: Fair evaluation between platforms
5. **Completeness**: Comprehensive coverage of common tasks

**Usage**: Select appropriate template, customize placeholders, add specific context, and iterate as needed to achieve desired results.

---

*Last Updated: Stage 1 Setup Phase*  
*AI Prompt Templates Version: 1.0.0*  
*Maintained by: PoC Team* 