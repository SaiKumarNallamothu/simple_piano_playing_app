import 'package:flutter_test/flutter_test.dart';
import 'package:simple_piano_playing_app/main.dart';

void main() {
  testWidgets('Piano App loads title smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SimplePianoApp());
    expect(find.text('Simple Piano'), findsOneWidget);
  });
}
