import 'dart:convert';

import 'package:meta/meta.dart';

import '../../../core.dart';
import '../../core/errors.dart';
import '../../model/frappe/interfaces.dart';
import '../log.manager.dart';
import 'errors.dart';

/// Class for handling Frappe-specific Logs
class FrappeLogManager extends RenovationController implements LogManager {
  FrappeLogManager(RenovationConfig config) : super(config);

  /// The private def. tags
  final List<String> _defaultTags = [];

  @override
  void clearCache() => _defaultTags.clear();

  /// Use this function to set the basic set of tags to be set for the logs raised from the client side
  void setDefaultTags(List<String> tags) => _defaultTags.setAll(0, tags);

  @override
  ErrorDetail handleError(String errorId, ErrorDetail error) =>
      RenovationController.genericError(error);

  @override
  Future<RequestResponse<FrappeLog>> error(
      {@required String content, String title, List<String> tags}) {
    if (content == null || content.isEmpty) {
      throw EmptyContentError();
    }
    return invokeLogger(
        cmd: 'renovation_core.utils.logging.log_error',
        content: content,
        title: title,
        tags: tags);
  }

  @override
  Future<RequestResponse<FrappeLog>> info(
      {@required String content, String title, List<String> tags}) {
    if (content == null || content.isEmpty) {
      throw EmptyContentError();
    }
    return invokeLogger(
        cmd: 'renovation_core.utils.logging.log_info',
        content: content,
        title: title,
        tags: tags);
  }

  @override
  Future<RequestResponse<FrappeLog>> warning(
      {@required String content, String title, List<String> tags}) {
    if (content == null || content.isEmpty) {
      throw EmptyContentError();
    }
    return invokeLogger(
        cmd: 'renovation_core.utils.logging.log_warning',
        content: content,
        title: title,
        tags: tags);
  }

  @override
  Future<RequestResponse<FrappeLog>> logRequest(
      {@required RequestResponse<dynamic> r, List<String> tags}) {
    if (r == null) {
      throw EmptyResponseError();
    }
    final _tags = ['frontend-request'];
    if (tags != null) {
      _tags.addAll(tags);
    }

    final req = r.rawResponse.request;
    final requestInfo =
        'Headers:\n${req.headers}\nParams:\n${json.encode(req.data)}';

    final headersInfo = <List<String>>[];
    r.rawResponse.headers.map.forEach((String k, List<String> value) {
      headersInfo.add([k, ...value]);
    });
    var header = '';
    headersInfo.forEach((List<String> headerInfo) {
      header += '${headerInfo[0]}: ${headerInfo[1]}\n';
    });

    final responseInfo =
        'Status: ${r.rawResponse.statusCode}\nHeaders:\n$header\n\nBody:\n${json.encode(r.rawResponse.data)}';

    return invokeLogger(
        cmd: 'renovation_core.utils.logging.log_client_request',
        request: requestInfo,
        response: responseInfo,
        tags: _tags);
  }

  @override
  Future<RequestResponse<FrappeLog>> invokeLogger(
      {@required String cmd,
      String content,
      String title,
      List<String> tags,
      String request,
      String response}) async {
    await getFrappe().checkAppInstalled(features: ['Logger']);

    tags ?? _defaultTags;

    final logResponse = await config.coreInstance.call(<String, dynamic>{
      'cmd': cmd,
      'content': content,
      'title': title,
      'tags': tags != null ? json.encode(tags) : null,
      'request': request,
      'response': response
    });

    if (logResponse.isSuccess) {
      List<dynamic> tagsDoc = logResponse.data.message['tags'];
      if (logResponse.data.message != null && tagsDoc != null) {
        final tags = tagsDoc.map<String>((dynamic x) => x['tag']).toList();

        logResponse.data.message.addAll({'tags_list': tags});
      }
      return RequestResponse.success<FrappeLog>(
          FrappeLog.fromJson(logResponse.data.message),
          rawResponse: logResponse.rawResponse);
    } else {
      return RequestResponse.fail(handleError(null, logResponse.error));
    }
  }
}
