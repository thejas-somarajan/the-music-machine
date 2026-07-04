import 'package:ukelele_tuner/models/chord.dart';

const beginnerChords = <Chord>[
  Chord(name: 'C', frets: [0, 0, 0, 3]),
  Chord(name: 'Am', frets: [2, 0, 0, 0]),
  Chord(name: 'F', frets: [2, 0, 1, 0]),
  Chord(name: 'G7', frets: [0, 2, 1, 2]),
  Chord(name: 'G', frets: [0, 2, 3, 2]),
  Chord(name: 'Em', frets: [0, 4, 3, 2]),
  Chord(name: 'A', frets: [2, 1, 0, 0]),
  Chord(name: 'D', frets: [2, 2, 2, 0]),
];

Chord? chordByName(String name) {
  for (final chord in beginnerChords) {
    if (chord.name == name) return chord;
  }
  return null;
}
