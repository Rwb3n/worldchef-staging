import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldchef_mobile/src/screens/home_feed_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Minimal Flutter application that satisfies existing widget tests.
///
/// This will be replaced in future tasks with the full WorldChef app
/// once the scaffold and navigation structure are defined.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorldChef',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const ProviderScope(child: HomeFeedScreen()),
    );
  }
}
