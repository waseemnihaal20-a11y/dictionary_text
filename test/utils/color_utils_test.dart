import 'package:dictionary_text/dictionary_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ColorUtils', () {
    group('isDark', () {
      test('should return true for black', () {
        expect(ColorUtils.isDark(Colors.black), isTrue);
      });

      test('should return false for white', () {
        expect(ColorUtils.isDark(Colors.white), isFalse);
      });

      test('should return true for dark gray', () {
        expect(ColorUtils.isDark(const Color(0xFF1A1A1A)), isTrue);
      });

      test('should return false for light gray', () {
        expect(ColorUtils.isDark(const Color(0xFFF0F0F0)), isFalse);
      });

      test('should return true for dark blue', () {
        expect(ColorUtils.isDark(const Color(0xFF0D47A1)), isTrue);
      });

      test('should return false for light yellow', () {
        expect(ColorUtils.isDark(const Color(0xFFFFF59D)), isFalse);
      });

      test('should handle mid-range colors', () {
        final result = ColorUtils.isDark(Colors.grey);
        expect(result, isA<bool>());
      });
    });

    group('getContrastingTextColor', () {
      test('should return white for black background', () {
        final textColor = ColorUtils.getContrastingTextColor(Colors.black);
        expect(textColor, Colors.white);
      });

      test('should return black for white background', () {
        final textColor = ColorUtils.getContrastingTextColor(Colors.white);
        expect(textColor, Colors.black);
      });

      test('should return white for dark blue background', () {
        final textColor = ColorUtils.getContrastingTextColor(
          const Color(0xFF0D47A1),
        );
        expect(textColor, Colors.white);
      });

      test('should return black for light yellow background', () {
        final textColor = ColorUtils.getContrastingTextColor(
          const Color(0xFFFFF59D),
        );
        expect(textColor, Colors.black);
      });

      test('should return a valid color for any input', () {
        final textColor = ColorUtils.getContrastingTextColor(Colors.purple);
        expect(textColor, anyOf(Colors.white, Colors.black));
      });
    });

    group('withOpacity', () {
      test('should return color with specified opacity', () {
        final result = ColorUtils.withOpacity(Colors.red, 0.5);
        expect(result.a, closeTo(0.5, 0.01));
      });

      test('should handle zero opacity', () {
        final result = ColorUtils.withOpacity(Colors.blue, 0.0);
        expect(result.a, closeTo(0.0, 0.01));
      });

      test('should handle full opacity', () {
        final result = ColorUtils.withOpacity(Colors.green, 1.0);
        expect(result.a, closeTo(1.0, 0.01));
      });
    });

    group('lighten', () {
      test('should lighten a color', () {
        final original = Colors.blue;
        final lightened = ColorUtils.lighten(original, 0.2);
        final originalLuminance = HSLColor.fromColor(original).lightness;
        final lightenedLuminance = HSLColor.fromColor(lightened).lightness;

        expect(lightenedLuminance, greaterThan(originalLuminance));
      });

      test('should not exceed maximum lightness', () {
        final result = ColorUtils.lighten(Colors.white, 0.5);
        final lightness = HSLColor.fromColor(result).lightness;

        expect(lightness, lessThanOrEqualTo(1.0));
      });

      test('should use default amount of 0.1', () {
        final original = Colors.blue;
        final lightened = ColorUtils.lighten(original);
        final originalLuminance = HSLColor.fromColor(original).lightness;
        final lightenedLuminance = HSLColor.fromColor(lightened).lightness;

        expect(
          lightenedLuminance,
          closeTo(originalLuminance + 0.1, 0.01),
        );
      });
    });

    group('darken', () {
      test('should darken a color', () {
        final original = Colors.blue;
        final darkened = ColorUtils.darken(original, 0.2);
        final originalLuminance = HSLColor.fromColor(original).lightness;
        final darkenedLuminance = HSLColor.fromColor(darkened).lightness;

        expect(darkenedLuminance, lessThan(originalLuminance));
      });

      test('should not go below minimum lightness', () {
        final result = ColorUtils.darken(Colors.black, 0.5);
        final lightness = HSLColor.fromColor(result).lightness;

        expect(lightness, greaterThanOrEqualTo(0.0));
      });

      test('should use default amount of 0.1', () {
        final original = Colors.blue;
        final darkened = ColorUtils.darken(original);
        final originalLuminance = HSLColor.fromColor(original).lightness;
        final darkenedLuminance = HSLColor.fromColor(darkened).lightness;

        expect(
          darkenedLuminance,
          closeTo(originalLuminance - 0.1, 0.01),
        );
      });
    });
  });
}
