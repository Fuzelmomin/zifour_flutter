import 'package:json_annotation/json_annotation.dart';

part 'update_challenge_model.g.dart';

@JsonSerializable()
class UpdateChallengeResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'updated_challenge')
  final ChallengeDetail challengeDetail;

  UpdateChallengeResponse({
    required this.status,
    required this.message,
    required this.challengeDetail,
  });

  factory UpdateChallengeResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateChallengeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateChallengeResponseToJson(this);
}

@JsonSerializable()
class ChallengeDetail {
  @JsonKey(name: 'crt_chl_id')
  final String crtChlId;
  @JsonKey(name: 'stu_id')
  final String stuId;
  final String chapter;
  final String topic;
  final String subjects;

  ChallengeDetail({
    required this.crtChlId,
    required this.stuId,
    required this.chapter,
    required this.topic,
    required this.subjects,
  });

  factory ChallengeDetail.fromJson(Map<String, dynamic> json) =>
      _$ChallengeDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeDetailToJson(this);
}

