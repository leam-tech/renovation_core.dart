import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

import '../../core/jsonable.dart';
import '../../model/frappe/document.dart';
import '../../model/frappe/utils.dart';
import '../interfaces.dart';

part 'interfaces.g.dart';

@JsonSerializable()
class SendOTPResponse extends JSONAble {
  SendOTPResponse(this.status, this.mobile);

  factory SendOTPResponse.fromJson(Map<String, dynamic> json) =>
      _$SendOTPResponseFromJson(json);

  String status = 'success';
  String mobile;

  @override
  Map<String, dynamic> toJson() => _$SendOTPResponseToJson(this);

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      SendOTPResponse.fromJson(json) as T;
}

@JsonSerializable()
class VerifyOTPResponse extends JSONAble {
  VerifyOTPResponse(this.status, this.mobile);

  factory VerifyOTPResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOTPResponseFromJson(json);

  String status;
  String mobile;

  @override
  Map<String, dynamic> toJson() => _$VerifyOTPResponseToJson(this);

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      VerifyOTPResponse.fromJson(json) as T;
}

@JsonSerializable()
class FrappeSessionStatusInfo extends SessionStatusInfo {
  FrappeSessionStatusInfo(bool loggedIn, double timestamp, {String currentUser})
      : super(loggedIn, timestamp, currentUser: currentUser);

  factory FrappeSessionStatusInfo.fromJson(Map<String, dynamic> json) =>
      _$FrappeSessionStatusInfoFromJson(json);

  @JsonKey(name: 'home_page')
  String homePage;

  String message;

  String user;

  String token;

  String lang;

  String mobile;

  String customer;

  String employee;

  @JsonKey(name: 'full_name')
  String fullName;

  @JsonKey(name: 'has_quick_login_pin')
  bool hasQuickPinLogin;

  @override
  T fromJson<T>(Map<String, dynamic> json) =>
      FrappeSessionStatusInfo.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$FrappeSessionStatusInfoToJson(this);
}

@JsonSerializable()
class User extends FrappeDocument {
  User() : super('User');

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  int enabled;
  String email;

  @JsonKey(name: 'first_name')
  String firstName;

  @JsonKey(name: 'middle_name')
  String middleName;

  @JsonKey(name: 'last_name')
  String lastName;

  @JsonKey(name: 'full_name')
  String fullName;

  String username;
  String language;
  String gender;
  String phone;

  @JsonKey(name: 'mobile_no')
  String mobileNo;

  @JsonKey(name: 'last_login')
  DateTime lastLogin;

  @JsonKey(name: 'user_image')
  String userImage;

  @JsonKey(name: 'block_modules')
  List<BlockModule> blockModules;

  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  T fromJson<T>(Map<String, dynamic> json) => User.fromJson(json) as T;
}

@JsonSerializable()
class BlockModule extends FrappeDocument {
  BlockModule() : super('Block Module');

  factory BlockModule.fromJson(Map<String, dynamic> json) =>
      _$BlockModuleFromJson(json);

  @JsonKey(name: 'module')
  String module;

  @override
  T fromJson<T>(Map<String, dynamic> json) => BlockModule.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$BlockModuleToJson(this);
}
