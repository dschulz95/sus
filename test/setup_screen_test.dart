import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imposter_game/l10n/app_localizations.dart';
import 'package:imposter_game/screens/setup_screen.dart';
import 'package:imposter_game/theme/app_theme.dart';

void main() {
  testWidgets('tapping anywhere on a category tile selects it',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.dark,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SetupScreen(),
    ));
    await tester.pumpAndSettle();

    final travelCard =
        find.ancestor(of: find.text('Travel'), matching: find.byType(Card));
    await tester.ensureVisible(travelCard);
    await tester.pumpAndSettle();
    expect(tester.widget<Card>(travelCard).color, AppTheme.card);

    // Tile content stays centred on the card.
    final rect = tester.getRect(travelCard);
    expect(tester.getCenter(find.text('Travel')).dx, closeTo(rect.center.dx, 1));

    // Tap near the bottom-right of the tile, outside the emoji and label.
    await tester.tapAt(rect.bottomRight - const Offset(12, 12));
    await tester.pump();

    expect(tester.widget<Card>(travelCard).color, AppTheme.cardSelected);
  });
}
