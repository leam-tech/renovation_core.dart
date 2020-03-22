import 'package:meta/meta.dart';

import '../core/config.dart';
import '../core/renovation.controller.dart';
import '../core/request.dart';

/// A controller containing properties and methods about the models (meta data).
abstract class MetaController extends RenovationController {
  MetaController(RenovationConfig config) : super(config);

  /// Returns the number of documents of a [doctype] available in the backend within [RequestResponse].
  Future<RequestResponse<int>> getDocCount(
      {@required String doctype, dynamic filters});

  /// Returns information about a document [docname] of type [doctype].
  ///
  /// Can specify the return within [RequestResponse] in the extending class.
  Future<RequestResponse<dynamic>> getDocInfo(
      {@required String doctype, @required String docname});

  /// Returns the meta about a doctype (collection).
  ///
  /// Can specify the return within [RequestResponse] in the extending class.
  Future<RequestResponse<dynamic>> getDocMeta({@required String doctype});

  /// Returns the label of a field [fieldName].
  Future<String> getFieldLabel(
      {@required String doctype, @required String fieldName});

  /// Returns meta details of a report.
  ///
  /// Can specify the return within [RequestResponse] in the extending class.
  Future<RequestResponse<dynamic>> getReportMeta({@required String report});

//FIXME: Since Dart doesn't support the Scripts yet
//  Future<RequestResponse<bool>> loadDocTypeScripts(
//      dynamic doctype) async {
//    dynamic dt;
//    if (doctype.runtimeType == String) {
//      dt = doctype;
//    } else {
//      dt = doctype.doctype;
//    }
//    return config.coreInstance.scriptManager.loadScripts(dt);
//  }
}
