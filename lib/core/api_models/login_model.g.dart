// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginData _$LoginDataFromJson(Map<String, dynamic> json) => LoginData(
      stuId: json['stu_id'] as String,
      stuName: json['stu_name'] as String,
      stuImage: json['stu_image'] as String,
      stuMobile: json['stu_mobile'] as String,
      stuEmail: json['stu_email'] as String?,
      stuCity: json['stu_city'] as String?,
      stuPincode: json['stu_pincode'] as String?,
      stuAddress: json['stu_address'] as String?,
      stuStdId: json['stu_std_id'] as String?,
      stuSubId: json['stu_sub_id'] as String?,
      stuMedId: json['stu_med_id'] as String?,
      stuExmId: json['stu_exm_id'] as String?,
    );

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
      'stu_id': instance.stuId,
      'stu_name': instance.stuName,
      'stu_image': instance.stuImage,
      'stu_mobile': instance.stuMobile,
      'stu_email': instance.stuEmail,
      'stu_city': instance.stuCity,
      'stu_pincode': instance.stuPincode,
      'stu_address': instance.stuAddress,
      'stu_std_id': instance.stuStdId,
      'stu_sub_id': instance.stuSubId,
      'stu_med_id': instance.stuMedId,
      'stu_exm_id': instance.stuExmId,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      status: json['status'] as bool,
      isActive: json['is_active'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : LoginData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'is_active': instance.isActive,
      'message': instance.message,
      'data': instance.data,
    };
