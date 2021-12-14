library model;

import 'dart:core';

import 'package:meta/meta.dart';

import '../core/config.dart';
import '../core/renovation.controller.dart';
import '../core/request.dart';
import 'document.dart';
import 'interfaces.dart';

/// An abstract controller containing methods and properties related to document CRUD operations.
abstract class ModelController<K extends RenovationDocument>
    extends RenovationController {
  ModelController(RenovationConfig config) : super(config);

  /// Holds the new name prefix number per doctype
  static final newNameCount = <String, int>{};

  /// Cache object for the docs
  final locals = <String, Map<String, dynamic>>{};

  /// Clears the `locals` and `newNameCount` and reset to `{}`
  @override
  void clearCache() {
    locals.clear();
    ModelController.newNameCount.clear();
  }

  /// Returns a new instance of [T] document with a new name based on [getNewName].
  T newDoc<T extends K>(T doc);

  /// Returns a new name for a doctype. For instance, `New Renovation Review 1`.
  @protected
  String getNewName(String doctype);

  /// Returns a cloned doc, with a new local name.
  T copyDoc<T extends K>(T doc);

  /// Clones a doc, set amended_from property to the original doc.
  T amendDoc<T extends K>(T doc);

  /// Returns a child doc instance, already attached to parent doc
  Future<T> addChildDoc<T extends K>(T doc, dynamic field);

  // TODO: Find a generic way to do it
//    final Function getDf = () async {
//      final RequestResponse<DocType> dtResponse =
//          await config.coreInstance.meta.getDocMeta(doc.doctype);
//      if (dtResponse.isSuccess == false) {
//        throw Error.safeToString('Failed fetching doctype meta');
//      }
//      if (field is DocField) {
//        final String fieldname = field.fieldname;
//        return dtResponse.data.fields.firstWhere(
//            (DocField f) => f.fieldname == field.fieldname,
//            orElse: throw Error.safeToString(
//                '$fieldname is not a child field of DocType ${dtResponse.data.doctype}'));
//      }
//      return dtResponse.data.fields
//          .firstWhere((DocField f) => f.fieldname == field.fieldname);
//    };
//
//    DocField df;
//    try {
//      df = await getDf();
//    } catch (e) {
//      print(e);
//    }
//    if (df == null) {
//      throw Error.safeToString('Failed to get datafield');
//    }
//    if (df.fieldtype != 'Table') {
//      throw Error.safeToString('${df.fieldname} is not a table field');
//    }
//    final RenovationDocument childDoc = await newDoc(df.options);
//    final Map<String, dynamic> temp = doc.toJson();
//    if (!temp.containsKey(df.fieldname)) {
//      temp[df.fieldname] = <dynamic>[];
//    }
//    childDoc.idx = temp[df.fieldname].length + 1;
//    temp[df.fieldname].add(childDoc);
//    doc = doc.fromJson(temp);
//
//    childDoc.parent = doc.name;
//    childDoc.parenttype = doc.doctype;
//
//    return childDoc;

  /// Deletes the document from the backend, returning its name.
  Future<RequestResponse<String?>> deleteDoc(String doctype, String docname);

  /// Returns the document specified by its [docname].
  Future<RequestResponse<T?>> getDoc<T extends K>(T obj, String docname,
      {bool? forceFetch});

  /// Returns list of documents [T] of a doctype specified by [obj].
  Future<RequestResponse<List<T?>?>> getList<T extends K>(T obj,
      {List<String>? fields,
      dynamic filters,
      String? orderBy,
      int? limitPageStart,
      int? limitPageLength,
      String? parent,
      Map<String, List<String>>? tableFields,
      List<String>? withLinkFields});

  /// Returns a [Map] of [docfield] and its value from the backend.
  Future<RequestResponse<Map<String, dynamic>?>> getValue(
      String doctype, String docname, String docfield);

  /// Assigns a doc or a list of docs to a particular user.
  Future<RequestResponse<bool?>> assignDoc(
      {required String assignTo,
      required String doctype,
      bool? myself,
      DateTime? dueDate,
      String? description,
      String? docName,
      List<String>? docNames,
      bool notify = false,
      Priority? priority,
      bool bulkAssign = false});

  /// Sets the assignment to [Status.Cancelled] which means that the task is assigned.
  Future<RequestResponse<dynamic>> completeDocAssignment(
      {required String doctype,
      required String docName,
      required String assignedTo});

  /// Un-assigns a user from the [doctype] and [docName].
  Future<RequestResponse<bool?>> unAssignDoc(
      {required String doctype,
      required String docName,
      required String unAssignFrom});

  /// Returns the list of documents assigned to a user.
  ///
  /// Optionally can filter the list by specifying [doctype] and [status].
  Future<RequestResponse<List<dynamic>?>> getDocsAssignedToUser(
      {required String assignedTo, String? doctype, Status? status});

  /// Returns the users assigned to a document of a certain doctype.
  Future<RequestResponse<List<dynamic>?>> getUsersAssignedToDoc(
      {required String doctype, required String docName});

  /// Returns the modified document [T] after setting the [docField] with [docValue].
  Future<RequestResponse<T?>> setValue<T extends K>(
      T obj, String? docName, String docField, dynamic docValue);

  /// Returns the saved document [T] after saving in the backend.
  Future<RequestResponse<T?>> saveDoc<T extends K>(T doc);

  /// Submit a submittable document.
  Future<RequestResponse<T?>> submitDoc<T extends K>(T doc);

  /// Saves the document first, then submit, in a single db transaction.
  Future<RequestResponse<T?>> saveSubmitDoc<T extends K>(T doc);

  /// Returns the cancelled document [T] of a submitted document.
  Future<RequestResponse<T?>> cancelDoc<T extends K>(T doc);

  /// Returns a list of results after searching against fields.
  Future<RequestResponse<List<dynamic>?>> searchLink(
      {required String doctype,
      required String txt,
      Map<String, dynamic>? options});

  /// Adds the documents to a static local variable [locals].
  @protected
  void addToLocals<T extends K>(T doc);

  /// Adds a tag to document [docName] of a [doctype].
  Future<RequestResponse<String?>> addTag(
      {required String doctype, required String docName, required String tag});

  /// Adds a tag to document [docName] of a [doctype].
  Future<RequestResponse<String?>> removeTag(
      {required String doctype, required String docName, required String tag});

  /// Gets all the names of all documents with the param-tag.
  Future<RequestResponse<List<String>?>> getTaggedDocs(
      {required String doctype, String? tag});

  /// Returns all tags of a doctype.
  Future<RequestResponse<List<String?>?>> getTags(
      {required String doctype, String? likeTag});

  /// Get report values.
  Future<RequestResponse<dynamic>> getReport(
      {required String report, dynamic filters, String? user});

  /// Returns the document from the local map.
  ///
  /// If the doctype or docname don't exist, `null` is returned.
  T? getDocFromCache<T extends K>(String? doctype, String docname) {
    if (locals.containsKey(doctype)) {
      if (locals[doctype]!.containsKey(docname)) {
        return locals[doctype]![docname];
      }
    }
    return null;
  }
}
