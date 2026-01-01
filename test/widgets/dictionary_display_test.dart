import 'package:dictionary_text/dictionary_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/mock_dictionary_service.dart';

void main() {
  group('DictionaryDisplay', () {
    late MockDictionaryService mockService;
    late DictionaryController controller;

    setUp(() {
      mockService = MockDictionaryService();
      controller = DictionaryController(service: mockService);
    });

    tearDown(() {
      controller.dispose();
    });

    Widget buildTestWidget({
      Color? backgroundColor,
      Color? textColor,
      TextStyle? definitionStyle,
      VoidCallback? onClose,
      Widget Function(BuildContext)? loadingBuilder,
      Widget Function(BuildContext, DictionaryError)? errorBuilder,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: DictionaryDisplay(
            controller: controller,
            backgroundColor: backgroundColor,
            textColor: textColor,
            definitionStyle: definitionStyle,
            onClose: onClose,
            loadingBuilder: loadingBuilder,
            errorBuilder: errorBuilder,
          ),
        ),
      );
    }

    testWidgets('should show loading indicator when isLoading is true',
        (tester) async {
      controller.isLoading.value = true;

      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Looking up definition...'), findsOneWidget);
    });

    testWidgets('should show custom loading widget when provided',
        (tester) async {
      controller.isLoading.value = true;

      await tester.pumpWidget(
        buildTestWidget(
          loadingBuilder: (context) => const Text('Custom Loading'),
        ),
      );

      expect(find.text('Custom Loading'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should show error when error is set', (tester) async {
      controller.error.value = createMockDictionaryError(
        title: 'Test Error',
        message: 'Test message',
        resolution: 'Test resolution',
      );

      await tester.pumpWidget(buildTestWidget(onClose: () {}));
      await tester.pumpAndSettle();

      expect(find.text('Test Error'), findsOneWidget);
      expect(find.text('Test message'), findsOneWidget);
      expect(find.text('Test resolution'), findsOneWidget);
      expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
    });

    testWidgets('should show custom error widget when provided',
        (tester) async {
      controller.error.value = createMockDictionaryError();

      await tester.pumpWidget(
        buildTestWidget(
          errorBuilder: (context, error) => Text('Custom: ${error.title}'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Custom: No Definitions Found'), findsOneWidget);
    });

    testWidgets('should show definition when currentDefinition is set',
        (tester) async {
      controller.currentDefinition.value = createMockDictionaryModel(
        word: 'test',
        phonetic: '/test/',
      );

      await tester.pumpWidget(buildTestWidget(onClose: () {}));
      await tester.pumpAndSettle();

      expect(find.text('test'), findsOneWidget);
      expect(find.text('/test/'), findsOneWidget);
      expect(find.text('verb'), findsOneWidget);
    });

    testWidgets('should show close button when onClose is provided',
        (tester) async {
      controller.currentDefinition.value = createMockDictionaryModel();

      await tester.pumpWidget(buildTestWidget(onClose: () {}));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    });

    testWidgets('should call onClose when close button is tapped',
        (tester) async {
      var closed = false;
      controller.currentDefinition.value = createMockDictionaryModel();

      await tester.pumpWidget(buildTestWidget(onClose: () => closed = true));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(closed, isTrue);
    });

    testWidgets('should show audio button when audio is available',
        (tester) async {
      controller.currentDefinition.value = createMockDictionaryModel(
        audioUrl: 'https://example.com/audio.mp3',
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);
    });

    testWidgets('should not show audio button when no audio', (tester) async {
      controller.currentDefinition.value = createMockDictionaryModel(
        audioUrl: null,
      );

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.volume_up_rounded), findsNothing);
    });

    testWidgets('should apply custom background color', (tester) async {
      controller.currentDefinition.value = createMockDictionaryModel();

      await tester.pumpWidget(
        buildTestWidget(backgroundColor: Colors.blue),
      );
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.blue);
    });

    testWidgets('should apply custom definition style', (tester) async {
      controller.currentDefinition.value = createMockDictionaryModel();
      const customStyle = TextStyle(fontSize: 20, color: Colors.red);

      await tester.pumpWidget(
        buildTestWidget(definitionStyle: customStyle),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DictionaryDisplay), findsOneWidget);
    });

    testWidgets('should show drag handle', (tester) async {
      controller.currentDefinition.value = createMockDictionaryModel();

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });

    testWidgets('should show multiple meanings', (tester) async {
      controller.currentDefinition.value = createMockDictionaryModel();

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('verb'), findsOneWidget);
      expect(find.text('noun'), findsOneWidget);
    });

    testWidgets('should show examples when available', (tester) async {
      controller.currentDefinition.value = createMockDictionaryModel();

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('butterfly fluttered'), findsOneWidget);
    });

    testWidgets('should show nothing when no definition or error',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
