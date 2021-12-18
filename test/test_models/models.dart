import 'package:json_annotation/json_annotation.dart';
import 'package:renovation_core/meta.dart';
import 'package:renovation_core/model.dart';

part 'models.g.dart';

@JsonSerializable()
class RenovationUserAgreement extends FrappeDocument {
  RenovationUserAgreement() : super('Renovation User Agreement');

  factory RenovationUserAgreement.fromJson(Map<String, dynamic>? json) =>
      _$RenovationUserAgreementFromJson(json!);

  String? title;

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      RenovationUserAgreement.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$RenovationUserAgreementToJson(this);
}

@JsonSerializable()
class RenovationReview extends FrappeDocument {
  RenovationReview() : super('Renovation Review');

  factory RenovationReview.fromJson(Map<String, dynamic>? json) =>
      _$RenovationReviewFromJson(json!);

  @JsonKey(name: 'reviewed_by_doctype')
  String? reviewedByDoctype;
  @JsonKey(name: 'reviewed_by')
  String? reviewedBy;

  @JsonKey(name: 'reviewed_by_doctype_doc')
  DocType? reviewedByDoctypeDoc;

  @JsonKey(name: 'reviewed_doctype')
  String? reviewedDoctype;
  @JsonKey(name: 'reviewed_entity')
  String? reviewedEntity;

  List<RenovationReviewItem>? reviews;

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      RenovationReview.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$RenovationReviewToJson(this);
}

@JsonSerializable()
class RenovationReviewItem extends FrappeDocument {
  RenovationReviewItem() : super('Renovation Review Item');

  factory RenovationReviewItem.fromJson(Map<String, dynamic>? json) =>
      _$RenovationReviewItemFromJson(json!);

  String? title;
  String? question;
  String? quantitative;
  String? answer;

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      RenovationReviewItem.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$RenovationReviewItemToJson(this);
}

@JsonSerializable()
class NonExistingDocType extends FrappeDocument {
  NonExistingDocType() : super('NON-EXISTING DOCTYPE');

  factory NonExistingDocType.fromJson(Map<String, dynamic>? json) =>
      _$NonExistingDocTypeFromJson(json!);

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      NonExistingDocType.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$NonExistingDocTypeToJson(this);
}
