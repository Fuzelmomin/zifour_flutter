// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterResponse _$ChapterResponseFromJson(Map<String, dynamic> json) =>
    ChapterResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      chapterList: (json['chapter_list'] as List<dynamic>)
          .map((e) => ChapterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChapterResponseToJson(ChapterResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'chapter_list': instance.chapterList,
    };

ChapterModel _$ChapterModelFromJson(Map<String, dynamic> json) => ChapterModel(
      chpId: json['chp_id'] as String,
      name: json['name'] as String,
      standard: json['standard'] as String,
      medium: json['medium'] as String,
      exam: json['exam'] as String,
      subId: json['sub_id']?.toString(),
    );

Map<String, dynamic> _$ChapterModelToJson(ChapterModel instance) =>
    <String, dynamic>{
      'chp_id': instance.chpId,
      'name': instance.name,
      'standard': instance.standard,
      'medium': instance.medium,
      'exam': instance.exam,
      'sub_id': instance.subId,
    };
