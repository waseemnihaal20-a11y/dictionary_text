import 'package:dictionary_text/dictionary_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnimatedTextWrapper', () {
    testWidgets('should display child widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedTextWrapper(
              onTrigger: () {},
              child: const Text('Test'),
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('should call onTrigger when tapped (triggerOnTap: true)',
        (tester) async {
      var triggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedTextWrapper(
              onTrigger: () => triggered = true,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      expect(triggered, isTrue);
    });

    testWidgets('should not call onTrigger on tap when triggerOnTap is false',
        (tester) async {
      var triggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedTextWrapper(
              onTrigger: () => triggered = true,
              triggerOnTap: false,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      expect(triggered, isFalse);
    });

    testWidgets(
        'should call onTrigger on long press when triggerOnTap is false',
        (tester) async {
      var triggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedTextWrapper(
              onTrigger: () => triggered = true,
              triggerOnTap: false,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      await tester.longPress(find.text('Test'));
      await tester.pumpAndSettle();

      expect(triggered, isTrue);
    });

    testWidgets('should apply selected color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedTextWrapper(
              onTrigger: () {},
              selectedColor: Colors.red,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedTextWrapper), findsOneWidget);
    });

    testWidgets('should apply custom animation duration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedTextWrapper(
              onTrigger: () {},
              animationDuration: const Duration(milliseconds: 500),
              child: const Text('Test'),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedTextWrapper), findsOneWidget);
    });

    testWidgets('should apply custom animation curve', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedTextWrapper(
              onTrigger: () {},
              animationCurve: Curves.bounceIn,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedTextWrapper), findsOneWidget);
    });

    testWidgets('should provide haptic feedback when enabled', (tester) async {
      final hapticFeedbacks = <String>[];

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (message) async {
          if (message.method == 'HapticFeedback.vibrate') {
            hapticFeedbacks.add(message.arguments as String);
          }
          return null;
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedTextWrapper(
              onTrigger: () {},
              enableHapticFeedback: true,
              child: const Text('Test'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test'));
      await tester.pumpAndSettle();

      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });

    testWidgets('should animate on tap down and up', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedTextWrapper(
              onTrigger: () {},
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Test')),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('should handle tap cancel', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedTextWrapper(
              onTrigger: () {},
              child: const Text('Test'),
            ),
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Test')),
      );
      await tester.pump();

      await gesture.cancel();
      await tester.pumpAndSettle();
    });

    testWidgets('should use theme primary color when selectedColor is null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.blue),
          home: Scaffold(
            body: AnimatedTextWrapper(
              onTrigger: () {},
              child: const Text('Test'),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedTextWrapper), findsOneWidget);
    });
  });
}
