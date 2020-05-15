import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../core.dart';
import '../../../model.dart';
import '../../core/config.dart';
import '../../core/errors.dart';
import '../../core/renovation.controller.dart';
import '../../core/request.dart';
import '../fcm.controller.dart';
import 'errors.dart';
import 'fcm_notification.model.dart';
import 'interfaces.dart';

/// Class for handling Frappe-specific functionality.
class Frappe extends RenovationController implements FCMController {
  Frappe(RenovationConfig config) : super(config) {
    loadAppVersions();
  }

  /// Holds the versions of each app as [AppVersion].
  final Map<String, AppVersion> _appVersions = <String, AppVersion>{};

  /// Whether the app versions are loaded
  bool appVersionsLoaded = false;

  /// Returns all the apps as a List of [AppVersion].
  List<AppVersion> get allAppVersions => _appVersions.values.toList();

  /// Returns the [AppVersion] of the app *frappe*.
  AppVersion get frappeVersion =>
      _appVersions.containsKey('frappe') ? _appVersions['frappe'] : null;

  /// Calls renovation_manager frappe site and the server will set.
  /// x-client-site cookie which is helpful in routing the requests.
  ///
  /// Returns the client id
  ///
  /// If the clientId is set, the saved clientId will be returned.
  ///
  /// Otherwise, it will be fetched from the backend using the app renovation_bench
  Future<RequestResponse<dynamic>> updateClientId() async {
    final id = Request.getClientId();
    if (id != null) {
      await verifyClientId(id);
      return RequestResponse.success<String>(id);
    }
    return await verifyClientId(id);
  }

  @override
  void clearCache() {}

  /// Verify the client ID from the backend.
  ///
  /// In case the client id is valid, it's returned within [RequestResponse].
  ///
  Future<RequestResponse<String>> verifyClientId(String id) async {
    if (id != null) {
      final r = await fetchId();
      if (!r.isSuccess) {
        config.logger.e(<String>[
          'Renovation Core: Failed to update clientId from renovation_bench',
          'Proceeding with the id from localStorage: $id'
        ]);
        return RequestResponse.success<String>('Using local clientID $id');
      } else if (r.data != id) {
        config.logger.e(<String>[
          'Renovation Core: localStorage and server clientId mismatch',
          'Reinitializing with clientId: ' + id
        ]);
      }
      Request.setClientId(r.data);
      await config.coreInstance.init(config.hostUrl, clientId: r.data);
    } else {
      final fetchedID = await fetchId();
      if (fetchedID.isSuccess) {
        Request.setClientId(fetchedID.data);
      } else {
        config.logger.e('Renovation Core: Failed fetching client id');
      }
      return RequestResponse.success<String>(fetchedID.data);
    }
    return RequestResponse.fail<String>(handleError(
        'verifyClientId',
        ErrorDetail(
            info: Information(
                cause: 'Client ID not defined',
                suggestion: 'Please define client id',
                httpCode: 400,
                data: 'Please define client id'))));
  }

  /// Helper method to get the ID from the backend
  Future<RequestResponse<String>> fetchId() async {
    final url = config.hostUrl;
    final data = <String, String>{'cmd': 'renovation_bench.get_client_id'};

    final options = Options();
    options.headers = <String, String>{
      'Accept': 'application/json',
      'content-type': 'application/json',
      'x-client-site': 'renovation_manager'
    };
    final dio = Dio();
    Response<String> response;
    Map<String, dynamic> jsonResponse;
    try {
      response = await dio.post<String>(url, data: data, options: options);

      if (response.statusCode / 100 == 2) {
        return RequestResponse.success<String>(
            json.decode(response.data)['message']);
      }

      jsonResponse = Request.convertToMap(response);
      return RequestResponse.fail<String>(handleError(
          'FetchId',
          ErrorDetail(
              info: Information(
                  httpCode: response.statusCode,
                  data: jsonResponse ?? response.data))));
    } on DioError catch (e) {
      return RequestResponse.fail<String>(handleError(
          'FetchId',
          ErrorDetail(
              info: Information(
                  httpCode: e.response.statusCode,
                  data: Request.isJsonResponse(e.response)
                      ? Request.convertToMap(e.response)
                      : e.response.data,
                  rawError: e))));
    }
  }

  /// Register the currently signed in user with an FCM Token.
  ///
  /// If the token is already registered, the backend will silently returning a success.
  @override
  Future<RequestResponse<String>> registerFCMToken(String token) async {
    await checkAppInstalled(features: ['registerFCMToken']);

    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: <String, dynamic>{
          'cmd': 'renovation_core.utils.fcm.register_client',
          'token': token
        });

    if (response.isSuccess == true) {
      return RequestResponse.success(response.data.message,
          rawResponse: response.rawResponse);
    }
    response.isSuccess = false;
    return RequestResponse.fail(handleError(
        'fcm_register_client',
        response.error ??
            ErrorDetail(
                info: Information(
                    data: response.data,
                    httpCode: response.httpCode,
                    rawResponse: response.rawResponse)
                  ..rawError = response?.error?.info?.rawError)));
  }

  /// Removes the token from the currently signed in user.
  ///
  /// If it fails, a failure is returned and the user should not be logged out.
  @override
  Future<RequestResponse<FrappeResponse>> unregisterFCMToken(
      String token) async {
    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: <String, dynamic>{'cmd': 'logout', 'fcm_token': token});

    if (response.isSuccess == true) {
      return RequestResponse.success(response.data,
          rawResponse: response.rawResponse);
    }
    response.isSuccess = false;
    return RequestResponse.fail(handleError(
        'fcm_unregister_client',
        response.error ??
            ErrorDetail(
                info: Information(
                    data: response.data,
                    httpCode: response.httpCode,
                    rawResponse: response.rawResponse)
                  ..rawError = response?.error?.info?.rawError)));
  }

  /// Returns a list of [FCMNotification] of a user.
  ///
  /// Optionally, can set [seen] to true to get only seen notifications.
  @override
  Future<RequestResponse<List<FCMNotification>>> getFCMNotifications(
      {bool seen}) async {
    await checkAppInstalled(features: ['getFCMNotifications']);

    var requestData = <String, dynamic>{
      'cmd': 'renovation_core.utils.fcm.get_user_notifications'
    };
    if (seen != null) {
      requestData.addAll(<String, dynamic>{
        'filters': {'seen': FrappeDocFieldConverter.boolToCheck(seen)}
      });
    }

    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: requestData);

    if (response.isSuccess == true) {
      if (response.data != null && response.data.message is List) {
        List<dynamic> jsonArray = response.data.message;
        var notifications = List<FCMNotification>.of(jsonArray.map(
            (dynamic notification) => FCMNotification.fromJson(notification)));
        return RequestResponse.success(notifications);
      }
    }
    response.isSuccess = false;
    return RequestResponse.fail(handleError(
        'fcm_notification',
        ErrorDetail(
            info: Information(
                data: response.data,
                rawResponse: response.rawResponse,
                httpCode: response.httpCode))));
  }

  /// Mark notification as seen in the backend.
  @override
  Future<RequestResponse<dynamic>> markFCMNotificationsAsSeen(
      String messageId) async {
    await checkAppInstalled(features: ['markFCMNotificationsAsSeen']);

    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: <String, dynamic>{
          'cmd': 'renovation_core.utils.fcm.mark_notification_seen',
          'message_id': messageId,
          'seen': 1
        });

    if (response.isSuccess == true) {
      if (response.data != null && response.data.message is String) {
        response.data = response.data.message;
        return response;
      }
    }
    response.isSuccess = false;
    return RequestResponse.fail<String>(handleError(
        'fcm_notification_mark',
        response.error ??
            ErrorDetail(
                info: Information(
                    data: response.data,
                    httpCode: response.httpCode,
                    rawResponse: response.rawResponse)
                  ..rawError = response?.error?.info?.rawError)));
  }

  /// Loads the apps installed in Frappé site and their versions.
  ///
  /// Sets [_appVersions] on successful loading and returning `true` within `RequestResponse`.
  ///
  /// If loading fails, a failure is returned.
  Future<RequestResponse<bool>> loadAppVersions() async {
    final response = await config.coreInstance.call(
        <String, dynamic>{'cmd': 'renovation_core.utils.site.get_versions'});

    appVersionsLoaded = true;

    if (response.isSuccess) {
      final version = response.data.message as Map<String, dynamic>;
      if (version != null) {
        version.forEach((String k, dynamic v) {
          _appVersions[k] = AppVersion.fromString(k, v);
        });
      }
      return RequestResponse.success(true, rawResponse: response.rawResponse);
    }
    return RequestResponse.fail(handleError('errorId',
        response.error ?? ErrorDetail(title: 'Error getting app versions')));
  }

  /// Returns the [AppVersion] of a certain app [appName].
  ///
  /// Returns `null` if the app doesn't exist in the map [_appVersions].
  AppVersion getAppsVersion(String appName) =>
      _appVersions.containsKey(appName) ? _appVersions[appName] : null;

  /// Silent method throwing an error [AppNotInstalled] if [appName] is not installed in the backend and [throwError] is set.
  ///
  /// To be used in controller's methods where the endpoints are defined in a custom app.
  ///
  /// When [throwError] is set to `false`, the method will just wait for the appVersions to load.
  ///
  /// Specify the [features] to be used for the app.
  ///
  /// [appName] defaults to 'renovation_core'
  /// [throwError] defaults to `true`
  ///
  Future<void> checkAppInstalled(
      {@required List<String> features,
      bool throwError = true,
      String appName = 'renovation_core'}) async {
    while (!appVersionsLoaded) {
      await Future<dynamic>.delayed(Duration(milliseconds: 100));
    }

    if (!_appVersions.containsKey(appName) && throwError) {
      throw AppNotInstalled(appName, features);
    }
  }

  @override
  ErrorDetail handleError(String errorId, ErrorDetail error) {
    switch (errorId) {
      case 'verifyClientId':
        error..title = 'Client ID Verification Error';
        break;
      case 'FetchId':
        error..title = 'Failed to Fetch Id';
        break;
      case 'Fetch-id-badrequest':
        error..title = 'Fetch Id Bad Request!';
        break;
      case 'fcm_register_client':
        error..title = 'Failed to register token!';
        break;
      case 'fcm_unregister_client':
        error..title = 'Failed to unregister token!';
        break;
      case 'fcm_notification':
        error..title = 'Failed to retrieve notification list!';
        break;
      case 'fcm_notification_mark':
        error..title = 'Failed to mark notification as seen!';
        break;
      default:
        error = RenovationController.genericError(error);
    }
    return error;
  }
}
