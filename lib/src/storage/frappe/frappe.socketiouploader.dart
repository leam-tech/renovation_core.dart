import 'dart:async';
import 'dart:typed_data';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:rxdart/rxdart.dart';

import '../../../core.dart';
import '../../../misc.dart';
import '../../../storage.dart';
import '../../core/errors.dart';
import '../interfaces.dart';

/// The following is the client side logic of frappe's socket io upload implementation
/// It has to fallback to normal method when something goes wrong (base64 encoded data over http)
///
/// Procedure:
/// 1. Validate filename
/// filename: IMG_20160429_075059.jpg
/// cmd: frappe.utils.file_manager.validate_filename
///
/// 2. Assign the obtained name to the file we are uploading
///
/// 3. Emit: upload-accept-slice with chunk
/// 4. Server will emit upload-request-slice asking for next chunk, do the loop
///
/// 5. on upload-end:
///  Call frappe.handler.uploadfile with from_form: 1 and file_url obtained with upload-end
///
/// 6. on upload-error:
///
/// 7. on disconnect:

/// Class handling socket.io uploading
class FrappeSocketIOUploader implements IErrorHandler {
  /// The subject to subscribe updates about the upload
  BehaviorSubject<FrappeUploadStatus> uploadStatus =
      BehaviorSubject<FrappeUploadStatus>.seeded(
          FrappeUploadStatus()..status = UploadingStatus.ready);

  /// The file as a buffer being uploaded
  Uint8List file;

  /// The size of the file
  num fileSize;

  /// The size of the chunk (Set constant)
  static const int chunkSize = 24576;

  /// Object holding the events and their handlers
  Map<String, List<SocketIOHandler>> socketIOCallbacks;

  /// The arguments of the file to be uploaded
  FrappeUploadFileParams args;

  /// Holds the reference to the keep-alive timeout
  Timer keepAliveTimeout;

  /// Flag to hold whether the upload is started
  bool started = false;

  /// Upload the file using socket.io
  ///
  /// - The arguments are first parsed using the file.utils functions
  /// - Check for socket.io connection
  /// - Setup the listeners
  /// - Validate the name of the file in the backend
  /// - Start upload
  /// @param uploadFileParams
  Future<void> upload(FrappeUploadFileParams uploadFileParams) async {
    getFrappeStorageController().validateUploadFileArgs(uploadFileParams);

    args = uploadFileParams;
    file = getFrappeStorageController().getByteList(uploadFileParams.file);
    fileSize = getFrappeStorageController().getFileSize(uploadFileParams.file);
    args.fileName = uploadFileParams.fileName;

    // verify socketIo
    if (!_getCore().socketIo.isConnected) {
      _getCore().socketIo.connect();
      await Future<dynamic>.delayed(Duration(seconds: 3));
      // if still not connected, error out
      if (!_getCore().socketIo.isConnected) {
        _onError(ErrorEvent.no_socketio);
        return;
      }
    }
    _setupListeners();

    var r = await _validateFileName();
    if (!r.isSuccess) {
      _getCore().config.logger.w('Invalid File Name');
      _onError(ErrorEvent.name_error);
      return;
    }
    args.fileName = r.data.message;

    started = false;
    _sendNextChunk(0);
  }

  /// Called after an error event or on completion
  ///
  /// Removes the listeners of the socket
  void _destroy() => _stripListeners();

  /// Sends the chunk to the socket in the backend after it emits the `upload-request-slice` event
  /// @param currentSlice The slice to be sent (starts at zero), Subsequent slice numbers supplied by the socket server
  void _sendNextChunk(num currentSlice) {
    List<int> data;
    if (currentSlice * chunkSize + chunkSize > file.length) {
      data = file.sublist(currentSlice * chunkSize, file.length);
    } else {
      data = file.sublist(
          currentSlice * chunkSize, currentSlice * chunkSize + chunkSize);
    }

    var uploadAcceptSlice = FrappeUploadAcceptSlice.fromJson(<String, dynamic>{
      'is_private': args.isPrivate,
      'name': args.fileName,
      'size': fileSize,
      'data': data
    });

    _emit('upload-accept-slice', uploadAcceptSlice.toJson());

    if (currentSlice > 0) {
      var progress = (((currentSlice * chunkSize) / fileSize) * 100).round();
      uploadStatus.add(FrappeUploadStatus()
        ..status = UploadingStatus.uploading
        ..filename = args.fileName
        ..progress = progress
        ..hasProgress = true);
    }

    _keepAlive();
  }

  /// Sets up the listeners of all the events emitted by the socket.io server
  void _setupListeners() async {
    if (socketIOCallbacks != null && socketIOCallbacks.isNotEmpty) {
      // setup done already perhaps;
      return;
    }
    _addIOListener('upload-request-slice', (dynamic data) {
      started = true;
      _sendNextChunk(FrappeUploadRequestSlice.fromJson(data).currentSlice);
    });

    _addIOListener('upload-end', (dynamic data) {
      var uploadEndData = FrappeUploadEnd.fromJson(data);
      if (uploadEndData.fileUrl.substring(0, 7) == '/public') {
        uploadEndData.fileUrl = uploadEndData.fileUrl.substring(7);
      }
      _onComplete(uploadEndData);
    });

    _addIOListener('upload-error', (dynamic data) {
      _onError(ErrorEvent.upload_error);
    });

    _addIOListener('disconnect', (dynamic data) {
      _onError(ErrorEvent.disconnected);
    });
  }

  /// Emit an event to the `uploadStatus` with status error followed by destroying the socket listeners
  /// @param event The name of the event emitted
  void _onError(ErrorEvent event) {
    uploadStatus.add(FrappeUploadStatus()
      ..status = UploadingStatus.error
      ..error = event);

    _getCore().config.logger.w(
        'LTS-Renovation-Core FrappeSocketIOUploader Error',
        EnumToString.parse(event));
    _destroy();
  }

  /// Handler of when the upload is complete
  ///
  /// Get the full details of the uploaded file (HTTP handler)
  ///
  /// In the end, call the `destroy` method
  ///
  /// @param frappeUploadEnd [FrappeUploadEnd] The object holding the file URL after successful upload
  Future<void> _onComplete(FrappeUploadEnd uploadEnd) async {
    keepAliveTimeout?.cancel();
    // finally, make a call to http uploadfile handler to get full details

    args.cmd = 'renovation_core.handler.uploadfile';
    args.fileUrl = uploadEnd.fileUrl;

    var r = await Request.initiateRequest(
        url: _getCore().config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_X_WWW_FORM_URLENCODED,
        data: args.toJson());

    RequestResponse<FrappeUploadFileResponse> uploadResponse;
    if (r.isSuccess) {
      final dynamic responseObj = r.data.message;
      final uploadFileResponse = FrappeUploadFileResponse()
          .fromJson<FrappeUploadFileResponse>(responseObj);
      uploadResponse = RequestResponse.success(uploadFileResponse);
    } else {
      uploadResponse =
          RequestResponse.fail(handleError('on_complete', r.error));
      uploadResponse.error.description = uploadEnd.fileUrl;
    }

    uploadStatus.add(FrappeUploadStatus()
      ..status = r.isSuccess ? UploadingStatus.completed : UploadingStatus
          .detail_error
      ..progress = 100
      ..filename = args.fileName
      ..r = uploadResponse);
    await uploadStatus.close();
    _destroy();
  }

  /// Adds the event listeners to an array to easily manage destroying, modifying them
  /// @param event The name of the event
  /// @param handler The callback on occurrence of the event
  void _addIOListener(String event, SocketIOHandler handler) {
    socketIOCallbacks ??= {};
    socketIOCallbacks[event] ??= <SocketIOHandler>[];

    if (socketIOCallbacks[event].contains(handler)) {
      // attached already, return
      return;
    }

    socketIOCallbacks[event].add(handler);
    _getCore().socketIo.on(event, handler);
  }

  /// Removes the listeners and resets `socketIOCallbacks`
  void _stripListeners() {
    socketIOCallbacks?.forEach((String event, List v) {
      var handlers = socketIOCallbacks[event];
      for (var handler in handlers) {
        _getCore().socketIo.off(event, handler: handler);
      }
    });
    socketIOCallbacks = {};
  }

  /// Helper method to emit an event with its data
  /// @param event The name of the event
  /// @param data The payload of the event, if any
  void _emit(String event, dynamic data) =>
      _getCore().socketIo.emit(event, data: data);

  /// Validates the file name in the backend
  ///
  /// @returns [Future<RequestResponse<dynamic>>] Returns success if validated, otherwise, failure
  Future<RequestResponse<FrappeResponse>> _validateFileName() async =>
      await _getCore().call(<String, dynamic>{
        'cmd': 'frappe.utils.file_manager.validate_filename',
        'filename': args.fileName
      });

  /// Check for the socket.io connection
  ///
  /// If the socket times out, an event is emitted "socket-timeout"
  void _keepAlive() {
    keepAliveTimeout?.cancel();
    keepAliveTimeout =
        Timer(Duration(seconds: 10), () => _onError(ErrorEvent.socket_timeout));
    // we could give 10seconds before timing out, since the upload has already started
  }

  /// Getter for the core instance
  Renovation _getCore() {
    return RenovationConfig.renovationInstance.coreInstance;
  }

  @override
  ErrorDetail handleError(String errorId, ErrorDetail error) {
    var err = ErrorDetail();

    switch (errorId) {
      case 'on_complete':
      default:
        err = RenovationController.genericError(error);
    }

    return err;
  }
}
