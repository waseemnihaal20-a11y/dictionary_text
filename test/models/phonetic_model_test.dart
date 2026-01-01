import 'package:dictionary_text/dictionary_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PhoneticModel', () {
    test('should create instance with all parameters', () {
      const phonetic = PhoneticModel(
        text: '/ˈflʌtər/',
        audio: 'https://example.com/audio.mp3',
      );

      expect(phonetic.text, '/ˈflʌtər/');
      expect(phonetic.audio, 'https://example.com/audio.mp3');
    });

    test('should create instance with null parameters', () {
      const phonetic = PhoneticModel();

      expect(phonetic.text, isNull);
      expect(phonetic.audio, isNull);
    });

    test('should create from JSON', () {
      final json = {
        'text': '/ˈflʌtər/',
        'audio': 'https://example.com/audio.mp3',
      };

      final phonetic = PhoneticModel.fromJson(json);

      expect(phonetic.text, '/ˈflʌtər/');
      expect(phonetic.audio, 'https://example.com/audio.mp3');
    });

    test('should handle empty JSON', () {
      final phonetic = PhoneticModel.fromJson({});

      expect(phonetic.text, isNull);
      expect(phonetic.audio, isNull);
    });

    test('hasAudio should return true when audio is present', () {
      const phonetic = PhoneticModel(
        audio: 'https://example.com/audio.mp3',
      );

      expect(phonetic.hasAudio, isTrue);
    });

    test('hasAudio should return false when audio is null', () {
      const phonetic = PhoneticModel();

      expect(phonetic.hasAudio, isFalse);
    });

    test('hasAudio should return false when audio is empty', () {
      const phonetic = PhoneticModel(audio: '');

      expect(phonetic.hasAudio, isFalse);
    });

    test('toJson should return correct map', () {
      const phonetic = PhoneticModel(
        text: '/ˈflʌtər/',
        audio: 'https://example.com/audio.mp3',
      );

      final json = phonetic.toJson();

      expect(json['text'], '/ˈflʌtər/');
      expect(json['audio'], 'https://example.com/audio.mp3');
    });

    test('equality should work correctly', () {
      const phonetic1 = PhoneticModel(
        text: '/ˈflʌtər/',
        audio: 'https://example.com/audio.mp3',
      );
      const phonetic2 = PhoneticModel(
        text: '/ˈflʌtər/',
        audio: 'https://example.com/audio.mp3',
      );
      const phonetic3 = PhoneticModel(
        text: '/ˈdɪfərənt/',
        audio: 'https://example.com/other.mp3',
      );

      expect(phonetic1, equals(phonetic2));
      expect(phonetic1, isNot(equals(phonetic3)));
    });

    test('toString should return formatted string', () {
      const phonetic = PhoneticModel(
        text: '/ˈflʌtər/',
        audio: 'https://example.com/audio.mp3',
      );

      expect(
        phonetic.toString(),
        'PhoneticModel(text: /ˈflʌtər/, audio: https://example.com/audio.mp3)',
      );
    });
  });
}
