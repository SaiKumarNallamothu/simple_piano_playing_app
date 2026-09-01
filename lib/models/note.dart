enum KeyType { white, black }

class NoteModel {
  final String id;
  final String name; // e.g. "C", "C#", "D"
  final int octave;
  final KeyType type;
  final String soundAsset;

  const NoteModel({
    required this.id,
    required this.name,
    required this.octave,
    required this.type,
    required this.soundAsset,
  });

  String get fullLabel => '$name$octave';

  bool get isBlack => type == KeyType.black;
  bool get isWhite => type == KeyType.white;

  static List<NoteModel> getOctave(int octave) {
    return [
      NoteModel(id: 'c$octave', name: 'C', octave: octave, type: KeyType.white, soundAsset: 'sounds/c$octave.wav'),
      NoteModel(id: 'cs$octave', name: 'C#', octave: octave, type: KeyType.black, soundAsset: 'sounds/cs$octave.wav'),
      NoteModel(id: 'd$octave', name: 'D', octave: octave, type: KeyType.white, soundAsset: 'sounds/d$octave.wav'),
      NoteModel(id: 'ds$octave', name: 'D#', octave: octave, type: KeyType.black, soundAsset: 'sounds/ds$octave.wav'),
      NoteModel(id: 'e$octave', name: 'E', octave: octave, type: KeyType.white, soundAsset: 'sounds/e$octave.wav'),
      NoteModel(id: 'f$octave', name: 'F', octave: octave, type: KeyType.white, soundAsset: 'sounds/f$octave.wav'),
      NoteModel(id: 'fs$octave', name: 'F#', octave: octave, type: KeyType.black, soundAsset: 'sounds/fs$octave.wav'),
      NoteModel(id: 'g$octave', name: 'G', octave: octave, type: KeyType.white, soundAsset: 'sounds/g$octave.wav'),
      NoteModel(id: 'gs$octave', name: 'G#', octave: octave, type: KeyType.black, soundAsset: 'sounds/gs$octave.wav'),
      NoteModel(id: 'a$octave', name: 'A', octave: octave, type: KeyType.white, soundAsset: 'sounds/a$octave.wav'),
      NoteModel(id: 'as$octave', name: 'A#', octave: octave, type: KeyType.black, soundAsset: 'sounds/as$octave.wav'),
      NoteModel(id: 'b$octave', name: 'B', octave: octave, type: KeyType.white, soundAsset: 'sounds/b$octave.wav'),
    ];
  }
}
