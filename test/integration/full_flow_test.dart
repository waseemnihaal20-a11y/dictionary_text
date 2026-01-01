import 'package:dictionary_text/dictionary_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Full Flow Integration Tests', () {
    testWidgets('DictionaryText renders correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DictionaryText(
                'beautiful',
                needGuide: false,
                backgroundColor: Colors.blue.shade100,
                selectedWordColor: Colors.blue,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(RichText), findsOneWidget);
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
                  'flutter',
                  needGuide: false,
                ),
                DictionaryText(
                  'dart',
                  needGuide: false,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(RichText), findsNWidgets(2));
      expect(find.byType(DictionaryText), findsNWidgets(2));
    });

    testWidgets('DictionaryText works with dialog mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DictionaryText(
              'flutter',
              displayMode: DisplayMode.dialog,
              needGuide: false,
            ),
          ),
        ),
      );

      expect(find.byType(DictionaryText), findsOneWidget);
    });

    testWidgets('DictionaryText works with long press mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DictionaryText(
              'flutter',
              triggerMode: TriggerMode.longPress,
              needGuide: false,
            ),
          ),
        ),
      );

      expect(find.byType(DictionaryText), findsOneWidget);
    });
  });
}
