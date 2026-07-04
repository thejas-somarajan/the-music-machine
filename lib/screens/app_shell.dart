import 'package:flutter/material.dart';
import 'package:ukelele_tuner/screens/chords_screen.dart';
import 'package:ukelele_tuner/screens/metronome_screen.dart';
import 'package:ukelele_tuner/screens/practice_screen.dart';
import 'package:ukelele_tuner/screens/songs_screen.dart';
import 'package:ukelele_tuner/screens/tuner_screen.dart';
import 'package:ukelele_tuner/theme/neon_theme.dart';
import 'package:ukelele_tuner/widgets/animated_background.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  final Map<int, Widget> _screenCache = {};

  Widget _screenFor(int index) {
    switch (index) {
      case 0:
        return const TunerScreen();
      case 1:
        return const MetronomeScreen();
      case 2:
        return const ChordsScreen();
      case 3:
        return const SongsScreen();
      case 4:
        return const PracticeScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
      _screenCache.putIfAbsent(index, () => _screenFor(index));
    });
  }

  @override
  void initState() {
    super.initState();
    _screenCache[0] = const TunerScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBackground(
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              for (final entry in _screenCache.entries)
                Offstage(
                  offstage: entry.key != _selectedIndex,
                  child: entry.value,
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 72,
          backgroundColor: NeonColors.surface,
          indicatorColor: NeonColors.neonCyan.withValues(alpha: 0.22),
          surfaceTintColor: Colors.transparent,
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: NeonColors.neonCyan, size: 26);
            }
            return IconThemeData(
              color: NeonColors.neonCyan.withValues(alpha: 0.45),
              size: 24,
            );
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: NeonColors.neonCyan,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              );
            }
            return TextStyle(
              color: NeonColors.neonCyan.withValues(alpha: 0.45),
              fontSize: 12,
              letterSpacing: 0.5,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _selectTab,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.tune_outlined),
              selectedIcon: Icon(Icons.tune),
              label: 'Tuner',
            ),
            NavigationDestination(
              icon: Icon(Icons.timer_outlined),
              selectedIcon: Icon(Icons.timer),
              label: 'Metronome',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view),
              label: 'Chords',
            ),
            NavigationDestination(
              icon: Icon(Icons.queue_music_outlined),
              selectedIcon: Icon(Icons.queue_music),
              label: 'Songs',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_fire_department_outlined),
              selectedIcon: Icon(Icons.local_fire_department),
              label: 'Practice',
            ),
          ],
        ),
      ),
    );
  }
}
