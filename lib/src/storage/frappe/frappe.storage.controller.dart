import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/config.dart';
import '../../core/errors.dart';
import '../../core/frappe/renovation.dart';
import '../../core/renovation.controller.dart';
import '../../core/request.dart';
import '../../model/frappe/frappe.model.controller.dart';
import '../interfaces.dart';
import '../storage.controller.dart';
import 'errors.dart';
import 'frappe.socketiouploader.dart';
import 'interfaces.dart';

class FrappeStorageController extends StorageController<FrappeUploadFileParams,
    FrappeUploadFileResponse?, FrappeUploadStatus> {
  FrappeStorageController(RenovationConfig config) : super(config);

  /// Validate the arguments of the file to be uploaded.
  ///
  /// The method is silent, so it should throw errors in case there's a validation error.
  ///
  /// Throws [MissingFileError] in case the file is `null` within uploadFileParams.
  ///
  /// Throws [MissingFileNameError] in case the fileName is `null` or empty.
  ///
  @override
  void validateUploadFileArgs(FrappeUploadFileParams uploadFileParams) {
    if (uploadFileParams.file == null) throw MissingFileError();

    if (uploadFileParams.fileName == null ||
        uploadFileParams.fileName!.isEmpty) {
      throw MissingFileNameError();
    }

    if (uploadFileParams.doctype != null && uploadFileParams.docname != null) {
      uploadFileParams.folder = null;
    }
  }

  /// Returns a [BehaviorSubject] that emit [FrappeUploadStatus] as the upload progresses using socket.io.
  ///
  /// It will fallback to [uploadViaHTTP] in case the socket.io method fails.
  ///
  /// On completion, the event [Status.completed] will be emitted and the `fileUrl` will be set in the backend.
  @override
  BehaviorSubject<FrappeUploadStatus> uploadFile(
      FrappeUploadFileParams uploadFileParams) {
    validateUploadFileArgs(uploadFileParams);
    var obs = BehaviorSubject<FrappeUploadStatus>.seeded(FrappeUploadStatus()
      ..status = UploadingStatus.uploading
      ..hasProgress = true);
    var realtimeUploader = FrappeSocketIOUploader();
    realtimeUploader.uploadStatus.listen((uploadStatus) async {
      switch (uploadStatus.status) {
        case UploadingStatus.ready:
          break;
        case UploadingStatus.error:
          config.coreInstance.config.logger.w([
            'LTS-Renovation-Core',
            'Frappe SocketIO Upload error',
            EnumToString.convertToString(uploadStatus.error)
          ]);
          // revert to http upload
          obs.add(FrappeUploadStatus()
            ..status = UploadingStatus.uploading
            ..hasProgress = false
            ..filename = uploadFileParams.fileName);
          var response = await uploadViaHTTP(uploadFileParams);
          obs.add(FrappeUploadStatus()
            ..status = response.isSuccess
                ? UploadingStatus.completed
                : UploadingStatus.error
            ..r = response);
          await obs.close();
          break;
        case UploadingStatus.uploading:
          config.coreInstance.config.logger
              .i(['Upload Progress', uploadStatus.progress.toString()]);
          obs.add(FrappeUploadStatus()
            ..filename = uploadStatus.filename
            ..status = UploadingStatus.uploading
            ..hasProgress = true
            ..progress = uploadStatus.progress);
          break;
        case UploadingStatus.completed:
          obs.add(FrappeUploadStatus()
            ..filename = uploadStatus.filename
            ..status = UploadingStatus.completed
            ..hasProgress = true
            ..progress = 100
            ..r = uploadStatus.r);
          await obs.close();
          break;
        case UploadingStatus.detail_error:
        default:
          RequestResponse<FrappeUploadFileResponse?>? response;
          if (uploadStatus.r != null) {
            response = uploadStatus.r;
          } else {
            response = RequestResponse.fail(handleError(null, null));
          }
          obs.add(FrappeUploadStatus()
            ..status = UploadingStatus.error
            ..r = response);

          await obs.close();
      }
    });
    realtimeUploader.upload(uploadFileParams);

    // try socketio upload first
    return obs;
  }

  /// Returns [FrappeUploadFileResponse] on uploading of file. This method should be used if [uploadFile] fails.
  ///
  /// Handles files of type [File] if native and [Uint8List] if from the web.
  @override
  Future<RequestResponse<FrappeUploadFileResponse?>> uploadViaHTTP(
      FrappeUploadFileParams uploadFileParams) async {
    await getFrappe().checkAppInstalled(features: ['uploadViaHTTP']);

    validateUploadFileArgs(uploadFileParams);

    uploadFileParams.fileData =
        base64Encode(getByteList(uploadFileParams.file));

    uploadFileParams.fileSize = getFileSize(uploadFileParams.file);

    uploadFileParams.cmd = getFrappe().getAppsVersion('renovation_core') != null
        ? 'renovation_core.handler.uploadfile'
        : 'frappe.handler.uploadfile';

    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_X_WWW_FORM_URLENCODED,
        data: uploadFileParams.toJson());

    if (response.isSuccess) {
      final dynamic responseObj = response.data!.message;
      if (responseObj != null) {
        final uploadFileResponse = FrappeUploadFileResponse()
            .fromJson<FrappeUploadFileResponse>(responseObj);

        return RequestResponse.success(uploadFileResponse,
            rawResponse: response.rawResponse);
      } else {
        return RequestResponse.fail(handleError(
            'uploadViaHttp',
            response.error ??
                ErrorDetail(
                    info: Information(rawResponse: response.rawResponse))));
      }
    } else {
      return RequestResponse.fail(handleError('uploadViaHttp', response.error));
    }
  }

  /// Returns [bool] within [RequestResponse] after querying the folder in Frappé backend.
  ///
  /// It calls `getList()` of [FrappeModelController].
  @override
  Future<RequestResponse<bool?>> checkFolderExists(String folderDir) async {
    final response = await config.coreInstance.model.getList(FrappeFile(),
        fields: ['name'], filters: {'is_folder': 1, 'name': folderDir});
    if (response.isSuccess) {
      return RequestResponse.success(response.data?.isNotEmpty);
    } else {
      return RequestResponse.fail(
          handleError('checkFolderExists', response.error));
    }
  }

  /// Returns [bool] within [RequestResponse] after creating folder.
  ///
  /// If unsuccessful, the `false` is returned within [RequestResponse].
  ///
  /// Optionally, specify the [parentFolder] which defaults to 'Home'.
  ///
  /// [folderName] must not contain a forward-slash, otherwise an error is returned within [RequestResponse].
  @override
  Future<RequestResponse<bool?>> createFolder(
      {required String folderName, String? parentFolder = 'Home'}) async {
    if (folderName.contains('/')) {
      return RequestResponse.fail(handleError(
          'invalid_foldername_forward_slash',
          ErrorDetail(info: Information(httpCode: 412))));
    }

    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_X_WWW_FORM_URLENCODED,
        data: <String, dynamic>{
          'cmd': 'frappe.core.doctype.file.file.create_new_folder',
          'file_name': folderName,
          'folder': parentFolder
        });

    return response.isSuccess
        ? RequestResponse.success(true, rawResponse: response.rawResponse)
        : RequestResponse.fail(handleError('create_folder', response.error));
  }

  /// Returns the URL appended to the reference of the file using the `hostUrl`.
  ///
  /// In case [ref] is `null` or contains "http", [ref] is returned as-is.
  @override
  String? getUrl(String? ref) {
    if (ref == null) return ref;

    // Already a well formed url, return it as-is.
    if (ref.contains('http')) return ref;

    return '${config.hostUrl}$ref';
  }

  @override
  ErrorDetail handleError(String? errorId, ErrorDetail? error) {
    error ??= RenovationController.genericError(error);

    switch (errorId) {
      case 'create_folder':
        if (error.info?.httpCode == 412) {
          error = handleError('invalid_foldername_forward_slash', error);
        } else if (error.info?.httpCode == 409) {
          error
            ..title = 'Folder with same name exists'
            ..type = RenovationError.DuplicateEntryError
            ..info = ((error.info ?? Information())
              ..httpCode = 409
              ..cause = 'A folder with same name exists'
              ..suggestion =
                  'Choose a new name for the folder or remove the existing one');
        } else {
          error = handleError(null, error);
        }
        break;
      case 'invalid_foldername_forward_slash':
        error
          ..title = 'Invalid Folder Name'
          ..info = ((error.info ?? Information())
            ..httpCode = 412
            ..cause = 'Invalid folder name: contains forward slash'
            ..suggestion = 'Remove the forward slash from the name');
        break;
      case 'uploadViaHttp':
        if (error.info?.rawResponse?.data?.contains(
                'Same file has already been attached to the record') ??
            false) {
          error
            ..type = RenovationError.DuplicateEntryError
            ..title = 'File already exists with attached to the document'
            ..info = ((error.info ?? Information())
              ..httpCode = 409
              ..cause = 'Same file was uploaded earlier to the document'
              ..suggestion =
                  'Either delete the file before re-uploading or ignore the message');
        } else {
          error = handleError(null, error);
        }
        break;
      case 'checkFolderExists':
      default:
        error = RenovationController.genericError(error);
    }

    return error;
  }
}
