import 'package:dio/dio.dart';

import '../models/dictionary_error.dart';
import '../models/dictionary_model.dart';

/// Service for fetching word definitions from the dictionary API.
///
/// Uses the free Dictionary API to look up word definitions,
/// phonetics, and examples.
///
/// Includes built-in caching to avoid repeated API calls for the same word.
///
/// Example:
/// ```dart
/// final service = DictionaryService();
/// final definition = await service.getDefinition('flutter');
/// print(definition.word);
/// ```
class DictionaryService {
  /// Creates a [DictionaryService] instance.
  DictionaryService() : _dio = _createDefaultDio();

  final Dio _dio;

  /// Cache for storing fetched definitions to avoid repeated API calls.
  final Map<String, DictionaryModel> _cache = {};

  /// Base URL for the dictionary API.
  static const String _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries';

  /// Default language for lookups.
  static const String _defaultLanguage = 'en';

  static Dio _createDefaultDio() {
    return Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    );
  }

  /// Fetches the definition for a word.
  ///
  /// [word] is the word to look up. It will be cleaned (lowercase,
  /// punctuation removed) before the API call.
  ///
  /// Returns a [DictionaryModel] containing the word definition.
  ///
  /// Throws a [DictionaryError] if the word is not found or if
  /// there's a network error.
  ///
  /// Example:
  /// ```dart
  /// final service = DictionaryService();
  /// try {
  ///   final definition = await service.getDefinition('flutter');
  ///   print(definition.word); // 'flutter'
  /// } on DictionaryError catch (e) {
  ///   print(e.message);
  /// }
  /// ```
  Future<DictionaryModel> getDefinition(String word) async {
    final cleanedWord = _cleanWord(word);

    if (cleanedWord.isEmpty) {
      throw DictionaryError.notFound(word);
    }

    // Return cached result if available
    if (_cache.containsKey(cleanedWord)) {
      return _cache[cleanedWord]!;
    }

    try {
      final response = await _dio.get<List<dynamic>>(
        '/$_defaultLanguage/$cleanedWord',
      );

      if (response.data == null || response.data!.isEmpty) {
        throw DictionaryError.notFound(cleanedWord);
      }

      final data = response.data!.first as Map<String, dynamic>;
      final model = DictionaryModel.fromJson(data);

      // Cache the result
      _cache[cleanedWord] = model;

      return model;
    } on DioException catch (e) {
      throw _handleDioError(e, cleanedWord);
    }
  }

  /// Clears the definition cache.
  void clearCache() {
    _cache.clear();
  }

  /// Cleans a word for API lookup.
  ///
  /// Removes punctuation and converts to lowercase.
  String _cleanWord(String word) {
    return word.replaceAll(RegExp(r'[^\w\s]'), '').trim().toLowerCase();
  }

  /// Converts a [DioException] to a [DictionaryError].
  DictionaryError _handleDioError(DioException e, String word) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return DictionaryError.timeout();

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) {
          return DictionaryError.notFound(word);
        }
        return DictionaryError.unknown(
          'Server returned status code: $statusCode',
        );

      case DioExceptionType.connectionError:
        return DictionaryError.network();

      case DioExceptionType.cancel:
        return const DictionaryError(
          title: 'Request Cancelled',
          message: 'The request was cancelled.',
        );

      default:
        return DictionaryError.unknown(e.message);
    }
  }
}
