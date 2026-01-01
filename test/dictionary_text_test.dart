import 'package:flutter_test/flutter_test.dart';

import 'models/definition_model_test.dart' as definition_model_test;
import 'models/dictionary_error_test.dart' as dictionary_error_test;
import 'models/dictionary_model_test.dart' as dictionary_model_test;
import 'models/meaning_model_test.dart' as meaning_model_test;
import 'models/phonetic_model_test.dart' as phonetic_model_test;
import 'utils/color_utils_test.dart' as color_utils_test;
import 'utils/storage_helper_test.dart' as storage_helper_test;
import 'services/dictionary_service_test.dart' as dictionary_service_test;
import 'controllers/dictionary_controller_test.dart'
    as dictionary_controller_test;
import 'widgets/animated_text_wrapper_test.dart' as animated_text_wrapper_test;
import 'widgets/dictionary_display_test.dart' as dictionary_display_test;
import 'widgets/dictionary_text_test.dart' as dictionary_text_test;
import 'integration/full_flow_test.dart' as full_flow_test;

void main() {
  group('Models', () {
    phonetic_model_test.main();
    definition_model_test.main();
    meaning_model_test.main();
    dictionary_model_test.main();
    dictionary_error_test.main();
  });

  group('Utils', () {
    color_utils_test.main();
    storage_helper_test.main();
  });

  group('Services', () {
    dictionary_service_test.main();
  });

  group('Controllers', () {
    dictionary_controller_test.main();
  });

  group('Widgets', () {
    animated_text_wrapper_test.main();
    dictionary_display_test.main();
    dictionary_text_test.main();
  });

  group('Integration', () {
    full_flow_test.main();
  });
}
