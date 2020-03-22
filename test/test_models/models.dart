import 'package:json_annotation/json_annotation.dart';
import 'package:renovation_core/model.dart';

part 'models.g.dart';

@JsonSerializable()
class RenovationUserAgreement extends FrappeDocument {
  RenovationUserAgreement() : super('Renovation User Agreement');

  factory RenovationUserAgreement.fromJson(Map<String, dynamic> json) =>
      _$RenovationUserAgreementFromJson(json);

  String title;

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      RenovationUserAgreement.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$RenovationUserAgreementToJson(this);
}

@JsonSerializable()
class ItemGroup extends FrappeDocument {
  ItemGroup() : super('Item Group');

  @JsonKey(name: 'parent_item_group_doc')
  ParentItemGroup parentItemGroupDoc;

  factory ItemGroup.fromJson(Map<String, dynamic> json) =>
      _$ItemGroupFromJson(json);

  @override
  T fromJson<T>(Map<String, dynamic> json) => ItemGroup.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$ItemGroupToJson(this);
}

@JsonSerializable()
class ParentItemGroup extends FrappeDocument {
  ParentItemGroup() : super('Parent Item Group');

  factory ParentItemGroup.fromJson(Map<String, dynamic> json) =>
      _$ParentItemGroupFromJson(json);

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      ParentItemGroup.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$ParentItemGroupToJson(this);
}

@JsonSerializable()
class ItemAttribute extends FrappeDocument {
  ItemAttribute() : super('Item Attribute');

  @JsonKey(name: 'item_attribute_values')
  List<ItemAttributeValue> itemAttributeValues;

  @JsonKey(name: 'attribute_name')
  String attributeName;

  factory ItemAttribute.fromJson(Map<String, dynamic> json) =>
      _$ItemAttributeFromJson(json);

  @override
  T fromJson<T>(Map<String, dynamic> json) => ItemAttribute.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$ItemAttributeToJson(this);
}

@JsonSerializable()
class ItemAttributeValue extends FrappeDocument {
  ItemAttributeValue() : super('Item Attribute Value');

  @JsonKey(name: 'attribute_value')
  String attributeValue;

  String abbr;

  factory ItemAttributeValue.fromJson(Map<String, dynamic> json) =>
      _$ItemAttributeValueFromJson(json);

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      ItemAttributeValue.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$ItemAttributeValueToJson(this);
}

@JsonSerializable()
class NonExistingDocType extends FrappeDocument {
  NonExistingDocType() : super('NON-EXISTING DOCTYPE');

  factory NonExistingDocType.fromJson(Map<String, dynamic> json) =>
      _$NonExistingDocTypeFromJson(json);

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      NonExistingDocType.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$NonExistingDocTypeToJson(this);
}
