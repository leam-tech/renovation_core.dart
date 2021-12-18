// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_notification.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FCMNotification _$FCMNotificationFromJson(Map<String, dynamic> json) =>
    FCMNotification()
      ..notification = json['notification'] == null
          ? null
          : NotificationMessage.fromJson(
              json['notification'] as Map<String, dynamic>?)
      ..data = json['data'] as Map<String, dynamic>?
      ..title = json['title'] as String?
      ..body = json['body'] as String?
      ..messageId = json['message_id'] as String?
      ..seen = FrappeDocFieldConverter.checkToBool(json['seen'] as int?)
      ..communicationDate = json['communication_date'] as String?
      ..rawNotification = json['rawNotification'] as Map<String, dynamic>?;

Map<String, dynamic> _$FCMNotificationToJson(FCMNotification instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('notification', instance.notification?.toJson());
  writeNotNull('data', instance.data);
  writeNotNull('title', instance.title);
  writeNotNull('body', instance.body);
  writeNotNull('message_id', instance.messageId);
  writeNotNull('seen', FrappeDocFieldConverter.boolToCheck(instance.seen));
  writeNotNull('communication_date', instance.communicationDate);
  writeNotNull('rawNotification', instance.rawNotification);
  return val;
}

NotificationMessage _$NotificationMessageFromJson(Map<String, dynamic> json) =>
    NotificationMessage()
      ..title = json['title'] as String?
      ..body = json['body'] as String?;

Map<String, dynamic> _$NotificationMessageToJson(NotificationMessage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('body', instance.body);
  return val;
}
