import 'package:json_annotation/json_annotation.dart';

part 'challenge_mcq_list_model.g.dart';

@JsonSerializable()
class ChallengeMcqListResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'mcq_list')
  final List<McqItem> mcqList;

  ChallengeMcqListResponse({
    required this.status,
    required this.message,
    required this.mcqList,
  });

  factory ChallengeMcqListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChallengeMcqListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeMcqListResponseToJson(this);
}

@JsonSerializable()
class McqItem {
  @JsonKey(name: 'mc_id')
  final String mcId;
  @JsonKey(name: 'mc_question')
  final String mcQuestion;
  @JsonKey(name: 'mc_description')
  final String mcDescription;
  @JsonKey(name: 'mc_option1')
  final String mcOption1;
  @JsonKey(name: 'mc_option2')
  final String mcOption2;
  @JsonKey(name: 'mc_option3')
  final String mcOption3;
  @JsonKey(name: 'mc_option4')
  final String mcOption4;
  @JsonKey(name: 'mc_answer')
  final String mcAnswer;
  @JsonKey(name: 'mc_solution')
  final String mcSolution;

  McqItem({
    required this.mcId,
    required this.mcQuestion,
    required this.mcDescription,
    required this.mcOption1,
    required this.mcOption2,
    required this.mcOption3,
    required this.mcOption4,
    required this.mcAnswer,
    required this.mcSolution,
  });

  factory McqItem.fromJson(Map<String, dynamic> json) =>
      _$McqItemFromJson(json);

  Map<String, dynamic> toJson() => _$McqItemToJson(this);

  List<String> get options => [mcOption1, mcOption2, mcOption3, mcOption4];
}

