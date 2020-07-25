import 'dart:core';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zxcvbn/src/result.dart';

import '../core/config.dart';
import '../core/renovation.controller.dart';
import '../core/request.dart';
import 'frappe/interfaces.dart';
import 'interfaces.dart';

/// A controller containing authentication properties and methods.
///
/// Authentication methods include standard email/pwd login, OTP login, updating session, etc..
abstract class AuthController<K extends SessionStatusInfo>
    extends RenovationController {
  BehaviorSubject<K> sessionStatus = BehaviorSubject<K>.seeded(null);

  /// Listen to changes in [sessionStatus] and log them in console
  AuthController(RenovationConfig config, {K sessionStatusInfo})
      : super(config) {
    sessionStatus.stream.where((session) => session != null).listen((session) {
      config.logger.i('Session Updated');
      config.logger.v(session.toJson());
    });
  }

  /// The current signed in user (if any).
  String currentUser;

  /// The token (JWT) of the current session.
  @protected
  String currentToken;

  /// The current signed in user's roles.
  List<String> currentUserRoles = <String>[];

  /// Returns the current JWT token formatted as `TOKEN_HEADER token`.
  String getCurrentToken();

  /// Checks the session's status (Whether the user is logged in or not) and returns it as [SessionStatusInfo]
  Future<RequestResponse<K>> checkLogin({bool shouldUpdateSession});

  /// Check the password's strength
  ///result.score : Integer from 0-4 (useful for implementing a strength bar)
  ///  0 # too guessable: risky password. (guesses < 10^3)
  ///  1 # very guessable: protection from throttled online attacks. (guesses < 10^6)
  ///  2 # somewhat guessable: protection from unthrottled online attacks. (guesses < 10^8)
  ///  3 # safely unguessable: moderate protection from offline slow-hash scenario. (guesses < 10^10)
  ///  4 # very unguessable: strong protection from offline slow-hash scenario. (guesses >= 10^10)
  ///
  /// result.feedback : verbal feedback to help choose better passwords. set when score <= 2.
  ///
  /// result.calcTime : how long it took to calculate an answer in milliseconds.
  Result estimatePassword(String password);


  /// Logs in the user (if successful) using [email] & [password].
  ///
  /// Returns the [SessionStatusInfo] whether successful or not, wrapped within [RequestResponse].
  ///
  /// [password] is optional.
  Future<RequestResponse<K>> login(String email, [String password]);

  /// Logs in the user (if successful) using [user] & [pin].
  ///
  /// Returns the [SessionStatusInfo] whether successful or not, wrapped within [RequestResponse].
  ///
  /// [pin] is usually a 4-digit.
  Future<RequestResponse<K>> pinLogin(String user, String pin);

  /// Sends a request to the backend with the mobile number. The response is a [SendOTPResponse].
  ///
  /// If [newOTP] is `true`, a previously sent OTP, won't be used. Instead a fresh one will be generated.
  Future<RequestResponse<SendOTPResponse>> sendOTP(String mobileNo,
      {bool newOTP});

  /// Verifies the [otp] entered by the user against the one sent through [sendOTP].
  Future<RequestResponse<VerifyOTPResponse>> verifyOTP(
      String mobileNo, String otp, bool loginToUser);

  /// Returns an array of roles assigned to the currently logged in user.
  Future<RequestResponse<List<String>>> getCurrentUserRoles();

  /// Logs out the current user.
  Future<RequestResponse<dynamic>> logout();

  /// Clears the current user's roles.
  @override
  void clearCache() {
    currentUserRoles = <String>[];
  }

  /// Updates the [sessionStatus].
  @protected
  @visibleForTesting
  void updateSession(
      {K sessionStatus, bool loggedIn = false, double useTimestamp});

  /// Helper method to verify the local session against the backend.
  @protected
  @visibleForTesting
  Future<RequestResponse<K>> verifySessionWithBackend(K info,
      {bool shouldUpdateSession = true});

  /// Returns the session status from [sessionStatus].
  K getSession() => sessionStatus.value;

  /// Returns a boolean whether the current user is logged in.
  bool get isLoggedIn => getSession().loggedIn;

  /// Sets the token (JWT).
  @protected
  @visibleForTesting
  void setAuthToken(String token);

  /// Removes the authentication token where relevant.
  @protected
  @visibleForTesting
  void clearAuthToken();

  /// Manually update the value of [sessionStatus].
  @protected
  @visibleForTesting
  void setSession(K session) => sessionStatus.add(session);

  /// Changes the user's language preference in the backend to the language [lang].
  Future<bool> changeUserLanguage(String lang);

  /// Resets [sessionStatus] as loggedIn = false with the current timestamp
  void resetSession() => updateSession(loggedIn: false);
}
