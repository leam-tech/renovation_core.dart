/// Thrown when the permission level is not between (0-9)
class InvalidPermissionLevel extends Error {
  @override
  String toString() => 'Valid permission levels are between (0-9) inclusive';
}
