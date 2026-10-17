import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:imposter_game/data/categories.dart';
import 'package:imposter_game/models/game_settings.dart';
import 'package:imposter_game/services/game_engine.dart';

void main() {
  GameSettings settings({int playerCount = 6, int imposters = 1}) =>
      GameSettings(
        category: kCategories.first,
        playerCount: playerCount,
        imposterCount: imposters,
      );

  group('GameEngine.createRound', () {
    test('picks a term from the chosen category', () {
      final engine = GameEngine(Random(1));
      final round = engine.createRound(settings());
      expect(kCategories.first.terms, contains(round.term));
    });

    test('creates the requested number of players', () {
      final engine = GameEngine(Random(2));
      final round = engine.createRound(settings(playerCount: 8));
      expect(round.players.length, 8);
    });

    test('assigns the requested number of imposters', () {
      final engine = GameEngine(Random(3));
      final round = engine.createRound(settings(playerCount: 8, imposters: 2));
      expect(round.imposters.length, 2);
    });

    test('assigns unique player numbers', () {
      final engine = GameEngine(Random(4));
      final round = engine.createRound(settings(playerCount: 10));
      final numbers = round.players.map((p) => p.number).toSet();
      expect(numbers.length, 10);
    });
  });

  group('determineOutcome', () {
    test('crew wins when an imposter is voted out', () {
      final engine = GameEngine(Random(5));
      final round = engine.createRound(settings());
      final imposter = round.imposters.first;
      expect(determineOutcome(round, imposter.number), GameOutcome.crewWins);
    });

    test('imposters win when a crewmate is voted out', () {
      final engine = GameEngine(Random(6));
      final round = engine.createRound(settings());
      final crewmate = round.crewmates.first;
      expect(determineOutcome(round, crewmate.number), GameOutcome.impostersWin);
    });

    test('noVote when nobody is voted out', () {
      final engine = GameEngine(Random(7));
      final round = engine.createRound(settings());
      expect(determineOutcome(round, null), GameOutcome.noVote);
    });
  });

  group('category data', () {
    test('every term has a non-empty hint that differs from the word', () {
      for (final category in kCategories) {
        expect(category.terms, isNotEmpty);
        for (final term in category.terms) {
          expect(term.hintDe.trim(), isNotEmpty);
          expect(term.hintEn.trim(), isNotEmpty);
          expect(term.hintDe, isNot(term.de));
          expect(term.hintEn, isNot(term.en));
        }
      }
    });

    test('terms within a category are unique', () {
      for (final category in kCategories) {
        final deWords = category.terms.map((t) => t.de).toSet();
        final enWords = category.terms.map((t) => t.en).toSet();
        expect(deWords.length, category.terms.length);
        expect(enWords.length, category.terms.length);
      }
    });
  });
}
