import 'package:flutter/material.dart';
import '../models/note.dart';
import '../audio/piano_audio.dart';
import 'piano_key.dart';

class PianoKeyboard extends StatefulWidget {
  final int octavesCount; // 1 or 2 octaves
  final int startOctave; // 3 or 4
  final bool showLabels;

  const PianoKeyboard({
    super.key,
    this.octavesCount = 1,
    this.startOctave = 4,
    this.showLabels = true,
  });

  @override
  State<PianoKeyboard> createState() => _PianoKeyboardState();
}

class _PianoKeyboardState extends State<PianoKeyboard> {
  // Track active pointer IDs to note IDs mapping for multi-touch & slide
  final Map<int, String> _pointerNoteMap = {};
  final Set<String> _activeNotes = {};

  late List<NoteModel> _notes;
  late List<NoteModel> _whiteNotes;

  @override
  void initState() {
    super.initState();
    _buildNotesList();
  }

  @override
  void didUpdateWidget(PianoKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.octavesCount != widget.octavesCount ||
        oldWidget.startOctave != widget.startOctave) {
      _buildNotesList();
    }
  }

  void _buildNotesList() {
    _notes = [];
    for (int i = 0; i < widget.octavesCount; i++) {
      _notes.addAll(NoteModel.getOctave(widget.startOctave + i));
    }
    // Add finishing C note of higher octave
    final lastOctave = widget.startOctave + widget.octavesCount;
    _notes.add(
      NoteModel(
        id: 'c$lastOctave',
        name: 'C',
        octave: lastOctave,
        type: KeyType.white,
        soundAsset: 'sounds/c$lastOctave.wav',
      ),
    );

    _whiteNotes = _notes.where((n) => n.isWhite).toList();
  }

  void _handlePointerEvent(PointerEvent event, Size boardSize) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPosition = renderBox.globalToLocal(event.position);

    if (event is PointerUpEvent || event is PointerCancelEvent) {
      final prevNote = _pointerNoteMap.remove(event.pointer);
      if (prevNote != null) {
        _updateActiveNotes();
      }
      return;
    }

    // Determine hit note at localPosition
    final hitNoteId = _findHitNote(localPosition, boardSize);

    if (hitNoteId != null) {
      final prevNote = _pointerNoteMap[event.pointer];
      if (prevNote != hitNoteId) {
        _pointerNoteMap[event.pointer] = hitNoteId;
        PianoAudioService.instance.playNote(hitNoteId);
        _updateActiveNotes();
      }
    } else {
      final prevNote = _pointerNoteMap.remove(event.pointer);
      if (prevNote != null) {
        _updateActiveNotes();
      }
    }
  }

  void _updateActiveNotes() {
    setState(() {
      _activeNotes.clear();
      _activeNotes.addAll(_pointerNoteMap.values);
    });
  }

  String? _findHitNote(Offset pos, Size boardSize) {
    if (pos.dx < 0 || pos.dx > boardSize.width || pos.dy < 0 || pos.dy > boardSize.height) {
      return null;
    }

    final double whiteKeyWidth = boardSize.width / _whiteNotes.length;
    final double blackKeyWidth = whiteKeyWidth * 0.62;
    final double blackKeyHeight = boardSize.height * 0.60;

    // First check if pointer hit any black key (since black keys lie on top)
    if (pos.dy <= blackKeyHeight) {
      for (int i = 0; i < _whiteNotes.length - 1; i++) {
        final currentWhite = _whiteNotes[i];
        final nextWhite = _whiteNotes[i + 1];

        // Check if there is a black key between currentWhite and nextWhite
        final blackNote = _findBlackNoteBetween(currentWhite, nextWhite);
        if (blackNote != null) {
          final double blackCenterX = (i + 1) * whiteKeyWidth;
          final double blackLeft = blackCenterX - (blackKeyWidth / 2);
          final double blackRight = blackCenterX + (blackKeyWidth / 2);

          if (pos.dx >= blackLeft && pos.dx <= blackRight) {
            return blackNote.id;
          }
        }
      }
    }

    // Otherwise check white keys
    final int whiteIndex = (pos.dx / whiteKeyWidth).floor();
    if (whiteIndex >= 0 && whiteIndex < _whiteNotes.length) {
      return _whiteNotes[whiteIndex].id;
    }

    return null;
  }

  NoteModel? _findBlackNoteBetween(NoteModel w1, NoteModel w2) {
    for (final note in _notes) {
      if (note.isBlack) {
        if (note.octave == w1.octave) {
          if (w1.name == 'C' && note.name == 'C#') return note;
          if (w1.name == 'D' && note.name == 'D#') return note;
          if (w1.name == 'F' && note.name == 'F#') return note;
          if (w1.name == 'G' && note.name == 'G#') return note;
          if (w1.name == 'A' && note.name == 'A#') return note;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size boardSize = Size(constraints.maxWidth, constraints.maxHeight);
        final double whiteKeyWidth = boardSize.width / _whiteNotes.length;
        final double blackKeyWidth = whiteKeyWidth * 0.62;
        final double blackKeyHeight = boardSize.height * 0.60;

        return Listener(
          onPointerDown: (e) => _handlePointerEvent(e, boardSize),
          onPointerMove: (e) => _handlePointerEvent(e, boardSize),
          onPointerUp: (e) => _handlePointerEvent(e, boardSize),
          onPointerCancel: (e) => _handlePointerEvent(e, boardSize),
          child: Container(
            width: boardSize.width,
            height: boardSize.height,
            color: const Color(0xFF0F172A),
            child: Stack(
              children: [
                // Layer 1: White Keys Row
                Row(
                  children: _whiteNotes.map((note) {
                    final isPressed = _activeNotes.contains(note.id);
                    return PianoKey(
                      note: note,
                      isPressed: isPressed,
                      showLabel: widget.showLabels,
                      width: whiteKeyWidth,
                      height: boardSize.height,
                    );
                  }).toList(),
                ),

                // Layer 2: Positioned Black Keys
                ..._buildBlackKeyWidgets(whiteKeyWidth, blackKeyWidth, blackKeyHeight),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildBlackKeyWidgets(
    double whiteKeyWidth,
    double blackKeyWidth,
    double blackKeyHeight,
  ) {
    final List<Widget> blackWidgets = [];

    for (int i = 0; i < _whiteNotes.length - 1; i++) {
      final currentWhite = _whiteNotes[i];
      final nextWhite = _whiteNotes[i + 1];
      final blackNote = _findBlackNoteBetween(currentWhite, nextWhite);

      if (blackNote != null) {
        final double leftOffset = (i + 1) * whiteKeyWidth - (blackKeyWidth / 2);
        final isPressed = _activeNotes.contains(blackNote.id);

        blackWidgets.add(
          Positioned(
            left: leftOffset,
            top: 0,
            child: IgnorePointer(
              child: PianoKey(
                note: blackNote,
                isPressed: isPressed,
                showLabel: widget.showLabels,
                width: blackKeyWidth,
                height: blackKeyHeight,
              ),
            ),
          ),
        );
      }
    }

    return blackWidgets;
  }
}
