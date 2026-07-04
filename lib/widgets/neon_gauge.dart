import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:ukelele_tuner/theme/neon_theme.dart';
import 'package:ukelele_tuner/widgets/gauge_painter.dart';

class NeonGauge extends StatefulWidget {
  const NeonGauge({
    super.key,
    required this.cents,
    required this.inTune,
  });

  final double cents;
  final bool inTune;

  @override
  State<NeonGauge> createState() => _NeonGaugeState();
}

class _NeonGaugeState extends State<NeonGauge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Simulation _simulation;
  double _displayCents = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this)
      ..addListener(() {
        setState(() => _displayCents = _controller.value);
      });
  }

  @override
  void didUpdateWidget(covariant NeonGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cents != widget.cents) {
      _simulation = SpringSimulation(
        const SpringDescription(mass: 1, stiffness: 180, damping: 18),
        _displayCents,
        widget.cents,
        _controller.velocity,
      );
      _controller.animateWith(_simulation);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.inTune)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.9, end: 1.08),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeInOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: NeonGlow.box(
                      NeonColors.neonGreen,
                      blur: 40,
                      spread: 4,
                    ),
                  ),
                ),
              );
            },
            onEnd: () {
              if (mounted && widget.inTune) setState(() {});
            },
          ),
        Container(
          width: 300,
          height: 220,
          decoration: BoxDecoration(
            color: NeonColors.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.inTune
                  ? NeonColors.neonGreen.withValues(alpha: 0.6)
                  : NeonColors.neonCyan.withValues(alpha: 0.25),
            ),
            boxShadow: widget.inTune
                ? NeonGlow.box(NeonColors.neonGreen, blur: 16)
                : null,
          ),
          child: CustomPaint(
            painter: GaugePainter(
              cents: _displayCents,
              inTune: widget.inTune,
            ),
          ),
        ),
      ],
    );
  }
}
