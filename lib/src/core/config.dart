import 'package:logger/logger.dart';

import 'renovation.dart';

/// Types of backend supported by the SDK
enum RenovationBackend {
  frappe,
  firebase // To be implemented
}

/// Class containing static instance of itself
///
/// Also includes the host URL and the backend chosen (Currently only frappe is enabled)
class RenovationConfig {
  RenovationConfig(this.coreInstance, this.backend, this.hostUrl, this.logger);

  /// A static instance of itself
  static RenovationConfig renovationInstance;

  /// A setting property to disable submission used in defaults
  bool disableSubmission = false;

  /// The backend used in the SDK
  RenovationBackend backend;

  /// An instance of [Renovation] to be used within the SDK
  Renovation coreInstance;

  /// The URL of the targeted backend
  String hostUrl;

  /// An instance of [Logger] to prettify printing logs
  Logger logger;
}
