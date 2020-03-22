import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../../../core.dart';
import '../../model/frappe/document.dart';
import '../../model/frappe/utils.dart';
import '../interfaces.dart';

part 'interfaces.g.dart';

@JsonSerializable()
class FrappeUploadFileParams extends UploadFileParams with FrappeAPI {
  FrappeUploadFileParams(
      {@required dynamic file,
      @required String fileName,
      this.isPrivate,
      this.folder = 'Home',
      @deprecated this.doctype,
      @deprecated this.docname,
      @deprecated this.docField})
      : super(file: file, fileName: fileName);

  factory FrappeUploadFileParams.fromJson(Map<String, dynamic> json) =>
      _$FrappeUploadFileParamsFromJson(json);

  @JsonKey(
      name: 'is_private',
      toJson: FrappeDocFieldConverter.boolToCheck,
      fromJson: FrappeDocFieldConverter.checkToBool)
  bool isPrivate;
  @JsonKey()
  String folder;
  String doctype;
  String docname;
  @JsonKey(name: 'docfield')
  String docField;
  @JsonKey(name: 'from_form')
  int fromForm = 1;
  @JsonKey(name: 'file_url')
  String fileUrl;

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      FrappeUploadFileParams.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$FrappeUploadFileParamsToJson(this);
}

@JsonSerializable()
class FrappeUploadFileResponse extends UploadFileResponse {
  FrappeUploadFileResponse();

  factory FrappeUploadFileResponse.fromJson(Map<String, dynamic> json) =>
      _$FrappeUploadFileResponseFromJson(json);

  @JsonKey(
      name: 'is_private',
      toJson: FrappeDocFieldConverter.boolToCheck,
      fromJson: FrappeDocFieldConverter.checkToBool)
  bool isPrivate;
  String name;

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      FrappeUploadFileResponse.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$FrappeUploadFileResponseToJson(this);
}

@JsonSerializable()
class FrappeFile extends FrappeDocument {
  FrappeFile() : super('File');

  factory FrappeFile.fromJson(Map<String, dynamic> json) =>
      _$FrappeFileFromJson(json);

  @JsonKey(name: 'file_name')
  String fileName;

  @JsonKey(
      name: 'is_private',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool isPrivate;

  @JsonKey(name: 'file_size')
  int fileSize;

  @JsonKey(name: 'file_url')
  String fileUrl;

  @JsonKey(
      name: 'is_folder',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool isFolder;

  @JsonKey(name: 'attached_to_doctype')
  String attachedToDoctype;

  @JsonKey(name: 'attached_to_name')
  String attachedToName;

  @override
  T fromJson<T>(Map<String, dynamic> json) => FrappeFile.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$FrappeFileToJson(this);
}

@JsonSerializable()
class FrappeUploadStatus extends UploadFileStatus {
  FrappeUploadStatus();

  factory FrappeUploadStatus.fromJson(Map<String, dynamic> json) =>
      _$FrappeUploadStatusFromJson(json);

  @JsonKey(ignore: true)
  RequestResponse<FrappeUploadFileResponse> r;

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      FrappeUploadStatus.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$FrappeUploadStatusToJson(this);
}

// Server response
@JsonSerializable()
class FrappeUploadRequestSlice extends JSONAble {
  FrappeUploadRequestSlice();

  num currentSlice;

  factory FrappeUploadRequestSlice.fromJson(Map<String, dynamic> json) =>
      _$FrappeUploadRequestSliceFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FrappeUploadRequestSliceToJson(this);

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      FrappeUploadRequestSlice.fromJson(json) as T;
}

// Our request
@JsonSerializable()
class FrappeUploadAcceptSlice extends JSONAble {
  FrappeUploadAcceptSlice();

  @JsonKey(name: 'is_private')
  bool isPrivate;
  String name;
  num size;
  String type;
  List<int> data;

  factory FrappeUploadAcceptSlice.fromJson(Map<String, dynamic> json) =>
      _$FrappeUploadAcceptSliceFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FrappeUploadAcceptSliceToJson(this);

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      FrappeUploadAcceptSlice.fromJson(json) as T;
}

// payload of upload-end IO event sent by server
@JsonSerializable()
class FrappeUploadEnd extends JSONAble {
  FrappeUploadEnd();

  @JsonKey(name: 'file_url')
  String fileUrl;

  factory FrappeUploadEnd.fromJson(Map<String, dynamic> json) =>
      _$FrappeUploadEndFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FrappeUploadEndToJson(this);

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      FrappeUploadEnd.fromJson(json) as T;
}
