# Ukulele Coach

A free, fully offline Flutter app that helps beginners tune their ukulele, keep time, learn chords, practice progressions, and build a daily practice habit — with zero accounts, zero paid services, and zero data leaving the device.

## Features

- **Tuner** — Real-time YIN pitch detection with neon needle gauge
- **Metronome** — 40–220 BPM with accent beats in 4/4
- **Chords** — Beginner chord library (C, Am, F, G7, G, Em, A, D)
- **Songs** — Simplified public-domain practice progressions (no lyrics)
- **Practice** — Daily streak tracker stored locally

## Getting Started

```bash
flutter pub get
flutter run
```

To regenerate metronome click sounds:

```bash
python3 scripts/generate_clicks.py
```

## Privacy

- Microphone permission is used only for on-device pitch detection
- No network requests, accounts, or analytics
