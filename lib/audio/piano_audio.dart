import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import '../models/note.dart';

class PianoAudioService {
  static final PianoAudioService instance = PianoAudioService._internal();

  PianoAudioService._internal();

  final Map<String, AudioSource> _audioSources = {};
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await SoLoud.instance.init();
      final allNotes = NoteModel.getAll88Notes();

      for (final note in allNotes) {
        try {
          final source = await SoLoud.instance.loadAsset('assets/${note.soundAsset}');
          _audioSources[note.id] = source;
        } catch (e) {
          debugPrint('Error loading audio asset ${note.soundAsset}: $e');
        }
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('SoLoud initialization error: $e');
    }
  }

  void playNote(String noteId) {
    final source = _audioSources[noteId];
    if (source == null) return;

    try {
      SoLoud.instance.play(source);
    } catch (e) {
      debugPrint('Error playing note $noteId: $e');
    }
  }

  void stopNote(String noteId) {
    // SoLoud handles voice decay smoothly automatically
  }

  void dispose() {
    if (!_isInitialized) return;
    try {
      for (final source in _audioSources.values) {
        SoLoud.instance.disposeSource(source);
      }
      _audioSources.clear();
      SoLoud.instance.deinit();
    } catch (e) {
      debugPrint('Error disposing SoLoud: $e');
    }
    _isInitialized = false;
  }
}
