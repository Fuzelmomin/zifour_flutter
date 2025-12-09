// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeResultResponse _$ChallengeResultResponseFromJson(
        Map<String, dynamic> json) =>
    ChallengeResultResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      subject: json['subject'] as String?,
      total: json['total'] as String?,
      unattended: json['unattended'] as String?,
      attended: json['attended'] as String?,
      correct: json['correct'] as String?,
      wrong: json['wrong'] as String?,
      marks: json['marks'] as String?,
      percentage: json['percentage'] as String?,
    );

Map<String, dynamic> _$ChallengeResultResponseToJson(
        ChallengeResultResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'subject': instance.subject,
      'total': instance.total,
      'unattended': instance.unattended,
      'attended': instance.attended,
      'correct': instance.correct,
      'wrong': instance.wrong,
      'marks': instance.marks,
      'percentage': instance.percentage,
    };
