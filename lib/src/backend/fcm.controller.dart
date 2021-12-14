import '../core/request.dart';
import 'frappe/fcm_notification.model.dart';

abstract class FCMController {
  /// Used to register client FCM token
  ///
  /// Takes the unique token from firebase messaging used to register.
  Future<RequestResponse<dynamic>> registerFCMToken(String token);

  /// Used to unregister fcm token for logging out users.
  Future<RequestResponse<dynamic>> unregisterFCMToken(String token);

  /// Used to get FCM Notifications.
  Future<RequestResponse<List<FCMNotification>?>> getFCMNotifications(
      {bool? seen});

  /// Used to mark FCM Notification as read
  Future<RequestResponse<dynamic>> markFCMNotificationsAsSeen(String messageId);
}
