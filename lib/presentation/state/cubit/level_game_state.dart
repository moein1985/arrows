import 'package:equatable/equatable.dart';
import '../../../domain/entities/level.dart';
import '../../../domain/entities/puzzle_state.dart';

class LevelGameState extends Equatable {
  final int levelNumber;
  final int totalLevels;
  final GameLevel currentLevel;
  final PuzzleState puzzle;
  final bool isLastActionCollision;

  const LevelGameState({
    required this.levelNumber,
    required this.totalLevels,
    required this.currentLevel,
    required this.puzzle,
    this.isLastActionCollision = false,
  });

  LevelGameState copyWith({
    int? levelNumber,
    int? totalLevels,
    GameLevel? currentLevel,
    PuzzleState? puzzle,
    bool? isLastActionCollision,
  }) {
    return LevelGameState(
      levelNumber: levelNumber ?? this.levelNumber,
      totalLevels: totalLevels ?? this.totalLevels,
      currentLevel: currentLevel ?? this.currentLevel,
      puzzle: puzzle ?? this.puzzle,
      isLastActionCollision: isLastActionCollision ?? false,
    );
  }

  @override
  List<Object?> get props => [
        levelNumber,
        totalLevels,
        currentLevel,
        puzzle,
        isLastActionCollision,
      ];
}
