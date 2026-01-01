/// Represents an error response from the dictionary API.
///
/// Contains a title, message, and optional resolution suggestion
/// to help users understand what went wrong.
class DictionaryError implements Exception {
  /// Creates a [DictionaryError] instance.
  ///
  /// [title] is a short error title.
  /// [message] is a detailed error message.
  /// [resolution] is an optional suggestion for resolving the error.
  const DictionaryError({
    required this.title,
    required this.message,
    this.resolution,
  });

  /// Creates a [DictionaryError] from a JSON map.
  ///
  /// Example:
  /// ```dart
  /// final error = DictionaryError.fromJson({
  ///   'title': 'No Definitions Found',
  ///   'message': 'Sorry, we couldn\'t find definitions.',
  ///   'resolution': 'Try a different word.',
  /// });
  /// ```
  factory DictionaryError.fromJson(Map<String, dynamic> json) {
    return DictionaryError(
      title: json['title'] as String? ?? 'Error',
      message: json['message'] as String? ?? 'An unknown error occurred.',
      resolution: json['resolution'] as String?,
    );
  }

  /// Creates a network error.
  factory DictionaryError.network([String? details]) {
    return DictionaryError(
      title: 'Network Error',
      message: details ?? 'Unable to connect to the dictionary service.',
      resolution: 'Please check your internet connection and try again.',
    );
  }

  /// Creates a timeout error.
  factory DictionaryError.timeout() {
    return const DictionaryError(
      title: 'Request Timeout',
      message: 'The request took too long to complete.',
      resolution: 'Please try again.',
    );
  }

  /// Creates a not found error.
  factory DictionaryError.notFound(String word) {
    return DictionaryError(
      title: 'No Definitions Found',
      message: 'Sorry, we couldn\'t find definitions for "$word".',
      resolution: 'Try searching for a different word.',
    );
  }

  /// Creates a generic unknown error.
  factory DictionaryError.unknown([String? details]) {
    return DictionaryError(
      title: 'Something Went Wrong',
      message: details ?? 'An unexpected error occurred.',
      resolution: 'Please try again later.',
    );
  }

  /// A short title for the error.
  final String title;

  /// A detailed message explaining the error.
  final String message;

  /// An optional suggestion for resolving the error.
  final String? resolution;

  /// Whether this error has a resolution suggestion.
  bool get hasResolution => resolution != null && resolution!.isNotEmpty;

  /// Converts this error to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'resolution': resolution,
    };
  }

  @override
  String toString() => 'DictionaryError: $title - $message';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DictionaryError &&
        other.title == title &&
        other.message == message;
  }

  @override
  int get hashCode => title.hashCode ^ message.hashCode;
}
