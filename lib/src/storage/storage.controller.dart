import 'dart:io';
import 'dart:typed_data';

import 'package:rxdart/rxdart.dart';

import '../core/config.dart';
import '../core/renovation.controller.dart';
import '../core/request.dart';
import 'frappe/errors.dart';
import 'interfaces.dart';

///Class containing properties and  methods dealing with Upload of files.
abstract class StorageController<
    K extends UploadFileParams,
    L extends UploadFileResponse?,
    M extends UploadFileStatus> extends RenovationController {
  StorageController(RenovationConfig config) : super(config);

  /// Validate the arguments of the file to be uploaded.
  ///
  /// The method is silent, so it should throw errors in case there's a validation error.
  void validateUploadFileArgs(K uploadFileParams);

  ///Clears the cache. Currently empty method
  @override
  void clearCache() {}

  /// Returns a [BehaviorSubject] that emit [UploadFileStatus] as the upload progresses using socket.io.
  ///
  /// Should fallback to [uploadViaHTTP] in case the socket.io method fails.
  BehaviorSubject<M> uploadFile(K uploadFileParams);

  /// Returns [UploadFileResponse] on uploading of file. This method should be used if [uploadFile] fails.
  Future<RequestResponse<L>> uploadViaHTTP(K uploadFileParams);

  /// Returns [bool] within RequestResponse after creating folder.
  Future<RequestResponse<bool?>> createFolder(
      {required String folderName, String? parentFolder});

  /// Returns [bool] within [RequestResponse] after querying the folder in the backend.
  Future<RequestResponse<bool?>> checkFolderExists(String folderDir);

  /// Returns the URL appended to the reference of the file.
  String? getUrl(String ref);

  /// Returns the file as [Uint8List] of a file.
  ///
  /// If the file is already of type [Uint8List] returns as-is.
  Uint8List getByteList(dynamic file) {
    if (file is Uint8List) {
      return file;
    }
    if (file is File) {
      return file.readAsBytesSync();
    }
    throw FileTypeError();
  }

  /// Returns the file size depending on whether it's [Uint8List] or [File].
  int getFileSize(dynamic file) {
    if (file is Uint8List) {
      return file.length;
    }
    if (file is File) {
      return file.lengthSync();
    }
    throw FileTypeError();
  }
}
