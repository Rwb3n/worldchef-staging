import 'package:flutter_test/flutter_test.dart';
import '../lib/smoke_test.dart';

void main() {
  group('Smoke Test', () {
    test('Mock Server Connectivity', () async {
      print('Starting Flutter Smoke Test...');
      try {
        await SmokeTest.runConnectivityTest();
        print('Flutter smoke test completed successfully!');
      } catch (e) {
        print('Flutter smoke test failed: $e');
        rethrow;
      }
    });
  });
} 