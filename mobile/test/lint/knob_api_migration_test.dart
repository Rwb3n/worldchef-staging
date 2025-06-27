import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('No deprecated knobs.options API remains', () {
    final libDir = Directory('lib');
    final offenders = <String>[];

    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File) continue;
      if (!entity.path.endsWith('.dart')) continue;
      final content = entity.readAsStringSync();
      if (content.contains('knobs.options(')) {
        offenders.add(entity.path);
      }
    }

    expect(offenders, isEmpty,
        reason:
            'Deprecated knobs.options API found in:\n${offenders.join('\n')}');
  });
}
