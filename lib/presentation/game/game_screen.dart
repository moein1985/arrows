import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../state/bloc/game_bloc.dart';
import '../state/event/game_event.dart';
import 'components/arrow_widget.dart';
import 'components/input_controller.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GameBloc>(),
      child: const GameView(),
    );
  }
}

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InputController(
        child: BlocBuilder<GameBloc, GameStateUI>(
          builder: (context, state) {
            if (state is GameInitial) {
              return _buildInitial(context);
            } else if (state is GameLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GamePlaying) {
              return _buildPlaying(context, state);
            } else if (state is GameOver) {
              return _buildGameOver(context, state);
            } else if (state is GameError) {
              return _buildError(context, state);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildInitial(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Arrows Game', style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              context.read<GameBloc>().add(StartGame());
            },
            child: const Text('Start Game'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaying(BuildContext context, GamePlaying state) {
    return SafeArea(
      child: Column(
        children: [
          _buildScoreboard(state),
          Expanded(
            child: Center(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: state.arrows.map((arrow) => ArrowWidget(arrow: arrow)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreboard(GamePlaying state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Score: ${state.score}', style: const TextStyle(fontSize: 24, color: Colors.white)),
          Row(
            children: List.generate(state.lives, (index) => const Icon(Icons.favorite, color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOver(BuildContext context, GameOver state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Game Over', style: const TextStyle(fontSize: 40, color: Colors.red, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text('Final Score: ${state.finalScore}', style: const TextStyle(fontSize: 24, color: Colors.white)),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              context.read<GameBloc>().add(StartGame());
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, GameError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(state.message, style: const TextStyle(fontSize: 24, color: Colors.red)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<GameBloc>().add(StartGame());
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
