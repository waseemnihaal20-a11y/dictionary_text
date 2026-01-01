import 'package:flutter/material.dart';
import 'package:dictionary_text/dictionary_text.dart';

void main() {
  runApp(const ExampleApp());
}

/// Example app demonstrating the dictionary_text package.
class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dictionary Text Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const DemoHomePage(),
    );
  }
}

/// Home page with various dictionary text demos.
class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    BasicDemoPage(),
    CustomStyleDemoPage(),
    DialogModeDemoPage(),
    LongPressDemoPage(),
    ParagraphDemoPage(),
  ];

  final List<String> _titles = const [
    'Basic Usage',
    'Custom Styles',
    'Dialog Mode',
    'Long Press',
    'Paragraph',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.text_fields),
            label: 'Basic',
          ),
          NavigationDestination(
            icon: Icon(Icons.palette),
            label: 'Custom',
          ),
          NavigationDestination(
            icon: Icon(Icons.web_asset),
            label: 'Dialog',
          ),
          NavigationDestination(
            icon: Icon(Icons.touch_app),
            label: 'Long Press',
          ),
          NavigationDestination(
            icon: Icon(Icons.article),
            label: 'Paragraph',
          ),
        ],
      ),
    );
  }
}

/// Basic usage demo.
class BasicDemoPage extends StatelessWidget {
  const BasicDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tap any word to see its definition:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: const [
                DictionaryText('Flutter'),
                DictionaryText('beautiful'),
                DictionaryText('framework'),
                DictionaryText('amazing'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom style demo.
class CustomStyleDemoPage extends StatelessWidget {
  const CustomStyleDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Custom Colors',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const DictionaryText(
              'programming',
              backgroundColor: Color(0xFFE3F2FD),
              selectedWordColor: Colors.blue,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Dark Background',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const DictionaryText(
              'technology',
              backgroundColor: Color(0xFF212121),
              selectedWordColor: Colors.amber,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Custom Definition Style',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          const DictionaryText(
            'innovation',
            definitionStyle: TextStyle(
              fontSize: 18,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog mode demo.
class DialogModeDemoPage extends StatelessWidget {
  const DialogModeDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dialog Display Mode',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Shows definition in a centered dialog',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: const [
                DictionaryText(
                  'creativity',
                  displayMode: DisplayMode.dialog,
                ),
                DictionaryText(
                  'inspiration',
                  displayMode: DisplayMode.dialog,
                ),
                DictionaryText(
                  'motivation',
                  displayMode: DisplayMode.dialog,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Long press mode demo.
class LongPressDemoPage extends StatelessWidget {
  const LongPressDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Long Press Trigger',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Hold the word to see its definition',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: const [
                DictionaryText(
                  'perseverance',
                  triggerMode: TriggerMode.longPress,
                ),
                DictionaryText(
                  'determination',
                  triggerMode: TriggerMode.longPress,
                ),
                DictionaryText(
                  'resilience',
                  triggerMode: TriggerMode.longPress,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Paragraph demo with multiple words.
class ParagraphDemoPage extends StatelessWidget {
  const ParagraphDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final words = [
      'Flutter',
      'is',
      'an',
      'open-source',
      'UI',
      'software',
      'development',
      'kit',
      'created',
      'by',
      'Google.',
      'It',
      'is',
      'used',
      'to',
      'develop',
      'cross-platform',
      'applications',
      'for',
      'Android,',
      'iOS,',
      'Linux,',
      'macOS,',
      'Windows,',
      'and',
      'the',
      'web',
      'from',
      'a',
      'single',
      'codebase.',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interactive Paragraph',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap any word to look it up:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: words
                .map((word) => DictionaryText(
                      word,
                      needGuide: false,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
