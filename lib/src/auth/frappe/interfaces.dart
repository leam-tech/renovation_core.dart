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

  factory SendOTPResponse.fromJson(Map<String, dynamic>? json) =>
      _$SendOTPResponseFromJson(json!);

  String? status = 'success';
  String? mobile;

  @override
  Map<String, dynamic> toJson() => _$SendOTPResponseToJson(this);

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      SendOTPResponse.fromJson(json) as T;
}

@JsonSerializable()
class VerifyOTPResponse extends JSONAble {
  VerifyOTPResponse(this.status, this.mobile);

  factory VerifyOTPResponse.fromJson(Map<String, dynamic>? json) =>
      _$VerifyOTPResponseFromJson(json!);

  String? status;
  String? mobile;

  @override
  Map<String, dynamic> toJson() => _$VerifyOTPResponseToJson(this);

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      VerifyOTPResponse.fromJson(json) as T;
}

@JsonSerializable()
class FrappeSessionStatusInfo extends SessionStatusInfo {
  FrappeSessionStatusInfo(bool? loggedIn, double? timestamp, {String? currentUser})
      : super(loggedIn, timestamp, currentUser: currentUser);

  factory FrappeSessionStatusInfo.fromJson(Map<String, dynamic>? json) =>
      _$FrappeSessionStatusInfoFromJson(json!);

  @JsonKey(name: 'home_page')
  String? homePage;

  String? message;

  String? user;

  String? token;

  String? lang;

  String? mobile;

  String? customer;

  String? employee;

  @JsonKey(name: 'full_name')
  String? fullName;

  @JsonKey(name: 'has_quick_login_pin')
  bool? hasQuickPinLogin;

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      FrappeSessionStatusInfo.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$FrappeSessionStatusInfoToJson(this);
}

@JsonSerializable()
class User extends FrappeDocument {
  User() : super('User');

  factory User.fromJson(Map<String, dynamic>? json) => _$UserFromJson(json!);

  int? enabled;
  String? email;

  @JsonKey(name: 'first_name')
  String? firstName;

  @JsonKey(name: 'middle_name')
  String? middleName;

  @JsonKey(name: 'last_name')
  String? lastName;

  @JsonKey(name: 'full_name')
  String? fullName;

  String? username;
  String? language;
  String? gender;
  String? phone;

  @JsonKey(name: 'mobile_no')
  String? mobileNo;

  @JsonKey(name: 'last_login')
  DateTime? lastLogin;

  @JsonKey(name: 'user_image')
  String? userImage;

  @JsonKey(name: 'block_modules')
  List<BlockModule>? blockModules;

  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  T fromJson<T>(Map<String, dynamic>? json) => User.fromJson(json) as T;
}

@JsonSerializable()
class BlockModule extends FrappeDocument {
  BlockModule() : super('Block Module');

  factory BlockModule.fromJson(Map<String, dynamic>? json) =>
      _$BlockModuleFromJson(json!);

  @JsonKey(name: 'module')
  String? module;

  @override
  T fromJson<T>(Map<String, dynamic>? json) => BlockModule.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$BlockModuleToJson(this);
}

@JsonSerializable()
class ResetPasswordInfo extends JSONAble {
  ResetPasswordInfo();

  factory ResetPasswordInfo.fromJson(Map<String, dynamic>? json) =>
      _$ResetPasswordInfoFromJson(json!);

  @JsonKey(name: 'has_medium', fromJson: FrappeDocFieldConverter.checkToBool)
  bool? hasMedium;

  List<String>? medium;

  ResetInfoHint? hints;

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      ResetPasswordInfo.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$ResetPasswordInfoToJson(this);
}

@JsonSerializable()
class ResetInfoHint extends JSONAble {
  ResetInfoHint();

  factory ResetInfoHint.fromJson(Map<String, dynamic>? json) =>
      _$ResetInfoHintFromJson(json!);

  String? email;

  String? sms;

  @override
  T fromJson<T>(Map<String, dynamic>? json) => ResetInfoHint.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$ResetInfoHintToJson(this);
}

@JsonSerializable()
class GenerateResetOTPResponse extends JSONAble {
  GenerateResetOTPResponse();

  factory GenerateResetOTPResponse.fromJson(Map<String, dynamic>? json) =>
      _$GenerateResetOTPResponseFromJson(json!);

  @JsonKey(fromJson: FrappeDocFieldConverter.checkToBool)
  bool? sent;

  String? reason;

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      GenerateResetOTPResponse.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$GenerateResetOTPResponseToJson(this);
}

@JsonSerializable()
class VerifyResetOTPResponse extends JSONAble {
  VerifyResetOTPResponse();

  factory VerifyResetOTPResponse.fromJson(Map<String, dynamic>? json) =>
      _$VerifyResetOTPResponseFromJson(json!);

  @JsonKey(fromJson: FrappeDocFieldConverter.checkToBool)
  bool? verified;

  @JsonKey(name: 'reset_token')
  String? resetToken;

  String? reason;

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      VerifyResetOTPResponse.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$VerifyResetOTPResponseToJson(this);
}

@JsonSerializable()
class UpdatePasswordResponse extends JSONAble {
  UpdatePasswordResponse();

  factory UpdatePasswordResponse.fromJson(Map<String, dynamic>? json) =>
      _$UpdatePasswordResponseFromJson(json!);

  @JsonKey(fromJson: FrappeDocFieldConverter.checkToBool)
  bool? updated;

  String? reason;

  @override
  T fromJson<T>(Map<String, dynamic>? json) =>
      UpdatePasswordResponse.fromJson(json) as T;

  @override
  Map<String, dynamic> toJson() => _$UpdatePasswordResponseToJson(this);
}

enum RESET_ID_TYPE { mobile, email }
enum OTP_MEDIUM { email, sms }
enum APPLE_OPTION {
  /// When the login is from iOS or macOS.
  native,

  /// When the login is through web platform
  web,

  /// When the login is through Android platform.
  android
}
