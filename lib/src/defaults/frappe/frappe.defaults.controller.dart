import 'dart:convert';

import 'package:meta/meta.dart';

import '../../auth/frappe/errors.dart';
import '../../core/config.dart';
import '../../core/errors.dart';
import '../../core/frappe/renovation.dart';
import '../../core/renovation.controller.dart';
import '../../core/request.dart';
import '../defaults.controller.dart';
import 'errors.dart';

/// Controller for getting and setting key-value pair in Frappé
class FrappeDefaultsController extends DefaultsController {
  FrappeDefaultsController(RenovationConfig config) : super(config);

  /// Renovation specific settings
  static final _renovationCustomSettings = ['disableSubmission'];

  /// Gets the value given the [key]. Can specify the [parent] if the key is duplicated under a different parent.
  ///
  /// Returns the value within [RequestResponse] and since the data can be saved in multiple data forms the type is [dynamic].
  ///
  /// If the key doesn't exist, data will be `null`.
  ///
  /// Throws [NotLoggedInUser] if the user is not logged in.
  @override
  Future<RequestResponse<dynamic>> getDefault(
      {@required String key, String parent = '__default'}) async {
    getFrappe().checkRenovationCoreInstalled();

    if (!config.coreInstance.auth.isLoggedIn) throw NotLoggedInUser();

    if (_renovationCustomSettings.contains(key)) {
      key = 'renovation:$key';
    }

    final response = await Request.initiateRequest(
        url:
            '${config.hostUrl}/api/method/renovation_core.utils.client.get_default',
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_X_WWW_FORM_URLENCODED,
        data: <String, dynamic>{'key': key, 'parent': parent});
    if (response.isSuccess) {
      return RequestResponse.success<dynamic>(response.data.message,
          rawResponse: response.rawResponse);
    } else {
      return RequestResponse.fail<dynamic>(handleError(null, response.error));
    }
  }

  /// Sets a default value in backend for a specified key and return nothing if successful.
  ///
  /// The [value] can only be [String], [bool], [num], [Map] or [List]. Otherwise, [InvalidDefaultsValue] will be thrown.
  ///
  /// Can specify the parent if the key is duplicated under a different parent.
  ///
  /// Throws [NotLoggedInUser] if the user is not logged in.
  @override
  Future<RequestResponse<dynamic>> setDefaults(
      {@required String key,
      @required dynamic value,
      String parent = '__default'}) async {
    if (!config.coreInstance.auth.isLoggedIn) throw NotLoggedInUser();

    dynamic _value;

    if (_renovationCustomSettings.contains(key)) {
      key = 'renovation:$key';
    }

    if (value == null ||
        value is! String &&
            value is! Map &&
            value is! List &&
            value is! bool &&
            value is! num) {
      throw InvalidDefaultsValue();
    }

    if (value is! String) {
      if (value is Map || value is List) {
        _value = jsonEncode(value);
      } else if (value is bool) {
        _value = value.toString();
      } else if (value is num) _value = value.toString();
    } else {
      _value = value;
    }

    final response = await Request.initiateRequest(
        url: '${config.hostUrl}/api/method/frappe.client.set_default',
        method: HttpMethod.POST,
        isFrappeResponse: false,
        contentType: ContentTypeLiterals.APPLICATION_X_WWW_FORM_URLENCODED,
        data: <String, dynamic>{'key': key, 'value': _value, 'parent': parent});

    if (response.isSuccess) {
      return RequestResponse.success<dynamic>(response.data.message);
    } else {
      return RequestResponse.fail<dynamic>(handleError(null, response.error));
    }
  }

  @override
  void clearCache() {}

  @override
  ErrorDetail handleError(String errorId, ErrorDetail error) =>
      RenovationController.genericError(error);
}
