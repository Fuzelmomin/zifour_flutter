// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mentor_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MentorCategoryResponse _$MentorCategoryResponseFromJson(
        Map<String, dynamic> json) =>
    MentorCategoryResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      mentorCategoryList: (json['mentor_category_list'] as List<dynamic>)
          .map((e) => MentorCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MentorCategoryResponseToJson(
        MentorCategoryResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'mentor_category_list': instance.mentorCategoryList,
    };

MentorCategoryModel _$MentorCategoryModelFromJson(Map<String, dynamic> json) =>
    MentorCategoryModel(
      mcatId: json['mcat_id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$MentorCategoryModelToJson(
        MentorCategoryModel instance) =>
    <String, dynamic>{
      'mcat_id': instance.mcatId,
      'name': instance.name,
    };
