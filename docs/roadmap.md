# 🧭 نقشه راه طراحی نسخه‌ی ۵۰ مرحله‌ای

این فایل نقشه‌ی راه اولیه برای تبدیل بازی فعلی به نسخه‌ای شبیه به بازی مرجع است. هدف فعلی، ساخت یک پایه‌ی سالم و قابل گسترش برای ۵۰ مرحله است، نه منتشر کردن نسخه‌ی نهایی.

---

## 1) هدف کوتاه‌مدت
- ساخت یک نسخه‌ی مرحله‌ای و قابل‌پیشرفت
- حفظ منطق اصلی بازی مشابه نسخه‌ی مرجع
- تمرکز بر ۵۰ مرحله‌ی اول به‌جای امکانات پیچیده
- طراحی ساختار قابل توسعه برای مراحل سخت‌تر در آینده

---

## 2) وضعیت فعلی و نکته‌ی اصلی
نسخه‌ی کنونی بیشتر روی «فلش‌های تصادفی و پاسخ سریع» است. برای نزدیک شدن به حس بازی مرجع، باید به سمت این ساختار برویم:
- مرحله‌محور بودن
- قوانین مشخص برای هر مرحله
- رشد تدریجی سختی
- حس حل مسئله و پیشرفت

---

## 3) نقشه‌ی اجرایی پیشنهادی

### فاز 1 — پایه‌ی بازی و داده‌ی مراحل
- [ ] ایجاد مدل مرحله (level data)
- [ ] تعریف ساختار داده برای ۵۰ مرحله
- [ ] طراحی state برای: شروع، بازی، پایان مرحله، بازی تمام‌شده
- [ ] جدا کردن منطق بازی از UI

### فاز 2 — موتور اصلی بازی
- [ ] حذف منطق «spawn بی‌نهایت تصادفی» به‌جای آن
- [ ] پیاده‌سازی چرخه‌ی مرحله‌ای
- [ ] اضافه‌کردن امتیاز، جان، و وضعیت موفقیت/شکست
- [ ] طراحی سیستم «پاسخ صحیح / پاسخ غلط» برای هر مرحله

### فاز 3 — طراحی ۵۰ مرحله
- [ ] بلوک 1: مراحل 1 تا 10 (آموزشی و ساده)
- [ ] بلوک 2: مراحل 11 تا 20 (ساده‌تر از متوسط)
- [ ] بلوک 3: مراحل 21 تا 30 (متوسط)
- [ ] بلوک 4: مراحل 31 تا 40 (سخت‌تر)
- [ ] بلوک 5: مراحل 41 تا 50 (چالش‌برانگیز)

### فاز 4 — تجربه‌ی کاربری
- [ ] صفحه‌ی شروع با دکمه‌ی شروع
- [ ] صفحه‌ی مرحله و HUD واضح
- [ ] صفحه‌ی موفقیت و بازی‌تمام‌شده
- [ ] انیمیشن‌های ساده برای ورود/پاسخ صحیح/اشتباه

### فاز 5 — تست و polish
- [ ] تست ۵۰ مرحله برای اطمینان از جریان درست
- [ ] تنظیم سختی و تعادل
- [ ] رفع باگ‌های UI و منطق
- [ ] آماده‌سازی برای توسعه‌ی مراحل بعدی

---

## 4) پیشنهاد تقسیم‌بندی ۵۰ مرحله

### بلوک آموزش: مراحل 1 تا 10
- تمرکز روی آشنایی با چهار جهت
- مراحل کوتاه و قابل‌فهم
- تعداد فلش کم
- خطای کم

### بلوک ساده: مراحل 11 تا 20
- کمی افزایش تعداد فلش‌ها
- شروع الگوهای کوتاه
- نیاز به تمرکز بیشتر

### بلوک متوسط: مراحل 21 تا 30
- افزایش طول مسیر
- نیاز به برنامه‌ریزی و پیش‌بینی
- اضافه‌شدن حس فشار منطقی

### بلوک سخت: مراحل 31 تا 40
- الگوهای ترکیبی و تکراری
- خطاها تاثیر بیشتری دارند
- افزایش پیچیدگی در تصمیم‌گیری

### بلوک چالش: مراحل 41 تا 50
- طراحی برای بازیکن جدی
- حالت‌های طولانی‌تر و سخت‌تر
- آماده‌سازی برای گسترش به مرحله‌های بالاتر

---

## 5) معیار موفقیت برای شروع
نسخه‌ی فعلی را به‌عنوان موفق می‌دانیم اگر این‌ها برقرار باشند:
- بازی از روی داده‌ی مرحله اجرا شود
- ۱۰ مرحله‌ی اول روان و بدون خطا کار کنند
- UI برای شروع و پایان مرحله قابل فهم باشد
- منطق پاسخ صحیح/اشتباه درست عمل کند

---

## 6) پیشنهاد اجرای عملی
1. اول منطق مرحله‌محور را پیاده کنید
2. سپس ۱۰ مرحله‌ی ابتدایی بسازید
3. بعد UI و مسیر پیشروی بازی را کامل کنید
4. در نهایت ۵۰ مرحله را به‌صورت تدریجی وارد کنید

این مسیر کم‌ریسک‌تر است و پایه‌ای قوی برای توسعه‌ی بعدی فراهم می‌کند.

---

## Phase 1: Core Gameplay & Foundation (MVP) (ETA: 2 Weeks)

The goal of this phase is to build a stable and complete Minimum Viable Product with all the essential features.

- [x] **Basic Arrow Spawning:** Arrows appear on screen.
- [x] **Player Input (Swiping):** Detect swipe gestures.
- [x] **Scoring and Lives System:** Basic implementation of score and lives.
- **To-Do:**
    - [ ] **Refine Arrow Logic:**
        - **Task:** Implement a time-based difficulty scaling system. The speed and frequency of arrows should increase as the game progresses.
        - **Task:** Ensure arrows spawn randomly from all four edges of the screen (top, bottom, left, right).
    - [ ] **Bug Fixing:**
        - **Task:** **Critical:** Debug and fix the swipe detection logic to ensure it accurately registers the direction of the swipe and matches it with the corresponding arrow.
        - **Task:** Add detailed logging for swipe events, arrow spawning, and game state changes to facilitate easier debugging.
    - [ ] **Game State Management:**
        - **Task:** Implement a finite state machine to manage game states (`MainMenu`, `Playing`, `Paused`, `GameOver`).
        - **Task:** Create a `GameOver` screen that displays the final score, high score, and options to "Restart" or go back to the "Main Menu".
    - [ ] **UI/UX Basics:**
        - **Task:** Design and implement a main menu with a "Start Game" button and a display for the high score.
        - **Task:** Create a simple and clear in-game UI to display the current score and remaining lives.

---

## Phase 2: Visual & Audio Polish (ETA: 3 Weeks)

This phase focuses on improving the user experience with better visuals, animations, and sound.

- **To-Do:**
    - [ ] **Minimalist UI/UX Design:**
        - **Task:** Design a clean and modern UI/UX for the entire game, including menus, in-game HUD, and game over screen.
        - **Task:** Choose a vibrant and visually appealing color palette.
        - **Task:** Select a clean and readable font for all text elements.
    - [ ] **Animations:**
        - **Task:** Animate the spawning of arrows to make them appear smoothly on the screen.
        - **Task:** Create a satisfying animation for when an arrow is correctly swiped (e.g., it scales up, fades out, and particles burst from it).
        - **Task:** Implement a "shake" or "wobble" animation for when the player makes an incorrect swipe.
        - **Task:** Add a subtle background animation to make the game feel more dynamic.
    - [ ] **Sound Design:**
        - **Task:** Add sound effects for correct and incorrect swipes.
        - **Task:** Implement a sound effect for when the game is over.
        - **Task:** Compose or source a catchy and non-intrusive background music loop.

---

## Phase 3: Advanced Gameplay & Game Modes (ETA: 4 Weeks)

Introduce variety and replayability with new features and modes.

- **To-Do:**
    - [ ] **Game Modes:**
        - **Task:** Implement a "Classic" game mode with gradually increasing difficulty.
        - **Task:** Implement a "Rush" mode where arrows appear at an increasingly fast pace.
        - **Task:** Implement a "Time Attack" mode where the player has to score as many points as possible in a limited time.
    - [ ] **Special Arrows:**
        - **Task:** Design and implement multi-directional arrows that require multiple swipes in different directions.
        - **Task:** Design and implement "bomb" arrows that clear all other arrows on the screen when swiped correctly.
        - **Task:** Design and implement "reverse" arrows that require a swipe in the opposite direction of the arrow.
        - **Task:** Design and implement "color-coded" arrows that can only be cleared by a swipe of the corresponding color.

---

## Phase 4: Services & Monetization (ETA: 2 Weeks)

Integrate platform services for a competitive and social experience, and explore monetization strategies.

- **To-Do:**
    - [ ] **Platform Integration:**
        - **Task:** Integrate Google Play Games Services on Android.
        - **Task:** Integrate Game Center on iOS.
    - [ ] **Leaderboards:**
        - **Task:** Implement a global leaderboard for each game mode.
    - [ ] **Achievements:**
        - **Task:** Create and implement a set of achievements for players to unlock.
    - [ ] **Monetization:**
        - **Task:** Implement an in-app purchase to remove ads.
        - **Task:** Integrate an ad network to display interstitial ads between games.

---

## Phase 5: Final Touches & Release (ETA: 1 Week)

Prepare the game for public release.

- **To-Do:**
    - [ ] **Testing:**
        - **Task:** Perform extensive testing on a wide range of devices to identify and fix bugs.
        - **Task:** Get feedback from a group of beta testers.
    - [ ] **Optimization:**
        - **Task:** Profile the game's performance and optimize any bottlenecks.
        - **Task:** Reduce the game's memory footprint and battery consumption.
    - [ ] **Store Presence:**
        - **Task:** Create high-quality screenshots and a promotional video for the app stores.
        - **Task:** Write a compelling app description and release notes.
        - **Task:** Design a professional-looking app icon.
    - [ ] **Submission:**
        - **Task:** Submit the game to the Google Play Store and Apple App Store for review.
