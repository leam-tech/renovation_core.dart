import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';

import '../../core/config.dart';
import '../../core/errors.dart';
import '../../core/frappe/renovation.dart';
import '../../core/jsonable.dart';
import '../../core/renovation.controller.dart';
import '../../core/request.dart';
import '../interfaces.dart';
import '../model.controller.dart';
import 'document.dart';
import 'errors.dart';
import 'filters.dart';
import 'interfaces.dart';
import 'utils.dart';

/// A controller containing methods and properties related to document CRUD operations of Frappé
class FrappeModelController extends ModelController<FrappeDocument> {
  FrappeModelController(RenovationConfig config) : super(config);

  static const String DOCTYPE_NOT_EXIST_TITLE = "DocType doesn't exist";
  static const String DOCNAME_NOT_EXIST_TITLE = "Docname doesn't exist";
  static const String DOCTYPE_OR_DOCNAME_NOT_EXIST_TITLE =
      "DocType or Docname doesn't exist";
  static const String DOCFIELD_NOT_EXIST_TITLE = 'DocField is not valid';

  /// Returns a new instance of [T] document with a new name based on [getNewName].
  ///
  /// It also adds the new doc to the local cache using [addToLocals].
  @override
  T newDoc<T extends FrappeDocument>(T doc) {
    doc.name = getNewName(doc.doctype);
    doc.isLocal = true;
    doc.unsaved = true;
    addToLocals(doc);
    return doc;
  }

  /// Returns a new name for a doctype.
  ///
  /// Depends on the document count saved in [newNameCount].
  @override
  @protected
  String getNewName(String doctype) {
    EmptyDoctypeError.verify(doctype);

    if (ModelController.newNameCount[doctype] == null) {
      ModelController.newNameCount[doctype] = 0;
    }
    ModelController.newNameCount[doctype]++;
    return 'New $doctype ${ModelController.newNameCount[doctype]}';
  }

  /// Adds the documents to a static local variable [locals].
  ///
  /// ```json
  /// {
  /// "User":{
  ///         "Admin":[User Instance]
  ///        }
  /// },
  /// {
  /// "Item":{
  ///       "Item 1": [Item Instance]
  ///        }
  /// }
  /// ```
  ///
  @protected
  @override
  void addToLocals<T extends FrappeDocument>(T doc) {
    EmptyDoctypeError.verify(doc.doctype);

    if (!locals.containsKey(doc.doctype)) {
      locals[doc.doctype] = <String, dynamic>{};
    }
    if (doc.name == null) {
      doc.name = getNewName(doc.doctype);
      doc.docStatus = FrappeDocStatus.Draft; // treat as a new doc
      doc.isLocal = true;
      doc.unsaved = true;
    }
    locals[doc.doctype][doc.name] = doc;
  }

  /// Returns the document specified by its [docName].
  ///
  /// By default, will return the document if available locally in [locals], otherwise it's fetched from the backend.
  ///
  /// If fetched from the backend, the document is added to [locals] using [addToLocals].
  ///
  /// If [forceFetch] is true, the document will be fetched from the backend even if it exists locally.
  ///
  /// Throws [EmptyDoctypeError] if the doctype field is not set within the model class.
  @override
  Future<RequestResponse<T>> getDoc<T extends FrappeDocument>(
      T obj, String docName,
      {bool forceFetch = false}) async {
    await getFrappe().checkRenovationCoreInstalled();

    EmptyDoctypeError.verify(obj.doctype);
    EmptyDocNameError.verify(docName);

    final cachedDoc = getDocFromCache<T>(obj.doctype, docName);

    if (cachedDoc != null && !forceFetch) {
      return RequestResponse.success(cachedDoc);
    }

    unawaited(config.coreInstance.meta.getDocMeta(doctype: obj.doctype));
    final response = await Request.initiateRequest(
        url:
            '${config.hostUrl}/api/method/renovation/doc/${Uri.encodeComponent(obj.doctype)}/${Uri.encodeComponent(docName)}',
        method: HttpMethod.GET,
        isFrappeResponse: false);
    if (response.isSuccess) {
      final dynamic responseObj = response.data.message;
      if (responseObj != null && responseObj != 'failed') {
        final temp = obj.fromJson<T>(responseObj);

        addToLocals(temp);
        return RequestResponse.success(temp, rawResponse: response.rawResponse);
      }
      response.isSuccess = false;
      return RequestResponse.fail(handleError(
          'get_doc',
          response.error ??
              ErrorDetail(
                  info: Information(
                      data: response.data,
                      httpCode: response.httpCode,
                      rawResponse: response.rawResponse)
                    ..rawError = response?.error?.info?.rawError)));
    }

    return RequestResponse.fail(handleError('get_doc', response.error));
  }

  /// Returns list of documents [T] of a doctype specified by [obj].
  ///
  /// By default, only the name field of the documents is fetched.
  ///
  /// If the [fields] property is specified as `["*"]`, all the fields of a document will be fetched.
  ///
  /// By default, child tables are not included and have to be specified under [tableFields].
  ///
  /// [filters] must comply with [DBFilter] specifications. Throws [InvalidFrappeFilter] otherwise.
  ///
  /// By default, the list will return `99` items specified by [limitPageLength].
  ///
  /// By default, the list will start from the index `0` in the DB specified by [limitPageStart].
  ///
  /// The list can be ordered in the following format specified by [orderBy] :
  ///
  ///    - {{field_name}} asc|desc
  ///    - By default, the list is ordered by modification timestamp (modified)
  @override
  Future<RequestResponse<List<T>>> getList<T extends FrappeDocument>(T obj,
      {List<String> fields,
      dynamic filters,
      String orderBy = 'modified desc',
      int limitPageStart = 0,
      int limitPageLength = 99,
      String parent,
      Map<String, List<String>> tableFields,
      List<String> withLinkFields}) async {
    await getFrappe().checkRenovationCoreInstalled();

    orderBy ??= 'modified desc';
    limitPageStart ??= 0;
    limitPageLength ??= 0;
    fields ??= <String>['name'];

    EmptyDoctypeError.verify(obj.doctype);

    if (filters != null) {
      if (!DBFilter.isDBFilter(filters)) throw InvalidFrappeFilter();
    }

    final params = GetListParams(obj.doctype,
        fields: fields.join(','),
        filters: filters != null ? jsonEncode(filters) : null,
        orderBy: orderBy,
        limitPageLength: limitPageLength,
        limitPageStart: limitPageStart,
        parent: parent,
        tableFieldsFrappe: tableFields != null ? jsonEncode(tableFields) : null,
        withLinkFieldsFrappe:
            withLinkFields != null ? jsonEncode(withLinkFields) : null);
    params.cmd = 'renovation_core.db.query.get_list_with_child';

    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.QUERY_STRING,
        queryParams: params.toJson());
    if (response.isSuccess) {
      // Convert the JSON => T
      final responseObj = obj.deserializeList<T>(response.data.message);
      return RequestResponse.success(responseObj,
          rawResponse: response.rawResponse);
    } else {
      return RequestResponse.fail(handleError('get_list', response.error));
    }
  }

  /// Returns a [Map] of docfield and its value of a specific [doctype] and [docName] from the backend. For instance:
  ///
  /// ```json
  /// {
  /// "email": "abc@example.com"
  /// }
  /// ```
  ///
  /// Returns a failure in case [doctype], [docName] or [docField] don't exist.
  @override
  Future<RequestResponse<Map<String, dynamic>>> getValue(
      String doctype, String docName, String docField) async {
    EmptyDoctypeError.verify(doctype);
    EmptyDocNameError.verify(docName);
    EmptyDocFieldError.verify(docField);

    final params = GetValueParams(doctype, docName, docField);
    params.cmd = 'frappe.client.get_value';

    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.GET,
        contentType: ContentTypeLiterals.QUERY_STRING,
        queryParams: params.toJson());
    if (response.isSuccess) {
      if (response.data?.message != null) {
        return RequestResponse.success(response.data.message,
            rawResponse: response.rawResponse);
      } else {
        response.isSuccess = false;
        return RequestResponse.fail(handleError(
            'get_value',
            ErrorDetail(
                info: Information(
                    data: response.data,
                    httpCode: response.httpCode,
                    rawResponse: response.rawResponse))));
      }
    } else {
      return RequestResponse.fail(handleError('get_value', response.error));
    }
  }

  /// Deletes the document from the backend, returning its name.
  ///
  /// If the document exists in locals cache, it will be deleted as well.
  ///
  /// Throws [EmptyDoctypeError] if [doctype] is `null` or an empty string.
  ///
  /// Throws [EmptyDocNameError] if [docName] is `null` or an empty string.
  ///
  /// Returns a failure if the document or doctype don't exist.
  @override
  Future<RequestResponse<String>> deleteDoc(
      String doctype, String docName) async {
    EmptyDoctypeError.verify(doctype);
    EmptyDocNameError.verify(docName);

    final response = await Request.initiateRequest(
        url:
            '${config.hostUrl}/api/resource/${Uri.encodeComponent(doctype)}/${Uri.encodeComponent(docName)}',
        method: HttpMethod.DELETE);
    if (response.isSuccess) {
      if (locals[doctype] != null && locals[doctype][docName] != null) {
        locals[doctype].remove(docName);
      }
      return RequestResponse.success(docName);
    } else {
      return RequestResponse.fail(handleError('delete_doc', response.error));
    }
  }

  /// Returns a cloned doc, with a new local name.
  @override
  T copyDoc<T extends FrappeDocument>(T doc) {
    EmptyDoctypeError.verify(doc.doctype);
    final clone = JSONAble.clone<T>(doc);
    clone.name = getNewName(doc.doctype);
    clone.docStatus = FrappeDocStatus.Draft;
    clone.isLocal = true;
    clone.unsaved = true;
    addToLocals(clone);
    return clone;
  }

  /// Clones a doc, set amended_from property to the original doc.
  @override
  T amendDoc<T extends FrappeDocument>(T doc) {
    EmptyDoctypeError.verify(doc.doctype);
    EmptyDocNameError.verify(doc.name);

    if (doc.docStatus != FrappeDocStatus.Submitted) {
      throw NotASubmittedDocument();
    }
    final newDoc = copyDoc(doc);
    newDoc.amendedFrom = doc.name;
    return newDoc;
  }

  @override
  Future<T> addChildDoc<T extends FrappeDocument>(
          T childDoc, dynamic field) async =>
      throw Exception('Method not implemeted yet');

  /// Returns the modified document [T] after setting the [docField] with [docValue].
  ///
  /// Returns a failure in case `doctype`, [docName] or [docField] don't exist.
  ///
  /// Throws [InvalidFrappeFieldValue] if [docValue] doesn't comply with [DBFilter.isDBValue].
  @override
  Future<RequestResponse<T>> setValue<T extends FrappeDocument>(
      T obj, String docName, String docField, dynamic docValue) async {
    EmptyDoctypeError.verify(obj.doctype);
    EmptyDocNameError.verify(docName);
    EmptyDocFieldError.verify(docField);
    if (!DBFilter.isDBValue(docValue)) throw InvalidFrappeFieldValue();

    final params = SetValueParams(obj.doctype, docName, docField, docValue);

    params.cmd = 'frappe.client.set_value';

    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: params.toJson());
    if (response.isSuccess) {
      return RequestResponse.success(obj.fromJson(response.data.message),
          rawResponse: response.rawResponse);
    }
    return RequestResponse.fail(handleError('set_value', response.error));
  }

  /// Returns the saved document [T] after saving in the backend and locally.
  ///
  /// If a new doc is to be saved, `isLocal` of the document should be set to `true`.
  ///
  /// If a new doc is saved with the same name, a failure is returned.
  @override
  Future<RequestResponse<T>> saveDoc<T extends FrappeDocument>(T doc) async {
    await getFrappe().checkRenovationCoreInstalled();

    EmptyDoctypeError.verify(doc.doctype);
    EmptyDocNameError.verify(doc.name);

    final response = await Request.initiateRequest(
        url:
            '${config.hostUrl}/api/method/renovation/doc/${Uri.encodeComponent(doc.doctype)}/${doc.isLocal ? "" : '${Uri.encodeComponent(doc.name)}'}',
        method: doc.isLocal ? HttpMethod.POST : HttpMethod.PUT,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: <String, dynamic>{'doc': doc.toJson()},
        isFrappeResponse: false);
    if (response.isSuccess) {
      if (response.data != null && response.data.message is Map) {
        final savedDoc = doc.fromJson<T>(response.data.message);
        savedDoc.isLocal = false;
        savedDoc.unsaved = false;
        addToLocals(savedDoc);
        return RequestResponse.success(savedDoc,
            rawResponse: response.rawResponse);
      }
    }
    response.isSuccess = false;
    return RequestResponse.fail(handleError(
        'save_doc',
        ErrorDetail(
            info: Information(
                data: response.data,
                rawResponse: response.rawResponse,
                httpCode: response.httpCode))));
  }

  /// Submit a submittable document.
  ///
  /// If the doctype or document don't exist, returns failure.
  ///
  /// Throws [NotSubmittableDocError] if the doctype is not submittable based on its meta.
  @override
  Future<RequestResponse<T>> submitDoc<T extends FrappeDocument>(T doc) async {
    EmptyDoctypeError.verify(doc.doctype);
    EmptyDocNameError.verify(doc.name);

    final meta =
        await getFrappeMetaController().getDocMeta(doctype: doc.doctype);

    if (meta.isSuccess && !meta.data.isSubmittable) {
      throw NotSubmittableDocError();
    }

    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: <String, dynamic>{
          'doc': doc.toJson(),
          'cmd': 'frappe.client.submit'
        });
    if (response.isSuccess) {
      if (response.data != null &&
          response.data.exc == null &&
          response.data.message is Map) {
        doc = doc.fromJson(response.data.message);
        doc.isLocal = false;
        doc.unsaved = false;
        addToLocals(doc);
        return RequestResponse.success(doc, rawResponse: response.rawResponse);
      }
    }
    response.isSuccess = false;
    return RequestResponse.fail(handleError(
        'submit_doc',
        response.error ??
            ErrorDetail(
                info: Information(
                    data: response.data,
                    rawResponse: response.rawResponse,
                    httpCode: response.httpCode))));
  }

  /// Saves the document first, then submit, in a single db transaction.
  ///
  /// If the doctype or document don't exist, returns failure.
  ///
  /// Throws [NotSubmittableDocError] if the doctype is not submittable based on its meta.
  @override
  Future<RequestResponse<T>> saveSubmitDoc<T extends FrappeDocument>(
      T doc) async {
    await getFrappe().checkRenovationCoreInstalled();

    EmptyDoctypeError.verify(doc.doctype);
    EmptyDocNameError.verify(doc.name);

    final meta =
        await getFrappeMetaController().getDocMeta(doctype: doc.doctype);

    if (meta.isSuccess && !meta.data.isSubmittable) {
      throw NotSubmittableDocError();
    }

    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: <String, dynamic>{
          'cmd': 'renovation_core.utils.doc.save_submit_doc',
          'doc': doc
        });
    if (response.isSuccess) {
      if (response.data != null &&
          response.data.exc == null &&
          response.data.message is Map) {
        doc = doc.fromJson(response.data.message);
        doc.isLocal = false;
        doc.unsaved = false;
        addToLocals(doc);
        return RequestResponse.success(doc, rawResponse: response.rawResponse);
      }
    }
    response.isSuccess = false;
    return RequestResponse.fail(handleError('save_submit_doc', response.error));
  }

  /// Returns the cancelled document [T] of a submitted document.
  ///
  /// Throws [NotASubmittedDocument] if the doc's status is not [FrappeDocStatus.Submitted].
  ///
  /// Returns a failure, if the document is duplicated or doctype/docname don't exist.
  @override
  Future<RequestResponse<T>> cancelDoc<T extends FrappeDocument>(T doc) async {
    EmptyDoctypeError.verify(doc.doctype);
    EmptyDocNameError.verify(doc.name);

    if (doc.docStatus != FrappeDocStatus.Submitted) {
      throw NotASubmittedDocument();
    }
    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: <String, dynamic>{
          'doctype': doc.doctype,
          'name': doc.name,
          'cmd': 'frappe.client.cancel'
        });
    if (response.isSuccess) {
      if (response.data != null &&
          response.data.exc == null &&
          response.data.message is Map) {
        doc = doc.fromJson(response.data.message);
        doc.isLocal = false;
        doc.unsaved = false;
        addToLocals(doc);
        return RequestResponse.success(doc, rawResponse: response.rawResponse);
      }
    }
    response.isSuccess = false;
    return RequestResponse.fail(handleError('cancel_doc', response.error));
  }

  /// Returns a list of [SearchLinkResponse] after searching against fields.
  ///
  /// By default, the search is done against the `name` field.
  ///
  /// [options] can be used to control the search. For instance searching against `mobile_no`:
  ///
  /// ```json
  /// {
  /// "searchField": "mobile_no"
  /// }
  /// ```
  ///
  /// Returns a successful [RequestResponse] with empty list if the query has no results.
  ///
  /// If the doctype doesn't exist, a failure is returned.
  @override
  Future<RequestResponse<List<SearchLinkResponse>>> searchLink(
      {@required String doctype,
      @required String txt,
      Map<String, dynamic> options}) async {
    EmptyDoctypeError.verify(doctype);

    options ??= <String, dynamic>{};
    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.GET,
        contentType: ContentTypeLiterals.QUERY_STRING,
        queryParams: <String, dynamic>{
          'cmd': 'frappe.desk.search.search_link',
          'txt': txt,
          'doctype': doctype,
          ...options
        },
        isFrappeResponse: false);
    if (response.isSuccess &&
        response.data != null &&
        response.data.message is Map &&
        response.data.message['results'] is List) {
      List temp = response.data.message['results'];
      final results =
          SearchLinkResponse().deserializeList<SearchLinkResponse>(temp);
      return RequestResponse.success(results,
          rawResponse: response.rawResponse);
    } else {
      return RequestResponse.fail(handleError('search_link', response.error));
    }
  }

  /// Assigns a doc or a list of docs to a particular user.
  ///
  /// If the user is signed in, [myself] can be set to `true` where the assigned to will be the user signed in.
  ///
  /// If multiple docs need to be assigned to a user, [bulkAssign] can be set to `true` and [docNames] can be used instead of [docName].
  ///
  /// Returns failure in case the [doctype] does not exist in the backend.
  @override
  Future<RequestResponse<bool>> assignDoc(
      {@required String assignTo,
      @required String doctype,
      bool myself = false,
      DateTime dueDate,
      String description,
      String docName,
      List<String> docNames,
      bool notify = false,
      Priority priority,
      bool bulkAssign = false}) async {
    // FIXME: possible to assign same doc twice, should be validated
    final args = AssignDocParams(
        assignTo: assignTo,
        description: description,
        myself: myself,
        dueDate: dueDate,
        doctype: doctype,
        docName: docName,
        docNames: docNames,
        priority: priority,
        bulkAssign: bulkAssign,
        notify: notify);

    args.cmd = args.bulkAssign
        ? 'frappe.desk.form.assign_to.add_multiple'
        : 'frappe.desk.form.assign_to.add';

    if (args.myself) args.assignTo = config.coreInstance.auth.currentUser;

    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: (args
              ..name =
                  args.bulkAssign ? jsonEncode(args.docNames) : args.docName)
            .toJson());
    if (response.isSuccess) {
      return RequestResponse.success(response.isSuccess);
    } else {
      return RequestResponse.fail(handleError('assign_doc', response.error));
    }
  }

  /// Sets the assignment to [Status.Cancelled] which means that the task is assigned.
  @override
  Future<RequestResponse<bool>> completeDocAssignment(
      {@required String doctype,
      @required String docName,
      @required String assignedTo}) async {
    EmptyDoctypeError.verify(doctype);
    EmptyDocNameError.verify(docName);
    final args = CompleteDocAssignmentParams(
      doctype: doctype,
      name: docName,
      assignedTo: assignedTo,
    )..cmd = 'frappe.desk.form.assign_to.remove';

    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: args.toJson());
    if (response.isSuccess) {
      return RequestResponse.success(true, rawResponse: response.rawResponse);
    } else {
      return RequestResponse.fail(
          handleError('complete_doc_assignment', response.error));
    }
  }

  /// Un-assigns a user from the [doctype] and [docName].
  @override
  Future<RequestResponse<bool>> unAssignDoc(
      {@required String doctype,
      @required String docName,
      @required String unAssignFrom}) async {
    await getFrappe().checkRenovationCoreInstalled();

    EmptyDoctypeError.verify(doctype);
    EmptyDocNameError.verify(docName);
    // FIXME possible to unassign same doc twice, should be validated
    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: <String, dynamic>{
          'cmd': 'renovation_core.utils.assign_doc.unAssignDocFromUser',
          'doctype': doctype,
          'docname': docName,
          'user': unAssignFrom
        });
    if (response.isSuccess) {
      return RequestResponse.success(true, rawResponse: response.rawResponse);
    } else {
      return RequestResponse.fail(handleError('unassign_doc', response.error));
    }
  }

  /// Returns the list of documents assigned to a user.
  ///
  /// Optionally can filter the list by specifying [doctype] and [status].
  @override
  Future<RequestResponse<List<GetDocsAssignedToUserResponse>>>
      getDocsAssignedToUser(
          {@required String assignedTo, String doctype, Status status}) async {
    await getFrappe().checkRenovationCoreInstalled();

    final args = GetDocsAssignedToUserParams(
        assignedTo: assignedTo, doctype: doctype, status: status)
      ..cmd = 'renovation_core.utils.assign_doc.getDocsAssignedToUser';

    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: args.toJson());
    if (response.isSuccess) {
      List result = response.data.message;

      return RequestResponse.success(
          result.isNotEmpty
              ? GetDocsAssignedToUserResponse().deserializeList(result)
              : [],
          rawResponse: response.rawResponse);
    } else {
      return RequestResponse.fail(
          handleError('get_docs_assigned_to_user', response.error));
    }
  }

  /// Returns the users assigned to a document of a certain doctype as list of [ToDo].
  @override
  Future<RequestResponse<List<ToDo>>> getUsersAssignedToDoc(
      {@required String doctype, @required String docName}) async {
    EmptyDoctypeError.verify(doctype);
    EmptyDocNameError.verify(docName);
    final response = await getList(ToDo(), filters: {
      'reference_type': doctype,
      'reference_name': docName
    }, fields: [
      'date',
      'status',
      'assigned_by',
      'assigned_by_full_name',
      'owner',
      'priority',
      'description'
    ]);

    if (response.isSuccess) {
      return response;
    } else {
      return RequestResponse.fail(
          handleError('get_users_assigned_to_doc', response.error));
    }
  }

  /// Adds a tag to document [docName] of a [doctype].
  ///
  /// If the document is tagged with the same tag, it will silently return success.
  ///
  /// Returns failure if the doctype or docname are invalid.
  @override
  Future<RequestResponse<String>> addTag(
      {@required String doctype,
      @required String docName,
      @required String tag}) async {
    EmptyDoctypeError.verify(doctype);
    EmptyDocNameError.verify(docName);
    final args = {
      'cmd': config.coreInstance.frappe.frappeVersion.major == 12
          ? 'frappe.desk.doctype.tag.tag.add_tag'
          : 'frappe.desk.tags.add_tag',
      'dt': doctype,
      'dn': docName,
      'tag': tag
    };

    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: args);

    if (response.isSuccess) {
      return RequestResponse.success(response.data.message,
          rawResponse: response.rawResponse);
    } else {
      return RequestResponse.fail(handleError('add_tag', response.error));
    }
  }

  /// Removes a tag from a document.
  ///
  /// If the document is not tagged with the tag sent, it will silently return success.
  ///
  /// Returns failure if the doctype or docname are invalid.
  @override
  Future<RequestResponse<String>> removeTag(
      {@required String doctype,
      @required String docName,
      @required String tag}) async {
    EmptyDoctypeError.verify(doctype);
    EmptyDocNameError.verify(docName);

    final args = {
      'cmd': config.coreInstance.frappe.frappeVersion.major == 12
          ? 'frappe.desk.doctype.tag.tag.remove_tag'
          : 'frappe.desk.tags.remove_tag',
      'dt': doctype,
      'dn': docName,
      'tag': tag
    };

    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: args);

    if (response.isSuccess) {
      return RequestResponse.success(tag, rawResponse: response.rawResponse);
    } else {
      return RequestResponse.fail(handleError('remove_tag', response.error));
    }
  }

  /// Gets all the names of all documents with the param-tag.
  ///
  /// If the tag doesn't exist, an empty array is returned.
  ///
  /// Returns failure if the doctype.
  @override
  Future<RequestResponse<List<String>>> getTaggedDocs(
      {@required String doctype, String tag}) async {
    EmptyDoctypeError.verify(doctype);

    final response = await Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: <String, dynamic>{
          'cmd': config.coreInstance.frappe.frappeVersion.major == 12
              ? 'frappe.desk.doctype.tag.tag.get_tagged_docs'
              : 'frappe.desk.tags.get_tagged_docs',
          'doctype': doctype,
          'tag': tag ?? ''
        });

    if (response.isSuccess) {
      List result = response.data.message;
      if (result.isNotEmpty) {
        return RequestResponse.success(List<String>.from(result[0]),
            rawResponse: response.rawResponse);
      }
      return RequestResponse.success([], rawResponse: response.rawResponse);
    } else {
      return RequestResponse.fail(
          handleError('get_tagged_docs', response.error));
    }
  }

  /// Returns all tags of a doctype.
  ///
  /// Optionally specify filters using [likeTag] which can be used in the form of SQL's LIKE statements.
  ///
  /// Returns failure if the doctype.
  @override
  Future<RequestResponse<List<String>>> getTags(
      {@required String doctype, String likeTag}) async {
    if (config.coreInstance.frappe.frappeVersion.major < 12) {
      final response = await Request.initiateRequest(
          url: config.hostUrl,
          method: HttpMethod.POST,
          contentType: ContentTypeLiterals.APPLICATION_JSON,
          data: <String, dynamic>{
            'cmd': 'frappe.desk.tags.get_tags',
            'doctype': doctype,
            'txt': likeTag ?? '',
            'cat_tags': jsonEncode(<dynamic>[])
          });

      if (response.isSuccess) {
        List result = response.data.message;
        return RequestResponse.success(List<String>.from(result),
            rawResponse: response.rawResponse);
      } else {
        return RequestResponse.fail(handleError('get_tags', response.error));
      }
    } else {
      final response = await getList(TagLink(), filters: [
        ['document_type', 'LIKE', doctype],
        ['tag', 'LIKE', '%${likeTag ?? ''}%']
      ], fields: [
        'tag'
      ]);

      if (response.isSuccess) {
        final tags = response.data.map((_tag) => _tag.tag).toList();
        return RequestResponse.success(tags, rawResponse: response.rawResponse);
      }
      return RequestResponse.fail(handleError('get_tag', response.error));
    }
  }

  /// Get report values in the form of [FrappeReport].
  ///
  /// Optionally specify filters which should conform to [DBFilter].
  ///
  /// Optionally specify the target user. Defaults to `null`.
  @override
  Future<RequestResponse<FrappeReport>> getReport(
      {@required String report, dynamic filters, String user}) async {
    await getFrappe().checkRenovationCoreInstalled();

    if (filters != null) {
      if (!DBFilter.isDBFilter(filters)) throw InvalidFrappeFilter();
    }
    filters ??= <String, dynamic>{};
    final response = await Request.initiateRequest(
      url: '${config.hostUrl}/api/method/renovation/report',
      method: HttpMethod.POST,
      contentType: ContentTypeLiterals.APPLICATION_JSON,
      data: <String, dynamic>{
        'report': report,
        'filters': filters,
        'user': user
      },
      isFrappeResponse: false,
    );
    if (response.isSuccess && response.data != null) {
      return RequestResponse.success(
          FrappeReport.fromJson(response.data.message),
          rawResponse: response.rawResponse);
    } else {
      return RequestResponse.fail(handleError('get_report', response.error));
    }
  }

  @override
  ErrorDetail handleError(String errorId, ErrorDetail error) {
    switch (errorId) {
      case 'get_doc':
        if (error.info != null &&
            error.info.data != null &&
            error.info?.data?.exception != null) {
          if (error.info.data.exception.contains('DoesNotExistError')) {
            error = handleError('non_existing_doc', error);
          } else if (error.info.data.exception.contains('ImportError')) {
            error = handleError('non_existing_doctype', error);
          }
        } else if (error.info.httpCode == 412) {
          error = handleError('wrong_input', error);
        } else {
          error = handleError(null, error);
        }
        break;
      case 'wrong_input':
        error
          ..type = RenovationError.DataFormatError
          ..title = 'Wrong input'
          ..info = (error.info
            ..httpCode = 412
            ..cause = 'The input arguments are in the wrong type/format'
            ..suggestion =
                'Use the correct parameters types/formats referencing the functions signature'
            ..data = error.info);
        break;
      case 'delete_doc':
        if (error.info.httpCode == 404) {
          error = handleError('non_existing', error);
        } else {
          error = handleError(null, error);
        }
        break;
      case 'get_report':
        if (error.info.httpCode == 404 &&
            error.info.data != null &&
            error.info.data.excType.contains('DoesNotExistError')) {
          error = handleError('non_existing_doctype', error);
        } else {
          error = handleError(null, error);
        }
        break;
      case 'set_value':
      case 'add_tag':
      case 'remove_tag':
        if (error.info.httpCode == 500) {
          error = handleError('non_existing_doctype', error);
        } else if (error.info.httpCode == 404) {
          error = handleError('non_existing_doc', error);
        } else {
          error = handleError(null, error);
        }
        break;
      case 'get_value':
        if (error.info.httpCode == 200) {
          error = handleError('non_existing', error);
        } else if (error.info.httpCode == 500) {
          error = handleError('non_existing_docfield', error);
        } else {
          handleError(null, error);
        }
        break;
      case 'save_doc':
        if (error.info != null &&
            error.info.data != null &&
            error.info.data.exception != null &&
            error.info.data.exception.contains('DuplicateEntryError')) {
          error = handleError('duplicate_document', error);
        } else {
          error = handleError(null, error);
        }
        break;
      case 'submit_doc':
      case 'save_submit_doc':
      case 'cancel_doc':
        if (error.info.httpCode == 409) {
          error = handleError('duplicate_document', error);
        } else if (error.info.httpCode == 500) {
          error = handleError('non_existing_doctype', error);
        } else if (error.info.httpCode == 404) {
          error = handleError('non_existing_doc', error);
        } else {
          error = handleError(null, error);
        }
        break;
      case 'search_link':
        if (error.info.httpCode == 404 &&
            error.info.data != null &&
            error.info.data.excType == 'DoesNotExistError') {
          error = handleError('non_existing_doctype', error);
        } else {
          error = handleError(null, error);
        }
        break;
      case 'get_tagged_docs':
        if (error.info.httpCode == 500 &&
            error.info.data != null &&
            error.info.data.exc.contains("doesn't exist")) {
          error = handleError('non_existing_doctype', error);
        } else {
          error = handleError(null, error);
        }
        break;

      case 'get_tags':
        if (error.info.httpCode == 500) {
          error = handleError('non_existing_doctype', error);
        } else {
          error = handleError(null, error);
        }
        break;
      case 'non_existing':
        error
          ..type = RenovationError.NotFoundError
          ..title = DOCTYPE_OR_DOCNAME_NOT_EXIST_TITLE
          ..info = (error.info
            ..httpCode = 404
            ..cause = 'Doctype or Docname does not exist'
            ..suggestion = 'Make sure the queried document name is correct'
            ..data = error.info);
        break;
      case 'non_existing_doc':
        error
          ..type = RenovationError.NotFoundError
          ..title = DOCNAME_NOT_EXIST_TITLE
          ..info = (error.info
            ..httpCode = 404
            ..cause = 'Docname does not exist'
            ..suggestion =
                'Make sure the queried document name is correct or create the required document'
            ..data = error.info);
        break;
      case 'non_existing_doctype':
        error
          ..type = RenovationError.NotFoundError
          ..title = DOCTYPE_NOT_EXIST_TITLE
          ..info = (error.info
            ..httpCode = 404
            ..cause = 'DocType does not exist'
            ..suggestion =
                'Make sure the queried DocType is input correctly or create the required DocType'
            ..data = error.info);
        break;
      case 'non_existing_docfield':
        error
          ..title = 'DocField is not valid'
          ..type = RenovationError.NotFoundError
          ..info = (error.info
            ..httpCode = 404
            ..cause = 'DocField is not defined for the DocType'
            ..suggestion =
                'Make sure the docfield is input. It is case-sensitive'
            ..data = error.info);
        break;
      case 'duplicate_document':
        error
          ..title = 'Duplicate document found'
          ..type = RenovationError.DuplicateEntryError
          ..info = (error.info
            ..httpCode = 409
            ..cause = 'Duplicate doc found'
            ..suggestion =
                'Change the "name" field or delete the existing document'
            ..data = error.info);
        break;
      case 'get_list':
        if (error.info.httpCode == 500 &&
            error.info.data != null &&
            error.info.data.exc.contains('TableMissingError')) {
          error = handleError('non_existing_doctype', error);
        }
        break;
      case 'assign_doc':
      case 'complete_doc_assignment':
      case 'unassign_doc':
      case 'get_docs_assigned_to_user':
      case 'get_users_assigned_to_doc':
      default:
        error = RenovationController.genericError(error);
    }
    return error;
  }
}
