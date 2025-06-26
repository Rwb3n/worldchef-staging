#!/usr/bin/env dart
// Simple CI helper: exits with non-zero if any hex colour literals are found
// in Widgetbook story files. Intended for t009 magic-number lint.
// Usage: dart scripts/check_magic_numbers.dart

import 'dart:io';

final hexPattern = RegExp(r'0xFF[0-9A-Fa-f]{6}');

void main() {
  final widgetbookDir = Directory('lib/widgetbook');
  if (!widgetbookDir.existsSync()) {
    stderr.writeln('Widgetbook directory not found.');
    exit(0); // skip – not an error for other packages
  }

  final offending = <String>[];
  for (final entity in widgetbookDir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = entity.readAsStringSync();
      if (hexPattern.hasMatch(content)) {
        offending.add(entity.path);
      }
    }
  }

  if (offending.isNotEmpty) {
    stderr.writeln('Magic-number hex colours detected in:');
    for (final path in offending) {
      stderr.writeln('  • $path');
    }
    stderr.writeln('Replace with WorldChefColors.* tokens.');
    exit(1);
  }

  stdout.writeln('✓ No magic-number hex colours detected.');
} 