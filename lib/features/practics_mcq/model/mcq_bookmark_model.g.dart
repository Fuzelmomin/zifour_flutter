// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcq_bookmark_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

McqBookmarkResponse _$McqBookmarkResponseFromJson(Map<String, dynamic> json) =>
    McqBookmarkResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      mcqList: (json['mcq_list'] as List<dynamic>)
          .map((e) => McqBookmarkItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$McqBookmarkResponseToJson(
        McqBookmarkResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'mcq_list': instance.mcqList,
    };

McqBookmarkItem _$McqBookmarkItemFromJson(Map<String, dynamic> json) =>
    McqBookmarkItem(
      mcqBkmId: (json['mcq_bkm_id'] as num).toInt(),
      stuId: json['stu_id'] as String,
      mcqId: json['mcq_id'] as String,
    );

Map<String, dynamic> _$McqBookmarkItemToJson(McqBookmarkItem instance) =>
    <String, dynamic>{
      'mcq_bkm_id': instance.mcqBkmId,
      'stu_id': instance.stuId,
      'mcq_id': instance.mcqId,
    };
