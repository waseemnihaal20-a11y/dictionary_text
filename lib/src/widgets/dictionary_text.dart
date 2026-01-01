import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../config/tutorial_config.dart';
import '../controllers/dictionary_controller.dart';
import '../enums/display_mode.dart';
import '../enums/trigger_mode.dart';
import '../models/dictionary_error.dart';
import '../utils/storage_helper.dart';
import 'dictionary_display.dart';

/// A widget that transforms text into an interactive dictionary.
///
/// Each word in the text can be tapped to see its definition, pronunciation,
/// and examples in a beautifully animated bottom sheet or dialog.
///
/// Works like a [Text] widget but with dictionary lookup functionality.
///
/// Example:
/// ```dart
/// DictionaryText(
///   'Flutter is a beautiful framework',
///   style: TextStyle(fontSize: 16),
/// )
/// ```
class DictionaryText extends StatefulWidget {
  /// Creates a [DictionaryText] widget.
  ///
  /// The [data] parameter is the text to display and make interactive.
  const DictionaryText(
    this.data, {
    super.key,
    this.style,
    this.displayMode = DisplayMode.bottomSheet,
    this.triggerMode = TriggerMode.tap,
    this.backgroundColor,
    this.selectedWordColor,
    this.definitionStyle,
    this.loadingBuilder,
    this.errorBuilder,
    this.needGuide = true,
    this.guideConfig,
    this.enableHapticFeedback = true,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.textAlign = TextAlign.start,
  });

  /// The text to display.
  final String data;

  /// Style for the text.
  final TextStyle? style;

  /// How to display the dictionary definition.
  ///
  /// Defaults to [DisplayMode.bottomSheet].
  final DisplayMode displayMode;

  /// The gesture that triggers the dictionary lookup.
  ///
  /// Defaults to [TriggerMode.tap].
  final TriggerMode triggerMode;

  /// Background color for the dictionary display.
  final Color? backgroundColor;

  /// Color/style for the currently selected word.
  ///
  /// The selected word appears bold and slightly larger.
  /// Defaults to the theme's primary color if not specified.
  final Color? selectedWordColor;

  /// Style for the definition text in the display.
  final TextStyle? definitionStyle;

  /// Custom loading widget builder.
  final Widget Function(BuildContext)? loadingBuilder;

  /// Custom error widget builder.
  final Widget Function(BuildContext, DictionaryError)? errorBuilder;

  /// Whether to show the tutorial guide on first use.
  ///
  /// Defaults to `true`.
  final bool needGuide;

  /// Configuration for the tutorial guide.
  final TutorialConfig? guideConfig;

  /// Whether to provide haptic feedback on tap.
  ///
  /// Defaults to `true`.
  final bool enableHapticFeedback;

  /// Maximum number of lines for the text.
  final int? maxLines;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  @override
  State<DictionaryText> createState() => _DictionaryTextState();
}

class _DictionaryTextState extends State<DictionaryText> {
  late DictionaryController _controller;
  late StorageHelper _storageHelper;
  final GlobalKey _textKey = GlobalKey();
  TutorialCoachMark? _tutorialCoachMark;
  bool _tutorialChecked = false;
  String? _selectedWord;

  @override
  void initState() {
    super.initState();
    _controller = DictionaryController();
    _storageHelper = StorageHelper();
    _initTutorial();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initTutorial() async {
    if (!widget.needGuide) return;

    await _storageHelper.init();
    if (!_storageHelper.isTutorialShown && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_tutorialChecked) {
          _tutorialChecked = true;
          _showTutorial();
        }
      });
    }
  }

  void _showTutorial() {
    final config = widget.guideConfig ?? const TutorialConfig();
    final triggerText = widget.triggerMode == TriggerMode.tap ? 'Tap' : 'Hold';
    final description = config.description ??
        "Didn't understand any word? No worries. $triggerText any word to get its detailed dictionary!";

    _tutorialCoachMark = TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: 'dictionary_text_target',
          keyTarget: _textKey,
          alignSkip: Alignment.topRight,
          paddingFocus: config.paddingEdge,
          shape: ShapeLightFocus.RRect,
          radius: config.radius,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.title ?? 'Dictionary Feature',
                      style: config.titleStyle ??
                          const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: config.descriptionStyle ??
                          const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
      colorShadow: config.tooltipColor ?? Theme.of(context).primaryColor,
      textSkip: config.skipText,
      textStyleSkip: const TextStyle(color: Colors.white),
      onFinish: () {
        _storageHelper.setTutorialShown();
      },
      onSkip: () {
        _storageHelper.setTutorialShown();
        return true;
      },
    );

    _tutorialCoachMark?.show(context: context);
  }

  void _handleWordTap(String word) {
    if (widget.enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }

    final cleanWord = word.replaceAll(RegExp(r'[^\w]'), '');
    if (cleanWord.isEmpty) return;

    setState(() {
      _selectedWord = cleanWord;
    });

    _controller.lookupWord(cleanWord);
    _showDefinition();
  }

  void _handleWordLongPress(String word) {
    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    final cleanWord = word.replaceAll(RegExp(r'[^\w]'), '');
    if (cleanWord.isEmpty) return;

    setState(() {
      _selectedWord = cleanWord;
    });

    _controller.lookupWord(cleanWord);
    _showDefinition();
  }

  void _showDefinition() {
    if (widget.displayMode == DisplayMode.dialog) {
      _showDialog();
    } else {
      _showBottomSheet();
    }
  }

  void _showBottomSheet() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    double heightFactor;
    if (screenWidth < 600) {
      heightFactor = 0.85;
    } else if (screenWidth < 900) {
      heightFactor = 0.75;
    } else {
      heightFactor = 0.6;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxWidth: screenWidth > 900 ? 600 : double.infinity,
      ),
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: mediaQuery.size.height * heightFactor,
          ),
          child: DictionaryDisplay(
            controller: _controller,
            backgroundColor: widget.backgroundColor,
            definitionStyle: widget.definitionStyle,
            loadingBuilder: widget.loadingBuilder,
            errorBuilder: widget.errorBuilder,
            onClose: () => Navigator.of(context).pop(),
          ),
        );
      },
    ).whenComplete(() {
      _controller.stopAudio();
      setState(() {
        _selectedWord = null;
      });
    });
  }

  void _showDialog() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    double dialogWidth;
    if (screenWidth < 600) {
      dialogWidth = screenWidth * 0.9;
    } else if (screenWidth < 900) {
      dialogWidth = 500;
    } else {
      dialogWidth = 600;
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: dialogWidth,
              constraints: BoxConstraints(
                maxHeight: mediaQuery.size.height * 0.8,
              ),
              decoration: BoxDecoration(
                color: widget.backgroundColor ??
                    Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: DictionaryDisplay(
                  controller: _controller,
                  backgroundColor: widget.backgroundColor,
                  definitionStyle: widget.definitionStyle,
                  loadingBuilder: widget.loadingBuilder,
                  errorBuilder: widget.errorBuilder,
                  onClose: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      _controller.stopAudio();
      setState(() {
        _selectedWord = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = widget.style ?? DefaultTextStyle.of(context).style;
    final selectedColor =
        widget.selectedWordColor ?? Theme.of(context).primaryColor;

    final words = widget.data.split(' ');
    final spans = <InlineSpan>[];

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final cleanWord = word.replaceAll(RegExp(r'[^\w]'), '');
      final isSelected = _selectedWord != null &&
          cleanWord.toLowerCase() == _selectedWord!.toLowerCase();

      final isLastWord = i == words.length - 1;
      final displayText = isLastWord ? word : '$word ';

      if (isSelected) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: selectedColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                displayText.trim(),
                style: defaultStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: (defaultStyle.fontSize ?? 14) * 1.1,
                  color: selectedColor,
                ),
              ),
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: displayText,
            style: defaultStyle,
            recognizer: widget.triggerMode == TriggerMode.tap
                ? (TapGestureRecognizer()..onTap = () => _handleWordTap(word))
                : (LongPressGestureRecognizer()
                  ..onLongPress = () => _handleWordLongPress(word)),
          ),
        );
      }
    }

    return RichText(
      key: _textKey,
      text: TextSpan(children: spans, style: defaultStyle),
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}
