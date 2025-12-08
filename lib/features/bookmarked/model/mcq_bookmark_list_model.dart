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

  McqBookmarkListItem({
    required this.mcqBkmId,
    required this.mcqId,
    required this.mcQuestion,
    required this.mcDescription,
  });

  factory McqBookmarkListItem.fromJson(Map<String, dynamic> json) =>
      _$McqBookmarkListItemFromJson(json);

  Map<String, dynamic> toJson() => _$McqBookmarkListItemToJson(this);
}

