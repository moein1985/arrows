import 'package:flutter/material.dart';
import 'presentation/game/puzzle_screen.dart';
import 'presentation/game/start_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arrows Game',
      initialRoute: '/',
      routes: {
        '/': (_) => const StartScreen(),
        '/game': (_) => const PuzzleScreen(),
      },
    );
  }
}
