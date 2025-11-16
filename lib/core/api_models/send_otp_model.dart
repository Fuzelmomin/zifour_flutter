import 'package:json_annotation/json_annotation.dart';

part 'send_otp_model.g.dart';

@JsonSerializable()
class SendOtpResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'stu_verification')
  final String? stuVerification;
  @JsonKey(name: 'stu_mobile')
  final String? stuMobile;

  SendOtpResponse({
    required this.status,
    required this.message,
    this.stuVerification,
    this.stuMobile,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$SendOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpResponseToJson(this);
}

