import 'package:equatable/equatable.dart';
import 'arrow.dart';

enum PuzzleStatus { playing, won, lost }

class PuzzleState extends Equatable {
  final int levelId;
  final List<Arrow> remainingArrows;
  final int hearts;
  final List<String> extractedArrowIds;
  final PuzzleStatus status;
  final String? hintArrowId;
  final int hintsUsed;
  final String? collidedArrowId;
  final bool isAnimating;

  const PuzzleState({
    required this.levelId,
    required this.remainingArrows,
    required this.hearts,
    required this.extractedArrowIds,
    required this.status,
    this.hintArrowId,
    this.hintsUsed = 0,
    this.collidedArrowId,
    this.isAnimating = false,
  });

  PuzzleState copyWith({
    int? levelId,
    List<Arrow>? remainingArrows,
    int? hearts,
    List<String>? extractedArrowIds,
    PuzzleStatus? status,
    String? hintArrowId,
    int? hintsUsed,
    String? collidedArrowId,
    bool? isAnimating,
  }) {
    return PuzzleState(
      levelId: levelId ?? this.levelId,
      remainingArrows: remainingArrows ?? this.remainingArrows,
      hearts: hearts ?? this.hearts,
      extractedArrowIds: extractedArrowIds ?? this.extractedArrowIds,
      status: status ?? this.status,
      hintArrowId: hintArrowId ?? this.hintArrowId,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      collidedArrowId: collidedArrowId,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }

  @override
  List<Object?> get props => [
        levelId,
        remainingArrows,
        hearts,
        extractedArrowIds,
        status,
        hintArrowId,
        hintsUsed,
        collidedArrowId,
        isAnimating,
      ];
}
