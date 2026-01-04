// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcq_feedback_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

McqFeedbackResponse _$McqFeedbackResponseFromJson(Map<String, dynamic> json) =>
    McqFeedbackResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      mcqList: (json['mcq_list'] as List<dynamic>)
          .map((e) => McqFeedbackItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$McqFeedbackResponseToJson(
        McqFeedbackResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'mcq_list': instance.mcqList,
    };

McqFeedbackItem _$McqFeedbackItemFromJson(Map<String, dynamic> json) =>
    McqFeedbackItem(
      mcqFdbId: (json['mcq_fdb_id'] as num).toInt(),
      stuId: json['stu_id'] as String,
      mcqId: json['mcq_id'] as String,
    );

Map<String, dynamic> _$McqFeedbackItemToJson(McqFeedbackItem instance) =>
    <String, dynamic>{
      'mcq_fdb_id': instance.mcqFdbId,
      'stu_id': instance.stuId,
      'mcq_id': instance.mcqId,
    };
