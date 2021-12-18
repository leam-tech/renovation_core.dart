// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interfaces.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetListParams _$GetListParamsFromJson(Map<String, dynamic> json) =>
    GetListParams(
      json['doctype'] as String?,
      fields: json['fields'] as String?,
      orderBy: json['order_by'] as String?,
      limitPageLength: json['limit_page_length'] as int?,
      limitPageStart: json['limit_start'] as int?,
      filters: json['filters'],
      parent: json['parent'] as String?,
      tableFieldsFrappe: json['table_fields'] as String?,
      withLinkFieldsFrappe: json['with_link_fields'] as String?,
    )..cmd = json['cmd'] as String?;

Map<String, dynamic> _$GetListParamsToJson(GetListParams instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('cmd', instance.cmd);
  writeNotNull('doctype', instance.doctype);
  writeNotNull('fields', instance.fields);
  writeNotNull('order_by', instance.orderBy);
  writeNotNull('limit_start', instance.limitPageStart);
  writeNotNull('limit_page_length', instance.limitPageLength);
  writeNotNull('filters', instance.filters);
  writeNotNull('parent', instance.parent);
  writeNotNull('table_fields', instance.tableFieldsFrappe);
  writeNotNull('with_link_fields', instance.withLinkFieldsFrappe);
  return val;
}

GetValueParams _$GetValueParamsFromJson(Map<String, dynamic> json) =>
    GetValueParams(
      json['doctype'] as String?,
      json['filters'] as String?,
      json['fieldname'] as String?,
    )..cmd = json['cmd'] as String?;

Map<String, dynamic> _$GetValueParamsToJson(GetValueParams instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('cmd', instance.cmd);
  writeNotNull('doctype', instance.doctype);
  writeNotNull('filters', instance.docname);
  writeNotNull('fieldname', instance.docfield);
  return val;
}

SetValueParams _$SetValueParamsFromJson(Map<String, dynamic> json) =>
    SetValueParams(
      json['doctype'] as String?,
      json['name'] as String?,
      json['fieldname'] as String?,
      json['value'],
    )..cmd = json['cmd'] as String?;

Map<String, dynamic> _$SetValueParamsToJson(SetValueParams instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('cmd', instance.cmd);
  writeNotNull('doctype', instance.doctype);
  writeNotNull('name', instance.docname);
  writeNotNull('fieldname', instance.docfield);
  writeNotNull('value', instance.value);
  return val;
}

SearchLinkResponse _$SearchLinkResponseFromJson(Map<String, dynamic> json) =>
    SearchLinkResponse()
      ..description = json['description'] as String?
      ..value = json['value'] as String?;

Map<String, dynamic> _$SearchLinkResponseToJson(SearchLinkResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('value', instance.value);
  return val;
}

AssignDocParams _$AssignDocParamsFromJson(Map<String, dynamic> json) =>
    AssignDocParams(
      assignTo: json['assign_to'] as String?,
      myself: json['myself'] as bool?,
      description: json['description'] as String?,
      dueDate:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      doctype: json['doctype'] as String?,
      notify: json['notify'] as bool?,
      priority: $enumDecodeNullable(_$PriorityEnumMap, json['priority']),
      bulkAssign: json['bulk_assign'] as bool? ?? false,
    )
      ..cmd = json['cmd'] as String?
      ..name = json['name'] as String?;

Map<String, dynamic> _$AssignDocParamsToJson(AssignDocParams instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('cmd', instance.cmd);
  writeNotNull('name', instance.name);
  writeNotNull('assign_to', instance.assignTo);
  writeNotNull('myself', FrappeDocFieldConverter.boolToCheck(instance.myself));
  writeNotNull('description', instance.description);
  writeNotNull(
      'date', FrappeDocFieldConverter.toFrappeDateTime(instance.dueDate));
  writeNotNull('doctype', instance.doctype);
  writeNotNull('notify', FrappeDocFieldConverter.boolToCheck(instance.notify));
  writeNotNull('priority', _$PriorityEnumMap[instance.priority]);
  writeNotNull(
      'bulk_assign', FrappeDocFieldConverter.boolToCheck(instance.bulkAssign));
  return val;
}

const _$PriorityEnumMap = {
  Priority.Low: 'Low',
  Priority.Medium: 'Medium',
  Priority.High: 'High',
};

GetDocsAssignedToUserParams _$GetDocsAssignedToUserParamsFromJson(
        Map<String, dynamic> json) =>
    GetDocsAssignedToUserParams(
      assignedTo: json['user'] as String?,
      doctype: json['doctype'] as String?,
      status: $enumDecodeNullable(_$StatusEnumMap, json['status']),
    )..cmd = json['cmd'] as String?;

Map<String, dynamic> _$GetDocsAssignedToUserParamsToJson(
    GetDocsAssignedToUserParams instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('cmd', instance.cmd);
  writeNotNull('user', instance.assignedTo);
  writeNotNull('doctype', instance.doctype);
  writeNotNull('status', _$StatusEnumMap[instance.status]);
  return val;
}

const _$StatusEnumMap = {
  Status.Open: 'Open',
  Status.Closed: 'Closed',
  Status.Cancelled: 'Cancelled',
};

GetDocsAssignedToUserResponse _$GetDocsAssignedToUserResponseFromJson(
        Map<String, dynamic> json) =>
    GetDocsAssignedToUserResponse(
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      status: $enumDecodeNullable(_$StatusEnumMap, json['status']),
      assignedBy: json['assignedBy'] as String?,
      assignedByFullName: json['assignedByFullName'] as String?,
      assignedTo: json['assignedTo'] as String?,
      assignedToFullName: json['assignedToFullName'] as String?,
      priority: $enumDecodeNullable(_$PriorityEnumMap, json['priority']),
      description: json['description'] as String?,
      doctype: json['doctype'] as String?,
      docname: json['docname'] as String?,
    );

Map<String, dynamic> _$GetDocsAssignedToUserResponseToJson(
    GetDocsAssignedToUserResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('dueDate', instance.dueDate?.toIso8601String());
  writeNotNull('status', _$StatusEnumMap[instance.status]);
  writeNotNull('assignedBy', instance.assignedBy);
  writeNotNull('assignedByFullName', instance.assignedByFullName);
  writeNotNull('assignedTo', instance.assignedTo);
  writeNotNull('assignedToFullName', instance.assignedToFullName);
  writeNotNull('priority', _$PriorityEnumMap[instance.priority]);
  writeNotNull('description', instance.description);
  writeNotNull('doctype', instance.doctype);
  writeNotNull('docname', instance.docname);
  return val;
}

CompleteDocAssignmentParams _$CompleteDocAssignmentParamsFromJson(
        Map<String, dynamic> json) =>
    CompleteDocAssignmentParams(
      doctype: json['doctype'] as String?,
      name: json['name'] as String?,
      assignedTo: json['assign_to'] as String?,
    )..cmd = json['cmd'] as String?;

Map<String, dynamic> _$CompleteDocAssignmentParamsToJson(
    CompleteDocAssignmentParams instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('cmd', instance.cmd);
  writeNotNull('doctype', instance.doctype);
  writeNotNull('name', instance.name);
  writeNotNull('assign_to', instance.assignedTo);
  return val;
}

ToDo _$ToDoFromJson(Map<String, dynamic> json) => ToDo()
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
  ..status = $enumDecodeNullable(_$StatusEnumMap, json['status'])
  ..priority = $enumDecodeNullable(_$PriorityEnumMap, json['priority'])
  ..date = json['date'] == null ? null : DateTime.parse(json['date'] as String)
  ..description = json['description'] as String?
  ..referenceType = json['reference_type'] as String?
  ..referenceName = json['reference_name'] as String?
  ..assignedBy = json['assigned_by'] as String?
  ..assignedByFullName = json['assigned_by_full_name'] as String?;

Map<String, dynamic> _$ToDoToJson(ToDo instance) {
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
  writeNotNull('status', _$StatusEnumMap[instance.status]);
  writeNotNull('priority', _$PriorityEnumMap[instance.priority]);
  writeNotNull('date', instance.date?.toIso8601String());
  writeNotNull('description', instance.description);
  writeNotNull('reference_type', instance.referenceType);
  writeNotNull('reference_name', instance.referenceName);
  writeNotNull('assigned_by', instance.assignedBy);
  writeNotNull('assigned_by_full_name', instance.assignedByFullName);
  return val;
}

FrappeReport _$FrappeReportFromJson(Map<String, dynamic> json) => FrappeReport()
  ..result = (json['result'] as List<dynamic>?)
      ?.map((e) => e as List<dynamic>)
      .toList()
  ..columns = (json['columns'] as List<dynamic>?)
      ?.map((e) => FrappeReportColumn.fromJson(e as Map<String, dynamic>?))
      .toList();

Map<String, dynamic> _$FrappeReportToJson(FrappeReport instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('result', instance.result);
  writeNotNull('columns', instance.columns?.map((e) => e.toJson()).toList());
  return val;
}

FrappeReportColumn _$FrappeReportColumnFromJson(Map<String, dynamic> json) =>
    FrappeReportColumn()
      ..label = json['label'] as String?
      ..type = json['type'] as String?
      ..width = json['width'] as String?
      ..options = json['options'];

Map<String, dynamic> _$FrappeReportColumnToJson(FrappeReportColumn instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('label', instance.label);
  writeNotNull('type', instance.type);
  writeNotNull('width', instance.width);
  writeNotNull('options', instance.options);
  return val;
}

FrappeLog _$FrappeLogFromJson(Map<String, dynamic> json) => FrappeLog()
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
  ..title = json['title'] as String?
  ..content = json['content'] as String?
  ..type = json['type'] as String?
  ..request = json['request'] as String?
  ..response = json['response'] as String?
  ..tags = (json['tags'] as List<dynamic>?)
      ?.map((e) => FrappeLogTag.fromJson(e as Map<String, dynamic>?))
      .toList()
  ..tagsList =
      (json['tags_list'] as List<dynamic>?)?.map((e) => e as String).toList();

Map<String, dynamic> _$FrappeLogToJson(FrappeLog instance) {
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
  writeNotNull('content', instance.content);
  writeNotNull('type', instance.type);
  writeNotNull('request', instance.request);
  writeNotNull('response', instance.response);
  writeNotNull('tags', instance.tags?.map((e) => e.toJson()).toList());
  writeNotNull('tags_list', instance.tagsList);
  return val;
}

FrappeLogTag _$FrappeLogTagFromJson(Map<String, dynamic> json) => FrappeLogTag()
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
  ..tag = json['tag'] as String?;

Map<String, dynamic> _$FrappeLogTagToJson(FrappeLogTag instance) {
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
  writeNotNull('tag', instance.tag);
  return val;
}

TagLink _$TagLinkFromJson(Map<String, dynamic> json) => TagLink()
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
  ..documentType = json['document_type'] as String?
  ..documentName = json['document_name'] as String?
  ..tag = json['tag'] as String?
  ..title = json['title'] as String?;

Map<String, dynamic> _$TagLinkToJson(TagLink instance) {
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
  writeNotNull('document_type', instance.documentType);
  writeNotNull('document_name', instance.documentName);
  writeNotNull('tag', instance.tag);
  writeNotNull('title', instance.title);
  return val;
}
