// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcq_bookmark_delete_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

McqBookmarkDeleteResponse _$McqBookmarkDeleteResponseFromJson(
        Map<String, dynamic> json) =>
    McqBookmarkDeleteResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      mcqList: (json['mcq_list'] as List<dynamic>)
          .map((e) => McqBookmarkDeleteItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$McqBookmarkDeleteResponseToJson(
        McqBookmarkDeleteResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'mcq_list': instance.mcqList,
    };

McqBookmarkDeleteItem _$McqBookmarkDeleteItemFromJson(
        Map<String, dynamic> json) =>
    McqBookmarkDeleteItem(
      stuId: json['stu_id'] as String,
      mcqId: json['mcq_id'] as String,
    );

Map<String, dynamic> _$McqBookmarkDeleteItemToJson(
        McqBookmarkDeleteItem instance) =>
    <String, dynamic>{
      'stu_id': instance.stuId,
      'mcq_id': instance.mcqId,
    };
