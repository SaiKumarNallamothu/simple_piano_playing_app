import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/piano_screen.dart';

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
      systemNavigationBarColor: Color(0xFF0F111A),
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
      title: 'Simple Piano',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F111A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF818CF8),
          surface: Color(0xFF161A29),
        ),
        useMaterial3: true,
      ),
      home: const PianoScreen(),
    );
  }
}
