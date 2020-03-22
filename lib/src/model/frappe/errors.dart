import 'document.dart';
import 'utils.dart';

/// An error to be thrown when the supplied argument to a method is not a [FrappeDocument]
class NotFrappeDocument extends Error {
  @override
  String toString() => 'Class does not extend FrappeDocument class';
}

/// An error to be thrown when a submitted doc operation is applied on a non-submitted document
///
/// i.e `docstatus` != [FrappeDocStatus.Submitted]
class NotASubmittedDocument extends Error {
  @override
  String toString() => 'The document is not marked as submitted';
}

class InvalidFrappeFilter extends Error {
  @override
  String toString() => "The supplied filter doesn't comply with DBFilter";
}

class InvalidFrappeFieldValue extends Error {
  @override
  String toString() => 'The supplied value does not comply with DBValue';
}

class EmptyDoctypeError extends Error {
  @override
  String toString() => 'The doctype should not be null or empty';

  static void verify(String doctype) {
    if (doctype == null || doctype.isEmpty) throw EmptyDoctypeError();
  }
}

class EmptyDocNameError extends Error {
  @override
  String toString() => 'The docname should not be null or empty';

  static void verify(String docName) {
    if (docName == null || docName.isEmpty) throw EmptyDocNameError();
  }
}

class EmptyDocFieldError extends Error {
  @override
  String toString() => 'The docfield should not be null or empty';

  static void verify(String docField) {
    if (docField == null || docField.isEmpty) throw EmptyDocFieldError();
  }
}

class NotSubmittableDocError extends Error {
  @override
  String toString() => 'This doctype is not submittable. Cannot submit';
}
