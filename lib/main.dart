import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/manga_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const OSMasteryApp());
}

class OSMasteryApp extends StatelessWidget {
  const OSMasteryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OS Mastery Study Tracker',
      debugShowCheckedModeBanner: false,
      theme: MangaTheme.theme,
      home: const SplashScreen(),
    );
  }
}
