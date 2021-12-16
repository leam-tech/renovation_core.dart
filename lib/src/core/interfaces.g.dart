// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interfaces.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrappeResponse _$FrappeResponseFromJson(Map<String, dynamic> json) =>
    FrappeResponse()
      ..serverMessages = json['_server_messages'] as String?
      ..exc = json['exc'] as String?
      ..excType = json['exc_type'] as String?
      ..message = json['message']
      ..sessionExpired = json['session_expired'] as int?
      ..exception = json['exception'] as String?
      ..data = json['data'] as String?
      ..traceback = json['traceback'] as String?;

Map<String, dynamic> _$FrappeResponseToJson(FrappeResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_server_messages', instance.serverMessages);
  writeNotNull('exc', instance.exc);
  writeNotNull('exc_type', instance.excType);
  writeNotNull('message', instance.message);
  writeNotNull('session_expired', instance.sessionExpired);
  writeNotNull('exception', instance.exception);
  writeNotNull('data', instance.data);
  writeNotNull('traceback', instance.traceback);
  return val;
}
