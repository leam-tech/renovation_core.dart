import 'errors.dart';

class AppVersion {
  AppVersion.fromString(String appName, Map<String, dynamic> version) {
    _appName = appName;
    _versionString = version['version'];
    _branch = version['branch'];
    _description = version['description'];
    _title = version['title'];
    _parseVersionSegment(_versionString);
  }

  String _title;
  String _description;
  String _branch;
  String _versionString;

  String _appName;
  int _major;
  int _minor;
  int _patch;

  String get appName => _appName;

  int get major => _major;

  int get minor => _minor;

  int get patch => _patch;

  String get versionString => _versionString;

  String get branch => _branch;

  String get description => _description;

  String get title => _title;

  void _parseVersionSegment(String versionString) {
    if (versionString != null && versionString.isNotEmpty) {
      final regex = RegExp(r'\d+(\.\d+){2,}');

      final version = regex.firstMatch(versionString);

      if (version != null && version.groupCount > 0) {
        final segments = version.group(0).split('.');

        if (segments != null && segments.length == 3) {
          _major = int.parse(segments[0]);
          _minor = int.parse(segments[1]);
          _patch = int.parse(segments[2]);
          return;
        }
      }
    }
    throw AppVersionFormatError();
  }
}
