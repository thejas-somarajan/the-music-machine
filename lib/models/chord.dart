class Chord {
  const Chord({
    required this.name,
    required this.frets,
  });

  /// Fret positions for G, C, E, A strings. 0 = open, -1 = muted.
  final String name;
  final List<int> frets;
}
