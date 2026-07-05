import 'package:flutter/material.dart';
import '../../../domain/entities/arrow.dart';
import '../../../domain/entities/level.dart';
import '../../../domain/entities/puzzle_state.dart';
import 'arrow_widget.dart';

class GridWidget extends StatefulWidget {
  final GameLevel level;
  final PuzzleState puzzle;
  final void Function(String arrowId) onArrowTap;
  final void Function(String arrowId) onSlideComplete;
  final void Function(String arrowId) onCollisionComplete;

  const GridWidget({
    super.key,
    required this.level,
    required this.puzzle,
    required this.onArrowTap,
    required this.onSlideComplete,
    required this.onCollisionComplete,
  });

  @override
  State<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  String? _animatingArrowId;
  bool _isCollisionAnim = false;

  @override
  void didUpdateWidget(GridWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final collidedId = widget.puzzle.collidedArrowId;
    if (collidedId != null && _animatingArrowId != collidedId) {
      _animatingArrowId = collidedId;
      _isCollisionAnim = true;
    }

    for (final arrow in widget.puzzle.remainingArrows) {
      if (arrow.state == BlockState.moving &&
          _animatingArrowId != arrow.id) {
        _animatingArrowId = arrow.id;
        _isCollisionAnim = false;
      }
    }
  }

  Offset _calcTargetOffset(Arrow arrow, double cellW, double cellH) {
    final baseX = arrow.col * cellW;
    final baseY = arrow.row * cellH;

    switch (arrow.direction) {
      case ArrowDirection.up:
        return Offset(baseX, -cellH);
      case ArrowDirection.down:
        return Offset(baseX, widget.level.gridRows * cellH);
      case ArrowDirection.left:
        return Offset(-cellW, baseY);
      case ArrowDirection.right:
        return Offset(widget.level.gridCols * cellW, baseY);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;

        final aspect = widget.level.gridCols / widget.level.gridRows;
        double gridW, gridH;
        if (maxW / maxH > aspect) {
          gridH = maxH;
          gridW = gridH * aspect;
        } else {
          gridW = maxW;
          gridH = gridW / aspect;
        }

        final cellW = gridW / widget.level.gridCols;
        final cellH = gridH / widget.level.gridRows;

        return SizedBox(
          width: gridW,
          height: gridH,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Layer 1: empty grid background
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D0D12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.level.gridCols,
                      childAspectRatio: 1,
                    ),
                    itemCount:
                        widget.level.gridRows * widget.level.gridCols,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF151521),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Layer 2: arrows with AnimatedPositioned
              for (final arrow in widget.puzzle.remainingArrows)
                _buildArrowLayer(arrow, cellW, cellH),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArrowLayer(Arrow arrow, double cellW, double cellH) {
    final isMoving = arrow.state == BlockState.moving;
    final isCollided = arrow.state == BlockState.collided;
    final isHint = arrow.id == widget.puzzle.hintArrowId;
    final canTap = arrow.state == BlockState.idle &&
        !widget.puzzle.isAnimating &&
        widget.puzzle.status == PuzzleStatus.playing;

    double left = arrow.col * cellW;
    double top = arrow.row * cellH;

    if (isMoving || (isCollided && _animatingArrowId == arrow.id)) {
      final target = _calcTargetOffset(arrow, cellW, cellH);
      left = target.dx;
      top = target.dy;
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      left: left,
      top: top,
      width: cellW,
      height: cellH,
      onEnd: () {
        if (_animatingArrowId == arrow.id) {
          if (_isCollisionAnim) {
            widget.onCollisionComplete(arrow.id);
          } else {
            widget.onSlideComplete(arrow.id);
          }
          _animatingArrowId = null;
          _isCollisionAnim = false;
        }
      },
      child: ArrowWidget(
        arrow: arrow,
        isHint: isHint,
        isCollided: isCollided,
        isMoving: isMoving,
        onTap: canTap ? () => widget.onArrowTap(arrow.id) : null,
      ),
    );
  }
}
