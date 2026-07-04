import 'dart:math';
import 'dart:typed_data';

/// On-device fundamental frequency estimation using the YIN algorithm.
class PitchDetector {
  PitchDetector({
    required this.sampleRate,
    this.threshold = 0.15,
    this.minRms = 0.003,
  });

  final int sampleRate;
  final double threshold;
  final double minRms;

  double? getPitch(Float32List buffer) {
    if (buffer.isEmpty) return null;

    var sumSquares = 0.0;
    for (final sample in buffer) {
      sumSquares += sample * sample;
    }
    final rms = sqrt(sumSquares / buffer.length);
    if (rms < minRms) return null;

    final yinBuffer = Float64List(buffer.length ~/ 2);
    _differenceFunction(buffer, yinBuffer);
    _cumulativeMeanNormalizedDifference(yinBuffer);

    var tauEstimate = -1;
    for (var tau = 2; tau < yinBuffer.length; tau++) {
      if (yinBuffer[tau] < threshold) {
        while (tau + 1 < yinBuffer.length && yinBuffer[tau + 1] < yinBuffer[tau]) {
          tau++;
        }
        tauEstimate = tau;
        break;
      }
    }

    if (tauEstimate == -1) return null;

    final betterTau = _parabolicInterpolation(yinBuffer, tauEstimate);
    if (betterTau <= 0) return null;

    final frequency = sampleRate / betterTau;
    if (frequency < 60 || frequency > 1200) return null;

    return frequency;
  }

  void _differenceFunction(Float32List buffer, Float64List yinBuffer) {
    for (var tau = 0; tau < yinBuffer.length; tau++) {
      var sum = 0.0;
      for (var i = 0; i < yinBuffer.length; i++) {
        final delta = buffer[i] - buffer[i + tau];
        sum += delta * delta;
      }
      yinBuffer[tau] = sum;
    }
  }

  void _cumulativeMeanNormalizedDifference(Float64List yinBuffer) {
    yinBuffer[0] = 1;
    var runningSum = 0.0;
    for (var tau = 1; tau < yinBuffer.length; tau++) {
      runningSum += yinBuffer[tau];
      yinBuffer[tau] *= tau / runningSum;
    }
  }

  double _parabolicInterpolation(Float64List yinBuffer, int tau) {
    if (tau <= 0 || tau >= yinBuffer.length - 1) return tau.toDouble();

    final s0 = yinBuffer[tau - 1];
    final s1 = yinBuffer[tau];
    final s2 = yinBuffer[tau + 1];
    final adjustment = (s2 - s0) / (2 * (2 * s1 - s2 - s0));
    return tau + adjustment;
  }
}
