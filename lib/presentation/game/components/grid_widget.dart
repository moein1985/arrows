import 'package:flutter/material.dart';
import '../../../domain/entities/arrow.dart';
import '../../../domain/entities/level.dart';
import '../../../domain/entities/puzzle_state.dart';
import 'arrow_widget.dart';

class GridWidget extends StatelessWidget {
  final GameLevel level;
  final PuzzleState puzzle;
  final bool isLastActionCollision;
  final void Function(String arrowId) onArrowTap;

  const GridWidget({
    super.key,
    required this.level,
    required this.puzzle,
    required this.isLastActionCollision,
    required this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    final arrowMap = <String, Arrow>{};
    for (final a in puzzle.remainingArrows) {
      arrowMap[a.id] = a;
    }

    return AspectRatio(
      aspectRatio: level.gridCols / level.gridRows,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: level.gridCols,
            childAspectRatio: 1,
          ),
          itemCount: level.gridRows * level.gridCols,
          itemBuilder: (context, index) {
            final row = index ~/ level.gridCols;
            final col = index % level.gridCols;

            Arrow? arrow;
            String? arrowId;
            for (final a in puzzle.remainingArrows) {
              if (a.row == row && a.col == col) {
                arrow = a;
                arrowId = a.id;
                break;
              }
            }

            final isHint = arrowId != null && arrowId == puzzle.hintArrowId;
            final isCollision = isLastActionCollision && arrow != null;

            return ArrowWidget(
              arrow: arrow,
              isHint: isHint,
              isCollision: isCollision,
              onTap: arrowId != null && puzzle.status == PuzzleStatus.playing
                  ? () => onArrowTap(arrowId!)
                  : null,
            );
          },
        ),
      ),
    );
  }
}
