import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'theme/piano_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to landscape orientation as requested
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Set dark status bar / navigation bar system overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: PianoTheme.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const SimplePianoApp());
}

class SimplePianoApp extends StatelessWidget {
  const SimplePianoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grand Piano Studio',
      debugShowCheckedModeBanner: false,
      theme: PianoTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
