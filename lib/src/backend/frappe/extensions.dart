import 'dart:core';

/// Extension to handle [DateTime] object for Frappé
extension FrappeTime on DateTime {
  /// Replaces the the 'T' in the generated string with a ' '
  String toFrappeDateTimeString() =>
      toIso8601String().replaceAll(RegExp(r'T'), ' ');
}
