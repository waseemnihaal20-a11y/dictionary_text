import 'package:dictionary_text/dictionary_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('DictionaryService', () {
    late MockDio mockDio;
    late DictionaryService service;

    setUp(() {
      mockDio = MockDio();
      service = DictionaryService(dio: mockDio);
    });

    test('should fetch word definition successfully', () async {
      final mockResponse = [
        {
          'word': 'flutter',
          'phonetic': '/ˈflʌtər/',
          'phonetics': [
            {'text': '/ˈflʌtər/', 'audio': 'https://example.com/audio.mp3'},
          ],
          'meanings': [
            {
              'partOfSpeech': 'verb',
              'definitions': [
                {'definition': 'To move with quick movements'},
              ],
            },
          ],
        }
      ];

      when(() => mockDio.get<List<dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/en/flutter'),
        ),
      );

      final result = await service.getDefinition('flutter');

      expect(result, isA<DictionaryModel>());
      expect(result.word, 'flutter');
      expect(result.meanings.isNotEmpty, isTrue);
      verify(() => mockDio.get<List<dynamic>>('/en/flutter')).called(1);
    });

    test('should clean word before API call', () async {
      final mockResponse = [
        {
          'word': 'flutter',
          'meanings': [],
        }
      ];

      when(() => mockDio.get<List<dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: mockResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/en/flutter'),
        ),
      );

      await service.getDefinition('Flutter!');

      verify(() => mockDio.get<List<dynamic>>('/en/flutter')).called(1);
    });

    test('should throw DictionaryError for 404 response', () async {
      when(() => mockDio.get<List<dynamic>>(any())).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: '/en/xyz'),
          ),
          requestOptions: RequestOptions(path: '/en/xyz'),
        ),
      );

      expect(
        () => service.getDefinition('xyz'),
        throwsA(isA<DictionaryError>()),
      );
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

    test('should handle connection timeout', () async {
      when(() => mockDio.get<List<dynamic>>(any())).thenThrow(
        DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: '/en/test'),
        ),
      );

      expect(
        () => service.getDefinition('test'),
        throwsA(
          isA<DictionaryError>().having(
            (e) => e.title,
            'title',
            'Request Timeout',
          ),
        ),
      );
    });

    test('should handle send timeout', () async {
      when(() => mockDio.get<List<dynamic>>(any())).thenThrow(
        DioException(
          type: DioExceptionType.sendTimeout,
          requestOptions: RequestOptions(path: '/en/test'),
        ),
      );

      expect(
        () => service.getDefinition('test'),
        throwsA(
          isA<DictionaryError>().having(
            (e) => e.title,
            'title',
            'Request Timeout',
          ),
        ),
      );
    });

    test('should handle receive timeout', () async {
      when(() => mockDio.get<List<dynamic>>(any())).thenThrow(
        DioException(
          type: DioExceptionType.receiveTimeout,
          requestOptions: RequestOptions(path: '/en/test'),
        ),
      );

      expect(
        () => service.getDefinition('test'),
        throwsA(
          isA<DictionaryError>().having(
            (e) => e.title,
            'title',
            'Request Timeout',
          ),
        ),
      );
    });

    test('should handle connection error', () async {
      when(() => mockDio.get<List<dynamic>>(any())).thenThrow(
        DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: '/en/test'),
        ),
      );

      expect(
        () => service.getDefinition('test'),
        throwsA(
          isA<DictionaryError>().having(
            (e) => e.title,
            'title',
            'Network Error',
          ),
        ),
      );
    });

    test('should handle cancelled request', () async {
      when(() => mockDio.get<List<dynamic>>(any())).thenThrow(
        DioException(
          type: DioExceptionType.cancel,
          requestOptions: RequestOptions(path: '/en/test'),
        ),
      );

      expect(
        () => service.getDefinition('test'),
        throwsA(
          isA<DictionaryError>().having(
            (e) => e.title,
            'title',
            'Request Cancelled',
          ),
        ),
      );
    });

    test('should handle null response data', () async {
      when(() => mockDio.get<List<dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/en/test'),
        ),
      );

      expect(
        () => service.getDefinition('test'),
        throwsA(isA<DictionaryError>()),
      );
    });

    test('should handle empty response data', () async {
      when(() => mockDio.get<List<dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: [],
          statusCode: 200,
          requestOptions: RequestOptions(path: '/en/test'),
        ),
      );

      expect(
        () => service.getDefinition('test'),
        throwsA(isA<DictionaryError>()),
      );
    });

    test('should handle unknown DioException', () async {
      when(() => mockDio.get<List<dynamic>>(any())).thenThrow(
        DioException(
          type: DioExceptionType.unknown,
          message: 'Unknown error',
          requestOptions: RequestOptions(path: '/en/test'),
        ),
      );

      expect(
        () => service.getDefinition('test'),
        throwsA(isA<DictionaryError>()),
      );
    });

    test('should handle non-404 bad response', () async {
      when(() => mockDio.get<List<dynamic>>(any())).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/en/test'),
          ),
          requestOptions: RequestOptions(path: '/en/test'),
        ),
      );

      expect(
        () => service.getDefinition('test'),
        throwsA(
          isA<DictionaryError>().having(
            (e) => e.message,
            'message',
            contains('500'),
          ),
        ),
      );
    });
  });
}
