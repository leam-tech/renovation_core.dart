import '../core/jsonable.dart';

/// Base class for representing sessions.
abstract class SessionStatusInfo extends JSONAble {
  SessionStatusInfo(this.loggedIn, this.timestamp, {this.currentUser});

  /// Whether the user is logged in or not.
  bool? loggedIn;

  /// The timestamp of the session when updated.
  double? timestamp;

  /// The current user logged in.
  String? currentUser;

  /// Holds the complete JSON retrieved from the backend
  /// This is because each app will have custom fields in the session response.
  Map<String, dynamic>? rawSession;
}
