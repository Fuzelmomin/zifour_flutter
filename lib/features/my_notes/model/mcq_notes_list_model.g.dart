// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcq_notes_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

McqNotesListResponse _$McqNotesListResponseFromJson(
        Map<String, dynamic> json) =>
    McqNotesListResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      mcqNotesList: (json['mcq_notes_list'] as List<dynamic>)
          .map((e) => McqNotesListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$McqNotesListResponseToJson(
        McqNotesListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'mcq_notes_list': instance.mcqNotesList,
    };

McqNotesListItem _$McqNotesListItemFromJson(Map<String, dynamic> json) =>
    McqNotesListItem(
      mcqNtsId: json['mcq_nts_id'] as String,
      mcqId: json['mcq_id'] as String,
      mcQuestion: json['mc_question'] as String,
      mcDescription: json['mc_description'] as String,
      mcqNotesTitle: json['mcq_notes_title'] as String,
      mcqNotesDescription: json['mcq_notes_description'] as String,
          type: json['type'] as String,
    );

Map<String, dynamic> _$McqNotesListItemToJson(McqNotesListItem instance) =>
    <String, dynamic>{
      'mcq_nts_id': instance.mcqNtsId,
      'mcq_id': instance.mcqId,
      'mc_question': instance.mcQuestion,
      'mc_description': instance.mcDescription,
      'mcq_notes_title': instance.mcqNotesTitle,
      'mcq_notes_description': instance.mcqNotesDescription,
      'type': instance.type,
    };
