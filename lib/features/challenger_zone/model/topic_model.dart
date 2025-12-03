import 'package:json_annotation/json_annotation.dart';

part 'topic_model.g.dart';

@JsonSerializable()
class TopicResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'topic_list')
  final List<TopicModel> topicList;

  TopicResponse({
    required this.status,
    required this.message,
    required this.topicList,
  });

  factory TopicResponse.fromJson(Map<String, dynamic> json) =>
      _$TopicResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TopicResponseToJson(this);
}

@JsonSerializable()
class TopicModel {
  @JsonKey(name: 'tpc_id')
  final String tpcId;
  final String name;
  final String chapter;

  TopicModel({
    required this.tpcId,
    required this.name,
    required this.chapter,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) =>
      _$TopicModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopicModelToJson(this);
}


