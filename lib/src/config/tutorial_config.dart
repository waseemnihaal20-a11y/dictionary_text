import 'package:flutter/material.dart';

/// Configuration for the tutorial guide overlay.
///
/// Customize the appearance and content of the tutorial
/// that shows users how to use the dictionary feature.
class TutorialConfig {
  /// Creates a [TutorialConfig] instance with default values.
  const TutorialConfig({
    this.title,
    this.description,
    this.tooltipColor,
    this.titleStyle,
    this.descriptionStyle,
    this.paddingEdge = 10.0,
    this.radius = 8.0,
    this.skipText = 'SKIP',
    this.nextText = 'NEXT',
    this.finishText = 'GOT IT',
  });

  /// Title of the tutorial tooltip.
  ///
  /// Defaults to "Dictionary Feature" if not specified.
  final String? title;

  /// Description shown in the tutorial tooltip.
  ///
  /// Auto-generated based on [TriggerMode] if not specified.
  /// Example: "Didn't understand any word? No worries. Tap any word
  /// to get its detailed dictionary!"
  final String? description;

  /// Background color of the tooltip.
  ///
  /// Defaults to the theme's primary color if not specified.
  final Color? tooltipColor;

  /// Text style for the title.
  final TextStyle? titleStyle;

  /// Text style for the description.
  final TextStyle? descriptionStyle;

  /// Padding around the highlighted area.
  ///
  /// Defaults to 10.0.
  final double paddingEdge;

  /// Border radius of the highlighted area.
  ///
  /// Defaults to 8.0.
  final double radius;

  /// Text for the skip button.
  ///
  /// Defaults to "SKIP".
  final String skipText;

  /// Text for the next button.
  ///
  /// Defaults to "NEXT".
  final String nextText;

  /// Text for the finish button.
  ///
  /// Defaults to "GOT IT".
  final String finishText;

  /// Creates a copy of this config with the given fields replaced.
  TutorialConfig copyWith({
    String? title,
    String? description,
    Color? tooltipColor,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    double? paddingEdge,
    double? radius,
    String? skipText,
    String? nextText,
    String? finishText,
  }) {
    return TutorialConfig(
      title: title ?? this.title,
      description: description ?? this.description,
      tooltipColor: tooltipColor ?? this.tooltipColor,
      titleStyle: titleStyle ?? this.titleStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      paddingEdge: paddingEdge ?? this.paddingEdge,
      radius: radius ?? this.radius,
      skipText: skipText ?? this.skipText,
      nextText: nextText ?? this.nextText,
      finishText: finishText ?? this.finishText,
    );
  }
}
