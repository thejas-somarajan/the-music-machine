#!/usr/bin/env python3
"""Generate metronome click WAV files for Ukulele Coach."""

import math
import struct
import wave
from pathlib import Path

SAMPLE_RATE = 44100
DURATION = 0.06


def generate_tone(path: Path, frequency: float, amplitude: float = 0.5) -> None:
    samples = int(SAMPLE_RATE * DURATION)
    with wave.open(str(path), 'w') as wav:
        wav.setnchannels(1)
        wav.setsampwidth(2)
        wav.setframerate(SAMPLE_RATE)
        frames = bytearray()
        for i in range(samples):
            t = i / SAMPLE_RATE
            envelope = math.exp(-t * 40)
            value = amplitude * envelope * math.sin(2 * math.pi * frequency * t)
            frames.extend(struct.pack('<h', int(value * 32767)))
        wav.writeframes(frames)


def main() -> None:
    out = Path(__file__).resolve().parent.parent / 'assets' / 'audio'
    out.mkdir(parents=True, exist_ok=True)
    generate_tone(out / 'click.wav', 880.0, 0.4)
    generate_tone(out / 'accent.wav', 1320.0, 0.55)
    print(f'Wrote click.wav and accent.wav to {out}')


if __name__ == '__main__':
    main()
