import 'package:dictionary_text/dictionary_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MeaningModel', () {
    test('should create instance with required parameters', () {
      const meaning = MeaningModel(
        partOfSpeech: 'verb',
        definitions: [],
      );

      expect(meaning.partOfSpeech, 'verb');
      expect(meaning.definitions, isEmpty);
      expect(meaning.synonyms, isEmpty);
      expect(meaning.antonyms, isEmpty);
    });

    test('should create instance with all parameters', () {
      const definitions = [
        DefinitionModel(definition: 'Test definition'),
      ];
      const meaning = MeaningModel(
        partOfSpeech: 'verb',
        definitions: definitions,
        synonyms: ['syn1'],
        antonyms: ['ant1'],
      );

      expect(meaning.partOfSpeech, 'verb');
      expect(meaning.definitions, hasLength(1));
      expect(meaning.synonyms, ['syn1']);
      expect(meaning.antonyms, ['ant1']);
    });

    test('should create from JSON', () {
      final json = {
        'partOfSpeech': 'noun',
        'definitions': [
          {'definition': 'A test definition'},
        ],
        'synonyms': ['synonym'],
        'antonyms': ['antonym'],
      };

      final meaning = MeaningModel.fromJson(json);

      expect(meaning.partOfSpeech, 'noun');
      expect(meaning.definitions, hasLength(1));
      expect(meaning.definitions.first.definition, 'A test definition');
      expect(meaning.synonyms, ['synonym']);
      expect(meaning.antonyms, ['antonym']);
    });

    test('should handle missing fields in JSON', () {
      final meaning = MeaningModel.fromJson({});

      expect(meaning.partOfSpeech, '');
      expect(meaning.definitions, isEmpty);
      expect(meaning.synonyms, isEmpty);
      expect(meaning.antonyms, isEmpty);
    });

    test('hasDefinitions should work correctly', () {
      const withDefs = MeaningModel(
        partOfSpeech: 'verb',
        definitions: [DefinitionModel(definition: 'Test')],
      );
      const withoutDefs = MeaningModel(
        partOfSpeech: 'verb',
        definitions: [],
      );

      expect(withDefs.hasDefinitions, isTrue);
      expect(withoutDefs.hasDefinitions, isFalse);
    });

    test('hasSynonyms should work correctly', () {
      const withSynonyms = MeaningModel(
        partOfSpeech: 'verb',
        definitions: [],
        synonyms: ['word'],
      );
      const withoutSynonyms = MeaningModel(
        partOfSpeech: 'verb',
        definitions: [],
      );

      expect(withSynonyms.hasSynonyms, isTrue);
      expect(withoutSynonyms.hasSynonyms, isFalse);
    });

    test('hasAntonyms should work correctly', () {
      const withAntonyms = MeaningModel(
        partOfSpeech: 'verb',
        definitions: [],
        antonyms: ['word'],
      );
      const withoutAntonyms = MeaningModel(
        partOfSpeech: 'verb',
        definitions: [],
      );

      expect(withAntonyms.hasAntonyms, isTrue);
      expect(withoutAntonyms.hasAntonyms, isFalse);
    });

    test('toJson should return correct map', () {
      const meaning = MeaningModel(
        partOfSpeech: 'verb',
        definitions: [DefinitionModel(definition: 'Test')],
        synonyms: ['syn'],
        antonyms: ['ant'],
      );

      final json = meaning.toJson();

      expect(json['partOfSpeech'], 'verb');
      expect(json['definitions'], hasLength(1));
      expect(json['synonyms'], ['syn']);
      expect(json['antonyms'], ['ant']);
    });

    test('equality should work correctly', () {
      const meaning1 = MeaningModel(partOfSpeech: 'verb', definitions: []);
      const meaning2 = MeaningModel(partOfSpeech: 'verb', definitions: []);
      const meaning3 = MeaningModel(partOfSpeech: 'noun', definitions: []);

      expect(meaning1, equals(meaning2));
      expect(meaning1, isNot(equals(meaning3)));
    });
  });
}
