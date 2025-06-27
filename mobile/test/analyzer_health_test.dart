import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('flutter analyze exits with code 0', () async {
    final result = await Process.run(
      'flutter',
      ['analyze', '--no-congratulate'],
      workingDirectory: Directory.current.path,
    );

    // Expect analyzer clean. This will currently FAIL (Red phase).
    expect(result.exitCode, 0, reason: result.stdout + result.stderr);
  });
} 