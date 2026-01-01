# dictionary_text

[![pub package](https://img.shields.io/pub/v/dictionary_text.svg)](https://pub.dev/packages/dictionary_text)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A beautiful, customizable Flutter widget that transforms any text into an interactive dictionary. Tap or hold any word to see definitions, pronunciations, and examples in a beautifully animated bottom sheet or dialog.

## Features

- **Instant Definitions** - Tap any word to see its dictionary definition
- **Audio Pronunciation** - Listen to word pronunciations
- **Highly Customizable** - Colors, styles, animations, and more
- **Responsive Design** - Adapts to mobile, tablet, and desktop
- **Smooth Animations** - iOS-quality spring animations
- **Multiple Display Modes** - Bottom sheet or dialog
- **Flexible Triggers** - Tap or long-press gestures
- **Tutorial Guide** - Built-in onboarding for users
- **Cross-Platform** - Android, iOS, Web, Windows, macOS, Linux

## Installation

Add `dictionary_text` to your `pubspec.yaml`:

```yaml
dependencies:
  dictionary_text: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

```dart
import 'package:dictionary_text/dictionary_text.dart';

// Basic usage
DictionaryText(
  text: 'Flutter',
)

// With customization
DictionaryText(
  text: 'beautiful',
  displayMode: DisplayMode.bottomSheet,
  triggerMode: TriggerMode.tap,
  selectedTextColor: Colors.blue,
)
```

## Configuration Options

### Display Mode

```dart
// Bottom sheet (default)
DictionaryText(
  text: 'word',
  displayMode: DisplayMode.bottomSheet,
)

// Centered dialog
DictionaryText(
  text: 'word',
  displayMode: DisplayMode.dialog,
)
```

### Trigger Mode

```dart
// Single tap (default)
DictionaryText(
  text: 'word',
  triggerMode: TriggerMode.tap,
)

// Long press
DictionaryText(
  text: 'word',
  triggerMode: TriggerMode.longPress,
)
```

### Styling

```dart
DictionaryText(
  text: 'word',
  backgroundColor: Colors.blue.shade50,
  selectedTextColor: Colors.blue,
  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  definitionStyle: TextStyle(fontSize: 16, height: 1.5),
)
```

### Custom Loading & Error Widgets

```dart
DictionaryText(
  text: 'word',
  loadingBuilder: (context) => MyCustomLoader(),
  errorBuilder: (context, error) => MyCustomError(error),
)
```

### Tutorial Guide

```dart
DictionaryText(
  text: 'word',
  needGuide: true,
  guideConfig: TutorialConfig(
    title: 'Dictionary Feature',
    description: 'Tap any word to see its definition!',
  ),
)
```

## API Reference

| Property               | Type          | Default       | Description                |
| ---------------------- | ------------- | ------------- | -------------------------- |
| `text`                 | `String`      | required      | The text to display        |
| `displayMode`          | `DisplayMode` | `bottomSheet` | How to display definitions |
| `triggerMode`          | `TriggerMode` | `tap`         | Gesture to trigger lookup  |
| `backgroundColor`      | `Color?`      | null          | Background color           |
| `selectedTextColor`    | `Color?`      | null          | Color when selected        |
| `textStyle`            | `TextStyle?`  | null          | Text style                 |
| `definitionStyle`      | `TextStyle?`  | null          | Definition text style      |
| `needGuide`            | `bool`        | `true`        | Show tutorial on first use |
| `animationDuration`    | `Duration`    | `300ms`       | Animation duration         |
| `enableHapticFeedback` | `bool`        | `true`        | Enable haptic feedback     |

## Platform Support

| Platform | Support |
| -------- | ------- |
| Android  | ✅      |
| iOS      | ✅      |
| Web      | ✅      |
| Windows  | ✅      |
| macOS    | ✅      |
| Linux    | ✅      |

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

Dictionary data provided by [Free Dictionary API](https://dictionaryapi.dev/)
