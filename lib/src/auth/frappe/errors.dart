/// Thrown when the language string is empty or doesn't conform to two character code.
///
/// Examples of invalid languages: ' ', 'a', 'arabic', 'USA'
///
class InvalidLanguage extends Error {
  @override
  String toString() =>
      'Language cannot be an empty string and must be exactly two characters';
}

/// Thrown when an operation is done with a non-logged in user.
class NotLoggedInUser extends Error {
  @override
  String toString() =>
      'No user logged in. This operation requires a logged in user';
}
