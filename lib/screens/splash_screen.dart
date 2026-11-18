import 'package:flutter/material.dart';
import '../audio/piano_audio.dart';
import '../theme/piano_theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
    _startAppInit();
  }

  Future<void> _startAppInit() async {
    // Initialize audio engine during splash screen load
    final startTime = DateTime.now();
    await PianoAudioService.instance.init();
    final elapsed = DateTime.now().difference(startTime);

    // Ensure splash displays for at least 2.2 seconds for a pleasant feel-good feel
    final remaining = const Duration(milliseconds: 2200) - elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PianoTheme.background,
      body: Stack(
        children: [
          // Background ambient glowing aura
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: PianoTheme.backgroundGlow,
              ),
            ),
          ),

          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: ScaleTransition(
                  scale: _pulseAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Luxury Piano Icon Crest
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF2E3342),
                              Color(0xFF161821),
                              Color(0xFF0C0E14),
                            ],
                          ),
                          border: Border.all(
                            color: PianoTheme.goldAccent.withAlpha(160),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: PianoTheme.goldAccent.withAlpha(50),
                              blurRadius: 32,
                              spreadRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.black.withAlpha(180),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.piano_rounded,
                          size: 48,
                          color: PianoTheme.goldAccent,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // App Title in Luxury Serif
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            PianoTheme.goldLight,
                            PianoTheme.goldAccent,
                            PianoTheme.goldDeep,
                          ],
                        ).createShader(bounds),
                        child: Text(
                          'Grand Piano Studio',
                          style: PianoTheme.titleSerif.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        'Acoustic Concert Grand • 88 Master Keys',
                        style: PianoTheme.bodySans.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.8,
                          color: const Color(0xFFB0B7C6),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Subtle Loading Indicator with gold accent
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            PianoTheme.goldAccent.withAlpha(200),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Tagline
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Text(
              'CONCERT PERFORMANCE AUDIO ENGINE',
              textAlign: TextAlign.center,
              style: PianoTheme.labelSans.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 3.0,
                color: Colors.white24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
