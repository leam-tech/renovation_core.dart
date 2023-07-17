import 'dart:convert';

import 'package:collection/collection.dart' show IterableExtension;

import '../../core/config.dart';
import '../../core/errors.dart';
import '../../core/frappe/renovation.dart';
import '../../core/renovation.controller.dart';
import '../../core/request.dart';
import '../../misc/string.dart';
import '../../model/frappe/errors.dart';
import '../../model/frappe/filters.dart';
import '../../model/frappe/frappe.model.controller.dart';
import '../../perm/interfaces.dart';
import '../meta.controller.dart';
import 'doctype.dart';
import 'interfaces.dart';

/// A controller containing properties and methods about the models (meta data) related to Frappé.
class FrappeMetaController extends MetaController {
  FrappeMetaController(RenovationConfig config) : super(config);

  /// Holds the doctype's in the cache
  Map<String?, DocType> docTypeCache = <String?, DocType>{};

  /// Returns the number of documents of a [doctype] available in the backend within [RequestResponse].
  ///
  /// Optionally can include filters to return the count based on a certain criteria.
  ///
  /// Throws [InvalidFrappeFilter] if the filter does not conform to Frappé filters.
  ///
  /// If the doctype does not exist, returns a failed [RequestResponse].
  @override
  Future<RequestResponse<int?>> getDocCount(
      {required String doctype, dynamic filters}) async {
    if (filters != null) {
      if (!DBFilter.isDBFilter(filters)) throw InvalidFrappeFilter();
    }
    final response = await Request.initiateRequest(
        url: '${config.hostUrl}',
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: <String, dynamic>{
          'cmd': 'frappe.desk.reportview.get',
          'doctype': doctype,
          'fields': jsonEncode(['count(`tab$doctype`.name) as total_count']),
          'filters': filters != null ? jsonEncode(filters) : null
        });
    if (response.isSuccess) {
      Map resultAsMap = response.data!.message;
      // Since the response is an array of array
      return RequestResponse.success(resultAsMap['values']?.first?.first);
    }
    return RequestResponse.fail(handleError('get_doc_count', response.error));
  }

  /// Returns information about a document [docname] of type [doctype] defined by [FrappeDocInfo].
  ///
  /// Returns a failed [RequestResponse] in case the [doctype] and/or [docname] do not exist in the backend.
  @override
  Future<RequestResponse<FrappeDocInfo?>> getDocInfo(
      {required String? doctype, required String docname}) async {
    final response = await Request.initiateRequest(
        url: '${config.hostUrl}',
        method: HttpMethod.GET,
        contentType: ContentTypeLiterals.QUERY_STRING,
        isFrappeResponse: false,
        queryParams: <String, dynamic>{
          'cmd': 'frappe.desk.form.load.get_docinfo',
          'doctype': doctype,
          'name': docname
        });
    if (response.isSuccess) {
      final Map<String, dynamic>? result = response.data!.message;
      if (result != null) {
        return RequestResponse.success(
            FrappeDocInfo.fromJson(result['docinfo']),
            rawResponse: response.rawResponse);
      } else {
        response.isSuccess = false;
        final error = ErrorDetail(
            title: 'DocInfo Not Found',
            info: Information(
              data: response.data,
              httpCode: response.httpCode,
            ));

        return RequestResponse.fail(handleError('get_doc_info', error));
      }
    } else {
      return RequestResponse.fail(handleError(
          'get_doc_info', response.error ?? response.data as ErrorDetail?));
    }
  }

  /// Returns the meta about a certain doctype based on the definition of Frappé's [DocType].
  ///
  /// In addition, to getting the meta, it is added to a [docTypeCache] as a local cache.
  ///
  /// Returns a failed [RequestResponse] if the doctype doesn't exist in the backend.
  @override
  Future<RequestResponse<DocType?>> getDocMeta(
      {required String? doctype}) async {
    await getFrappe().checkAppInstalled(features: ['getDocMeta']);

    if (docTypeCache.containsKey(doctype) && docTypeCache[doctype] != null) {
      if (docTypeCache.containsKey(doctype) &&
          docTypeCache[doctype] != null &&
          !docTypeCache[doctype]!.isLoading) {
        return RequestResponse.success(docTypeCache[doctype]);
      } else {
        while (docTypeCache.containsKey(doctype) &&
            docTypeCache[doctype] != null &&
            docTypeCache[doctype]!.isLoading) {
          await Future<void>.delayed(Duration(milliseconds: 100));
        }
        if (docTypeCache.containsKey(doctype) &&
            docTypeCache[doctype] != null) {
          return RequestResponse.success(docTypeCache[doctype]);
        } else {
          return RequestResponse.fail(
              handleError('get_doc_meta', ErrorDetail()));
        }
      }
    } else {
      docTypeCache[doctype] = DocType()..isLoading = true;

      // FIXME: Core-Dart doesn't support scripts currently
      //    config.coreInstance.scriptManager.events[doctype] = {};
      final response = await Request.initiateRequest(
          url: config.hostUrl,
          method: HttpMethod.POST,
          contentType: ContentTypeLiterals.APPLICATION_JSON,
          data: <String, dynamic>{
            'cmd': 'renovation_core.utils.meta.get_bundle',
            'doctype': doctype
          });

      if (response.isSuccess) {
        final metas = <String?, DocType>{};
        final metasDeserialized = List<DocType>.from(
            (response.data!.message['metas'] as List)
                .map((dynamic _meta) => DocType.fromJson(_meta))
                .toList());
        // local var first, Object.assign together later
        for (final dmeta in metasDeserialized) {
          if (dmeta.doctype == 'DocType') {
            metas[dmeta.name] = dmeta;
            // append __messages for translations

            core.translate.extendDictionary(
                dict: dmeta.messages != null
                    ? dmeta.messages?.cast<String, String>()
                    : null);
          }
        }
        docTypeCache.addAll(metas);
        // trigger read perm which creates the perm dict in rcore.perms.doctypePerms
        metas.forEach((String? k, DocType v) {
          if (v.isTable == null || !v.isTable!) {
            // perm for normal doctypes only, not for Child docs
            core.perm.hasPerm(doctype: k, pType: PermissionType.read);
          }
        });
        return RequestResponse.success(docTypeCache[doctype],
            rawResponse: response.rawResponse);
      }

      return RequestResponse.fail(handleError('get_doc_meta', response.error));
    }
  }

  /// Returns the label of a field in Frappé.
  ///
  /// If the field exists withing the [doctype], the title case equivalent is returned.
  ///
  /// For example, full_name of User doctype will return 'Full Name'.
  ///
  /// If the doctype or the field doesn't exist, [fieldName] is returned.
  @override
  Future<String?> getFieldLabel(
      {required String doctype, required String fieldName}) async {
    final response = await getDocMeta(doctype: doctype);
    dynamic label = fieldName;
    final standardFields = <String, String>{
      'name': 'Name',
      'docStatus': 'DocStatus'
    };
    if (standardFields.containsKey(fieldName)) {
      label = standardFields[fieldName];
    }
    if (!response.isSuccess) {
      config.logger.e('getFieldLabel: Failed to read docmeta');
    } else {
      final docMeta = response.data!;
      var field =
          docMeta.fields!.singleWhereOrNull((f) => f.fieldName == fieldName);

      field ??= docMeta.disabledFields!
          .singleWhereOrNull((f) => f.fieldName == fieldName);
      if (field != null) {
        label = field.label;
      } else {
        label = toTitleCase(label);
      }
    }
    return core.translate.getMessage(txt: label);
  }

  /// Returns the meta details of a Frappé report as a [RenovationReport].
  ///
  /// If the [report] doesn't exist, a failed [RequestResponse] is returned.
  @override
  Future<RequestResponse<RenovationReport?>> getReportMeta(
          {required String report}) async =>
      await core.model.getDoc(RenovationReport(), report);

  ///Clears all docMeta from the cache
  @override
  void clearCache() => docTypeCache = <String?, DocType>{};

  @override
  ErrorDetail handleError(String? errorId, ErrorDetail? error) {
    error ??= RenovationController.genericError(error);

    ErrorDetail err;
    switch (errorId) {
      case 'get_doc_count':
        bool containsMissingTable = error.info?.rawError?.response?.data
                ?.contains('TableMissingError') ??
            false;
        if (error.info?.httpCode == 404 || containsMissingTable) {
          err = handleError('doctype_not_exist', error);
        } else {
          err = handleError(null, error);
        }
        break;
      case 'get_doc_meta':
        if (error.info?.httpCode == 404) {
          err = handleError('doctype_not_exist', error);
        } else {
          err = handleError(null, error);
        }
        break;
      case 'get_doc_info':
        if (identical(error.info?.httpCode, 404)) {
          err = handleError('docname_not_exist', error);
        } else if (identical(error.info?.httpCode, 500)) {
          err = handleError('doctype_not_exist', error);
        } else if (identical(error.title, 'DocInfo Not Found')) {
          error.type = RenovationError.NotFoundError;
          error.info = Information(
              data: error.info, httpCode: 404, cause: 'Docinfo not found');
          err = ErrorDetail(
              title: error.title, type: error.type, info: error.info);
        } else {
          err = handleError(null, error);
        }
        break;
      case 'doctype_not_exist':
        error
          ..title = FrappeModelController.DOCTYPE_NOT_EXIST_TITLE
          ..type = RenovationError.NotFoundError
          ..info = (error.info = Information(
              data: error.info,
              httpCode: 404,
              cause: FrappeModelController.DOCTYPE_NOT_EXIST_TITLE,
              suggestion:
                  'Make sure the queried doctype is correct or create the required doctype'));
        err = ErrorDetail(title: error.title, info: error.info);
        break;
      case 'docname_not_exist':
        error
          ..title = FrappeModelController.DOCNAME_NOT_EXIST_TITLE
          ..type = RenovationError.NotFoundError
          ..info = ((error.info ?? Information())
            ..httpCode = 404
            ..cause = FrappeModelController.DOCNAME_NOT_EXIST_TITLE
            ..suggestion =
                'Make sure the queried document name is correct or create the required document');
        err = ErrorDetail(title: error.title, info: error.info);
        break;
      default:
        err = RenovationController.genericError(error);
    }
    return err;
  }
}
