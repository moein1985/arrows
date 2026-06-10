import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/entities/game_state.dart' as domain;
import '../../../domain/usecases/get_game_state_usecase.dart';
import '../../../domain/usecases/start_game_usecase.dart';
import '../../../domain/usecases/submit_player_action_usecase.dart';
import '../event/game_event.dart';
import '../../../domain/entities/arrow.dart';
import 'package:equatable/equatable.dart';

part 'game_state_ui.dart';

class GameBloc extends Bloc<GameEvent, GameStateUI> {
  final StartGameUseCase startGameUseCase;
  final GetGameStateUseCase getGameStateUseCase;
  final SubmitPlayerActionUseCase submitPlayerActionUseCase;
  StreamSubscription? _gameStateSubscription;

  GameBloc({
    required this.startGameUseCase,
    required this.getGameStateUseCase,
    required this.submitPlayerActionUseCase,
  }) : super(GameInitial()) {
    on<StartGame>(_onStartGame);
    on<PlayerSwiped>(_onPlayerSwiped);
    on<_GameStateUpdated>(_onGameStateUpdated);
  }

  void _onStartGame(StartGame event, Emitter<GameStateUI> emit) async {
    debugPrint('[GameBloc] _onStartGame: Starting new game...');
    emit(GameLoading());
    final failureOrStarted = await startGameUseCase(NoParams());
    failureOrStarted.fold(
      (failure) {
        debugPrint('[GameBloc] _onStartGame: Failed to start game.');
        emit(GameError('Failed to start the game.'));
      },
      (_) {
        debugPrint('[GameBloc] _onStartGame: Game started successfully. Listening for game state updates.');
        _gameStateSubscription?.cancel();
        _gameStateSubscription = getGameStateUseCase(NoParams()).listen(
          (failureOrGameState) {
            failureOrGameState.fold(
              (failure) {
                debugPrint('[GameBloc] Listener: Received game state failure.');
                add(_GameStateUpdated(GameError('Failed to get game state.')));
              },
              (gameState) {
                debugPrint('[GameBloc] Listener: Received new game state: Score=${gameState.score}, Lives=${gameState.lives}, Arrows=${gameState.arrows.length}');
                add(_GameStateUpdated(gameState));
              },
            );
          },
        );
      },
    );
  }

  void _onPlayerSwiped(PlayerSwiped event, Emitter<GameStateUI> emit) async {
    debugPrint('[GameBloc] _onPlayerSwiped: Player swiped ${event.direction}');
    await submitPlayerActionUseCase(Params(direction: event.direction));
  }

  void _onGameStateUpdated(_GameStateUpdated event, Emitter<GameStateUI> emit) {
    final gameState = event.gameState;
    debugPrint('[GameBloc] _onGameStateUpdated: Processing game state update of type ${gameState.runtimeType}');

    if (gameState is domain.GameState) {
      final uiState = GamePlaying(
        score: gameState.score,
        lives: gameState.lives,
        arrows: gameState.arrows,
      );
      if (gameState.status == domain.GameStatus.gameOver) {
        debugPrint('[GameBloc] _onGameStateUpdated: Game is over. Final score: ${gameState.score}');
        emit(GameOver(finalScore: gameState.score));
      } else {
        debugPrint('[GameBloc] _onGameStateUpdated: Emitting GamePlaying state.');
        emit(uiState);
      }
    } else if (gameState is GameError) {
      debugPrint('[GameBloc] _onGameStateUpdated: Emitting GameError state: ${gameState.message}');
      emit(gameState);
    }
  }

  @override
  Future<void> close() {
    debugPrint('[GameBloc] close: Closing GameBloc and canceling subscription.');
    _gameStateSubscription?.cancel();
    return super.close();
  }
}

class _GameStateUpdated extends GameEvent {
  final dynamic gameState; // Using dynamic to avoid layer violations, will be mapped in BLoC

  const _GameStateUpdated(this.gameState);

  @override
  List<Object> get props => [gameState];
}


