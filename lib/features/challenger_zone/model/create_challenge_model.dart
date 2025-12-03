import 'package:json_annotation/json_annotation.dart';

part 'create_challenge_model.g.dart';

@JsonSerializable()
class CreateChallengeResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'topic_list')
  final List<CreatedChallengeItem> topicList;

  CreateChallengeResponse({
    required this.status,
    required this.message,
    required this.topicList,
  });

  factory CreateChallengeResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateChallengeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChallengeResponseToJson(this);
}

@JsonSerializable()
class CreatedChallengeItem {
  @JsonKey(name: 'crt_chl_id')
  final String crtChlId;
  @JsonKey(name: 'stu_id')
  final String stuId;
  final String name;
  final String chapter;
  final String topic;
  final String subjects;

  CreatedChallengeItem({
    required this.crtChlId,
    required this.stuId,
    required this.name,
    required this.chapter,
    required this.topic,
    required this.subjects,
  });

  factory CreatedChallengeItem.fromJson(Map<String, dynamic> json) =>
      _$CreatedChallengeItemFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedChallengeItemToJson(this);
}


