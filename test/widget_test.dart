import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_piano_playing_app/main.dart';
import 'package:simple_piano_playing_app/models/note.dart';
import 'package:simple_piano_playing_app/screens/piano_screen.dart';
import 'package:simple_piano_playing_app/widgets/piano_keyboard_row.dart';
import 'package:simple_piano_playing_app/widgets/chords_keyboard_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Piano App Unit & Widget Tests', () {
    test('88 Piano Notes model verification', () {
      final notes = NoteModel.getAll88Notes();
      expect(notes.length, equals(88));
      expect(notes.first.id, equals('a0'));
      expect(notes.first.midi, equals(21));
      expect(notes.last.id, equals('c8'));
      expect(notes.last.midi, equals(108));

      final whiteNotes = NoteModel.getWhiteNotesOnly();
      expect(whiteNotes.length, equals(52));
    });

    testWidgets('App loads splash, home screen buttons & opens instructions', (WidgetTester tester) async {
      await tester.pumpWidget(const SimplePianoApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify Home Screen buttons
      expect(find.text('Simple Piano Studio'), findsOneWidget);
      expect(find.text('Compose / Play'), findsOneWidget);
      expect(find.text('How to Use'), findsOneWidget);

      // Tap How to Use button and verify modal
      await tester.tap(find.text('How to Use'));
      await tester.pumpAndSettle();
      expect(find.text('How to Use Keyboard'), findsOneWidget);
      expect(find.text('Full 88-Key Piano'), findsOneWidget);
      expect(find.text('4 Playing Modes'), findsOneWidget);

      // Dismiss dialog
      await tester.tap(find.text('Got It!'));
      await tester.pumpAndSettle();
      expect(find.text('How to Use Keyboard'), findsNothing);

      // Tap Compose / Play and enter Piano Screen
      await tester.tap(find.text('Compose / Play'));
      await tester.pumpAndSettle();
      expect(find.text('88-Key Piano'), findsOneWidget);
    });

    testWidgets('Switching modes updates UI', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PianoScreen()));
      await tester.pumpAndSettle();

      // Switch to Double Row Mode
      await tester.tap(find.text('Double'));
      await tester.pump();
      expect(find.byType(PianoKeyboardRow), findsNWidgets(2));

      // Switch to Dual Player Mode
      await tester.tap(find.text('Dual Player'));
      await tester.pump();
      expect(find.text('▲ Player 2'), findsOneWidget);
      expect(find.text('Player 1 ▼'), findsOneWidget);

      // Switch to Chords Mode
      await tester.tap(find.text('Chords'));
      await tester.pump();
      expect(find.byType(ChordsKeyboardView), findsOneWidget);
      expect(find.text('C Maj'), findsOneWidget);
    });

    testWidgets('Toggling show/hide labels works', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PianoScreen()));
      await tester.pumpAndSettle();

      final labelButton = find.byIcon(Icons.subtitles_rounded);
      expect(labelButton, findsOneWidget);

      await tester.tap(labelButton);
      await tester.pump();

      expect(find.byIcon(Icons.subtitles_off_rounded), findsOneWidget);
    });
  });
}
