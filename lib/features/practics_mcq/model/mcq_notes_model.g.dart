// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcq_notes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

McqNotesResponse _$McqNotesResponseFromJson(Map<String, dynamic> json) =>
    McqNotesResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      mcqList: (json['mcq_list'] as List<dynamic>)
          .map((e) => McqNotesItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$McqNotesResponseToJson(McqNotesResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'mcq_list': instance.mcqList,
    };

McqNotesItem _$McqNotesItemFromJson(Map<String, dynamic> json) => McqNotesItem(
      mcqNtsId: (json['mcq_nts_id'] as num).toInt(),
      stuId: json['stu_id'] as String,
      mcqId: json['mcq_id'] as String,
    );

Map<String, dynamic> _$McqNotesItemToJson(McqNotesItem instance) =>
    <String, dynamic>{
      'mcq_nts_id': instance.mcqNtsId,
      'stu_id': instance.stuId,
      'mcq_id': instance.mcqId,
    };
