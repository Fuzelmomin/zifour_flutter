// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_photo_update_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfilePhotoUpdateResponse _$ProfilePhotoUpdateResponseFromJson(
        Map<String, dynamic> json) =>
    ProfilePhotoUpdateResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      stuImage: json['stu_image'] as String?,
    );

Map<String, dynamic> _$ProfilePhotoUpdateResponseToJson(
        ProfilePhotoUpdateResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'stu_image': instance.stuImage,
    };
