/// Represents phonetic information for a word.
///
/// Contains the phonetic text representation and optional audio URL
/// for pronunciation playback.
class PhoneticModel {
  /// Creates a [PhoneticModel] instance.
  ///
  /// [text] is the phonetic transcription (e.g., '/ˈflʌtər/').
  /// [audio] is an optional URL to an audio file for pronunciation.
  const PhoneticModel({
    this.text,
    this.audio,
  });

  /// Creates a [PhoneticModel] from a JSON map.
  ///
  /// Example:
  /// ```dart
  /// final phonetic = PhoneticModel.fromJson({
  ///   'text': '/ˈflʌtər/',
  ///   'audio': 'https://example.com/audio.mp3',
  /// });
  /// ```
  factory PhoneticModel.fromJson(Map<String, dynamic> json) {
    return PhoneticModel(
      text: json['text'] as String?,
      audio: json['audio'] as String?,
    );
  }

  /// The phonetic text representation (e.g., '/ˈflʌtər/').
  final String? text;

  /// URL to an audio file for pronunciation playback.
  final String? audio;

  /// Whether this phonetic has a valid audio URL.
  bool get hasAudio => audio != null && audio!.isNotEmpty;

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'audio': audio,
    };
  }

  @override
  String toString() => 'PhoneticModel(text: $text, audio: $audio)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhoneticModel && other.text == text && other.audio == audio;
  }

  @override
  int get hashCode => text.hashCode ^ audio.hashCode;
}
