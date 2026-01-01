/// A beautiful, customizable Flutter widget that transforms any text into
/// an interactive dictionary.
///
/// Tap or hold any word to see definitions, pronunciations, and examples
/// in a beautifully animated bottom sheet or dialog.
///
/// ## Getting Started
///
/// ```dart
/// import 'package:dictionary_text/dictionary_text.dart';
///
/// DictionaryText(
///   text: 'Flutter',
///   displayMode: DisplayMode.bottomSheet,
///   triggerMode: TriggerMode.tap,
/// )
/// ```
library;

export 'src/config/dictionary_config.dart';
export 'src/config/tutorial_config.dart';
export 'src/controllers/dictionary_controller.dart';
export 'src/enums/display_mode.dart';
export 'src/enums/trigger_mode.dart';
export 'src/models/definition_model.dart';
export 'src/models/dictionary_error.dart';
export 'src/models/dictionary_model.dart';
export 'src/models/meaning_model.dart';
export 'src/models/phonetic_model.dart';
export 'src/services/dictionary_service.dart';
export 'src/utils/color_utils.dart';
export 'src/utils/storage_helper.dart';
export 'src/widgets/animated_text_wrapper.dart';
export 'src/widgets/dictionary_display.dart';
export 'src/widgets/dictionary_text.dart';
