import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../controllers/dictionary_controller.dart';
import '../models/dictionary_error.dart';
import '../models/dictionary_model.dart';

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
    final colorScheme = theme.colorScheme;
    final bgColor = backgroundColor ?? theme.scaffoldBackgroundColor;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(colorScheme),
          _buildHeader(context, theme, colorScheme),
          Flexible(
            child: _buildContent(context, theme, colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return ValueListenableBuilder<DictionaryModel?>(
      valueListenable: controller.currentDefinition,
      builder: (context, definition, _) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      definition?.word ?? 'Loading...',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (definition?.displayPhonetic != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        definition!.displayPhonetic!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (definition?.phonetics.isNotEmpty == true &&
                  definition!.phonetics.first.audio != null)
                ValueListenableBuilder<bool>(
                  valueListenable: controller.isPlayingAudio,
                  builder: (context, isPlaying, _) {
                    return IconButton.filled(
                      onPressed: isPlaying
                          ? controller.stopAudio
                          : controller.playAudio,
                      icon: Icon(
                        isPlaying
                            ? Icons.stop_rounded
                            : Icons.volume_up_rounded,
                      ),
                    ).animate().scaleXY(
                          begin: 1.0,
                          end: 1.1,
                          duration: 500.ms,
                          curve: Curves.easeInOut,
                        );
                  },
                ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onClose ?? () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return _buildLoading(context, colorScheme);
        }

        return ValueListenableBuilder<DictionaryError?>(
          valueListenable: controller.error,
          builder: (context, error, _) {
            if (error != null) {
              return _buildError(context, theme, colorScheme, error);
            }

            return ValueListenableBuilder<DictionaryModel?>(
              valueListenable: controller.currentDefinition,
              builder: (context, definition, _) {
                if (definition == null) {
                  return _buildEmpty(theme, colorScheme);
                }

                return _buildDefinition(
                    context, theme, colorScheme, definition);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLoading(BuildContext context, ColorScheme colorScheme) {
    if (loadingBuilder != null) {
      return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 300),
        child: loadingBuilder!(context),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 300),
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Looking up definition...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    DictionaryError error,
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
            size: 64,
            color: colorScheme.error.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          Text(
            error.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            error.message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (error.resolution != null) ...[
            const SizedBox(height: 8),
            Text(
              error.resolution!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmpty(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Text(
          'No definitions available',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildDefinition(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    DictionaryModel definition,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final meaning in definition.meanings)
            _buildMeaning(theme, colorScheme, meaning),
        ],
      ),
    );
  }

  Widget _buildMeaning(
    ThemeData theme,
    ColorScheme colorScheme,
    dynamic meaning,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              meaning.partOfSpeech,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < meaning.definitions.length && i < 3; i++)
            _buildDefinitionItem(
                theme, colorScheme, meaning.definitions[i], i + 1),
        ],
      ),
    );
  }

  Widget _buildDefinitionItem(
    ThemeData theme,
    ColorScheme colorScheme,
    dynamic def,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  def.definition,
                  style: definitionStyle ?? theme.textTheme.bodyMedium,
                ),
                if (def.example != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        left: BorderSide(color: colorScheme.primary, width: 3),
                      ),
                    ),
                    child: Text(
                      '"${def.example}"',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
