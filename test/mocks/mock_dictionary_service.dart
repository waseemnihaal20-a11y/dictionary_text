import 'package:dictionary_text/dictionary_text.dart';
import 'package:mocktail/mocktail.dart';

/// Mock implementation of [DictionaryService] for testing.
class MockDictionaryService extends Mock implements DictionaryService {}

/// Mock implementation of [StorageHelper] for testing.
class MockStorageHelper extends Mock implements StorageHelper {}

/// Creates a sample [DictionaryModel] for testing.
DictionaryModel createMockDictionaryModel({
  String word = 'flutter',
  String? phonetic = '/ˈflʌtər/',
  String? audioUrl =
      'https://api.dictionaryapi.dev/media/pronunciations/en/flutter.mp3',
}) {
  return DictionaryModel(
    word: word,
    phonetic: phonetic,
    phonetics: [
      PhoneticModel(
        text: phonetic,
        audio: audioUrl,
      ),
    ],
    meanings: [
      MeaningModel(
        partOfSpeech: 'verb',
        definitions: [
          DefinitionModel(
            definition: 'To move with quick, light movements',
            example: 'The butterfly fluttered its wings',
            synonyms: ['flap', 'wave'],
            antonyms: ['stay still'],
          ),
          DefinitionModel(
            definition: 'To move about quickly and aimlessly',
            example: 'She fluttered around the room',
          ),
        ],
      ),
      MeaningModel(
        partOfSpeech: 'noun',
        definitions: [
          DefinitionModel(
            definition: 'A quick, light movement',
            example: 'The flutter of wings',
          ),
        ],
      ),
    ],
    sourceUrls: ['https://en.wiktionary.org/wiki/flutter'],
  );
}

/// Creates a sample [DictionaryError] for testing.
DictionaryError createMockDictionaryError({
  String title = 'No Definitions Found',
  String message = 'Sorry, we couldn\'t find definitions for "xyz".',
  String? resolution = 'Try searching for a different word.',
}) {
  return DictionaryError(
    title: title,
    message: message,
    resolution: resolution,
  );
}
