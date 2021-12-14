/// A request and response utility of the backend communication
library request;

import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:meta/meta.dart';

import 'config.dart';
import 'errors.dart';
import 'interfaces.dart';
import 'renovation.dart';

part 'request.response.dart';

class ContentTypeLiterals {
  static const String QUERY_STRING = 'query_string';
  static const String APPLICATION_JSON = 'application/json';
  static const String APPLICATION_X_WWW_FORM_URLENCODED =
      'application/x-www-form-urlencoded';
  static const String MULTIPART_FORM_DATA = 'multipart/form-data';
}

enum RenovationError {
  AuthenticationError,
  PermissionError,
  NotFoundError,
  NetworkError,
  GenericError,
  DataFormatError,
  DuplicateEntryError,
  BackendSettingError
}

class Request {
  static String clientId;

  /// The [Dio] instance used in all network calls
  static final Dio _dio = Dio();

  /// Persistent cookie when JWT is not in use.
  ///
  /// Initialized when [setupPersistentCookie] is called
  static PersistCookieJar _cookieJar;

  /// Handles the raw request to a server
  ///
  /// Supported methods are *GET*, *POST*, *PUT*, *DELETE*,
  ///
  static Future<Response<String>> _httpRequest(
      String url, HttpMethod httpMethod, Map<String, dynamic> headers,
      {String contentType,
      Map<String, dynamic> data,
      Map<String, dynamic> queryParams}) async {
    final httpOptions = Options();
    ContentType _contentType;

    headers ??= RenovationRequestOptions.headers;

    if (data != null) {
      switch (contentType) {
        case ContentTypeLiterals.QUERY_STRING:
          _contentType = ContentType.parse('');
          break;
        case ContentTypeLiterals.APPLICATION_JSON:
          _contentType = ContentType.json;
          break;
        case ContentTypeLiterals.APPLICATION_X_WWW_FORM_URLENCODED:
          _contentType = ContentType.parse('application/x-www-form-urlencoded');
          break;
        case ContentTypeLiterals.MULTIPART_FORM_DATA:
          break;
        default:
          _contentType = ContentType.parse('');
      }
    } else {
      _contentType = ContentType.parse(''); //mandatory
    }

    if (clientId != null) {
      headers['X-Client-Site'] = clientId;
    }
    httpOptions.headers = headers;
    httpOptions.contentType = _contentType.value;

    switch (httpMethod) {
      case HttpMethod.GET:
        return _dio.get<String>(url,
            options: httpOptions, queryParameters: queryParams);
      case HttpMethod.POST:
        return _dio.post<String>(url,
            options: httpOptions, data: data, queryParameters: queryParams);
      case HttpMethod.PUT:
        return _dio.put<String>(url,
            options: httpOptions, data: data, queryParameters: queryParams);
      case HttpMethod.DELETE:
        return _dio.delete<String>(url,
            options: httpOptions, queryParameters: queryParams);
        break;
      default:
        throw RequestException(
            cause:
                'HTTP Method Not Implemented. Supported Methods are: GET, POST, PUT & DELETE');
    }
  }

  static Future<RequestResponse<FrappeResponse>> initiateRequest(
      {@required String url,
      @required HttpMethod method,
      String contentType,
      Map<String, dynamic> headers,
      Map<String, dynamic> data,
      Map<String, dynamic> queryParams,
      bool isFrappeResponse = true}) async {
    Response<dynamic> response;
    RequestResponse<FrappeResponse> r;
    try {
      response = await Request._httpRequest(url, method, headers,
          contentType: contentType, data: data, queryParams: queryParams);

      final frappeResponse = _buildFrappeResponse(response, isFrappeResponse);

      if ((response.statusCode / 100).floor() == 2) {
        r = RequestResponse.success<FrappeResponse>(frappeResponse);
      } else {
        final info =
            Information(httpCode: response.statusCode, data: response.data);
        final errorDetail = ErrorDetail(info: info);
        r = RequestResponse.fail(errorDetail);
      }
    } on DioError catch (err) {
      if (err.response != null) {
        final frappeResponse =
            _buildFrappeResponse(err.response, isFrappeResponse);
        final info = Information(
            httpCode: err.response?.statusCode,
            data: frappeResponse,
            rawError: err);
        final errorDetail = ErrorDetail(info: info);
        r = RequestResponse.fail(errorDetail);
      }
    }

    if (r != null) {
      _messageChecker(r);
      _errorChecker(r);
    } else {
      throw RequestException(
          cause: 'No FrappeResponse after initiateRequest',
          contentType: contentType,
          url: url,
          data: data,
          queryParams: queryParams,
          headers: headers);
    }

    r.rawResponse = response;
    return r;
  }

  static void setClientId(String id) {
    clientId = id;
    RenovationConfig.renovationInstance.logger.i('Client ID: $clientId');
  }

  static String getClientId() => clientId;

  static FrappeResponse _buildFrappeResponse(
      Response<dynamic> response, bool isFrappeResponse) {
    Map<String, dynamic> jsonResponse;
    final isJsonResponse = response.headers[Headers.contentTypeHeader][0] ==
        ContentType.json.value;
    if (isJsonResponse) {
      jsonResponse = json.decode(response.data);
    }
    var frappeResponse = FrappeResponse();
    if (isJsonResponse) {
      if (isFrappeResponse) {
        frappeResponse = FrappeResponse.fromJson(jsonResponse);
      } else {
        frappeResponse
          ..message = jsonResponse['data'] ?? jsonResponse
          ..serverMessages = jsonResponse['server_messages']
          ..exc = jsonResponse['exc']
          ..excType = jsonResponse['exc_type']
          ..exception = jsonResponse['exception']
          ..sessionExpired = jsonResponse['session_expired'];
      }
    } else {
      frappeResponse.message = response.data;
    }
    return frappeResponse;
  }

  static void _messageChecker(RequestResponse<FrappeResponse> response) {
    final Function addMessage = (dynamic message) {
      if (message is String) {
        message = json.decode(message);
      }
      RenovationConfig.renovationInstance.coreInstance.messages.add(message);
    };

    List<dynamic> serverMessagesArray;
    if (response.isSuccess && response.data.serverMessages != null) {
      serverMessagesArray = json.decode(response.data.serverMessages);

      serverMessagesArray.forEach(addMessage);
    }
    if ((!response.isSuccess &&
        response.error.info.data is FrappeResponse &&
        response.error.info.data.serverMessages != null)) {
      serverMessagesArray = List<String>.from(
          json.decode(response.error.info.data.serverMessages));

      serverMessagesArray.forEach(addMessage);
    }
  }

  static void _errorChecker(RequestResponse<FrappeResponse> r) {
    if (!r.isSuccess) {
      final Function excContains = (String sx) {
        if (r.error.info.data.exc != null) {
          return r.error.info.data.exc.contains(sx);
        }
        return false;
      };
      if (r.data != null) {
        if (r.data.sessionExpired == null || r.data.sessionExpired == 1) {
          Renovation().auth.resetSession();
        }
      }

      r.error ?? ErrorDetail();

      if (excContains('PermissionError')) {
        r.exc = RenovationError.PermissionError;
        r.error.type = RenovationError.PermissionError;
      } else if (excContains('AuthenticationError')) {
        r.exc = RenovationError.AuthenticationError;
        r.error.type = RenovationError.AuthenticationError;
      }
      if (r.error.info.data.serverMessages != null) {
        // Array of server message strings that still need to be decoded
        final serverMessagesArray =
            List<String>.from(json.decode(r.error.info.data.serverMessages));

        final serverMessagesArrayParsed = serverMessagesArray
            .map<Map<String, dynamic>>((String message) => json.decode(message))
            .toList();
        if (serverMessagesArrayParsed.isNotEmpty) {
          if (serverMessagesArrayParsed[0].containsKey('message')) {
            if (serverMessagesArrayParsed[0]['message'] == 'Invalid Request') {
              RenovationConfig.renovationInstance.logger
                  .e('Invalid Request. Best to re-login');
              try {
                RenovationConfig.renovationInstance.coreInstance.auth.logout();
              } on Exception catch (e) {
                RenovationConfig.renovationInstance.logger.e(e);
              }
              Renovation().auth.resetSession();
            }
          }
        }
      }
    }
  }

  /// Returns the JSON as a [Map] from the response, if any.
  static Map<String, dynamic> convertToMap(Response<dynamic> response) {
    if (response.data != null && isJsonResponse(response)) {
      return json.decode(response.data);
    }
    return null;
  }

  /// Returns `true` if the [Response] or [DioError] contains a JSON response.
  static bool isJsonResponse(Response<dynamic> response) =>
      response.headers[Headers.contentTypeHeader][0] ==
      ContentTypeLiterals.APPLICATION_JSON;

  /// Set [PersistCookieJar] with the directory path.
  static void setupPersistentCookie(PersistCookieJar cookieJar) {
    // If the interceptor wasn't added to Dio
    if (_dio.interceptors.whereType<CookieManager>().isEmpty) {
      _cookieJar = cookieJar;
      _dio.interceptors.add(CookieManager(_cookieJar));
    }
  }
}

class RequestException implements Exception {
  RequestException(
      {this.cause,
      this.url,
      this.data,
      this.queryParams,
      this.headers,
      this.contentType});

  String cause;
  String url;
  String contentType;
  dynamic data;
  dynamic queryParams;
  dynamic headers;

  @override
  String toString() =>
      <dynamic>[url, data, queryParams, headers, contentType].toString();
}

/// Static class holding the headers to be used by each request.
class RenovationRequestOptions {
  static Map<String, dynamic> headers;
}

enum HttpMethod { GET, POST, PUT, DELETE }
