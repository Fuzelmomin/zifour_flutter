// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_challenge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateChallengeResponse _$CreateChallengeResponseFromJson(
        Map<String, dynamic> json) =>
    CreateChallengeResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      topicList: (json['topic_list'] as List<dynamic>)
          .map((e) => CreatedChallengeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreateChallengeResponseToJson(
        CreateChallengeResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'topic_list': instance.topicList,
    };

CreatedChallengeItem _$CreatedChallengeItemFromJson(
        Map<String, dynamic> json) =>
    CreatedChallengeItem(
      crtChlId: (json['crt_chl_id'] as num).toInt(),
      stuId: json['stu_id'] as String,
      name: json['name'] as String,
      chapter: json['chapter'] as String,
      topic: json['topic'] as String,
      subjects: json['subjects'] as String,
    );

Map<String, dynamic> _$CreatedChallengeItemToJson(
        CreatedChallengeItem instance) =>
    <String, dynamic>{
      'crt_chl_id': instance.crtChlId,
      'stu_id': instance.stuId,
      'name': instance.name,
      'chapter': instance.chapter,
      'topic': instance.topic,
      'subjects': instance.subjects,
    };
