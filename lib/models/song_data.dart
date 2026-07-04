import 'package:ukelele_tuner/models/song.dart';

const practiceSongs = <Song>[
  Song(
    title: 'Twinkle, Twinkle, Little Star',
    difficulty: 'Beginner',
    chordsUsed: ['C', 'G7', 'F', 'C'],
    sections: [
      SongSection(
        name: 'Verse',
        chords: ['C', 'C', 'G7', 'G7', 'C', 'C', 'G7', 'C'],
        strumPattern: 'D DU D DU',
      ),
    ],
  ),
  Song(
    title: 'You Are My Sunshine',
    difficulty: 'Beginner',
    chordsUsed: ['C', 'G7', 'F', 'C', 'G'],
    sections: [
      SongSection(
        name: 'Verse',
        chords: ['C', 'C', 'G7', 'G7', 'C', 'F', 'C', 'G7', 'C'],
        strumPattern: 'D DU D DU',
      ),
      SongSection(
        name: 'Chorus',
        chords: ['C', 'G', 'C', 'F', 'C', 'G7', 'C'],
        strumPattern: 'D D DU DU',
      ),
    ],
  ),
  Song(
    title: 'Amazing Grace',
    difficulty: 'Beginner',
    chordsUsed: ['C', 'F', 'G7', 'C'],
    sections: [
      SongSection(
        name: 'Verse',
        chords: ['C', 'F', 'C', 'C', 'G7', 'C', 'F', 'C', 'G7', 'C'],
        strumPattern: 'D DU D DU',
      ),
    ],
  ),
  Song(
    title: 'Happy Birthday',
    difficulty: 'Beginner',
    chordsUsed: ['C', 'G7', 'F', 'C'],
    sections: [
      SongSection(
        name: 'Verse',
        chords: ['C', 'C', 'G7', 'C', 'F', 'C', 'G7', 'C'],
        strumPattern: 'D DU D DU',
      ),
    ],
  ),
];
