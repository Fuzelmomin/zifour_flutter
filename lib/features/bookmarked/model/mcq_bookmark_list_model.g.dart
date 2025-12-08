// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcq_bookmark_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

McqBookmarkListResponse _$McqBookmarkListResponseFromJson(
        Map<String, dynamic> json) =>
    McqBookmarkListResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      mcqBookmarkList: (json['mcq_bookmark_list'] as List<dynamic>)
          .map((e) => McqBookmarkListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$McqBookmarkListResponseToJson(
        McqBookmarkListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'mcq_bookmark_list': instance.mcqBookmarkList,
    };

McqBookmarkListItem _$McqBookmarkListItemFromJson(Map<String, dynamic> json) =>
    McqBookmarkListItem(
      mcqBkmId: json['mcq_bkm_id'] as String,
      mcqId: json['mcq_id'] as String,
      mcQuestion: json['mc_question'] as String,
      mcDescription: json['mc_description'] as String,
    );

Map<String, dynamic> _$McqBookmarkListItemToJson(
        McqBookmarkListItem instance) =>
    <String, dynamic>{
      'mcq_bkm_id': instance.mcqBkmId,
      'mcq_id': instance.mcqId,
      'mc_question': instance.mcQuestion,
      'mc_description': instance.mcDescription,
    };
