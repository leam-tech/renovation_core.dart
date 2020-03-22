/// An error thrown when trying to convert a check docfield where the value is not `0` or `1`
class NotCheckError extends Error {
  NotCheckError();

  @override
  String toString() => 'Integer value should be either 1 or 0';
}

/// An error thrown when trying to convert `docStatus` where the value is not `0`, `1` or `2`
class NotDocStatusIntegerError extends Error {
  NotDocStatusIntegerError();

  @override
  String toString() => 'Doc Status value should be 0, 1 or 2';
}


/// An error thrown when the app version is not in the format x.y.z
class AppVersionFormatError extends Error {
  @override
  String toString() => 'Version empty or not in proper format';
}

/// An error thrown when the response is empty
class EmptyResponseError extends Error {
  @override
  String toString() => 'Response cannot be null';
}

/// An error thrown when the content to log is empty
class EmptyContentError extends Error {
  @override
  String toString() => 'Content cannot be empty or null';
}
