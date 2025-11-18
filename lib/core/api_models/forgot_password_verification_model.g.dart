// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_verification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgotPasswordVerificationResponse _$ForgotPasswordVerificationResponseFromJson(
        Map<String, dynamic> json) =>
    ForgotPasswordVerificationResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$ForgotPasswordVerificationResponseToJson(
        ForgotPasswordVerificationResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
