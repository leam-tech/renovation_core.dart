import 'package:meta/meta.dart';

import '../core/config.dart';
import '../core/renovation.controller.dart';
import '../core/request.dart';

/// Class handling the translations and setting the language
abstract class TranslationController extends RenovationController {
  TranslationController(RenovationConfig config) : super(config);

  /// The current set language. Defaults to English.
  @protected
  String currentLanguage = 'en';

  /// Messages dictionary holding translation maps of each language. Structure is:
  ///```
  /// {
  ///  'en': {
  ///     ----
  ///  },
  ///  'ar': {
  ///     ----
  ///  }
  /// }
  /// ```
  final Map<String, Map<String, String>> _messages =
      <String, Map<String, String>>{};

  /// Loads the translation of the selected language from the backend.
  Future<RequestResponse<Map<String, String>?>> loadTranslations(
      {String? lang});

  /// Returns the translated text paired with the key [txt].
  ///
  /// If [txt] doesn't exist for a certain language or the [lang] is not defined in the Map,
  ///
  /// [txt] is returned as-is.
  String? getMessage({required String? txt, String? lang}) {
    lang ??= currentLanguage;
    if (txt == null) {
      return txt;
    }
    return (_messages[lang] ?? <String, dynamic>{})[txt] ?? txt;
  }

  /// Sets the message dictionary for a certain language.
  ///
  /// Note: This will overwrite the existing map.
  ///
  /// If `null` is passed as [dict], an empty Map will be set instead.
  void setMessagesDict({required Map<String, String> dict, String? lang}) {
    lang ??= currentLanguage;
    _messages[lang] = dict;
  }

  /// Add translations to the existing Map.
  ///
  /// Unlike [setMessagesDict], this will not overwrite the existing map, just adds to it (or replace in case the key is duplicated).
  void extendDictionary({required Map<String, String>? dict, String? lang}) {
    lang ??= currentLanguage;
    if (dict != null) {
      _messages[lang] ??= <String, String>{};
      _messages[lang]?.addAll(dict);
    }
  }

  /// A setter for [currentLanguage]. Defaults to 'en'
  void setCurrentLanguage(String lang) => currentLanguage = lang;

  /// Returns the [currentLanguage].
  String? getCurrentLanguage() => currentLanguage;

  /// Removes all translations saved in messages dictionary.
  @override
  void clearCache() => _messages.clear();
}
