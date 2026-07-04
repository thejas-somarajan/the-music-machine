import 'package:flutter_test/flutter_test.dart';
import 'package:ukelele_tuner/models/tuning_note.dart';

void main() {
  group('tuning_note', () {
    test('closestString picks nearest ukulele string', () {
      final match = closestString(392.0);
      expect(match.note.name, 'G');
      expect(match.cents.abs(), lessThan(1));
    });

    test('isInTune respects threshold', () {
      expect(isInTune(4.9), isTrue);
      expect(isInTune(5.1), isFalse);
      expect(isInTune(-5.0), isTrue);
    });

    test('frequencyToCents is zero at target', () {
      expect(frequencyToCents(440, 440), closeTo(0, 0.001));
    });
  });
}
