import 'package:json_annotation/json_annotation.dart';

import '../../model/frappe/document.dart';
import '../../model/frappe/utils.dart';

part 'interfaces.g.dart';

/// isOwner & ifOwner
/// isOwner is available in DocPerm only.
/// ifOwner is available in Permission
///  isOwner specifies that this instance (or line) of DocPerm is applicable only if user is owner
///  ifOwner signifies the set of permissions to apply if user if the owner
@JsonSerializable()
class DocPerm extends FrappeDocument {
  DocPerm() : super('DocPerm');

  factory DocPerm.fromJson(Map<String, dynamic>? json) =>
      _$DocPermFromJson(json!);

  @JsonKey(
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool create = false;
  @JsonKey(
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool read = false;
  @JsonKey(
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool write = false;
  @JsonKey(
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool delete = false;
  @JsonKey(
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool submit = false;
  @JsonKey(
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool cancel = false;
  @JsonKey(
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool amend = false;
  @JsonKey(
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool report = false;
  @JsonKey(
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool import = false;
  @JsonKey(
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool export = false;
  @JsonKey(
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool print = false;
  @JsonKey(
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool email = false;
  @JsonKey(
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool share = false;
  @JsonKey(
      name: 'recursive_delete',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool recursiveDelete = false;
  @JsonKey(
      name: 'set_user_permissions',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool setUserPermissions = false;
  @JsonKey(name: 'permlevel')
  int? permLevel;

  @JsonKey(
      name: 'if_owner',
      fromJson: ifOwnerCheckToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool ifOwner = false;

  String? role;

  dynamic match;

  /// A wrapper on [FrappeDocFieldConverter.checkToBool] for scenarios
  /// where if_owner could be an empty object, when if_owner is not defined for a doc
  static bool ifOwnerCheckToBool(dynamic value) {
    if (value is Map) {
      return false;
    }
    return FrappeDocFieldConverter.checkToBool(value);
  }

  @override
  Map<String, dynamic> toJson() => _$DocPermToJson(this);

  @override
  T fromJson<T>(Map<String, dynamic>? json) => DocPerm.fromJson(json) as T;
}
