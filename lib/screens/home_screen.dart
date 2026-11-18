import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/piano_theme.dart';
import 'piano_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateToPiano(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PianoScreen(),
      ),
    );
  }

  void _showHowToUseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: PianoTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: PianoTheme.goldAccent.withAlpha(100),
            width: 1.2,
          ),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.auto_stories_rounded,
              color: PianoTheme.goldAccent,
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              'How to Use Keyboard',
              style: PianoTheme.titleSerif.copyWith(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInstructionStep(
                icon: Icons.piano_rounded,
                title: 'Full 88-Key Piano',
                description: 'Access the complete grand piano range from A0 to C8 with realistic acoustic sound samples.',
              ),
              const SizedBox(height: 14),
              _buildInstructionStep(
                icon: Icons.dashboard_rounded,
                title: '4 Playing Modes',
                description:
                    '• Single: Scrollable 88-key layout with octave selector.\n'
                    '• Double: Stacked dual keyboard rows for expanded range.\n'
                    '• Dual Player: Flipped top keyboard for face-to-face duets.\n'
                    '• Chords: Instant one-tap Major, Minor, 7th & Maj7 chords.',
              ),
              const SizedBox(height: 14),
              _buildInstructionStep(
                icon: Icons.lock_clock_rounded,
                title: 'Octave Navigation & Lock',
                description: 'Tap any Octave button (Oct 0 - Oct 7) to jump directly. Tap again to lock scrolling to that specific octave.',
              ),
              const SizedBox(height: 14),
              _buildInstructionStep(
                icon: Icons.tune_rounded,
                title: 'Adjust Key Size & Labels',
                description: 'Use the slider at the top bar to resize keys and press the Subtitle button to toggle note name labels.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: PianoTheme.goldAccent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'Got It!',
              style: PianoTheme.labelSans.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: PianoTheme.goldAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: PianoTheme.surfaceElevated,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: PianoTheme.goldAccent.withAlpha(50),
              width: 1,
            ),
          ),
          child: Icon(icon, color: PianoTheme.goldAccent, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: PianoTheme.bodySans.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: PianoTheme.bodySans.copyWith(
                  color: const Color(0xFF94A3B8),
                  fontSize: 11.5,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Piano Body Inspired Central Emblem & Title Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(PianoTheme.radiusLarge),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                          decoration: BoxDecoration(
                            color: PianoTheme.surfaceGlass,
                            borderRadius: BorderRadius.circular(PianoTheme.radiusLarge),
                            border: Border.all(
                              color: PianoTheme.surfaceGlassBorder,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(160),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Gold Inlaid Piano Emblem
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const RadialGradient(
                                    colors: [
                                      Color(0xFF282D3D),
                                      Color(0xFF141722),
                                      Color(0xFF090B10),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: PianoTheme.goldAccent.withAlpha(180),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: PianoTheme.goldAccent.withAlpha(45),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.piano_rounded,
                                  size: 40,
                                  color: PianoTheme.goldAccent,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // App Title
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    PianoTheme.goldLight,
                                    PianoTheme.goldAccent,
                                    PianoTheme.goldDeep,
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'Simple Piano Studio',
                                  style: PianoTheme.titleSerif.copyWith(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '88 Keys Acoustic Performance',
                                style: PianoTheme.bodySans.copyWith(
                                  fontSize: 12.5,
                                  color: const Color(0xFFA1A9BC),
                                  letterSpacing: 0.6,
                                ),
                              ),

                              const SizedBox(height: 28),

                              // Action Buttons Row (Compose Piano & How to Use)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Compose / Start Playing Button
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(PianoTheme.radiusMedium),
                                      gradient: const LinearGradient(
                                        colors: [
                                          PianoTheme.goldLight,
                                          PianoTheme.goldAccent,
                                          PianoTheme.goldDeep,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: PianoTheme.goldAccent.withAlpha(90),
                                          blurRadius: 18,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () => _navigateToPiano(context),
                                      icon: const Icon(
                                        Icons.music_note_rounded,
                                        size: 20,
                                        color: Color(0xFF090A0F),
                                      ),
                                      label: Text(
                                        'Compose / Play',
                                        style: PianoTheme.labelSans.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF090A0F),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        foregroundColor: const Color(0xFF090A0F),
                                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(PianoTheme.radiusMedium),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // How to Use Instructions Button
                                  OutlinedButton.icon(
                                    onPressed: () => _showHowToUseDialog(context),
                                    icon: const Icon(
                                      Icons.help_outline_rounded,
                                      size: 20,
                                      color: PianoTheme.goldAccent,
                                    ),
                                    label: Text(
                                      'How to Use',
                                      style: PianoTheme.labelSans.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: PianoTheme.goldLight,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: PianoTheme.goldAccent.withAlpha(140),
                                        width: 1.2,
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(PianoTheme.radiusMedium),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
