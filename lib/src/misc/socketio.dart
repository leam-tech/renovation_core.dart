import 'package:socket_io_client/socket_io_client.dart';

import '../core/config.dart';
import '../core/errors.dart';
import '../core/renovation.controller.dart';
import '../core/request.dart';

typedef SocketIOHandler = void Function(dynamic data);

/// Class for functionality of SocketIO operations
class SocketIOClient extends RenovationController {
  SocketIOClient(RenovationConfig config) : super(config);

  /// Returns whether the socket is connected.
  ///
  /// If the socket is `null`, returns `false` otherwise.
  bool get isConnected => _socket != null ? _socket.connected : false;

  /// The instance of the socket
  Socket _socket;

  /// Connect to the socket endpoint in the server.
  ///
  /// If the socket is already connected, the socket will be disconnected before reconnecting.
  ///
  /// By default [requiresAuthorization] is set to `true` which adds "Authorization" headers based on [RenovationRequestOptions].
  void connect({String url, String path, bool requiresAuthorization = true}) {
    url ??= config.hostUrl;
    path ??= '/socket.io';

    final opts = <dynamic, dynamic>{
      'path': path,
      'transports': <String>['websocket'],
      'extraHeaders': requiresAuthorization
          ? <String, String>{
              'Authorization': RenovationRequestOptions.headers['Authorization']
            }
          : null
    };

    if (_socket != null) {
      // Update the options
      // Need to reuse the same object created earlier
      _socket.io
        ..uri = url
        ..options = opts;
      (_socket..disconnect()).connect();
    } else {
      _socket = io(url, opts);
    }

    config.logger.i('LTS-Renovation-Core-Dart Connecting socket on $url$path');

    if (!_socket.hasListeners('connect')) {
      _socket.on(
          'connect',
          (dynamic data) =>
              config.logger.i('Connected socket successfully on $url$path'));
    }
    if (!_socket.hasListeners('connect_error')) {
      _socket.on(
          'connect_error',
          (dynamic connectStatus) =>
              config.logger.e('Connected socket unsuccessful on $url$path'));
    }
    if (!_socket.hasListeners('connect_timeout')) {
      _socket.on(
          'connect_timeout',
          (dynamic connectStatus) => config.logger
              .e(<dynamic>['Timeout while connecting', connectStatus]));
    }
  }

  /// Gets the reference of the socket in the class
  Socket get getSocket {
    if (_socket == null) config.logger.e('Socket not initialized');
    return _socket;
  }

  /// Emits the event with payload [data] optionally.
  ///
  /// If the socket is `null`, the method returns `false`.
  bool emit(String event, {dynamic data}) {
    if (!isConnected) {
      config.logger.e('Socket is not connected to emit , $event, $data');
      return false;
    }
    _socket.emit(event, data);
    return true;
  }

  /// Subscribe to an [event] if the socket [isConnected].
  ///
  /// On event receive, the callback [handler] will be triggered.
  void on(String event, SocketIOHandler handler) {
    if (isConnected) _socket.on(event, handler);
  }

  /// Unsubscribe from the event if the socket [isConnected].
  ///
  /// Optionally can specify a [handler] to be triggered after the event is not listened to.
  void off(String event, {SocketIOHandler handler}) {
    if (isConnected) _socket.off(event, handler);
  }

  /// Disconnects (if any) the socket and set [_socket] to the instance itself.
  ///
  /// Otherwise, [_socket] is set to `null`.
  void disconnect() =>
      _socket = isConnected ? _socket = _socket.disconnect() : null;

  /// Clears the cache. Currently empty method
  @override
  void clearCache() {}

  @override
  ErrorDetail handleError(String errorId, ErrorDetail error) =>
      throw UnimplementedError(
          'Error handling is not implemented in SocketIOClient');
}
