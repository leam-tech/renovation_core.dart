/// Helper function to convert string [s] to Title Case
///
/// Examples:
///
/// - hello world -> Hello World
/// - hello_world -> Hello_world
String toTitleCase(String s) => s.replaceAllMapped(
    RegExp('/\w\S*/g'),
    (Match txt) =>
        txt[0]!.toUpperCase() + txt.toString().substring(1).toLowerCase());

/// Helper function to convert an underscore string [s] to camel case.
///
/// Example:
///
/// - hello_world -> helloWorld
String underScoreToCamel(String s) => s.replaceAllMapped(RegExp('/(\_[a-z])/g'),
    (Match $1) => $1.toString().toUpperCase().replaceAll('_', ''));

/// Helper function to convert an underscore string [s] to Title case.
///
/// Example:
///
/// hello_world -> Hello World
String underScoreToTitle(String s) {
  s = s.replaceAllMapped('/(\_[a-z])/g',
      (Match $1) => $1.toString().toUpperCase().replaceAll('_', ' '));
  s = s.replaceAll(s[0], s[0].toString().toUpperCase());
  return s;
}
