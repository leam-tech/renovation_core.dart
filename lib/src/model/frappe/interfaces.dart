import 'package:json_annotation/json_annotation.dart';

import '../../core/jsonable.dart';
import '../interfaces.dart';
import 'document.dart';
import 'utils.dart';

part 'interfaces.g.dart';

@JsonSerializable()
class GetListParams extends JSONAble with FrappeAPI {
  GetListParams(this.doctype,
      {this.fields,
      this.orderBy,
      this.limitPageLength,
      this.limitPageStart,
      this.filters,
      this.parent,
      this.tableFieldsFrappe,
      this.withLinkFieldsFrappe});

  factory GetListParams.fromJson(Map<String, dynamic> json) =>
      _$GetListParamsFromJson(json);

  String? doctype;
  String? fields;

  @JsonKey(name: 'order_by')
  String? orderBy;

  @JsonKey(name: 'limit_start')
  int? limitPageStart;

  @JsonKey(name: 'limit_page_length')
  int? limitPageLength;

  dynamic filters;
  String? parent;

  @JsonKey(name: 'table_fields')
  String? tableFieldsFrappe;

  @JsonKey(name: 'with_link_fields')
  String? withLinkFieldsFrappe;

  @override
  Map<String, dynamic> toJson() => _$GetListParamsToJson(this);

  @override
  T fromJson<T>(Map<String, dynamic> json) => GetListParams.fromJson(json) as T;
}

@JsonSerializable()
class GetValueParams extends JSONAble with FrappeAPI {
  GetValueParams(this.doctype, this.docname, this.docfield);

  factory GetValueParams.fromJson(Map<String, dynamic> json) =>
      _$GetValueParamsFromJson(json);

  String? doctype;
  @JsonKey(name: 'filters')
  String? docname;
  @JsonKey(name: 'fieldname')
  String? docfield;

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      GetValueParams.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$GetValueParamsToJson(this);
}

@JsonSerializable()
class SetValueParams extends JSONAble with FrappeAPI {
  SetValueParams(this.doctype, this.docname, this.docfield, this.value);

  factory SetValueParams.fromJson(Map<String, dynamic> json) =>
      _$SetValueParamsFromJson(json);

  String? doctype;
  @JsonKey(name: 'name')
  String? docname;
  @JsonKey(name: 'fieldname')
  String? docfield;
  dynamic value;

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      SetValueParams.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$SetValueParamsToJson(this);
}

@JsonSerializable()
class SearchLinkResponse extends JSONAble {
  SearchLinkResponse();

  factory SearchLinkResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchLinkResponseFromJson(json);
  String? description;
  String? value;

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      SearchLinkResponse.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$SearchLinkResponseToJson(this);
}

@JsonSerializable()
class AssignDocParams extends JSONAble with FrappeAPI {
  AssignDocParams(
      {this.assignTo,
      this.myself,
      this.description,
      this.dueDate,
      this.doctype,
      this.docName,
      this.docNames,
      this.notify,
      this.priority,
      this.bulkAssign = false});

  factory AssignDocParams.fromJson(Map<String, dynamic> json) =>
      _$AssignDocParamsFromJson(json);

  String? name;
  @JsonKey(name: 'assign_to')
  String? assignTo;
  @JsonKey(toJson: FrappeDocFieldConverter.boolToCheck)
  bool? myself;
  String? description;
  @JsonKey(name: 'date', toJson: FrappeDocFieldConverter.toFrappeDateTime)
  DateTime? dueDate;
  String? doctype;
  @JsonKey(name: 'docname', ignore: true)
  String? docName;
  @JsonKey(name: 'docnames', ignore: true)
  List<String>? docNames;
  @JsonKey(toJson: FrappeDocFieldConverter.boolToCheck)
  bool? notify;
  @JsonKey()
  Priority? priority;

  /// Use List<String>docnames instead while using bulkAssign
  @JsonKey(name: 'bulk_assign', toJson: FrappeDocFieldConverter.boolToCheck)
  bool? bulkAssign;

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      AssignDocParams.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$AssignDocParamsToJson(this);
}

@JsonSerializable()
class GetDocsAssignedToUserParams extends JSONAble with FrappeAPI {
  GetDocsAssignedToUserParams(
      {required this.assignedTo, this.doctype, this.status});

  factory GetDocsAssignedToUserParams.fromJson(Map<String, dynamic> json) =>
      _$GetDocsAssignedToUserParamsFromJson(json);

  @JsonKey(name: 'user')
  String? assignedTo;
  String? doctype;
  Status? status;

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      GetDocsAssignedToUserParams.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$GetDocsAssignedToUserParamsToJson(this);
}

@JsonSerializable()
class GetDocsAssignedToUserResponse extends JSONAble {
  GetDocsAssignedToUserResponse(
      {this.dueDate,
      this.status,
      this.assignedBy,
      this.assignedByFullName,
      this.assignedTo,
      this.assignedToFullName,
      this.priority,
      this.description,
      this.doctype,
      this.docname});

  factory GetDocsAssignedToUserResponse.fromJson(Map<String, dynamic> json) =>
      _$GetDocsAssignedToUserResponseFromJson(json);

  /// Time to finish task (yyyy-mm-dd)
  DateTime? dueDate;
  Status? status;

  /// DocName of the User who assigned this doc originally
  String? assignedBy;

  /// Full name of the assigned by user
  String? assignedByFullName;

  /// The assigned to User
  String? assignedTo;
  String? assignedToFullName;
  Priority? priority;
  String? description;
  String? doctype;
  String? docname;

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      GetDocsAssignedToUserResponse.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$GetDocsAssignedToUserResponseToJson(this);
}

class GetUsersAssignedToDocParams {
  GetUsersAssignedToDocParams(this.doctype, this.docname);

  String doctype;
  String docname;
}

@JsonSerializable()
class CompleteDocAssignmentParams extends JSONAble with FrappeAPI {
  CompleteDocAssignmentParams(
      {required this.doctype, required this.name, required this.assignedTo});

  factory CompleteDocAssignmentParams.fromJson(Map<String, dynamic> json) =>
      _$CompleteDocAssignmentParamsFromJson(json);

  String? doctype;
  String? name;
  @JsonKey(name: 'assign_to')
  String? assignedTo;

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      CompleteDocAssignmentParams.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$CompleteDocAssignmentParamsToJson(this);
}

@JsonSerializable()
class ToDo extends FrappeDocument {
  ToDo() : super('ToDo');

  factory ToDo.fromJson(Map<String, dynamic> json) => _$ToDoFromJson(json);

  Status? status;
  Priority? priority;

  DateTime? date;
  String? description;

  @JsonKey(name: 'reference_type')
  String? referenceType;
  @JsonKey(name: 'reference_name')
  String? referenceName;

  @JsonKey(name: 'assigned_by')
  String? assignedBy;

  @JsonKey(name: 'assigned_by_full_name')
  String? assignedByFullName;

  @override
  T fromJson<T>(Map<String, dynamic> json) => ToDo.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$ToDoToJson(this);
}

@JsonSerializable()
class FrappeReport extends JSONAble {
  FrappeReport();

  factory FrappeReport.fromJson(Map<String, dynamic> json) =>
      _$FrappeReportFromJson(json);

  List<List<dynamic>>? result;

  List<FrappeReportColumn>? columns;

  @override
  T fromJson<T>(Map<String, dynamic> json) => FrappeReport.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$FrappeReportToJson(this);
}

@JsonSerializable()
class FrappeReportColumn extends JSONAble {
  FrappeReportColumn();

  factory FrappeReportColumn.fromJson(Map<String, dynamic> json) =>
      _$FrappeReportColumnFromJson(json);

  String? label;
  String? type;
  String? width;
  dynamic options;

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      FrappeReportColumn.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$FrappeReportColumnToJson(this);
}

@JsonSerializable()
class FrappeLog extends FrappeDocument {
  FrappeLog() : super('Renovation Log');

  factory FrappeLog.fromJson(Map<String, dynamic> json) =>
      _$FrappeLogFromJson(json);

  String? title;

  String? content;

  String? type;

  String? request;

  String? response;

  List<FrappeLogTag>? tags;

  @JsonKey(name: 'tags_list')
  List<String>? tagsList;

  @override
  T fromJson<T>(Map<String, dynamic> json) => FrappeLog.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$FrappeLogToJson(this);
}

@JsonSerializable()
class FrappeLogTag extends FrappeDocument {
  FrappeLogTag() : super('Renovation Log Tag Selector');

  factory FrappeLogTag.fromJson(Map<String, dynamic> json) =>
      _$FrappeLogTagFromJson(json);

  String? tag;

  @override
  T fromJson<T>(Map<String, dynamic> json) => FrappeLogTag.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$FrappeLogTagToJson(this);
}

@JsonSerializable()
class TagLink extends FrappeDocument {
  TagLink() : super('Tag Link');

  factory TagLink.fromJson(Map<String, dynamic> json) =>
      _$TagLinkFromJson(json);

  @JsonKey(name: 'document_type')
  String? documentType;

  @JsonKey(name: 'document_name')
  String? documentName;

  String? tag;

  String? title;

  @override
  T fromJson<T>(Map<String, dynamic> json) => TagLink.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$TagLinkToJson(this);
}
