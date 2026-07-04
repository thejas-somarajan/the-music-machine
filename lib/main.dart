import 'package:flutter/material.dart';
import 'package:ukelele_tuner/screens/app_shell.dart';
import 'package:ukelele_tuner/theme/neon_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UkuleleCoachApp());
}

class UkuleleCoachApp extends StatelessWidget {
  const UkuleleCoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ukulele Coach',
      debugShowCheckedModeBanner: false,
      theme: NeonTheme.dark,
      home: const AppShell(),
    );
  }
}
