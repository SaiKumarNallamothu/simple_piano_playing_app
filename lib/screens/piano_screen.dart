import 'package:flutter/material.dart';
import '../widgets/piano_keyboard.dart';
import '../audio/piano_audio.dart';

class PianoScreen extends StatefulWidget {
  const PianoScreen({super.key});

  @override
  State<PianoScreen> createState() => _PianoScreenState();
}

class _PianoScreenState extends State<PianoScreen> {
  int _octavesCount = 1; // 1 or 2 octaves
  int _startOctave = 4; // 3 or 4
  bool _showLabels = true;
  bool _isAudioReady = false;

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F111A), // Deep dark studio background
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar / Controls Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              child: Row(
                children: [
                  // App Title & Icon
                  const Icon(
                    Icons.music_note_rounded,
                    color: Color(0xFF818CF8),
                    size: 22,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Simple Piano',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),

                  // Action controls packed nicely
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Octave Count Switcher
                        _buildHeaderButton(
                          label: _octavesCount == 1 ? '1 Octave' : '2 Octaves',
                          icon: Icons.splitscreen_rounded,
                          onPressed: () {
                            setState(() {
                              _octavesCount = _octavesCount == 1 ? 2 : 1;
                            });
                          },
                        ),
                        const SizedBox(width: 6),

                        // Octave Range Selector
                        if (_octavesCount == 1) ...[
                          _buildHeaderButton(
                            label: 'Oct C$_startOctave',
                            icon: Icons.tune_rounded,
                            onPressed: () {
                              setState(() {
                                _startOctave = _startOctave == 4 ? 3 : 4;
                              });
                            },
                          ),
                          const SizedBox(width: 6),
                        ],

                        // Toggle Labels
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                          icon: Icon(
                            _showLabels ? Icons.subtitles_rounded : Icons.subtitles_off_rounded,
                            color: _showLabels ? const Color(0xFF818CF8) : Colors.white38,
                            size: 20,
                          ),
                          tooltip: 'Toggle Key Labels',
                          onPressed: () {
                            setState(() {
                              _showLabels = !_showLabels;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Visual Piano Surface
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _isAudioReady
                      ? PianoKeyboard(
                          octavesCount: _octavesCount,
                          startOctave: _octavesCount == 2 ? 3 : _startOctave,
                          showLabels: _showLabels,
                        )
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

  Widget _buildHeaderButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF23293E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 14, color: const Color(0xFFA5B4FC)),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
