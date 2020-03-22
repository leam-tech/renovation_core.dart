import 'package:enum_to_string/enum_to_string.dart';
import 'package:meta/meta.dart';

import '../../core/config.dart';
import '../../core/errors.dart';
import '../../core/frappe/renovation.dart';
import '../../core/renovation.controller.dart';
import '../../core/request.dart';
import '../../meta/frappe/doctype.dart';
import '../../model/frappe/document.dart';
import '../interfaces.dart';
import '../perm.controller.dart';
import 'errors.dart';
import 'interfaces.dart';

/// Frappe Permission Controller with extended methods & properties
///
/// Includes a method for loading basic permissions and checking permission of doctypes/documents.
class FrappePermissionController extends PermissionController<FrappeDocument> {
  FrappePermissionController(RenovationConfig config) : super(config);

  /// Returns the basic params from the backend for the current user defined by [BasicPermInfo].
  ///
  /// In addition, it adds the received permissions in [basicPerms].
  ///
  /// If a user isn't signed in, the Guest basic permissions is retrieved.
  @override
  Future<RequestResponse<BasicPermInfo>> loadBasicPerms() async {
    if (basicPerms != null) {
      if (basicPerms.isLoading) {
        await Future<dynamic>.delayed(Duration(milliseconds: 50));
        return loadBasicPerms();
      } else {
        return RequestResponse.success(basicPerms);
      }
    }

    basicPerms = BasicPermInfo()..isLoading = true;

    final user = config.coreInstance.auth.currentUser ?? 'Guest';

    final response = await Request.initiateRequest(
        url: config.hostUrl +
            '/api/method/renovation_core.utils.client.get_current_user_permissions',
        method: HttpMethod.POST,
        contentType: ContentTypeLiterals.APPLICATION_JSON);
    if (response.isSuccess && response.data != null) {
      response.data.message != null
          ? basicPerms = (BasicPermInfo.fromJson(response.data.message)
            ..user = user
            ..isLoading = false)
          : basicPerms = BasicPermInfo();
    }
    return response.isSuccess
        ? RequestResponse.success(basicPerms, rawResponse: response.rawResponse)
        : RequestResponse.fail(handleError('load_basic_perms', response.error));
  }

  /// Returns the list permission of the current user of a certain [doctype].
  ///
  /// Optionally can specify the permission of a certain [document] (TBD).
  @override
  Future<RequestResponse<List<DocPerm>>> getPerm<T extends FrappeDocument>(
      {@required String doctype, T document}) async {
    var perm = <DocPerm>[
      DocPerm()
        ..read = false
        ..ifOwner = false
        ..permLevel = 0
    ];

    if (getFrappeAuthController().currentUser == 'Administrator') {
      perm[0].read = true;
    }

    final responses = await Future.wait([
      getFrappeMetaController().getDocMeta(doctype: doctype),
      getFrappeAuthController().getCurrentUserRoles()
    ]);
    final RequestResponse<DocType> docMeta = responses[0];
    final RequestResponse<List<String>> currentUserRoles = responses[1];

    if (!docMeta.isSuccess) {
      return RequestResponse.success(perm);
    }

    if (!currentUserRoles.isSuccess) {
      return RequestResponse.success(perm);
    }

    // read from meta.permissions
    for (final doctypePerm in docMeta.data.permissions) {
      // apply only if this DocPerm role is present for currentUser
      if (!currentUserRoles.data.contains(doctypePerm.role)) {
        continue;
      }

      // permlevels 0,1,2..
      // There's a new perm level, need to grow the list
      if (perm.length < doctypePerm.permLevel + 1) {
        perm.add(DocPerm());
        perm[doctypePerm.permLevel].permLevel = doctypePerm.permLevel;
      }

      // For User permissions
      // NOTE: this data is required for displaying match rules in ListComponent
      for (final pType in PermissionType.values) {
        final permission = perm[doctypePerm.permLevel].toJson();
        final permissionType = EnumToString.parse(pType);
        permission[permissionType] = permission[permissionType] == 1
            ? permission[permissionType]
            : (doctypePerm.toJson()[permissionType] ?? 0);
        perm[doctypePerm.permLevel] = DocPerm.fromJson(permission);
      }
    }
    // TODO : Implement Document Specific rules
    return RequestResponse.success(perm);
  }

  /// Returns boolean whether the user has perm [pType] for a particular [doctype].
  ///
  /// Optionally can specify [permLevel] for values allowed from (0-9).
  ///
  /// If there are errors, `false` is returned.
  @override
  Future<bool> hasPerm(
      {@required String doctype,
      @required PermissionType pType,
      int permLevel,
      String docname}) async {
    if (!doctypePerms.containsKey(doctype)) {
      final permsR = await getPerm(doctype: doctype);
      if (permsR.isSuccess) {
        doctypePerms[doctype] = permsR.data;
      }
    }
    permLevel ??= 0;

    if (permLevel < 0 || permLevel > 9) throw InvalidPermissionLevel();

    final perms = doctypePerms[doctype];

    if (perms == null) {
      return false;
    }
    if (perms.length < permLevel + 1 || perms[permLevel] == null) {
      return false;
    }

    var perm = perms[permLevel].toJson()[EnumToString.parse(pType)] == 1;
    if (permLevel == 0 && docname != null) {
      final docInfo = await getFrappeMetaController()
          .getDocInfo(doctype: doctype, docname: docname);
      if (docInfo.isSuccess &&
          docInfo.data != null &&
          docInfo.data.permissions.toJson()[EnumToString.parse(pType)] == 0) {
        perm = false;
      }
    }
    return perm;
  }

  /// Similar to [hasPerm] with the key difference that it can accept a list of perms [pTypes].
  ///
  /// If one of the perms is not allowed, the method returns `false`.
  @override
  Future<bool> hasPerms(
      {@required String doctype,
      @required List<PermissionType> pTypes,
      String docname}) async {
    for (final pType in pTypes) {
      final hasPerm = await this.hasPerm(
          doctype: doctype, pType: pType, permLevel: 0, docname: docname);
      if (!hasPerm) {
        return false;
      }
    }
    return true;
  }

  @override
  ErrorDetail handleError(String errorId, ErrorDetail error) {
    ErrorDetail err;
    switch (errorId) {
      case 'load_basic_perms':
      default:
        err = RenovationController.genericError(error);
    }

    return err;
  }
}
