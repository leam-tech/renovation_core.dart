import '../core/config.dart';
import '../core/renovation.controller.dart';
import '../core/request.dart';
import '../model/document.dart';
import 'frappe/interfaces.dart';
import 'interfaces.dart';

/// Class containing permission properties/caches & methods
abstract class PermissionController<K extends RenovationDocument>
    extends RenovationController {
  PermissionController(RenovationConfig config) : super(config);

  /// Holds the basic permissions defined by [BasicPermInfo].
  BasicPermInfo? basicPerms;

  /// Holds the permissions for each doctype as a form of caching.
  Map<String?, List<DocPerm>> doctypePerms = <String?, List<DocPerm>>{};

  /// Resets the [basicPerms] and [doctypePerms] properties.
  ///
  /// For instance, when the session changes.
  @override
  void clearCache() {
    basicPerms = null;
    doctypePerms = <String?, List<DocPerm>>{};
  }

  /// Loads the basic params from the backend for the current user.
  Future<RequestResponse<dynamic>> loadBasicPerms();

  /// Returns the list permission of the current user of a certain [doctype].
  Future<RequestResponse<List<dynamic>>> getPerm<T extends K>(
      {required String doctype, T? document});

  /// Returns boolean whether the user has perm [pType] for a particular [doctype].
  Future<bool> hasPerm(
      {required String? doctype,
      required PermissionType pType,
      int? permLevel,
      String? docname});

  /// Similar to [hasPerm] but instead can accept a list of perms [pTypes].
  Future<bool> hasPerms(
      {required String doctype,
      required List<PermissionType> pTypes,
      String? docname});

  /// Check if the user can create a doctype.
  Future<bool> canCreate(String doctype) async =>
      await _canInUserPermissions('can_create', doctype);

  /// Check if the user can read a doctype.
  Future<bool> canRead(String doctype) async =>
      await _canInUserPermissions('can_read', doctype);

  /// Check if the user can write a doctype
  Future<bool> canWrite(String doctype) async =>
      await _canInUserPermissions('can_write', doctype);

  /// Check if the user can cancel a doctype.
  Future<bool> canCancel(String doctype) async =>
      await _canInUserPermissions('can_cancel', doctype);

  /// Check if the user can delete a doctype.
  Future<bool> canDelete(String doctype) async =>
      await _canInUserPermissions('can_delete', doctype);

  /// Check if the user can import a doctype.
  Future<bool> canImport(String doctype) async =>
      await _canInUserPermissions('can_import', doctype);

  /// Check if the user can export a doctype.
  Future<bool> canExport(String doctype) async =>
      await _canInUserPermissions('can_export', doctype);

  /// Check if the user can print a doctype.
  Future<bool> canPrint(String doctype) async =>
      await _canInUserPermissions('can_print', doctype);

  /// Check if the user can email a doctype.
  Future<bool> canEmail(String doctype) async =>
      await _canInUserPermissions('can_email', doctype);

  /// Check if the user can search a doctype.
  Future<bool> canSearch(String doctype) async =>
      await _canInUserPermissions('can_search', doctype);

  /// Check if the user can get report of a doctype.
  Future<bool> canGetReport(String doctype) async =>
      await _canInUserPermissions('can_get_report', doctype);

  /// Check if the user can set user permissions of a doctype.
  Future<bool> canSetUserPermissions(String doctype) async =>
      await _canInUserPermissions('can_set_user_permissions', doctype);

  /// Check if the user can submit a doctype.
  ///
  /// The permission cache needs to be loaded. If not, `false is returned`.
  Future<bool> canSubmit(String doctype) async {
    // not provided in bootinfo
    final perms = doctypePerms[doctype];
    if (perms != null) return perms[0].submit;

    config.logger.e('Renovation Core'
        'Permissions'
        'Permission Cache not loaded to retrieve correct perm for canSubmit');
    // no perms
    return false;
  }

  /// Check if the user can amend a doctype.
  ///
  /// The permission cache needs to be loaded. If not, `false is returned`.
  Future<bool> canAmend(String doctype) async {
    // not provided in bootinfo
    final perms = doctypePerms[doctype];
    if (perms != null) return perms[0].amend;
    config.logger.e('Renovation Core'
        'Permissions'
        'Permission Cache not loaded to retrieve correct perm for canAmend');
    // no perms
    return false;
  }

  /// Check if the user can recursively delete a doctype.
  ///
  /// The permission cache needs to be loaded. If not, `false is returned`.
  Future<bool> canRecursiveDelete(String doctype) async {
    final perms = doctypePerms[doctype];
    if (perms != null) return perms[0].recursiveDelete;
    config.logger.e('Renovation Core'
        'Permissions'
        'Permission Cache not loaded to retrieve correct perm for canRecursiveDelete');
    // no perms
    return false;
  }

  /// Returns boolean whether the user has the permission part of the basic permissions.
  ///
  /// If the basic permissions aren't loaded, they are loaded first.
  Future<bool> _canInUserPermissions(
      String arrayProperty, String doctype) async {
    if (!_validateBasicPerms()) await loadBasicPerms();

    final doctypeList = basicPerms?.toJson()[arrayProperty] as List<String>?;

    return doctypeList != null ? doctypeList.contains(doctype) : false;
  }

  /// Verifies if basic perms is valid.
  ///
  /// In addition, verifies whether the user to which it was originally loaded is actually the current user.
  bool _validateBasicPerms() {
    if (basicPerms == null || basicPerms!.isLoading!) {
      return false;
    } else if (basicPerms!.user != core.auth.currentUser) {
      config.logger.e('renovation_core: Basic Perm Mismatch');
      basicPerms = null;
      return false;
    }
    return true;
  }
}
