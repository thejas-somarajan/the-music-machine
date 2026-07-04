import 'dart:async';
import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:ukelele_tuner/theme/neon_theme.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key, required this.child});

  final Widget child;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ambientController;
  late final List<_Particle> _particles;
  late final List<_DataStream> _dataStreams;
  final _random = Random(42);

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    _particles = List.generate(48, (_) => _Particle.random(_random));
    _dataStreams = List.generate(10, (_) => _DataStream.random(_random));
  }

  @override
  void dispose() {
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ambientController,
      builder: (context, child) {
        return CustomPaint(
          painter: _CyberpunkBackgroundPainter(
            ambient: _ambientController.value,
            particles: _particles,
            dataStreams: _dataStreams,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.radius,
    required this.color,
    required this.phase,
  });

  final double x;
  final double y;
  final double speed;
  final double radius;
  final Color color;
  final double phase;

  factory _Particle.random(Random random) {
    final palette = [
      NeonColors.neonMagenta,
      NeonColors.neonGreen,
    ];
    return _Particle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      speed: 0.04 + random.nextDouble() * 0.12,
      radius: 0.8 + random.nextDouble() * 2.2,
      color: palette[random.nextInt(palette.length)],
      phase: random.nextDouble() * pi * 2,
    );
  }
}

class _DataStream {
  _DataStream({
    required this.x,
    required this.speed,
    required this.length,
    required this.phase,
  });

  final double x;
  final double speed;
  final int length;
  final double phase;

  factory _DataStream.random(Random random) {
    return _DataStream(
      x: random.nextDouble(),
      speed: 0.15 + random.nextDouble() * 0.35,
      length: 4 + random.nextInt(8),
      phase: random.nextDouble(),
    );
  }
}

class _CyberpunkBackgroundPainter extends CustomPainter {
  _CyberpunkBackgroundPainter({
    required this.ambient,
    required this.particles,
    required this.dataStreams,
  });

  final double ambient;
  final List<_Particle> particles;
  final List<_DataStream> dataStreams;

  @override
  void paint(Canvas canvas, Size size) {
    _paintBaseGradient(canvas, size);
    _paintPerspectiveGrid(canvas, size);
    _paintDataStreams(canvas, size);
    _paintParticles(canvas, size);
    _paintCrtOverlay(canvas, size);
    _paintVignette(canvas, size);
  }

  void _paintBaseGradient(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0014),
            Color(0xFF050508),
            Color(0xFF080012),
          ],
        ).createShader(rect),
    );
  }

  void _paintPerspectiveGrid(Canvas canvas, Size size) {
    final horizonY = size.height * 0.38;
    final centerX = size.width / 2;
    final floorHeight = size.height - horizonY;
    final scroll = ambient;

    const verticalCount = 14;
    for (var i = 0; i <= verticalCount; i++) {
      final t = i / verticalCount;
      final bottomX = centerX + (t - 0.5) * size.width * 1.35;
      final flicker = 0.55 + sin(ambient * pi * 4 + i * 0.8) * 0.2;

      final paint = Paint()
        ..strokeWidth = 1
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            NeonColors.neonCyan.withValues(alpha: 0),
            NeonColors.neonCyan.withValues(alpha: 0.22 * flicker),
            NeonColors.neonCyan.withValues(alpha: 0.28 * flicker),
          ],
        ).createShader(Rect.fromLTWH(0, horizonY, size.width, floorHeight));

      canvas.drawLine(
        Offset(centerX, horizonY),
        Offset(bottomX, size.height),
        paint,
      );
    }

    const horizontalCount = 18;
    for (var i = 0; i < horizontalCount; i++) {
      final progress = ((i / horizontalCount) + scroll) % 1.0;
      final eased = pow(progress, 1.65).toDouble();
      final y = horizonY + floorHeight * eased;
      final spread = (y - horizonY) / floorHeight;
      final halfWidth = spread * size.width * 0.58;
      final alpha = (1 - progress) * 0.45;

      final paint = Paint()
        ..color = NeonColors.neonCyan.withValues(alpha: alpha)
        ..strokeWidth = 1;

      canvas.drawLine(
        Offset(centerX - halfWidth, y),
        Offset(centerX + halfWidth, y),
        paint,
      );
    }
  }

  void _paintDataStreams(Canvas canvas, Size size) {
    for (final stream in dataStreams) {
      final x = stream.x * size.width;
      final headY = ((ambient * stream.speed + stream.phase) % 1.0) * size.height;

      for (var i = 0; i < stream.length; i++) {
        final y = (headY - i * 14) % size.height;
        final alpha = (1 - i / stream.length) * 0.35;

        canvas.drawCircle(
          Offset(x, y),
          1.2,
          Paint()..color = NeonColors.neonGreen.withValues(alpha: alpha),
        );
      }
    }
  }

  void _paintParticles(Canvas canvas, Size size) {
    final t = ambient * pi * 2;

    for (final particle in particles) {
      final driftX = sin(t * particle.speed * 3 + particle.phase) * 12;
      final y =
          ((particle.y + ambient * particle.speed) % 1.0) * size.height;
      final x = particle.x * size.width + driftX;
      final twinkle = 0.4 + sin(t * 2 + particle.phase) * 0.6;

      canvas.drawCircle(
        Offset(x, y),
        particle.radius,
        Paint()
          ..color = particle.color.withValues(alpha: 0.25 * twinkle)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
    }
  }

  void _paintCrtOverlay(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.018)
      ..strokeWidth = 1;

    for (var y = 0.0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  void _paintVignette(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.45);
    final radius = max(size.width, size.height) * 0.85;

    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.55),
          ],
          stops: const [0.45, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  @override
  bool shouldRepaint(covariant _CyberpunkBackgroundPainter oldDelegate) {
    return oldDelegate.ambient != ambient;
  }
}

class GlitchText extends StatefulWidget {
  const GlitchText({
    super.key,
    required this.text,
    required this.style,
  });

  final String text;
  final TextStyle style;

  @override
  State<GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<GlitchText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _random = Random();
  Timer? _glitchTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scheduleGlitch();
  }

  void _scheduleGlitch() {
    _glitchTimer?.cancel();
    _glitchTimer = Timer(Duration(milliseconds: 1800 + _random.nextInt(3200)), () {
      if (!mounted) return;
      _controller.forward(from: 0).then((_) {
        if (mounted) _scheduleGlitch();
      });
    });
  }

  @override
  void dispose() {
    _glitchTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final glitching = t > 0 && t < 1;
        final offsetX = glitching ? (_random.nextBool() ? 3.0 : -3.0) * t : 0.0;
        final offsetY = glitching ? 1.5 * t : 0.0;
        final split = glitching ? lerpDouble(0, 2, t)! : 0.0;

        return Stack(
          alignment: Alignment.center,
          children: [
            if (glitching) ...[
              Transform.translate(
                offset: Offset(-split, 0),
                child: Text(
                  widget.text,
                  style: widget.style.copyWith(
                    color: NeonColors.neonMagenta.withValues(alpha: 0.7),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(split, 0),
                child: Text(
                  widget.text,
                  style: widget.style.copyWith(
                    color: NeonColors.neonCyan.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
            Transform.translate(
              offset: Offset(offsetX, offsetY),
              child: Text(widget.text, style: widget.style),
            ),
          ],
        );
      },
    );
  }
}
