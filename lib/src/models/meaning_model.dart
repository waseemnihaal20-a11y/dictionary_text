import 'definition_model.dart';

/// Represents a meaning of a word grouped by part of speech.
///
/// Contains the part of speech (e.g., 'noun', 'verb') and a list
/// of definitions for that usage.
class MeaningModel {
  /// Creates a [MeaningModel] instance.
  ///
  /// [partOfSpeech] indicates the grammatical category (e.g., 'noun', 'verb').
  /// [definitions] is the list of definitions for this part of speech.
  /// [synonyms] is a list of synonyms for this meaning.
  /// [antonyms] is a list of antonyms for this meaning.
  const MeaningModel({
    required this.partOfSpeech,
    required this.definitions,
    this.synonyms = const [],
    this.antonyms = const [],
  });

  /// Creates a [MeaningModel] from a JSON map.
  ///
  /// Example:
  /// ```dart
  /// final meaning = MeaningModel.fromJson({
  ///   'partOfSpeech': 'verb',
  ///   'definitions': [
  ///     {'definition': 'To move with quick movements'},
  ///   ],
  /// });
  /// ```
  factory MeaningModel.fromJson(Map<String, dynamic> json) {
    return MeaningModel(
      partOfSpeech: json['partOfSpeech'] as String? ?? '',
      definitions: (json['definitions'] as List<dynamic>?)
              ?.map((e) => DefinitionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      synonyms: (json['synonyms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      antonyms: (json['antonyms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  /// The grammatical category (e.g., 'noun', 'verb', 'adjective').
  final String partOfSpeech;

  /// List of definitions for this part of speech.
  final List<DefinitionModel> definitions;

  /// List of synonyms for this meaning.
  final List<String> synonyms;

  /// List of antonyms for this meaning.
  final List<String> antonyms;

  /// Whether this meaning has definitions.
  bool get hasDefinitions => definitions.isNotEmpty;

  /// Whether this meaning has synonyms.
  bool get hasSynonyms => synonyms.isNotEmpty;

  /// Whether this meaning has antonyms.
  bool get hasAntonyms => antonyms.isNotEmpty;

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'partOfSpeech': partOfSpeech,
      'definitions': definitions.map((e) => e.toJson()).toList(),
      'synonyms': synonyms,
      'antonyms': antonyms,
    };
  }

  @override
  String toString() =>
      'MeaningModel(partOfSpeech: $partOfSpeech, definitions: ${definitions.length})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MeaningModel && other.partOfSpeech == partOfSpeech;
  }

  @override
  int get hashCode => partOfSpeech.hashCode;
}
