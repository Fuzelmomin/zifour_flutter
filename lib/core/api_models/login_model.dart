import 'package:json_annotation/json_annotation.dart';

part 'login_model.g.dart';

@JsonSerializable()
class LoginData {
  @JsonKey(name: 'stu_id')
  final String stuId;
  @JsonKey(name: 'stu_name')
  final String stuName;
  @JsonKey(name: 'stu_image')
  final String stuImage;
  @JsonKey(name: 'stu_mobile')
  final String stuMobile;
  @JsonKey(name: 'stu_email')
  final String stuEmail;
  @JsonKey(name: 'stu_city')
  final String stuCity;
  @JsonKey(name: 'stu_pincode')
  final String stuPincode;
  @JsonKey(name: 'stu_address')
  final String stuAddress;
  @JsonKey(name: 'stu_std_id')
  final String? stuStdId;
  @JsonKey(name: 'stu_sub_id')
  final String? stuSubId;
  @JsonKey(name: 'stu_med_id')
  final String? stuMedId;
  @JsonKey(name: 'stu_exm_id')
  final String? stuExmId;

  LoginData({
    required this.stuId,
    required this.stuName,
    required this.stuImage,
    required this.stuMobile,
    required this.stuEmail,
    required this.stuCity,
    required this.stuPincode,
    required this.stuAddress,
    this.stuStdId,
    this.stuSubId,
    this.stuMedId,
    this.stuExmId,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final bool status;
  @JsonKey(name: 'is_active')
  final bool isActive;
  final String message;
  final LoginData? data;

  LoginResponse({
    required this.status,
    required this.isActive,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

