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
  int _spawnSpeed = 2000; // Initial spawn speed in milliseconds
  final int _minSpawnSpeed = 500; // Minimum spawn speed
  final int _speedIncreaseFactor = 50; // a smaller number means faster speed increase

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
    _spawnSpeed = 2000;
    _gameStateController.add(_currentState);

    _timer?.cancel();
    _scheduleNextArrow();
  }

  void _scheduleNextArrow() {
    if (_currentState.status != GameStatus.playing) return;

    _timer = Timer(Duration(milliseconds: _spawnSpeed), () {
      _addNewArrow();
      _scheduleNextArrow();
    });
  }

  @override
  Future<void> submitPlayerAction(ArrowDirection direction) async {
    if (_currentState.arrows.isEmpty || _currentState.status != GameStatus.playing) {
      return; // Nothing to check against
    }

    final expectedDirection = _currentState.arrows.first.direction;
    if (direction == expectedDirection) {
      // Correct action
      final newArrows = List<Arrow>.from(_currentState.arrows)..removeAt(0);
      final newScore = _currentState.score + 1;

      // Increase speed
      if (newScore % 5 == 0 && _spawnSpeed > _minSpawnSpeed) {
        _spawnSpeed = max(_minSpawnSpeed, _spawnSpeed - _speedIncreaseFactor);
      }

      _currentState = _currentState.copyWith(
        score: newScore,
        arrows: newArrows,
      );
    } else {
      // Incorrect action
      final newLives = _currentState.lives - 1;
      _currentState = _currentState.copyWith(lives: newLives);
      if (newLives <= 0) {
        _endGame();
      }
    }
    _gameStateController.add(_currentState);
  }

  void _addNewArrow() {
    var currentArrows = List<Arrow>.from(_currentState.arrows);
    var currentLives = _currentState.lives;

    if (currentArrows.length >= 5) {
      currentArrows.removeAt(0); // Remove the oldest arrow
      currentLives--; // Player loses a life
    }

    if (currentLives <= 0) {
      _endGame();
      return;
    }

    final direction = ArrowDirection.values[_random.nextInt(ArrowDirection.values.length)];
    final newArrow = Arrow(id: DateTime.now().toIso8601String(), direction: direction);
    currentArrows.add(newArrow);

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
