import 'package:flutter/material.dart';
import '../models/note.dart';

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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 60),
      curve: Curves.easeOutCubic,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isPressed
              ? [
                  const Color(0xFFE2E8F0),
                  const Color(0xFF6366F1), // Neon highlight when pressed
                ]
              : [
                  Colors.white,
                  const Color(0xFFF1F5F9),
                  const Color(0xFFE2E8F0),
                ],
        ),
        boxShadow: isPressed
            ? [
                BoxShadow(
                  color: const Color(0xFF6366F1).withAlpha((0.6 * 255).round()),
                  blurRadius: 16,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withAlpha((0.2 * 255).round()),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Pressed indicator bar
          if (isPressed)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF818CF8),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ),
            ),
          // Note label text
          if (showLabel)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    note.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isPressed ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    '${note.octave}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isPressed
                          ? Colors.white70
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBlackKey() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 60),
      curve: Curves.easeOutCubic,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(6),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isPressed
              ? [
                  const Color(0xFF312E81),
                  const Color(0xFF4F46E5), // Glowing blue-purple on press
                ]
              : [
                  const Color(0xFF1E293B),
                  const Color(0xFF0F172A),
                  Colors.black,
                ],
        ),
        boxShadow: isPressed
            ? [
                BoxShadow(
                  color: const Color(0xFF818CF8).withAlpha((0.7 * 255).round()),
                  blurRadius: 14,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withAlpha((0.5 * 255).round()),
                  blurRadius: 6,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Top accent strip
          Positioned(
            top: 0,
            left: 2,
            right: 2,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: isPressed ? const Color(0xFFA5B4FC) : Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          if (showLabel)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                note.name,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isPressed ? Colors.white : Colors.white70,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
