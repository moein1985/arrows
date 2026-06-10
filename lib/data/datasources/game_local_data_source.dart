import 'dart:async';
import 'dart:math';
import '../../domain/entities/arrow.dart';
import '../../domain/entities/game_state.dart';

abstract class GameLocalDataSource {
  Stream<GameState> getGameState();
  Future<void> startGame();
  Future<void> submitPlayerAction(ArrowDirection direction);
}

class GameLocalDataSourceImpl implements GameLocalDataSource {
  final _gameStateController = StreamController<GameState>.broadcast();
  Timer? _timer;
  GameState _currentState = GameState.initial();
  final Random _random = Random();

  @override
  Stream<GameState> getGameState() {
    // Yield initial state immediately
    Future.delayed(Duration.zero, () {
      _gameStateController.add(_currentState);
    });
    return _gameStateController.stream;
  }

  @override
  Future<void> startGame() async {
    _currentState = GameState.initial().copyWith(status: GameStatus.playing);
    _gameStateController.add(_currentState);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentState.status == GameStatus.playing) {
        _addNewArrow();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Future<void> submitPlayerAction(ArrowDirection direction) async {
    if (_currentState.arrows.isEmpty || _currentState.status != GameStatus.playing) {
      return; // Nothing to check against
    }

    final expectedDirection = _currentState.arrows.first.direction; // Check against the FIRST arrow
    if (direction == expectedDirection) {
      // Correct action
      final newArrows = List<Arrow>.from(_currentState.arrows)..removeAt(0); // Remove the FIRST arrow
      _currentState = _currentState.copyWith(
        score: _currentState.score + 1,
        arrows: newArrows,
      );
    } else {
      // Incorrect action
      final newLives = _currentState.lives - 1;
      _currentState = _currentState.copyWith(lives: newLives);
      if (newLives <= 0) { // Use <= to be safe
        _endGame();
      }
    }
    _gameStateController.add(_currentState);
  }

  void _addNewArrow() {
    var currentArrows = List<Arrow>.from(_currentState.arrows);
    var currentLives = _currentState.lives;

    if (currentArrows.length >= 5) { // Max 5 arrows on screen
      currentArrows.removeAt(0); // Remove the oldest arrow
      currentLives--; // Player loses a life
    }

    if (currentLives <= 0) {
      _endGame();
      return;
    }

    final direction = ArrowDirection.values[_random.nextInt(ArrowDirection.values.length)];
    final newArrow = Arrow(id: DateTime.now().toIso8601String(), direction: direction);
    currentArrows.add(newArrow); // Add the new arrow

    _currentState = _currentState.copyWith(
      arrows: currentArrows,
      lives: currentLives,
    );
    _gameStateController.add(_currentState);
  }

  void _endGame() {
    _timer?.cancel();
    _currentState = _currentState.copyWith(status: GameStatus.gameOver);
    _gameStateController.add(_currentState);
  }

  void dispose() {
    _timer?.cancel();
    _gameStateController.close();
  }
}
