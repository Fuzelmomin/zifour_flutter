// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubjectResponse _$SubjectResponseFromJson(Map<String, dynamic> json) =>
    SubjectResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      subjectList: (json['subject_list'] as List<dynamic>)
          .map((e) => SubjectModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubjectResponseToJson(SubjectResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'subject_list': instance.subjectList,
    };

SubjectModel _$SubjectModelFromJson(Map<String, dynamic> json) => SubjectModel(
      subId: json['sub_id'] as String,
      name: json['name'] as String,

      totalChapter: json['total_chapter'] as String,
      totalLectures: json['total_lectures'] as String,
    );

Map<String, dynamic> _$SubjectModelToJson(SubjectModel instance) =>
    <String, dynamic>{
      'sub_id': instance.subId,
      'name': instance.name,
      'total_chapter': instance.totalChapter,
      'total_lectures': instance.totalLectures,
    };
