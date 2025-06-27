import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Verify no GoogleFonts.lora usage remains (Red step)', () {
    final offenders = <String>[];
    final libDir = Directory('lib');

    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File) continue;
      if (!entity.path.endsWith('.dart')) continue;

      final content = entity.readAsStringSync();
      final hasLora = RegExp(r'GoogleFonts\.lora\s*\(').hasMatch(content);
      if (hasLora) {
        offenders.add(entity.path);
      }
    }

    expect(offenders, isEmpty,
        reason:
            'The following files still reference GoogleFonts.lora:\n${offenders.join('\n')}');
  });
} 