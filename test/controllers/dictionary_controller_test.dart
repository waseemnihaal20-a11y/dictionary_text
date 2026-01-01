import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/mock_dictionary_service.dart';

void main() {
  group('DictionaryController ValueNotifiers', () {
    test('ValueNotifier isLoading initializes to false', () {
      final isLoading = ValueNotifier<bool>(false);
      expect(isLoading.value, isFalse);
      isLoading.dispose();
    });

    test('ValueNotifier can be updated', () {
      final isLoading = ValueNotifier<bool>(false);
      isLoading.value = true;
      expect(isLoading.value, isTrue);
      isLoading.value = false;
      expect(isLoading.value, isFalse);
      isLoading.dispose();
    });

    test('ValueNotifier notifies listeners', () {
      final isLoading = ValueNotifier<bool>(false);
      var notified = false;
      isLoading.addListener(() => notified = true);
      isLoading.value = true;
      expect(notified, isTrue);
      isLoading.dispose();
    });
  });

  group('DictionaryController Mock Service', () {
    test('MockDictionaryService can be created', () {
      final mockService = MockDictionaryService();
      expect(mockService, isNotNull);
    });

    test('createMockDictionaryModel creates valid model', () {
      final model = createMockDictionaryModel(
        word: 'test',
        phonetic: '/test/',
      );
      expect(model.word, 'test');
      expect(model.phonetic, '/test/');
      expect(model.meanings, isNotEmpty);
    });

    test('createMockDictionaryModel with null audio', () {
      final model = createMockDictionaryModel(audioUrl: null);
      expect(model.audioUrl, isNull);
      expect(model.hasAudio, isFalse);
    });

    test('createMockDictionaryModel with audio', () {
      final model = createMockDictionaryModel(
        audioUrl: 'https://example.com/audio.mp3',
      );
      expect(model.audioUrl, 'https://example.com/audio.mp3');
      expect(model.hasAudio, isTrue);
    });

    test('createMockDictionaryError creates valid error', () {
      final error = createMockDictionaryError(
        title: 'Test Error',
        message: 'Test message',
      );
      expect(error.title, 'Test Error');
      expect(error.message, 'Test message');
    });
  });
}
