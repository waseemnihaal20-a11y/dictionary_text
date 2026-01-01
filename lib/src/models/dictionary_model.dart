import 'meaning_model.dart';
import 'phonetic_model.dart';

/// Represents a complete dictionary entry for a word.
///
/// Contains the word, phonetic information, meanings grouped by
/// part of speech, and license information.
class DictionaryModel {
  /// Creates a [DictionaryModel] instance.
  ///
  /// [word] is the looked-up word.
  /// [phonetic] is the primary phonetic transcription.
  /// [phonetics] is a list of all phonetic variations.
  /// [meanings] contains definitions grouped by part of speech.
  /// [license] is optional license information from the API.
  /// [sourceUrls] is a list of source URLs for the definitions.
  const DictionaryModel({
    required this.word,
    this.phonetic,
    this.phonetics = const [],
    this.meanings = const [],
    this.license,
    this.sourceUrls = const [],
  });

  /// Creates a [DictionaryModel] from a JSON map.
  ///
  /// Example:
  /// ```dart
  /// final dictionary = DictionaryModel.fromJson({
  ///   'word': 'flutter',
  ///   'phonetic': '/ˈflʌtər/',
  ///   'phonetics': [...],
  ///   'meanings': [...],
  /// });
  /// ```
  factory DictionaryModel.fromJson(Map<String, dynamic> json) {
    return DictionaryModel(
      word: json['word'] as String? ?? '',
      phonetic: json['phonetic'] as String?,
      phonetics: (json['phonetics'] as List<dynamic>?)
              ?.map((e) => PhoneticModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      meanings: (json['meanings'] as List<dynamic>?)
              ?.map((e) => MeaningModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      license: json['license'] != null
          ? LicenseModel.fromJson(json['license'] as Map<String, dynamic>)
          : null,
      sourceUrls: (json['sourceUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  /// The word that was looked up.
  final String word;

  /// The primary phonetic transcription.
  final String? phonetic;

  /// List of all phonetic variations with audio URLs.
  final List<PhoneticModel> phonetics;

  /// Meanings grouped by part of speech.
  final List<MeaningModel> meanings;

  /// License information from the API source.
  final LicenseModel? license;

  /// URLs to the definition sources.
  final List<String> sourceUrls;

  /// Returns the first available audio URL from phonetics.
  String? get audioUrl {
    for (final phonetic in phonetics) {
      if (phonetic.hasAudio) {
        return phonetic.audio;
      }
    }
    return null;
  }

  /// Whether this dictionary entry has audio available.
  bool get hasAudio => audioUrl != null;

  /// Returns the best available phonetic text.
  String? get displayPhonetic {
    if (phonetic != null && phonetic!.isNotEmpty) return phonetic;
    for (final p in phonetics) {
      if (p.text != null && p.text!.isNotEmpty) return p.text;
    }
    return null;
  }

  /// Whether this dictionary entry has meanings.
  bool get hasMeanings => meanings.isNotEmpty;

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'phonetic': phonetic,
      'phonetics': phonetics.map((e) => e.toJson()).toList(),
      'meanings': meanings.map((e) => e.toJson()).toList(),
      'license': license?.toJson(),
      'sourceUrls': sourceUrls,
    };
  }

  @override
  String toString() =>
      'DictionaryModel(word: $word, meanings: ${meanings.length})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DictionaryModel && other.word == word;
  }

  @override
  int get hashCode => word.hashCode;
}

/// Represents license information for dictionary data.
class LicenseModel {
  /// Creates a [LicenseModel] instance.
  const LicenseModel({
    required this.name,
    required this.url,
  });

  /// Creates a [LicenseModel] from a JSON map.
  factory LicenseModel.fromJson(Map<String, dynamic> json) {
    return LicenseModel(
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  /// The name of the license.
  final String name;

  /// URL to the full license text.
  final String url;

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  @override
  String toString() => 'LicenseModel(name: $name)';
}
