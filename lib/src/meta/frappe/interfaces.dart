import 'package:json_annotation/json_annotation.dart';

import '../../core/jsonable.dart';
import '../../model/frappe/document.dart';
import '../../model/frappe/interfaces.dart';
import '../../model/frappe/utils.dart';
import '../../perm/frappe/interfaces.dart';
import '../../storage/frappe/interfaces.dart';

part 'interfaces.g.dart';

@JsonSerializable()
class FrappeDocInfo extends JSONAble {
  FrappeDocInfo();

  factory FrappeDocInfo.fromJson(Map<String, dynamic>? json) =>
      _$FrappeDocInfoFromJson(json!);

  List<FrappeFile>? attachments;

  List<FrappeCommunication>? communications;
  List<FrappeComment>? comments;

  @JsonKey(name: 'total_comments')
  int? totalComments;

  List<FrappeVersion>? versions;

  List<ToDo>? assignments;
  DocPerm? permissions;
  List<FrappeSharedSetting>? shared;

  List<FrappeViewLog>? views;

  List<Map<String, dynamic>>? milestones;

  @JsonKey(name: 'energy_point_logs')
  List<Map<String, dynamic>>? energyPointLogs;

  @JsonKey(
      name: 'is_document_followed',
      toJson: FrappeDocFieldConverter.boolToCheck,
      fromJson: FrappeDocFieldConverter.checkToBool)
  bool? isDocumentFollowed;
  String? tags;

  @override
  T fromJson<T>(Map<String, dynamic>? json) => FrappeDocInfo.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$FrappeDocInfoToJson(this);
}

@JsonSerializable()
class FrappeCommunication extends FrappeDocument {
  FrappeCommunication() : super('Communication');

  factory FrappeCommunication.fromJson(Map<String, dynamic>? json) =>
      _$FrappeCommunicationFromJson(json!);

  @JsonKey(name: 'communication_type')
  String? communicationType;

  @JsonKey(name: 'communication_medium')
  String? communicationMedium;

  @JsonKey(name: 'comment_tyoe')
  String? commentType;

  @JsonKey(
      name: 'communication_date',
      toJson: FrappeDocFieldConverter.toFrappeDateTime)
  DateTime? communicationDate;

  String? content;

  String? sender;

  @JsonKey(name: 'sender_full_name')
  String? senderFullName;

  String? cc;
  String? bcc;
  String? subject;

  @JsonKey(name: 'delivery_status')
  String? deliveryStatus;

  @JsonKey(name: 'reference_doctype')
  String? referenceDoctype;

  @JsonKey(name: 'reference_name')
  String? referenceName;

  @JsonKey(
      name: 'read_by_recipient',
      toJson: FrappeDocFieldConverter.boolToCheck,
      fromJson: FrappeDocFieldConverter.checkToBool)
  bool? readByRecipient;

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      FrappeCommunication.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$FrappeCommunicationToJson(this);
}

@JsonSerializable()
class FrappeComment extends FrappeDocument {
  FrappeComment() : super('Comment');

  factory FrappeComment.fromJson(Map<String, dynamic>? json) =>
      _$FrappeCommentFromJson(json!);

  @JsonKey(name: 'comment_email')
  String? commentEmail;

  @JsonKey(name: 'comment_type')
  String? commentType;

  String? subject;

  @JsonKey(name: 'comment_by')
  String? commentBy;

  @JsonKey(
      toJson: FrappeDocFieldConverter.boolToCheck,
      fromJson: FrappeDocFieldConverter.checkToBool)
  bool? published;

  @JsonKey(
      toJson: FrappeDocFieldConverter.boolToCheck,
      fromJson: FrappeDocFieldConverter.checkToBool)
  bool? seen;

  String? content;

  @JsonKey(name: 'reference_owner')
  String? referenceOwner;

  @JsonKey(name: 'reference_doctype')
  String? referenceDoctype;

  @JsonKey(name: 'reference_name')
  String? referenceName;

  @JsonKey(name: 'link_doctype')
  String? linkDoctype;

  @JsonKey(name: 'link_name')
  String? linkName;

  @override
  T fromJson<T>(Map<String, dynamic>? json) => FrappeComment.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$FrappeCommentToJson(this);
}

@JsonSerializable()
class FrappeVersion extends FrappeDocument {
  FrappeVersion() : super('Version');

  factory FrappeVersion.fromJson(Map<String, dynamic>? json) =>
      _$FrappeVersionFromJson(json!);

  String? data;
  String? ref_doctype;
  String? docname;

  @override
  T fromJson<T>(Map<String, dynamic>? json) => FrappeVersion.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$FrappeVersionToJson(this);
}

@JsonSerializable()
class FrappeSharedSetting extends JSONAble {
  FrappeSharedSetting();

  factory FrappeSharedSetting.fromJson(Map<String, dynamic>? json) =>
      _$FrappeSharedSettingFromJson(json!);

  String? user;

  @JsonKey(
      toJson: FrappeDocFieldConverter.boolToCheck,
      fromJson: FrappeDocFieldConverter.checkToBool)
  bool? read;
  @JsonKey(
      toJson: FrappeDocFieldConverter.boolToCheck,
      fromJson: FrappeDocFieldConverter.checkToBool)
  bool? write;
  @JsonKey(
      toJson: FrappeDocFieldConverter.boolToCheck,
      fromJson: FrappeDocFieldConverter.checkToBool)
  bool? share;
  @JsonKey(
      toJson: FrappeDocFieldConverter.boolToCheck,
      fromJson: FrappeDocFieldConverter.checkToBool)
  bool? everyone;

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      FrappeSharedSetting.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$FrappeSharedSettingToJson(this);
}

@JsonSerializable()
class FrappeViewLog extends FrappeDocument {
  FrappeViewLog() : super('View Log');

  factory FrappeViewLog.fromJson(Map<String, dynamic>? json) =>
      _$FrappeViewLogFromJson(json!);

  String? viewedBy;
  @JsonKey(name: 'reference_doctype')
  String? referenceDoctype;
  @JsonKey(name: 'reference_name')
  String? referenceName;

  @override
  T fromJson<T>(Map<String, dynamic>? json) => FrappeViewLog.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$FrappeViewLogToJson(this);
}

@JsonSerializable()
class RenovationReport extends FrappeDocument {
  RenovationReport() : super('Renovation Report');

  factory RenovationReport.fromJson(Map<String, dynamic>? json) =>
      _$RenovationReportFromJson(json!);

  String? report;
  List<RenovationReportFilter>? filters;

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      RenovationReport.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$RenovationReportToJson(this);
}

@JsonSerializable()
class RenovationReportFilter extends FrappeDocument {
  RenovationReportFilter() : super('Renovation Report Filter');

  factory RenovationReportFilter.fromJson(Map<String, dynamic>? json) =>
      _$RenovationReportFilterFromJson(json!);

  @JsonKey(name: 'default_value')
  String? defaultValue;
  @JsonKey(name: 'fieldname')
  String? fieldName;
  @JsonKey(name: 'fieldtype')
  String? fieldType;

  String? options;
  String? label;

  @JsonKey(
      name: 'reqd',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? required;

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      RenovationReportFilter.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$RenovationReportFilterToJson(this);
}
