import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imposter_game/data/categories.dart';
import 'package:imposter_game/l10n/app_localizations.dart';
import 'package:imposter_game/models/game_settings.dart';
import 'package:imposter_game/screens/discussion_screen.dart';
import 'package:imposter_game/services/game_engine.dart';

void main() {
  testWidgets('discussion screen announces the starting player', (tester) async {
    final round = GameEngine(Random(1)).createRound(
      GameSettings(
        category: kCategories.first,
        playerCount: 4,
        imposterCount: 1,
        discussionDuration: Duration.zero,
        playerNames: const ['Anna', 'Ben', 'Cara', 'Dan'],
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('de'),
        home: DiscussionScreen(round: round),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Wer fängt an?'), findsOneWidget);
    expect(find.text(round.startingPlayer.name), findsOneWidget);
  });
}
