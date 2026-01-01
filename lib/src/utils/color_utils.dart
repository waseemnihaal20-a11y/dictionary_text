import 'package:flutter/material.dart';

/// Utility class for color-related calculations.
///
/// Provides methods for determining color luminosity and
/// calculating contrasting text colors.
class ColorUtils {
  ColorUtils._();

  /// Returns true if the color is considered "dark".
  ///
  /// Uses the relative luminance formula:
  /// `(0.299 * R + 0.587 * G + 0.114 * B)`
  ///
  /// Example:
  /// ```dart
  /// ColorUtils.isDark(Colors.black); // true
  /// ColorUtils.isDark(Colors.white); // false
  /// ```
  static bool isDark(Color color) {
    final luminance = 0.299 * color.r + 0.587 * color.g + 0.114 * color.b;
    return luminance < 0.5;
  }

  /// Returns white or black text color based on background luminosity.
  ///
  /// Returns [Colors.white] for dark backgrounds and [Colors.black]
  /// for light backgrounds to ensure readable contrast.
  ///
  /// Example:
  /// ```dart
  /// final textColor = ColorUtils.getContrastingTextColor(Colors.blue);
  /// // Returns Colors.white for dark blue
  /// ```
  static Color getContrastingTextColor(Color backgroundColor) {
    return isDark(backgroundColor) ? Colors.white : Colors.black;
  }

  /// Returns a color with adjusted opacity.
  ///
  /// [color] is the base color.
  /// [opacity] is the opacity value between 0.0 and 1.0.
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Lightens a color by the given [amount].
  ///
  /// [amount] should be between 0.0 and 1.0.
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Darkens a color by the given [amount].
  ///
  /// [amount] should be between 0.0 and 1.0.
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}
