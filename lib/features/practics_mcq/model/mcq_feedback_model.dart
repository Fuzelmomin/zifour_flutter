import 'package:json_annotation/json_annotation.dart';

part 'mcq_feedback_model.g.dart';

@JsonSerializable()
class McqFeedbackResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'mcq_list')
  final List<McqFeedbackItem> mcqList;

  McqFeedbackResponse({
    required this.status,
    required this.message,
    required this.mcqList,
  });

  factory McqFeedbackResponse.fromJson(Map<String, dynamic> json) =>
      _$McqFeedbackResponseFromJson(json);

  Map<String, dynamic> toJson() => _$McqFeedbackResponseToJson(this);
}

@JsonSerializable()
class McqFeedbackItem {
  @JsonKey(name: 'mcq_fdb_id')
  final int mcqFdbId;
  @JsonKey(name: 'stu_id')
  final String stuId;
  @JsonKey(name: 'mcq_id')
  final String mcqId;

  McqFeedbackItem({
    required this.mcqFdbId,
    required this.stuId,
    required this.mcqId,
  });

  factory McqFeedbackItem.fromJson(Map<String, dynamic> json) =>
      _$McqFeedbackItemFromJson(json);

  Map<String, dynamic> toJson() => _$McqFeedbackItemToJson(this);
}
