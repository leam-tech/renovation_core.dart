import 'package:lts_renovation_core/core.dart';

class TestManager {
  /// Holds the test instance of Renovation
  static Renovation renovation;

  static Future<Renovation> getTestInstance({int hostIndex = 0}) async {
    if (renovation == null) {
      renovation = Renovation();

//      final Map<String, String> credentials = getTestUserCredentials();

      print('CORE INIT: ${hostUrls[hostIndex]}');
      await renovation.init(hostUrls[hostIndex]);
    }
    return renovation;
  }

  /// A getter for the used credentials across the testing environment
  static Map<String, String> getTestUserCredentials() =>
      Map<String, String>.of(<String, String>{
        'email': '<admin_user>',
        'password': '<password>',
        'fullName': '<admin_user>'
      });

  ///Holds the host URLs of the backend
  ///
  /// Useful if another app on another site needs to be tested
  static List<String> hostUrls = <String>[
    '<host_url>',
    'http://localhost:8000'
  ];
}
