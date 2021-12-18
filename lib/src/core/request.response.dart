part of request;

/// A class to encapsulate the response from the backend used across the package
class RequestResponse<T> {
  RequestResponse(this.httpCode, this.isSuccess, this.data,
      {this.exc, this.error, this.rawResponse});

  /// The HTTP status code
  int? httpCode;

  /// Whether the request is successful
  bool isSuccess;

  /// The data coming from the response or otherwise
  T data;
  RenovationError? exc;
  ErrorDetail? error;

  /// The raw response object of the dio package
  Response<String>? rawResponse;

  ///
  /// Returns a success [RequestResponse] instance
  ///
  /// [isSuccess] is set to `true` with a data of type [F] and with httpCode as `200`
  ///
  static RequestResponse<F> success<F>(F data,
          {int? httpCode, Response<String>? rawResponse}) =>
      RequestResponse<F>(httpCode ?? 200, true, data, rawResponse: rawResponse);

  /// Returns a [RequestResponse] instance with the error details [ErrorDetail] if any
  static RequestResponse<F?> fail<F>(ErrorDetail errorDetail) =>
      RequestResponse<F?>(errorDetail.info?.httpCode, false, null,
          error: errorDetail);
}
