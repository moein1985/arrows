# 🧭 نقشه راه پروژه — Arrows: Puzzle Escape

> **بازی مرجع:** [Arrows – Puzzle Escape](https://play.google.com/store/apps/details?id=com.ecffri.arrows)
> **هدف:** بازسازی دقیق مکانیک بازی با ۱۰۰ مرحله دست‌ساز + انیمیشن اسلاید
> **روش:** ساده، گام‌به‌گام، قابل پیاده‌سازی توسط مدل‌های کوچک

---

## ۱) مکانیک دقیق بازی (از تحقیق مرجع)

### قاعده بازی:
1. **گرید ۲بعدی** با سلول‌های خالی و بلوک‌های فلش‌دار (Up/Down/Left/Right)
2. **تپ کردن** روی فلش → بلوک **نرم و پیوسته** در جهت فلش **اسلاید** می‌شود و از گرید خارج می‌گردد
3. **تصادم:** اگر بلوک در مسیر خود به بلوک دیگری برخورد کند → حرکت نامعتبر است، قلب کم می‌شود
4. **هدف:** همه بلوک‌ها با ترتیب درست تپ شوند تا گرید کاملاً خالی شود
5. **بدون تایمر** — بازی آرام و منطقی است

### ویژگی‌ها:
- ۳ قلب در هر مرحله (در مراحل سخت‌تر ۲ قلب)
- **Undo**: برگرداندن آخرین حرکت
- **Reset**: شروع مجدد مرحله
- **Hint**: نشان دادن یک فلش با مسیر باز

---

## ۲) وضعیت فعلی پروژه

### کارهای انجام‌شده ✅
- [x] Entity ها: `arrow.dart`, `level.dart`, `puzzle_state.dart`
- [x] Cubit و State: `level_game_cubit.dart`, `level_game_state.dart`
- [x] ۱۰۰ مرحله دست‌ساز در `level_data.dart`
- [x] UI پایه: `arrow_widget.dart`, `grid_widget.dart`, `hud_widget.dart`, `puzzle_screen.dart`
- [x] Routing و DI
- [x] حذف فایل‌های قدیمی (Arcade + Sequence)
- [x] `flutter analyze` — بدون خطا
- [x] `flutter test` — ۵ تست پاس

### کارهای باقی‌مانده ❌ (فاز انیمیشن)
- [ ] اضافه کردن `BlockState` به مدل داده
- [ ] بازنویسی Cubit برای پشتیبانی از حالت `moving` و `collided`
- [ ] بازنویسی UI با `Stack` + `AnimatedPositioned` برای انیمیشن اسلاید
- [ ] انیمیشن برخورد (حرکت تا نقطه تصادم، سپس بازگشت)
- [ ] انیمیشن خروج (حرکت تا خارج از گرید، سپس حذف)
- [ ] غیرفعال کردن تپ هنگام انیمیشن
- [ ] تست بصری و اصلاح

---

## ۳) فاز جدید: انیمیشن و حالت‌های بلوک

### ۳-الف) تغییرات مدل داده

#### `arrow.dart` — اضافه شدن `BlockState`:
```dart
enum BlockState { idle, moving, exited, collided }

class Arrow extends Equatable {
  final String id;
  final int row;
  final int col;
  final ArrowDirection direction;
  final BlockState state;        // NEW: حالت فعلی بلوک

  const Arrow({
    required this.id,
    required this.row,
    required this.col,
    required this.direction,
    this.state = BlockState.idle,
  });

  Arrow copyWith({BlockState? state}) {
    return Arrow(
      id: id, row: row, col: col,
      direction: direction,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [id, row, col, direction, state];
}
```

#### `puzzle_state.dart` — اضافه شدن `collidedArrowId`:
```dart
class PuzzleState extends Equatable {
  // ... فیلدهای قبلی ...
  final String? collidedArrowId;    // NEW: فلشی که الان در حال تصادم است
  final bool isAnimating;           // NEW: آیا انیمیشنی در حال اجراست؟
}
```

### ۳-ب) تغییرات Cubit

#### `level_game_cubit.dart` — منطق جدید `extractArrow`:
```dart
void extractArrow(String arrowId) {
  if (state.puzzle.isAnimating) return;     // تپ هنگام انیمیشن نادیده گرفته شود

  final arrow = findArrow(arrowId);
  if (arrow == null) return;

  if (_isPathClear(arrow, remainingArrows)) {
    // مسیر باز → فلش را moving کن
    // UI انیمیشن اسلاید را اجرا می‌کند
    // پس از پایان انیمیشن، onSlideComplete صدا زده می‌شود
    emit(state.copyWith(
      puzzle: puzzle.copyWith(
        remainingArrows: updateArrowState(arrow, BlockState.moving),
        isAnimating: true,
      ),
    ));
  } else {
    // مسیر بسته → فلش را collided کن
    // UI انیمیشن برخورد را اجرا می‌کند (حرکت تا نقطه تصادم + بازگشت)
    // پس از پایان انیمیشن، onCollisionComplete صدا زده می‌شود
    emit(state.copyWith(
      puzzle: puzzle.copyWith(
        remainingArrows: updateArrowState(arrow, BlockState.collided),
        hearts: puzzle.hearts - 1,
        collidedArrowId: arrowId,
        isAnimating: true,
      ),
      isLastActionCollision: true,
    ));
  }
}

void onSlideComplete(String arrowId) {
  // فلش از remainingArrows حذف شود
  // به extractedArrowIds اضافه شود
  // isAnimating = false
  // اگر remainingArrows خالی شد → won
}

void onCollisionComplete(String arrowId) {
  // state فلش به idle برگردد
  // collidedArrowId = null
  // isAnimating = false
  // اگر hearts == 0 → lost
}
```

### ۳-ج) تغییرات UI — `Stack` + `AnimatedPositioned`

#### `grid_widget.dart` — بازنویسی با Stack:
```dart
Stack(
  children: [
    // لایه پس‌زمینه: گرید سلول‌های خالی
    _buildEmptyGrid(),

    // لایه فلش‌ها: هر فلش یک AnimatedPositioned
    for (final arrow in puzzle.remainingArrows)
      AnimatedPositioned(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeOut,
        left: _calcOffsetX(arrow, gridSize),
        top: _calcOffsetY(arrow, gridSize),
        child: ArrowWidget(
          arrow: arrow,
          isHint: arrow.id == puzzle.hintArrowId,
          isCollided: arrow.state == BlockState.collided,
          onTap: arrow.state == BlockState.idle && !puzzle.isAnimating
              ? () => onArrowTap(arrow.id)
              : null,
        ),
      ),
  ],
)
```

#### منطق offset برای اسلاید:
- وقتی `state == BlockState.moving`:
  - `up` → `top` به `-cellSize` (بالای گرید)
  - `down` → `top` به `gridHeight` (پایین گرید)
  - `left` → `left` به `-cellSize` (چپ گرید)
  - `right` → `left` به `gridWidth` (راست گرید)
- وقتی `state == BlockState.collided`:
  - حرکت تا نقطه تصادف، سپس بازگشت به موقعیت اولیه
  - می‌توان با `AnimatedPositioned` + `onEnd` callback این کار را کرد

#### `arrow_widget.dart` — تغییرات:
- وقتی `state == moving` → opacity کاهشی یا بدون تغییر (فقط حرکت)
- وقتی `state == collided` → رنگ قرمز + لرزش کوتاه
- وقتی `state == idle` → حالت عادی + قابل تپ

### ۳-د) `puzzle_screen.dart` — اتصال callback ها:
```dart
GridWidget(
  level: state.currentLevel,
  puzzle: puzzle,
  onArrowTap: cubit.extractArrow,
  onSlideComplete: cubit.onSlideComplete,       // NEW
  onCollisionComplete: cubit.onCollisionComplete, // NEW
)
```

---

## ۴) گام‌های اجرایی فاز انیمیشن

### گام ۸: به‌روزرسانی Entity ها
- [ ] اضافه کردن `BlockState` enum به `arrow.dart`
- [ ] اضافه کردن `state` به `Arrow` + `copyWith`
- [ ] اضافه کردن `collidedArrowId` و `isAnimating` به `puzzle_state.dart`

### گام ۹: به‌روزرسانی Cubit
- [ ] بازنویسی `extractArrow` برای set کردن `moving` / `collided`
- [ ] اضافه کردن `onSlideComplete(arrowId)`
- [ ] اضافه کردن `onCollisionComplete(arrowId)`
- [ ] غیرفعال کردن تپ هنگام `isAnimating`
- [ ] به‌روزرسانی `undo` برای پشتیبانی از حالت‌های جدید
- [ ] به‌روزرسانی `resetLevel` برای reset کردن `BlockState` ها

### گام ۱۰: بازنویسی UI با Stack
- [ ] بازنویسی `grid_widget.dart` با `Stack` + `AnimatedPositioned`
- [ ] محاسبه offset برای هر جهت
- [ ] callback های `onSlideComplete` و `onCollisionComplete`
- [ ] به‌روزرسانی `arrow_widget.dart` برای حالت‌های `moving` / `collided`
- [ ] به‌روزرسانی `puzzle_screen.dart` برای اتصال callback ها

### گام ۱۱: تست و اصلاح
- [ ] `flutter analyze` بدون خطا
- [ ] `flutter test` پاس
- [ ] تست بصری: اسلاید نرم، برخورد با بازگشت
- [ ] تست Undo بعد از انیمیشن
- [ ] تست Reset
- [ ] تست Hint

---

## ۵) ترتیب اجرا

```
فاز ۱ (تکمیل‌شده):
  گام ۱ → ۲ → ۳ → ۴ → ۵ → ۶ → ۷

فاز ۲ (انیمیشن):
  گام ۸ (Entity) → گام ۹ (Cubit) → گام ۱۰ (UI Stack) → گام ۱۱ (تست)
```

---

## ۶) معیار موفقیت نهایی

- [ ] روی فلش تپ می‌زنیم → فلش **نرم و پیوسته** در جهت خودش اسلاید می‌شود
- [ ] فلش تا **خارج از گرید** حرکت می‌کند و ناپدید می‌شود
- [ ] اگر مسیر بسته باشد → فلش تا نقطه تصادم حرکت می‌کند، سپس **برمی‌گردد**
- [ ] هنگام انیمیشن، تپ‌های دیگر **نادیده** گرفته می‌شوند
- [ ] ۳ قلب در هر مرحله (۲ قلب در مراحل سخت)
- [ ] دکمه Undo کار می‌کند
- [ ] دکمه Reset کار می‌کند
- [ ] دکمه Hint کار می‌کند
- [ ] ۱۰۰ مرحله با سختی تدریجی
- [ ] UI مینیمالیست و تمیز
- [ ] `flutter analyze` بدون خطا
- [ ] `flutter test` پاس
