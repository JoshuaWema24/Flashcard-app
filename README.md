# ⚡ Flashcard Quiz App

A vibrant, animated flashcard study app built with Flutter. Features a bold yellow & green theme, smooth 3D card flip animations, and full card management with persistent storage.

---

## Screenshots

| Quiz Screen | Manage Cards | Add / Edit Card |
|---|---|---|
| Yellow card face (question) | Numbered card list | Form with validation |
| Green card face (answer) | Edit & delete actions | Saves on submit |

---

## Features

- **Flip animation** — Tap the card or press "Show Answer" to reveal the answer with a smooth 3D flip
- **Navigate cards** — Previous / Next buttons to move through your deck
- **Progress bar** — Shows your position in the deck at a glance
- **Add cards** — Create new flashcards with a question and answer
- **Edit cards** — Update any existing card at any time
- **Delete cards** — Remove cards with a confirmation dialog
- **Persistent storage** — Cards are saved locally and survive app restarts
- **Starter deck** — 5 default cards preloaded so you can start immediately

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| Language | Dart 3.x |
| Storage | `shared_preferences` ^2.2.2 |
| State | `setState` (no external state manager) |

---

## Project Structure

```
flashcard_app/
├── pubspec.yaml
└── lib/
    ├── main.dart                        # App entry point
    ├── app.dart                         # MaterialApp + theme
    ├── models/
    │   └── flashcard.dart               # Flashcard data model
    ├── services/
    │   └── flashcard_service.dart       # Load/save via SharedPreferences
    ├── screens/
    │   ├── home_screen.dart             # Main quiz screen
    │   ├── manage_screen.dart           # Card list (edit/delete)
    │   └── card_form_screen.dart        # Add / edit form
    └── widgets/
        └── flashcard_widget.dart        # Animated flip card widget
```

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0` — [Install Flutter](https://docs.flutter.dev/get-started/install)
- Dart SDK `>=3.0.0` (bundled with Flutter)
- A connected device or emulator

### Installation

```bash
# 1. Unzip the project
unzip flashcard_app.zip
cd flashcard_app

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Build for release

```bash
# Android APK
flutter build apk --release

# iOS (macOS only)
flutter build ios --release

# Web
flutter build web --release
```

---

## Theme Colors

| Role | Color | Hex |
|---|---|---|
| Primary / Question face | Vibrant Yellow | `#FFD600` |
| Secondary / Answer face | Vibrant Green | `#00C853` |
| Background | Off-white | `#F5F5F5` |
| Delete action | Red | `#E53935` |

---

## How to Use

1. **Study** — On the home screen, read the question on the yellow card
2. **Reveal** — Tap the card or press **Show Answer** to flip to the green answer face
3. **Navigate** — Use **Previous** / **Next** to move between cards
4. **Manage** — Tap the ✏️ icon in the top-right to open the Manage Cards screen
5. **Add** — Press **+ New Card**, fill in the question and answer, tap **Add Card**
6. **Edit** — Tap the green edit icon next to any card
7. **Delete** — Tap the red delete icon and confirm

---

## Customisation

### Change theme colors
Edit `lib/app.dart` — update the `ColorScheme`:
```dart
primary: const Color(0xFFFFD600),   // yellow
secondary: const Color(0xFF00C853), // green
```

### Change flip animation speed
Edit `lib/widgets/flashcard_widget.dart`:
```dart
duration: const Duration(milliseconds: 420), // increase to slow down
```

### Change auto-loaded default cards
Edit `lib/services/flashcard_service.dart` in the `_defaults()` method.

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2
```

Install with:
```bash
flutter pub get
```

---

## License

MIT — free to use, modify, and distribute.