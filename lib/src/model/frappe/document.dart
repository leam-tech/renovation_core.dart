import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../../core/errors.dart';
import '../document.dart';
import 'utils.dart';

abstract class FrappeDocument extends RenovationDocument {
  FrappeDocument(this.doctype);

  factory FrappeDocument.fromJson(Map<String, dynamic> json) =>
      throw JSONAbleMethodsNotImplemented();

  @nonVirtual
  String? doctype;

  @nonVirtual
  String? name;

  @nonVirtual
  String? owner;

  @nonVirtual
  @JsonKey(
      name: 'docstatus',
      fromJson: FrappeDocFieldConverter.intToFrappeDocStatus,
      toJson: FrappeDocFieldConverter.frappeDocStatusToInt)
  FrappeDocStatus? docStatus = FrappeDocStatus.Draft;

  @nonVirtual
  @JsonKey(
      name: '__islocal',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? isLocal;

  @nonVirtual
  @JsonKey(
      name: '__unsaved',
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? unsaved;

  @nonVirtual
  @JsonKey(name: 'amended_from')
  String? amendedFrom;

  @nonVirtual
  @JsonKey(fromJson: FrappeDocFieldConverter.idxFromString)
  int? idx;

  @nonVirtual
  String? parent;

  @nonVirtual
  @JsonKey(name: 'parenttype')
  String? parentType;

  @nonVirtual
  @JsonKey(toJson: FrappeDocFieldConverter.toFrappeDateTime)
  DateTime? creation;

  @nonVirtual
  @JsonKey(name: 'parentfield')
  String? parentField;

  @nonVirtual
  @JsonKey(toJson: FrappeDocFieldConverter.toFrappeDateTime)
  DateTime? modified;

  @nonVirtual
  @JsonKey(name: 'modified_by')
  String? modifiedBy;

  static T nullifyFields<T extends FrappeDocument>(T doc) => doc
    ..name = null
    ..doctype = null
    ..idx = null
    ..creation = null
    ..modified = null
    ..docStatus = null;

  static List<T> nullifyList<T extends FrappeDocument>(List<T> docs) =>
      List<T>.of(docs.map((T doc) => doc
        ..name = null
        ..doctype = null
        ..idx = null
        ..creation = null
        ..modified = null
        ..docStatus = null));

  @override
  List<T>? deserializeList<T>(List? docs) => docs != null
      ? List<T>.from(super
          .deserializeList<T>(docs)!
          .map<T>((T obj) => ((obj as FrappeDocument)..doctype = doctype) as T))
      : null;
}
