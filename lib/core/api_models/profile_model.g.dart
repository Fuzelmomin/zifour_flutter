// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => ProfileData(
      stuId: json['stu_id'] as String? ?? '',
      stuImage: json['stu_image'] as String?,
      stuSince: json['stu_since'] as String?,
      stuName: json['stu_name'] as String? ?? '',
      stuMobile: json['stu_mobile'] as String? ?? '',
      stuEmail: json['stu_email'] as String?,
      stuGender: (json['stu_gender'] as num?)?.toInt() ?? 1,
      stuDocument: json['stu_document'] as String?,
      stuCity: json['stu_city'] as String?,
      stuPincode: json['stu_pincode'] as String?,
      stuAddress: json['stu_address'] as String?,
      stuStdId: json['stu_std_id'] as String? ?? '',
      stuExmId: json['stu_exm_id'] as String? ?? '',
      stuMedId: json['stu_med_id'] as String? ?? '0',
    );

Map<String, dynamic> _$ProfileDataToJson(ProfileData instance) =>
    <String, dynamic>{
      'stu_id': instance.stuId,
      'stu_image': instance.stuImage,
      'stu_since': instance.stuSince,
      'stu_name': instance.stuName,
      'stu_mobile': instance.stuMobile,
      'stu_email': instance.stuEmail,
      'stu_gender': instance.stuGender,
      'stu_document': instance.stuDocument,
      'stu_city': instance.stuCity,
      'stu_pincode': instance.stuPincode,
      'stu_address': instance.stuAddress,
      'stu_std_id': instance.stuStdId,
      'stu_exm_id': instance.stuExmId,
      'stu_med_id': instance.stuMedId,
    };

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : ProfileData.fromJson(json['data'] as Map<String, dynamic>),
      standardList: (json['standard_list'] as List<dynamic>?)
          ?.map((e) => NewStandardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      examList: (json['exam_list'] as List<dynamic>?)
          ?.map((e) => NewExamModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      mediumList: (json['medium_list'] as List<dynamic>?)
          ?.map((e) => NewMediumModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'standard_list': instance.standardList,
      'exam_list': instance.examList,
      'medium_list': instance.mediumList,
    };

UpdateProfileResponse _$UpdateProfileResponseFromJson(
        Map<String, dynamic> json) =>
    UpdateProfileResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$UpdateProfileResponseToJson(
        UpdateProfileResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };

NewMediumModel _$NewMediumModelFromJson(Map<String, dynamic> json) =>
    NewMediumModel(
      medId: json['med_id'] as String,
      medName: json['med_name'] as String,
    );

Map<String, dynamic> _$NewMediumModelToJson(NewMediumModel instance) =>
    <String, dynamic>{
      'med_id': instance.medId,
      'med_name': instance.medName,
    };
