# Imposter 🕵️

A hot-seat party game built with **Flutter**. Pick a category, set the number
of players, and deal a secret word to the crew — while one or two hidden
imposters try to blend in without knowing the word.

> German / English · Local multiplayer (pass the device)

## How to play

1. Choose a **category** and the **number of players** (3–12).
2. Decide whether **1 or 2** players are the imposters.
3. Each player secretly reveals their card:
   - **Crewmates** see the secret word.
   - **Imposters** see a hint word (optional) — they must blend in.
4. Discuss the word without naming it.
5. **Vote out** who you think the imposter is.

Crewmates win by catching an imposter; the imposter wins by staying hidden.

## Features

- 14 bilingual categories in **German & English**, all **AI-generated**
  - Every category generates a fresh secret word + hint for every round via the
    OpenAI API
  - Each category keeps a fixed word list as an offline fallback
- 3–12 players, 1 or 2 imposters
- Optional discussion timer (off / 2 / 3 / 5 min)
- Optional hint word for imposters (on / off)
- Optional custom player names, kept (with the player count) when playing again
- Pass-the-device reveal flow with private cards, starting with a random player,
  then a randomly chosen player opens the discussion
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

## AI-generated categories (OpenAI)

Every category generates a new secret word + hint for every round using the
OpenAI API instead of a fixed word list. A category is AI-driven when it has an
AI prompt configured; if a category has no prompt, its built-in word list is
used directly.

1. Copy the template to a local config file (this file is git-ignored):
   ```bash
   cp assets/config.example.json assets/config.json
   ```
2. Open `assets/config.json` and set your API key:
   ```json
   { "openai_api_key": "sk-..." }
   ```

If no key is configured or the API is unreachable, the game automatically falls
back to the category's built-in word list, so it stays playable offline.

## Project structure

```
lib/
  data/       # built-in categories & terms (bilingual)
  l10n/       # .arb localization files (gen_l10n)
  models/     # domain models
  screens/    # UI screens
  services/   # GameEngine (pure game logic), OpenAI term generator, config
  theme/      # app theme
  widgets/    # shared widgets
  app.dart     # MaterialApp
  main.dart    # entry point
assets/
  config.example.json   # template for the OpenAI API key (git-ignored real file: config.json)
test/
  game_engine_test.dart
  setup_screen_layout_test.dart
  term_generator_test.dart
  widget_test.dart
```

## Roadmap

- Online multiplayer via a backend (Firebase / Supabase)
- Custom categories & word packs
- Per-player secret voting
- Score tracking across rounds

## License

MIT — see [LICENSE](LICENSE).
