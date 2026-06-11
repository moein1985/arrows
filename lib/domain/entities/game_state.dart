import 'package:equatable/equatable.dart';
import 'arrow.dart';

enum GameStatus { initial, playing, paused, gameOver }

class GameState extends Equatable {
  final int score;
  final int lives;
  final List<Arrow> arrows;
  final GameStatus status;

  const GameState({
    required this.score,
    required this.lives,
    required this.arrows,
    required this.status,
  });

  factory GameState.initial() {
    return const GameState(
      score: 0,
      lives: 3,
      arrows: [],
      status: GameStatus.initial,
    );
  }

  GameState copyWith({
    int? score,
    int? lives,
    List<Arrow>? arrows,
    GameStatus? status,
  }) {
    return GameState(
      score: score ?? this.score,
      lives: lives ?? this.lives,
      arrows: arrows ?? this.arrows,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [score, lives, arrows, status];
}
