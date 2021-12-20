import 'dart:core';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

import '../auth/auth.controller.dart';
import '../auth/frappe/frappe.auth.controller.dart';
import '../auth/frappe/interfaces.dart';
import '../auth/interfaces.dart';
import '../backend/frappe/frappe.dart';
import '../backend/frappe/frappe.log.manager.dart';
import '../backend/log.manager.dart';
import '../core/errors.dart';
import '../core/frappe/renovation.dart';
import '../defaults/defaults.controller.dart';
import '../defaults/frappe/frappe.defaults.controller.dart';
import '../meta/frappe/frappe.meta.controller.dart';
import '../meta/meta.controller.dart';
import '../misc/message.bus.dart';
import '../misc/socketio.dart';
import '../model/frappe/frappe.model.controller.dart';
import '../model/model.controller.dart';
import '../perm/frappe/frappe.perm.controller.dart';
import '../perm/perm.controller.dart';
import '../storage/frappe/frappe.storage.controller.dart';
import '../storage/storage.controller.dart';
import '../translation/frappe/frappe.translation.controller.dart';
import '../translation/translation.controller.dart';
import 'config.dart';
import 'interfaces.dart';
import 'renovation.controller.dart';
import 'request.dart';

class Renovation {
  //***    Singleton Approach
  factory Renovation() => _renovation;

  Renovation._internal();

  static final Renovation _renovation = Renovation._internal();

  //*************

  /// The `AuthController` instance
  late AuthController auth;

  /// The `ModelController` instance
  late ModelController model;

  /// The `MetaController` instance
  late MetaController meta;

  /// The `MetaController` instance
  late StorageController storage;

  /// The `PermissionController` instance
  late PermissionController perm;

  /// The `DefaultsController` instance
  late DefaultsController defaults;

  /// The `RenovationConfig` instance
  late RenovationConfig config;

  /// The `Frappe` instance
  ///
  /// Only initialized if the backend is `frappe`
  late Frappe frappe;

  /// The `LogManager` instance
  late LogManager log;

  /// The `TranslationController` instance
  late TranslationController translate;

  /// The `SocketIOClient` instance
  late SocketIOClient socketIo;

  /// The `MessageBus` property
  final bus = MessageBus();

  /// Method for calling custom cmds defined in the backend
  Future<RequestResponse<FrappeResponse?>> call(
    Map<String, dynamic> args, {
    Map<String, dynamic> extraHeaders = const <String, dynamic>{},
    bool isFrappeResponse = true,
  }) {
    return Request.initiateRequest(
        url: config.hostUrl,
        method: HttpMethod.POST,
        headers: <String, dynamic>{
          ...RenovationRequestOptions.headers!,
          ...extraHeaders
        },
        contentType: ContentTypeLiterals.APPLICATION_JSON,
        data: args,
        isFrappeResponse: isFrappeResponse);
  }

  /// An observable holding the messages to be used in the front-end
  BehaviorSubject<dynamic> messages = BehaviorSubject<dynamic>.seeded(null);

  /// Initialize the state of the renovation instance
  Future<void> init<K extends SessionStatusInfo>(
    String hostUrl, {
    RenovationBackend backend = RenovationBackend.frappe,
    String? clientId,
    K? sessionStatusInfo,
    bool useJWT = false,
    bool isBenchEnabled = false,
    bool disableLog = false,
    Logger? customLogger,

    /// Cookie JAR options
    String? cookieDir,
    bool persistSession = true,
    bool ignoreExpires = false,
  }) async {
    final logger = customLogger ??
        Logger(
          filter: DebugFilter(disableLog: disableLog),
          printer: PrettyPrinter(colors: true, methodCount: 0),
        );

    final startTime = DateTime.now();
    if (clientId != null) {
      Request.setClientId(clientId);
    }
    config = RenovationConfig(this, backend, hostUrl, logger);
    RenovationConfig.renovationInstance = config;

    socketIo = SocketIOClient(config);

    if (backend == RenovationBackend.frappe) {
      RenovationRequestOptions.headers = <String, String?>{
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest'
      };

      frappe = Frappe(config);
      translate = FrappeTranslationController(config);
      model = FrappeModelController(config);
      meta = FrappeMetaController(config);
      perm = FrappePermissionController(config);
      storage = FrappeStorageController(config);
      defaults = FrappeDefaultsController(config);
      log = FrappeLogManager(config);
      auth = FrappeAuthController(
        config,
        sessionStatusInfo: sessionStatusInfo as FrappeSessionStatusInfo?,
      );

      // Manage sessions using cookies instead of JWT
      if (!useJWT) {
        if (cookieDir != null) {
          Request.setupPersistentCookie(
            PersistCookieJar(
                storage: FileStorage(cookieDir),
                ignoreExpires: ignoreExpires,
                persistSession: persistSession),
          );
        } else {
          throw CookieDirNotSet();
        }
      } else {
        getFrappeAuthController().enableJWT();
      }

//      unawaited(frappe.loadAppVersions());
      // TODO:
      // dashboard = FrappeDashboardController(config);
    }
    if (isBenchEnabled && clientId == null) {
      await frappe.updateClientId();
    }

    logger.v(
        'Renovation Core Took ${DateTime.now().difference(startTime).inMilliseconds.toString()}ms to initialize');
  }

  /// Clears the cache of the renovation controllers. Involved controllers:
  ///
  /// - [FrappeModelController]
  /// - [FrappeMetaController]
  /// - [FrappeAuthController]
  /// - [FrappePermissionController]
  /// - [Frappe]
  void clearCache() {
    for (final renovationController in <RenovationController?>[
      model,
      meta,
      auth,
      perm,
      frappe
    ]) {
      renovationController?.clearCache();
    }
  }
}

class DebugFilter extends LogFilter {
  final bool disableLog;

  DebugFilter({this.disableLog = false});

  @override
  bool shouldLog(LogEvent event) {
    var shouldLog = false;
    if (event.level.index >= level!.index) {
      shouldLog = true;
    }
    return shouldLog && !disableLog;
  }
}
