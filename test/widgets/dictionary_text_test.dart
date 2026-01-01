import 'package:dictionary_text/dictionary_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/mock_dictionary_service.dart';

void main() {
  group('DictionaryText Widget', () {
    late MockStorageHelper mockStorageHelper;

    setUp(() {
      mockStorageHelper = MockStorageHelper();

      when(() => mockStorageHelper.init()).thenAnswer((_) async {});
      when(() => mockStorageHelper.isTutorialShown).thenReturn(true);
      when(() => mockStorageHelper.setTutorialShown())
          .thenAnswer((_) async => true);
    });

    Widget buildTestWidget({
      String text = 'flutter',
      DisplayMode displayMode = DisplayMode.bottomSheet,
      TriggerMode triggerMode = TriggerMode.tap,
      Color? backgroundColor,
      Color? selectedTextColor,
      TextStyle? textStyle,
      bool needGuide = false,
      DictionaryController? controller,
      DictionaryService? service,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: DictionaryText(
              text: text,
              displayMode: displayMode,
              triggerMode: triggerMode,
              backgroundColor: backgroundColor,
              selectedTextColor: selectedTextColor,
              textStyle: textStyle,
              needGuide: needGuide,
              controller: controller,
              service: service,
              storageHelper: mockStorageHelper,
            ),
          ),
        ),
      );
    }

    testWidgets('should display text correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget(text: 'beautiful'));

      expect(find.text('beautiful'), findsOneWidget);
    });

    testWidgets('should apply custom text style', (tester) async {
      const customStyle = TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      );

      await tester.pumpWidget(
        buildTestWidget(textStyle: customStyle),
      );

      final textWidget = tester.widget<Text>(find.text('flutter'));
      expect(textWidget.style?.fontSize, 24);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('should apply selectedTextColor', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(selectedTextColor: Colors.purple),
      );

      expect(find.byType(AnimatedTextWrapper), findsOneWidget);
    });

    testWidgets('should not trigger on tap when triggerMode is longPress',
        (tester) async {
      final mockService = MockDictionaryService();

      await tester.pumpWidget(
        buildTestWidget(
          triggerMode: TriggerMode.longPress,
          service: mockService,
        ),
      );

      await tester.tap(find.text('flutter'));
      await tester.pump();

      verifyNever(() => mockService.getDefinition(any()));
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
  });
}
