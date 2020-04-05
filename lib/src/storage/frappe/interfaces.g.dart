// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interfaces.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrappeUploadFileParams _$FrappeUploadFileParamsFromJson(
    Map<String, dynamic> json) {
  return FrappeUploadFileParams(
    fileName: json['filename'] as String,
    isPrivate: FrappeDocFieldConverter.checkToBool(json['is_private'] as int),
    folder: json['folder'] as String,
    doctype: json['doctype'] as String,
    docname: json['docname'] as String,
    docField: json['docfield'] as String,
  )
    ..cmd = json['cmd'] as String
    ..fileData = json['filedata'] as String
    ..fileSize = json['file_size'] as int
    ..fromForm = json['from_form'] as int
    ..fileUrl = json['file_url'] as String;
}

Map<String, dynamic> _$FrappeUploadFileParamsToJson(
    FrappeUploadFileParams instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('cmd', instance.cmd);
  writeNotNull('filename', instance.fileName);
  writeNotNull('filedata', instance.fileData);
  writeNotNull('file_size', instance.fileSize);
  writeNotNull(
      'is_private', FrappeDocFieldConverter.boolToCheck(instance.isPrivate));
  writeNotNull('folder', instance.folder);
  writeNotNull('doctype', instance.doctype);
  writeNotNull('docname', instance.docname);
  writeNotNull('docfield', instance.docField);
  writeNotNull('from_form', instance.fromForm);
  writeNotNull('file_url', instance.fileUrl);
  return val;
}

FrappeUploadFileResponse _$FrappeUploadFileResponseFromJson(
    Map<String, dynamic> json) {
  return FrappeUploadFileResponse()
    ..fileName = json['file_name'] as String
    ..fileUrl = json['file_url'] as String
    ..isPrivate = FrappeDocFieldConverter.checkToBool(json['is_private'] as int)
    ..name = json['name'] as String;
}

Map<String, dynamic> _$FrappeUploadFileResponseToJson(
    FrappeUploadFileResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('file_name', instance.fileName);
  writeNotNull('file_url', instance.fileUrl);
  writeNotNull(
      'is_private', FrappeDocFieldConverter.boolToCheck(instance.isPrivate));
  writeNotNull('name', instance.name);
  return val;
}

FrappeFile _$FrappeFileFromJson(Map<String, dynamic> json) {
  return FrappeFile()
    ..doctype = json['doctype'] as String
    ..name = json['name'] as String
    ..owner = json['owner'] as String
    ..docStatus =
        FrappeDocFieldConverter.intToFrappeDocStatus(json['docstatus'] as int)
    ..isLocal = FrappeDocFieldConverter.checkToBool(json['__islocal'] as int)
    ..unsaved = FrappeDocFieldConverter.checkToBool(json['__unsaved'] as int)
    ..amendedFrom = json['amended_from'] as String
    ..idx = FrappeDocFieldConverter.idxFromString(json['idx'])
    ..parent = json['parent'] as String
    ..parentType = json['parenttype'] as String
    ..creation = json['creation'] == null
        ? null
        : DateTime.parse(json['creation'] as String)
    ..parentField = json['parentfield'] as String
    ..modified = json['modified'] == null
        ? null
        : DateTime.parse(json['modified'] as String)
    ..modifiedBy = json['modified_by'] as String
    ..fileName = json['file_name'] as String
    ..isPrivate = FrappeDocFieldConverter.checkToBool(json['is_private'] as int)
    ..fileSize = json['file_size'] as int
    ..fileUrl = json['file_url'] as String
    ..isFolder = FrappeDocFieldConverter.checkToBool(json['is_folder'] as int)
    ..attachedToDoctype = json['attached_to_doctype'] as String
    ..attachedToName = json['attached_to_name'] as String;
}

Map<String, dynamic> _$FrappeFileToJson(FrappeFile instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('doctype', instance.doctype);
  writeNotNull('name', instance.name);
  writeNotNull('owner', instance.owner);
  writeNotNull('docstatus',
      FrappeDocFieldConverter.frappeDocStatusToInt(instance.docStatus));
  writeNotNull(
      '__islocal', FrappeDocFieldConverter.boolToCheck(instance.isLocal));
  writeNotNull(
      '__unsaved', FrappeDocFieldConverter.boolToCheck(instance.unsaved));
  writeNotNull('amended_from', instance.amendedFrom);
  writeNotNull('idx', instance.idx);
  writeNotNull('parent', instance.parent);
  writeNotNull('parenttype', instance.parentType);
  writeNotNull(
      'creation', FrappeDocFieldConverter.toFrappeDateTime(instance.creation));
  writeNotNull('parentfield', instance.parentField);
  writeNotNull(
      'modified', FrappeDocFieldConverter.toFrappeDateTime(instance.modified));
  writeNotNull('modified_by', instance.modifiedBy);
  writeNotNull('file_name', instance.fileName);
  writeNotNull(
      'is_private', FrappeDocFieldConverter.boolToCheck(instance.isPrivate));
  writeNotNull('file_size', instance.fileSize);
  writeNotNull('file_url', instance.fileUrl);
  writeNotNull(
      'is_folder', FrappeDocFieldConverter.boolToCheck(instance.isFolder));
  writeNotNull('attached_to_doctype', instance.attachedToDoctype);
  writeNotNull('attached_to_name', instance.attachedToName);
  return val;
}

FrappeUploadStatus _$FrappeUploadStatusFromJson(Map<String, dynamic> json) {
  return FrappeUploadStatus()
    ..status = _$enumDecodeNullable(_$UploadingStatusEnumMap, json['status'])
    ..hasProgress = json['hasProgress'] as bool
    ..progress = json['progress'] as num
    ..error = _$enumDecodeNullable(_$ErrorEventEnumMap, json['error'])
    ..filename = json['filename'] as String;
}

Map<String, dynamic> _$FrappeUploadStatusToJson(FrappeUploadStatus instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('status', _$UploadingStatusEnumMap[instance.status]);
  writeNotNull('hasProgress', instance.hasProgress);
  writeNotNull('progress', instance.progress);
  writeNotNull('error', _$ErrorEventEnumMap[instance.error]);
  writeNotNull('filename', instance.filename);
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$UploadingStatusEnumMap = {
  UploadingStatus.ready: 'ready',
  UploadingStatus.uploading: 'uploading',
  UploadingStatus.completed: 'completed',
  UploadingStatus.error: 'error',
  UploadingStatus.detail_error: 'detail_error',
};

const _$ErrorEventEnumMap = {
  ErrorEvent.no_socketio: 'no_socketio',
  ErrorEvent.disconnected: 'disconnected',
  ErrorEvent.upload_error: 'upload_error',
  ErrorEvent.name_error: 'name_error',
  ErrorEvent.socket_timeout: 'socket_timeout',
};

FrappeUploadRequestSlice _$FrappeUploadRequestSliceFromJson(
    Map<String, dynamic> json) {
  return FrappeUploadRequestSlice()..currentSlice = json['currentSlice'] as num;
}

Map<String, dynamic> _$FrappeUploadRequestSliceToJson(
    FrappeUploadRequestSlice instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('currentSlice', instance.currentSlice);
  return val;
}

FrappeUploadAcceptSlice _$FrappeUploadAcceptSliceFromJson(
    Map<String, dynamic> json) {
  return FrappeUploadAcceptSlice()
    ..isPrivate = json['is_private'] as bool
    ..name = json['name'] as String
    ..size = json['size'] as num
    ..type = json['type'] as String
    ..data = (json['data'] as List)?.map((e) => e as int)?.toList();
}

Map<String, dynamic> _$FrappeUploadAcceptSliceToJson(
    FrappeUploadAcceptSlice instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('is_private', instance.isPrivate);
  writeNotNull('name', instance.name);
  writeNotNull('size', instance.size);
  writeNotNull('type', instance.type);
  writeNotNull('data', instance.data);
  return val;
}

FrappeUploadEnd _$FrappeUploadEndFromJson(Map<String, dynamic> json) {
  return FrappeUploadEnd()..fileUrl = json['file_url'] as String;
}

Map<String, dynamic> _$FrappeUploadEndToJson(FrappeUploadEnd instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('file_url', instance.fileUrl);
  return val;
}
