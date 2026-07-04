import 'package:flutter/material.dart';
import 'package:ukelele_tuner/services/metronome_service.dart';
import 'package:ukelele_tuner/theme/neon_theme.dart';
import 'package:ukelele_tuner/widgets/neon_primitives.dart';

class MetronomeScreen extends StatefulWidget {
  const MetronomeScreen({super.key});

  @override
  State<MetronomeScreen> createState() => _MetronomeScreenState();
}

class _MetronomeScreenState extends State<MetronomeScreen> {
  final _metronome = MetronomeService();

  @override
  void dispose() {
    _metronome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _metronome,
      builder: (context, _) {
        return Column(
          children: [
            const NeonScreenHeader(title: 'METRONOME'),
            const Spacer(),
            Text(
              '${_metronome.bpm}',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: NeonColors.neonCyan,
                    fontWeight: FontWeight.bold,
                    shadows: NeonGlow.text(NeonColors.neonCyan, blur: 16),
                  ),
            ),
            Text(
              'BPM',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: NeonColors.textMuted,
                    letterSpacing: 4,
                  ),
            ),
            const SizedBox(height: 32),
            NeonCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _BpmButton(
                        icon: Icons.remove,
                        onPressed: () => _metronome.setBpm(_metronome.bpm - 1),
                      ),
                      const SizedBox(width: 24),
                      _BpmButton(
                        icon: Icons.add,
                        onPressed: () => _metronome.setBpm(_metronome.bpm + 1),
                      ),
                    ],
                  ),
                  Slider(
                    value: _metronome.bpm.toDouble(),
                    min: 40,
                    max: 220,
                    divisions: 180,
                    activeColor: NeonColors.neonCyan,
                    inactiveColor: NeonColors.textMuted.withValues(alpha: 0.3),
                    onChanged: (v) => _metronome.setBpm(v.round()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final active = _metronome.isRunning &&
                    ((_metronome.beat + 3) % 4) == index;
                final isAccentSlot = index == 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: NeonStatusDot(
                    color: isAccentSlot ? NeonColors.neonAmber : NeonColors.neonCyan,
                    active: active,
                    size: 14,
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            NeonActionButton(
              label: _metronome.isRunning ? 'STOP' : 'START',
              onPressed: () {
                if (_metronome.isRunning) {
                  _metronome.stop();
                } else {
                  _metronome.start();
                }
              },
            ),
            const Spacer(flex: 2),
          ],
        );
      },
    );
  }
}

class _BpmButton extends StatelessWidget {
  const _BpmButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: NeonColors.neonCyan.withValues(alpha: 0.15),
        foregroundColor: NeonColors.neonCyan,
        side: const BorderSide(color: NeonColors.neonCyan),
      ),
    );
  }
}
