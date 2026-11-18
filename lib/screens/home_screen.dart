import 'package:flutter/material.dart';
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
        backgroundColor: const Color(0xFF161A29),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
        ),
        title: const Row(
          children: [
            Icon(Icons.help_outline_rounded, color: Color(0xFF818CF8), size: 26),
            SizedBox(width: 10),
            Text(
              'How to Use Keyboard',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
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
              const SizedBox(height: 12),
              _buildInstructionStep(
                icon: Icons.grid_view_rounded,
                title: '4 Playing Modes',
                description:
                    '• Single: Scrollable 88-key layout with octave selector.\n'
                    '• Double: Stacked dual keyboard rows for expanded range.\n'
                    '• Dual Player: Flipped top keyboard for face-to-face duets.\n'
                    '• Chords: Instant one-tap Major, Minor, 7th & Maj7 chords.',
              ),
              const SizedBox(height: 12),
              _buildInstructionStep(
                icon: Icons.lock_clock_rounded,
                title: 'Octave Navigation & Lock',
                description: 'Tap any Octave button (Oct 0 - Oct 7) to jump directly. Tap again to lock scrolling to that specific octave.',
              ),
              const SizedBox(height: 12),
              _buildInstructionStep(
                icon: Icons.zoom_in_rounded,
                title: 'Adjust Key Size & Labels',
                description: 'Use the slider at the top bar to resize keys and press the Subtitle button to toggle note name labels.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Got It!',
              style: TextStyle(
                color: Color(0xFF818CF8),
                fontWeight: FontWeight.bold,
                fontSize: 15,
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
            color: const Color(0xFF23293E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF818CF8), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                  height: 1.35,
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
      backgroundColor: const Color(0xFF0F111A),
      body: Stack(
        children: [
          // Ambient Glow Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.9,
                  colors: [
                    Color(0x336366F1),
                    Color(0x111E1B4B),
                    Color(0xFF0F111A),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header Logo & Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF818CF8), Color(0xFF4F46E5)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withAlpha(120),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.piano_rounded,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.white, Color(0xFFA5B4FC)],
                              ).createShader(bounds),
                              child: const Text(
                                'Simple Piano Studio',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Text(
                              '88 Keys Acoustic Performance',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF94A3B8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Action Buttons Row (Compose Piano & How to Use)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Compose / Start Playing Button
                        ElevatedButton.icon(
                          onPressed: () => _navigateToPiano(context),
                          icon: const Icon(Icons.music_note_rounded, size: 22),
                          label: const Text(
                            'Compose / Play',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            elevation: 8,
                            shadowColor: const Color(0xFF6366F1).withAlpha(150),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // How to Use Instructions Button
                        OutlinedButton.icon(
                          onPressed: () => _showHowToUseDialog(context),
                          icon: const Icon(Icons.help_outline_rounded, size: 22),
                          label: const Text(
                            'How to Use',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF818CF8),
                            side: const BorderSide(color: Color(0xFF818CF8), width: 1.8),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
    );
  }
}
