import 'package:flutter/material.dart';
import 'package:ukelele_tuner/theme/neon_theme.dart';

class FrequencyDisplay extends StatelessWidget {
  const FrequencyDisplay({
    super.key,
    required this.frequency,
    required this.cents,
    required this.noteName,
    required this.inTune,
    required this.hasSignal,
  });

  final double? frequency;
  final double cents;
  final String? noteName;
  final bool inTune;
  final bool hasSignal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    if (!hasSignal || frequency == null || noteName == null) {
      return Column(
        children: [
          Text(
            '—',
            style: theme.headlineMedium?.copyWith(
              color: NeonColors.textMuted,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'PLAY A STRING',
            style: theme.labelLarge?.copyWith(
              color: NeonColors.textMuted,
              letterSpacing: 3,
            ),
          ),
        ],
      );
    }

    Color centsColor;
    if (inTune) {
      centsColor = NeonColors.neonGreen;
    } else if (cents > 0) {
      centsColor = NeonColors.neonMagenta;
    } else {
      centsColor = NeonColors.neonAmber;
    }

    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: frequency!),
          duration: const Duration(milliseconds: 200),
          builder: (context, value, child) {
            return Text(
              '$noteName · ${value.toStringAsFixed(1)} Hz',
              style: theme.headlineSmall?.copyWith(
                color: NeonColors.textPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                shadows: NeonGlow.text(NeonColors.neonCyan, blur: 10),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: cents),
          duration: const Duration(milliseconds: 200),
          builder: (context, value, child) {
            return AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: theme.titleMedium!.copyWith(
                color: centsColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                shadows: NeonGlow.text(centsColor, blur: 8),
              ),
              child: Text(
                inTune ? 'IN TUNE' : _formatCents(value),
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatCents(double value) {
    if (value > 0) return '+${value.toStringAsFixed(1)} CENTS';
    return '${value.toStringAsFixed(1)} CENTS';
  }
}
