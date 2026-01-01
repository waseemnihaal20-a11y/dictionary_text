import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../models/dictionary_error.dart';
import '../models/dictionary_model.dart';
import '../services/dictionary_service.dart';

/// Controller for managing dictionary lookup state.
///
/// Uses [ValueNotifier] for reactive state management without
/// requiring external state management packages.
///
/// Example:
/// ```dart
/// final controller = DictionaryController();
/// await controller.lookupWord('flutter');
/// print(controller.currentDefinition.value?.word);
/// controller.dispose();
/// ```
class DictionaryController {
  /// Creates a [DictionaryController] instance.
  ///
  /// Optionally accepts a custom [DictionaryService] and [AudioPlayer]
  /// for testing purposes.
  DictionaryController({
    DictionaryService? service,
    AudioPlayer? audioPlayer,
  })  : _service = service ?? DictionaryService(),
        _audioPlayer = audioPlayer ?? AudioPlayer();

  final DictionaryService _service;
  final AudioPlayer _audioPlayer;

  /// Whether a lookup is currently in progress.
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  /// The current dictionary definition, or null if none loaded.
  final ValueNotifier<DictionaryModel?> currentDefinition =
      ValueNotifier<DictionaryModel?>(null);

  /// The current error, or null if no error.
  final ValueNotifier<DictionaryError?> error =
      ValueNotifier<DictionaryError?>(null);

  /// Whether audio is currently playing.
  final ValueNotifier<bool> isPlayingAudio = ValueNotifier<bool>(false);

  bool _isDisposed = false;

  /// Looks up a word in the dictionary.
  ///
  /// Updates [isLoading], [currentDefinition], and [error] accordingly.
  ///
  /// [word] is the word to look up.
  Future<void> lookupWord(String word) async {
    if (_isDisposed) return;

    isLoading.value = true;
    error.value = null;
    currentDefinition.value = null;

    try {
      final definition = await _service.getDefinition(word);
      if (!_isDisposed) {
        currentDefinition.value = definition;
      }
    } on DictionaryError catch (e) {
      if (!_isDisposed) {
        error.value = e;
      }
    } catch (e) {
      if (!_isDisposed) {
        error.value = DictionaryError.unknown(e.toString());
      }
    } finally {
      if (!_isDisposed) {
        isLoading.value = false;
      }
    }
  }

  /// Plays the pronunciation audio if available.
  ///
  /// Does nothing if no audio URL is available or if already playing.
  Future<void> playAudio() async {
    if (_isDisposed) return;

    final audioUrl = currentDefinition.value?.audioUrl;
    if (audioUrl == null || audioUrl.isEmpty) return;

    try {
      isPlayingAudio.value = true;
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();

      _audioPlayer.playerStateStream.listen((state) {
        if (!_isDisposed) {
          if (state.processingState == ProcessingState.completed) {
            isPlayingAudio.value = false;
          }
        }
      });
    } catch (e) {
      if (!_isDisposed) {
        isPlayingAudio.value = false;
      }
    }
  }

  /// Stops the currently playing audio.
  Future<void> stopAudio() async {
    if (_isDisposed) return;

    try {
      await _audioPlayer.stop();
      isPlayingAudio.value = false;
    } catch (_) {
      isPlayingAudio.value = false;
    }
  }

  /// Clears the current definition and error state.
  void clear() {
    if (_isDisposed) return;

    currentDefinition.value = null;
    error.value = null;
    isLoading.value = false;
    isPlayingAudio.value = false;
  }

  /// Disposes of the controller and releases resources.
  ///
  /// Must be called when the controller is no longer needed.
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;

    _audioPlayer.dispose();
    isLoading.dispose();
    currentDefinition.dispose();
    error.dispose();
    isPlayingAudio.dispose();
  }
}
