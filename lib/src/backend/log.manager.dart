import '../../core.dart';

abstract class LogManager extends RenovationController {
  LogManager(RenovationConfig config) : super(config);

  @override
  void clearCache() {}

  /// Basic Logging
  Future<RequestResponse<dynamic>> info();

  /// Basic Logging
  Future<RequestResponse<dynamic>> warning();

  /// Basic Logging
  Future<RequestResponse<dynamic>> error();

  /// A wrapper fn for backend endpoint
  Future<RequestResponse<dynamic>> invokeLogger();

  /// Log client side request
  Future<RequestResponse<dynamic>> logRequest();
}
