class SongSection {
  const SongSection({
    required this.name,
    required this.chords,
    required this.strumPattern,
  });

  final String name;
  final List<String> chords;
  final String strumPattern;
}

class Song {
  const Song({
    required this.title,
    required this.difficulty,
    required this.chordsUsed,
    required this.sections,
  });

  final String title;
  final String difficulty;
  final List<String> chordsUsed;
  final List<SongSection> sections;
}
