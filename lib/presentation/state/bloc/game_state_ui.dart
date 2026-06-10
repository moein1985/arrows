part of 'game_bloc.dart';

abstract class GameStateUI extends Equatable {
  const GameStateUI();

  @override
  List<Object> get props => [];
}

class GameInitial extends GameStateUI {}

class GameLoading extends GameStateUI {}

class GamePlaying extends GameStateUI {
  final int score;
  final int lives;
  final List<Arrow> arrows;

  const GamePlaying({required this.score, required this.lives, required this.arrows});

  @override
  List<Object> get props => [score, lives, arrows];
}

class GameOver extends GameStateUI {
  final int finalScore;

  const GameOver({required this.finalScore});

  @override
  List<Object> get props => [finalScore];
}

class GameError extends GameStateUI {
  final String message;

  const GameError(this.message);

  @override
  List<Object> get props => [message];
}
