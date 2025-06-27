import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  // This test intentionally does nothing except rely on the imports above.
  // If the project compiles successfully, it means the required dependencies
  // are present. In the current Red phase, we expect compilation to fail.
  test('compile health – ensure critical packages resolve', () {
    expect(true, isTrue);
  });
}
