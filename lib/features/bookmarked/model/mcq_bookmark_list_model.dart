import 'package:json_annotation/json_annotation.dart';

part 'mcq_bookmark_list_model.g.dart';

@JsonSerializable()
class McqBookmarkListResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'mcq_bookmark_list')
  final List<McqBookmarkListItem> mcqBookmarkList;

  McqBookmarkListResponse({
    required this.status,
    required this.message,
    required this.mcqBookmarkList,
  });

  factory McqBookmarkListResponse.fromJson(Map<String, dynamic> json) =>
      _$McqBookmarkListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$McqBookmarkListResponseToJson(this);
}

@JsonSerializable()
class McqBookmarkListItem {
  @JsonKey(name: 'mcq_bkm_id')
  final String mcqBkmId;
  @JsonKey(name: 'mcq_id')
  final String mcqId;
  @JsonKey(name: 'mc_question')
  final String mcQuestion;
  @JsonKey(name: 'mc_description')
  final String mcDescription;
  @JsonKey(name: 'mc_option1', defaultValue: '')
  final String mcOption1;
  @JsonKey(name: 'mc_option2', defaultValue: '')
  final String mcOption2;
  @JsonKey(name: 'mc_option3', defaultValue: '')
  final String mcOption3;
  @JsonKey(name: 'mc_option4', defaultValue: '')
  final String mcOption4;
  @JsonKey(name: 'mc_answer', defaultValue: '')
  final String mcAnswer;
  @JsonKey(name: 'mc_solution', defaultValue: '')
  final String mcSolution;
  @JsonKey(name: 'chp_name', defaultValue: '')
  final String chpName;
  @JsonKey(name: 'tpc_name', defaultValue: '')
  final String tpcName;
  final String type;

  McqBookmarkListItem({
    required this.mcqBkmId,
    required this.mcqId,
    required this.mcQuestion,
    required this.mcDescription,
    required this.mcOption1,
    required this.mcOption2,
    required this.mcOption3,
    required this.mcOption4,
    required this.mcAnswer,
    required this.mcSolution,
    required this.chpName,
    required this.tpcName,
    required this.type,
  });

  factory McqBookmarkListItem.fromJson(Map<String, dynamic> json) =>
      _$McqBookmarkListItemFromJson(json);

  Map<String, dynamic> toJson() => _$McqBookmarkListItemToJson(this);

  List<String> get options => [mcOption1, mcOption2, mcOption3, mcOption4];
}

