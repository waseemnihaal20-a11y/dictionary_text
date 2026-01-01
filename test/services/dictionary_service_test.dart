import 'package:dictionary_text/dictionary_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DictionaryService', () {
    late DictionaryService service;

    setUp(() {
      service = DictionaryService();
    });

    test('should throw DictionaryError for empty word', () async {
      expect(
        () => service.getDefinition(''),
        throwsA(isA<DictionaryError>()),
      );
    });

    test('should throw DictionaryError for punctuation-only word', () async {
      expect(
        () => service.getDefinition('!!!'),
        throwsA(isA<DictionaryError>()),
      );
    });

    test('should throw DictionaryError for whitespace-only word', () async {
      expect(
        () => service.getDefinition('   '),
        throwsA(isA<DictionaryError>()),
      );
    });

    test('clearCache should not throw', () {
      expect(() => service.clearCache(), returnsNormally);
    });

    test('service can be instantiated', () {
      expect(service, isA<DictionaryService>());
    });

    test('DictionaryError factory constructors work', () {
      final notFound = DictionaryError.notFound('test');
      expect(notFound.title, 'No Definitions Found');

      final network = DictionaryError.network();
      expect(network.title, 'Network Error');

      final timeout = DictionaryError.timeout();
      expect(timeout.title, 'Request Timeout');

      final unknown = DictionaryError.unknown('error');
      expect(unknown.title, 'Something Went Wrong');
    });
  });
}
