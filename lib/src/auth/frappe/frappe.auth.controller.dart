import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../core/config.dart';
import '../../core/errors.dart';
import '../../core/frappe/renovation.dart';
import '../../core/renovation.controller.dart';
import '../../core/request.dart';
import '../auth.controller.dart';
import '../interfaces.dart';
import 'errors.dart';
import 'interfaces.dart';

/// An extension of [AuthController] containing authentication properties and methods specific to Frappé.
///
/// Authentication methods include standard email/pwd login, OTP login, updating session, etc..
class FrappeAuthController extends AuthController<FrappeSessionStatusInfo> {
  /// If [sessionStatusInfo] is not null, the session and the token will be set locally.
  ///
  /// This can be useful, if the session was stored in "SharedPreferences", for instance where the controller can be initialized with a previous session.
  FrappeAuthController(RenovationConfig config,
      {FrappeSessionStatusInfo sessionStatusInfo})
      : super(config, sessionStatusInfo: sessionStatusInfo) {
    final isSessionProvided = sessionStatusInfo != null;

    if (isSessionProvided) {
      updateSession(
          sessionStatus: sessionStatusInfo,
          loggedIn: sessionStatusInfo.loggedIn,
          useTimestamp: sessionStatusInfo.timestamp);

      if (sessionStatusInfo.token != null) {
        setAuthToken(sessionStatusInfo.token);
      }
    }
  }

  /// The header to which the token is prepended to according to the requirement of the backend.
  static const String TOKEN_HEADER = 'JWTToken';

  /// Whether to authenticate using JWT. If set to false, will use cookies.
  bool _useJwt = false;

  /// Returns the current JWT token formatted as `TOKEN_HEADER token`.
  @override
  String getCurrentToken() =>
      currentToken != null ? '$TOKEN_HEADER $currentToken' : null;

  /// Set the value for whether to use JWT authentication
  void enableJWT(bool useJwt) {
    if (getFrappe().getAppsVersion('renovation_core') == null && useJwt) {
      getFrappe().checkAppInstalled(features: ['Login using JWT']);
    } else {
      _useJwt = useJwt;
    }
  }

  /// Checks the session's status (Whether the user is logged in or not) and returns it as [FrappeSessionStatusInfo].
  ///
  /// If it exists locally, the status will be compared between the server's session.
  ///
  /// Only if [shouldUpdateSession] is set to `true`, the [sessionStatus] will be updated.
  ///
  /// By default, [sessionStatus] is updated.
  @override
  Future<RequestResponse<FrappeSessionStatusInfo>> checkLogin(
      {bool shouldUpdateSession = true}) async {
    var currentSession = getSession();
    if (currentSession != null && currentSession.loggedIn) {
      return await verifySessionWithBackend(currentSession,
          shouldUpdateSession: shouldUpdateSession);
    } else {
      // no login info or not logged in
      currentSession = FrappeSessionStatusInfo(false,
          (DateTime.now().millisecondsSinceEpoch / 1000).floor().toDouble());
      return RequestResponse.fail(
          ErrorDetail(info: Information(httpCode: 403, data: currentSession)));
    }
  }

  /// Logs in the user (if successful) using [email] & [password]. The session ([sessionStatus]) is updated accordingly.
  ///
  /// Returns [FrappeSessionStatusInfo] whether successful or not, wrapped within [RequestResponse].
  ///
  /// [password] is optional.
  @override
  Future<RequestResponse<FrappeSessionStatusInfo>> login(String email,
      [String password]) async {
    final response = await Request.initiateRequest(
        url: config.hostUrl + '/api/method/login',
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_X_WWW_FORM_URLENCODED,
        data: <String, dynamic>{
          'usr': email,
          'pwd': password,
          'use_jwt': _useJwt ? 1 : 0
        },
        isFrappeResponse: false);

    SessionStatusInfo sessionStatusInfo;
    if (response.isSuccess) {
      sessionStatusInfo = FrappeSessionStatusInfo.fromJson(
          Request.convertToMap(response.rawResponse));

      sessionStatusInfo.rawSession = Request.convertToMap(response.rawResponse);
    }
    updateSession(
        loggedIn: response.isSuccess, sessionStatus: sessionStatusInfo);

    return response.isSuccess
        ? RequestResponse.success(sessionStatusInfo,
            rawResponse: response.rawResponse)
        : RequestResponse.fail(handleError('login', response.error));
  }

  /// Logs in the user (if successful) using [user] & [pin]. The session ([sessionStatus]) is updated accordingly.
  ///
  /// Returns the [FrappeSessionStatusInfo] whether successful or not, wrapped within [RequestResponse].
  ///
  /// [pin] is usually a 4-digit.
  @override
  Future<RequestResponse<FrappeSessionStatusInfo>> pinLogin(
      String user, String pin) async {
    await getFrappe().checkAppInstalled(features: ['pinLogin']);

    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: <String, dynamic>{
          'cmd': 'renovation_core.utils.auth.pin_login',
          'user': user,
          'pin': pin
        });
    SessionStatusInfo sessionStatusInfo;
    if (response.isSuccess) {
      sessionStatusInfo = FrappeSessionStatusInfo.fromJson(
          Request.convertToMap(response.rawResponse));
      sessionStatusInfo.rawSession = Request.convertToMap(response.rawResponse);
    }
    updateSession(
        sessionStatus: sessionStatusInfo, loggedIn: response.isSuccess);
    return response.isSuccess
        ? RequestResponse.success(sessionStatusInfo,
            rawResponse: response.rawResponse)
        : RequestResponse.fail(handleError('pin_login', response.error));
  }

  /// Sends a request to the backend with the mobile number. The response is a [SendOTPResponse].
  ///
  /// If [newOTP] is `true`, a previously sent OTP, won't be used. Instead a fresh one will be generated.
  ///
  /// By default [newOTP] is `false`.
  ///
  /// There are multiple reasons where this request will respond with failure which include:
  ///
  ///
  /// - SMS Settings not configured in the backend.
  /// - The mobile number is wrongly formatted.
  /// - The SMS provider responded with an error.
  @override
  Future<RequestResponse<SendOTPResponse>> sendOTP(String mobileNo,
      {bool newOTP = false}) async {
    await getFrappe().checkAppInstalled(features: ['sendOTP']);

    final response = await Request.initiateRequest(
        url: config.hostUrl + '/api/method/renovation/auth.sms.generate',
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_X_WWW_FORM_URLENCODED,
        data: <String, dynamic>{'mobile': mobileNo, 'newPIN': newOTP ? 1 : 0});

    SendOTPResponse sendOTPResponse;

    if (response.isSuccess) {
      sendOTPResponse =
          SendOTPResponse.fromJson(Request.convertToMap(response.rawResponse));
    }
    if (sendOTPResponse != null && sendOTPResponse.status == 'fail') {
      response.error = ErrorDetail()
        ..title = 'SMS was not sent'
        ..type = RenovationError.BackendSettingError
        ..info = (Information()
          ..httpCode = 400
          ..data = response.data
          ..cause = 'SMS settings may not be set'
          ..rawResponse = response.rawResponse);
      response.isSuccess = false;
    }

    return response.isSuccess
        ? RequestResponse.success(sendOTPResponse,
            rawResponse: response.rawResponse)
        : RequestResponse.fail(handleError('send_otp', response.error));
  }

  /// Verifies the [otp] entered by the user against the one sent through [sendOTP].
  ///
  /// If [loginToUser] is true, the [sessionStatus] will be updated with the new session part of the API response.
  ///
  /// In all cases, it returns the response [VerifyOTPResponse].
  @override
  Future<RequestResponse<VerifyOTPResponse>> verifyOTP(
      String mobileNo, String otp, bool loginToUser) async {
    await getFrappe().checkAppInstalled(features: ['verifyOTP']);

    final response = await Request.initiateRequest(
        url: config.hostUrl + '/api/method/renovation/auth.sms.verify',
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_X_WWW_FORM_URLENCODED,
        isFrappeResponse: false,
        data: <String, dynamic>{
          'mobile': mobileNo,
          'pin': otp,
          'loginToUser': loginToUser ? 1 : 0,
          'use_jwt': _useJwt ? 1 : 0
        });

    VerifyOTPResponse verifyOTPResponse;

    if (response.isSuccess) {
      verifyOTPResponse = VerifyOTPResponse.fromJson(response.data.message);
      if (verifyOTPResponse.status != 'verified') {
        response.isSuccess = false;
      } else {
        // successful login
        if (loginToUser) {
          // update session
          // response.data.user is expected from renovation_core

          final sessionStatusInfo =
              FrappeSessionStatusInfo.fromJson(response.data.message);
          sessionStatusInfo.rawSession =
              Request.convertToMap(response.rawResponse);

          updateSession(loggedIn: true, sessionStatus: sessionStatusInfo);
        }
      }
    }

    if (!response.isSuccess && response.error == null) {
      response.error = ErrorDetail(
          info: Information(
              data: verifyOTPResponse,
              httpCode: response.httpCode,
              rawResponse: response.rawResponse));
    }

    return response.isSuccess
        ? RequestResponse.success(verifyOTPResponse,
            rawResponse: response.rawResponse)
        : RequestResponse.fail(handleError('verify_otp', response.error));
  }

  /// Returns an array of roles assigned to the currently logged in user.
  @override
  Future<RequestResponse<List<String>>> getCurrentUserRoles() async {
    await getFrappe().checkAppInstalled(features: ['getCurrentUserRoles']);

    final response = await Request.initiateRequest(
        url: config.hostUrl +
            '/api/method/renovation_core.utils.client.get_current_user_roles',
        method: HttpMethod.GET);

    if (response.isSuccess && response.data != null) {
      final map = Request.convertToMap(response.rawResponse);

      // Since the return is List<dynamic>
      currentUserRoles = <String>[...map['message']];
    } else {
      currentUserRoles = null;
    }

    return response.isSuccess
        ? RequestResponse.success(currentUserRoles,
            rawResponse: response.rawResponse)
        : handleError('get_current_user_roles', response.error);
  }

  /// Logs out the current user.
  ///
  /// Updated the local session as a non-logged in user through [updateSession].
  @override
  Future<RequestResponse<dynamic>> logout() async {
    updateSession(loggedIn: false);
    final RequestResponse<dynamic> response = await Request.initiateRequest(
        url: config.hostUrl + '/api/method/frappe.handler.logout',
        method: HttpMethod.GET);
    return response;
  }

  /// Updates the session locally.
  ///
  /// The [AuthController.sessionStatus] `BehaviorSubject` is updated if the new session [sessionStatus] is different than the old one.
  ///
  /// If the sessions match, nothing happens.
  ///
  /// If [useTimestamp] is specified, it will be used as the timestamp of the new session, otherwise, the current timestamp will be used.
  @override
  @protected
  @visibleForTesting
  void updateSession(
      {FrappeSessionStatusInfo sessionStatus,
      bool loggedIn = false,
      double useTimestamp}) {
    // Update when old and new status  don't match
    final old = getSession() ?? FrappeSessionStatusInfo(false, 0);
    final newStatus = sessionStatus ?? FrappeSessionStatusInfo(false, 0);

    newStatus
      ..loggedIn = loggedIn
      ..timestamp = 0;
    if (loggedIn) {
      newStatus.currentUser = sessionStatus.user;
    }
    newStatus.timestamp = null;
    newStatus.homePage = null;
    newStatus.message = null;
    old.timestamp = null;
    old.homePage = null;
    old.message = null;

    // check for old-new mismatch
    if (!identical(old, newStatus)) {
      final token = newStatus.token;

      // lets clear cache before everything else
      getCore().clearCache();

      // its better to update the BehaviorSubject before doing anything else
      final session = newStatus;
      newStatus.timestamp =
          useTimestamp ?? (DateTime.now().millisecondsSinceEpoch / 1000);

      if (newStatus.loggedIn) {
        if (token != null) {
          currentToken = token;
          // when simply checking auth status, token isn't returned
          setAuthToken(token);
        }
        if (newStatus.lang != null) {
          config.coreInstance.translate.setCurrentLanguage(newStatus.lang);
        }
        config.coreInstance.translate.loadTranslations(lang: newStatus.lang);
        currentUser = newStatus.currentUser;
      } else {
        clearAuthToken();
        currentUserRoles = <String>[];
        currentUser = null;
      }
      // Update SessionStatus after setting token
      // This is important because there might be functions ready to execute
      // right after session update
      setSession(session);
    }
  }

  /// Helper method to verify the local session against Frappé backend.
  ///
  /// Returns the session from the backend as [FrappeSessionStatusInfo].
  ///
  /// If the session is invalid, the session will be reset by calling [resetSession].
  @override
  @protected
  @visibleForTesting
  Future<RequestResponse<FrappeSessionStatusInfo>> verifySessionWithBackend(
      FrappeSessionStatusInfo info,
      {bool shouldUpdateSession = true}) async {
    final response = await Request.initiateRequest(
        url: config.hostUrl + '/api/method/frappe.auth.get_logged_user',
        method: HttpMethod.GET,
        isFrappeResponse: false);
    if (response.isSuccess) {
      final serverSession = FrappeSessionStatusInfo.fromJson(
          Request.convertToMap(response.rawResponse));
      serverSession.rawSession = Request.convertToMap(response.rawResponse);

      // check if same login
      if (serverSession.user != info.currentUser) {
        // login changed
        // notify SessionExpired
        config.logger.e(
            'RenovationCore Wrong session assumption. I hope you are listening at SessionStatus');
        updateSession(loggedIn: false);
        return RequestResponse.fail(ErrorDetail(
            type: RenovationError.PermissionError,
            title: 'Wrong session assumption',
            info: Information(
                httpCode: 403,
                rawResponse: response.rawResponse,
                cause:
                    'Wrong session assumption, I hope you are listening at SessionStatus',
                suggestion: 'Relogin')));
      } else {
        serverSession.token = info.token;
        if (shouldUpdateSession) {
          updateSession(loggedIn: true, sessionStatus: serverSession);
        }
        return RequestResponse.success(serverSession,
            rawResponse: response.rawResponse);
      }
    } else {
      config.logger.e('Renovation Core INVALID SESSION');
      updateSession(loggedIn: false);
      return RequestResponse.fail(response.error);
    }
  }

  /// Returns `true` if the user's language preference in the backend is changed to the language [lang].
  ///
  /// Throws an [InvalidLanguage] if [lang] is `null` or incorrect language code.
  ///
  /// Throws a [NotLoggedInUser] if the user is not logged in.
  ///
  /// If successful, updates the lang field of the current [sessionStatus].
  @override
  Future<bool> changeUserLanguage(String lang) async {
    if (lang == null || lang.trim().isEmpty || lang.trim().length > 2) {
      throw InvalidLanguage();
    }

    final sessionStatusInfo = getSession();
    if (sessionStatusInfo == null || !sessionStatusInfo.loggedIn) {
      throw NotLoggedInUser();
    }

    final response = await getCore().model.setValue(
        User(), sessionStatusInfo.user, 'language', lang.toLowerCase());

    if (response.isSuccess) {
      sessionStatusInfo.lang = lang;
      updateSession(
          loggedIn: response.isSuccess, sessionStatus: sessionStatusInfo);
      return sessionStatusInfo.loggedIn;
    }
    return false;
  }

  /// Removes [currentToken] and removes the Authorization header from [RequestOptions]
  @override
  @protected
  @visibleForTesting
  void clearAuthToken() {
    currentToken = null;
    RenovationRequestOptions.headers.remove('Authorization');
  }

  /// Sets the authentication token under [currentToken]
  ///
  /// In addition, updates [RequestOptions]'s Authorization header formatted as:
  ///
  /// [TOKEN_HEADER] + [token]
  @override
  @protected
  @visibleForTesting
  void setAuthToken(String token) {
    currentToken = token;

    // Can't use the standard Bearer <token> format since frappe treats that as something else
    // frappe/api.py validate_oauth() checks for the presence of the keyword 'Bearer'
    RenovationRequestOptions.headers['Authorization'] = '$TOKEN_HEADER $token';
  }

  @override
  ErrorDetail handleError(String errorId, ErrorDetail error) {
    if (error == null || error.info == null || error.info.data == null) {
      error = handleError(null, error);
    } else {
      switch (errorId) {
        case 'verify_otp':
          errorId = error.info.data?.status;
          error = handleError(errorId, error);
          break;
        case 'invalid_pin':
          error
            ..type = RenovationError.AuthenticationError
            ..title = 'Wrong OTP'
            ..description = 'Entered OTP is wrong'
            ..info = (error.info
              ..httpCode = 401
              ..cause = 'Wrong OTP entered'
              ..suggestion =
                  'Enter correct OTP received by SMS or generate a new OTP');
          break;
        case 'user_not_found':
        case 'no_linked_user':
        case 'no_pin_for_mobile':
          error
            ..type = RenovationError.NotFoundError
            ..title = 'User not found'
            ..info = (error.info
              ..httpCode = 404
              ..cause =
                  'User is either not registered or does not have a mobile number'
              ..suggestion = 'Create user or add a mobile number');
          break;

        case 'pin_login':
          error
            ..title = 'Incorrect Pin'
            ..info = (error.info
              ..cause = 'Wrong PIN is entered'
              ..suggestion = 'Re-enter the PIN correctly');
          break;

        case 'login':
          if (error.info.data.message is Map) {
            switch (error.info.data.message['message']) {
              case 'User disabled or missing':
                error = handleError('login_user_non_exist', error);
                break;
              case 'Incorrect password':
                error = handleError('login_incorrect_password', error);
                break;
              default:
                error = handleError(null, error);
            }
          } else {
            error = handleError(null, error);
          }
          break;
        case 'login_incorrect_password':
          error
            ..title = 'Incorrect Password'
            ..type = RenovationError.AuthenticationError
            ..info = (error.info
              ..cause = error.info.data.message['message']
              ..suggestion = 'Create the new user or enable it if disabled');
          break;
        case 'login_user_non_exist':
          error
            ..title = 'User not found'
            ..type = RenovationError.NotFoundError
            ..info = (error.info
              ..httpCode = 404
              ..cause = error.info.data.message['message']
              ..suggestion = 'Create the new user or enable it if disabled');
          break;
        case 'send_otp':
          if (error.type != RenovationError.BackendSettingError) {
            error = handleError(null, error);
          }
          break;
        // No specific errors
        case 'get_current_user_roles':
        case 'logout':
        default:
          error = RenovationController.genericError(error);
      }
    }
    return error;
  }
}
