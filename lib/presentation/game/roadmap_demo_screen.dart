import 'package:flutter/material.dart';

import '../../domain/entities/game_phase.dart';

class RoadmapDemoScreen extends StatefulWidget {
  const RoadmapDemoScreen({super.key});

  @override
  State<RoadmapDemoScreen> createState() => _RoadmapDemoScreenState();
}

class _RoadmapDemoScreenState extends State<RoadmapDemoScreen> {
  final GamePhase _phase = GamePhase.mainMenu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Roadmap Demo')),
      body: Center(
        child: Text('Current phase: $_phase'),
      ),
    );
  }
}
