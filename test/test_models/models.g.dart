// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RenovationUserAgreement _$RenovationUserAgreementFromJson(
        Map<String, dynamic> json) =>
    RenovationUserAgreement()
      ..doctype = json['doctype'] as String?
      ..name = json['name'] as String?
      ..owner = json['owner'] as String?
      ..docStatus = FrappeDocFieldConverter.intToFrappeDocStatus(
          json['docstatus'] as int?)
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
      ..title = json['title'] as String?;

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

RenovationReview _$RenovationReviewFromJson(Map<String, dynamic> json) =>
    RenovationReview()
      ..doctype = json['doctype'] as String?
      ..name = json['name'] as String?
      ..owner = json['owner'] as String?
      ..docStatus = FrappeDocFieldConverter.intToFrappeDocStatus(
          json['docstatus'] as int?)
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
      ..reviewedByDoctype = json['reviewed_by_doctype'] as String?
      ..reviewedBy = json['reviewed_by'] as String?
      ..reviewedByDoctypeDoc = json['reviewed_by_doctype_doc'] == null
          ? null
          : DocType.fromJson(
              json['reviewed_by_doctype_doc'] as Map<String, dynamic>?)
      ..reviewedDoctype = json['reviewed_doctype'] as String?
      ..reviewedEntity = json['reviewed_entity'] as String?
      ..reviews = (json['reviews'] as List<dynamic>?)
          ?.map(
              (e) => RenovationReviewItem.fromJson(e as Map<String, dynamic>?))
          .toList();

Map<String, dynamic> _$RenovationReviewToJson(RenovationReview instance) {
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
  writeNotNull('reviewed_by_doctype', instance.reviewedByDoctype);
  writeNotNull('reviewed_by', instance.reviewedBy);
  writeNotNull(
      'reviewed_by_doctype_doc', instance.reviewedByDoctypeDoc?.toJson());
  writeNotNull('reviewed_doctype', instance.reviewedDoctype);
  writeNotNull('reviewed_entity', instance.reviewedEntity);
  writeNotNull('reviews', instance.reviews?.map((e) => e.toJson()).toList());
  return val;
}

RenovationReviewItem _$RenovationReviewItemFromJson(
        Map<String, dynamic> json) =>
    RenovationReviewItem()
      ..doctype = json['doctype'] as String?
      ..name = json['name'] as String?
      ..owner = json['owner'] as String?
      ..docStatus = FrappeDocFieldConverter.intToFrappeDocStatus(
          json['docstatus'] as int?)
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
      ..title = json['title'] as String?
      ..question = json['question'] as String?
      ..quantitative = json['quantitative'] as String?
      ..answer = json['answer'] as String?;

Map<String, dynamic> _$RenovationReviewItemToJson(
    RenovationReviewItem instance) {
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
  writeNotNull('question', instance.question);
  writeNotNull('quantitative', instance.quantitative);
  writeNotNull('answer', instance.answer);
  return val;
}

NonExistingDocType _$NonExistingDocTypeFromJson(Map<String, dynamic> json) =>
    NonExistingDocType()
      ..doctype = json['doctype'] as String?
      ..name = json['name'] as String?
      ..owner = json['owner'] as String?
      ..docStatus = FrappeDocFieldConverter.intToFrappeDocStatus(
          json['docstatus'] as int?)
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
      ..modifiedBy = json['modified_by'] as String?;

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
