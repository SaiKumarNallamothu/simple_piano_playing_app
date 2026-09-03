import 'package:flutter/material.dart';
import '../models/note.dart';
import '../audio/piano_audio.dart';
import 'piano_key.dart';

class PianoKeyboardRow extends StatefulWidget {
  final List<NoteModel> notes;
  final double whiteKeyWidth;
  final bool showLabels;
  final ScrollController? scrollController;
  final bool isFlipped; // Support Dual Players 180° orientation

  const PianoKeyboardRow({
    super.key,
    required this.notes,
    this.whiteKeyWidth = 60.0,
    this.showLabels = true,
    this.scrollController,
    this.isFlipped = false,
  });

  @override
  State<PianoKeyboardRow> createState() => _PianoKeyboardRowState();
}

class _PianoKeyboardRowState extends State<PianoKeyboardRow> {
  late ScrollController _internalController;
  ScrollController get _activeController => widget.scrollController ?? _internalController;

  // Track pointer locations mapped to notes
  final Map<int, String> _pointerNoteMap = {};
  final Set<String> _activeNotes = {};

  late List<NoteModel> _whiteNotes;

  @override
  void initState() {
    super.initState();
    _internalController = ScrollController();
    _whiteNotes = widget.notes.where((n) => n.isWhite).toList();
  }

  @override
  void didUpdateWidget(PianoKeyboardRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notes != widget.notes) {
      _whiteNotes = widget.notes.where((n) => n.isWhite).toList();
    }
  }

  @override
  void dispose() {
    _internalController.dispose();
    super.dispose();
  }

  void _handlePointerEvent(PointerEvent event, double totalHeight) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPos = renderBox.globalToLocal(event.position);

    if (event is PointerUpEvent || event is PointerCancelEvent) {
      final prevNote = _pointerNoteMap.remove(event.pointer);
      if (prevNote != null) {
        PianoAudioService.instance.stopNote(prevNote);
        _updateActiveNotes();
      }
      return;
    }

    // Account for horizontal scroll offset
    final scrollOffset = _activeController.hasClients ? _activeController.offset : 0.0;
    final double absoluteX = localPos.dx + scrollOffset;

    final hitNoteId = _findHitNote(absoluteX, localPos.dy, totalHeight);

    if (hitNoteId != null) {
      final prevNote = _pointerNoteMap[event.pointer];
      if (prevNote != hitNoteId) {
        if (prevNote != null) {
          PianoAudioService.instance.stopNote(prevNote);
        }
        _pointerNoteMap[event.pointer] = hitNoteId;
        PianoAudioService.instance.playNote(hitNoteId);
        _updateActiveNotes();
      }
    } else {
      final prevNote = _pointerNoteMap.remove(event.pointer);
      if (prevNote != null) {
        PianoAudioService.instance.stopNote(prevNote);
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

  String? _findHitNote(double absoluteX, double localY, double totalHeight) {
    final double blackKeyWidth = widget.whiteKeyWidth * 0.64;
    final double blackKeyHeight = totalHeight * 0.58;

    // Check Black keys first (higher priority)
    if (localY <= blackKeyHeight) {
      for (int i = 0; i < _whiteNotes.length - 1; i++) {
        final currentWhite = _whiteNotes[i];
        final nextWhite = _whiteNotes[i + 1];

        final blackNote = _findBlackNoteBetween(currentWhite, nextWhite);
        if (blackNote != null) {
          final double blackCenterX = (i + 1) * widget.whiteKeyWidth;
          final double blackLeft = blackCenterX - (blackKeyWidth / 2);
          final double blackRight = blackCenterX + (blackKeyWidth / 2);

          if (absoluteX >= blackLeft && absoluteX <= blackRight) {
            return blackNote.id;
          }
        }
      }
    }

    // Check White keys
    final int whiteIndex = (absoluteX / widget.whiteKeyWidth).floor();
    if (whiteIndex >= 0 && whiteIndex < _whiteNotes.length) {
      return _whiteNotes[whiteIndex].id;
    }

    return null;
  }

  NoteModel? _findBlackNoteBetween(NoteModel w1, NoteModel w2) {
    for (final note in widget.notes) {
      if (note.isBlack) {
        if (note.midi == w1.midi + 1 && note.midi == w2.midi - 1) {
          return note;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final totalWidth = _whiteNotes.length * widget.whiteKeyWidth;

    Widget content = LayoutBuilder(
      builder: (context, constraints) {
        final double height = constraints.maxHeight;
        final double blackKeyWidth = widget.whiteKeyWidth * 0.64;
        final double blackKeyHeight = height * 0.58;

        return Listener(
          onPointerDown: (e) => _handlePointerEvent(e, height),
          onPointerMove: (e) => _handlePointerEvent(e, height),
          onPointerUp: (e) => _handlePointerEvent(e, height),
          onPointerCancel: (e) => _handlePointerEvent(e, height),
          child: SingleChildScrollView(
            controller: _activeController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              width: totalWidth,
              height: height,
              child: Stack(
                children: [
                  // Layer 1: White Keys
                  Row(
                    children: _whiteNotes.map((note) {
                      final isPressed = _activeNotes.contains(note.id);
                      return PianoKey(
                        note: note,
                        isPressed: isPressed,
                        showLabel: widget.showLabels,
                        width: widget.whiteKeyWidth,
                        height: height,
                      );
                    }).toList(),
                  ),

                  // Layer 2: Black Keys
                  ..._buildBlackKeyWidgets(widget.whiteKeyWidth, blackKeyWidth, blackKeyHeight),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (widget.isFlipped) {
      return Transform.rotate(
        angle: 3.14159, // 180 degrees flip for Dual Player 2
        child: content,
      );
    }

    return content;
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
