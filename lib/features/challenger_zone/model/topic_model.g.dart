// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicResponse _$TopicResponseFromJson(Map<String, dynamic> json) =>
    TopicResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      topicList: (json['topic_list'] as List<dynamic>)
          .map((e) => TopicModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TopicResponseToJson(TopicResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'topic_list': instance.topicList,
    };

TopicModel _$TopicModelFromJson(Map<String, dynamic> json) => TopicModel(
      tpcId: json['tpc_id'] as String?,
      letpId: json['letp_id'] as String?,
      name: json['name'] as String,
      chapter: json['chapter'] as String,
    );

Map<String, dynamic> _$TopicModelToJson(TopicModel instance) =>
    <String, dynamic>{
      'tpc_id': instance.tpcId,
      'letp_id': instance.tpcId,
      'name': instance.name,
      'chapter': instance.chapter,
    };
