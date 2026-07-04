import 'dart:math';

class TuningNote {
  const TuningNote({
    required this.name,
    required this.octave,
    required this.frequency,
    required this.label,
  });

  final String name;
  final int octave;
  final double frequency;
  final String label;
}

const standardTuning = <TuningNote>[
  TuningNote(name: 'G', octave: 4, frequency: 392.0, label: 'G'),
  TuningNote(name: 'C', octave: 4, frequency: 261.63, label: 'C'),
  TuningNote(name: 'E', octave: 4, frequency: 329.63, label: 'E'),
  TuningNote(name: 'A', octave: 4, frequency: 440.0, label: 'A'),
];

class StringMatch {
  const StringMatch({
    required this.note,
    required this.index,
    required this.cents,
  });

  final TuningNote note;
  final int index;
  final double cents;
}

double frequencyToCents(double frequency, double targetFrequency) {
  if (frequency <= 0 || targetFrequency <= 0) return 0;
  return 1200 * (log(frequency / targetFrequency) / ln2);
}

StringMatch closestString(double frequency) {
  var bestIndex = 0;
  var bestCents = frequencyToCents(frequency, standardTuning[0].frequency);
  var bestAbs = bestCents.abs();

  for (var i = 1; i < standardTuning.length; i++) {
    final cents = frequencyToCents(frequency, standardTuning[i].frequency);
    final absCents = cents.abs();
    if (absCents < bestAbs) {
      bestIndex = i;
      bestCents = cents;
      bestAbs = absCents;
    }
  }

  return StringMatch(
    note: standardTuning[bestIndex],
    index: bestIndex,
    cents: bestCents,
  );
}

bool isInTune(double cents, {double threshold = 5}) => cents.abs() <= threshold;
