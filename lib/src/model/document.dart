import 'package:json_annotation/json_annotation.dart';

import '../core/errors.dart';
import '../core/jsonable.dart';

/// Base class for all models
abstract class RenovationDocument extends JSONAble {
  RenovationDocument();

  factory RenovationDocument.fromJson(Map<String, dynamic> json) =>
      throw JSONAbleMethodsNotImplemented();

  @JsonKey(ignore: true)
  Map<String, dynamic>? rawResponse;
}
