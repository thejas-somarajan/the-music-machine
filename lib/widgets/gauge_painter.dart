import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ukelele_tuner/theme/neon_theme.dart';

class GaugePainter extends CustomPainter {
  GaugePainter({
    required this.cents,
    required this.inTune,
  });

  final double cents;
  final bool inTune;

  static const _minCents = -50.0;
  static const _maxCents = 50.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.92);
    final radius = min(size.width, size.height) * 0.42;

    _drawArc(canvas, center, radius);
    _drawTicks(canvas, center, radius);
    _drawInTuneZone(canvas, center, radius);
    _drawNeedle(canvas, center, radius);
  }

  void _drawArc(Canvas canvas, Offset center, double radius) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = SweepGradient(
        colors: [
          NeonColors.neonAmber.withValues(alpha: 0.8),
          NeonColors.neonGreen.withValues(alpha: 0.9),
          NeonColors.neonMagenta.withValues(alpha: 0.8),
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(pi),
      ).createShader(rect);

    canvas.drawArc(rect, pi, pi, false, paint);
  }

  void _drawInTuneZone(Canvas canvas, Offset center, double radius) {
    const inTuneCents = 5.0;
    final startAngle = _centsToAngle(-inTuneCents);
    final sweep = _centsToAngle(inTuneCents) - startAngle;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = NeonColors.neonGreen.withValues(alpha: inTune ? 0.55 : 0.25);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 6),
      startAngle,
      sweep,
      false,
      paint,
    );
  }

  void _drawTicks(Canvas canvas, Offset center, double radius) {
    const tickValues = [-50, -25, -10, 0, 10, 25, 50];
    final tickPaint = Paint()
      ..strokeWidth = 2
      ..color = NeonColors.textMuted.withValues(alpha: 0.7);
    final labelStyle = TextStyle(
      color: NeonColors.textMuted,
      fontSize: 11,
      fontWeight: FontWeight.w500,
    );

    for (final tick in tickValues) {
      final angle = _centsToAngle(tick.toDouble());
      final outer = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );
      final inner = Offset(
        center.dx + cos(angle) * (radius - (tick == 0 ? 18 : 12)),
        center.dy + sin(angle) * (radius - (tick == 0 ? 18 : 12)),
      );
      canvas.drawLine(inner, outer, tickPaint);

      final textPainter = TextPainter(
        text: TextSpan(text: tick == 0 ? '0' : '$tick', style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      final labelRadius = radius + 18;
      final labelOffset = Offset(
        center.dx + cos(angle) * labelRadius - textPainter.width / 2,
        center.dy + sin(angle) * labelRadius - textPainter.height / 2,
      );
      textPainter.paint(canvas, labelOffset);
    }
  }

  void _drawNeedle(Canvas canvas, Offset center, double radius) {
    final clamped = cents.clamp(_minCents, _maxCents);
    final angle = _centsToAngle(clamped);

    Color needleColor;
    if (inTune) {
      needleColor = NeonColors.neonGreen;
    } else if (clamped > 0) {
      needleColor = NeonColors.neonMagenta;
    } else if (clamped < 0) {
      needleColor = NeonColors.neonAmber;
    } else {
      needleColor = NeonColors.neonCyan;
    }

    final tip = Offset(
      center.dx + cos(angle) * (radius - 20),
      center.dy + sin(angle) * (radius - 20),
    );

    final glowPaint = Paint()
      ..color = needleColor.withValues(alpha: 0.5)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawLine(center, tip, glowPaint);

    final needlePaint = Paint()
      ..color = needleColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, tip, needlePaint);

    final hubPaint = Paint()..color = NeonColors.neonCyan;
    canvas.drawCircle(center, 8, hubPaint);
    canvas.drawCircle(
      center,
      12,
      Paint()
        ..color = NeonColors.neonCyan.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  double _centsToAngle(double value) {
    final normalized = (value - _minCents) / (_maxCents - _minCents);
    return pi + normalized * pi;
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.cents != cents || oldDelegate.inTune != inTune;
  }
}
