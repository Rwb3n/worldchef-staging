import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikeNotifier extends Notifier<bool> {
  @override
  bool build() => false; // initial state: not liked

  void toggle() => state = !state;
}

final likeProvider = NotifierProvider<LikeNotifier, bool>(LikeNotifier.new);
