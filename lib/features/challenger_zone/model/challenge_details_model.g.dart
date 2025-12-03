// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallengeDetailsResponse _$ChallengeDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    ChallengeDetailsResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      challenge:
          ChallengeDetails.fromJson(json['challenge'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChallengeDetailsResponseToJson(
        ChallengeDetailsResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'challenge': instance.challenge,
    };

ChallengeDetails _$ChallengeDetailsFromJson(Map<String, dynamic> json) =>
    ChallengeDetails(
      crtChlId: json['crt_chl_id'] as String,
      stuId: json['stu_id'] as String,
      challengeName: json['challenge_name'] as String,
      crtChlSr: json['crt_chl_sr'] as String,
      crtChlStatus: json['crt_chl_status'] as String,
      crtChlAdded: json['crt_chl_added'] as String,
      crtChlUpdated: json['crt_chl_updated'] as String,
      totalMcq: json['total_mcq'] as int,
      chapters: (json['chapters'] as List<dynamic>)
          .map((e) => NamedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      topics: (json['topics'] as List<dynamic>)
          .map((e) => NamedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subjects: (json['subjects'] as List<dynamic>)
          .map((e) => NamedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChallengeDetailsToJson(ChallengeDetails instance) =>
    <String, dynamic>{
      'crt_chl_id': instance.crtChlId,
      'stu_id': instance.stuId,
      'challenge_name': instance.challengeName,
      'crt_chl_sr': instance.crtChlSr,
      'crt_chl_status': instance.crtChlStatus,
      'crt_chl_added': instance.crtChlAdded,
      'crt_chl_updated': instance.crtChlUpdated,
      'total_mcq': instance.totalMcq,
      'chapters': instance.chapters,
      'topics': instance.topics,
      'subjects': instance.subjects,
    };

NamedItem _$NamedItemFromJson(Map<String, dynamic> json) => NamedItem(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$NamedItemToJson(NamedItem instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };


