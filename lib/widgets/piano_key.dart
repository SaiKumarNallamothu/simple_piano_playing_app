import 'package:flutter/material.dart';
import '../models/note.dart';
import '../theme/piano_theme.dart';

class PianoKey extends StatelessWidget {
  final NoteModel note;
  final bool isPressed;
  final bool showLabel;
  final double width;
  final double height;

  const PianoKey({
    super.key,
    required this.note,
    required this.isPressed,
    required this.showLabel,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return note.isWhite ? _buildWhiteKey() : _buildBlackKey();
  }

  Widget _buildWhiteKey() {
    return AnimatedScale(
      scale: isPressed ? 0.985 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(PianoTheme.radiusKeyBottom),
            bottomRight: Radius.circular(PianoTheme.radiusKeyBottom),
          ),
          border: Border.all(
            color: isPressed ? PianoTheme.goldAccent.withAlpha(180) : const Color(0x33000000),
            width: isPressed ? 1.0 : 0.6,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isPressed
                ? [
                    PianoTheme.ivoryPressedTop,
                    PianoTheme.ivoryPressedBottom,
                    const Color(0xFFC7BD9F),
                  ]
                : [
                    PianoTheme.ivoryTop,
                    PianoTheme.ivoryMid,
                    PianoTheme.ivoryBottom,
                  ],
            stops: const [0.0, 0.7, 1.0],
          ),
          boxShadow: isPressed
              ? [
                  BoxShadow(
                    color: PianoTheme.goldAccent.withAlpha(90),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Colors.black.withAlpha(60),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(50),
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                  BoxShadow(
                    color: const Color(0xFFD6CEBD).withAlpha(120),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Realistic top edge lip / acoustic felt accent
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: isPressed
                      ? PianoTheme.goldAccent.withAlpha(200)
                      : PianoTheme.pianoFeltRed.withAlpha(180),
                ),
              ),
            ),

            // Note label text
            if (showLabel)
              Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      note.name,
                      style: PianoTheme.keyNoteLabel.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isPressed ? const Color(0xFF2C2416) : const Color(0xFF4A4E58),
                      ),
                    ),
                    Text(
                      '${note.octave}',
                      style: PianoTheme.labelSans.copyWith(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: isPressed ? const Color(0xFF5A4D32) : const Color(0xFF8B92A2),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlackKey() {
    return AnimatedScale(
      scale: isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
          border: Border.all(
            color: isPressed ? PianoTheme.goldAccent.withAlpha(180) : const Color(0xFF2E323D),
            width: isPressed ? 1.0 : 0.6,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isPressed
                ? [
                    PianoTheme.ebonyPressed,
                    const Color(0xFF1F2128),
                    const Color(0xFF15161C),
                  ]
                : [
                    PianoTheme.ebonyHighlight,
                    PianoTheme.ebonyTop,
                    PianoTheme.ebonyMid,
                    PianoTheme.ebonyBottom,
                  ],
            stops: isPressed ? const [0.0, 0.5, 1.0] : const [0.0, 0.15, 0.7, 1.0],
          ),
          boxShadow: isPressed
              ? [
                  BoxShadow(
                    color: PianoTheme.goldAccent.withAlpha(100),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Colors.black.withAlpha(120),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(180),
                    blurRadius: 7,
                    spreadRadius: 1,
                    offset: const Offset(0, 5),
                  ),
                  BoxShadow(
                    color: const Color(0x33000000),
                    blurRadius: 1,
                    offset: const Offset(1, 0),
                  ),
                ],
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Beveled gloss highlight on top edge
            Positioned(
              top: 0,
              left: 2,
              right: 2,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: isPressed ? PianoTheme.goldLight : Colors.white24,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(1)),
                ),
              ),
            ),
            if (showLabel)
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  note.name,
                  style: PianoTheme.keyNoteLabel.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isPressed ? PianoTheme.goldLight : const Color(0xFFD2D6DF),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
