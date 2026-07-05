import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/puzzle_state.dart';
import '../state/cubit/level_game_cubit.dart';
import '../state/cubit/level_game_state.dart';
import 'components/grid_widget.dart';
import 'components/hud_widget.dart';

class PuzzleScreen extends StatelessWidget {
  const PuzzleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LevelGameCubit(),
      child: const _PuzzleView(),
    );
  }
}

class _PuzzleView extends StatelessWidget {
  const _PuzzleView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: BlocBuilder<LevelGameCubit, LevelGameState>(
          builder: (context, state) {
            final puzzle = state.puzzle;
            final cubit = context.read<LevelGameCubit>();

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  HudWidget(
                    levelNumber: state.levelNumber,
                    totalLevels: state.totalLevels,
                    hearts: puzzle.hearts,
                    maxHearts: state.currentLevel.hearts,
                    canUndo: puzzle.extractedArrowIds.isNotEmpty,
                    onUndo: cubit.undo,
                    onReset: cubit.resetLevel,
                    onHint: cubit.showHint,
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Center(
                      child: GridWidget(
                        level: state.currentLevel,
                        puzzle: puzzle,
                        isLastActionCollision: state.isLastActionCollision,
                        onArrowTap: cubit.extractArrow,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (puzzle.status == PuzzleStatus.won)
                    _ResultBanner(
                      text: 'Level Cleared!',
                      color: Colors.greenAccent,
                      buttonText: 'Next Level',
                      onButtonTap: cubit.nextLevel,
                    )
                  else if (puzzle.status == PuzzleStatus.lost)
                    _ResultBanner(
                      text: 'Out of Hearts!',
                      color: Colors.redAccent,
                      buttonText: 'Retry',
                      onButtonTap: cubit.resetLevel,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ResultBanner extends StatelessWidget {
  final String text;
  final Color color;
  final String buttonText;
  final VoidCallback onButtonTap;

  const _ResultBanner({
    required this.text,
    required this.color,
    required this.buttonText,
    required this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: onButtonTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.black,
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
