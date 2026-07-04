import 'package:flutter/material.dart';
import 'package:ukelele_tuner/models/chord_data.dart';
import 'package:ukelele_tuner/theme/neon_theme.dart';
import 'package:ukelele_tuner/widgets/chord_diagram.dart';
import 'package:ukelele_tuner/widgets/neon_primitives.dart';

class ChordsScreen extends StatelessWidget {
  const ChordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const NeonScreenHeader(title: 'CHORDS'),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: beginnerChords.length,
            itemBuilder: (context, index) {
              final chord = beginnerChords[index];
              return NeonCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      chord.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: NeonColors.neonCyan,
                          fontWeight: FontWeight.w700,
                        ),
                    ),
                    const SizedBox(height: 8),
                    ChordDiagram(chord: chord, size: 90),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
