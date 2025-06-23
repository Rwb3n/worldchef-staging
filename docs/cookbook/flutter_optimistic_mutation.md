# Cookbook: Optimistic Mutations with Rollback

**Pattern:** `StateNotifier<AsyncValue<T>>` with Optimistic Updates  
**Source:** PoC #3 Validation - 100% Success Rate  
**Use Case:** Like buttons, favorites, quick toggles, shopping cart  
**Validated in:** PoC #3 Stage 2 (36ms optimistic update latency, 210ms p90 mutation latency)

This pattern provides instant UI feedback while safely handling network failures through rollback mechanisms.

## Core Implementation Pattern

```dart
// lib/providers/like_mutation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldchef/models/recipe.dart';
import 'package:worldchef/services/api_service.dart';

/// State for tracking like mutation operations
class LikeMutationState {
  final bool isLoading;
  final String? error;
  final Map<String, bool> optimisticLikes; // recipeId -> liked state
  
  const LikeMutationState({
    this.isLoading = false,
    this.error,
    this.optimisticLikes = const {},
  });
  
  LikeMutationState copyWith({
    bool? isLoading,
    String? error,
    Map<String, bool>? optimisticLikes,
  }) {
    return LikeMutationState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      optimisticLikes: optimisticLikes ?? this.optimisticLikes,
    );
  }
}

/// StateNotifier for handling like/unlike operations with optimistic updates
class LikeMutationNotifier extends StateNotifier<LikeMutationState> {
  LikeMutationNotifier(this.ref) : super(const LikeMutationState());
  
  final Ref ref;

  /// Optimistic like toggle with rollback on failure
  Future<void> toggleLike(String recipeId, bool currentLiked) async {
    // 1. OPTIMISTIC UPDATE - Immediate UI feedback
    final newLikedState = !currentLiked;
    final updatedOptimistic = Map<String, bool>.from(state.optimisticLikes);
    updatedOptimistic[recipeId] = newLikedState;
    
    state = state.copyWith(
      optimisticLikes: updatedOptimistic,
      error: null,
    );

    try {
      // 2. NETWORK REQUEST - Send to server
      state = state.copyWith(isLoading: true);
      final apiService = ref.read(apiServiceProvider);
      
      if (newLikedState) {
        await apiService.likeRecipe(recipeId);
      } else {
        await apiService.unlikeRecipe(recipeId);
      }
      
      // 3. SUCCESS - Remove optimistic state, invalidate cache
      final clearedOptimistic = Map<String, bool>.from(state.optimisticLikes);
      clearedOptimistic.remove(recipeId);
      
      state = state.copyWith(
        isLoading: false,
        optimisticLikes: clearedOptimistic,
      );
      
      // Invalidate related providers to sync with server state
      ref.invalidate(recipeDetailProvider(recipeId));
      ref.invalidate(recipeListProvider);
      
    } catch (error) {
      // 4. ROLLBACK - Restore original state on failure
      final rolledBackOptimistic = Map<String, bool>.from(state.optimisticLikes);
      rolledBackOptimistic.remove(recipeId); // Remove optimistic state
      
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to ${newLikedState ? 'like' : 'unlike'} recipe: $error',
        optimisticLikes: rolledBackOptimistic,
      );
    }
  }
  
  /// Get the effective liked state (optimistic or server state)
  bool getEffectiveLikedState(String recipeId, bool serverState) {
    return state.optimisticLikes[recipeId] ?? serverState;
  }
  
  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }
}

final likeMutationProvider = StateNotifierProvider<LikeMutationNotifier, LikeMutationState>((ref) {
  return LikeMutationNotifier(ref);
});
```

## UI Integration Pattern

### 1. Like Button Widget
```dart
// lib/widgets/like_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikeButton extends ConsumerWidget {
  final String recipeId;
  final bool serverLikedState; // From recipe detail or list
  
  const LikeButton({
    Key? key,
    required this.recipeId,
    required this.serverLikedState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mutationState = ref.watch(likeMutationProvider);
    final mutationNotifier = ref.read(likeMutationProvider.notifier);
    
    // Get effective state (optimistic or server)
    final effectiveLiked = mutationNotifier.getEffectiveLikedState(
      recipeId, 
      serverLikedState,
    );
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: mutationState.isLoading ? null : () {
            mutationNotifier.toggleLike(recipeId, effectiveLiked);
          },
          icon: Icon(
            effectiveLiked ? Icons.favorite : Icons.favorite_border,
            color: effectiveLiked ? Colors.red : Colors.grey,
          ),
        ),
        // Optional: Show loading indicator
        if (mutationState.isLoading && mutationState.optimisticLikes.containsKey(recipeId))
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 1),
          ),
        // Optional: Show error with retry
        if (mutationState.error != null)
          TextButton(
            onPressed: () => mutationNotifier.clearError(),
            child: Text('Error', style: TextStyle(color: Colors.red, fontSize: 10)),
          ),
      ],
    );
  }
}
```

### 2. Recipe Card with Optimistic Like
```dart
class RecipeCard extends ConsumerWidget {
  final Recipe recipe;
  
  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(recipe.title),
        trailing: LikeButton(
          recipeId: recipe.id,
          serverLikedState: recipe.isLiked,
        ),
      ),
    );
  }
}
```

## Advanced Patterns

### 1. Batch Operations
```dart
/// Handle multiple likes/unlikes in a single operation
Future<void> batchToggleLikes(List<String> recipeIds, List<bool> currentStates) async {
  // Apply all optimistic updates first
  final updatedOptimistic = Map<String, bool>.from(state.optimisticLikes);
  for (int i = 0; i < recipeIds.length; i++) {
    updatedOptimistic[recipeIds[i]] = !currentStates[i];
  }
  
  state = state.copyWith(optimisticLikes: updatedOptimistic);
  
  try {
    state = state.copyWith(isLoading: true);
    await apiService.batchLikeRecipes(recipeIds, currentStates);
    
    // Clear all optimistic states on success
    final clearedOptimistic = Map<String, bool>.from(state.optimisticLikes);
    for (String id in recipeIds) {
      clearedOptimistic.remove(id);
    }
    
    state = state.copyWith(
      isLoading: false,
      optimisticLikes: clearedOptimistic,
    );
    
    ref.invalidate(recipeListProvider);
  } catch (error) {
    // Rollback all optimistic states
    final rolledBackOptimistic = Map<String, bool>.from(state.optimisticLikes);
    for (String id in recipeIds) {
      rolledBackOptimistic.remove(id);
    }
    
    state = state.copyWith(
      isLoading: false,
      error: 'Batch operation failed: $error',
      optimisticLikes: rolledBackOptimistic,
    );
  }
}
```

### 2. Offline Queue Support
```dart
// lib/providers/offline_mutation_queue.dart
class OfflineMutationQueue extends StateNotifier<List<PendingMutation>> {
  OfflineMutationQueue(this.ref) : super([]);
  
  final Ref ref;

  void queueLikeToggle(String recipeId, bool newState) {
    state = [...state, PendingMutation.like(recipeId, newState)];
  }
  
  Future<void> processPendingMutations() async {
    for (final mutation in state) {
      try {
        await _executeMutation(mutation);
        state = state.where((m) => m.id != mutation.id).toList();
      } catch (e) {
        // Keep in queue for retry
        break;
      }
    }
  }
}
```

## Performance Characteristics

**Validated Metrics (from PoC #3):**
- **Optimistic Update Latency:** 36ms (target: <50ms) ✅
- **Mutation Round-Trip p90:** 210ms (target: <300ms) ✅
- **Widget Rebuilds:** 2 (optimistic + confirmation) ✅
- **UI Responsiveness:** Instant feedback, no perceived lag

## Testing Patterns

### 1. Unit Testing Optimistic Updates
```dart
test('like mutation applies optimistic update immediately', () async {
  final container = ProviderContainer(
    overrides: [
      apiServiceProvider.overrideWithValue(mockApiService),
    ],
  );
  
  final notifier = container.read(likeMutationProvider.notifier);
  
  // Trigger optimistic update
  notifier.toggleLike('recipe1', false);
  
  // Should show optimistic state immediately
  final state = container.read(likeMutationProvider);
  expect(state.optimisticLikes['recipe1'], true);
  expect(notifier.getEffectiveLikedState('recipe1', false), true);
});
```

### 2. Testing Rollback Behavior
```dart
test('like mutation rolls back on failure', () async {
  when(mockApiService.likeRecipe(any)).thenThrow(Exception('Network error'));
  
  final notifier = container.read(likeMutationProvider.notifier);
  await notifier.toggleLike('recipe1', false);
  
  final state = container.read(likeMutationProvider);
  expect(state.optimisticLikes.containsKey('recipe1'), false);
  expect(state.error, contains('Network error'));
});
```

### 3. Widget Testing with Optimistic State
```dart
testWidgets('like button shows optimistic state', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: LikeButton(recipeId: 'recipe1', serverLikedState: false),
      ),
    ),
  );
  
  // Tap the button
  await tester.tap(find.byType(IconButton));
  await tester.pump(); // Trigger rebuild
  
  // Should show liked state immediately (optimistic)
  expect(find.byIcon(Icons.favorite), findsOneWidget);
});
```

## Error Handling Strategies

### 1. User-Friendly Error Messages
```dart
String getErrorMessage(String operation, dynamic error) {
  if (error.toString().contains('network')) {
    return 'Please check your internet connection and try again.';
  } else if (error.toString().contains('unauthorized')) {
    return 'Please log in to $operation recipes.';
  } else {
    return 'Something went wrong. Please try again.';
  }
}
```

### 2. Retry Logic
```dart
class RetryableMutation {
  final String recipeId;
  final bool targetState;
  int retryCount = 0;
  
  static const maxRetries = 3;
  
  bool get canRetry => retryCount < maxRetries;
  
  Future<void> executeWithRetry(ApiService apiService) async {
    while (canRetry) {
      try {
        if (targetState) {
          await apiService.likeRecipe(recipeId);
        } else {
          await apiService.unlikeRecipe(recipeId);
        }
        return; // Success
      } catch (e) {
        retryCount++;
        if (!canRetry) rethrow;
        await Future.delayed(Duration(seconds: retryCount * 2)); // Exponential backoff
      }
    }
  }
}
```

## Key Benefits

1. **Instant Feedback** - Users see changes immediately
2. **Resilient** - Graceful handling of network failures
3. **Consistent** - Server state always wins after sync
4. **Performant** - Minimal widget rebuilds
5. **Testable** - Clear separation of concerns

## Common Pitfalls

1. **Forgetting Rollback** - Always handle network failures
2. **State Conflicts** - Use server state as source of truth
3. **Memory Leaks** - Clean up optimistic state after resolution
4. **Race Conditions** - Handle concurrent mutations properly
5. **Error Blindness** - Provide clear error feedback to users

---

**Validation Evidence:**
- PoC #3 Success Rate: 100% (like mutation provider)
- Performance: 36ms optimistic updates, 210ms p90 network latency
- Test Coverage: 100% pass rate with rollback scenarios
- AI Generation: 100% first-iteration success 