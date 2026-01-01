import 'package:dictionary_text/dictionary_text.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('StorageHelper', () {
    late MockSharedPreferences mockPrefs;
    late StorageHelper storageHelper;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      storageHelper = StorageHelper(mockPrefs);
    });

    test('tutorialShownKey should be correct', () {
      expect(
        StorageHelper.tutorialShownKey,
        'dictionary_text_tutorial_shown',
      );
    });

    test('isTutorialShown should return false when not set', () {
      when(() => mockPrefs.getBool(StorageHelper.tutorialShownKey))
          .thenReturn(null);

      expect(storageHelper.isTutorialShown, isFalse);
    });

    test('isTutorialShown should return stored value', () {
      when(() => mockPrefs.getBool(StorageHelper.tutorialShownKey))
          .thenReturn(true);

      expect(storageHelper.isTutorialShown, isTrue);
    });

    test('setTutorialShown should save true value', () async {
      when(() => mockPrefs.setBool(StorageHelper.tutorialShownKey, true))
          .thenAnswer((_) async => true);

      final result = await storageHelper.setTutorialShown();

      expect(result, isTrue);
      verify(() => mockPrefs.setBool(StorageHelper.tutorialShownKey, true))
          .called(1);
    });

    test('resetTutorial should remove the key', () async {
      when(() => mockPrefs.remove(StorageHelper.tutorialShownKey))
          .thenAnswer((_) async => true);

      final result = await storageHelper.resetTutorial();

      expect(result, isTrue);
      verify(() => mockPrefs.remove(StorageHelper.tutorialShownKey)).called(1);
    });

    test('clearAll should clear all preferences', () async {
      when(() => mockPrefs.clear()).thenAnswer((_) async => true);

      final result = await storageHelper.clearAll();

      expect(result, isTrue);
      verify(() => mockPrefs.clear()).called(1);
    });

    test('should handle null prefs for isTutorialShown', () {
      final helperWithoutPrefs = StorageHelper();

      expect(helperWithoutPrefs.isTutorialShown, isFalse);
    });
  });
}
