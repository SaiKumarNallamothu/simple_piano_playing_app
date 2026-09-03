import 'package:flutter/material.dart';
import '../models/note.dart';
import '../audio/piano_audio.dart';
import '../widgets/piano_keyboard_row.dart';
import '../widgets/chords_keyboard_view.dart';

enum KeyboardMode { singleRow, doubleRow, dualPlayers, chords }

class PianoScreen extends StatefulWidget {
  const PianoScreen({super.key});

  @override
  State<PianoScreen> createState() => _PianoScreenState();
}

class _PianoScreenState extends State<PianoScreen> {
  KeyboardMode _currentMode = KeyboardMode.singleRow;
  bool _showLabels = true;
  bool _isAudioReady = false;
  double _keyWidth = 55.0; // Adjustable key size

  late List<NoteModel> _all88Notes;
  late ScrollController _singleRowScrollController;
  late ScrollController _doubleRowTopScrollController;
  late ScrollController _doubleRowBottomScrollController;

  @override
  void initState() {
    super.initState();
    _all88Notes = NoteModel.getAll88Notes();
    _singleRowScrollController = ScrollController(initialScrollOffset: 1200); // Start near Middle C (C4)
    _doubleRowTopScrollController = ScrollController(initialScrollOffset: 1500);
    _doubleRowBottomScrollController = ScrollController(initialScrollOffset: 600);
    _initAudio();
  }

  Future<void> _initAudio() async {
    await PianoAudioService.instance.init();
    if (mounted) {
      setState(() {
        _isAudioReady = true;
      });
    }
  }

  @override
  void dispose() {
    _singleRowScrollController.dispose();
    _doubleRowTopScrollController.dispose();
    _doubleRowBottomScrollController.dispose();
    super.dispose();
  }

  void _jumpToOctave(int octave) {
    // Find first white key in target octave
    final whiteNotes = NoteModel.getWhiteNotesOnly();
    final index = whiteNotes.indexWhere((n) => n.octave == octave);
    if (index != -1 && _singleRowScrollController.hasClients) {
      final targetOffset = index * _keyWidth;
      _singleRowScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar / Controls Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: const BoxDecoration(
                color: Color(0xFF161A29),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.music_note_rounded,
                        color: Color(0xFF818CF8),
                        size: 22,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '88-Key Piano',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),

                      // Keyboard Mode Selector Tabs
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildModeTab('Single', KeyboardMode.singleRow),
                            _buildModeTab('Double', KeyboardMode.doubleRow),
                            _buildModeTab('Dual Player', KeyboardMode.dualPlayers),
                            _buildModeTab('Chords', KeyboardMode.chords),
                          ],
                        ),
                      ),

                      const SizedBox(width: 6),

                      // Toggle Labels Button
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(6),
                        icon: Icon(
                          _showLabels ? Icons.subtitles_rounded : Icons.subtitles_off_rounded,
                          color: _showLabels ? const Color(0xFF818CF8) : Colors.white38,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _showLabels = !_showLabels;
                          });
                        },
                      ),
                    ],
                  ),

                  // Octave Navigator & Key Width Slider Bar (for Single Row Mode)
                  if (_currentMode == KeyboardMode.singleRow)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Row(
                        children: [
                          const Text(
                            'Jump Octave:',
                            style: TextStyle(fontSize: 11, color: Colors.white54),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(8, (i) {
                                  final octave = i;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: InkWell(
                                      onTap: () => _jumpToOctave(octave),
                                      borderRadius: BorderRadius.circular(4),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF23293E),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'Oct $octave',
                                          style: const TextStyle(fontSize: 10, color: Colors.white70),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Key Width Slider
                          const Icon(Icons.zoom_out, size: 14, color: Colors.white54),
                          SizedBox(
                            width: 80,
                            child: Slider(
                              value: _keyWidth,
                              min: 40.0,
                              max: 80.0,
                              activeColor: const Color(0xFF818CF8),
                              onChanged: (val) {
                                setState(() {
                                  _keyWidth = val;
                                });
                              },
                            ),
                          ),
                          const Icon(Icons.zoom_in, size: 14, color: Colors.white54),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Main View Surface
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _isAudioReady
                      ? _buildActiveModeView()
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF818CF8),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveModeView() {
    switch (_currentMode) {
      case KeyboardMode.singleRow:
        return PianoKeyboardRow(
          notes: _all88Notes,
          whiteKeyWidth: _keyWidth,
          showLabels: _showLabels,
          scrollController: _singleRowScrollController,
        );

      case KeyboardMode.doubleRow:
        return Column(
          children: [
            // Top Row
            Expanded(
              child: PianoKeyboardRow(
                notes: _all88Notes,
                whiteKeyWidth: _keyWidth,
                showLabels: _showLabels,
                scrollController: _doubleRowTopScrollController,
              ),
            ),
            const Divider(height: 4, thickness: 4, color: Color(0xFF0F111A)),
            // Bottom Row
            Expanded(
              child: PianoKeyboardRow(
                notes: _all88Notes,
                whiteKeyWidth: _keyWidth,
                showLabels: _showLabels,
                scrollController: _doubleRowBottomScrollController,
              ),
            ),
          ],
        );

      case KeyboardMode.dualPlayers:
        return Column(
          children: [
            // Player 2 (Top - Flipped 180°)
            Expanded(
              child: PianoKeyboardRow(
                notes: _all88Notes,
                whiteKeyWidth: _keyWidth,
                showLabels: _showLabels,
                isFlipped: true,
              ),
            ),
            Container(
              height: 24,
              color: const Color(0xFF1E293B),
              alignment: Alignment.center,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('▲ Player 2', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF818CF8))),
                  Text('Player 1 ▼', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))),
                ],
              ),
            ),
            // Player 1 (Bottom - Normal)
            Expanded(
              child: PianoKeyboardRow(
                notes: _all88Notes,
                whiteKeyWidth: _keyWidth,
                showLabels: _showLabels,
                isFlipped: false,
              ),
            ),
          ],
        );

      case KeyboardMode.chords:
        return ChordsKeyboardView(showLabels: _showLabels);
    }
  }

  Widget _buildModeTab(String title, KeyboardMode mode) {
    final isSelected = _currentMode == mode;
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _currentMode = mode;
          });
        },
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF23293E),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
