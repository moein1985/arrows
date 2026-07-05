import 'package:arrows/data/levels/level_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LevelData', () {
    test('creates 100 levels', () {
      expect(LevelData.levels.length, 100);
      expect(LevelData.levels.first.id, 1);
      expect(LevelData.levels.last.id, 100);
    });

    test('each level has unique id', () {
      final ids = LevelData.levels.map((l) => l.id).toSet();
      expect(ids.length, 100);
    });

    test('each level has at least 2 arrows', () {
      for (final level in LevelData.levels) {
        expect(level.arrows.length, greaterThanOrEqualTo(2),
            reason: 'Level ${level.id} has fewer than 2 arrows');
      }
    });

    test('no two arrows share the same cell in a level', () {
      for (final level in LevelData.levels) {
        final positions = <String>{};
        for (final arrow in level.arrows) {
          final key = '${arrow.row},${arrow.col}';
          expect(positions.contains(key), isFalse,
              reason: 'Level ${level.id} has overlapping arrows at $key');
          positions.add(key);
        }
      }
    });

    test('arrows are within grid bounds', () {
      for (final level in LevelData.levels) {
        for (final arrow in level.arrows) {
          expect(arrow.row, lessThan(level.gridRows),
              reason: 'Level ${level.id} arrow ${arrow.id} row out of bounds');
          expect(arrow.col, lessThan(level.gridCols),
              reason: 'Level ${level.id} arrow ${arrow.id} col out of bounds');
        }
      }
    });
  });
}

