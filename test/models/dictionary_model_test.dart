import 'package:dictionary_text/dictionary_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DictionaryModel', () {
    test('should create instance with required parameters', () {
      const model = DictionaryModel(word: 'flutter');

      expect(model.word, 'flutter');
      expect(model.phonetic, isNull);
      expect(model.phonetics, isEmpty);
      expect(model.meanings, isEmpty);
      expect(model.license, isNull);
      expect(model.sourceUrls, isEmpty);
    });

    test('should create instance with all parameters', () {
      const phonetics = [PhoneticModel(text: '/ˈflʌtər/')];
      const meanings = [
        MeaningModel(partOfSpeech: 'verb', definitions: []),
      ];
      const model = DictionaryModel(
        word: 'flutter',
        phonetic: '/ˈflʌtər/',
        phonetics: phonetics,
        meanings: meanings,
        sourceUrls: ['https://example.com'],
      );

      expect(model.word, 'flutter');
      expect(model.phonetic, '/ˈflʌtər/');
      expect(model.phonetics, hasLength(1));
      expect(model.meanings, hasLength(1));
      expect(model.sourceUrls, ['https://example.com']);
    });

    test('should create from JSON', () {
      final json = {
        'word': 'flutter',
        'phonetic': '/ˈflʌtər/',
        'phonetics': [
          {'text': '/ˈflʌtər/', 'audio': 'https://example.com/audio.mp3'},
        ],
        'meanings': [
          {
            'partOfSpeech': 'verb',
            'definitions': [
              {'definition': 'To move quickly'},
            ],
          },
        ],
        'license': {'name': 'CC BY-SA', 'url': 'https://license.url'},
        'sourceUrls': ['https://example.com'],
      };

      final model = DictionaryModel.fromJson(json);

      expect(model.word, 'flutter');
      expect(model.phonetic, '/ˈflʌtər/');
      expect(model.phonetics, hasLength(1));
      expect(model.meanings, hasLength(1));
      expect(model.license?.name, 'CC BY-SA');
      expect(model.sourceUrls, ['https://example.com']);
    });

    test('should handle missing fields in JSON', () {
      final model = DictionaryModel.fromJson({});

      expect(model.word, '');
      expect(model.phonetic, isNull);
      expect(model.phonetics, isEmpty);
      expect(model.meanings, isEmpty);
      expect(model.license, isNull);
      expect(model.sourceUrls, isEmpty);
    });

    test('audioUrl should return first available audio', () {
      const model = DictionaryModel(
        word: 'flutter',
        phonetics: [
          PhoneticModel(text: '/ˈflʌtər/'),
          PhoneticModel(
            text: '/ˈflʌtər/',
            audio: 'https://example.com/audio.mp3',
          ),
        ],
      );

      expect(model.audioUrl, 'https://example.com/audio.mp3');
    });

    test('audioUrl should return null when no audio available', () {
      const model = DictionaryModel(
        word: 'flutter',
        phonetics: [PhoneticModel(text: '/ˈflʌtər/')],
      );

      expect(model.audioUrl, isNull);
    });

    test('hasAudio should work correctly', () {
      const withAudio = DictionaryModel(
        word: 'flutter',
        phonetics: [
          PhoneticModel(audio: 'https://example.com/audio.mp3'),
        ],
      );
      const withoutAudio = DictionaryModel(word: 'flutter');

      expect(withAudio.hasAudio, isTrue);
      expect(withoutAudio.hasAudio, isFalse);
    });

    test('displayPhonetic should return phonetic when available', () {
      const model = DictionaryModel(
        word: 'flutter',
        phonetic: '/ˈflʌtər/',
      );

      expect(model.displayPhonetic, '/ˈflʌtər/');
    });

    test('displayPhonetic should fallback to phonetics list', () {
      const model = DictionaryModel(
        word: 'flutter',
        phonetics: [PhoneticModel(text: '/ˈflʌtər/')],
      );

      expect(model.displayPhonetic, '/ˈflʌtər/');
    });

    test('displayPhonetic should return null when none available', () {
      const model = DictionaryModel(word: 'flutter');

      expect(model.displayPhonetic, isNull);
    });

    test('hasMeanings should work correctly', () {
      const withMeanings = DictionaryModel(
        word: 'flutter',
        meanings: [MeaningModel(partOfSpeech: 'verb', definitions: [])],
      );
      const withoutMeanings = DictionaryModel(word: 'flutter');

      expect(withMeanings.hasMeanings, isTrue);
      expect(withoutMeanings.hasMeanings, isFalse);
    });

    test('toJson should return correct map', () {
      const model = DictionaryModel(
        word: 'flutter',
        phonetic: '/ˈflʌtər/',
        phonetics: [PhoneticModel(text: '/ˈflʌtər/')],
        meanings: [MeaningModel(partOfSpeech: 'verb', definitions: [])],
        sourceUrls: ['https://example.com'],
      );

      final json = model.toJson();

      expect(json['word'], 'flutter');
      expect(json['phonetic'], '/ˈflʌtər/');
      expect(json['phonetics'], hasLength(1));
      expect(json['meanings'], hasLength(1));
      expect(json['sourceUrls'], ['https://example.com']);
    });

    test('equality should work correctly', () {
      const model1 = DictionaryModel(word: 'flutter');
      const model2 = DictionaryModel(word: 'flutter');
      const model3 = DictionaryModel(word: 'dart');

      expect(model1, equals(model2));
      expect(model1, isNot(equals(model3)));
    });
  });

  group('LicenseModel', () {
    test('should create from JSON', () {
      final json = {
        'name': 'CC BY-SA',
        'url': 'https://license.url',
      };

      final license = LicenseModel.fromJson(json);

      expect(license.name, 'CC BY-SA');
      expect(license.url, 'https://license.url');
    });

    test('should handle missing fields', () {
      final license = LicenseModel.fromJson({});

      expect(license.name, '');
      expect(license.url, '');
    });

    test('toJson should return correct map', () {
      const license = LicenseModel(
        name: 'CC BY-SA',
        url: 'https://license.url',
      );

      final json = license.toJson();

      expect(json['name'], 'CC BY-SA');
      expect(json['url'], 'https://license.url');
    });
  });
}
