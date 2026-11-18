import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/note.dart';
import '../audio/piano_audio.dart';
import '../theme/piano_theme.dart';
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
  int? _selectedLockedOctave; // Null when unlocked (scrollable), 0-7 when locked to specific octave

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

  void _selectOctaveAndLock(int octave) {
    setState(() {
      if (_selectedLockedOctave == octave) {
        _selectedLockedOctave = null; // Toggle unlock when tapped again
      } else {
        _selectedLockedOctave = octave; // Lock to selected octave
      }
    });

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
      backgroundColor: PianoTheme.background,
      body: Stack(
        children: [
          // Ambient Glow Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: PianoTheme.backgroundGlow,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top App Bar / Controls Header with Frosted Glassmorphism
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: PianoTheme.surfaceDark.withAlpha(220),
                        border: Border(
                          bottom: BorderSide(
                            color: PianoTheme.goldAccent.withAlpha(50),
                            width: 1,
                          ),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x66000000),
                            blurRadius: 12,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              // Back button to return to studio home
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.only(right: 8),
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: PianoTheme.goldLight,
                                  size: 18,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),

                              // Crest & Title
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: PianoTheme.surfaceElevated,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: PianoTheme.goldAccent.withAlpha(120),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.piano_rounded,
                                  color: PianoTheme.goldAccent,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '88-Key Piano',
                                style: PianoTheme.titleSerif.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const Spacer(),

                              // Keyboard Mode Selector Tabs
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
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
                              Tooltip(
                                message: 'Toggle Note Labels',
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _showLabels = !_showLabels;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(PianoTheme.radiusSmall),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: _showLabels
                                          ? PianoTheme.goldAccent.withAlpha(35)
                                          : PianoTheme.surfaceElevated,
                                      borderRadius: BorderRadius.circular(PianoTheme.radiusSmall),
                                      border: Border.all(
                                        color: _showLabels
                                            ? PianoTheme.goldAccent.withAlpha(150)
                                            : Colors.white10,
                                      ),
                                    ),
                                    child: Icon(
                                      _showLabels ? Icons.subtitles_rounded : Icons.subtitles_off_rounded,
                                      color: _showLabels ? PianoTheme.goldAccent : Colors.white38,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Octave Navigator & Key Width Slider Bar (for Single Row Mode)
                          if (_currentMode == KeyboardMode.singleRow)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    _selectedLockedOctave != null ? Icons.lock_rounded : Icons.lock_open_rounded,
                                    size: 13,
                                    color: _selectedLockedOctave != null ? PianoTheme.goldLight : Colors.white38,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _selectedLockedOctave != null ? 'Octave Locked:' : 'Jump Octave:',
                                    style: PianoTheme.labelSans.copyWith(
                                      fontSize: 10.5,
                                      fontWeight: _selectedLockedOctave != null ? FontWeight.bold : FontWeight.w500,
                                      color: _selectedLockedOctave != null ? PianoTheme.goldLight : const Color(0xFF94A3B8),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          // Unlock All Button
                                          if (_selectedLockedOctave != null)
                                            Padding(
                                              padding: const EdgeInsets.only(right: 5.0),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _selectedLockedOctave = null;
                                                  });
                                                },
                                                borderRadius: BorderRadius.circular(4),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFF991B1B),
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(color: const Color(0xFFDC2626), width: 0.8),
                                                  ),
                                                  child: Text(
                                                    'Unlock Scroll',
                                                    style: PianoTheme.labelSans.copyWith(
                                                      fontSize: 9.5,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                          ...List.generate(8, (i) {
                                            final octave = i;
                                            final isLocked = _selectedLockedOctave == octave;
                                            return Padding(
                                              padding: const EdgeInsets.only(right: 4.0),
                                              child: InkWell(
                                                onTap: () => _selectOctaveAndLock(octave),
                                                borderRadius: BorderRadius.circular(4),
                                                child: AnimatedContainer(
                                                  duration: const Duration(milliseconds: 150),
                                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                                                  decoration: BoxDecoration(
                                                    color: isLocked
                                                        ? PianoTheme.goldAccent
                                                        : PianoTheme.surfaceElevated,
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(
                                                      color: isLocked
                                                          ? PianoTheme.goldLight
                                                          : PianoTheme.goldAccent.withAlpha(40),
                                                      width: 0.8,
                                                    ),
                                                    boxShadow: isLocked
                                                        ? [
                                                            BoxShadow(
                                                              color: PianoTheme.goldAccent.withAlpha(90),
                                                              blurRadius: 8,
                                                            )
                                                          ]
                                                        : null,
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      if (isLocked) ...[
                                                        const Icon(Icons.lock_rounded, size: 9, color: Color(0xFF090A0F)),
                                                        const SizedBox(width: 2),
                                                      ],
                                                      Text(
                                                        'Oct $octave',
                                                        style: PianoTheme.labelSans.copyWith(
                                                          fontSize: 9.5,
                                                          fontWeight: isLocked ? FontWeight.bold : FontWeight.w500,
                                                          color: isLocked ? const Color(0xFF090A0F) : const Color(0xFFCBD5E1),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),

                                  // Key Width Slider with gold accent
                                  const Icon(Icons.zoom_out, size: 13, color: Color(0xFF94A3B8)),
                                  SizedBox(
                                    width: 65,
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        activeTrackColor: PianoTheme.goldAccent,
                                        inactiveTrackColor: Colors.white12,
                                        thumbColor: PianoTheme.goldLight,
                                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                                        trackHeight: 2.0,
                                      ),
                                      child: Slider(
                                        value: _keyWidth,
                                        min: 40.0,
                                        max: 80.0,
                                        onChanged: (val) {
                                          setState(() {
                                            _keyWidth = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.zoom_in, size: 13, color: Color(0xFF94A3B8)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Main Piano Body Housing
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                    child: Container(
                      decoration: BoxDecoration(
                        color: PianoTheme.pianoBodyDark,
                        borderRadius: BorderRadius.circular(PianoTheme.radiusMedium),
                        border: Border.all(
                          color: const Color(0xFF282C38),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(220),
                            blurRadius: 18,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: PianoTheme.goldAccent.withAlpha(25),
                            blurRadius: 22,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(PianoTheme.radiusMedium - 1.5),
                        child: _isAudioReady
                            ? _buildActiveModeView()
                            : const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(PianoTheme.goldAccent),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
          isScrollable: _selectedLockedOctave == null,
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
            Container(
              height: 4,
              color: const Color(0xFF161820),
            ),
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
              decoration: const BoxDecoration(
                color: Color(0xFF141722),
                border: Border.symmetric(
                  horizontal: BorderSide(color: Color(0x22FFFFFF), width: 0.8),
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '▲ Player 2',
                    style: PianoTheme.labelSans.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: PianoTheme.goldLight,
                    ),
                  ),
                  Text(
                    'Player 1 ▼',
                    style: PianoTheme.labelSans.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF7DD3FC),
                    ),
                  ),
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
      padding: const EdgeInsets.only(right: 5.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _currentMode = mode;
          });
        },
        borderRadius: BorderRadius.circular(PianoTheme.radiusSmall),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? PianoTheme.goldAccent : PianoTheme.surfaceElevated,
            borderRadius: BorderRadius.circular(PianoTheme.radiusSmall),
            border: Border.all(
              color: isSelected ? PianoTheme.goldLight : Colors.white10,
              width: 0.8,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: PianoTheme.goldAccent.withAlpha(70),
                      blurRadius: 6,
                    )
                  ]
                : null,
          ),
          child: Text(
            title,
            style: PianoTheme.labelSans.copyWith(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF090A0F) : const Color(0xFFD2D6DF),
            ),
          ),
        ),
      ),
    );
  }
}
