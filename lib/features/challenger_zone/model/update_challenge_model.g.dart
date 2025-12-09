// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_challenge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateChallengeResponse _$UpdateChallengeResponseFromJson(
        Map<String, dynamic> json) =>
    UpdateChallengeResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      challengeDetail: ChallengeDetail.fromJson(
          json['updated_challenge'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateChallengeResponseToJson(
        UpdateChallengeResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'updated_challenge': instance.challengeDetail,
    };

ChallengeDetail _$ChallengeDetailFromJson(Map<String, dynamic> json) =>
    ChallengeDetail(
      crtChlId: json['crt_chl_id'] as String,
      stuId: json['stu_id'] as String,
      chapter: json['chapter'] as String,
      topic: json['topic'] as String,
      subjects: json['subjects'] as String,
    );

Map<String, dynamic> _$ChallengeDetailToJson(ChallengeDetail instance) =>
    <String, dynamic>{
      'crt_chl_id': instance.crtChlId,
      'stu_id': instance.stuId,
      'chapter': instance.chapter,
      'topic': instance.topic,
      'subjects': instance.subjects,
    };
