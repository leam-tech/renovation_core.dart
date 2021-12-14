import 'package:json_annotation/json_annotation.dart';

import 'jsonable.dart';

part 'interfaces.g.dart';

/// Model representing the response structure from Frappé's endpoints
@JsonSerializable()
class FrappeResponse extends JSONAble {
  FrappeResponse();

  factory FrappeResponse.fromJson(Map<String, dynamic>? json) =>
      _$FrappeResponseFromJson(json!);

  @JsonKey(name: '_server_messages')
  String? serverMessages;

  String? exc;

  @JsonKey(name: 'exc_type')
  String? excType;

  dynamic message;

  @JsonKey(name: 'session_expired')
  int? sessionExpired;

  String? exception;

  String? data;

  String? traceback;

  @override
  Map<String, dynamic> toJson() => _$FrappeResponseToJson(this);

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      FrappeResponse.fromJson(json) as T;
}
