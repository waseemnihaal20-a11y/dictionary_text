# dictionary_text

[![pub package](https://img.shields.io/pub/v/dictionary_text.svg)](https://pub.dev/packages/dictionary_text)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A beautiful, customizable Flutter widget that transforms any text into an interactive dictionary. Tap or hold any word to see definitions, pronunciations, and examples in a beautifully animated bottom sheet or dialog.

## Preview

![Screenshot](https://uihelncxdoxavatnjnkv.supabase.co/storage/v1/object/sign/test-bucket/Screenshot_1767297722.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV8xYjhhYzQ2My01ZDNlLTQzNzktODNkMi1mMDNiMWQ4M2I3Y2MiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJ0ZXN0LWJ1Y2tldC9TY3JlZW5zaG90XzE3NjcyOTc3MjIucG5nIiwiaWF0IjoxNzY3MzQ2MjY0LCJleHAiOjE5MjUwMjYyNjR9.DWPO68hjEBCPOE86hXIyoGjFDgBaHSH1ViS-vPwCk20)

![Demo](https://uihelncxdoxavatnjnkv.supabase.co/storage/v1/object/sign/test-bucket/dictionary_text_package_demo.gif?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV8xYjhhYzQ2My01ZDNlLTQzNzktODNkMi1mMDNiMWQ4M2I3Y2MiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJ0ZXN0LWJ1Y2tldC9kaWN0aW9uYXJ5X3RleHRfcGFja2FnZV9kZW1vLmdpZiIsImlhdCI6MTc2NzM0NzQxNCwiZXhwIjoxOTI1MDI3NDE0fQ.veRfuPB6LsMfhZ_tHMkf25riA9s8qgzSQ-6PQVN_ZHI)

## Author

**Abdul Waseem Nihaal**

- Email: waseemnihaal20@gmail.com
- GitHub: https://github.com/waseemnihaal20-a11y

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

// Basic usage - works like Text widget
DictionaryText('Flutter is amazing')

// With customization
DictionaryText(
  'beautiful',
  displayMode: DisplayMode.bottomSheet,
  triggerMode: TriggerMode.tap,
  selectedWordColor: Colors.blue,
)
```

## Configuration Options

### Display Mode

```dart
// Bottom sheet (default)
DictionaryText(
  'word',
  displayMode: DisplayMode.bottomSheet,
)

// Centered dialog
DictionaryText(
  'word',
  displayMode: DisplayMode.dialog,
)
```

### Trigger Mode

```dart
// Single tap (default)
DictionaryText(
  'word',
  triggerMode: TriggerMode.tap,
)

// Long press
DictionaryText(
  'word',
  triggerMode: TriggerMode.longPress,
)
```

### Styling

```dart
DictionaryText(
  'word',
  backgroundColor: Colors.blue.shade50,
  selectedWordColor: Colors.blue,
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  definitionStyle: TextStyle(fontSize: 16, height: 1.5),
)
```

### Custom Loading & Error Widgets

```dart
DictionaryText(
  'word',
  loadingBuilder: (context) => MyCustomLoader(),
  errorBuilder: (context, error) => MyCustomError(error),
)
```

### Tutorial Guide

```dart
DictionaryText(
  'word',
  needGuide: true,
  guideConfig: TutorialConfig(
    title: 'Dictionary Feature',
    description: 'Tap any word to see its definition!',
  ),
)
```

## Using DictionaryService Directly

```dart
final service = DictionaryService();
final definition = await service.getDefinition('flutter');
print(definition.word); // 'flutter'
print(definition.meanings.first.partOfSpeech); // 'verb'
```

## API Reference

| Property               | Type           | Default               | Description                  |
| ---------------------- | -------------- | --------------------- | ---------------------------- |
| `data`                 | `String`       | required (positional) | The text to display          |
| `style`                | `TextStyle?`   | null                  | Text style                   |
| `displayMode`          | `DisplayMode`  | `bottomSheet`         | How to display definitions   |
| `triggerMode`          | `TriggerMode`  | `tap`                 | Gesture to trigger lookup    |
| `backgroundColor`      | `Color?`       | null                  | Background color for display |
| `selectedWordColor`    | `Color?`       | null                  | Color for selected word      |
| `definitionStyle`      | `TextStyle?`   | null                  | Definition text style        |
| `needGuide`            | `bool`         | `true`                | Show tutorial on first use   |
| `enableHapticFeedback` | `bool`         | `true`                | Enable haptic feedback       |
| `maxLines`             | `int?`         | null                  | Maximum number of lines      |
| `overflow`             | `TextOverflow` | `clip`                | Text overflow behavior       |
| `textAlign`            | `TextAlign`    | `start`               | Text alignment               |

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
