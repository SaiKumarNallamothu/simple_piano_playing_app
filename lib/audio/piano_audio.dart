import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../models/note.dart';

class PianoAudioService {
  static final PianoAudioService instance = PianoAudioService._internal();

  PianoAudioService._internal();

  // Pool of AudioPlayers for polyphonic zero-latency playback
  final Map<String, List<AudioPlayer>> _playersPool = {};
  final Map<String, int> _poolIndex = {};

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    final notes = [
      ...NoteModel.getOctave(3),
      ...NoteModel.getOctave(4),
      const NoteModel(id: 'c5', name: 'C', octave: 5, type: KeyType.white, soundAsset: 'sounds/c5.wav'),
    ];

    for (final note in notes) {
      _playersPool[note.id] = [];
      _poolIndex[note.id] = 0;

      // Allocate 3 players per note to support rapid re-triggering & polyphony
      for (int i = 0; i < 3; i++) {
        final player = AudioPlayer();
        try {
          await player.setSource(AssetSource(note.soundAsset));
          await player.setVolume(1.0);
        } catch (e) {
          debugPrint('Error pre-loading asset ${note.soundAsset}: $e');
        }
        _playersPool[note.id]!.add(player);
      }
    }

    _isInitialized = true;
  }

  void playNote(String noteId) {
    final pool = _playersPool[noteId];
    if (pool == null || pool.isEmpty) return;

    final index = _poolIndex[noteId]! % pool.length;
    _poolIndex[noteId] = index + 1;

    final player = pool[index];
    
    // Play with source seeking for rapid low-latency response
    player.seek(Duration.zero).then((_) {
      player.resume();
    }).catchError((_) {
      player.play(AssetSource('sounds/$noteId.wav'));
    });
  }

  void dispose() {
    for (final pool in _playersPool.values) {
      for (final player in pool) {
        player.dispose();
      }
    }
    _playersPool.clear();
    _poolIndex.clear();
    _isInitialized = false;
  }
}
