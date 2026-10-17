import 'package:flutter_test/flutter_test.dart';
import 'package:imposter_game/app.dart';

void main() {
  testWidgets('renders the home screen', (tester) async {
    await tester.pumpWidget(const ImposterApp());
    await tester.pumpAndSettle();

    expect(find.text('Imposter'), findsWidgets);
    expect(find.text('Neues Spiel'), findsOneWidget);
  });
}
