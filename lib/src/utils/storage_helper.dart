import 'package:shared_preferences/shared_preferences.dart';

/// Helper class for managing local storage operations.
///
/// Uses [SharedPreferences] to persist data across app sessions.
class StorageHelper {
  /// Creates a [StorageHelper] instance.
  ///
  /// Optionally accepts a [SharedPreferences] instance for testing.
  StorageHelper([this._prefs]);

  SharedPreferences? _prefs;

  /// Storage key for the tutorial shown flag.
  static const String tutorialShownKey = 'dictionary_text_tutorial_shown';

  /// Initializes the shared preferences instance.
  ///
  /// Must be called before using other methods if no instance
  /// was provided in the constructor.
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Returns whether the tutorial has been shown.
  ///
  /// Returns `false` if the key doesn't exist or hasn't been initialized.
  bool get isTutorialShown {
    return _prefs?.getBool(tutorialShownKey) ?? false;
  }

  /// Marks the tutorial as shown.
  ///
  /// Returns `true` if the operation was successful.
  Future<bool> setTutorialShown() async {
    await init();
    return _prefs?.setBool(tutorialShownKey, true) ?? Future.value(false);
  }

  /// Resets the tutorial shown flag.
  ///
  /// Useful for testing or allowing users to see the tutorial again.
  Future<bool> resetTutorial() async {
    await init();
    return _prefs?.remove(tutorialShownKey) ?? Future.value(false);
  }

  /// Clears all stored data.
  ///
  /// Use with caution as this removes all preferences.
  Future<bool> clearAll() async {
    await init();
    return _prefs?.clear() ?? Future.value(false);
  }
}
