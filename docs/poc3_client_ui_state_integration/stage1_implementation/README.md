# Stage 1 – Core Feature Implementation

Implement the core flows that exercise the integrated UI + server state patterns.

## Focus Areas
1. Recipe List retrieval & pagination (Riverpod AsyncNotifierProvider).
2. Recipe Detail retrieval with hero transition.
3. Like/Unlike action with optimistic update & cache invalidation.
4. UI-only state: Theme toggle & offline banner.

## Expected Artifacts
| Artifact | Path | Description |
|----------|------|-------------|
| `recipe_list_provider.dart` | `lib/providers/recipe_list_provider.dart` | Server state provider for paginated recipe list |
| `recipe_detail_provider.dart` | `lib/providers/recipe_detail_provider.dart` | Provider for recipe details |
| `like_mutation_provider.dart` | `lib/providers/like_mutation_provider.dart` | Mutation provider implementing optimistic update pattern |
| Screen widgets | `lib/screens/` | Flutter widgets for List & Detail |
| Unit tests | `test/unit/` | Provider tests & optimistic update rollback tests |

---
_Last updated: 2025-06-13_ 