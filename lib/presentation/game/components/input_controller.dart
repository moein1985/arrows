import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/arrow.dart';
import '../../state/bloc/game_bloc.dart';
import '../../state/event/game_event.dart';

class InputController extends StatelessWidget {
  final Widget child;
  const InputController({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: (details) {
        final velocity = details.velocity.pixelsPerSecond;
        final dx = velocity.dx.abs();
        final dy = velocity.dy.abs();

        if (dx > dy) {
          // Horizontal swipe
          if (details.velocity.pixelsPerSecond.dx > 0) {
            context.read<GameBloc>().add(const PlayerSwiped(direction: ArrowDirection.right));
          } else {
            context.read<GameBloc>().add(const PlayerSwiped(direction: ArrowDirection.left));
          }
        } else {
          // Vertical swipe
          if (details.velocity.pixelsPerSecond.dy > 0) {
            context.read<GameBloc>().add(const PlayerSwiped(direction: ArrowDirection.down));
          } else {
            context.read<GameBloc>().add(const PlayerSwiped(direction: ArrowDirection.up));
          }
        }
      },
      child: child,
    );
  }
}
