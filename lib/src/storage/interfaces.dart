import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../core/jsonable.dart';

abstract class UploadFileParams extends JSONAble {
  UploadFileParams(
      {@required this.file,
      @required this.fileName,
      this.fileData,
      this.fileSize});

  @JsonKey(ignore: true)
  dynamic file;
  @JsonKey(name: 'filename')
  String fileName;
  @JsonKey(name: 'filedata')
  String fileData;
  @JsonKey(name: 'file_size')
  int fileSize;
}

abstract class UploadFileResponse extends JSONAble {
  @JsonKey(name: 'file_name')
  String fileName;
  @JsonKey(name: 'file_url')
  String fileUrl;
}

enum UploadingStatus { ready, uploading, completed, error, detail_error }

enum ErrorEvent {
  no_socketio,
  disconnected,
  upload_error,
  name_error,
  socket_timeout
}

abstract class UploadFileStatus extends JSONAble {
  UploadingStatus status;
  bool hasProgress;
  num progress;
  ErrorEvent error;
  String filename;
}
