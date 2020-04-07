import 'dart:io';

import 'package:renovation_core/core.dart';

class TestManager {
  /// Holds the test instance of Renovation
  static Renovation renovation;
  static final Map<String, String> _envVariables = Platform.environment;

  static Future<Renovation> getTestInstance() async {
    if (renovation == null) {
      renovation = Renovation();

//      print(_envVariables);

      await renovation.init(_envVariables[EnvVariables.HostURL],
          disableLog: true);
    }
    return renovation;
  }

  static String getVariable(String variableName) => _envVariables[variableName];

  static final String primaryUser = _envVariables[EnvVariables.PrimaryUser];
  static final String primaryUserPwd =
      _envVariables[EnvVariables.PrimaryUserPwd];
  static final String secondaryUser = _envVariables[EnvVariables.SecondaryUser];
  static final String secondaryUserPwd =
      _envVariables[EnvVariables.SecondaryUserPwd];
  static final String mobileNumber = _envVariables[EnvVariables.MobileNumber];
}

class EnvVariables {
  // Prefix variables to avoid any conflict with existing variables
  static const String _envPrefix = 'CORE_DART_';

  // Host URL
  static const String HostURL = '${_envPrefix}HOST_URL';

  // Users
  static const String PrimaryUser = '${_envPrefix}PRIMARY_USER';
  static const String PrimaryUserPwd = '${_envPrefix}PRIMARY_USER_PWD';
  static const String PrimaryUserName = '${_envPrefix}PRIMARY_USER_NAME';
  static const String PrimaryUserEmail = '${_envPrefix}PRIMARY_USER_EMAIL';
  static const String SecondaryUser = '${_envPrefix}SECONDARY_USER';
  static const String SecondaryUserPwd = '${_envPrefix}SECONDARY_USER_PWD';
  static const String MobileNumber = '${_envPrefix}MOBILE_NUMBER';
  static const String PinNumber = '${_envPrefix}PIN_NUMBER';

  // Storage
  static const String ExistingFolder = '${_envPrefix}EXISTING_FOLDER';
}
