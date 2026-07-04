import 'package:flutter/material.dart';
import 'package:ukelele_tuner/core/tuner_notes.dart';
import 'package:ukelele_tuner/theme/neon_theme.dart';

class StringSelector extends StatelessWidget {
  const StringSelector({
    super.key,
    required this.activeIndex,
    required this.inTuneIndex,
  });

  final int? activeIndex;
  final int? inTuneIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(standardTuning.length, (index) {
        final note = standardTuning[index];
        final isActive = activeIndex == index;
        final isInTune = inTuneIndex == index;

        Color borderColor;
        Color glowColor;
        if (isInTune) {
          borderColor = NeonColors.neonGreen;
          glowColor = NeonColors.neonGreen;
        } else if (isActive) {
          borderColor = NeonColors.neonCyan;
          glowColor = NeonColors.neonCyan;
        } else {
          borderColor = NeonColors.textMuted.withValues(alpha: 0.4);
          glowColor = Colors.transparent;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: AnimatedScale(
            scale: isActive ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: NeonColors.surface.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor, width: 2),
                boxShadow: isActive || isInTune
                    ? NeonGlow.box(glowColor, blur: 14, spread: 1)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    note.label,
                    style: theme.titleMedium?.copyWith(
                      color: isInTune
                          ? NeonColors.neonGreen
                          : isActive
                              ? NeonColors.neonCyan
                              : NeonColors.textMuted,
                      shadows: isActive || isInTune
                          ? NeonGlow.text(glowColor, blur: 6)
                          : null,
                    ),
                  ),
                  Text(
                    '${note.octave}',
                    style: theme.labelSmall?.copyWith(
                      color: isActive
                          ? NeonColors.textPrimary.withValues(alpha: 0.7)
                          : NeonColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
