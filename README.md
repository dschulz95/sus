# Imposter 🕵️

A hot-seat party game built with **Flutter**. Pick a category, set the number
of players, and deal a secret word to the crew — while one or two hidden
imposters try to blend in without knowing the word.

> German / English · Local multiplayer (pass the device)

## How to play

1. Choose a **category** and the **number of players** (4–12).
2. Decide whether **1 or 2** players are the imposters.
3. Each player secretly reveals their card:
   - **Crewmates** see the secret word.
   - **Imposters** see nothing — they must blend in.
4. Discuss the word without naming it.
5. **Vote out** who you think the imposter is.

Crewmates win by catching an imposter; the imposter wins by staying hidden.

## Features

- 12 bilingual categories (144 words) in **German & English**
- 4–12 players, 1 or 2 imposters
- Optional discussion timer (off / 2 / 3 / 5 min)
- Pass-the-device reveal flow with private cards
- Group vote and result screen
- Dependency-light architecture with fully unit-tested game logic

## Getting started

Requirements: Flutter SDK 3.x (Dart 3.x).

```bash
git clone <repository-url>
cd imposter_game
flutter pub get
flutter run
```

Run the tests:

```bash
flutter test
```

## Project structure

```
lib/
  data/       # built-in categories & terms (bilingual)
  l10n/       # .arb localization files (gen_l10n)
  models/     # domain models
  screens/    # UI screens
  services/   # GameEngine (pure game logic)
  theme/      # app theme
  widgets/    # shared widgets
  app.dart     # MaterialApp
  main.dart    # entry point
test/
  game_engine_test.dart
  widget_test.dart
```

## Roadmap

- Online multiplayer via a backend (Firebase / Supabase)
- Custom categories & word packs
- Per-player secret voting
- Score tracking across rounds

## License

MIT — see [LICENSE](LICENSE).
