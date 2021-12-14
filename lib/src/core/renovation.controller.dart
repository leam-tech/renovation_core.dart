/// The base of all controllers within the package for any type of backend
/// Currently only *Frappe* is implemented as the backend
import 'config.dart';
import 'errors.dart';
import 'renovation.dart';
import 'request.dart';

///
/// A superclass to be inherited by controllers.
///
/// It contains the following methods that are concrete:
///
/// - [getCore] which returns the Renovation instance
///
/// - [getHostUrl] which returns the host URL used to connect to the backend
abstract class RenovationController implements IErrorHandler {
  RenovationController(this.config);

  final RenovationConfig config;
  static const String GENERIC_ERROR_TITLE =
      'Generic Error, investigate .info for more details';

  /// A generic method to parse a `GenericError`. The following is achieved on the object:
  ///
  /// - Set type as `GenericError` by default if not already set
  /// - Set title as 'Generic Error` by default if not already set
  ///
  static ErrorDetail genericError(ErrorDetail? errorDetail) {
    if (errorDetail == null) {
      return ErrorDetail(
          title: RenovationController.GENERIC_ERROR_TITLE,
          type: RenovationError.GenericError,
          info: Information(httpCode: 400));
    }

    return errorDetail
      ..title = errorDetail.title ?? RenovationController.GENERIC_ERROR_TITLE
      ..type = errorDetail.type ?? RenovationError.GenericError
      ..info = errorDetail.info != null
          ? (errorDetail.info!..httpCode = errorDetail.info?.httpCode ?? 400)
          : Information(httpCode: 400);
  }

  /// Clears the cache or residual objects.
  void clearCache();

  /// Returns the configured host URL towards the backend
  String getHostUrl() => config.hostUrl;

  /// Gets the reference to the [Renovation] instance
  Renovation getCore() => config.coreInstance;
}
