import 'package:json_annotation/json_annotation.dart';

import '../../core/jsonable.dart';
import '../../model/frappe/utils.dart';

part 'fcm_notification.model.g.dart';

@JsonSerializable()
class FCMNotification extends JSONAble {
  FCMNotification();

  factory FCMNotification.fromJson(Map<String, dynamic>? json) {
    json!['notification'] = json['notification']?.cast<String, dynamic>();
    json['data'] = json['data'] != null
        ? json['data'].cast<String, dynamic>()
        // Handle iOS Notifications where it doesn't contain data object (All are in one Map)
        : json.cast<String, dynamic>();
    return _$FCMNotificationFromJson(json);
  }

  NotificationMessage? notification;

  Map<String, dynamic>? data;

  String? title;
  String? body;

  @JsonKey(name: 'message_id')
  String? messageId;

  @JsonKey(
      fromJson: FrappeDocFieldConverter.checkToBool,
      toJson: FrappeDocFieldConverter.boolToCheck)
  bool? seen;

  @JsonKey(name: 'communication_date')
  String? communicationDate;

  // Useful for iOS where it appends the fields within data and omits data key
  Map<String, dynamic>? rawNotification;

  @override
  Map<String, dynamic> toJson() => _$FCMNotificationToJson(this);

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      FCMNotification.fromJson(json) as T;
}

/// Represents the notification map within the FCM Notification object
/// Only contains body & title (Android)
/// In iOS, the data will be appended to this object (Use rawNotification) to access the fields
@JsonSerializable()
class NotificationMessage extends JSONAble {
  NotificationMessage();

  factory NotificationMessage.fromJson(Map<String, dynamic>? json) =>
      _$NotificationMessageFromJson(json!);

  String? title;
  String? body;

  @override
  Map<String, dynamic> toJson() => _$NotificationMessageToJson(this);

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      NotificationMessage.fromJson(json) as T;
}
