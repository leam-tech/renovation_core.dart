import '../../auth/frappe/frappe.auth.controller.dart';
import '../../backend/frappe/frappe.dart';
import '../../backend/frappe/frappe.log.manager.dart';
import '../../defaults/frappe/frappe.defaults.controller.dart';
import '../../meta/frappe/frappe.meta.controller.dart';
import '../../model/frappe/frappe.model.controller.dart';
import '../../perm/frappe/frappe.perm.controller.dart';
import '../../storage/frappe/frappe.storage.controller.dart';
import '../../translation/frappe/frappe.translation.controller.dart';
import '../renovation.dart';

/// Methods to get instances of Frappé controllers
/// for better code assistance
FrappeModelController getFrappeModelController() =>
    Renovation()?.model as FrappeModelController;

FrappeStorageController getFrappeStorageController() =>
    Renovation()?.storage as FrappeStorageController;

FrappeAuthController getFrappeAuthController() =>
    Renovation()?.auth as FrappeAuthController;

FrappeMetaController getFrappeMetaController() =>
    Renovation()?.meta as FrappeMetaController;

FrappePermissionController getFrappePermissionController() =>
    Renovation()?.perm as FrappePermissionController;

FrappeTranslationController getFrappeTranslationController() =>
    Renovation()?.translate as FrappeTranslationController;

FrappeDefaultsController getFrappeDefaultsController() =>
    Renovation()?.defaults as FrappeDefaultsController;

FrappeLogManager getFrappeLogManager() => Renovation()?.log as FrappeLogManager;

Frappe getFrappe() => Renovation()?.frappe;
