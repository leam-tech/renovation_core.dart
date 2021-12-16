// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interfaces.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocPerm _$DocPermFromJson(Map<String, dynamic> json) => DocPerm()
  ..doctype = json['doctype'] as String?
  ..name = json['name'] as String?
  ..owner = json['owner'] as String?
  ..docStatus =
      FrappeDocFieldConverter.intToFrappeDocStatus(json['docstatus'] as int?)
  ..isLocal = FrappeDocFieldConverter.checkToBool(json['__islocal'] as int?)
  ..unsaved = FrappeDocFieldConverter.checkToBool(json['__unsaved'] as int?)
  ..amendedFrom = json['amended_from'] as String?
  ..idx = FrappeDocFieldConverter.idxFromString(json['idx'])
  ..parent = json['parent'] as String?
  ..parentType = json['parenttype'] as String?
  ..creation = json['creation'] == null
      ? null
      : DateTime.parse(json['creation'] as String)
  ..parentField = json['parentfield'] as String?
  ..modified = json['modified'] == null
      ? null
      : DateTime.parse(json['modified'] as String)
  ..modifiedBy = json['modified_by'] as String?
  ..create = FrappeDocFieldConverter.checkToBool(json['create'] as int?)
  ..read = FrappeDocFieldConverter.checkToBool(json['read'] as int?)
  ..write = FrappeDocFieldConverter.checkToBool(json['write'] as int?)
  ..delete = FrappeDocFieldConverter.checkToBool(json['delete'] as int?)
  ..submit = FrappeDocFieldConverter.checkToBool(json['submit'] as int?)
  ..cancel = FrappeDocFieldConverter.checkToBool(json['cancel'] as int?)
  ..amend = FrappeDocFieldConverter.checkToBool(json['amend'] as int?)
  ..report = FrappeDocFieldConverter.checkToBool(json['report'] as int?)
  ..import = FrappeDocFieldConverter.checkToBool(json['import'] as int?)
  ..export = FrappeDocFieldConverter.checkToBool(json['export'] as int?)
  ..print = FrappeDocFieldConverter.checkToBool(json['print'] as int?)
  ..email = FrappeDocFieldConverter.checkToBool(json['email'] as int?)
  ..share = FrappeDocFieldConverter.checkToBool(json['share'] as int?)
  ..recursiveDelete =
      FrappeDocFieldConverter.checkToBool(json['recursive_delete'] as int?)
  ..setUserPermissions =
      FrappeDocFieldConverter.checkToBool(json['set_user_permissions'] as int?)
  ..permLevel = json['permlevel'] as int?
  ..ifOwner = DocPerm.ifOwnerCheckToBool(json['if_owner'])
  ..role = json['role'] as String?
  ..match = json['match'];

Map<String, dynamic> _$DocPermToJson(DocPerm instance) {
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
  writeNotNull('create', FrappeDocFieldConverter.boolToCheck(instance.create));
  writeNotNull('read', FrappeDocFieldConverter.boolToCheck(instance.read));
  writeNotNull('write', FrappeDocFieldConverter.boolToCheck(instance.write));
  writeNotNull('delete', FrappeDocFieldConverter.boolToCheck(instance.delete));
  writeNotNull('submit', FrappeDocFieldConverter.boolToCheck(instance.submit));
  writeNotNull('cancel', FrappeDocFieldConverter.boolToCheck(instance.cancel));
  writeNotNull('amend', FrappeDocFieldConverter.boolToCheck(instance.amend));
  writeNotNull('report', FrappeDocFieldConverter.boolToCheck(instance.report));
  writeNotNull('import', FrappeDocFieldConverter.boolToCheck(instance.import));
  writeNotNull('export', FrappeDocFieldConverter.boolToCheck(instance.export));
  writeNotNull('print', FrappeDocFieldConverter.boolToCheck(instance.print));
  writeNotNull('email', FrappeDocFieldConverter.boolToCheck(instance.email));
  writeNotNull('share', FrappeDocFieldConverter.boolToCheck(instance.share));
  writeNotNull('recursive_delete',
      FrappeDocFieldConverter.boolToCheck(instance.recursiveDelete));
  writeNotNull('set_user_permissions',
      FrappeDocFieldConverter.boolToCheck(instance.setUserPermissions));
  writeNotNull('permlevel', instance.permLevel);
  writeNotNull(
      'if_owner', FrappeDocFieldConverter.boolToCheck(instance.ifOwner));
  writeNotNull('role', instance.role);
  writeNotNull('match', instance.match);
  return val;
}
