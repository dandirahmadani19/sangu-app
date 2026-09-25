import 'package:flutter_test/flutter_test.dart';
import 'package:sangu/core/ai/gemini_client.dart';

void main() {
  group('resolveModelName', () {
    test('nilai Remote Config non-kosong dipakai apa adanya', () {
      expect(resolveModelName('gemini-3.8-flash'), 'gemini-3.8-flash');
    });

    test('nilai Remote Config kosong → fallback ke default lokal', () {
      expect(resolveModelName(''), isNotEmpty);
    });
  });
}
