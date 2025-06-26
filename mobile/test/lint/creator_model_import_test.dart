import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('All files using CreatorData must import models/creator_data.dart', () {
    final libDir = Directory('mobile/lib');
    final offenders = <String>[];

    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File) continue;
      if (!entity.path.endsWith('.dart')) continue;
      if (entity.path.contains('creator_data.dart')) continue; // model itself

      final content = entity.readAsStringSync();
      if (content.contains('CreatorData(') &&
          !content.contains("src/models/creator_data.dart")) {
        offenders.add(entity.path);
      }
    }

    expect(offenders, isEmpty,
        reason: 'Files missing CreatorData import:\n${offenders.join('\n')}');
  });
} 