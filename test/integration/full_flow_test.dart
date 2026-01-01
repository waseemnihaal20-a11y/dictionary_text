import 'package:dictionary_text/dictionary_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/mock_dictionary_service.dart';

void main() {
  group('Full Flow Integration Tests', () {
    late MockStorageHelper mockStorageHelper;

    setUp(() {
      mockStorageHelper = MockStorageHelper();

      when(() => mockStorageHelper.init()).thenAnswer((_) async {});
      when(() => mockStorageHelper.isTutorialShown).thenReturn(true);
      when(() => mockStorageHelper.setTutorialShown())
          .thenAnswer((_) async => true);
    });

    testWidgets('DictionaryText renders correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DictionaryText(
                text: 'beautiful',
                storageHelper: mockStorageHelper,
                needGuide: false,
                backgroundColor: Colors.blue.shade100,
                selectedTextColor: Colors.blue,
              ),
            ),
          ),
        ),
      );

      expect(find.text('beautiful'), findsOneWidget);
      expect(find.byType(DictionaryText), findsOneWidget);
    });

    testWidgets('multiple DictionaryText widgets render independently',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                DictionaryText(
                  text: 'flutter',
                  storageHelper: mockStorageHelper,
                  needGuide: false,
                ),
                DictionaryText(
                  text: 'dart',
                  storageHelper: mockStorageHelper,
                  needGuide: false,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('flutter'), findsOneWidget);
      expect(find.text('dart'), findsOneWidget);
    });

    testWidgets('DictionaryText works with dialog mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DictionaryText(
              text: 'flutter',
              displayMode: DisplayMode.dialog,
              storageHelper: mockStorageHelper,
              needGuide: false,
            ),
          ),
        ),
      );

      expect(find.byType(DictionaryText), findsOneWidget);
    });

    testWidgets('DictionaryText works with long press mode', (tester) async {
      final mockService = MockDictionaryService();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DictionaryText(
              text: 'flutter',
              triggerMode: TriggerMode.longPress,
              service: mockService,
              storageHelper: mockStorageHelper,
              needGuide: false,
            ),
          ),
        ),
      );

      await tester.tap(find.text('flutter'));
      await tester.pump();

      verifyNever(() => mockService.getDefinition(any()));
    });
  });
}
