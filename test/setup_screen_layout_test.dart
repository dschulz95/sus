import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imposter_game/app.dart';

/// Loads the real Roboto font shipped with the Flutter SDK so text is laid
/// out with production metrics instead of the square test font.
Future<void> _loadRoboto() async {
  final fonts =
      '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts';
  final loader = FontLoader('Roboto');
  const files = ['Roboto-Regular.ttf', 'Roboto-Medium.ttf', 'Roboto-Bold.ttf'];
  for (final file in files) {
    loader.addFont(
      Future.value(
        ByteData.sublistView(File('$fonts/$file').readAsBytesSync()),
      ),
    );
  }
  await loader.load();
}

void main() {
  setUpAll(_loadRoboto);

  testWidgets('category tiles fit on a 390px wide phone', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ImposterApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Neues Spiel'));
    await tester.pumpAndSettle();

    expect(find.text('Essen & Trinken'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
