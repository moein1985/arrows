import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/levels/level_data.dart';
import '../../../domain/entities/arrow.dart';
import '../../../domain/entities/level.dart';
import '../../../domain/entities/puzzle_state.dart';
import 'level_game_state.dart';

class LevelGameCubit extends Cubit<LevelGameState> {
  LevelGameCubit()
      : super(
          LevelGameState(
            levelNumber: 1,
            totalLevels: LevelData.levels.length,
            currentLevel: LevelData.levels.first,
            puzzle: _initialPuzzle(LevelData.levels.first),
          ),
        );

  static PuzzleState _initialPuzzle(GameLevel level) {
    return PuzzleState(
      levelId: level.id,
      remainingArrows: List.from(level.arrows),
      hearts: level.hearts,
      extractedArrowIds: [],
      status: PuzzleStatus.playing,
    );
  }

  void startLevel(int levelNumber) {
    final index = (levelNumber - 1).clamp(0, LevelData.levels.length - 1);
    final level = LevelData.levels[index];
    emit(
      state.copyWith(
        levelNumber: level.id,
        currentLevel: level,
        puzzle: _initialPuzzle(level),
        isLastActionCollision: false,
      ),
    );
  }

  void extractArrow(String arrowId) {
    final puzzle = state.puzzle;
    if (puzzle.status != PuzzleStatus.playing) return;
    if (puzzle.isAnimating) return;

    final arrow = puzzle.remainingArrows.firstWhere(
      (a) => a.id == arrowId,
      orElse: () => puzzle.remainingArrows.first,
    );

    final isClear = _isPathClear(
      arrow,
      puzzle.remainingArrows,
      state.currentLevel.gridRows,
      state.currentLevel.gridCols,
    );

    if (!isClear) {
      final newHearts = puzzle.hearts - 1;
      final newRemaining = puzzle.remainingArrows
          .map((a) => a.id == arrowId ? a.copyWith(state: BlockState.collided) : a)
          .toList();

      emit(
        state.copyWith(
          puzzle: puzzle.copyWith(
            remainingArrows: newRemaining,
            hearts: newHearts,
            hintArrowId: null,
            collidedArrowId: arrowId,
            isAnimating: true,
          ),
          isLastActionCollision: true,
        ),
      );
      return;
    }

    final newRemaining = puzzle.remainingArrows
        .map((a) => a.id == arrowId ? a.copyWith(state: BlockState.moving) : a)
        .toList();

    emit(
      state.copyWith(
        puzzle: puzzle.copyWith(
          remainingArrows: newRemaining,
          hintArrowId: null,
          isAnimating: true,
        ),
        isLastActionCollision: false,
      ),
    );
  }

  void onSlideComplete(String arrowId) {
    final puzzle = state.puzzle;
    if (puzzle.status != PuzzleStatus.playing) return;

    final newRemaining =
        List<Arrow>.from(puzzle.remainingArrows)..removeWhere((a) => a.id == arrowId);
    final newExtracted = List<String>.from(puzzle.extractedArrowIds)..add(arrowId);
    final newStatus =
        newRemaining.isEmpty ? PuzzleStatus.won : PuzzleStatus.playing;

    emit(
      state.copyWith(
        puzzle: puzzle.copyWith(
          remainingArrows: newRemaining,
          extractedArrowIds: newExtracted,
          status: newStatus,
          isAnimating: false,
        ),
      ),
    );
  }

  void onCollisionComplete(String arrowId) {
    final puzzle = state.puzzle;

    final newRemaining = puzzle.remainingArrows
        .map((a) => a.id == arrowId ? a.copyWith(state: BlockState.idle) : a)
        .toList();

    final newStatus =
        puzzle.hearts <= 0 ? PuzzleStatus.lost : PuzzleStatus.playing;

    emit(
      state.copyWith(
        puzzle: puzzle.copyWith(
          remainingArrows: newRemaining,
          status: newStatus,
          collidedArrowId: null,
          isAnimating: false,
        ),
      ),
    );
  }

  bool _isPathClear(Arrow arrow, List<Arrow> allArrows, int gridRows, int gridCols) {
    switch (arrow.direction) {
      case ArrowDirection.up:
        for (var r = arrow.row - 1; r >= 0; r--) {
          if (_hasArrowAt(allArrows, r, arrow.col)) return false;
        }
        break;
      case ArrowDirection.down:
        for (var r = arrow.row + 1; r < gridRows; r++) {
          if (_hasArrowAt(allArrows, r, arrow.col)) return false;
        }
        break;
      case ArrowDirection.left:
        for (var c = arrow.col - 1; c >= 0; c--) {
          if (_hasArrowAt(allArrows, arrow.row, c)) return false;
        }
        break;
      case ArrowDirection.right:
        for (var c = arrow.col + 1; c < gridCols; c++) {
          if (_hasArrowAt(allArrows, arrow.row, c)) return false;
        }
        break;
    }
    return true;
  }

  bool _hasArrowAt(List<Arrow> allArrows, int row, int col) {
    return allArrows.any((a) => a.row == row && a.col == col);
  }

  void undo() {
    final puzzle = state.puzzle;
    if (puzzle.extractedArrowIds.isEmpty) return;
    if (puzzle.isAnimating) return;
    if (puzzle.status != PuzzleStatus.playing && puzzle.status != PuzzleStatus.won) return;

    final lastId = puzzle.extractedArrowIds.last;
    final arrow = state.currentLevel.arrows.firstWhere((a) => a.id == lastId);

    final newRemaining = List<Arrow>.from(puzzle.remainingArrows)..add(arrow);
    final newExtracted = List<String>.from(puzzle.extractedArrowIds)..removeLast();

    emit(
      state.copyWith(
        puzzle: puzzle.copyWith(
          remainingArrows: newRemaining,
          extractedArrowIds: newExtracted,
          status: PuzzleStatus.playing,
          hintArrowId: null,
          isAnimating: false,
        ),
        isLastActionCollision: false,
      ),
    );
  }

  void resetLevel() {
    final level = state.currentLevel;
    emit(
      state.copyWith(
        puzzle: _initialPuzzle(level),
        isLastActionCollision: false,
      ),
    );
  }

  void showHint() {
    final puzzle = state.puzzle;
    if (puzzle.status != PuzzleStatus.playing) return;
    if (puzzle.isAnimating) return;

    for (final arrow in puzzle.remainingArrows) {
      final isClear = _isPathClear(
        arrow,
        puzzle.remainingArrows,
        state.currentLevel.gridRows,
        state.currentLevel.gridCols,
      );
      if (isClear) {
        emit(
          state.copyWith(
            puzzle: puzzle.copyWith(
              hintArrowId: arrow.id,
              hintsUsed: puzzle.hintsUsed + 1,
            ),
          ),
        );
        return;
      }
    }
  }

  void nextLevel() {
    final next = state.levelNumber < state.totalLevels
        ? state.levelNumber + 1
        : state.levelNumber;
    startLevel(next);
  }
}
