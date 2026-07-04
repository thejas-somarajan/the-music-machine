import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukelele_tuner/services/practice_tracker_service.dart';

void main() {
  group('PracticeTrackerService', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('first log sets streak to 1 and increments total', () async {
      final tracker = await PracticeTrackerService.create();
      expect(tracker.canLogToday, isTrue);

      final logged = await tracker.logToday();
      expect(logged, isTrue);
      expect(tracker.streak, 1);
      expect(tracker.totalSessions, 1);
      expect(tracker.canLogToday, isFalse);
    });

    test('second log same day is no-op', () async {
      final tracker = await PracticeTrackerService.create();
      await tracker.logToday();
      final logged = await tracker.logToday();
      expect(logged, isFalse);
      expect(tracker.totalSessions, 1);
    });

    test('log after gap resets streak to 1', () async {
      SharedPreferences.setMockInitialValues({
        'lastPracticeDate': '2020-01-01',
        'currentStreak': 10,
        'totalSessions': 10,
      });
      final tracker = await PracticeTrackerService.create();
      await tracker.logToday();
      expect(tracker.streak, 1);
      expect(tracker.totalSessions, 11);
    });
  });
}
