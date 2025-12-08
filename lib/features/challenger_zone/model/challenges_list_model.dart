import 'package:json_annotation/json_annotation.dart';

part 'challenges_list_model.g.dart';

@JsonSerializable()
class ChallengesListResponse {
  final bool status;
  final String message;
  final int total;
  final List<ChallengeListItem> data;

  ChallengesListResponse({
    required this.status,
    required this.message,
    required this.total,
    required this.data,
  });

  factory ChallengesListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChallengesListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengesListResponseToJson(this);
}

@JsonSerializable()
class ChallengeListItem {
  @JsonKey(name: 'crt_chl_id')
  final String crtChlId;
  @JsonKey(name: 'stu_id')
  final String stuId;
  @JsonKey(name: 'challenge_name')
  final String challengeName;
  final String chapters;
  final String topics;
  final String subjects;
  @JsonKey(name: 'er_flag')
  final String erFlag;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  ChallengeListItem({
    required this.crtChlId,
    required this.stuId,
    required this.challengeName,
    required this.chapters,
    required this.topics,
    required this.subjects,
    required this.erFlag,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChallengeListItem.fromJson(Map<String, dynamic> json) =>
      _$ChallengeListItemFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeListItemToJson(this);
}

