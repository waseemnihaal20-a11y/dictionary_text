import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../config/dictionary_config.dart';
import '../config/tutorial_config.dart';
import '../controllers/dictionary_controller.dart';
import '../enums/display_mode.dart';
import '../enums/trigger_mode.dart';
import '../models/dictionary_error.dart';
import '../services/dictionary_service.dart';
import '../utils/color_utils.dart';
import '../utils/storage_helper.dart';
import 'animated_text_wrapper.dart';
import 'dictionary_display.dart';

/// A widget that transforms text into an interactive dictionary.
///
/// Tap or hold any word to see definitions, pronunciations, and examples
/// in a beautifully animated bottom sheet or dialog.
///
/// Example:
/// ```dart
/// DictionaryText(
///   text: 'Flutter is beautiful',
///   displayMode: DisplayMode.bottomSheet,
///   triggerMode: TriggerMode.tap,
/// )
/// ```
class DictionaryText extends StatefulWidget {
  /// Creates a [DictionaryText] widget.
  ///
  /// [text] is the text to display and make interactive.
  const DictionaryText({
    required this.text,
    super.key,
    this.displayMode = DisplayMode.bottomSheet,
    this.triggerMode = TriggerMode.tap,
    this.backgroundColor,
    this.selectedTextColor,
    this.textStyle,
    this.definitionStyle,
    this.loadingBuilder,
    this.errorBuilder,
    this.needGuide = true,
    this.guideConfig,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
    this.enableHapticFeedback = true,
    this.service,
    this.controller,
    this.storageHelper,
  });

  /// The text to display.
  final String text;

  /// How to display the dictionary definition.
  ///
  /// Defaults to [DisplayMode.bottomSheet].
  final DisplayMode displayMode;

  /// The gesture that triggers the dictionary lookup.
  ///
  /// Defaults to [TriggerMode.tap].
  final TriggerMode triggerMode;

  /// Background color for the dictionary display.
  ///
  /// Text color is automatically calculated based on luminosity.
  final Color? backgroundColor;

  /// Color of the text when it is selected/tapped.
  ///
  /// Defaults to the theme's primary color if not specified.
  final Color? selectedTextColor;

  /// Style for the main text widget.
  final TextStyle? textStyle;

  /// Style for the definition text.
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

  /// Duration of animations.
  ///
  /// Defaults to 300 milliseconds.
  final Duration animationDuration;

  /// Curve used for animations.
  ///
  /// Defaults to [Curves.easeOutCubic].
  final Curve animationCurve;

  /// Whether to provide haptic feedback on tap.
  ///
  /// Defaults to `true`.
  final bool enableHapticFeedback;

  /// Optional custom dictionary service for testing.
  final DictionaryService? service;

  /// Optional custom dictionary controller for testing.
  final DictionaryController? controller;

  /// Optional storage helper for testing.
  final StorageHelper? storageHelper;

  /// Creates a [DictionaryConfig] from this widget's properties.
  DictionaryConfig get config => DictionaryConfig(
        displayMode: displayMode,
        triggerMode: triggerMode,
        backgroundColor: backgroundColor,
        selectedTextColor: selectedTextColor,
        textStyle: textStyle,
        definitionStyle: definitionStyle,
        animationDuration: animationDuration,
        animationCurve: animationCurve,
        enableHapticFeedback: enableHapticFeedback,
      );

  @override
  State<DictionaryText> createState() => _DictionaryTextState();
}

class _DictionaryTextState extends State<DictionaryText> {
  late DictionaryController _controller;
  late StorageHelper _storageHelper;
  final GlobalKey _textKey = GlobalKey();
  TutorialCoachMark? _tutorialCoachMark;
  bool _tutorialChecked = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? DictionaryController(service: widget.service);
    _storageHelper = widget.storageHelper ?? StorageHelper();
    _initTutorial();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
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

  void _handleWordTap() {
    _controller.lookupWord(widget.text);
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = widget.selectedTextColor ?? theme.primaryColor;
    final textColor = widget.backgroundColor != null
        ? ColorUtils.getContrastingTextColor(widget.backgroundColor!)
        : null;

    final textStyle = widget.textStyle?.copyWith(color: textColor) ??
        theme.textTheme.bodyLarge?.copyWith(color: textColor);

    return AnimatedTextWrapper(
      key: _textKey,
      onTrigger: _handleWordTap,
      triggerOnTap: widget.triggerMode == TriggerMode.tap,
      selectedColor: selectedColor,
      animationDuration: widget.animationDuration,
      animationCurve: widget.animationCurve,
      enableHapticFeedback: widget.enableHapticFeedback,
      child: Text(
        widget.text,
        style: textStyle,
      ),
    );
  }
}
