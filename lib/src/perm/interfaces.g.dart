// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interfaces.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasicPermInfo _$BasicPermInfoFromJson(Map<String, dynamic> json) =>
    BasicPermInfo()
      ..can_search = (json['can_search'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..can_email = (json['can_email'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..can_export = (json['can_export'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..can_get_report = (json['can_get_report'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..can_cancel = (json['can_cancel'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..can_print = (json['can_print'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..can_set_user_permissions =
          (json['can_set_user_permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
      ..can_delete = (json['can_delete'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..can_write = (json['can_write'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..can_import = (json['can_import'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..can_read =
          (json['can_read'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..can_create = (json['can_create'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..isLoading = json['isLoading'] as bool?
      ..user = json['user'] as String?;

Map<String, dynamic> _$BasicPermInfoToJson(BasicPermInfo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('can_search', instance.can_search);
  writeNotNull('can_email', instance.can_email);
  writeNotNull('can_export', instance.can_export);
  writeNotNull('can_get_report', instance.can_get_report);
  writeNotNull('can_cancel', instance.can_cancel);
  writeNotNull('can_print', instance.can_print);
  writeNotNull('can_set_user_permissions', instance.can_set_user_permissions);
  writeNotNull('can_delete', instance.can_delete);
  writeNotNull('can_write', instance.can_write);
  writeNotNull('can_import', instance.can_import);
  writeNotNull('can_read', instance.can_read);
  writeNotNull('can_create', instance.can_create);
  writeNotNull('isLoading', instance.isLoading);
  writeNotNull('user', instance.user);
  return val;
}
