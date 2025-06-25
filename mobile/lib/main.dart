import 'package:flutter/material.dart';

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
      home: const _CounterHomePage(),
    );
  }
}

class _CounterHomePage extends StatefulWidget {
  const _CounterHomePage();

  @override
  State<_CounterHomePage> createState() => _CounterHomePageState();
}

class _CounterHomePageState extends State<_CounterHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WorldChef'),
      ),
      body: Center(
        child: Text('$_counter', key: const Key('counterText')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
} 