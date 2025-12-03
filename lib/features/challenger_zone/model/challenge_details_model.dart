import 'package:json_annotation/json_annotation.dart';

part 'challenge_details_model.g.dart';

@JsonSerializable()
class ChallengeDetailsResponse {
  final bool status;
  final String message;
  final ChallengeDetails challenge;

  ChallengeDetailsResponse({
    required this.status,
    required this.message,
    required this.challenge,
  });

  factory ChallengeDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$ChallengeDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeDetailsResponseToJson(this);
}

@JsonSerializable()
class ChallengeDetails {
  @JsonKey(name: 'crt_chl_id')
  final String crtChlId;
  @JsonKey(name: 'stu_id')
  final String stuId;
  @JsonKey(name: 'challenge_name')
  final String challengeName;
  @JsonKey(name: 'crt_chl_sr')
  final String crtChlSr;
  @JsonKey(name: 'crt_chl_status')
  final String crtChlStatus;
  @JsonKey(name: 'crt_chl_added')
  final String crtChlAdded;
  @JsonKey(name: 'crt_chl_updated')
  final String crtChlUpdated;
  @JsonKey(name: 'total_mcq')
  final int totalMcq;
  final List<NamedItem> chapters;
  final List<NamedItem> topics;
  final List<NamedItem> subjects;

  ChallengeDetails({
    required this.crtChlId,
    required this.stuId,
    required this.challengeName,
    required this.crtChlSr,
    required this.crtChlStatus,
    required this.crtChlAdded,
    required this.crtChlUpdated,
    required this.totalMcq,
    required this.chapters,
    required this.topics,
    required this.subjects,
  });

  factory ChallengeDetails.fromJson(Map<String, dynamic> json) =>
      _$ChallengeDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeDetailsToJson(this);
}

@JsonSerializable()
class NamedItem {
  final String id;
  final String name;

  NamedItem({
    required this.id,
    required this.name,
  });

  factory NamedItem.fromJson(Map<String, dynamic> json) =>
      _$NamedItemFromJson(json);

  Map<String, dynamic> toJson() => _$NamedItemToJson(this);
}


