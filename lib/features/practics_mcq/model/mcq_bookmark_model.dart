import 'package:json_annotation/json_annotation.dart';

part 'mcq_bookmark_model.g.dart';

@JsonSerializable()
class McqBookmarkResponse {
  final bool status;
  final String message;
  @JsonKey(name: 'mcq_list')
  final List<McqBookmarkItem> mcqList;

  McqBookmarkResponse({
    required this.status,
    required this.message,
    required this.mcqList,
  });

  factory McqBookmarkResponse.fromJson(Map<String, dynamic> json) =>
      _$McqBookmarkResponseFromJson(json);

  Map<String, dynamic> toJson() => _$McqBookmarkResponseToJson(this);
}

@JsonSerializable()
class McqBookmarkItem {
  @JsonKey(name: 'mcq_bkm_id')
  final int mcqBkmId;
  @JsonKey(name: 'stu_id')
  final String stuId;
  @JsonKey(name: 'mcq_id')
  final String mcqId;

  McqBookmarkItem({
    required this.mcqBkmId,
    required this.stuId,
    required this.mcqId,
  });

  factory McqBookmarkItem.fromJson(Map<String, dynamic> json) =>
      _$McqBookmarkItemFromJson(json);

  Map<String, dynamic> toJson() => _$McqBookmarkItemToJson(this);
}

