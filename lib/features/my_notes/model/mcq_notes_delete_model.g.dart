// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcq_notes_delete_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

McqNotesDeleteResponse _$McqNotesDeleteResponseFromJson(
        Map<String, dynamic> json) =>
    McqNotesDeleteResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      mcqList: (json['mcq_list'] as List<dynamic>)
          .map((e) => McqNotesDeleteItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$McqNotesDeleteResponseToJson(
        McqNotesDeleteResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'mcq_list': instance.mcqList,
    };

McqNotesDeleteItem _$McqNotesDeleteItemFromJson(Map<String, dynamic> json) =>
    McqNotesDeleteItem(
      stuId: json['stu_id'] as String,
      mcqId: json['mcq_id'] as String,
    );

Map<String, dynamic> _$McqNotesDeleteItemToJson(McqNotesDeleteItem instance) =>
    <String, dynamic>{
      'stu_id': instance.stuId,
      'mcq_id': instance.mcqId,
    };
