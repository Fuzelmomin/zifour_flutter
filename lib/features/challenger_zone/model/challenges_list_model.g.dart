// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenges_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengesListResponse _$ChallengesListResponseFromJson(
        Map<String, dynamic> json) =>
    ChallengesListResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      total: json['total'] as int,
      data: (json['data'] as List<dynamic>)
          .map((e) => ChallengeListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChallengesListResponseToJson(
        ChallengesListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'total': instance.total,
      'data': instance.data,
    };

ChallengeListItem _$ChallengeListItemFromJson(Map<String, dynamic> json) =>
    ChallengeListItem(
      crtChlId: json['crt_chl_id'] as String,
      stuId: json['stu_id'] as String,
      challengeName: json['challenge_name'] as String,
      chapters: json['chapters'] as String,
      topics: json['topics'] as String,
      subjects: json['subjects'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ChallengeListItemToJson(ChallengeListItem instance) =>
    <String, dynamic>{
      'crt_chl_id': instance.crtChlId,
      'stu_id': instance.stuId,
      'challenge_name': instance.challengeName,
      'chapters': instance.chapters,
      'topics': instance.topics,
      'subjects': instance.subjects,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

