import '../core/config.dart';
import '../core/renovation.controller.dart';
import '../core/request.dart';

/// Controller for getting and setting key-value pair in the backend.
abstract class DefaultsController extends RenovationController {
  DefaultsController(RenovationConfig config) : super(config);

  /// Gets the value given the [key]. Can specify the [parent] if the key is duplicated under a different parent.
  Future<RequestResponse<dynamic>> getDefault(
      {required String key, String? parent});

  /// Sets a default value in backend for a specified key and return nothing if successful.
  Future<RequestResponse<dynamic>> setDefaults(
      {required String key, required dynamic value, String? parent});
}
