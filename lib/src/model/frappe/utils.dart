import 'package:json_annotation/json_annotation.dart';

import '../../backend/frappe/errors.dart';
import '../../backend/frappe/extensions.dart';
import '../../core/jsonable.dart';
import 'document.dart';

/// Use this mixin when [cmd] needs to be included in the JSON object of Frappe's API
mixin FrappeAPI on JSONAble {
  String? cmd;
}

/// A helper class containing method to be used with [JsonKey]
///
/// For instance `unsaved` under [FrappeDocument] where it comes from the backend as 0, 1 representing false & true, respectively.
///
/// The method [FrappeDocFieldConverter.checkToBool] can be used
///
/// The reverse method can be used as well when converting back to JSON, for instance, [FrappeDocFieldConverter.boolToCheck]
class FrappeDocFieldConverter {
  static int? idxFromString(dynamic idx) =>
      idx is String ? int.parse(idx) : idx as int?;

  /// Converts to the boolean representation of the "Check" docfield in Frappé
  /// `false` is represented as `0` in Frappé while `true` is represented as `1`
  static bool checkToBool(int? value) {
    if (value == null) {
      return false;
    }
    if (value != 0 && value != 1) {
      throw NotCheckError();
    }
    return value == 1;
  }

  /// Converts the value of a check (bool) to Frappé representation (0 or 1)
  static int? boolToCheck(bool? boolValue) {
    if (boolValue == null) {
      return null;
    }
    return boolValue ? 1 : 0;
  }

  /// Converts the docStatus of a document from `0, 1 or 2` to [FrappeDocStatus]
  static FrappeDocStatus? intToFrappeDocStatus(int? docStatus) {
    if (docStatus == null) {
      return null;
    }
    if (!<int>[0, 1, 2].contains(docStatus)) {
      throw NotDocStatusIntegerError();
    }
    return FrappeDocStatus.values[docStatus];
  }

  /// Converts the docStatus of a document [FrappeDocStatus] to its representation in Frappé `0, 1 or 2`
  static int? frappeDocStatusToInt(FrappeDocStatus? docStatus) {
    if (docStatus == null) {
      return null;
    }
    return docStatus.index;
  }

  static String? toFrappeDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }
    return dateTime.toFrappeDateTimeString();
  }
}

/// A representation of the document status in Frappé `docStatus` in [FrappeDocument].
enum FrappeDocStatus {
  /// Frappé's equivalent is `0`
  Draft,

  /// Frappé's equivalent is `1`
  Submitted,

  /// Frappé's equivalent is `2`
  Cancelled
}
