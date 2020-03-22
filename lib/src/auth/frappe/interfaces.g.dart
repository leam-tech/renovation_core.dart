// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interfaces.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendOTPResponse _$SendOTPResponseFromJson(Map<String, dynamic> json) {
  return SendOTPResponse(
    json['status'] as String,
    json['mobile'] as String,
  );
}

Map<String, dynamic> _$SendOTPResponseToJson(SendOTPResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('status', instance.status);
  writeNotNull('mobile', instance.mobile);
  return val;
}

VerifyOTPResponse _$VerifyOTPResponseFromJson(Map<String, dynamic> json) {
  return VerifyOTPResponse(
    json['status'] as String,
    json['mobile'] as String,
  );
}

Map<String, dynamic> _$VerifyOTPResponseToJson(VerifyOTPResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('status', instance.status);
  writeNotNull('mobile', instance.mobile);
  return val;
}

FrappeSessionStatusInfo _$FrappeSessionStatusInfoFromJson(
    Map<String, dynamic> json) {
  return FrappeSessionStatusInfo(
    json['loggedIn'] as bool,
    (json['timestamp'] as num)?.toDouble(),
    currentUser: json['currentUser'] as String,
  )
    ..rawSession = json['rawSession'] as Map<String, dynamic>
    ..homePage = json['home_page'] as String
    ..message = json['message'] as String
    ..user = json['user'] as String
    ..token = json['token'] as String
    ..lang = json['lang'] as String
    ..mobile = json['mobile'] as String
    ..customer = json['customer'] as String
    ..employee = json['employee'] as String
    ..fullName = json['full_name'] as String
    ..hasQuickPinLogin = json['has_quick_login_pin'] as bool;
}

Map<String, dynamic> _$FrappeSessionStatusInfoToJson(
    FrappeSessionStatusInfo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('loggedIn', instance.loggedIn);
  writeNotNull('timestamp', instance.timestamp);
  writeNotNull('currentUser', instance.currentUser);
  writeNotNull('rawSession', instance.rawSession);
  writeNotNull('home_page', instance.homePage);
  writeNotNull('message', instance.message);
  writeNotNull('user', instance.user);
  writeNotNull('token', instance.token);
  writeNotNull('lang', instance.lang);
  writeNotNull('mobile', instance.mobile);
  writeNotNull('customer', instance.customer);
  writeNotNull('employee', instance.employee);
  writeNotNull('full_name', instance.fullName);
  writeNotNull('has_quick_login_pin', instance.hasQuickPinLogin);
  return val;
}

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..doctype = json['doctype'] as String
    ..name = json['name'] as String
    ..owner = json['owner'] as String
    ..docStatus =
        FrappeDocFieldConverter.intToFrappeDocStatus(json['docstatus'] as int)
    ..isLocal = FrappeDocFieldConverter.checkToBool(json['__islocal'] as int)
    ..unsaved = FrappeDocFieldConverter.checkToBool(json['__unsaved'] as int)
    ..amendedFrom = json['amended_from'] as String
    ..idx = FrappeDocFieldConverter.idxFromString(json['idx'])
    ..parent = json['parent'] as String
    ..parentType = json['parenttype'] as String
    ..creation = json['creation'] == null
        ? null
        : DateTime.parse(json['creation'] as String)
    ..parentField = json['parentfield'] as String
    ..modified = json['modified'] == null
        ? null
        : DateTime.parse(json['modified'] as String)
    ..modifiedBy = json['modified_by'] as String
    ..enabled = json['enabled'] as int
    ..email = json['email'] as String
    ..firstName = json['first_name'] as String
    ..middleName = json['middle_name'] as String
    ..lastName = json['last_name'] as String
    ..fullName = json['full_name'] as String
    ..username = json['username'] as String
    ..language = json['language'] as String
    ..gender = json['gender'] as String
    ..phone = json['phone'] as String
    ..mobileNo = json['mobile_no'] as String
    ..lastLogin = json['last_login'] == null
        ? null
        : DateTime.parse(json['last_login'] as String)
    ..userImage = json['user_image'] as String;
}

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('doctype', instance.doctype);
  writeNotNull('name', instance.name);
  writeNotNull('owner', instance.owner);
  writeNotNull('docstatus',
      FrappeDocFieldConverter.frappeDocStatusToInt(instance.docStatus));
  writeNotNull(
      '__islocal', FrappeDocFieldConverter.boolToCheck(instance.isLocal));
  writeNotNull(
      '__unsaved', FrappeDocFieldConverter.boolToCheck(instance.unsaved));
  writeNotNull('amended_from', instance.amendedFrom);
  writeNotNull('idx', instance.idx);
  writeNotNull('parent', instance.parent);
  writeNotNull('parenttype', instance.parentType);
  writeNotNull(
      'creation', FrappeDocFieldConverter.toFrappeDateTime(instance.creation));
  writeNotNull('parentfield', instance.parentField);
  writeNotNull(
      'modified', FrappeDocFieldConverter.toFrappeDateTime(instance.modified));
  writeNotNull('modified_by', instance.modifiedBy);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('email', instance.email);
  writeNotNull('first_name', instance.firstName);
  writeNotNull('middle_name', instance.middleName);
  writeNotNull('last_name', instance.lastName);
  writeNotNull('full_name', instance.fullName);
  writeNotNull('username', instance.username);
  writeNotNull('language', instance.language);
  writeNotNull('gender', instance.gender);
  writeNotNull('phone', instance.phone);
  writeNotNull('mobile_no', instance.mobileNo);
  writeNotNull('last_login', instance.lastLogin?.toIso8601String());
  writeNotNull('user_image', instance.userImage);
  return val;
}
