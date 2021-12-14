import 'package:json_annotation/json_annotation.dart';

import '../core/jsonable.dart';

part 'interfaces.g.dart';

@JsonSerializable()
class BasicPermInfo extends JSONAble {
  BasicPermInfo();

  factory BasicPermInfo.fromJson(Map<String, dynamic>? json) =>
      _$BasicPermInfoFromJson(json!);

  List<String>? can_search;
  List<String>? can_email;
  List<String>? can_export;
  List<String>? can_get_report;
  List<String>? can_cancel;
  List<String>? can_print;
  List<String>? can_set_user_permissions;
  List<String>? can_delete;
  List<String>? can_write;
  List<String>? can_import;
  List<String>? can_read;
  List<String>? can_create;
  bool? isLoading;
  String? user;

  @override
  T fromJson<T>(Map<String, dynamic>? json) => BasicPermInfo.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$BasicPermInfoToJson(this);
}

enum PermissionType {
  create,
  read,
  write,
  delete,
  submit,
  cancel,
  amend,
  report,
  import,
  export,
  print,
  recursive_delete,
  email,
  share,
  set_user_permissions
}
