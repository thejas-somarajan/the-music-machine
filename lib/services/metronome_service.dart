import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class MetronomeService extends ChangeNotifier {
  AudioPlayer? _player;
  Timer? _timer;

  int _bpm = 120;
  int _beat = 0;
  bool _running = false;

  int get bpm => _bpm;
  int get beat => _beat;
  bool get isRunning => _running;

  void setBpm(int value) {
    _bpm = value.clamp(40, 220);
    if (_running) {
      _reschedule();
    }
    notifyListeners();
  }

  void start() {
    if (_running) return;
    _running = true;
    _beat = 0;
    _reschedule();
    notifyListeners();
  }

  void stop() {
    _running = false;
    _timer?.cancel();
    _timer = null;
    _beat = 0;
    notifyListeners();
  }

  void _reschedule() {
    _timer?.cancel();
    final interval = Duration(milliseconds: (60000 / _bpm).round());
    _timer = Timer.periodic(interval, (_) => _onTick());
    _onTick();
  }

  Future<void> _onTick() async {
    if (!_running) return;

    try {
      _player ??= AudioPlayer()..setReleaseMode(ReleaseMode.stop);
      final isAccent = _beat == 0;
      await _player!.stop();
      await _player!.play(
        AssetSource(isAccent ? 'audio/accent.wav' : 'audio/click.wav'),
      );
    } catch (e) {
      debugPrint('Metronome playback error: $e');
    }

    _beat = (_beat + 1) % 4;
    notifyListeners();
  }

  @override
  void dispose() {
    stop();
    _player?.dispose();
    _player = null;
    super.dispose();
  }
}
