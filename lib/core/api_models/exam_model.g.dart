// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamResponse _$ExamResponseFromJson(Map<String, dynamic> json) => ExamResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      examList: (json['exam_list'] as List<dynamic>)
          .map((e) => ExamModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExamResponseToJson(ExamResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'exam_list': instance.examList,
    };

ExamModel _$ExamModelFromJson(Map<String, dynamic> json) => ExamModel(
      exmId: json['exm_id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ExamModelToJson(ExamModel instance) => <String, dynamic>{
      'exm_id': instance.exmId,
      'name': instance.name,
    };
