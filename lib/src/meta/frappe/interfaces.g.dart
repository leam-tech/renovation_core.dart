// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interfaces.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrappeDocInfo _$FrappeDocInfoFromJson(Map<String, dynamic> json) =>
    FrappeDocInfo()
      ..attachments = (json['attachments'] as List<dynamic>?)
          ?.map((e) => FrappeFile.fromJson(e as Map<String, dynamic>?))
          .toList()
      ..communications = (json['communications'] as List<dynamic>?)
          ?.map((e) => FrappeCommunication.fromJson(e as Map<String, dynamic>?))
          .toList()
      ..comments = (json['comments'] as List<dynamic>?)
          ?.map((e) => FrappeComment.fromJson(e as Map<String, dynamic>?))
          .toList()
      ..totalComments = json['total_comments'] as int?
      ..versions = (json['versions'] as List<dynamic>?)
          ?.map((e) => FrappeVersion.fromJson(e as Map<String, dynamic>?))
          .toList()
      ..assignments = (json['assignments'] as List<dynamic>?)
          ?.map((e) => ToDo.fromJson(e as Map<String, dynamic>?))
          .toList()
      ..permissions = json['permissions'] == null
          ? null
          : DocPerm.fromJson(json['permissions'] as Map<String, dynamic>?)
      ..shared = (json['shared'] as List<dynamic>?)
          ?.map((e) => FrappeSharedSetting.fromJson(e as Map<String, dynamic>?))
          .toList()
      ..views = (json['views'] as List<dynamic>?)
          ?.map((e) => FrappeViewLog.fromJson(e as Map<String, dynamic>?))
          .toList()
      ..milestones = (json['milestones'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList()
      ..energyPointLogs = (json['energy_point_logs'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList()
      ..isDocumentFollowed = FrappeDocFieldConverter.checkToBool(
          json['is_document_followed'] as int?)
      ..tags = json['tags'] as String?;

Map<String, dynamic> _$FrappeDocInfoToJson(FrappeDocInfo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'attachments', instance.attachments?.map((e) => e.toJson()).toList());
  writeNotNull('communications',
      instance.communications?.map((e) => e.toJson()).toList());
  writeNotNull('comments', instance.comments?.map((e) => e.toJson()).toList());
  writeNotNull('total_comments', instance.totalComments);
  writeNotNull('versions', instance.versions?.map((e) => e.toJson()).toList());
  writeNotNull(
      'assignments', instance.assignments?.map((e) => e.toJson()).toList());
  writeNotNull('permissions', instance.permissions?.toJson());
  writeNotNull('shared', instance.shared?.map((e) => e.toJson()).toList());
  writeNotNull('views', instance.views?.map((e) => e.toJson()).toList());
  writeNotNull('milestones', instance.milestones);
  writeNotNull('energy_point_logs', instance.energyPointLogs);
  writeNotNull('is_document_followed',
      FrappeDocFieldConverter.boolToCheck(instance.isDocumentFollowed));
  writeNotNull('tags', instance.tags);
  return val;
}

FrappeCommunication _$FrappeCommunicationFromJson(Map<String, dynamic> json) =>
    FrappeCommunication()
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
      ..communicationType = json['communication_type'] as String?
      ..communicationMedium = json['communication_medium'] as String?
      ..commentType = json['comment_tyoe'] as String?
      ..communicationDate = json['communication_date'] == null
          ? null
          : DateTime.parse(json['communication_date'] as String)
      ..content = json['content'] as String?
      ..sender = json['sender'] as String?
      ..senderFullName = json['sender_full_name'] as String?
      ..cc = json['cc'] as String?
      ..bcc = json['bcc'] as String?
      ..subject = json['subject'] as String?
      ..deliveryStatus = json['delivery_status'] as String?
      ..referenceDoctype = json['reference_doctype'] as String?
      ..referenceName = json['reference_name'] as String?
      ..readByRecipient = FrappeDocFieldConverter.checkToBool(
          json['read_by_recipient'] as int?);

Map<String, dynamic> _$FrappeCommunicationToJson(FrappeCommunication instance) {
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
  writeNotNull('communication_type', instance.communicationType);
  writeNotNull('communication_medium', instance.communicationMedium);
  writeNotNull('comment_tyoe', instance.commentType);
  writeNotNull('communication_date',
      FrappeDocFieldConverter.toFrappeDateTime(instance.communicationDate));
  writeNotNull('content', instance.content);
  writeNotNull('sender', instance.sender);
  writeNotNull('sender_full_name', instance.senderFullName);
  writeNotNull('cc', instance.cc);
  writeNotNull('bcc', instance.bcc);
  writeNotNull('subject', instance.subject);
  writeNotNull('delivery_status', instance.deliveryStatus);
  writeNotNull('reference_doctype', instance.referenceDoctype);
  writeNotNull('reference_name', instance.referenceName);
  writeNotNull('read_by_recipient',
      FrappeDocFieldConverter.boolToCheck(instance.readByRecipient));
  return val;
}

FrappeComment _$FrappeCommentFromJson(Map<String, dynamic> json) =>
    FrappeComment()
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
      ..commentEmail = json['comment_email'] as String?
      ..commentType = json['comment_type'] as String?
      ..subject = json['subject'] as String?
      ..commentBy = json['comment_by'] as String?
      ..published =
          FrappeDocFieldConverter.checkToBool(json['published'] as int?)
      ..seen = FrappeDocFieldConverter.checkToBool(json['seen'] as int?)
      ..content = json['content'] as String?
      ..referenceOwner = json['reference_owner'] as String?
      ..referenceDoctype = json['reference_doctype'] as String?
      ..referenceName = json['reference_name'] as String?
      ..linkDoctype = json['link_doctype'] as String?
      ..linkName = json['link_name'] as String?;

Map<String, dynamic> _$FrappeCommentToJson(FrappeComment instance) {
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
  writeNotNull('comment_email', instance.commentEmail);
  writeNotNull('comment_type', instance.commentType);
  writeNotNull('subject', instance.subject);
  writeNotNull('comment_by', instance.commentBy);
  writeNotNull(
      'published', FrappeDocFieldConverter.boolToCheck(instance.published));
  writeNotNull('seen', FrappeDocFieldConverter.boolToCheck(instance.seen));
  writeNotNull('content', instance.content);
  writeNotNull('reference_owner', instance.referenceOwner);
  writeNotNull('reference_doctype', instance.referenceDoctype);
  writeNotNull('reference_name', instance.referenceName);
  writeNotNull('link_doctype', instance.linkDoctype);
  writeNotNull('link_name', instance.linkName);
  return val;
}

FrappeVersion _$FrappeVersionFromJson(Map<String, dynamic> json) =>
    FrappeVersion()
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
      ..data = json['data'] as String?
      ..ref_doctype = json['ref_doctype'] as String?
      ..docname = json['docname'] as String?;

Map<String, dynamic> _$FrappeVersionToJson(FrappeVersion instance) {
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
  writeNotNull('data', instance.data);
  writeNotNull('ref_doctype', instance.ref_doctype);
  writeNotNull('docname', instance.docname);
  return val;
}

FrappeSharedSetting _$FrappeSharedSettingFromJson(Map<String, dynamic> json) =>
    FrappeSharedSetting()
      ..user = json['user'] as String?
      ..read = FrappeDocFieldConverter.checkToBool(json['read'] as int?)
      ..write = FrappeDocFieldConverter.checkToBool(json['write'] as int?)
      ..share = FrappeDocFieldConverter.checkToBool(json['share'] as int?)
      ..everyone =
          FrappeDocFieldConverter.checkToBool(json['everyone'] as int?);

Map<String, dynamic> _$FrappeSharedSettingToJson(FrappeSharedSetting instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('user', instance.user);
  writeNotNull('read', FrappeDocFieldConverter.boolToCheck(instance.read));
  writeNotNull('write', FrappeDocFieldConverter.boolToCheck(instance.write));
  writeNotNull('share', FrappeDocFieldConverter.boolToCheck(instance.share));
  writeNotNull(
      'everyone', FrappeDocFieldConverter.boolToCheck(instance.everyone));
  return val;
}

FrappeViewLog _$FrappeViewLogFromJson(Map<String, dynamic> json) =>
    FrappeViewLog()
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
      ..viewedBy = json['viewedBy'] as String?
      ..referenceDoctype = json['reference_doctype'] as String?
      ..referenceName = json['reference_name'] as String?;

Map<String, dynamic> _$FrappeViewLogToJson(FrappeViewLog instance) {
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
  writeNotNull('viewedBy', instance.viewedBy);
  writeNotNull('reference_doctype', instance.referenceDoctype);
  writeNotNull('reference_name', instance.referenceName);
  return val;
}

RenovationReport _$RenovationReportFromJson(Map<String, dynamic> json) =>
    RenovationReport()
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
      ..report = json['report'] as String?
      ..filters = (json['filters'] as List<dynamic>?)
          ?.map((e) =>
              RenovationReportFilter.fromJson(e as Map<String, dynamic>?))
          .toList();

Map<String, dynamic> _$RenovationReportToJson(RenovationReport instance) {
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
  writeNotNull('report', instance.report);
  writeNotNull('filters', instance.filters?.map((e) => e.toJson()).toList());
  return val;
}

RenovationReportFilter _$RenovationReportFilterFromJson(
        Map<String, dynamic> json) =>
    RenovationReportFilter()
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
      ..defaultValue = json['default_value'] as String?
      ..fieldName = json['fieldname'] as String?
      ..fieldType = json['fieldtype'] as String?
      ..options = json['options'] as String?
      ..label = json['label'] as String?
      ..required = FrappeDocFieldConverter.checkToBool(json['reqd'] as int?);

Map<String, dynamic> _$RenovationReportFilterToJson(
    RenovationReportFilter instance) {
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
  writeNotNull('default_value', instance.defaultValue);
  writeNotNull('fieldname', instance.fieldName);
  writeNotNull('fieldtype', instance.fieldType);
  writeNotNull('options', instance.options);
  writeNotNull('label', instance.label);
  writeNotNull('reqd', FrappeDocFieldConverter.boolToCheck(instance.required));
  return val;
}
