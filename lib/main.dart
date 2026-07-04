import 'package:flutter/material.dart';
import 'package:ukelele_tuner/screens/tuner_screen.dart';
import 'package:ukelele_tuner/theme/neon_theme.dart';

void main() {
  runApp(const UkuleleTunerApp());
}

class UkuleleTunerApp extends StatelessWidget {
  const UkuleleTunerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Music Machine',
      debugShowCheckedModeBanner: false,
      theme: NeonTheme.dark,
      home: const TunerScreen(),
    );
  }
}
