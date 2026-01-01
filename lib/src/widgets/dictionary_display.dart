import 'package:flutter/material.dart';

import '../controllers/dictionary_controller.dart';
import '../models/dictionary_error.dart';
import '../models/dictionary_model.dart';
import '../utils/color_utils.dart';

/// Widget that displays dictionary definition content.
///
/// Shows the word, phonetic, audio button, meanings, definitions,
/// and examples in a beautifully animated layout.
class DictionaryDisplay extends StatelessWidget {
  /// Creates a [DictionaryDisplay] instance.
  const DictionaryDisplay({
    required this.controller,
    super.key,
    this.backgroundColor,
    this.textColor,
    this.definitionStyle,
    this.onClose,
    this.loadingBuilder,
    this.errorBuilder,
  });

  /// The dictionary controller providing state.
  final DictionaryController controller;

  /// Background color for the display.
  final Color? backgroundColor;

  /// Text color for the display.
  final Color? textColor;

  /// Style for definition text.
  final TextStyle? definitionStyle;

  /// Callback when the close button is pressed.
  final VoidCallback? onClose;

  /// Custom loading widget builder.
  final Widget Function(BuildContext)? loadingBuilder;

  /// Custom error widget builder.
  final Widget Function(BuildContext, DictionaryError)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.scaffoldBackgroundColor;
    final txtColor = textColor ?? ColorUtils.getContrastingTextColor(bgColor);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(txtColor),
          Flexible(
            child: _buildContent(context, txtColor),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle(Color txtColor) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: txtColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Color txtColor) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return _buildLoading(context);
        }

        return ValueListenableBuilder<DictionaryError?>(
          valueListenable: controller.error,
          builder: (context, error, _) {
            if (error != null) {
              return _buildError(context, error, txtColor);
            }

            return ValueListenableBuilder<DictionaryModel?>(
              valueListenable: controller.currentDefinition,
              builder: (context, definition, _) {
                if (definition == null) {
                  return const SizedBox.shrink();
                }

                return _buildDefinition(context, definition, txtColor);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    if (loadingBuilder != null) {
      return loadingBuilder!(context);
    }

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Looking up definition...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    DictionaryError error,
    Color txtColor,
  ) {
    if (errorBuilder != null) {
      return errorBuilder!(context, error);
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: txtColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            error.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: txtColor,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            error.message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: txtColor.withValues(alpha: 0.7),
                ),
            textAlign: TextAlign.center,
          ),
          if (error.hasResolution) ...[
            const SizedBox(height: 8),
            Text(
              error.resolution!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: txtColor.withValues(alpha: 0.5),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          if (onClose != null)
            TextButton(
              onPressed: onClose,
              child: const Text('Close'),
            ),
        ],
      ),
    );
  }

  Widget _buildDefinition(
    BuildContext context,
    DictionaryModel definition,
    Color txtColor,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, definition, txtColor),
          const SizedBox(height: 20),
          ...definition.meanings.asMap().entries.map((entry) {
            return _buildMeaning(context, entry.value, txtColor, entry.key);
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    DictionaryModel definition,
    Color txtColor,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                definition.word,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: txtColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (definition.displayPhonetic != null)
                Text(
                  definition.displayPhonetic!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: txtColor.withValues(alpha: 0.6),
                        fontStyle: FontStyle.italic,
                      ),
                ),
            ],
          ),
        ),
        if (definition.hasAudio) _buildAudioButton(context, txtColor),
        if (onClose != null)
          IconButton(
            icon: Icon(Icons.close_rounded, color: txtColor),
            onPressed: onClose,
          ),
      ],
    );
  }

  Widget _buildAudioButton(BuildContext context, Color txtColor) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isPlayingAudio,
      builder: (context, isPlaying, _) {
        return IconButton(
          icon: Icon(
            isPlaying ? Icons.stop_rounded : Icons.volume_up_rounded,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            if (isPlaying) {
              controller.stopAudio();
            } else {
              controller.playAudio();
            }
          },
        );
      },
    );
  }

  Widget _buildMeaning(
    BuildContext context,
    meaning,
    Color txtColor,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              meaning.partOfSpeech,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(height: 12),
          ...meaning.definitions.asMap().entries.map((defEntry) {
            return _buildDefinitionItem(
              context,
              defEntry.value,
              txtColor,
              defEntry.key + 1,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDefinitionItem(
    BuildContext context,
    definition,
    Color txtColor,
    int number,
  ) {
    final defStyle = definitionStyle ??
        Theme.of(context).textTheme.bodyLarge?.copyWith(color: txtColor);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$number. ',
                style: defStyle?.copyWith(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(
                  definition.definition,
                  style: defStyle,
                ),
              ),
            ],
          ),
          if (definition.hasExample)
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 4),
              child: Text(
                '"${definition.example}"',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: txtColor.withValues(alpha: 0.6),
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
