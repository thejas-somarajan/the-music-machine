import 'package:shared_preferences/shared_preferences.dart';

class PracticeTrackerService {
  PracticeTrackerService(this._prefs);

  static const _keyLastDate = 'lastPracticeDate';
  static const _keyStreak = 'currentStreak';
  static const _keyTotal = 'totalSessions';

  final SharedPreferences _prefs;

  static Future<PracticeTrackerService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PracticeTrackerService(prefs);
  }

  int get streak => _prefs.getInt(_keyStreak) ?? 0;
  int get totalSessions => _prefs.getInt(_keyTotal) ?? 0;

  bool get canLogToday {
    final last = _prefs.getString(_keyLastDate);
    return last != _dateOnly(DateTime.now());
  }

  bool get loggedToday => !canLogToday;

  Future<bool> logToday() async {
    final today = _dateOnly(DateTime.now());
    final lastDateStr = _prefs.getString(_keyLastDate);
    if (lastDateStr == today) return false;

    var newStreak = 1;
    if (lastDateStr != null) {
      final lastDate = DateTime.parse(lastDateStr);
      final daysSince = DateTime.now().difference(lastDate).inDays;
      if (daysSince == 1) {
        newStreak = streak + 1;
      }
    }

    await _prefs.setString(_keyLastDate, today);
    await _prefs.setInt(_keyStreak, newStreak);
    await _prefs.setInt(_keyTotal, totalSessions + 1);
    return true;
  }

  static String _dateOnly(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
