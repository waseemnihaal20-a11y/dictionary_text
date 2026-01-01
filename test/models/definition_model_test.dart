import 'package:dictionary_text/dictionary_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DefinitionModel', () {
    test('should create instance with required parameters', () {
      const definition = DefinitionModel(
        definition: 'To move with quick movements',
      );

      expect(definition.definition, 'To move with quick movements');
      expect(definition.example, isNull);
      expect(definition.synonyms, isEmpty);
      expect(definition.antonyms, isEmpty);
    });

    test('should create instance with all parameters', () {
      const definition = DefinitionModel(
        definition: 'To move with quick movements',
        example: 'The butterfly fluttered',
        synonyms: ['flap', 'wave'],
        antonyms: ['stay still'],
      );

      expect(definition.definition, 'To move with quick movements');
      expect(definition.example, 'The butterfly fluttered');
      expect(definition.synonyms, ['flap', 'wave']);
      expect(definition.antonyms, ['stay still']);
    });

    test('should create from JSON', () {
      final json = {
        'definition': 'To move with quick movements',
        'example': 'The butterfly fluttered',
        'synonyms': ['flap', 'wave'],
        'antonyms': ['stay still'],
      };

      final definition = DefinitionModel.fromJson(json);

      expect(definition.definition, 'To move with quick movements');
      expect(definition.example, 'The butterfly fluttered');
      expect(definition.synonyms, ['flap', 'wave']);
      expect(definition.antonyms, ['stay still']);
    });

    test('should handle missing fields in JSON', () {
      final definition = DefinitionModel.fromJson({});

      expect(definition.definition, '');
      expect(definition.example, isNull);
      expect(definition.synonyms, isEmpty);
      expect(definition.antonyms, isEmpty);
    });

    test('hasExample should return true when example is present', () {
      const definition = DefinitionModel(
        definition: 'Test',
        example: 'Example sentence',
      );

      expect(definition.hasExample, isTrue);
    });

    test('hasExample should return false when example is null', () {
      const definition = DefinitionModel(definition: 'Test');

      expect(definition.hasExample, isFalse);
    });

    test('hasExample should return false when example is empty', () {
      const definition = DefinitionModel(
        definition: 'Test',
        example: '',
      );

      expect(definition.hasExample, isFalse);
    });

    test('hasSynonyms should work correctly', () {
      const withSynonyms = DefinitionModel(
        definition: 'Test',
        synonyms: ['word'],
      );
      const withoutSynonyms = DefinitionModel(definition: 'Test');

      expect(withSynonyms.hasSynonyms, isTrue);
      expect(withoutSynonyms.hasSynonyms, isFalse);
    });

    test('hasAntonyms should work correctly', () {
      const withAntonyms = DefinitionModel(
        definition: 'Test',
        antonyms: ['word'],
      );
      const withoutAntonyms = DefinitionModel(definition: 'Test');

      expect(withAntonyms.hasAntonyms, isTrue);
      expect(withoutAntonyms.hasAntonyms, isFalse);
    });

    test('toJson should return correct map', () {
      const definition = DefinitionModel(
        definition: 'To move with quick movements',
        example: 'The butterfly fluttered',
        synonyms: ['flap'],
        antonyms: ['stay'],
      );

      final json = definition.toJson();

      expect(json['definition'], 'To move with quick movements');
      expect(json['example'], 'The butterfly fluttered');
      expect(json['synonyms'], ['flap']);
      expect(json['antonyms'], ['stay']);
    });

    test('equality should work correctly', () {
      const def1 = DefinitionModel(
        definition: 'Test',
        example: 'Example',
      );
      const def2 = DefinitionModel(
        definition: 'Test',
        example: 'Example',
      );
      const def3 = DefinitionModel(
        definition: 'Different',
        example: 'Other',
      );

      expect(def1, equals(def2));
      expect(def1, isNot(equals(def3)));
    });
  });
}
