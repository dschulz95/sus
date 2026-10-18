import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imposter_game/data/categories.dart';
import 'package:imposter_game/l10n/app_localizations.dart';
import 'package:imposter_game/models/game_settings.dart';
import 'package:imposter_game/screens/result_screen.dart';
import 'package:imposter_game/services/game_engine.dart';

void main() {
  testWidgets('play again keeps player names and count', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

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
        locale: const Locale('en'),
        home: ResultScreen(round: round, votedOutNumber: 1),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Play again'));
    await tester.tap(find.text('Play again'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.widgetWithText(TextField, 'Dan'),
      200,
      scrollable: find.byType(Scrollable).first,
    );

    final fields = tester
        .widgetList<TextField>(find.byType(TextField))
        .map((field) => field.controller!.text)
        .toList();
    expect(fields, ['Anna', 'Ben', 'Cara', 'Dan']);
  });
}
