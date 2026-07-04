import 'package:flutter/material.dart';
import 'package:ukelele_tuner/services/practice_tracker_service.dart';
import 'package:ukelele_tuner/theme/neon_theme.dart';
import 'package:ukelele_tuner/widgets/neon_primitives.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  PracticeTrackerService? _tracker;
  bool _loading = true;
  bool _justLogged = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final tracker = await PracticeTrackerService.create();
      if (!mounted) return;
      setState(() {
        _tracker = tracker;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _logPractice() async {
    final tracker = _tracker;
    if (tracker == null || !tracker.canLogToday) return;

    final logged = await tracker.logToday();
    if (!mounted) return;
    setState(() {
      _justLogged = logged;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: NeonColors.neonCyan),
      );
    }

    if (_tracker == null) {
      return Column(
        children: [
          const NeonScreenHeader(title: 'PRACTICE'),
          const Spacer(),
          Text(
            'Practice tracker unavailable.\nStop the app and run a full rebuild.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: NeonColors.textMuted,
                ),
          ),
          const Spacer(flex: 2),
        ],
      );
    }

    final tracker = _tracker!;
    final logged = tracker.loggedToday || _justLogged;

    return Column(
      children: [
        const NeonScreenHeader(title: 'PRACTICE'),
        const Spacer(),
        Icon(
          Icons.local_fire_department_rounded,
          size: 80,
          color: NeonColors.neonAmber,
        ),
        const SizedBox(height: 24),
        Text(
          '${tracker.streak}',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: NeonColors.neonAmber,
                fontWeight: FontWeight.bold,
                shadows: NeonGlow.text(NeonColors.neonAmber, blur: 14),
              ),
        ),
        Text(
          'DAY STREAK',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: NeonColors.textMuted,
                letterSpacing: 4,
              ),
        ),
        const SizedBox(height: 40),
        NeonActionButton(
          label: logged ? 'LOGGED TODAY' : "LOG TODAY'S PRACTICE",
          enabled: !logged,
          color: logged ? NeonColors.neonGreen : NeonColors.neonCyan,
          onPressed: _logPractice,
        ),
        const SizedBox(height: 16),
        Text(
          '${tracker.totalSessions} total sessions',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: NeonColors.textMuted,
              ),
        ),
        const Spacer(flex: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeonStatusDot(
              color: logged ? NeonColors.neonGreen : NeonColors.neonCyan,
              active: true,
            ),
            const SizedBox(width: 10),
            Text(
              logged ? 'LOGGED' : 'READY',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: logged ? NeonColors.neonGreen : NeonColors.textMuted,
                    letterSpacing: 2,
                    shadows: logged
                        ? NeonGlow.text(NeonColors.neonGreen, blur: 6)
                        : null,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
