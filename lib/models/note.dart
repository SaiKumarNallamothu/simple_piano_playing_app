enum KeyType { white, black }

class NoteModel {
  final String id;
  final String name; // e.g. "C", "C#", "D"
  final int octave;
  final int midi; // 21 (A0) to 108 (C8)
  final KeyType type;
  final String soundAsset;

  const NoteModel({
    required this.id,
    required this.name,
    required this.octave,
    required this.midi,
    required this.type,
    required this.soundAsset,
  });

  String get fullLabel => '$name$octave';
  bool get isBlack => type == KeyType.black;
  bool get isWhite => type == KeyType.white;

  static const List<String> noteNames = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'
  ];

  static List<NoteModel> _all88Notes = [];

  static List<NoteModel> getAll88Notes() {
    if (_all88Notes.isNotEmpty) return _all88Notes;

    final List<NoteModel> notes = [];
    for (int midi = 21; midi <= 108; midi++) {
      final octave = (midi ~/ 12) - 1;
      final nameIdx = midi % 12;
      final name = noteNames[nameIdx];
      final isBlack = name.contains('#');
      final nameClean = name.toLowerCase().replaceAll('#', 's');
      final id = '$nameClean$octave';

      notes.add(
        NoteModel(
          id: id,
          name: name,
          octave: octave,
          midi: midi,
          type: isBlack ? KeyType.black : KeyType.white,
          soundAsset: 'sounds/$id.wav',
        ),
      );
    }
    _all88Notes = List.unmodifiable(notes);
    return _all88Notes;
  }

  static List<NoteModel> getWhiteNotesOnly() {
    return getAll88Notes().where((n) => n.isWhite).toList();
  }
}
