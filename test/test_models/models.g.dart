// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RenovationUserAgreement _$RenovationUserAgreementFromJson(
    Map<String, dynamic> json) {
  return RenovationUserAgreement()
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
    ..title = json['title'] as String;
}

Map<String, dynamic> _$RenovationUserAgreementToJson(
    RenovationUserAgreement instance) {
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
  writeNotNull('title', instance.title);
  return val;
}

ItemGroup _$ItemGroupFromJson(Map<String, dynamic> json) {
  return ItemGroup()
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
    ..parentItemGroupDoc = json['parent_item_group_doc'] == null
        ? null
        : ParentItemGroup.fromJson(
            json['parent_item_group_doc'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ItemGroupToJson(ItemGroup instance) {
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
  writeNotNull('parent_item_group_doc', instance.parentItemGroupDoc?.toJson());
  return val;
}

ParentItemGroup _$ParentItemGroupFromJson(Map<String, dynamic> json) {
  return ParentItemGroup()
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
    ..modifiedBy = json['modified_by'] as String;
}

Map<String, dynamic> _$ParentItemGroupToJson(ParentItemGroup instance) {
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
  return val;
}

ItemAttribute _$ItemAttributeFromJson(Map<String, dynamic> json) {
  return ItemAttribute()
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
    ..itemAttributeValues = (json['item_attribute_values'] as List)
        ?.map((e) => e == null
            ? null
            : ItemAttributeValue.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..attributeName = json['attribute_name'] as String;
}

Map<String, dynamic> _$ItemAttributeToJson(ItemAttribute instance) {
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
  writeNotNull('item_attribute_values',
      instance.itemAttributeValues?.map((e) => e?.toJson())?.toList());
  writeNotNull('attribute_name', instance.attributeName);
  return val;
}

ItemAttributeValue _$ItemAttributeValueFromJson(Map<String, dynamic> json) {
  return ItemAttributeValue()
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
    ..attributeValue = json['attribute_value'] as String
    ..abbr = json['abbr'] as String;
}

Map<String, dynamic> _$ItemAttributeValueToJson(ItemAttributeValue instance) {
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
  writeNotNull('attribute_value', instance.attributeValue);
  writeNotNull('abbr', instance.abbr);
  return val;
}

NonExistingDocType _$NonExistingDocTypeFromJson(Map<String, dynamic> json) {
  return NonExistingDocType()
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
    ..modifiedBy = json['modified_by'] as String;
}

Map<String, dynamic> _$NonExistingDocTypeToJson(NonExistingDocType instance) {
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
  return val;
}
