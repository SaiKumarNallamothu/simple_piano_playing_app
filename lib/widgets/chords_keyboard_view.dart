import 'package:flutter/material.dart';
import '../models/note.dart';
import '../audio/piano_audio.dart';

class ChordDefinition {
  final String name;
  final String rootNote; // e.g. "C", "D", "E"
  final String type; // "Maj", "Min", "7", "Maj7", "Dim"
  final List<String> noteIds;

  const ChordDefinition({
    required this.name,
    required this.rootNote,
    required this.type,
    required this.noteIds,
  });
}

class ChordsKeyboardView extends StatefulWidget {
  final bool showLabels;
  const ChordsKeyboardView({super.key, this.showLabels = true});

  @override
  State<ChordsKeyboardView> createState() => _ChordsKeyboardViewState();
}

class _ChordsKeyboardViewState extends State<ChordsKeyboardView> {
  final Set<String> _activeChordNames = {};

  final List<String> _roots = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
  final List<String> _types = ['Maj', 'Min', '7', 'Maj7'];

  List<ChordDefinition> _buildChords() {
    final List<ChordDefinition> chords = [];
    final allNotes = NoteModel.getAll88Notes();

    for (final root in _roots) {
      for (final type in _types) {
        // Find root note in Octave 4
        final rootNote = allNotes.firstWhere(
          (n) => n.name == root && n.octave == 4,
          orElse: () => allNotes[39],
        );

        final List<int> intervals = [];
        if (type == 'Maj') intervals.addAll([0, 4, 7]);
        if (type == 'Min') intervals.addAll([0, 3, 7]);
        if (type == '7') intervals.addAll([0, 4, 7, 10]);
        if (type == 'Maj7') intervals.addAll([0, 4, 7, 11]);

        final List<String> noteIds = [];
        for (final offset in intervals) {
          final targetMidi = rootNote.midi + offset;
          final match = allNotes.firstWhere(
            (n) => n.midi == targetMidi,
            orElse: () => rootNote,
          );
          noteIds.add(match.id);
        }

        chords.add(
          ChordDefinition(
            name: '$root $type',
            rootNote: root,
            type: type,
            noteIds: noteIds,
          ),
        );
      }
    }
    return chords;
  }

  void _triggerChord(ChordDefinition chord) {
    setState(() {
      _activeChordNames.add(chord.name);
    });

    for (final noteId in chord.noteIds) {
      PianoAudioService.instance.playNote(noteId);
    }
  }

  void _releaseChord(ChordDefinition chord) {
    setState(() {
      _activeChordNames.remove(chord.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chords = _buildChords();

    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: chords.length,
        itemBuilder: (context, index) {
          final chord = chords[index];
          final isPressed = _activeChordNames.contains(chord.name);

          return GestureDetector(
            onTapDown: (_) => _triggerChord(chord),
            onTapUp: (_) => _releaseChord(chord),
            onTapCancel: () => _releaseChord(chord),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 80),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isPressed
                      ? [const Color(0xFF6366F1), const Color(0xFF4F46E5)]
                      : [const Color(0xFF1E293B), const Color(0xFF0F172A)],
                ),
                border: Border.all(
                  color: isPressed ? const Color(0xFF818CF8) : Colors.white10,
                  width: isPressed ? 2 : 1,
                ),
                boxShadow: isPressed
                    ? [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withAlpha((0.6 * 255).round()),
                          blurRadius: 12,
                          spreadRadius: 2,
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.3 * 255).round()),
                          blurRadius: 4,
                          offset: const Offset(0, 3),
                        )
                      ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      chord.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isPressed ? Colors.white : const Color(0xFFE2E8F0),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      chord.noteIds.map((id) => id.toUpperCase()).join(' '),
                      style: TextStyle(
                        fontSize: 10,
                        color: isPressed ? Colors.white70 : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
