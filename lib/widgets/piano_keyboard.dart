import 'package:flutter/material.dart';
import '../models/note.dart';
import 'piano_keyboard_row.dart';

class PianoKeyboard extends StatelessWidget {
  final int octavesCount;
  final int startOctave;
  final bool showLabels;

  const PianoKeyboard({
    super.key,
    this.octavesCount = 1,
    this.startOctave = 4,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final allNotes = NoteModel.getAll88Notes();
    final startMidi = (startOctave + 1) * 12; // C_startOctave
    final endMidi = startMidi + (octavesCount * 12);

    final notes = allNotes.where((n) => n.midi >= startMidi && n.midi <= endMidi).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final whiteCount = notes.where((n) => n.isWhite).length;
        final whiteWidth = constraints.maxWidth / whiteCount;

        return PianoKeyboardRow(
          notes: notes,
          whiteKeyWidth: whiteWidth,
          showLabels: showLabels,
        );
      },
    );
  }
}
