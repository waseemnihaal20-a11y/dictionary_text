import 'package:flutter/material.dart';

import '../enums/display_mode.dart';
import '../enums/trigger_mode.dart';

/// Configuration for the [DictionaryText] widget appearance and behavior.
///
/// Use this class to customize how the dictionary widget looks and behaves.
class DictionaryConfig {
  /// Creates a [DictionaryConfig] instance with default values.
  const DictionaryConfig({
    this.displayMode = DisplayMode.bottomSheet,
    this.triggerMode = TriggerMode.tap,
    this.backgroundColor,
    this.selectedTextColor,
    this.textStyle,
    this.definitionStyle,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
    this.enableHapticFeedback = true,
  });

  /// How to display the dictionary definition.
  ///
  /// Defaults to [DisplayMode.bottomSheet].
  final DisplayMode displayMode;

  /// The gesture that triggers the dictionary lookup.
  ///
  /// Defaults to [TriggerMode.tap].
  final TriggerMode triggerMode;

  /// Background color for the dictionary display.
  ///
  /// Text color is automatically calculated based on luminosity.
  final Color? backgroundColor;

  /// Color of the text when it is selected/tapped.
  ///
  /// Defaults to the theme's primary color if not specified.
  final Color? selectedTextColor;

  /// Style for the main text widget.
  final TextStyle? textStyle;

  /// Style for the definition text.
  final TextStyle? definitionStyle;

  /// Duration of animations.
  ///
  /// Defaults to 300 milliseconds.
  final Duration animationDuration;

  /// Curve used for animations.
  ///
  /// Defaults to [Curves.easeOutCubic].
  final Curve animationCurve;

  /// Whether to provide haptic feedback on tap.
  ///
  /// Defaults to `true`.
  final bool enableHapticFeedback;

  /// Creates a copy of this config with the given fields replaced.
  DictionaryConfig copyWith({
    DisplayMode? displayMode,
    TriggerMode? triggerMode,
    Color? backgroundColor,
    Color? selectedTextColor,
    TextStyle? textStyle,
    TextStyle? definitionStyle,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? enableHapticFeedback,
  }) {
    return DictionaryConfig(
      displayMode: displayMode ?? this.displayMode,
      triggerMode: triggerMode ?? this.triggerMode,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      selectedTextColor: selectedTextColor ?? this.selectedTextColor,
      textStyle: textStyle ?? this.textStyle,
      definitionStyle: definitionStyle ?? this.definitionStyle,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
    );
  }
}
