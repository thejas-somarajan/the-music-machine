import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NeonColors {
  static const background = Color(0xFF050508);
  static const surface = Color(0xFF0D0D18);
  static const neonCyan = Color(0xFF00F5FF);
  static const neonMagenta = Color(0xFFFF2BD6);
  static const neonGreen = Color(0xFF39FF14);
  static const neonAmber = Color(0xFFFFB800);
  static const neonViolet = Color(0xFF9D4EDD);
  static const textPrimary = Color(0xFFE8E8F0);
  static const textMuted = Color(0xFF6B6B80);
}

class NeonGlow {
  static List<BoxShadow> box(Color color, {double blur = 20, double spread = 2}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.6),
        blurRadius: blur,
        spreadRadius: spread,
      ),
      BoxShadow(
        color: color.withValues(alpha: 0.25),
        blurRadius: blur * 2,
        spreadRadius: spread,
      ),
    ];
  }

  static List<Shadow> text(Color color, {double blur = 12}) {
    return [
      Shadow(color: color.withValues(alpha: 0.9), blurRadius: blur),
      Shadow(color: color.withValues(alpha: 0.45), blurRadius: blur * 2),
    ];
  }
}

class CyberpunkFonts {
  static TextStyle display(TextStyle? style) =>
      GoogleFonts.audiowide(textStyle: style);

  static TextStyle ui(TextStyle? style) =>
      GoogleFonts.chakraPetch(textStyle: style);

  static TextStyle mono(TextStyle? style) =>
      GoogleFonts.shareTechMono(textStyle: style);
}

class NeonTheme {
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    final textTheme = TextTheme(
      displayLarge: CyberpunkFonts.display(base.textTheme.displayLarge),
      displayMedium: CyberpunkFonts.display(base.textTheme.displayMedium),
      displaySmall: CyberpunkFonts.display(base.textTheme.displaySmall),
      headlineLarge: CyberpunkFonts.display(base.textTheme.headlineLarge),
      headlineMedium: CyberpunkFonts.display(base.textTheme.headlineMedium),
      headlineSmall: CyberpunkFonts.mono(base.textTheme.headlineSmall),
      titleLarge: CyberpunkFonts.ui(
        base.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      titleMedium: CyberpunkFonts.ui(
        base.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      titleSmall: CyberpunkFonts.ui(base.textTheme.titleSmall),
      bodyLarge: CyberpunkFonts.ui(base.textTheme.bodyLarge),
      bodyMedium: CyberpunkFonts.ui(base.textTheme.bodyMedium),
      bodySmall: CyberpunkFonts.mono(base.textTheme.bodySmall),
      labelLarge: CyberpunkFonts.mono(base.textTheme.labelLarge),
      labelMedium: CyberpunkFonts.mono(base.textTheme.labelMedium),
      labelSmall: CyberpunkFonts.mono(
        base.textTheme.labelSmall?.copyWith(letterSpacing: 1.2),
      ),
    ).apply(
      bodyColor: NeonColors.textPrimary,
      displayColor: NeonColors.textPrimary,
    );

    return base.copyWith(
      scaffoldBackgroundColor: NeonColors.background,
      colorScheme: const ColorScheme.dark(
        surface: NeonColors.surface,
        primary: NeonColors.neonCyan,
        secondary: NeonColors.neonMagenta,
        tertiary: NeonColors.neonGreen,
      ),
      textTheme: textTheme,
    );
  }
}
