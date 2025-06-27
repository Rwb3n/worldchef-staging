import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RecipesNotifier extends AsyncNotifier<List<String>> {
  static const _boxName = 'recipes_cache';
  static const _key = 'recipes';

  @override
  Future<List<String>> build() async {
    await _ensureHive();
    final box = await Hive.openBox(_boxName);
    final cached = box.get(_key);
    if (cached != null) {
      return List<String>.from(cached as List);
    }
    final fetched = _mockFetch();
    await box.put(_key, fetched);
    return fetched;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final fetched = _mockFetch();
    final box = await Hive.openBox(_boxName);
    await box.put(_key, fetched);
    state = AsyncData(fetched);
  }

  List<String> _mockFetch() {
    return List<String>.generate(20, (i) => 'Recipe ${i + 1}');
  }

  Future<void> _ensureHive() async {
    if (!Hive.isAdapterRegistered(0)) {
      await Hive.initFlutter();
    }
  }
}

final recipesProvider =
    AsyncNotifierProvider<RecipesNotifier, List<String>>(RecipesNotifier.new);
