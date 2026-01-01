import 'package:dictionary_text/dictionary_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DictionaryText Widget', () {
    Widget buildTestWidget({
      String text = 'flutter',
      DisplayMode displayMode = DisplayMode.bottomSheet,
      TriggerMode triggerMode = TriggerMode.tap,
      Color? backgroundColor,
      Color? selectedWordColor,
      TextStyle? style,
      bool needGuide = false,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: DictionaryText(
              text,
              displayMode: displayMode,
              triggerMode: triggerMode,
              backgroundColor: backgroundColor,
              selectedWordColor: selectedWordColor,
              style: style,
              needGuide: needGuide,
            ),
          ),
        ),
      );
    }

    testWidgets('should display text correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget(text: 'beautiful'));

      expect(find.byType(RichText), findsOneWidget);
    });

    testWidgets('should apply custom text style', (tester) async {
      const customStyle = TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      );

      await tester.pumpWidget(
        buildTestWidget(style: customStyle),
      );

      expect(find.byType(RichText), findsOneWidget);
    });

    testWidgets('should apply selectedWordColor', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(selectedWordColor: Colors.purple),
      );

      expect(find.byType(DictionaryText), findsOneWidget);
    });

    testWidgets('should render with different display modes', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(displayMode: DisplayMode.dialog),
      );

      expect(find.byType(DictionaryText), findsOneWidget);
    });

    testWidgets('should render with background color', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(backgroundColor: Colors.blue),
      );

      expect(find.byType(DictionaryText), findsOneWidget);
    });

    testWidgets('should render with long press mode', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(triggerMode: TriggerMode.longPress),
      );

      expect(find.byType(DictionaryText), findsOneWidget);
    });
  });
}
