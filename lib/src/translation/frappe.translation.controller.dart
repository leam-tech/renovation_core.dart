import './translation.controller.dart';
import '../core/config.dart';
import '../core/errors.dart';
import '../core/renovation.controller.dart';
import '../core/request.dart';

/// Class handling the translation of Frappe
class FrappeTranslationController extends TranslationController {
  FrappeTranslationController(RenovationConfig config) : super(config);

  /// Returns the translations of the selected language from the backend of Frappé.
  ///
  /// In addition, sets the local dictionary through [setMessagesDict].
  ///
  /// If lang is not passed, the [currentLanguage] is used instead.
  @override
  Future<RequestResponse<Map<String, String>>> loadTranslations(
      {String lang}) async {
    lang ??= currentLanguage;
    final response = await Request.initiateRequest(
        url: config.hostUrl +
            '/api/method/renovation_core.utils.client.get_lang_dict',
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_X_WWW_FORM_URLENCODED,
        data: <String, dynamic>{'lang': lang});
    if (response.isSuccess) {
      setMessagesDict(
          dict: Map<String, String>.from(response.data.message), lang: lang);
    } else {
      return RequestResponse.fail(
          handleError('loadtranslation', response.error));
    }
    return RequestResponse.success(Map.from(response.data.message),
        rawResponse: response.rawResponse);
  }

  @override
  ErrorDetail handleError(String errorId, ErrorDetail error) {
    ErrorDetail err;
    switch (errorId) {
      case 'loadtranslation':
      default:
        err = RenovationController.genericError(error);
    }
    return err;
  }
}
