import 'package:dio/dio.dart';

import 'request.dart' show RenovationError;

abstract class IErrorHandler {
  /// Returns the [ErrorDetail] after manipulating an existing one.
  ///
  /// Method that handles errors by parsing the raw response or custom input.
  ///
  /// If other errors are to be added, then they will be handled here as if-else or switch-case.
  ///
  /// Each error needs to be supplied an [errorId], or `null` if a Generic Error were to be returned.
  ///
  /// If [error] is passed, it can be manipulated within this method and return the modified [ErrorDetail] object.
  ErrorDetail handleError(String errorId, ErrorDetail error);
}

/// Model class holding the details of an error along with the original request
class ErrorDetail {
  ErrorDetail({this.title, this.description, this.type, this.info}){
    info ??= Information();
  }

  /// Title of the message. Can be used in the front-end
  String? title;

  /// A short description of the error than can be used in the front-end
  String? description;

  /// Type of error (validation, permission, etc...)
  RenovationError? type;

  /// An instance of [Information] that contain more details
  Information? info;
}

/// A class holding the raw information in addition to possible causes and suggestions for the errors
class Information {
  Information(
      {this.serverMessages,
      this.httpCode,
      this.cause,
      this.suggestion,
      this.data,
      this.rawResponse,
      this.rawError});

  /// Message from the server (back-end), if any.
  List<String>? serverMessages;

  /// HTTP code if the error is from the server
  int? httpCode;

  /// A cause of the error, if any
  String? cause;

  /// A suggestion message, if any, to resolve the error
  String? suggestion;

  /// Further details for debugging/logging
  dynamic data;

  /// Raw Response from [Dio]
  Response<String>? rawResponse;

  /// Raw Error from [Dio]
  DioError? rawError;
}

/// An error class to be thrown when a class doesn't implement [JSONAble] abstract methods
class JSONAbleMethodsNotImplemented extends Error {
  @override
  String toString() => 'fromJson() and/or toJson() are not implemented';
}

/// Thrown when Cookie directory is not set while useJWT is set to `false`
class CookieDirNotSet extends Error {
  @override
  String toString() =>
      'Cookie directory is not set, please set a valid cookie directory';
}
