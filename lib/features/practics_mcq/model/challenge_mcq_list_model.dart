import 'package:json_annotation/json_annotation.dart';

part 'challenge_mcq_list_model.g.dart';


@JsonSerializable()
class ChallengeMcqListResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'mcq_list')
  final List<McqItem> mcqList;

  @JsonKey(name: 'chp_name')
  final String? chpName;
  @JsonKey(name: 'tpc_name')
  final String? tpcName;
  final String? standard;
  final String? medium;
  final String? subject;

  ChallengeMcqListResponse({
    required this.status,
    required this.message,
    required this.mcqList,
    this.chpName,
    this.tpcName,
    this.standard,
    this.medium,
    this.subject,
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
  final String? mcSolution;
  @JsonKey(name: 'text_solution')
  final String? textSolution;
  @JsonKey(name: 'video_solution')
  final String? videoSolution;

  @JsonKey(name: 'mcq_variant')
  final String? mcqVariant;

  McqItem({
    required this.mcId,
    required this.mcQuestion,
    required this.mcDescription,
    required this.mcOption1,
    required this.mcOption2,
    required this.mcOption3,
    required this.mcOption4,
    required this.mcAnswer,
    this.mcSolution,
    this.textSolution,
    this.videoSolution,
    this.mcqVariant,
  });

  factory McqItem.fromJson(Map<String, dynamic> json) =>
      _$McqItemFromJson(json);

  Map<String, dynamic> toJson() => _$McqItemToJson(this);

  List<String> get options => [mcOption1, mcOption2, mcOption3, mcOption4];
}

