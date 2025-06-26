import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('All files using WorldChefTextStyles must import typography.dart', () {
    final libDir = Directory('mobile/lib');
    final offendingFiles = <String>[];

    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File) continue;
      if (!entity.path.endsWith('.dart')) continue;
      if (entity.path.contains('typography.dart')) continue;

      final content = entity.readAsStringSync();
      if (content.contains('WorldChefTextStyles') &&
          !content.contains("core/design_system/typography.dart")) {
        offendingFiles.add(entity.path);
      }
    }

    expect(offendingFiles, isEmpty, reason: 'Files missing typography import:\n${offendingFiles.join('\n')}');
  });
} 