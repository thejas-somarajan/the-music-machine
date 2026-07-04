import 'package:flutter/material.dart';
import 'package:ukelele_tuner/models/chord.dart';
import 'package:ukelele_tuner/theme/neon_theme.dart';

class ChordDiagram extends StatelessWidget {
  const ChordDiagram({
    super.key,
    required this.chord,
    this.size = 100,
  });

  final Chord chord;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.2,
      child: CustomPaint(
        painter: _ChordDiagramPainter(chord: chord),
      ),
    );
  }
}

class _ChordDiagramPainter extends CustomPainter {
  _ChordDiagramPainter({required this.chord});

  final Chord chord;
  static const _stringLabels = ['G', 'C', 'E', 'A'];

  @override
  void paint(Canvas canvas, Size size) {
    const fretCount = 4;
    final padding = size.width * 0.12;
    final nutY = size.height * 0.22;
    final boardBottom = size.height * 0.92;
    final boardHeight = boardBottom - nutY;
    final stringSpacing = (size.width - padding * 2) / 3;
    final fretSpacing = boardHeight / fretCount;

    final gridPaint = Paint()
      ..color = NeonColors.neonCyan.withValues(alpha: 0.5)
      ..strokeWidth = 1.2;

    final nutPaint = Paint()
      ..color = NeonColors.neonCyan.withValues(alpha: 0.9)
      ..strokeWidth = 3;

    canvas.drawLine(
      Offset(padding, nutY),
      Offset(size.width - padding, nutY),
      nutPaint,
    );

    for (var s = 0; s < 4; s++) {
      final x = padding + s * stringSpacing;
      canvas.drawLine(Offset(x, nutY), Offset(x, boardBottom), gridPaint);
    }

    for (var f = 1; f <= fretCount; f++) {
      final y = nutY + f * fretSpacing;
      canvas.drawLine(
        Offset(padding, y),
        Offset(size.width - padding, y),
        gridPaint,
      );
    }

    final labelStyle = TextStyle(
      color: NeonColors.textMuted,
      fontSize: size.width * 0.1,
      fontWeight: FontWeight.w600,
    );
    for (var s = 0; s < 4; s++) {
      final x = padding + s * stringSpacing;
      final tp = TextPainter(
        text: TextSpan(text: _stringLabels[s], style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, nutY - tp.height - 4));
    }

    final dotPaint = Paint()
      ..color = NeonColors.neonMagenta
      ..style = PaintingStyle.fill;

    final openPaint = Paint()
      ..color = NeonColors.neonCyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (var s = 0; s < chord.frets.length; s++) {
      final fret = chord.frets[s];
      final x = padding + s * stringSpacing;
      if (fret < 0) continue;

      if (fret == 0) {
        canvas.drawCircle(Offset(x, nutY - 10), 4, openPaint);
      } else {
        final y = nutY + (fret - 0.5) * fretSpacing;
        canvas.drawCircle(Offset(x, y), 5.5, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ChordDiagramPainter oldDelegate) {
    return oldDelegate.chord.name != chord.name;
  }
}
