import 'package:flutter/material.dart';
import 'package:ukelele_tuner/theme/neon_theme.dart';
import 'package:ukelele_tuner/widgets/animated_background.dart';

class NeonCard extends StatelessWidget {
  const NeonCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.glowColor = NeonColors.neonCyan,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: NeonColors.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: glowColor.withValues(alpha: 0.35)),
      ),
      child: child,
    );
  }
}

class NeonScreenHeader extends StatelessWidget {
  const NeonScreenHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: GlitchText(
        text: title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              letterSpacing: 8,
              color: NeonColors.neonCyan,
              fontWeight: FontWeight.w700,
              shadows: NeonGlow.text(NeonColors.neonCyan, blur: 14),
            ),
      ),
    );
  }
}

class NeonActionButton extends StatelessWidget {
  const NeonActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.color = NeonColors.neonCyan,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: enabled ? onPressed : null,
      style: FilledButton.styleFrom(
        backgroundColor: color.withValues(alpha: enabled ? 0.15 : 0.05),
        foregroundColor: enabled ? color : NeonColors.textMuted,
        disabledBackgroundColor: color.withValues(alpha: 0.05),
        disabledForegroundColor: NeonColors.textMuted,
        side: BorderSide(color: enabled ? color : NeonColors.textMuted),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      ),
      child: Text(label),
    );
  }
}

class NeonStatusDot extends StatelessWidget {
  const NeonStatusDot({
    super.key,
    required this.color,
    required this.active,
    this.size = 10,
  });

  final Color color;
  final bool active;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: active ? size * 1.4 : size,
      height: active ? size * 1.4 : size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? color : color.withValues(alpha: 0.25),
        boxShadow: active ? NeonGlow.box(color, blur: 8, spread: 0) : null,
      ),
    );
  }
}
