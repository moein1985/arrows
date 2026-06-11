import 'package:equatable/equatable.dart';
import '../../../domain/entities/arrow.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class StartGame extends GameEvent {}

class PlayerSwiped extends GameEvent {
  final ArrowDirection direction;

  const PlayerSwiped({required this.direction});

  @override
  List<Object> get props => [direction];
}

class PauseGame extends GameEvent {}

class ResumeGame extends GameEvent {}



