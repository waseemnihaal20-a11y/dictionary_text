/// Represents a single definition of a word.
///
/// Contains the definition text, optional example sentence,
/// and lists of synonyms and antonyms.
class DefinitionModel {
  /// Creates a [DefinitionModel] instance.
  ///
  /// [definition] is the meaning of the word.
  /// [example] is an optional example sentence showing usage.
  /// [synonyms] is a list of words with similar meanings.
  /// [antonyms] is a list of words with opposite meanings.
  const DefinitionModel({
    required this.definition,
    this.example,
    this.synonyms = const [],
    this.antonyms = const [],
  });

  /// Creates a [DefinitionModel] from a JSON map.
  ///
  /// Example:
  /// ```dart
  /// final definition = DefinitionModel.fromJson({
  ///   'definition': 'To move with quick, light movements',
  ///   'example': 'The butterfly fluttered its wings',
  ///   'synonyms': ['flap', 'wave'],
  ///   'antonyms': ['stay still'],
  /// });
  /// ```
  factory DefinitionModel.fromJson(Map<String, dynamic> json) {
    return DefinitionModel(
      definition: json['definition'] as String? ?? '',
      example: json['example'] as String?,
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

  /// The definition text explaining the meaning.
  final String definition;

  /// An optional example sentence showing word usage.
  final String? example;

  /// List of words with similar meanings.
  final List<String> synonyms;

  /// List of words with opposite meanings.
  final List<String> antonyms;

  /// Whether this definition has an example sentence.
  bool get hasExample => example != null && example!.isNotEmpty;

  /// Whether this definition has synonyms.
  bool get hasSynonyms => synonyms.isNotEmpty;

  /// Whether this definition has antonyms.
  bool get hasAntonyms => antonyms.isNotEmpty;

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'definition': definition,
      'example': example,
      'synonyms': synonyms,
      'antonyms': antonyms,
    };
  }

  @override
  String toString() =>
      'DefinitionModel(definition: $definition, example: $example)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DefinitionModel &&
        other.definition == definition &&
        other.example == example;
  }

  @override
  int get hashCode => definition.hashCode ^ example.hashCode;
}
