import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_verification_model.g.dart';

@JsonSerializable()
class ForgotPasswordVerificationResponse {
  final bool status;
  final String message;

  ForgotPasswordVerificationResponse({
    required this.status,
    required this.message,
  });

  factory ForgotPasswordVerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordVerificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordVerificationResponseToJson(this);
}

