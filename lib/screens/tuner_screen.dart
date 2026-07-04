import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ukelele_tuner/core/pitch_detector.dart';
import 'package:ukelele_tuner/core/tuner_notes.dart';
import 'package:ukelele_tuner/theme/neon_theme.dart';
import 'package:ukelele_tuner/widgets/animated_background.dart';
import 'package:ukelele_tuner/widgets/frequency_display.dart';
import 'package:ukelele_tuner/widgets/neon_gauge.dart';
import 'package:ukelele_tuner/widgets/string_selector.dart';

enum TunerState { idle, listening, detecting, inTune }

class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen>
    with SingleTickerProviderStateMixin {
  static const _sampleRate = 44100;
  static const _bufferSize = 2048;
  static const _inTuneThreshold = 5.0;
  static const _smoothingFactor = 0.3;

  final _audioCapture = FlutterAudioCapture();
  final _pitchDetector = PitchDetector(sampleRate: _sampleRate);

  TunerState _state = TunerState.idle;
  bool _hasPermission = false;
  double? _frequency;
  double _smoothedCents = 0;
  int? _activeStringIndex;
  String? _noteLabel;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _initMicrophone();
  }

  Future<void> _initMicrophone() async {
    final status = await Permission.microphone.request();
    if (!mounted) return;

    if (status.isGranted) {
      setState(() {
        _hasPermission = true;
        _state = TunerState.listening;
      });
      await _startCapture();
    } else {
      setState(() {
        _hasPermission = false;
        _state = TunerState.idle;
      });
    }
  }

  Future<void> _startCapture() async {
    try {
      await _audioCapture.start(
        _onAudio,
        _onCaptureError,
        sampleRate: _sampleRate,
        bufferSize: _bufferSize,
      );
    } catch (e) {
      _onCaptureError(e);
    }
  }

  void _onAudio(dynamic obj) {
    final samples = Float32List.fromList(
      (obj as List).map((e) => (e as num).toDouble()).toList(),
    );

    final pitch = _pitchDetector.getPitch(samples);
    if (!mounted) return;

    if (pitch == null) {
      setState(() {
        _frequency = null;
        _noteLabel = null;
        _activeStringIndex = null;
        _smoothedCents = _smoothedCents * 0.85;
        _state = TunerState.listening;
      });
      return;
    }

    final match = closestString(pitch);
    final smoothed = _smoothedCents * (1 - _smoothingFactor) +
        match.cents * _smoothingFactor;
    final inTune = isInTune(smoothed, threshold: _inTuneThreshold);

    setState(() {
      _frequency = pitch;
      _smoothedCents = smoothed;
      _activeStringIndex = match.index;
      _noteLabel = '${match.note.name}${match.note.octave}';
      _state = inTune ? TunerState.inTune : TunerState.detecting;
    });
  }

  void _onCaptureError(Object error) {
    if (!mounted) return;
    setState(() => _state = TunerState.idle);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _audioCapture.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inTune = _state == TunerState.inTune;
    final hasSignal = _frequency != null;

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: _hasPermission ? _buildTuner(inTune, hasSignal) : _buildPermissionGate(),
        ),
      ),
    );
  }

  Widget _buildPermissionGate() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 600),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: NeonColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: NeonColors.neonCyan.withValues(alpha: 0.5)),
              boxShadow: NeonGlow.box(NeonColors.neonCyan),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.mic_none_rounded,
                  size: 48,
                  color: NeonColors.neonCyan,
                ),
                const SizedBox(height: 16),
                Text(
                  'Microphone Access',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: NeonColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This app needs the microphone to detect the pitch of your ukulele strings. All processing happens on your device.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: NeonColors.textMuted,
                      ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _initMicrophone,
                  style: FilledButton.styleFrom(
                    backgroundColor: NeonColors.neonCyan.withValues(alpha: 0.15),
                    foregroundColor: NeonColors.neonCyan,
                    side: const BorderSide(color: NeonColors.neonCyan),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                  ),
                  child: const Text('Enable Microphone'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTuner(bool inTune, bool hasSignal) {
    return Column(
      children: [
        const SizedBox(height: 24),
        GlitchText(
          text: 'THE MUSIC MACHINE',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                letterSpacing: 8,
                color: NeonColors.neonCyan,
                fontWeight: FontWeight.w700,
                shadows: NeonGlow.text(NeonColors.neonCyan, blur: 14),
              ),
        ),
        const Spacer(),
        NeonGauge(cents: _smoothedCents, inTune: inTune),
        const SizedBox(height: 32),
        FrequencyDisplay(
          frequency: _frequency,
          cents: _smoothedCents,
          noteName: _noteLabel,
          inTune: inTune,
          hasSignal: hasSignal,
        ),
        const SizedBox(height: 36),
        StringSelector(
          activeIndex: _activeStringIndex,
          inTuneIndex: inTune ? _activeStringIndex : null,
        ),
        const Spacer(),
        _buildStatusRow(inTune, hasSignal),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildStatusRow(bool inTune, bool hasSignal) {
    Color dotColor;
    String statusText;

    switch (_state) {
      case TunerState.inTune:
        dotColor = NeonColors.neonGreen;
        statusText = 'In tune!';
      case TunerState.detecting:
        dotColor = NeonColors.neonCyan;
        statusText = 'Detecting...';
      case TunerState.listening:
        dotColor = NeonColors.textMuted;
        statusText = 'Listening...';
      case TunerState.idle:
        dotColor = NeonColors.neonAmber;
        statusText = 'Idle';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final scale = hasSignal || _state == TunerState.listening
                ? 0.8 + _pulseController.value * 0.4
                : 1.0;
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                  boxShadow: NeonGlow.box(dotColor, blur: 8, spread: 0),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        Text(
          statusText.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: inTune ? NeonColors.neonGreen : NeonColors.textMuted,
                letterSpacing: 2,
                shadows: inTune
                    ? NeonGlow.text(NeonColors.neonGreen, blur: 6)
                    : null,
              ),
        ),
      ],
    );
  }
}
