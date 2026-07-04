import 'package:flutter/material.dart';
import 'package:ukelele_tuner/models/chord_data.dart';
import 'package:ukelele_tuner/models/song.dart';
import 'package:ukelele_tuner/models/song_data.dart';
import 'package:ukelele_tuner/theme/neon_theme.dart';
import 'package:ukelele_tuner/widgets/chord_diagram.dart';
import 'package:ukelele_tuner/widgets/neon_primitives.dart';

class SongsScreen extends StatelessWidget {
  const SongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const NeonScreenHeader(title: 'SONGS'),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            itemCount: practiceSongs.length + 1,
            itemBuilder: (context, index) {
              if (index == practiceSongs.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Simplified practice progressions for drilling chord changes — not exact transcriptions. No lyrics included.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: NeonColors.textMuted,
                        ),
                  ),
                );
              }
              return _SongCard(song: practiceSongs[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _SongCard extends StatefulWidget {
  const _SongCard({required this.song});

  final Song song;

  @override
  State<_SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<_SongCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final song = widget.song;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeonCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      song.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: NeonColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: NeonColors.neonMagenta.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Text(
                      song.difficulty.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: NeonColors.neonMagenta,
                            letterSpacing: 1,
                          ),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: NeonColors.neonCyan,
                  ),
                ],
              ),
            ),
            if (_expanded) ...[
              const SizedBox(height: 12),
              Text(
                'CHORDS: ${song.chordsUsed.join(' · ')}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: NeonColors.neonCyan,
                      letterSpacing: 1,
                    ),
              ),
              const SizedBox(height: 16),
              for (final section in song.sections) ...[
                Text(
                  section.name.toUpperCase(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: NeonColors.textPrimary,
                        letterSpacing: 2,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  section.chords.join('  →  '),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: NeonColors.textMuted,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'STRUM: ${section.strumPattern}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: NeonColors.neonGreen,
                        letterSpacing: 2,
                      ),
                ),
                const SizedBox(height: 12),
              ],
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  for (final name in song.chordsUsed)
                    if (chordByName(name) != null)
                      Column(
                        children: [
                          Text(
                            name,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: NeonColors.textMuted,
                                ),
                          ),
                          ChordDiagram(chord: chordByName(name)!, size: 64),
                        ],
                      ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
