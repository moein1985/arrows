# 🧭 نقشه راه پروژه — Arrows: Puzzle Escape

> **بازی مرجع:** [Arrows – Puzzle Escape](https://play.google.com/store/apps/details?id=com.ecffri.arrows)
> **هدف:** بازسازی منطق بازی با ۱۰۰ مرحله دست‌ساز
> **روش:** ساده، گام‌به‌گام، بدون پیچیدگی اضافی

---

## ۱) بازی چه‌کار می‌کند؟ (خلاصه ساده)

- یک **گرید** (مثل جدول) داریم با چند **فلش** روی آن.
- هر فلش یک **جهت** دارد: بالا ⬆️، پایین ⬇️، چپ ⬅️، راست ➡️.
- بازیکن روی فلش **ضربه** می‌زند. فلش در جهت خودش حرکت می‌کند و از گرید خارج می‌شود.
- **اما:** اگر در مسیر حرکت فلش، فلش دیگری باشد → **تصادم**! یک ❤️ کم می‌شود.
- اگر مسیر **خالی** باشد → فلش با موفقیت خارج می‌شود.
- هر مرحله **۳ قلب** دارد. اگر همه تمام شوند → مرحله از اول شروع می‌شود.
- هدف: **همه فلش‌ها را خارج کن** بدون از دست دادن همه قلب‌ها.
- **بدون تایمر** — بازی آرام است.
- دکمه‌ها: **Undo** (برگرداندن آخرین حرکت)، **Reset** (شروع مجدد مرحله)، **Hint** (نشان دادن فلش امن).

---

## ۲) چه چیزی را باید تغییر دهیم؟

کد فعلی دو سیستم اشتباه دارد:
1. **سیستم Arcade**: فلش تصادفی با تایمر ظاهر می‌شود و بازیکن swipe می‌کند → **حذف**
2. **سیستم توالی**: بازیکن دکمه جهت را به ترتیب فشار می‌دهد → **حذف**

باید یک سیستم **گرید + ضربه** بسازیم.

---

## ۳) فایل‌هایی که باید بسازیم/تغییر دهیم

### فایل‌هایی که باید بسازیم:
1. `lib/domain/entities/puzzle_state.dart` — وضعیت بازی
2. `lib/presentation/game/puzzle_screen.dart` — صفحه اصلی بازی (جای level_demo_screen)
3. `lib/presentation/game/components/grid_widget.dart` — رندر گرید
4. `lib/presentation/game/components/hud_widget.dart` — قلب‌ها و دکمه‌ها

### فایل‌هایی که باید بازنویسی کنیم:
5. `lib/domain/entities/arrow.dart` — اضافه کردن row, col
6. `lib/domain/entities/level.dart` — گرید-محور به جای توالی
7. `lib/data/levels/level_data.dart` — ۱۰۰ مرحله دست‌ساز
8. `lib/presentation/state/cubit/level_game_cubit.dart` — منطق پازل
9. `lib/presentation/state/cubit/level_game_state.dart` — وضعیت UI پازل
10. `lib/presentation/game/components/arrow_widget.dart` — سلول گرید
11. `lib/presentation/game/start_screen.dart` — متن جدید
12. `lib/presentation/game/progress_summary.dart` — ۱۰۰ مرحله
13. `lib/core/di/injection_container.dart` — DI ساده
14. `lib/main.dart` — مسیر جدید

### فایل‌هایی که باید حذف کنیم:
15. `lib/domain/entities/game_state.dart`
16. `lib/domain/entities/game_phase.dart`
17. `lib/data/datasources/game_local_data_source.dart`
18. `lib/data/repositories/game_repository_impl.dart`
19. `lib/domain/repositories/game_repository.dart`
20. `lib/domain/usecases/start_game_usecase.dart`
21. `lib/domain/usecases/get_game_state_usecase.dart`
22. `lib/domain/usecases/submit_player_action_usecase.dart`
23. `lib/presentation/state/bloc/game_bloc.dart`
24. `lib/presentation/state/bloc/game_state_ui.dart`
25. `lib/presentation/state/event/game_event.dart`
26. `lib/presentation/game/game_screen.dart`
27. `lib/presentation/game/components/input_controller.dart`
28. `lib/presentation/game/roadmap_demo_screen.dart`
29. `lib/presentation/game/level_demo_screen.dart`

---

## ۴) گام‌های اجرایی (به ترتیب)

### گام ۱: مدل داده (Entity ها)

#### ۱-الف) `lib/domain/entities/arrow.dart` را بازنویسی کن:
```dart
import 'package:equatable/equatable.dart';

enum ArrowDirection { up, down, left, right }

class Arrow extends Equatable {
  final String id;
  final int row;                    // سطر در گرید (از 0)
  final int col;                    // ستون در گرید (از 0)
  final ArrowDirection direction;   // جهت فلش

  const Arrow({
    required this.id,
    required this.row,
    required this.col,
    required this.direction,
  });

  @override
  List<Object?> get props => [id, row, col, direction];
}
```

#### ۱-ب) `lib/domain/entities/level.dart` را بازنویسی کن:
```dart
import 'package:equatable/equatable.dart';
import 'arrow.dart';

class GameLevel extends Equatable {
  final int id;
  final int gridRows;           // تعداد سطرهای گرید
  final int gridCols;           // تعداد ستون‌های گرید
  final List<Arrow> arrows;     // فلش‌های روی گرید
  final int hearts;             // تعداد قلب‌ها (معمولاً 3)
  final int difficulty;         // عدد از 1 تا 5

  const GameLevel({
    required this.id,
    required this.gridRows,
    required this.gridCols,
    required this.arrows,
    required this.hearts,
    required this.difficulty,
  });

  @override
  List<Object?> get props => [id, gridRows, gridCols, arrows, hearts, difficulty];
}
```

#### ۱-ج) `lib/domain/entities/puzzle_state.dart` را بساز:
```dart
import 'package:equatable/equatable.dart';
import 'arrow.dart';

enum PuzzleStatus { playing, won, lost }

class PuzzleState extends Equatable {
  final int levelId;
  final List<Arrow> remainingArrows;     // فلش‌های روی گرید
  final int hearts;                      // قلب‌های باقی‌مانده
  final List<String> extractedArrowIds;  // فلش‌های خارج شده (برای undo)
  final PuzzleStatus status;             // playing / won / lost
  final String? hintArrowId;             // فلش پیشنهادی (null = بدون hint)
  final int hintsUsed;                   // تعداد استفاده از hint

  const PuzzleState({
    required this.levelId,
    required this.remainingArrows,
    required this.hearts,
    required this.extractedArrowIds,
    required this.status,
    this.hintArrowId,
    this.hintsUsed = 0,
  });

  PuzzleState copyWith({
    int? levelId,
    List<Arrow>? remainingArrows,
    int? hearts,
    List<String>? extractedArrowIds,
    PuzzleStatus? status,
    String? hintArrowId,
    int? hintsUsed,
  }) {
    return PuzzleState(
      levelId: levelId ?? this.levelId,
      remainingArrows: remainingArrows ?? this.remainingArrows,
      hearts: hearts ?? this.hearts,
      extractedArrowIds: extractedArrowIds ?? this.extractedArrowIds,
      status: status ?? this.status,
      hintArrowId: hintArrowId ?? this.hintArrowId,
      hintsUsed: hintsUsed ?? this.hintsUsed,
    );
  }

  @override
  List<Object?> get props => [
        levelId, remainingArrows, hearts,
        extractedArrowIds, status, hintArrowId, hintsUsed,
      ];
}
```

### گام ۲: منطق بازی (Cubit)

#### ۲-الف) `lib/presentation/state/cubit/level_game_state.dart` را بازنویسی کن:
```dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/level.dart';
import '../../../domain/entities/puzzle_state.dart';

class LevelGameState extends Equatable {
  final int levelNumber;
  final int totalLevels;
  final GameLevel currentLevel;
  final PuzzleState puzzle;
  final bool isLastActionCollision;  // برای انیمیشن

  const LevelGameState({
    required this.levelNumber,
    required this.totalLevels,
    required this.currentLevel,
    required this.puzzle,
    this.isLastActionCollision = false,
  });

  LevelGameState copyWith({
    int? levelNumber,
    int? totalLevels,
    GameLevel? currentLevel,
    PuzzleState? puzzle,
    bool? isLastActionCollision,
  }) {
    return LevelGameState(
      levelNumber: levelNumber ?? this.levelNumber,
      totalLevels: totalLevels ?? this.totalLevels,
      currentLevel: currentLevel ?? this.currentLevel,
      puzzle: puzzle ?? this.puzzle,
      isLastActionCollision: isLastActionCollision ?? false,
    );
  }

  @override
  List<Object?> get props => [
        levelNumber, totalLevels, currentLevel,
        puzzle, isLastActionCollision,
      ];
}
```

#### ۲-ب) `lib/presentation/state/cubit/level_game_cubit.dart` را بازنویسی کن:

**منطق اصلی — تابع `extractArrow`:**
```dart
void extractArrow(String arrowId) {
  // 1. فلش را در remainingArrows پیدا کن
  // 2. مسیر حرکت را بررسی کن (از موقعیت فلش تا لبه گرید در جهت فلش)
  // 3. اگر فلش دیگری در مسیر است → تصادم: hearts-- و isLastActionCollision=true
  // 4. اگر مسیر خالی است → فلش را از remainingArrows حذف کن، به extractedArrowIds اضافه کن
  // 5. اگر remainingArrows خالی شد → status = won
  // 6. اگر hearts == 0 → status = lost
}
```

**بررسی مسیر (collision check):**
```dart
bool _isPathClear(Arrow arrow, List<Arrow> allArrows) {
  // بسته به جهت فلش، از موقعیت (row, col) تا لبه گرید حرکت کن
  // اگر ArrowDirection.up: row از arrow.row-1 تا 0 (همه row های بالاتر)
  // اگر ArrowDirection.down: row از arrow.row+1 تا gridRows-1
  // اگر ArrowDirection.left: col از arrow.col-1 تا 0
  // اگر ArrowDirection.right: col از arrow.col+1 تا gridCols-1
  // در هر سلول چک کن: آیا فلش دیگری در همان row/col وجود دارد؟
  // اگر بله → false (مسیر بسته)
  // اگر هیچ فلشی در مسیر نبود → true (مسیر باز)
}
```

**تابع undo:**
```dart
void undo() {
  // اگر extractedArrowIds خالی است → return
  // آخرین id را از extractedArrowIds بردار
  // فلش متناظر را در currentLevel.arrows پیدا کن
  // فلش را به remainingArrows برگردان
  // hintArrowId = null
}
```

**تابع reset:**
```dart
void resetLevel() {
  // تمام فلش‌های currentLevel.arrows را به remainingArrows برگردان
  // hearts = currentLevel.hearts
  // extractedArrowIds = []
  // status = playing
}
```

**تابع hint:**
```dart
void showHint() {
  // از بین remainingArrows، فلشی پیدا کن که _isPathClear آن true است
  // hintArrowId = id آن فلش
  // hintsUsed++
}
```

### گام ۳: داده‌ی مراحل

#### ۳-الف) `lib/data/levels/level_data.dart` را بازنویسی کن:

**ساختار هر مرحله:**
```dart
GameLevel(
  id: 1,
  gridRows: 3,
  gridCols: 3,
  hearts: 3,
  difficulty: 1,
  arrows: [
    Arrow(id: 'a1', row: 0, col: 0, direction: ArrowDirection.right),
    Arrow(id: 'a2', row: 1, col: 1, direction: ArrowDirection.down),
  ],
)
```

**قوانین طراحی مرحله:**
- هر مرحله باید **حداقل یک ترتیب extraction موفق** داشته باشد
- فلش‌ها نباید روی هم باشند (هر سلول حداکثر یک فلش)
- ترتیب extraction با حذف فلش‌هایی که مسیر بقیه را باز می‌کنند مشخص می‌شود

**تقسیم ۱۰۰ مرحله:**
- مراحل ۱-۲۰: گرید ۳×۳ تا ۴×۴، ۲-۴ فلش (آموزشی)
- مراحل ۲۱-۴۰: گرید ۴×۴ تا ۵×۵، ۴-۶ فلش (ساده)
- مراحل ۴۱-۶۰: گرید ۵×۵ تا ۶×۶، ۶-۹ فلش (متوسط)
- مراحل ۶۱-۸۰: گرید ۶×۶ تا ۷×۷، ۹-۱۲ فلش (سخت)
- مراحل ۸۱-۱۰۰: گرید ۷×۷ تا ۸×۸، ۱۲-۱۶ فلش (چالش)

### گام ۴: UI

#### ۴-الف) `lib/presentation/game/components/arrow_widget.dart` را بازنویسی کن:
- یک سلول گرید با فلش داخلش
- اگر فلش hint شده → رنگ مخصوص (مثلاً سبز)
- اگر فلش تصادم کرده → رنگ قرمز + لرزش
- اگر خالی → فقط پس‌زمینه

#### ۴-ب) `lib/presentation/game/components/grid_widget.dart` را بساز:
- یک `GridView.builder` یا `Table` با `gridRows` × `gridCols`
- هر سلول یا خالی است یا یک `ArrowWidget`
- روی هر فلش ضربه بزن → `cubit.extractArrow(arrowId)`

#### ۴-ج) `lib/presentation/game/components/hud_widget.dart` را بساز:
- سطر بالا: شماره مرحله + قلب‌ها (❤️❤️❤️)
- سطر پایین: دکمه Undo، دکمه Reset، دکمه Hint

#### ۴-د) `lib/presentation/game/puzzle_screen.dart` را بساز:
- `BlocProvider<LevelGameCubit>`
- `Column` شامل: `HudWidget` + `GridWidget` + پیام برد/باخت

### گام ۵: اتصال و routing

#### ۵-الف) `lib/main.dart` را به‌روزرسانی کن:
- مسیر `/` → `StartScreen`
- مسیر `/game` → `PuzzleScreen`

#### ۵-ب) `lib/core/di/injection_container.dart` را ساده کن:
- فقط `LevelGameCubit` را ثبت کن (اگر لازم است)

### گام ۶: حذف فایل‌های قدیمی
فایل‌های لیست‌شده در بخش ۲ (شماره ۱۵ تا ۲۹) را حذف کن.

### گام ۷: تست و اصلاح
- `flutter run` را اجرا کن
- مراحل اولیه را بازی کن
- باگ‌ها را رفع کن

---

## ۵) ترتیب اجرا

```
گام ۱ (مدل داده) → گام ۲ (منطق) → گام ۳ (مراحل) → گام ۴ (UI) → گام ۵ (اتصال) → گام ۶ (حذف) → گام ۷ (تست)
```

---

## ۶) معیار موفقیت

- [ ] روی فلش ضربه می‌زنیم → فلش در جهت خودش خارج می‌شود
- [ ] اگر مسیر بسته باشد → تصادم + قلب کم می‌شود
- [ ] ۳ قلب در هر مرحله
- [ ] دکمه Undo کار می‌کند
- [ ] دکمه Reset کار می‌کند
- [ ] دکمه Hint کار می‌کند
- [ ] ۱۰۰ مرحله با سختی تدریجی
- [ ] UI مینیمالیست و تمیز
