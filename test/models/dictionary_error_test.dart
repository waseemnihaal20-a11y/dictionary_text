import 'package:dictionary_text/dictionary_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DictionaryError', () {
    test('should create instance with required parameters', () {
      const error = DictionaryError(
        title: 'Error Title',
        message: 'Error message',
      );

      expect(error.title, 'Error Title');
      expect(error.message, 'Error message');
      expect(error.resolution, isNull);
    });

    test('should create instance with all parameters', () {
      const error = DictionaryError(
        title: 'Error Title',
        message: 'Error message',
        resolution: 'Try again',
      );

      expect(error.title, 'Error Title');
      expect(error.message, 'Error message');
      expect(error.resolution, 'Try again');
    });

    test('should create from JSON', () {
      final json = {
        'title': 'Error Title',
        'message': 'Error message',
        'resolution': 'Try again',
      };

      final error = DictionaryError.fromJson(json);

      expect(error.title, 'Error Title');
      expect(error.message, 'Error message');
      expect(error.resolution, 'Try again');
    });

    test('should handle missing fields in JSON', () {
      final error = DictionaryError.fromJson({});

      expect(error.title, 'Error');
      expect(error.message, 'An unknown error occurred.');
      expect(error.resolution, isNull);
    });

    test('network factory should create correct error', () {
      final error = DictionaryError.network();

      expect(error.title, 'Network Error');
      expect(error.message, contains('Unable to connect'));
      expect(error.resolution, contains('internet connection'));
    });

    test('network factory should accept custom details', () {
      final error = DictionaryError.network('Custom network error');

      expect(error.message, 'Custom network error');
    });

    test('timeout factory should create correct error', () {
      final error = DictionaryError.timeout();

      expect(error.title, 'Request Timeout');
      expect(error.message, contains('took too long'));
      expect(error.resolution, 'Please try again.');
    });

    test('notFound factory should create correct error', () {
      final error = DictionaryError.notFound('xyz');

      expect(error.title, 'No Definitions Found');
      expect(error.message, contains('xyz'));
      expect(error.resolution, contains('different word'));
    });

    test('unknown factory should create correct error', () {
      final error = DictionaryError.unknown();

      expect(error.title, 'Something Went Wrong');
      expect(error.message, contains('unexpected error'));
      expect(error.resolution, 'Please try again later.');
    });

    test('unknown factory should accept custom details', () {
      final error = DictionaryError.unknown('Custom error details');

      expect(error.message, 'Custom error details');
    });

    test('hasResolution should return true when resolution exists', () {
      const error = DictionaryError(
        title: 'Error',
        message: 'Message',
        resolution: 'Resolution',
      );

      expect(error.hasResolution, isTrue);
    });

    test('hasResolution should return false when resolution is null', () {
      const error = DictionaryError(
        title: 'Error',
        message: 'Message',
      );

      expect(error.hasResolution, isFalse);
    });

    test('hasResolution should return false when resolution is empty', () {
      const error = DictionaryError(
        title: 'Error',
        message: 'Message',
        resolution: '',
      );

      expect(error.hasResolution, isFalse);
    });

    test('toJson should return correct map', () {
      const error = DictionaryError(
        title: 'Error Title',
        message: 'Error message',
        resolution: 'Try again',
      );

      final json = error.toJson();

      expect(json['title'], 'Error Title');
      expect(json['message'], 'Error message');
      expect(json['resolution'], 'Try again');
    });

    test('toString should return formatted string', () {
      const error = DictionaryError(
        title: 'Error Title',
        message: 'Error message',
      );

      expect(error.toString(), 'DictionaryError: Error Title - Error message');
    });

    test('equality should work correctly', () {
      const error1 = DictionaryError(title: 'Error', message: 'Message');
      const error2 = DictionaryError(title: 'Error', message: 'Message');
      const error3 = DictionaryError(title: 'Other', message: 'Different');

      expect(error1, equals(error2));
      expect(error1, isNot(equals(error3)));
    });

    test('should be throwable as Exception', () {
      const error = DictionaryError(
        title: 'Error',
        message: 'Message',
      );

      expect(() => throw error, throwsA(isA<DictionaryError>()));
    });
  });
}
